# Auditoría Técnica — Ithaki UI + ithaki_design_system

## Resumen Ejecutivo

| Dimensión | Estado | Nota |
|---|---|---|
| Arquitectura / Preparación Backend | Insuficiente | Sin capa de abstracción (repositorios/interfaces) |
| State Management | Bueno | Riverpod bien granularizado, lógica separada en Notifiers |
| God Screens & Code Smells | Crítico | 1 archivo de 1113 líneas, 4 archivos > 350 líneas |
| Consistencia con Design System | Moderado | ~100+ violaciones de tokens hardcodeados |
| Calidad de Tests | Parcial | 303 tests excelentes en providers/utils, 0 widget tests, 0 integration tests |

---

## 1. Arquitectura y Escalabilidad


### **[Moderado] Datos mock acoplados directamente a la UI**

Archivos como `lib/data/mock_home_data.dart` y `lib/data/mock_job_search_data.dart` son constantes estáticas importadas directamente desde las pantallas. No pasan por la capa de providers.

```dart
// ACTUAL — home_screen.dart importa datos directamente
import '../../data/mock_home_data.dart';
// ... en el build:
MockHomeData.jobs  // acoplamiento directo
```

**Propuesta:** Envolver datos mock en providers para que la UI nunca conozca el origen:

```dart
// Crear un provider que encapsule la fuente de datos
final homeDataProvider = FutureProvider<HomeData>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  return repo.getHomeData();
});
```

### **[Mejora] State Management — Bien estructurado**

Los providers en `lib/providers/` están bien granularizados:
- 10 providers independientes solo para Profile (basics, aboutMe, skills, workExperience, etc.)
- `profileCompletionProvider` es un provider derivado/computed que vigila todos los demás — buen patrón
- Modelos inmutables con `copyWith()` — patrón funcional correcto
- `TourNotifier` usa `AsyncNotifier` con persistencia a SharedPreferences — buen ejemplo a seguir

---

## 2. God Screens, Code Smells y Malas Prácticas


### **[Moderado] Rendimiento: `MediaQuery.of(context)` en build()**

Ambas pantallas principales llaman a `MediaQuery.of(context)` directamente en `build()`, causando reconstrucciones en cada cambio de teclado/orientación:

```dart
// home_screen.dart:41 y job_search_screen.dart:57
final topOffset = MediaQuery.of(context).padding.top + kToolbarHeight + 16;
```

**Propuesta:**
```dart
// Usar MediaQuery.paddingOf(context) para escuchar solo lo necesario
final topPadding = MediaQuery.paddingOf(context).top;
final topOffset = topPadding + kToolbarHeight + 16;
```

### **[Moderado] `setState` para estado que debería vivir en providers**

En `lib/screens/job_search/job_search_screen.dart:28-40`, el estado de filtros, paginación y jobs guardados vive como `State` local con `setState`:

```dart
int _selectedTab = 0;
int _currentPage = 1;
final Set<int> _savedJobIndices = {};
final Map<String, Set<String>> _filters = { ... };
```

Esto impide compartir estado entre pantallas y no es testeable. Debería migrarse a un `Notifier` de Riverpod.

### **[Mejora] Lógica de negocio en la capa UI**

- `job_search_screen.dart:506-517` — `_formatNumber()` es lógica de presentación dentro de un widget
- `profile_basics_screen.dart:95-114` — validación de tamaño de archivo (5MB) hardcodeada en el widget
- `edit_job_preferences_screen.dart:64-80` — parsing de salary + save + navigation en una sola función

---

## 3. Consistencia con `ithaki_design_system`

### **[Crítico] Colores de gradiente fuera del Design System**

`lib/utils/match_colors.dart` define 10+ colores hardcodeados que deberían ser tokens del design system:

```dart
// ACTUAL — colores que deberían ser tokens
case 'STRONG MATCH':
  return const [Color(0xFF50C948), Color(0xFF75E767)];
case 'GOOD MATCH':
  return const [Color(0xFFA8D84E), Color(0xFFC8E86E)];
```

**Propuesta:** Mover estos colores como tokens al design system:
```dart
// En ithaki_design_system → ithaki_theme.dart
static const matchStrongStart = Color(0xFF50C948);
static const matchStrongEnd   = Color(0xFF75E767);
static const matchGoodStart   = Color(0xFFA8D84E);
// etc.
```

### **[Moderado] ~100+ violaciones de colores inline**

Archivos con más violaciones (colores hardcodeados `Color(0x...)` o `Colors.*` en lugar de tokens):

| Archivo | Violaciones aprox. | Ejemplo |
|---|---|---|
| `lib/screens/job_search/job_search_screen.dart` | 30+ | `Color(0xFFE9DEFF)`, `Color(0xFFF8F8F8)` |
| `lib/screens/home/home_screen.dart` | 20+ | `Color(0xFFDACCF8)`, `Colors.white` |
| `lib/widgets/app_nav_drawer.dart` | 15+ | `Color(0xFFCCFF00)`, `Color(0xFFE0E0E0)` |
| `lib/screens/settings/account_settings_screen.dart` | 8+ | `Color(0xFFE9DEFF)` (duplicado de job_search) |
| `lib/screens/auth/verify_otp_screen.dart` | 5+ | `Color(0xFFF0EAFA)`, `Colors.white` |

### **[Moderado] TextStyle inline en lugar de tokens tipográficos**

Más de 100 instancias de `TextStyle()` hardcodeado esparcidas por la app. El design system provee `IthakiTheme.headingLarge`, `bodyRegular`, etc., pero se usan inconsistentemente:

```dart
// VIOLACIÓN FRECUENTE — fontSize y fontWeight hardcodeados
TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary)

// CORRECTO — usando token del design system
IthakiTheme.headingMedium
```

**Propuesta:** Si faltan tokens intermedios en el design system, agregarlos:
```dart
// En ithaki_design_system
static const labelMedium = TextStyle(fontSize: 15, fontWeight: FontWeight.w600);
static const bodySmall = TextStyle(fontSize: 13, fontWeight: FontWeight.w400);
```

### **[Moderado] EdgeInsets hardcodeados — Sin escala de spacing**

El valor `EdgeInsets.symmetric(horizontal: 16)` aparece 20+ veces en toda la app. No existe una escala de spacing en el design system.

**Propuesta:** Crear tokens de spacing:
```dart
// En ithaki_design_system
abstract class IthakiSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}
```

### **[Mejora] Design System — Widgets agnósticos (sin acoplamiento)**

Los 39 widgets del design system son **correctamente agnósticos** — no contienen lógica de negocio. Son puramente presentacionales con callbacks (`onPressed`, `onChanged`). Esto está bien.

---

## 4. Calidad de los Tests

### **[Crítico] 0 Widget Tests — 48 pantallas sin cobertura de UI**

No existe un solo widget test. Todas las pantallas de auth, profile, home, settings y job search carecen de tests que verifiquen renderizado, interacción con formularios, o navegación.

**Riesgo:** Bugs de UI, errores de validación de formularios, y regresiones en la navegación son completamente invisibles.

**Propuesta — Widget test para login:**
```dart
testWidgets('login shows error on empty email submit', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(home: LoginEmailScreen()),
    ),
  );

  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();

  expect(find.text('Please enter your email'), findsOneWidget);
});
```

### **[Crítico] 0 Integration Tests — Flujos de usuario no verificados**

Flujos completos no testeados:
- Registro → Verificación → Onboarding
- Búsqueda de empleo → Filtros → Guardar
- Edición de perfil → Guardar → Verificar persistencia

### **[Crítico] CitySearchService sin tests**

El único servicio que hace HTTP no tiene ni un solo test. No se verifica:
- Manejo de errores HTTP
- Parsing de JSON malformado
- Lógica de deduplicación
- Filtro por código de país

**Propuesta:**
```dart
test('search deduplicates results by city,country key', () async {
  final mockClient = MockClient((req) async => http.Response(
    jsonEncode([
      {'address': {'city': 'Athens', 'country': 'Greece'}},
      {'address': {'city': 'Athens', 'country': 'Greece'}}, // duplicado
    ]),
    200,
  ));

  final service = CitySearchService(client: mockClient);
  final results = await service.search('Athens');
  expect(results.length, 1);
});
```

(Requiere refactorizar `CitySearchService` para aceptar un `http.Client` inyectable.)

### **[Mejora] Tests existentes — Excelente calidad**

Lo que SÍ está testeado es de alta calidad:

| Área | Tests | Calidad |
|---|---|---|
| Provider tests (profile, registration, derived) | 72 | Excelente — edge cases, aislamiento, orthogonality |
| Tour provider (async + persistence) | 24 | Excelente — verifica estado + SharedPreferences |
| Settings provider | 12 | Buena — canales independientes, input inválido |
| Setup provider | 37 | Excelente — preservación parcial, reemplazo |
| Validators | 21 | Excelente — boundary testing, parametric |
| Match colors | 21 | Excelente — todos los labels + fallback |
| Language utils | 14 | Excelente — variantes regionales + fallback |

Patrones positivos encontrados:
- Uso correcto de `ProviderContainer.test()` con cleanup automático
- Tests de aislamiento entre containers
- `closeTo()` para comparaciones float
- Tests de secuencia de mutaciones preservando campos previos

---

## Resumen de Prioridades

| # | Severidad | Hallazgo | Esfuerzo |
|---|---|---|---|
| 1 | **Crítico** | Crear capa de repositorios abstractos para backend | Alto |
| 2 | **Crítico** | Refactorizar `job_search_screen.dart` (1113 líneas) | Medio |
| 3 | **Crítico** | Agregar widget tests para auth y profile screens | Alto |
| 4 | **Crítico** | Testear `CitySearchService` con HTTP mock | Bajo |
| 5 | **Moderado** | Mover colores/gradientes a tokens del design system | Medio |
| 6 | **Moderado** | Reemplazar ~100 `TextStyle()` inline por tokens | Medio |
| 7 | **Moderado** | Crear escala de spacing en design system | Bajo |
| 8 | **Moderado** | Migrar estado local de filtros a Riverpod provider | Medio |
| 9 | **Moderado** | Usar `MediaQuery.paddingOf()` en lugar de `.of()` | Bajo |
| 10 | **Mejora** | Refactorizar `home_screen.dart` en sub-widgets | Medio |
