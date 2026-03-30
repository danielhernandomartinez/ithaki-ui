# Reporte de Auditoría Técnica — Ithaki UI

**Fecha:** 2026-03-30 | **Auditor:** Claude Code (claude-sonnet-4-6) | **Rama:** `main` @ `d65677a`

---

## Nota Global del Proyecto

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   NOTA GENERAL DEL PROYECTO:   7.8 / 10  →  B+     │
│                                                     │
│   Arquitectura / Backend-ready    ★★★★☆  8.5/10   │
│   State Management (Riverpod)     ★★★★★  9.0/10   │
│   Calidad de Código / Smells      ★★★☆☆  7.0/10   │
│   Cobertura y Calidad de Tests    ★★★☆☆  6.5/10   │
│   Consistencia con Design System  ★★★★☆  8.0/10   │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Veredicto:** El proyecto está en un estado **saludable para una fase pre-backend**. La arquitectura de Riverpod es idiomática y correcta, y el patrón Repository está bien establecido en 4 de 5 dominios. Los tests de providers son de una calidad notable. Los principales puntos de deuda son: la ausencia de un `AuthRepository`, la duplicación literal del panel de navegación en cada pantalla, y una cobertura de tests de widgets prácticamente inexistente (2/58 pantallas).

---

## Resumen Ejecutivo

| Dimensión | Estado | Severidad máxima |
|---|---|---|
| Arquitectura / Preparación Backend | Sólida con una brecha crítica | 🔴 Crítico |
| State Management (Riverpod) | Excelente | — |
| God Screens & Code Smells | Presente pero contenido | 🟡 Moderado |
| Calidad de Tests | Excelente en providers, inexistente en UI | 🟡 Moderado |

---

## 1. Arquitectura y Escalabilidad

### ✅ Lo que está bien

**Patrón Repository con interfaces abstractas: implementado correctamente en 4 dominios.**

`HomeRepository`, `ProfileRepository`, `JobSearchRepository` y `CitySearchRepository` exponen todos sus métodos como `Future<T>` desde la interface. Los providers registran el mock con el tipo abstracto, por lo que cambiar la implementación al backend real es literalmente una línea:

```dart
// lib/repositories/profile_repository.dart — contrato listo
abstract class ProfileRepository {
  Future<ProfileBasics> getBasics();
  Future<void> saveBasics(ProfileBasics basics);
  // ...9 métodos más, todos async
}

// lib/repositories/profile_repository.dart:101
final profileRepositoryProvider = Provider<ProfileRepository>(
  (_) => MockProfileRepository(), // ← swap a RealProfileRepository aquí
);
```

**Riverpod con `AsyncNotifier`: bien aplicado.** El patrón `ref.read(repo).save(); state = AsyncData(updated)` es idiomático. Los providers usan `ref.watch` para lecturas y `ref.read` para escrituras. El provider derivado `profileCompletionProvider` minimiza reconstrucciones. `TourNotifier` con persistencia a `SharedPreferences` es el ejemplo más maduro del proyecto.

**Rutas centralizadas.** La clase `Routes` elimina todas las cadenas mágicas de navegación. Los extras tipados `WorkExperienceEditExtra` y `EducationEditExtra` son un buen patrón para pasar datos complejos entre rutas.

---

### 🟡 [Moderado] — `MockJobSearchRepository.search()` ignora todos sus parámetros

**Archivo:** [`lib/repositories/job_search_repository.dart:183`](lib/repositories/job_search_repository.dart#L183)

```dart
@override
Future<JobSearchResult> search({
  Map<String, Set<String>> filters = const {},
  String sort = 'Date: Recent',
  int page = 1,
}) async {
  return const JobSearchResult(
    jobs: _allJobs,       // ← siempre los mismos 10, sin filtrar
    totalJobs: 1500,      // ← dato inventado, no derivado de la lista
    totalPages: 25,
  );
}
```

Toda la lógica de `applyFilters`, `resetFilters`, `setSort` en el notifier actualiza estado y no produce ningún efecto visual. El contrato del método (qué devuelve dado ciertos filtros) nunca fue validado, lo que puede generar desacuerdos con el API real.

---

### 🟡 [Moderado] — Dos clases `JobInterest` con estructuras incompatibles

**Archivos:** [`lib/providers/setup_provider.dart:79`](lib/providers/setup_provider.dart#L79) y [`lib/models/profile_models.dart:124`](lib/models/profile_models.dart#L124)

```dart
// setup_provider.dart — flujo de onboarding
class JobInterest { final String id; final String label; final String subtitle; }

// profile_models.dart — perfil guardado
class JobInterest { final String title; final String category; }
```

Cuando el flujo de setup necesite persistir al perfil, habrá que mapear manualmente entre ambas. Esta inconsistencia también genera confusión al importar (requiere atención al contexto del archivo).

---

### 🟡 [Moderado] — `profileCompletionProvider` retorna 0.0 silenciosamente durante la carga

**Archivo:** [`lib/providers/profile_provider.dart:243`](lib/providers/profile_provider.dart#L243)

```dart
final profileCompletionProvider = Provider<double>((ref) {
  final photoUrl = ref.watch(profileBasicsProvider).value?.photoUrl; // null durante loading
  final bio = ref.watch(profileAboutMeProvider).value?.bio ?? '';
  // ...
  return filled / 6; // retorna 0.0 mientras cargan los async providers
});
```

El `HomeProfileCompletionCard` y el indicador del drawer mostrarán 0% con un flash visual al inicializar. Sería más correcto usar `AsyncValue<double>` o retornar `null` para renderizar un shimmer.

---

## 2. Malas Prácticas, Code Smells y "God Screens"

### 🔴 [Crítico] — Panel de navegación duplicado verbatim en 3 pantallas

**Archivos:**
- [`lib/screens/home/home_screen.dart`](lib/screens/home/home_screen.dart) (208 líneas)
- [`lib/screens/profile/profile_screen.dart`](lib/screens/profile/profile_screen.dart) (202 líneas)
- [`lib/screens/job_search/job_search_screen.dart`](lib/screens/job_search/job_search_screen.dart) (176 líneas)

Las tres pantallas son estructuralmente idénticas. Este bloque se copia literalmente en todas:

```dart
// ~60 líneas IDÉNTICAS en cada pantalla:
if (_panels.menuOpen || _panels.menuCtrl.status != AnimationStatus.dismissed)
  Positioned(
    top: topOffset - 14, left: 16, right: 16, bottom: 40,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SlideTransition(
        position: _panels.slideAnim,
        child: AppNavDrawer(...),
      ),
    ),
  ),
if (_panels.profileOpen || _panels.profileCtrl.status != AnimationStatus.dismissed)
  Positioned(
    // ... ídem para ProfileMenuPanel
  ),
```

Un bug o cambio de diseño en el panel debe aplicarse en 3 lugares. La solución es un `PanelScaffold` widget que reciba `body`, `currentRoute` y los callbacks necesarios, eliminando ~120 líneas duplicadas.

---

### 🟡 [Moderado] — `ProfileBasicsScreen` acumula demasiadas responsabilidades (350 líneas)

**Archivo:** [`lib/screens/profile/profile_basics_screen.dart`](lib/screens/profile/profile_basics_screen.dart)

La pantalla gestiona simultáneamente: 5 `TextEditingController`, `FilePicker`, `showDatePicker`, selector de país, selector de opciones, estado `_isDirty`, y construye la UI del modal "Leave Editing?" de forma inline:

```dart
// lines 168-211 — modal completo embebido en el State
void _showLeaveSheet() {
  showModalBottomSheet(
    builder: (_) => BottomSheetBase(
      child: Column(children: [
        const Text('All entered information will be lost...'),
        OutlinedButton(...),
        IthakiButton('Save and Leave', ...),
      ]),
    ),
  );
}
```

No es un caso extremo, pero el patrón de construir UIs modales inline en el `State` debería estandarizarse extrayendo los modales a widgets propios.

---

### 🟡 [Moderado] — Colores fuera del sistema de diseño en 8+ archivos

`IthakiTheme` define tokens semánticos pero varios archivos usan `Colors.grey.shade*` directamente, que además **no puede ser `const`** (son getters que crean instancias en tiempo de ejecución):

| Archivo | Instancias | Ejemplo |
|---|---|---|
| [`profile_screen.dart:120`](lib/screens/profile/profile_screen.dart#L120) | 2 | `BorderSide(color: Colors.grey.shade300)` — no-const |
| [`profile_job_preferences_tab.dart:63`](lib/screens/profile/tabs/profile_job_preferences_tab.dart#L63) | 1 | `BorderSide(color: Colors.grey.shade300)` — no-const |
| [`upload_file_tab.dart`](lib/widgets/upload_file_tab.dart) | 4 | `.shade300`, `.shade200`, `.shade100` |
| [`profile_values_tab.dart`](lib/screens/profile/tabs/profile_values_tab.dart) | 2 | `Colors.grey.shade200` |

Estos deberían ser tokens en `IthakiTheme` (e.g. `IthakiTheme.borderLight` ya existe, pero no se usa consistentemente).

---

### 🟡 [Moderado] — Ruta duplicada y dead import en `router.dart`

**Archivo:** [`lib/router.dart`](lib/router.dart)

**Problema 1 — Dos rutas para la misma pantalla:**
```dart
GoRoute(path: Routes.root,  builder: (_, __) => const HomeScreen()), // '/'
GoRoute(path: Routes.home,  builder: (_, __) => const HomeScreen()), // '/home'
```
`_HomeScreenState` tiene `String _selectedRoute = '/home'` pero `initialLocation` es `Routes.root = '/'`. El estado del drawer puede desincronizarse.

**Problema 2 — Import sin ruta:**
```dart
import 'screens/auth/select_language_screen.dart'; // importado pero sin GoRoute ni Routes.selectLanguage
```

---

### 🟢 [Mejora] — Validación de email duplicada e incompleta

**Archivos:** [`lib/screens/auth/register_screen.dart:47`](lib/screens/auth/register_screen.dart#L47), `login_email_screen.dart`

```dart
bool get _emailValid =>
    email.contains('@') && email.contains('.');  // duplicado en ambas pantallas
```

La validación de contraseña vive en `validators.dart` con una clase `PasswordValidation`. La de email debería seguir el mismo patrón: `EmailValidation.isValid(email)` centralizado.

---

### 🟢 [Mejora] — `_selectedRoute` es estado redundante en `HomeScreen`

**Archivo:** [`lib/screens/home/home_screen.dart:31`](lib/screens/home/home_screen.dart#L31)

GoRouter ya mantiene la ruta activa. Este `setState` local puede desincronizarse ante navegación por deep link. `ProfileScreen` y `JobSearchScreen` pasan la ruta como constante hardcodeada, lo que es más robusto.

---

## 3. Calidad de los Tests

### Fortalezas destacadas

Los tests existentes son de **calidad ejemplar** para lo que cubren. El patrón `ProviderContainer.test()` con override de notifiers es idiomático para Riverpod 3.x. Destacan especialmente:

| Archivo | Tests | Qué prueba bien |
|---|---|---|
| [`test/providers/settings_provider_test.dart`](test/providers/settings_provider_test.dart) | 12 | Estado inicial, toggles, ortogonalidad, aislamiento de contenedores |
| [`test/providers/provider_test.dart`](test/providers/provider_test.dart) | ~72 | `profileCompletionProvider` con overrides declarativos, `closeTo()` para floats |
| [`test/screens/auth/login_email_screen_test.dart`](test/screens/auth/login_email_screen_test.dart) | ~18 | Layout, estado del botón Sign In, checkbox, navegación |
| [`test/screens/auth/register_screen_test.dart`](test/screens/auth/register_screen_test.dart) | ~20 | Todas las condiciones del botón Continue, filas de validación, mismatch error |

---

### 🟡 [Moderado] — Tests de widget usan selectores posicionales frágiles

**Archivos:** [`test/screens/auth/login_email_screen_test.dart:58`](test/screens/auth/login_email_screen_test.dart#L58), [`register_screen_test.dart:62`](test/screens/auth/register_screen_test.dart#L62)

```dart
// Frágil: se rompe silenciosamente si se añade o reordena un campo
await tester.enterText(find.byType(TextField).at(0), email);
await tester.enterText(find.byType(TextField).at(1), password);
await tester.enterText(find.byType(TextField).at(2), confirmPassword);
```

Si se añade un campo antes del email, el texto entra en el campo equivocado sin que el test falle con un error claro. La solución es añadir `Key('email_field')`, `Key('password_field')` a los widgets y buscar por `find.byKey(...)`.

---

### 🟡 [Moderado] — Cobertura de pantallas: 2 de 58 (~3%)

Solo `LoginEmailScreen` y `RegisterScreen` tienen tests de widget. Las 56 pantallas restantes (perfil completo, settings, setup, tour, home, job search) no tienen ninguna cobertura. El valor mínimo es un "smoke test" que asegure que la pantalla renderiza sin errores con sus providers — algo que habría detectado errores de composición del árbol de widgets.

**Prioridad de cobertura sugerida:**
1. `ProfileBasicsScreen` — formulario más complejo, mayor riesgo de regresión
2. `HomeScreen` — pantalla principal con múltiples providers async
3. Pantallas de setup — flujo de onboarding crítico

---

### 🟡 [Moderado] — `city_search_repository_test.dart` hace llamadas HTTP reales

**Archivo:** [`test/repositories/city_search_repository_test.dart`](test/repositories/city_search_repository_test.dart)

Los tests llaman directamente a `nominatim.openstreetmap.org`. Esto los hace no-deterministas (dependen de red y disponibilidad de Nominatim), lentos, y sujetos a rate-limiting. `NominatimCitySearch` ya recibe `http.Client` por inyección, por lo que mockear con `mocktail` (ya está en dev dependencies) es directo.

---

### 🟢 [Mejora] — La ruta `Notifier.save() → repository` no está cubierta

**Archivo:** [`test/providers/provider_test.dart`](test/providers/provider_test.dart)

Los tests usan Fake Notifiers que precargan estado sin pasar por `MockProfileRepository`. Este es el enfoque correcto para probar `profileCompletionProvider` en aislamiento, pero significa que la cadena `notifier.save() → repo.saveBasics() → state = AsyncData(updated)` nunca es ejercida por ningún test. Un bug en `MockProfileRepository.saveBasics` pasaría desapercibido.

---

## 4. Resumen de Hallazgos

### 🟡 Moderado

| # | Hallazgo | Archivo(s) afectado(s) |
|---|---|---|
| M-1 | `MockJobSearchRepository.search()` ignora todos los parámetros | [`repositories/job_search_repository.dart`](lib/repositories/job_search_repository.dart) |
| M-2 | Dos clases `JobInterest` con estructuras incompatibles | `setup_provider.dart`, `profile_models.dart` |
| M-3 | `profileCompletionProvider` silent 0.0 durante la carga | [`providers/profile_provider.dart:243`](lib/providers/profile_provider.dart#L243) |
| M-4 | `ProfileBasicsScreen` con múltiples responsabilidades (350L) | [`screens/profile/profile_basics_screen.dart`](lib/screens/profile/profile_basics_screen.dart) |
| M-5 | `Colors.grey.shade*` fuera de `IthakiTheme`, no-const | 8+ archivos |
| M-6 | Ruta duplicada `/` y `/home`, dead import en router | [`router.dart`](lib/router.dart) |
| M-7 | Tests de widget con selectores posicionales frágiles | [`test/screens/auth/`](test/screens/auth/) |
| M-8 | `city_search_repository_test` hace HTTP real | [`test/repositories/`](test/repositories/) |
| M-9 | Cobertura de tests de pantalla: 2/58 (3%) | [`test/screens/`](test/screens/) |

### 🟢 Mejora / Nice-to-have

| # | Hallazgo |
|---|---|
| N-1 | Email validation duplicada en register y login — mover a `validators.dart` |
| N-2 | `_selectedRoute` estado redundante en `HomeScreen` |
| N-3 | Tests no cubren la cadena `Notifier.save() → repository` |
| N-4 | `http.Client` de `CitySearchRepository` no inyectable desde tests |
| N-5 | `CitySearchRepository` sin caché — misma query produce llamada HTTP repetida |
| N-6 | `profileCompletionProvider` debería retornar `AsyncValue<double>` o `double?` |

---

## 5. Plan de Acción Recomendado

### Fase 1 — Antes de conectar el backend (bloqueantes)
2. Unificar las dos clases `JobInterest` en un único modelo compartido en `profile_models.dart`
3. Definir el contrato de `JobSearchRepository.search()` con parámetros reales de filtro/sort/paginación

### Fase 2 — Deuda técnica de alta rentabilidad
4. Extraer `PanelScaffold` widget compartido (elimina ~120 líneas duplicadas en 3 pantallas)
5. Añadir tokens de color a `IthakiTheme` para los grises hardcodeados (`borderSubtle`, `surfaceMuted`, etc.)
6. Resolver ruta duplicada `/` vs `/home` y el dead import de `select_language_screen.dart`

### Fase 3 — Tests
7. Reemplazar `find.byType(TextField).at(n)` por `find.byKey(Key('field_name'))`
8. Mockear `http.Client` en `city_search_repository_test` con `mocktail`
9. Añadir smoke tests para las 5 pantallas de mayor riesgo: `ProfileBasicsScreen`, `HomeScreen`, `EditJobPreferencesScreen`, `LocationFilterSheet`, `SetupPreferencesScreen`

---

*Auditoría basada en lectura directa de los 121 archivos Dart en `lib/` y los 11 archivos de test. El codebase está en estado saludable para un producto pre-backend. El camino crítico hacia producción pasa por: (2) extraer `PanelScaffold`, (3) ampliar cobertura de widget tests.*
