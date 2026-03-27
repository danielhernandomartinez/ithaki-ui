# Reporte de Auditoría Técnica — Ithaki UI + ithaki_design_system

**Fecha:** 2026-03-27 | **Auditor:** Claude Code (claude-sonnet-4-6) | **Versión analizada:** `main` @ `3d8a097`

---

## Resumen Ejecutivo

| Dimensión | Estado | Severidad |
|---|---|---|
| Arquitectura / Preparación Backend | **Bloqueante** | Crítico |
| State Management (Riverpod) | Bueno con excepciones | Moderado |
| God Screens & Code Smells | Presente pero contenido | Moderado |
| Consistencia con Design System | Parcial — 100+ violaciones | Moderado |
| Calidad de Tests | Excelente en providers, inexistente en UI | Crítico |

El proyecto tiene una **base sólida** en state management y tests de providers. Sin embargo, presenta **dos bloqueantes críticos para producción**: (1) la capa de repositorios es síncrona, lo que hace imposible una integración directa con cualquier backend, y (2) hay cero cobertura de tests de widgets e integración.

---

## 1. Arquitectura y Escalabilidad

### **[CRÍTICO] Los repositorios son síncronos — No están preparados para un backend real**

**El problema más importante del proyecto.** Todos los métodos de `ProfileRepository` devuelven valores síncronos:

```dart
// lib/repositories/profile_repository.dart:4-13
abstract class ProfileRepository {
  ProfileBasics getBasics();          // ❌ debería ser Future<ProfileBasics>
  ProfileAboutMe getAboutMe();        // ❌
  ProfileSkills getSkills();          // ❌
  List<WorkExperience> getWorkExperiences();  // ❌
  List<Education> getEducations();    // ❌
  // ...
}
```

Cuando se integre el backend, **todos los notifiers** que leen estos repositorios en `build()` deberán convertirse de `Notifier<T>` a `AsyncNotifier<T>`, lo que implica una reescritura masiva en cascada:

```dart
// lib/providers/profile_provider.dart:10-12
// ACTUAL — síncrono
class ProfileBasicsNotifier extends Notifier<ProfileBasics> {
  @override
  ProfileBasics build() => ref.read(profileRepositoryProvider).getBasics();
  // ↑ Esto reventará cuando getBasics() sea async
}

// CORRECTO para preparar el backend
abstract class ProfileRepository {
  Future<ProfileBasics> getBasics();
  Future<void> saveBasics(ProfileBasics basics);  // también falta el método de escritura
}

class ProfileBasicsNotifier extends AsyncNotifier<ProfileBasics> {
  @override
  Future<ProfileBasics> build() => ref.read(profileRepositoryProvider).getBasics();
}
```

**Impacto:** Refactorización de 8 providers + 4 repositorios + todos los widgets que los consumen.

---

### **[CRÍTICO] Los filtros de Job Search no llegan al repositorio**

El `jobSearchProvider` gestiona correctamente los filtros activos en su estado, pero `MockJobSearchRepository` devuelve **siempre los mismos 10 jobs sin filtrar**, ignorando completamente ese estado:

```dart
// lib/providers/job_search_provider.dart:74-86
void applyFilters(Map<String, Set<String>> updated) { ... }  // ✅ actualiza estado

// lib/repositories/job_search_repository.dart:9
List<JobListing> get jobs;  // ❌ getter sin parámetros — no recibe los filtros

// El repositorio no tiene:
// Future<List<JobListing>> search({Map<String,Set<String>> filters, int page, String sort});
```

La interfaz del repositorio necesita un método que acepte los filtros, el sorting y la paginación como parámetros para que la futura integración con la API sea directa.

---

### **[CRÍTICO] `savedJobIndices` usa posición en lista, no ID de job**

```dart
// lib/providers/job_search_provider.dart:7,64-72
final Set<int> savedJobIndices;  // ❌ índice de posición, NO ID de trabajo

void toggleSaved(int index) {
  final updated = Set<int>.from(state.savedJobIndices);
  if (updated.contains(index)) {
    updated.remove(index);
  } else {
    updated.add(index);
  }
}
```

Si la lista cambia de orden (sorting diferente, nueva página, filtros), el índice `3` ya no corresponde al mismo trabajo. Debería usar `String jobId` desde el modelo `JobListing`.

---

### **[Mejora] State Management bien estructurado**

Lo que está bien — digno de destacar como patrón a seguir:

- **17 providers granulares** con responsabilidades únicas (10 solo para profile)
- **`profileCompletionProvider`** (`lib/providers/profile_provider.dart:202-218`) es un provider derivado excelente — usa `.select()` para minimizar reconstrucciones
- **`TourNotifier`** usa `AsyncNotifier` con persistencia real a SharedPreferences — es el único ejemplo correcto de cómo debería funcionar la capa de datos cuando se integre el backend
- **Estado inmutable** con `copyWith()` en todos los modelos

---

## 2. God Screens, Code Smells y Malas Prácticas

### **[Moderado] Pantallas más grandes — candidatas a refactorización**

| Archivo | Líneas | Tipo | Responsabilidades mixtas |
|---|---|---|---|
| `lib/screens/profile/profile_basics_screen.dart` | **~349** | ConsumerStatefulWidget | Formulario, validación, file picker, dirty state, navegación condicional |
| `lib/screens/profile/education_screen.dart` | **~323** | ConsumerWidget | Lista + formulario inline, lógica de add/edit mezclada |
| `lib/screens/profile/work_experience_screen.dart` | **~317** | Mixto | Patrón dual (lista + formulario) en un solo archivo |
| `lib/screens/job_search/location_filter_sheet.dart` | **~309** | ConsumerStatefulWidget | Búsqueda HTTP + debounce + selector de país + lista de ciudades + confirmación |
| `lib/screens/settings/notifications_screen.dart` | **~292** | ConsumerWidget | Múltiples secciones de settings con TextStyle inline |
| `lib/screens/job_search/filters_sheet.dart` | **~225** | ConsumerStatefulWidget | Orquestación de sub-sheets + estado local de filtros |

Ninguno llega a ser un "God Screen" de 1000+ líneas, lo cual es positivo. La refactorización más urgente es `ProfileBasicsScreen`.

---

### **[Moderado] Lógica de negocio embebida en la UI**

**Caso 1: Validación de tamaño de archivo hardcodeada en widget**
```dart
// lib/screens/profile/profile_basics_screen.dart (~línea 95-110)
Future<void> _pickPhoto() async {
  final result = await FilePicker.platform.pickFiles(...);
  if (file.size > 5 * 1024 * 1024) {  // ❌ 5MB hardcodeado en la UI
    ScaffoldMessenger.of(context).showSnackBar(...);
    return;
  }
  setState(() { _photoPath = file.path; });
}
```
Debería ser una constante en una clase `FileValidationConfig` o en el repositorio.

**Caso 2: `_isFormValid` como getter del widget**
```dart
// lib/screens/profile/profile_basics_screen.dart:64-65
bool get _isFormValid =>
    _nameCtrl.text.trim().isNotEmpty && _lastNameCtrl.text.trim().isNotEmpty;
```
Esta validación no es testeable sin levantar el widget completo. Debería estar en el notifier o en un `Validator`.

**Caso 3: `_formatNumber()` en `job_search_screen.dart` (~línea 506)**
Lógica de formateo de números (`1500 → '1.5K'`) dentro del widget. Debería estar en `/utils/`.

---

### **[Moderado] `MediaQuery.of(context)` en `build()` — Reconstrucciones innecesarias**

```dart
// lib/screens/home/home_screen.dart:41 y lib/screens/job_search/job_search_screen.dart:57
final topOffset = MediaQuery.of(context).padding.top + kToolbarHeight + 16;
// ❌ Se reconstruye ante cualquier cambio de MediaQuery (teclado, orientación, etc.)
```

**Corrección:**
```dart
// Escucha solo la propiedad necesaria
final topPadding = MediaQuery.paddingOf(context).top;
final topOffset = topPadding + kToolbarHeight + 16;
```

---

### **[Mejora] `Color` importado dentro de modelos de datos**

```dart
// lib/repositories/job_search_repository.dart:29
JobListing(
  companyColor: Color(0xFF6B4EAA),  // ❌ Flutter Color dentro de un modelo de datos puro
  ...
)
```

Los modelos de datos no deberían depender de `package:flutter`. `companyColor` debería ser un `String` (hex) y la UI lo convierte al renderizar.

---

## 3. Consistencia con `ithaki_design_system`

### **[Crítico] Colores de gradiente fuera del Design System**

`lib/utils/match_colors.dart` define 10+ colores que son tokens de dominio de negocio y deberían vivir en el design system:

```dart
// lib/utils/match_colors.dart
case 'STRONG MATCH':
  return const [Color(0xFF50C948), Color(0xFF75E767)];  // ❌ fuera del DS

// DEBERÍA SER en ithaki_design_system → ithaki_theme.dart:
static const matchStrongStart = Color(0xFF50C948);
static const matchStrongEnd   = Color(0xFF75E767);
```

### **[Moderado] ~100+ violaciones de colores inline**

| Archivo | Violaciones aprox. | Ejemplo |
|---|---|---|
| `lib/screens/job_search/job_search_screen.dart` | 30+ | `Color(0xFFE9DEFF)`, `Color(0xFFF8F8F8)` |
| `lib/screens/home/home_screen.dart` | 20+ | `Color(0xFFDACCF8)`, `Colors.white` |
| `lib/widgets/app_nav_drawer.dart` | 15+ | `Color(0xFFCCFF00)`, `Color(0xFFE0E0E0)` |
| `lib/screens/settings/account_settings_screen.dart` | 8+ | `Color(0xFFE9DEFF)` (mismo hex que job_search) |
| `lib/screens/auth/verify_otp_screen.dart` | 5+ | `Color(0xFFF0EAFA)`, `Colors.white` |

El hecho de que `Color(0xFFE9DEFF)` aparezca en varios archivos sin estar definido como token es una **deuda técnica compuesta** — cuando el color cambie en el design system, habrá que buscar y reemplazar manualmente en N archivos.

### **[Moderado] 235+ instancias de `TextStyle()` inline**

En lugar de tokens tipográficos del design system, las pantallas construyen `TextStyle()` con valores hardcodeados. El design system ya provee `IthakiTheme.headingLarge`, `bodyRegular`, etc., pero se usan inconsistentemente.

```dart
// VIOLACIÓN — fontSize y fontWeight hardcodeados
TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary)

// CORRECTO — usando token del design system
IthakiTheme.labelMedium
```

### **[Moderado] Sin escala de spacing**

`EdgeInsets.symmetric(horizontal: 16)` aparece 20+ veces. No existe `IthakiSpacing` en el design system.

**Propuesta:**
```dart
// En ithaki_design_system
abstract class IthakiSpacing {
  static const double xs = 4, sm = 8, md = 12, lg = 16, xl = 24, xxl = 32;
}
```

### **[Mejora] Widgets del Design System — correctamente agnósticos**

Los 39 widgets del design system son puramente presentacionales con callbacks (`onPressed`, `onChanged`) y sin lógica de negocio. Esto está bien y es el patrón a mantener.

---

## 4. Calidad de los Tests


### **[CRÍTICO] 0 Integration Tests — Flujos de usuario críticos sin verificar**

Flujos no testeados:
- Registro → Verificación OTP → Onboarding → Home
- Búsqueda con filtros → Guardar job → Ver tab "Saved"
- Editar perfil → Guardar → Verificar datos actualizados

```

### **[Mejora] Tests existentes — Excelente calidad**

Lo que SÍ está testeado merece reconocimiento explícito:

| Archivo | Tests | Destacado |
|---|---|---|
| `test/providers/provider_test.dart` | 72 | `ProviderContainer.test()`, overrides de notifiers, `closeTo()` para floats |
| `test/providers/setup_provider_test.dart` | 37 | Tests de preservación de campos no modificados (orthogonality) |
| `test/providers/tour_provider_test.dart` | 24 | AsyncNotifier + verificación de persistencia en SharedPreferences real |
| `test/providers/settings_provider_test.dart` | 12 | Canales independientes, edge cases de input inválido |
| `test/utils/validators_test.dart` | 21 | Parametric testing sobre todos los caracteres especiales válidos |
| `test/utils/match_colors_test.dart` | 21 | Todos los labels de match + fallback behavior |
| `test/utils/language_utils_test.dart` | 14 | Variantes regionales + fallback |

**Total: 303 unit tests** con patrón `ProviderContainer.test()` correcto para Riverpod 3.x.

---

## 5. Resumen de Hallazgos por Severidad

### 🔴 Crítico

| # | Hallazgo | Archivo(s) afectado(s) | Esfuerzo |
|---|---|---|---|
| C-2 | Filtros de Job Search no llegan al repositorio | `lib/repositories/job_search_repository.dart`, `lib/providers/job_search_provider.dart` | Medio |
| C-5 | 0 integration tests — flujos de usuario críticos sin verificar | `test/` | Alto |

### 🟡 Moderado

| # | Hallazgo | Archivo(s) afectado(s) | Esfuerzo |
|---|---|---|---|
| M-1 | Validación del formulario y lógica de file picker embebidas en la UI | `lib/screens/profile/profile_basics_screen.dart:64` | Bajo |
| M-2 | `_formatNumber()` como método de widget en lugar de utilidad | `lib/screens/job_search/job_search_screen.dart` | Muy bajo |
| M-3 | `MediaQuery.of(context)` en `build()` — reconstrucciones innecesarias | `lib/screens/home/home_screen.dart:41`, `lib/screens/job_search/job_search_screen.dart:57` | Muy bajo |
| M-4 | 100+ colores `Color(0x...)` hardcodeados fuera del design system | Todos los screens | Medio |
| M-5 | 235+ `TextStyle()` inline — tokens tipográficos del DS no usados | Todos los screens | Medio |
| M-6 | Sin escala de spacing (`IthakiSpacing`) en el design system | `ithaki_design_system` | Bajo |
| M-7 | `Color` de Flutter importado dentro de modelos de datos puros | `lib/repositories/job_search_repository.dart:29` | Bajo |
| M-8 | Colores de gradiente de `matchLabel` fuera del design system | `lib/utils/match_colors.dart` | Bajo |

### 🟢 Mejora / Nice-to-have

| # | Hallazgo |
|---|---|
| N-1 | `ProfileRepository` no tiene métodos de escritura (`saveBasics`, `saveExperience`, etc.) — prepararlos ahora para cuando exista el backend |
| N-2 | `HomeRepository` también carece de abstracción async — misma situación que profile |
| N-3 | Falta estrategia de caché para `CitySearchRepository` (misma query → misma llamada HTTP) |
| N-4 | El `http.Client` en `citySearchRepositoryProvider` se crea directamente; usar `.family` para poder sobreescribirlo en tests |
| N-5 | Añadir `const` a constructores de widgets sin estado dinámico |
| N-6 | No hay manejo de excepciones si `json.decode()` falla en `NominatimCitySearch` |

---

## 6. Plan de Acción Recomendado

### Fase 2 — Cobertura de tests
7. Widget tests para auth — `VerifyOtpScreen`
8. Widget tests para profile — `ProfileBasicsScreen` (dirty state, botón Save habilita/deshabilita)
9. 1 integration test de flujo completo — registro → home

### Fase 3 — Limpieza y design system
11. Crear `IthakiSpacing` en el design system
12. Migrar colores hardcodeados — empezar por `job_search_screen.dart` (30+ instancias)
13. Mover `_formatNumber()` y validación de 5MB a `utils/`

---

*El codebase está en un estado saludable para un producto en fase pre-backend. La arquitectura de Riverpod es correcta y la calidad de los unit tests de providers es ejemplar. El camino crítico hacia producción pasa por: (1) hacer los repositorios async, (2) añadir cobertura de widget tests, (3) limpiar las violaciones del design system.*
