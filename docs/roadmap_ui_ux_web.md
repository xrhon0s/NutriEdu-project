# Roadmap UI/UX web de NutriEdu

Fecha de inicio: 8 de septiembre de 2026
Estado: en curso
Avance de la fase UI/UX: 94%

## 1. Objetivo

Consolidar una experiencia web coherente, accesible y responsive antes de retomar el desarrollo mobile. El trabajo debe mejorar los flujos reales del producto y producir patrones que luego puedan trasladarse a React Native.

No se plantea un rediseño decorativo completo. Se preservan la identidad de NutriEdu, los flujos funcionales y la arquitectura React actual.

## 2. Principios

- Priorizar claridad clínica, confianza y velocidad de uso.
- Reservar el verde para identidad, selección y acciones principales; usar neutros para la estructura y colores semánticos para alertas.
- Evitar tarjetas anidadas, radios excesivos, sombras pesadas y grandes espacios vacíos.
- Sustituir emojis funcionales por iconos de `lucide-react` con etiquetas accesibles.
- Mantener controles de al menos 44 px, foco visible, contraste AA y navegación por teclado.
- Diseñar primero para los flujos frecuentes y verificar 390 px, 768 px, 1024 px y 1440 px.
- Mantener el español consistente; la internacionalización completa continúa como línea independiente.
- Cada pantalla debe contemplar carga, vacío, error, éxito y acciones deshabilitadas.

## 3. Diagnóstico inicial

- Los componentes compartidos existen, pero muchas páginas todavía repiten estilos de botones, campos, estados y paginación.
- La navegación principal no tiene una solución completa para pantallas pequeñas.
- Conviven radios grandes (`rounded-3xl`, `rounded-full`) con el estilo más sobrio del panel administrativo.
- Varias vistas usan emojis como iconos y colores no sistematizados, incluidos botones azules dentro de flujos principalmente verdes.
- Recetas, detalle y planificador presentan tarjetas altas y mucho espacio vertical, reduciendo la información visible.
- Las tablas administrativas funcionan, pero necesitan acciones consistentes, filtros más compactos y una estrategia mobile.
- Las transiciones respetan reducción de movimiento, pero faltan skeletons y reintentos uniformes para solicitudes.

## 4. Fases

### Fase 1 - Fundamentos y shell (0-20%)

- [x] Definir tokens CSS para color, tipografía, radios, sombras, espaciado y foco.
- [ ] Completar `IconButton`, `Field` y `Select`; `Button`, `StatusMessage`, `Pagination` y estado vacío ya están consolidados.
- [x] Unificar `AppShell`, ancho de contenido, encabezados y separación vertical.
- [x] Implementar navegación responsive con menú accesible y acción de cierre de sesión inequívoca.
- [x] Corregir footer autenticado para evitar enlaces redundantes o rutas inesperadas.

### Fase 2 - Flujo de recetas (20-45%)

- [x] Compactar filtros y resultados sin perder legibilidad.
- [x] Rediseñar la tarjeta para mostrar afinidad, seguridad, calorías, tiempo y confianza con jerarquía clara.
- Mantener seis recetas seguras iniciales y paginación estable.
- [x] Mejorar recomendaciones con skeleton, reintento y explicación breve del puntaje.
- [x] Reorganizar detalle de receta: resumen, nutrientes, ingredientes, alertas y sustitutos.

### Fase 3 - Perfil y planificación (45-65%)

- [x] Convertir perfil en secciones navegables y reducir formularios visualmente extensos.
- [x] Mostrar contexto disponible, prioridad de objetivos y seguimiento profesional sin lenguaje diagnóstico.
- [x] Hacer el planificador más compacto, escaneable y usable en tablet/mobile.
- [x] Mejorar selección de receta, guardado, cambios sin guardar y confirmaciones.

### Fase 4 - Autenticación y recuperación (65-78%)

- [x] Refinar login, registro, recuperación y cambio de contraseña como una sola familia visual.
- [x] Mantener visibilidad de contraseña, requisitos en tiempo real y mensajes específicos.
- [x] Verificar en código autocompletado, etiquetas, foco, teclado y prevención de doble envío; la aceptación visual multipantalla queda en Fase 6.

### Fase 5 - Lista de compras (72-82%)

- [x] Reemplazar el diseño heredado por shell, tokens y controles compartidos.
- [x] Agrupar ingredientes, agregar cantidades conocidas y mostrar recetas de origen.
- [x] Separar todos/pendientes y guardar checks por usuario y firma del plan.
- [x] Incorporar skeleton, vacío, error, reintento, actualización y reinicio confirmado.

### Fase 6 - Administración (82-94%)

- [x] Crear una navegación lateral estable en escritorio y un selector compacto en mobile para operaciones, usuarios, catálogos, reglas y consumo IA.
- [x] Unificar búsqueda, filtros, tablas, paginación, formularios, modales y acciones sensibles en todos los módulos administrativos.
- [x] Adaptar todas las tablas administrativas a pantallas estrechas mediante tarjetas y columnas prioritarias, no escalado ilegible.
- [x] Hacer visible la cobertura nutricional, la revisión, la cuantificación y la clasificación del catálogo.

### Fase 7 - QA y transferencia a mobile (94-100%)

- Ejecutar lint y build, recorridos autenticados y revisión de consola.
- Verificar teclado, lector de pantalla básico, contraste, reducción de movimiento y zoom al 200%.
- Comparar capturas en los cuatro anchos objetivo y corregir overflow, solapamientos y saltos de layout.
- Documentar tokens, componentes y decisiones reutilizables en React Native.

## 5. Orden de implementación inmediato

1. Tokens, shell y navegación responsive.
2. Componentes de formulario, botones, estados y paginación.
3. Recetas y detalle de receta.
4. Perfil y planificador.
5. Autenticación.
6. Lista de compras.
7. Panel administrativo.
8. QA responsive y accesible.

## 6. Criterios de salida

- Los flujos principales funcionan sin regresiones en desktop y mobile web.
- No hay texto cortado, controles superpuestos ni scroll horizontal accidental.
- Ninguna acción depende solo de color o de un emoji.
- Todas las solicitudes visibles tienen estados de carga, error y reintento apropiados.
- Los patrones compartidos sustituyen duplicación real sin convertir la interfaz en una abstracción difícil de mantener.
- Lint, build y pruebas funcionales relevantes están aprobados.
- La guía técnica y el registro de progreso reflejan cada fase terminada.

## 7. Primera entrega propuesta

La primera entrega cubrirá tokens, `AppShell`, navegación responsive y controles compartidos. Después se aplicará inmediatamente a Recetas, porque es el flujo principal y permitirá validar el sistema antes de extenderlo al resto de la web.

## 8. Registro de implementación

### 2026-09-08 - Fundamentos y primera aplicación en Recetas

- Se agregaron tokens semánticos para canvas, superficies, bordes, texto, marca, foco y sombra.
- `AppShell`, `PageHeader`, `StatusMessage` y `EmptyState` adoptaron el sistema compartido.
- Se crearon `Button` y `Pagination` con estados deshabilitados y nombres accesibles.
- La navegación ahora usa enlaces semánticos, estado activo, menú responsive hasta 1024 px, cierre con Escape y una acción de sesión consistente.
- El footer evita rutas redundantes para usuarios autenticados.
- Recetas usa filtros etiquetados, tarjetas compactas con iconos Lucide, métricas en una sola banda, skeletons, estados vacíos y reintento de recomendaciones.
- Se mantuvieron seis recetas seguras por página y doce resultados al filtrar.
- Lint y build de producción: aprobados. Frontend y backend locales: accesibles.
- Frontend `4e45b4d` publicado en `chore/release-readiness`; GitHub quality y preview de Vercel aprobados.
- La inspección visual automatizada quedó pendiente porque no había navegador conectado; se requiere revisión manual en 390, 768, 1024 y 1440 px.

### 2026-09-08 - Detalle de receta y alternativas

- El detalle usa `AppShell`, encabezado y controles compartidos, sin gradientes ni radios sobredimensionados.
- La descripción se presenta una sola vez y procede de `recetas.descripcion`.
- Se consultan y muestran los ingredientes reales de la receta, identificando visualmente los que coinciden con restricciones.
- Los ocho valores nutricionales se presentan por porción; la ausencia de datos se declara como `Pendiente`.
- Carga, error, reintento y receta inexistente tienen estados explícitos.
- El modal de alternativas es responsive, admite Escape, bloquea el scroll de fondo y no depende de emojis.
- Las alternativas son informativas: no modifican una receta ni eliminan alertas de seguridad al cerrar el modal.
- Las opciones se limitan al mismo `substitution_group`: pollo puede enlazarse con otra ave segura, pero no con tofu, pescado o carbohidratos. Si el catálogo no contiene una alternativa cercana, el modal lo declara sin rellenar opciones arbitrarias.
- Lint sin errores ni advertencias y build Vite: correctos. La revisión visual en los cuatro anchos objetivo continúa pendiente por falta de navegador conectado.
- Frontend `a7a5ad7` publicado; GitHub quality y preview de Vercel aprobados.

### 2026-09-08 - Planificador semanal

- El planificador usa el shell y los controles compartidos y elimina el panel anidado, gradientes y radios sobredimensionados.
- El formulario agrupa receta, día y comida; pulsar un espacio vacío lo configura y desplaza el foco visual hacia esa herramienta.
- El resumen muestra ocupación de los 21 espacios y distingue un plan guardado de cambios locales pendientes.
- La carga tiene skeleton, los errores permiten reintento y el guardado ofrece mensajes específicos.
- Una receta que dejó de ser compatible permanece señalada y bloquea el guardado hasta retirarla, de acuerdo con la validación del backend.
- Las alternativas no se presentan como cambios aplicados porque el esquema actual no guarda sustituciones.
- Lint sin errores ni advertencias y build Vite: correctos. La aceptación visual autenticada continúa pendiente.
- Frontend `16bf1d6` publicado; GitHub quality y preview de Vercel aprobados.

### 2026-09-08 - Perfil de salud

- Las cuatro secciones conservan guardados y endpoints independientes, con pestañas semánticas y nombres accesibles.
- El resumen cuantifica datos personales, objetivos, condiciones/restricciones y metas disponibles sin convertirlo en un diagnóstico.
- Los objetivos seleccionados muestran el orden de prioridad que recibe el backend.
- Condiciones de seguimiento profesional y restricciones activas se distinguen con texto e iconos, no solo color.
- La búsqueda y paginación de restricciones usan controles compartidos; `Pagination` admite ahora un total explícito.
- Los 13 valores nutricionales se agrupan en energía, macronutrientes y límites específicos para reducir carga visual.
- La fecha impide valores futuros según la zona horaria local y los campos numéricos conservan unidades visibles.
- Carga, error, reintento, catálogos vacíos y guardado tienen estados explícitos.
- Lint sin errores ni advertencias y build Vite: correctos. La aceptación visual autenticada continúa pendiente.
- Frontend `201114a` publicado; GitHub quality y preview de Vercel aprobados.

### 2026-09-08 - Autenticación y recuperación

- Login, registro, solicitud de recuperación y restablecimiento usan el mismo shell, tokens semánticos, campos y botones con progreso.
- Registro ahora exige repetir la contraseña; ambas entradas informan coincidencia sin depender solo del color.
- La guía de contraseña está conectada mediante `aria-describedby`, conserva visibilidad opcional y bloquea envíos que incumplen la política.
- Correos se normalizan antes de enviarse. El botón deshabilitado y `aria-busy` previenen dobles envíos mientras existe una solicitud.
- Login separa autenticación de la consulta posterior de restricciones: si esa segunda consulta falla, conserva la sesión y dirige al perfil en lugar de mostrar un falso error de credenciales.
- Un enlace de restablecimiento sin token muestra una salida específica para solicitar otro enlace y no presenta un formulario inutilizable.
- Lint sin errores ni advertencias y build Vite: correctos. La conexión de navegador no estuvo disponible, por lo que capturas, consola y recorrido interactivo permanecen en Fase 6.
- Frontend `e83f07f` publicado; GitHub quality y preview de Vercel aprobados.
- Fase UI/UX web: **72%**. Expansión completa del producto: **91%**.

### 2026-09-08 - Lista de compras accionable

- El endpoint detallado agrega cantidades por gramos o unidad a través de todas las apariciones del ingrediente en el plan y conserva las recetas de origen.
- Mobile mantiene el arreglo histórico; web activa el contrato nuevo con `?detailed=true`.
- Una firma determinista del plan separa los checks por usuario y descarta progreso obsoleto cuando cambia la semana guardada.
- La interfaz usa `AppShell`, encabezado, botones, mensajes y estados vacíos compartidos; elimina gradiente, radios excesivos y checks decorativos.
- Ingredientes se agrupan por familia alimentaria y pueden verse todos o solo pendientes. Actualización, reinicio y progreso tienen estados accesibles.
- Los datos faltantes permanecen visibles como cantidad por definir. La prueba local real devolvió 23 ingredientes de 5 comidas y confirmó que el catálogo actual todavía no registra sus cantidades.
- Contrato específico, lint y build de producción: correctos. La aceptación visual automatizada continúa pendiente por falta de navegador conectado.
- Backend `9e9f368` y frontend `1a73a93` publicados; contratos y quality de GitHub Actions aprobados junto con el preview de Vercel.
- Fase UI/UX web: **78%**.

### 2026-09-09 - Shell administrativo y calidad del catálogo

- El panel usa navegación lateral persistente en escritorio y un selector nativo estable en pantallas pequeñas.
- Todas las secciones muestran contexto activo y comparten `AppShell`, `PageHeader` y `Button`.
- Operación incorpora cinco métricas accionables: recetas con ocho nutrientes, recetas revisadas, relaciones cuantificadas, ingredientes categorizados y sustituciones precisas.
- Cada indicador muestra numerador, total, porcentaje y acceso directo al catálogo correspondiente.
- El consumo de IA y las migraciones conservan sus contratos, pero ahora tienen estados, jerarquía y alertas operativas más claras.
- No se requiere migración: los indicadores se calculan sobre las columnas existentes de las migraciones `009`, `010` y `012`.
- La consulta real local confirmó 80 de 80 ingredientes categorizados y listos para sustitución, y evidenció la deuda actual: 0 recetas con nutrición completa o revisada y 0 de 281 relaciones con cantidad.
- Contrato de overview, lint y build de producción: aprobados. QA visual multipantalla continúa pendiente porque no hay navegador conectado.
- Fase UI/UX web: **84%**. Expansión completa del producto: **79%**.

### 2026-09-09 - Gestión responsive de recetas e ingredientes

- Los catálogos usan tarjetas en mobile y tablas sin ancho mínimo forzado desde tablet.
- Las tablas priorizan nombre, cobertura nutricional, taxonomía y acciones; los datos secundarios aparecen según el espacio disponible.
- Búsqueda, limpieza de filtros, resultados, vacío, carga, error y éxito usan los componentes compartidos.
- La paginación duplicada fue reemplazada por `Pagination` y conserva el ajuste de página cuando se elimina el último elemento.
- La eliminación dejó de depender de `window.confirm`: `ConfirmModal` gestiona foco, Escape, bloqueo de scroll, cierre por fondo, progreso y texto específico.
- La eliminación de ingredientes advierte que las relaciones existentes pueden bloquearla para proteger integridad referencial.
- Lint, build y smoke HTTP del route administrativo: aprobados. La revisión visual autenticada continúa pendiente.
- Fase Administración UI: **60%**. Fase UI/UX web: **88%**. Expansión completa del producto: **79%**.

### 2026-09-09 - Usuarios y catálogos clínicos

- Usuarios usa tarjetas mobile y una tabla de columnas prioritarias, sin ancho mínimo ni scroll horizontal forzado.
- La cobertura clínica agrupa objetivos, condiciones y restricciones; el estado del perfil permanece visible en todos los anchos.
- Cambiar un rol abre una confirmación que explica los permisos concedidos o retirados. La protección del último administrador continúa en backend.
- Los catálogos clínicos incorporan búsqueda tolerante a tildes, paginación local, tarjetas mobile y estados de riesgo, actividad y orientación profesional.
- El formulario explica el carácter estable del código y agrupa opciones binarias con contexto; crear, editar y activar/desactivar tienen progreso y resultado explícitos.
- Se añadió la variante compartida `warning` a `Button` para acciones sensibles no destructivas.
- Lint sin advertencias, build Vite y smoke HTTP: aprobados. La aceptación visual autenticada continúa pendiente.
- Fase Administración UI: **78%**. Fase UI/UX web: **91%**. Expansión completa del producto: **80%**.

### 2026-09-09 - Cierre de administración UI

- Reglas nutricionales separa la carga paginada del catálogo clínico, evitando volver a solicitar datos estáticos en cada cambio de página o filtro.
- El formulario deriva `kcal_per_meal`, `g_per_meal` o `mg_per_meal` según el nutriente y habilita únicamente los límites compatibles con mínimo, máximo, rango o recomendación.
- Reglas y restricciones incluyen estados de guardado/cambio, filtros, búsqueda, vacíos, paginación compartida, tarjetas mobile y tablas de columnas prioritarias.
- La auditoría de IA diferencia resumen global/filtrado, calcula tasa de éxito y presenta política protegida, tokens, costo efectivo, proveedor, modelo, identificador y código de error.
- Todos los módulos del panel cubren carga, error, vacío, acciones deshabilitadas y responsive a nivel de código.
- Lint sin errores ni advertencias, build Vite, 14 contratos backend y smoke HTTP: aprobados.
- La aceptación visual autenticada en 390, 768, 1024 y 1440 px continúa en Fase 7 porque no hay navegador conectado.
- Fase Administración UI del alcance actual: **100%**. Fase UI/UX web: **94%**. Expansión completa del producto: **81%**.
