# Auditoría Integral del Proyecto — Ithaki UI
**Fecha:** 2026-04-02
**Auditor:** Claude (claude-sonnet-4-6, análisis asistido por IA)
**Rama:** `main` @ `bbe4920`
**Alcance:** Codebase completo (Flutter), arquitectura, estado de producto, negocio y mercado

---

## Resumen Ejecutivo

Ithaki UI es una aplicación Flutter en fase **pre-backend** que construye la interfaz de una plataforma de talento tecnológico de alto nivel. En los 17.328 líneas de código distribuidas en 123 archivos Dart se encuentran 58 pantallas completamente implementadas, un sistema de onboarding de 5 pasos, gestión completa de perfil con 7 secciones, búsqueda de empleo con filtros, y un tour interactivo de producto de 13 pasos.

La arquitectura es su mayor fortaleza: el patrón `Riverpod + Repository` con interfaces abstractas está correctamente aplicado, lo que hace que el swap a un backend real sea una operación de bajo riesgo. El estado de los providers cubre prácticamente el 100% de los flujos de negocio.

Los tres hallazgos más críticos son:
1. **No existe un `AuthProvider` funcional** — el sistema de autenticación es un stub vacío, bloqueante para cualquier prueba real de usuario.
2. **La cobertura de tests de widget es del 3%** (2 de 58 pantallas) — cualquier regresión de UI pasará desapercibida.
3. **El panel de navegación principal está duplicado verbatim** en las 3 pantallas principales (Home, Profile, JobSearch) — un cambio de diseño requiere editar 3 archivos.

Desde el punto de vista de negocio, el proyecto apunta a un mercado con players establecidos (LinkedIn, Toptal, Upwork) y necesita una propuesta de diferenciación clara. La interfaz sugiere enfoque en talento tech de alta cualificación con un diseño de calidad, lo que es un punto de entrada legítimo pero requiere validación de mercado urgente.

**Calificación global: 7.9 / 10 — Sólido para una fase pre-backend.**

---

## 1. Análisis DAFO

### Matriz Estratégica

|  | **Positivo** | **Negativo** |
|---|---|---|
| **Interno (controlable)** | **FORTALEZAS** | **DEBILIDADES** |
| | Arquitectura Riverpod + Repository lista para backend real — el swap es una línea de código | No existe `AuthProvider` funcional — la autenticación es un stub, bloquea pruebas reales |
| | 58 pantallas completamente implementadas — el producto visual está prácticamente completo | Cobertura de tests de widget al 3% — regresiones de UI invisibles |
| | Tour interactivo de 13 pasos con persistencia — onboarding de alta calidad diferenciador | Panel de navegación duplicado en 3 pantallas (~120 líneas idénticas) |
| | Design system propio (`ithaki_design_system v0.10.16`) — consistencia visual garantizada | `MockJobSearchRepository` ignora filtros/sort/paginación — funcionalidad central no probada |
| | i18n en 3 idiomas (EN/EL/AR) desde el día 1 — preparado para mercado griego y árabe | Dos definiciones incompatibles de `JobInterest` en setup vs perfil |
| | `CitySearchRepository` con HTTP real (Nominatim) — única integración externa funcional | Settings y localización no persisten entre sesiones |
| **Externo (sin control)** | **OPORTUNIDADES** | **AMENAZAS** |
| | Mercado de talento tech con escasez global — la demanda de profesionales cualificados crece | LinkedIn domina el mercado general con efectos de red insuperables |
| | Enfoque en mercado griego y mediterráneo — nicho menos saturado que mercado anglosajón | Toptal, Upwork y Arc.dev cubren el segmento premium tech con años de ventaja |
| | Modalidad de trabajo remoto normalizada — el pool de talento se vuelve global | El talento de alta cualificación es escaso para atraer a la plataforma (problema cold start) |
| | Integración de IA para matching — diferenciador tecnológico todavía accesible | Dependencia de API externa de terceros (`ithaki_design_system` en Git) sin versioning semántico |
| | Regulación europea (AI Act, GDPR) como barrera de entrada para players no europeos | Flutter ecosistema en evolución constante — upgrades de dependencias pueden ser disruptivos |

### Análisis Cruzado

**Fortaleza → Oportunidad:** La internacionalización en griego y árabe desde el inicio, combinada con el menor nivel de competencia en el mercado mediterráneo, es la combinación más poderosa del proyecto. Es el camino de menor resistencia hacia tracción inicial.

**Debilidad → Amenaza:** La ausencia de autenticación real significa que no hay ningún usuario real usando el producto. Cada semana sin usuarios reales es una semana en la que Toptal y Upwork consolidan su posición. La deuda técnica de auth no es solo técnica — es una amenaza de tiempo al mercado.

**Fortaleza → Amenaza:** El tour interactivo y la calidad del onboarding pueden ser el mecanismo de conversión que reduzca el problema de cold start (talento que no se registra en plataformas desconocidas). Es una ventaja diferenciadora usable.

---

## 2. Arquitectura Técnica

### 2.1 Stack y Elecciones Tecnológicas

| Tecnología | Versión | Evaluación |
|---|---|---|
| Flutter | 3.0+ | Correcto para app móvil multiplataforma |
| Riverpod | 3.3.1 | Excelente — patrón `AsyncNotifier` bien aplicado |
| GoRouter | 17.1.0 | Correcto — 31 rutas centralizadas, type-safe extras |
| `shared_preferences` | 2.5.5 | Subutilizado — solo `tourProvider` lo usa |
| `http` | 1.6.0 | Apropiado para MVP — considerar `dio` para backend real |
| `ithaki_design_system` | 0.10.16 (Git) | ⚠️ Dependencia de Git sin versioning semántico — riesgo operativo |
| `mocktail` | 1.0.4 | Correcto para tests |

**Dependencia crítica de riesgo:** `ithaki_design_system` se carga directamente desde Git. Un cambio en la rama del diseño puede romper la build sin ninguna señal de advertencia. Debe migrarse a un package versionado (pub.dev privado o tag de Git).

### 2.2 Patrón de Arquitectura

```
PRESENTACIÓN (Screens + Widgets)
        ↓ ref.watch() / ref.read()
ESTADO (Riverpod Providers — AsyncNotifier / Notifier)
        ↓ Future<T>
REPOSITORIOS (Interfaces abstractas)
        ↓ implementación swappable
DATOS (Mock In-Memory | HTTP | SharedPreferences)
```

La separación de capas es correcta y consistente en todos los dominios. Los providers registran el mock con el tipo abstracto:

```dart
final profileRepositoryProvider = Provider<ProfileRepository>(
  (_) => MockProfileRepository(), // ← swap a RealProfileRepository en una línea
);
```

### 2.3 Dominio por Dominio

| Dominio | Estado | Notas |
|---|---|---|
| **Profile** | ✅ Excelente | 9 AsyncNotifiers, `profileCompletionProvider` derivado |
| **Tour** | ✅ Excelente | Persistencia SharedPreferences, estado modal completo |
| **Home** | ✅ Bueno | Datos hardcodeados, fácil de conectar |
| **Settings** | 🟡 Incompleto | No persiste entre sesiones |
| **JobSearch** | 🟡 Broken por diseño | `search()` ignora filtros/sort/paginación |
| **Auth** | 🔴 Stub | MockAuthRepository vacío, no hay AuthProvider |
| **Setup/Onboarding** | 🟡 Funcional pero desconectado | No persiste al perfil al finalizar |

---

## 3. Escalabilidad

### Escalabilidad Técnica

**Base de datos / Estado:** La app usa mocks in-memory. La arquitectura soporta fácilmente swap a REST API o GraphQL. El modelo de datos (Profile, WorkExperience, Education, JobListing) está bien definido y es normalizable.

**Compute:** Flutter en cliente — no hay preocupaciones de escalabilidad de servidor en esta fase. Cuando se conecte backend, la arquitectura stateless de los repositorios permite balanceo horizontal.

**Búsqueda:** La única llamada HTTP real va a Nominatim (OpenStreetMap) para búsqueda de ciudades. En producción debe migrarse a un servicio propio o pagar por una API (Google Places, Mapbox) para evitar los términos de uso de Nominatim.

**Caching:** No existe estrategia de caché. `CitySearchRepository` hace una llamada HTTP en cada búsqueda sin debounce. En producción necesita al menos debounce de 300ms + caché en memoria.

### Escalabilidad Organizacional

El codebase de 17.328 líneas en 123 archivos es manejable para un equipo de 2-5 desarrolladores. La estructura de carpetas es predecible y bien nombrada. Sin embargo:

- **Bus factor: 1** — Si el desarrollador actual deja el proyecto, nadie más conoce el sistema del tour, el routing o los modelos.
- **Sin documentación técnica de APIs** — El README es el default de Flutter ("A new Flutter project").
- **Docs técnicos en `docs/superpowers/plans/`** — Existen planes de implementación que documentan decisiones, pero no hay documentación de arquitectura viva.

**Puntuación de escalabilidad: 🟡 Necesita preparación** — La arquitectura soporta 2-3x crecimiento del equipo con cambios menores (documentación, ADRs, CI/CD).

---

## 4. Calidad de Código y Deuda Técnica

### Mapa de Deuda Técnica

**🔴 Deuda Crítica**

| Problema | Archivos | Impacto |
|---|---|---|
| Panel de navegación duplicado (~60 líneas × 3) | `home_screen.dart`, `profile_screen.dart`, `job_search_screen.dart` | Bug fix requiere editar 3 archivos |
| `MockAuthRepository` completamente vacío | `repositories/auth_repository.dart` | Flujo de autenticación es un shell sin funcionalidad |

**🟡 Deuda Moderada**

| Problema | Archivo(s) | Impacto |
|---|---|---|
| `MockJobSearchRepository.search()` ignora parámetros | `repositories/job_search_repository.dart` | Los filtros actualizan estado pero no tienen efecto visual |
| Dos clases `JobInterest` incompatibles | `setup_provider.dart` vs `profile_models.dart` | Conversión manual necesaria al persistir onboarding |
| `profileCompletionProvider` retorna 0.0 silenciosamente | `providers/profile_provider.dart:243` | Flash visual de "0% completado" al inicializar |
| Ruta duplicada `/` y `/home` en router | `router.dart` | Estado del drawer puede desincronizarse |
| `Colors.grey.shade*` hardcodeados fuera de IthakiTheme | 8+ archivos | No-const, inconsistencia con design system |
| `settingsProvider` y `localeProvider` sin persistencia | Providers respectivos | Cambios se pierden al reiniciar la app |

**🟢 Deuda Baja**

| Problema |
|---|
| Validación de email duplicada en register y login (debería ir a `validators.dart`) |
| `_selectedRoute` estado redundante en `HomeScreen` (GoRouter ya tiene esta info) |
| Dead import de `select_language_screen.dart` en `router.dart` |
| `CitySearchRepository` sin caché ni debounce |

### Métricas de Calidad

| Métrica | Valor | Evaluación |
|---|---|---|
| Líneas de código (`lib/`) | 17.328 | Apropiado para el alcance del producto |
| Archivos Dart | 123 | Bien organizado |
| Cobertura providers | ~90% | Excelente |
| Cobertura widgets/screens | ~3% (2/58) | Crítica |
| Cobertura utils | ~85% | Buena |
| Cobertura global estimada | ~30% | Insuficiente para producción |

---

## 5. Seguridad y Compliance

> **Nota de confianza:** La app no tiene backend, por lo que la superficie de ataque es mínima en esta fase. Las siguientes observaciones son mayormente proyecciones hacia producción.

### Estado Actual

| Área | Estado | Severidad |
|---|---|---|
| Autenticación | Stub — sin tokens, sin sesiones | 🔴 Bloquea producción |
| Gestión de secretos | No hay API keys hardcodeadas en el código (solo Nominatim, sin auth) | ✅ |
| Validación de inputs | `PasswordValidation` robusto, email validation incompleta | 🟡 |
| HTTPS | Solo Nominatim con HTTPS | ✅ |
| GDPR | El perfil captura PII (nombre, email, teléfono, foto, fecha nacimiento) | 🟡 Requiere atención |
| Almacenamiento local | Solo `SharedPreferences` para el tour — datos no sensibles | ✅ |

### Para Producción (alta prioridad)

1. **AuthProvider con JWT / refresh tokens** — almacenar en `flutter_secure_storage`, no en `SharedPreferences`.
2. **GDPR compliance** — La app captura PII de ciudadanos europeos (campo de ciudadanía, residencia, foto). Necesita: política de privacidad visible, consentimiento explícito, y opción de borrado de cuenta (el sheet `delete_account_sheet.dart` ya existe en UI pero sin lógica).
3. **Certificate pinning** — Para las llamadas al backend cuando se implemente.
4. **Validación de subida de archivos** — `upload_files_sheet.dart` y `file_picker` capturan archivos sin validación de tipo/tamaño en cliente (solo `exceedsMaxFileSize` parcial).

---

## 6. Equipo y Procesos

### Workflow de Desarrollo

| Aspecto | Observación |
|---|---|
| Control de versiones | Git con commits semánticos (`feat:`, `refactor:`) — buena práctica |
| Ramas | Trabajo directo en `main` — sin feature branches observadas |
| CI/CD | No hay configuración visible (sin `.github/workflows`, `fastlane`, etc.) |
| Code reviews | Indeterminado — repositorio aparenta ser individual o pequeño equipo |
| Linting | `flutter_lints ^6.0.0` + `analysis_options.yaml` configurado |

### Bus Factor y Conocimiento

- **Bus factor estimado: 1-2** — El sistema del tour, el routing con extras tipados, y los modelos de datos son conocimiento concentrado.
- **Documentación de decisiones:** Los archivos en `docs/superpowers/plans/` documentan planes de implementación (design system, tour, async repositories). Es una práctica positiva no común en proyectos de este tamaño.
- **Onboarding de nuevos devs:** El README es el template de Flutter. Un nuevo desarrollador necesitaría 1-2 semanas para entender la arquitectura, no por complejidad sino por falta de documentación de entrada.

**Recomendación:** Añadir un `CONTRIBUTING.md` con decisiones arquitectónicas clave (por qué Riverpod, por qué el patrón Repository, cómo añadir un nuevo dominio).

---

## 7. Negocio y Mercado

### Propuesta de Valor Inferida

Ithaki se posiciona como una **plataforma de talento tecnológico de alta cualificación**, con enfoque aparente en el mercado griego (Ithaki = Ítaca, referencia griega, soporte nativo de `el`) y árabe. La UI sugiere:
- Matching de empleos por porcentaje de afinidad (similar a LinkedIn Premium)
- Perfil rico: CV, portfolio de archivos, valores personales, competencias
- Presencia de empleadores activos (curso, noticias, invitaciones)

### Landscape Competitivo

| Competidor | Fortaleza principal | Vulnerabilidad explotable |
|---|---|---|
| **LinkedIn** | Red global, efectos de red | Generalista — no especializado en tech de calidad |
| **Toptal** | Marca de calidad "top 3%" | Proceso de selección lento, costoso para empresas |
| **Upwork** | Volumen, freelance | No sirve bien a empleo permanente |
| **Arc.dev** | Especializado en tech remoto | Enfocado en mercado anglosajón |
| **Workable / Recruitee** | ATS para empresas | No tiene lado de candidato |

**Hueco potencial:** Plataforma de talento tech especializada con cobertura del mediterráneo (Grecia, Chipre, Medio Oriente), con UX superior y sistema de matching propio. Es un nicho real y defendible.

### Riesgos de Negocio

1. **Problema del huevo y la gallina (cold start):** Sin talento, no hay empresas. Sin empresas, no hay talento. Este es el mayor riesgo de cualquier marketplace.
2. **Monetización no definida:** No hay signos de modelo de negocio en la UI (sin planes de pago, sin anuncios). Es normal en esta fase, pero debe definirse antes de escalar.
3. **Validación de PMF:** No hay evidencia de usuarios reales. El producto visual está completo pero no ha sido probado con el mercado objetivo.

### Oportunidades Inmediatas

1. **Lanzar un MVP funcional con autenticación real** — 5-10 usuarios beta basta para validar el onboarding y el perfil.
2. **Partnerships con bootcamps y universidades griegas/árabes** — canal de adquisición de talento de bajo coste.
3. **Funcionalidad de "make invisible"** (ya existe el sheet en UI) como diferenciador: talento que busca sin que su empresa actual lo sepa.

---

## 8. Innovación y Future-Proofing

### Preparación para IA

La presencia de un campo `matchPercentage` en `JobListing` y `JobRecommendation` indica que el modelo contempla matching algorítmico. La arquitectura de repositorios facilita conectar un servicio de ML externo: el `JobSearchRepository.search()` puede devolver resultados rankeados por IA sin cambios en el cliente.

**Oportunidad inmediata:** Integrar un LLM para generar el "About Me" del candidato basándose en su experiencia laboral y habilidades (el campo `bio` en `ProfileAboutMe` está vacío en el mock). Bajo coste, alto valor percibido.

### Modularidad

El codebase es modular por dominio (auth, profile, job_search, setup, settings). Añadir un nuevo dominio (ej. "Applications" — seguimiento de candidaturas) requiere:
1. Nuevo modelo en `lib/models/`
2. Nuevo repositorio en `lib/repositories/`
3. Nuevo provider en `lib/providers/`
4. Nuevas pantallas en `lib/screens/`
5. Nuevas rutas en `router.dart` y `routes.dart`

El patrón está establecido y es predecible. No hay "magic" que descubrir.

### Visión Técnica

Los documentos en `docs/superpowers/plans/` (design system, async repositories, product tour) evidencian una visión técnica deliberada. Es una señal positiva poco común en proyectos de este tamaño. La trazabilidad de decisiones existe; falta formalizarla en ADRs.

---

## 9. Hoja de Ruta de Mejoras

### Victorias Rápidas (1-2 semanas, bajo esfuerzo, alto impacto)

| # | Acción | Impacto | Esfuerzo |
|---|--------|--------|--------|
| 1 | Extraer `NavPanelScaffold` para `home_screen`, `profile_screen`, `job_search_screen` — elimina ~120 líneas duplicadas | Alto | Bajo |
| 2 | Unificar las dos clases `JobInterest` en un solo modelo en `profile_models.dart` | Alto | Bajo |
| 3 | Implementar `MockJobSearchRepository.search()` que realmente filtre/ordene/paginé la lista de mocks | Alto | Bajo |
| 4 | Persistir `localeProvider` y `settingsProvider` a `SharedPreferences` | Medio | Bajo |
| 5 | Resolver ruta duplicada `/` vs `/home` y eliminar el dead import en `router.dart` | Bajo | Muy bajo |
| 6 | Mover `EmailValidation` a `validators.dart` (igual que `PasswordValidation`) | Bajo | Muy bajo |

### Medio Plazo (1-3 meses)

| # | Acción | Impacto | Esfuerzo | Dependencias |
|---|--------|--------|--------|-------------|
| 1 | Implementar `AuthProvider` real con JWT + `flutter_secure_storage` | Crítico | Medio | Backend de autenticación |
| 2 | Agregar smoke tests para las 10 pantallas de mayor riesgo (ProfileBasics, Home, JobSearch, Setup) | Alto | Medio | — |
| 3 | Conectar un backend real para `ProfileRepository` y `HomeRepository` | Alto | Alto | Decisión de backend (REST/GraphQL/Supabase) |
| 4 | Reemplazar `find.byType(TextField).at(n)` por `find.byKey()` en los 2 tests de widget existentes | Bajo | Muy bajo | — |
| 5 | Migrar `ithaki_design_system` de dependencia de Git a versión semántica (pub.dev privado o Git tag) | Medio | Bajo | Coordinación con equipo de design |
| 6 | Agregar `CONTRIBUTING.md` con decisiones arquitectónicas y guía de onboarding de nuevos devs | Medio | Bajo | — |
| 7 | Definir estrategia de caché + debounce en `CitySearchRepository` | Bajo | Bajo | — |

### Largo Plazo / Estratégico (3-12 meses)

| # | Acción | Impacto | Esfuerzo | Dependencias |
|---|--------|--------|--------|-------------|
| 1 | Implementar matching algorítmico real (ML/LLM) para `matchPercentage` | Muy alto | Alto | Datos de usuarios reales |
| 2 | Establecer CI/CD completo (GitHub Actions: test + build + deploy) | Alto | Medio | — |
| 3 | Alcanzar cobertura de tests al 70%+ (providers + widgets críticos) | Alto | Alto | Fase 1 y 2 completadas |
| 4 | Validar PMF con 50+ usuarios beta y definir modelo de monetización | Crítico para negocio | Medio | MVP funcional con auth |
| 5 | Explorar integración de IA generativa para "About Me" y recomendaciones de habilidades | Alto | Medio | Backend + LLM API |
| 6 | Lanzamiento en App Store / Google Play con certificados, terms of service, política de privacidad GDPR | Alto | Alto | Auth + GDPR compliance |

---

## 10. TL;DR

- **El producto visual está completo** — 58 pantallas, diseño coherente, onboarding funcional. Lo que falta es el backend, no la UI.
- **La arquitectura es la fortaleza principal** — Riverpod + Repository con mocks hace que conectar un backend sea seguro y predecible. No hay que reescribir nada.
- **Tres deudas bloquean el avance:** (1) no hay AuthProvider real, (2) los filtros de búsqueda son un teatro (el mock los ignora), (3) el panel de navegación duplicado es una bomba de tiempo ante cualquier cambio de diseño.
- **El nicho de mercado existe** — talento tech en el mediterráneo es un espacio real y menos saturado que el mercado anglosajón. La i18n en griego y árabe desde el día 1 es una ventaja no trivial.
- **Next step:** Implementar autenticación real (AuthProvider + JWT + flutter_secure_storage) — es la única acción que convierte el proyecto de una maqueta de alta calidad en un producto que puede tener usuarios reales.

---

*Auditoría basada en lectura directa de 123 archivos Dart en `lib/`, 11 archivos de test, documentación en `docs/`, y análisis del historial de commits reciente. El reporte técnico detallado previo está disponible en `AUDIT_REPORT.md` (2026-03-30).*
