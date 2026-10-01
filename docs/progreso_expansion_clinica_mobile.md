# Progreso de Expansion Clinica, IA y Mobile - NutriEdu

Este documento funciona como bitacora viva del trabajo de expansion de NutriEdu. Su objetivo es dejar registro claro de cada movimiento importante: decisiones, archivos tocados, validaciones, bloqueos y siguiente paso.

Roadmap base: [roadmap_clinico_ai_mobile.md](roadmap_clinico_ai_mobile.md)

## Estado actual

- Fase activa: cierre de Fase 2 e inicio de la base mobile-first para Fase 4.
- Prioridad acordada: mantener el Mobile MVP funcional y preparar una integracion de vision con limites clinicos y de privacidad explicitos.
- Enfoque mobile-first: la app movil se considera pieza principal para los futuros modulos de IA por camara y documentos.
- Estado de implementacion: Fase 1 completada; Mobile MVP editable con autenticacion, perfil clinico, recetas, plan, compras y captura validada de imagenes.

## Reglas de trabajo

- Comunicar cada movimiento antes o mientras se realiza.
- Registrar cambios relevantes en esta bitacora.
- Mantener el roadmap como documento estrategico y esta bitacora como documento operativo.
- No eliminar comportamiento actual sin una razon explicita.
- Mantener web, backend y futura app movil consumiendo una API comun.
- Validar cada bloque con comandos, pruebas manuales o revision documental, segun corresponda.

## Plan operativo inicial

### Paso 1: Analisis del estado actual

Objetivo:

- revisar schema actual;
- revisar controladores y rutas relacionadas con usuario, restricciones, recetas y planner;
- detectar donde encaja el perfil avanzado sin romper el flujo existente.

Estado: completado.

### Paso 2: Diseno de schema Fase 1

Objetivo:

- definir tablas nuevas;
- definir relaciones con `usuarios`;
- definir datos semilla para objetivos y condiciones;
- decidir si se crea un archivo SQL de migracion o una actualizacion del schema base.

Estado: completado.

### Paso 3: Backend de perfil avanzado

Objetivo:

- crear servicios/controladores para perfil avanzado;
- crear endpoints protegidos por JWT;
- leer el usuario desde `req.user.id`;
- preparar respuestas reutilizables por web y mobile.

Estado: completado.

### Paso 4: Motor de reglas nutricionales inicial

Objetivo:

- crear una primera version de evaluacion nutricional;
- evaluar recetas contra metas y restricciones;
- devolver score, alertas y recomendaciones.

Estado: completado.

Validacion runtime: completada.

### Paso 5: Integracion web minima

Objetivo:

- actualizar la pantalla de perfil para probar datos nuevos;
- validar que el backend funciona antes de iniciar mobile.

Estado: completado.

### Paso 6: Mobile MVP

Objetivo:

- iniciar proyecto React Native;
- conectar auth;
- conectar perfil avanzado;
- preparar permisos para camara y documentos.

Estado: en progreso.

## Registro de movimientos

### 2026-08-21 - Inicio de Paso 1: analisis del estado actual

Tipo: analisis tecnico.

Archivos objetivo:

- `nutriedu-backend/database/db.js`
- `nutriedu-backend/controllers/userController.js`
- `nutriedu-backend/controllers/recipeController.js`
- `nutriedu-backend/controllers/plannerController.js`
- `nutriedu-backend/routes/userRoutes.js`
- `nutriedu-backend/routes/recipeRoutes.js`
- `nutriedu-backend/routes/plannerRoutes.js`
- `docs/bases_de_datos.md`
- archivos disponibles en `Schemas/`

Resumen:

- Se inicia la revision del estado actual para ubicar el perfil avanzado, objetivos, condiciones clinicas y motor de reglas sin romper los flujos existentes.

Validacion:

- Revision directa de controladores, rutas, conexion a base de datos, frontend de perfil y seed actual.

Hallazgos:

- El backend ya usa `req.user.id` en restricciones, recetas y planner, lo cual facilita reutilizar la API desde mobile.
- Las rutas de recetas y planner conservan `:userId` por compatibilidad, pero los controladores usan el usuario autenticado.
- El modelo actual cubre usuarios, restricciones, ingredientes, recetas, plan semanal y tokens de recuperacion.
- `recetas` solo contiene `calorias`, `tiempo_preparacion` y `nivel_salud`; aun no existen nutrientes como proteina, sodio, azucar o carbohidratos.
- La pantalla web `Profile.jsx` actualmente solo permite seleccionar restricciones alimentarias.
- No existe aun una carpeta formal de migraciones versionadas.

Decision:

- Crear una carpeta `nutriedu-backend/migrations/` para cambios SQL versionados.
- En Fase 1 se agregaran tablas nuevas sin borrar ni modificar las tablas actuales.
- La expansion de nutrientes por receta se hara de forma separada para no bloquear el perfil clinico inicial.

### 2026-08-21 - Inicio de Paso 2: diseno de schema Fase 1

Tipo: diseno de base de datos.

Archivos objetivo:

- `nutriedu-backend/migrations/001_clinical_profile_foundation.sql`
- `docs/progreso_expansion_clinica_mobile.md`

Resumen:

- Se inicia la creacion de una migracion versionada para perfil avanzado, objetivos, condiciones clinicas, reglas nutricionales y metas por usuario.

Validacion:

- Revision manual de SQL.
- `node --check server.js`.
- `node --check controllers/profileController.js`.
- `node --check routes/profileRoutes.js`.
- `node -e "require('./routes/profileRoutes'); console.log('profile routes ok')"`.

Resultado:

- Migracion creada correctamente.
- Backend compila sin errores de sintaxis.
- El nuevo router de perfil se puede importar correctamente.

### 2026-08-21 - Backend de perfil avanzado inicial

Tipo: implementacion backend.

Archivos:

- `nutriedu-backend/controllers/profileController.js`
- `nutriedu-backend/routes/profileRoutes.js`
- `nutriedu-backend/server.js`
- `nutriedu-backend/README.md`
- `docs/bases_de_datos.md`
- `docs/progreso_expansion_clinica_mobile.md`

Resumen:

- Se agrego el modulo protegido `/api/profile`.
- Se agrego `GET /api/profile` para devolver perfil, objetivos, condiciones y metas nutricionales del usuario autenticado.
- Se agrego `PUT /api/profile` para guardar datos antropometricos y estilo de vida.
- Se agrego `GET /api/profile/catalogs` para objetivos y condiciones clinicas.
- Se agrego `PUT /api/profile/goals` para guardar objetivos por ID o `code`.
- Se agrego `PUT /api/profile/conditions` para guardar condiciones clinicas confirmadas.
- Se agrego `PUT /api/profile/targets` para guardar metas y limites nutricionales.
- Se documento el nuevo modulo en el README del backend y en la documentacion de base de datos.

Validacion:

- `node --check server.js`.
- `node --check controllers/profileController.js`.
- `node --check routes/profileRoutes.js`.
- `node -e "require('./routes/profileRoutes'); console.log('profile routes ok')"`.

Resultado:

- Backend sin errores de sintaxis en archivos modificados.
- Rutas de perfil listas para probar despues de ejecutar la migracion en la base de datos.

Nota:

- En este punto la tabla `reglas_nutricionales` quedo preparada para el siguiente movimiento: implementar la primera evaluacion nutricional.

### 2026-08-21 - Motor de reglas nutricionales inicial

Tipo: implementacion backend.

Archivos:

- `nutriedu-backend/services/nutritionRuleService.js`
- `nutriedu-backend/controllers/recipeController.js`
- `nutriedu-backend/routes/recipeRoutes.js`
- `nutriedu-backend/README.md`
- `docs/bases_de_datos.md`
- `docs/progreso_expansion_clinica_mobile.md`

Resumen:

- Se creo `nutritionRuleService` para evaluar recetas contra el perfil del usuario.
- Se agrego `GET /api/recipes/evaluate/:recipeId`.
- La evaluacion considera restricciones alimentarias, objetivos, condiciones clinicas, metas nutricionales y reglas activas.
- El resultado incluye `score`, `status`, `unsafeIngredients`, `alerts` y `context`.
- La logica queda en un servicio reutilizable para que futuras funciones de IA puedan evaluar platos detectados desde imagen.

Validacion:

- `node --check services/nutritionRuleService.js`.
- `node --check controllers/recipeController.js`.
- `node --check routes/recipeRoutes.js`.
- `node -e "require('./routes/recipeRoutes'); console.log('recipe routes ok')"`.

Resultado:

- Backend sin errores de sintaxis en el servicio, controlador y rutas de recetas.

Nota:

- Las reglas basadas en nutrientes como proteina, sodio o azucar solo se aplican cuando la receta tenga esos valores cargados.

### 2026-08-21 - Aplicacion de migracion clinica en base local

Tipo: base de datos.

Archivos:

- `nutriedu-backend/migrations/001_clinical_profile_foundation.sql`
- `docs/progreso_expansion_clinica_mobile.md`

Resumen:

- Se ejecuto la migracion clinica contra la base de datos configurada en `nutriedu-backend/.env`.
- La ejecucion creo o actualizo tablas de perfil avanzado, objetivos, condiciones clinicas, reglas y metas nutricionales.
- Tambien agrego columnas nutricionales opcionales en `recetas`.

Validacion:

- Consulta de conteo a `objetivos_nutricionales`.
- Consulta de conteo a `condiciones_clinicas`.
- Consulta de conteo a `reglas_nutricionales`.
- Consulta a `information_schema.columns` para columnas nutricionales en `recetas`.

Resultado:

- Objetivos nutricionales: 12.
- Condiciones clinicas: 13.
- Reglas nutricionales: 8.
- Columnas verificadas en `recetas`: `protein_g`, `sodium_mg`, `sugar_g`.

### 2026-08-21 - Prueba runtime del perfil clinico y motor de reglas

Tipo: validacion de integracion backend.

Archivos:

- `nutriedu-backend/scripts/clinicalProfileSmokeTest.js`
- `nutriedu-backend/package.json`
- `nutriedu-backend/README.md`
- `docs/progreso_expansion_clinica_mobile.md`

Resumen:

- Se agrego el comando reutilizable `npm run test:clinical-smoke`.
- La prueba crea un usuario temporal, inicia sesion mediante el endpoint real y obtiene un JWT.
- Con ese JWT consulta catalogos, guarda perfil, objetivos, condiciones clinicas y metas nutricionales.
- Luego recupera el perfil completo y evalua una receta disponible.
- El usuario temporal se elimina siempre al finalizar, incluso si una validacion falla.

Validacion:

- Autenticacion JWT: correcta.
- Catalogos: 12 objetivos y 13 condiciones.
- Objetivos guardados: `gain_muscle`, `general_health`.
- Condicion guardada: `hypertension`.
- Metas nutricionales: guardadas y recuperadas correctamente.
- Receta evaluada: ID 1, score 100, estado `suitable`.
- Limpieza: 0 usuarios temporales restantes.
- `node --check scripts/clinicalProfileSmokeTest.js`.
- `git diff --check`.

Resultado:

- Los endpoints nuevos funcionan de extremo a extremo contra la base local.
- La base backend de Fase 1 queda lista para la integracion web minima.

Nota:

- La receta evaluada aun no tiene todos los nutrientes nuevos cargados. El motor omite valores desconocidos para evitar alertas inventadas.

### 2026-08-21 - Creacion de roadmap estrategico

Tipo: documentacion.

Archivos:

- `docs/roadmap_clinico_ai_mobile.md`
- `README.md`

Resumen:

- Se creo el roadmap clinico, IA y mobile.
- Se definio mobile como prioridad temprana por los casos de uso de camara, foto de plato y analisis de documentos.
- Se agrego el enlace del roadmap al README principal.

Validacion:

- Revision manual del documento.
- Revision de caracteres no ASCII en el roadmap.

### 2026-08-21 - Creacion de bitacora viva

Tipo: documentacion operativa.

Archivos:

- `docs/progreso_expansion_clinica_mobile.md`

Resumen:

- Se creo este documento para registrar el avance paso a paso.
- Se separo el roadmap estrategico de la bitacora operativa.
- Se definieron reglas de trabajo y plan operativo inicial.

Validacion:

- Revision manual del documento.
- Revision de caracteres no ASCII en la bitacora.

## Decisiones tomadas

- La app movil se priorizara temprano porque los modulos de IA necesitan portabilidad.
- La IA no debe actualizar informacion medica sin confirmacion explicita del usuario.
- El backend Express seguira siendo la API central.
- El motor de reglas debe existir antes de depender de IA.
- El perfil avanzado debe ser la fuente de verdad para web, mobile e IA.
- Mobile se implementa con Expo SDK 57, Expo Router y TypeScript.
- Los JWT se almacenan con Expo SecureStore en Android e iOS.

## Decisiones pendientes

- Elegir proveedor de IA.
- Elegir almacenamiento para imagenes/documentos.
- Definir politica de retencion de archivos sensibles.
- Definir primer catalogo oficial de objetivos.
- Definir primer catalogo oficial de condiciones clinicas.
- Definir si las migraciones se ejecutaran manualmente en Supabase o mediante una herramienta automatizada.

## Riesgos activos

- Manejo de datos medicos sensibles.
- Recomendaciones clinicas demasiado absolutas.
- Estimaciones nutricionales imprecisas desde imagenes.
- Crecimiento del schema sin migraciones versionadas.
- Duplicacion de logica entre web y mobile si no se centraliza en backend.

### 2026-08-21 - Integracion web del perfil avanzado

Tipo: implementacion frontend.

Archivos:

- `nutriedu-frontend/src/pages/Profile.jsx`
- `docs/progreso_expansion_clinica_mobile.md`

Resumen:

- Se reemplazo la pantalla limitada a restricciones por un perfil de salud con cuatro secciones.
- Se conectaron datos personales, estilo de vida, objetivos, condiciones clinicas, restricciones y metas nutricionales.
- Cada seccion guarda de forma independiente contra los endpoints de perfil.
- Se conservaron las restricciones alimentarias existentes.

Validacion:

- `npm run lint`: sin errores; tres advertencias preexistentes en paginas no modificadas.
- `npm run build`: correcto.
- Vite sirvio `/profile` con estado HTTP 200.
- La verificacion visual automatizada quedo pendiente porque no habia un navegador conectado al workspace.

Resultado:

- Paso 5 completado y contrato web/backend listo para reutilizar desde mobile.

### 2026-08-21 - Inicio de Mobile MVP

Tipo: arquitectura e implementacion mobile.

Archivos:

- `nutriedu-mobile/`
- `README.md`
- `docs/progreso_expansion_clinica_mobile.md`

Resumen:

- Se creo la app con Expo SDK 57, React Native, Expo Router y TypeScript estricto.
- Se agrego login contra el backend existente.
- Se agrego restauracion y cierre de sesion.
- El JWT usa Expo SecureStore en Android e iOS.
- Se agrego una ruta protegida con resumen del perfil avanzado.
- La URL de API se configura mediante `EXPO_PUBLIC_API_URL`.
- Se reutilizo el logo existente de NutriEdu.

Validacion:

- `npm run typecheck`: correcto.
- `npm run lint`: correcto, sin hallazgos.
- `npx expo config --type public`: SDK 57 y plugins correctos.
- `npx expo export --platform all`: Android, iOS y web exportados correctamente.
- `git diff --check`: correcto.

Riesgo registrado:

- `npm audit` reporta 11 vulnerabilidades moderadas dentro de herramientas nativas de Expo por una dependencia transitiva de `uuid`.
- No se aplico `npm audit fix --force` porque propone cambios incompatibles con el SDK actual.

Resultado:

- Paso 6 iniciado con un primer flujo vertical funcional: login, sesion segura y lectura del perfil.

### 2026-08-21 - Autenticacion completa y navegacion funcional mobile

Tipo: implementacion y validacion mobile.

Archivos principales:

- `nutriedu-mobile/src/app/login.tsx`
- `nutriedu-mobile/src/app/register.tsx`
- `nutriedu-mobile/src/app/forgot-password.tsx`
- `nutriedu-mobile/src/app/(app)/_layout.tsx`
- `nutriedu-mobile/src/app/(app)/recipes/`
- `nutriedu-mobile/src/app/(app)/plan.tsx`
- `nutriedu-mobile/src/app/(app)/shopping.tsx`
- `nutriedu-mobile/src/components/auth-form.tsx`
- `nutriedu-mobile/src/components/recipe-card.tsx`
- `nutriedu-mobile/src/types/api.ts`
- `nutriedu-backend/scripts/clinicalProfileSmokeTest.js`

Resumen:

- Se agrego registro con validacion local e inicio de sesion automatico.
- Se agrego solicitud de recuperacion con respuesta generica para proteger privacidad.
- Se creo navegacion inferior para perfil, recetas, plan y compras.
- Se conectaron recetas recomendadas y detalle con ingredientes y evaluacion personalizada.
- Se agrego consulta del plan semanal con progreso.
- Se agrego lista de compras con checks persistentes en almacenamiento local seguro.
- Se extendio el smoke test backend para cubrir todas las lecturas usadas por mobile.

Validacion:

- `npm run typecheck`: correcto.
- `npm run lint`: correcto, sin hallazgos.
- `git diff --check`: correcto.
- `npx expo export --platform all`: 16 rutas exportadas para Android, iOS y web.
- Smoke API: 5 recomendaciones, receta ID 1, 6 ingredientes y evaluacion `suitable` con score 100.
- Smoke API: plan y lista vacios devueltos correctamente para usuario nuevo.
- Usuario temporal eliminado al finalizar la prueba.

Resultado:

- Autenticacion y navegacion base del Mobile MVP completadas.
- Recetas quedan conectadas de extremo a extremo con el motor clinico.
- Plan y compras ya son utiles para consulta; la edicion mobile queda como siguiente incremento.

### 2026-08-21 - Diagnostico de conexion Expo Go

Tipo: diagnostico de entorno local.

Problema:

- Expo Go no podia conectarse a `exp://192.168.0.102:8081`.

Causa confirmada:

- La direccion Wi-Fi del computador cambio a `10.11.87.210`.
- Metro y el backend seguian configurados o compartidos con la direccion anterior.
- Las pruebas contra `192.168.0.102` fallaron incluso desde el computador.

Correccion:

- Se actualizo `nutriedu-mobile/.env` con `http://10.11.87.210:3002/api`.
- Se reinicio Expo con cache limpia y modo LAN.
- Metro ahora anuncia `exp://10.11.87.210:8081`.

Validacion:

- Metro respondio HTTP 200 en `10.11.87.210:8081`.
- El backend respondio HTTP 401 sin JWT en `10.11.87.210:3002/api/profile`, resultado esperado para una ruta protegida.

Nota operativa:

- La IP local puede cambiar al cambiar de red o reconectarse a Wi-Fi. Cuando ocurra, se debe actualizar `EXPO_PUBLIC_API_URL` y reiniciar Expo.
- El segundo intento con la IP correcta siguio fallando desde Expo Go.
- El firewall de macOS esta desactivado y los procesos escuchan en todas las interfaces.
- Metro y backend responden correctamente desde el computador.
- La evidencia apunta a aislamiento entre dispositivos en la red administrada `10.11.x.x`.
- Resolucion pendiente: conectar el computador al hotspot personal del telefono y reiniciar Expo/backend con la nueva IP.

### 2026-08-21 - Cambio a hotspot personal

Tipo: correccion de conectividad para dispositivo fisico.

Movimiento:

- Se conecto el computador al hotspot personal del telefono.
- La nueva direccion local del computador es `172.20.10.2`.
- Se actualizo `nutriedu-mobile/.env` con `EXPO_PUBLIC_API_URL=http://172.20.10.2:3002/api`.

Estado:

- Configuracion actualizada.
- Backend iniciado con acceso a red local en `172.20.10.2:3002`.
- Metro iniciado en modo LAN con `exp://172.20.10.2:8081`.
- El backend respondio HTTP 401 sin JWT, resultado esperado para la ruta protegida `/api/profile`.
- Metro completo correctamente la compilacion inicial del bundle.
- Se identifico y corrigio un segundo bloqueo: el arranque anterior estaba en un entorno que reportaba `Networking has been disabled`.
- Al intentar abrir el proyecto desde el telefono, Expo reporto `Project is incompatible with this version of Expo Go`.
- La conectividad local quedo resuelta; el bloqueo actual es una version antigua de Expo Go frente al SDK usado por el proyecto.
- Metro se detuvo para que el siguiente arranque se haga en la terminal visible del desarrollador despues de actualizar Expo Go.

### 2026-08-21 - Compatibilidad Expo Go en dispositivo fisico

Tipo: decision de compatibilidad del Mobile MVP.

Diagnostico confirmado:

- `nutriedu-mobile` fue creado con Expo SDK 57.
- La version publica de Expo Go disponible en las tiendas para dispositivos fisicos permanece compatible con SDK 54 durante la transicion de SDK 57.
- Por eso la tienda no ofrece una actualizacion aunque Expo Go rechaza el proyecto como una version mas nueva.

Decision:

- Alinear temporalmente el Mobile MVP con Expo SDK 54 para permitir pruebas inmediatas en un telefono fisico.
- Conservar sin cambios las pantallas, rutas, autenticacion y servicios API.
- Volver a SDK 57 mas adelante mediante un development build, cuando el flujo de distribucion mobile este preparado.

Estado:

- Auditoria de imports completada: no se usan paquetes UI exclusivos de SDK 57.
- Proyecto alineado con Expo SDK 54, React 19.1 y React Native 0.81.5.
- Se eliminaron dependencias no utilizadas del template SDK 57.
- `npx expo install --check`: dependencias actualizadas y compatibles.
- `npx expo-doctor`: 18 de 18 verificaciones correctas.
- `npm run typecheck`: correcto.
- `npm run lint`: correcto.
- `npx expo export --platform all`: 16 rutas exportadas correctamente para Android, iOS y web.
- `npm install --package-lock-only`: lockfile reproducible con el flujo de instalacion estandar.
- README mobile actualizado con el flujo LAN y la razon del SDK temporal.
- Expo Go confirmado en el telefono fisico mediante hotspot personal.

### 2026-08-21 - Perfil clinico editable en mobile

Tipo: incremento funcional del Mobile MVP.

Implementacion:

- Se reemplazo el resumen de perfil de solo lectura por cuatro vistas editables: personal, objetivos, salud y metas.
- Datos personales incluye fecha de nacimiento, sexo, peso, estatura, actividad, condicion fisica y notas.
- Habitos incluye comidas diarias, frecuencia de comidas fuera, estilo alimentario y tiempo para cocinar.
- Los objetivos se seleccionan en orden de prioridad y se persisten mediante `/api/profile/goals`.
- Salud permite seleccionar condiciones clinicas y restricciones alimentarias de forma independiente.
- Las metas permiten definir limites de calorias, proteina, carbohidratos, grasas, azucar, fibra, sodio y agua.
- Se agregaron validaciones de fecha, numeros positivos y rangos minimos/maximos.
- Despues de cada guardado, mobile vuelve a consultar el servidor para mostrar el estado canonico persistido.
- Se agregaron controles nativos reutilizables con estados accesibles para opciones, checkboxes y acciones de guardado.

Archivos principales:

- `nutriedu-mobile/src/app/(app)/profile.tsx`
- `nutriedu-mobile/src/components/profile-controls.tsx`
- `nutriedu-mobile/src/types/api.ts`
- `nutriedu-backend/scripts/clinicalProfileSmokeTest.js`

Validacion:

- `npm run typecheck`: correcto.
- `npm run lint`: correcto.
- `npx expo export --platform all`: 16 rutas exportadas para Android, iOS y web.
- Smoke API: 12 objetivos y 13 condiciones disponibles.
- Smoke API: datos personales, dos objetivos, hipertension, una restriccion y metas nutricionales persistieron y se leyeron correctamente.
- Smoke API: usuario temporal y relaciones eliminados correctamente al finalizar.
- Revision React: carga paralela, componentes externos, actualizaciones funcionales de estado y roles accesibles verificados.

Resultado:

- La gestion completa del perfil clinico ya esta disponible en mobile.
- Pendiente visual: recorrer y guardar las cuatro vistas desde Expo Go en el telefono fisico.

### 2026-08-21 - Mejoras de captura y exploracion del perfil

Tipo: mejora de usabilidad del perfil clinico mobile.

Implementacion:

- Se reemplazo la fecha escrita manualmente por un selector de calendario nativo en Android e iOS.
- El calendario limita la seleccion entre 1900 y la fecha actual y conserva el formato `AAAA-MM-DD` para la API.
- Web mantiene un campo de texto compatible para conservar la exportacion multiplataforma.
- Se agrego un icono de informacion junto a estilo alimentario con definiciones de omnivoro, vegetariano, vegano y pescetariano.
- Condiciones clinicas y restricciones alimentarias ahora tienen buscadores independientes.
- Sin busqueda se muestran seis elementos destacados y se mantienen visibles los elementos ya seleccionados.
- Con busqueda se consulta el catalogo completo por nombre y, para condiciones, tambien por descripcion.
- Se agregaron estados de cero resultados y controles para limpiar cada busqueda.

Decision de producto:

- Los seis elementos iniciales son una seleccion editorial para facilitar el acceso, no una afirmacion de prevalencia clinica.
- La seleccion puede reemplazarse en el futuro por estadisticas anonimizadas o una prioridad administrada por profesionales.

Archivos principales:

- `nutriedu-mobile/src/components/date-field.native.tsx`
- `nutriedu-mobile/src/components/date-field.tsx`
- `nutriedu-mobile/src/components/profile-controls.tsx`
- `nutriedu-mobile/src/app/(app)/profile.tsx`

Validacion:

- `@react-native-community/datetimepicker` `8.4.4`, version recomendada para Expo SDK 54.
- `npx expo install --check`: dependencias compatibles.
- `npm run typecheck`: correcto.
- `npm run lint`: correcto.
- `npx expo export --platform all`: 16 rutas exportadas para Android, iOS y web.
- `git diff --check`: correcto.

Resultado:

- La captura de nacimiento elimina errores de formato en dispositivos moviles.
- Los catalogos clinicos pueden crecer sin convertir la vista de salud en una lista extensa por defecto.
- Calendario, ayuda contextual y busquedas confirmados en el telefono fisico.

### 2026-08-21 - Teclado del perfil y planificador mobile editable

Tipo: correccion de usabilidad e incremento funcional del Mobile MVP.

Implementacion:

- El perfil ahora ajusta sus margenes y desplazamiento cuando aparece el teclado.
- Android usa el modo `resize`; en iOS el formulario usa ajuste automatico de insets y cierre interactivo.
- Los resultados de restricciones permanecen visibles, desplazables y seleccionables mientras se escribe.
- El planificador muestra los 21 espacios semanales, incluso cuando estan vacios.
- Cada espacio permite buscar, agregar o reemplazar una receta compatible con las restricciones del usuario.
- Las recetas pueden retirarse del borrador antes de guardar la semana completa.
- El backend valida dias, tipos de comida, IDs de receta, espacios duplicados y compatibilidad con restricciones.
- El reemplazo del plan usa una transaccion PostgreSQL: cualquier fallo revierte la operacion y conserva el plan anterior.
- La lista de compras se vuelve a consultar al entrar en su pestana, por lo que refleja el ultimo plan guardado.

Archivos principales:

- `nutriedu-mobile/app.json`
- `nutriedu-mobile/src/app/(app)/profile.tsx`
- `nutriedu-mobile/src/app/(app)/plan.tsx`
- `nutriedu-mobile/src/app/(app)/shopping.tsx`
- `nutriedu-mobile/src/components/recipe-picker-modal.tsx`
- `nutriedu-backend/controllers/plannerController.js`

Validacion:

- `node --check nutriedu-backend/controllers/plannerController.js`: correcto.
- `npm run typecheck`: correcto.
- `npm run lint`: correcto.
- `npx expo export --platform all`: 16 rutas exportadas para Android, iOS y web.
- `git diff --check`: correcto.

Resultado:

- La busqueda inferior del perfil ya no queda bloqueada por el teclado.
- El plan semanal dejo de ser de solo lectura en mobile.
- La derivacion de la lista de compras queda sincronizada al navegar desde el plan.
- El ciclo de agregar, reemplazar, eliminar, guardar y abrir compras fue confirmado en el telefono fisico.

### 2026-08-21 - Exploracion y filtros de recetas en mobile

Tipo: incremento funcional del Mobile MVP y ampliacion del contrato de recetas.

Implementacion:

- La pestana Recetas ahora consulta el catalogo seguro completo en lugar de mostrar solo cinco recomendaciones aleatorias.
- La busqueda encuentra coincidencias por nombre y descripcion con una espera de 350 ms para evitar solicitudes por cada pulsacion.
- Se agregaron filtros por nivel de salud: todas, muy saludable, saludable y moderada.
- Se agregaron limites opcionales de calorias minimas y maximas con validacion de rango.
- La interfaz muestra el numero de resultados, el estado de busqueda y una accion para limpiar filtros activos.
- El planificador reutiliza los mismos controles y reglas sobre su catalogo de recetas compatibles cargado localmente.
- El backend incorpora `safe_only=true`, valida filtros numericos y ordena resultados de manera determinista.
- Las solicitudes anteriores se cancelan cuando el usuario cambia los filtros rapidamente.

Archivos principales:

- `nutriedu-mobile/src/app/(app)/recipes/index.tsx`
- `nutriedu-mobile/src/components/recipe-filters.tsx`
- `nutriedu-mobile/src/components/recipe-picker-modal.tsx`
- `nutriedu-mobile/src/types/api.ts`
- `nutriedu-backend/controllers/recipeController.js`
- `nutriedu-backend/scripts/clinicalProfileSmokeTest.js`

Validacion:

- `node --check` para controlador y smoke test: correcto.
- `npm run typecheck`: correcto.
- `npm run lint`: correcto.
- Smoke autenticado: 36 recetas seguras dentro del rango consultado.
- Smoke autenticado: filtro moderado sin resultados fuera de rango y busqueda por descripcion verificada.
- `npx expo export --platform all`: 16 rutas exportadas para Android, iOS y web.
- `git diff --check`: correcto.

Resultado:

- Recetas y planificador comparten el mismo lenguaje de busqueda y filtrado.
- El servidor mantiene la compatibilidad clinica como regla obligatoria, no solo como filtro visual.
- Pendiente manual: revisar busqueda, combinaciones de filtros, limpieza y selector del plan en Expo Go.

### 2026-08-21 - Captura mobile e intake seguro de imagenes

Tipo: cierre tecnico del Mobile MVP e inicio de la base para vision.

Implementacion:

- Se agrego una quinta pestana `Analizar` con captura desde camara y seleccion desde galeria.
- Android e iOS declaran mensajes de permiso especificos; no se solicita permiso de microfono.
- La pantalla gestiona permiso denegado, acceso a ajustes, seleccion, reemplazo, eliminacion y vista previa estable.
- Mobile valida formatos y limite de 8 MB antes de enviar la imagen.
- `apiRequest` detecta `FormData` y permite que el runtime genere correctamente el boundary multipart.
- Se agrego `POST /api/food-analysis/intake`, protegido por JWT y limitado a una imagen por solicitud.
- Multer procesa la imagen solo en memoria y limita el archivo a 8 MB.
- El backend valida MIME y firma binaria para JPEG, PNG, WebP y HEIC/HEIF.
- La respuesta versionada indica `validated`, incluye metadatos, no incluye resultados de IA y declara que la imagen no fue retenida.
- La interfaz distingue explicitamente una imagen validada de un analisis visual completado.

Decision provisional de privacidad:

- Las imagenes se descartan al finalizar la solicitud.
- No se habilitara persistencia hasta definir proveedor, finalidad, consentimiento, tiempo de retencion y mecanismo de eliminacion.
- No se devuelven ingredientes, nutrientes ni recomendaciones simuladas mientras no exista un proveedor real.

Archivos principales:

- `nutriedu-mobile/app.json`
- `nutriedu-mobile/src/app/(app)/_layout.tsx`
- `nutriedu-mobile/src/app/(app)/analyze.tsx`
- `nutriedu-mobile/src/services/api.ts`
- `nutriedu-mobile/src/types/api.ts`
- `nutriedu-backend/routes/foodAnalysisRoutes.js`
- `nutriedu-backend/controllers/foodAnalysisController.js`
- `nutriedu-backend/server.js`
- `nutriedu-backend/scripts/clinicalProfileSmokeTest.js`

Validacion:

- `expo-image-picker` `~17.0.11`, compatible con Expo SDK 54.
- `node --check` para rutas, controlador y smoke test: correcto.
- `npm run typecheck`: correcto.
- `npm run lint`: correcto.
- Smoke autenticado: PNG valido aceptado con estado `validated` y `retained: false`.
- Smoke autenticado: archivo con MIME PNG y contenido falso rechazado con HTTP `415`.
- `npm audit fix` actualizo dependencias transitivas compatibles del backend; auditoria final con 0 vulnerabilidades.
- `npx expo install --check`: dependencias compatibles usando el mapa local de Expo.
- `npx expo config --type public`: permisos de fotos y camara resueltos correctamente.
- `npx expo export --platform all`: 18 rutas exportadas para Android, iOS y web.
- `git diff --check`: correcto.

Resultado:

- NutriEdu ya puede capturar, previsualizar y transportar una imagen desde mobile hasta una frontera backend autenticada.
- La frontera es independiente del proveedor de IA y evita retencion accidental durante esta etapa.
- Camara, galeria y carga fueron confirmadas desde Expo Go en el telefono fisico.

### 2026-08-21 - Vision estructurada, consentimiento y revision clinica

Tipo: primer incremento funcional de Fase 4.

Implementacion:

- Se definio el esquema `1.0` para comida, plato, ingredientes, porcion, nutrientes, confianza e incertidumbres.
- El esquema se valida nuevamente en backend aunque el proveedor use Structured Outputs.
- Se creo una interfaz de proveedor visual con adaptador OpenAI configurable por entorno.
- El adaptador usa Responses API con imagen en data URL, detalle alto, JSON Schema estricto, timeout de 60 segundos y `store: false`.
- Mobile convierte la imagen a JPEG, limita el ancho a 1600 px y aplica compresion antes del envio externo.
- El analisis real exige consentimiento explicito por imagen y version de consentimiento tanto en mobile como en backend.
- Si no hay proveedor, la app conserva el flujo de validacion local sin simular resultados.
- La salida visual se evalua con reglas NutriEdu contra restricciones, objetivos, condiciones y metas manuales.
- La coincidencia de ingredientes usa frases normalizadas para evitar falsos positivos simples como `sal` dentro de `salsa`.
- El resultado mobile presenta confianza, nutrientes aproximados, incertidumbres, score y alertas clinicas.
- El usuario puede renombrar, agregar o retirar ingredientes y solicitar una reevaluacion sin volver a enviar la imagen.
- Al editar ingredientes, mobile oculta el score anterior y marca la evaluacion como pendiente hasta recibir la reevaluacion.
- Las imagenes siguen sin persistirse en NutriEdu; las correcciones tampoco se guardan todavia.

Privacidad y responsabilidad:

- La API key vive solo en backend.
- La autorizacion se solicita antes de enviar bytes al proveedor externo.
- La extraccion visual se limita a observaciones y estimaciones; el motor clinico determinista genera la compatibilidad.
- `store: false` evita almacenamiento de la respuesta para recuperacion posterior, pero no sustituye la revision de las politicas de tratamiento del proveedor.

Archivos principales:

- `nutriedu-backend/services/vision/foodAnalysisSchema.js`
- `nutriedu-backend/services/vision/openAiVisionProvider.js`
- `nutriedu-backend/services/vision/index.js`
- `nutriedu-backend/services/nutritionRuleService.js`
- `nutriedu-backend/controllers/foodAnalysisController.js`
- `nutriedu-backend/routes/foodAnalysisRoutes.js`
- `nutriedu-backend/scripts/visionProviderContractTest.js`
- `nutriedu-backend/scripts/clinicalProfileSmokeTest.js`
- `nutriedu-mobile/src/app/(app)/analyze.tsx`
- `nutriedu-mobile/src/components/food-analysis-review.tsx`
- `nutriedu-mobile/src/types/api.ts`

Validacion:

- `npm run test:vision-contract`: request OpenAI, data URL, esquema estricto y `store: false` verificados sin red.
- Smoke autenticado: proveedor desactivado reportado correctamente.
- Smoke autenticado: analisis sin consentimiento rechazado con HTTP `400`.
- Smoke autenticado: correccion reevaluada y un ingrediente restringido detectado.
- `npm run typecheck`: correcto.
- `npm run lint`: correcto.
- `npx expo install --check`: dependencias compatibles con el mapa local SDK 54.
- `npx expo export --platform all`: 18 rutas exportadas para Android, iOS y web.
- `git diff --check`: correcto.

Limite de validacion actual:

- No se ejecuto una llamada real al proveedor porque `OPENAI_API_KEY` no esta configurada en este entorno.
- El prompt, costos, latencia y precision visual deben calibrarse con un conjunto controlado de imagenes antes de considerarse confiables.

## Movimiento recomendado anterior

Calibrar y endurecer el analisis visual:

- configurar el proveedor en desarrollo y ejecutar imagenes reales autorizadas;
- crear un pequeno dataset de evaluacion con resultados esperados;
- medir precision de ingredientes, porcion, nutrientes, latencia y costo;
- agregar rate limiting, presupuesto por usuario y observabilidad sin registrar imagenes;
- ampliar correcciones manuales a porcion y nutrientes.

### 2026-08-22 - Limites de uso y control preventivo de costo visual

Tipo: endurecimiento operativo previo a habilitar el proveedor real.

Implementacion:

- Se agrego una migracion durable para registrar cada intento de analisis, tokens, costo estimado, estado y error.
- Cada llamada externa debe reservar primero cupo diario del usuario y presupuesto mensual global dentro de una transaccion con bloqueo asesor de PostgreSQL.
- El limite predeterminado es de 5 analisis por usuario por dia UTC.
- El presupuesto mensual predeterminado es de USD 5 y cada solicitud pendiente reserva USD 0.01 para evitar llamadas concurrentes por encima del techo.
- Solicitudes fallidas liberan su reserva; solicitudes exitosas reemplazan la reserva por el costo estimado con los tokens reales devueltos por el proveedor.
- El adaptador OpenAI usa detalle de imagen `low`, razonamiento `minimal` y un maximo de 1400 tokens de salida por defecto, todos configurables.
- Las tarifas de entrada y salida son configurables para que el calculo no quede acoplado permanentemente al precio actual.
- Mobile muestra cuantos analisis quedan disponibles durante el dia y bloquea la accion al llegar a cero.
- No se configuro una API key ni se ejecuto una llamada facturable durante este movimiento.

Archivos principales:

- `nutriedu-backend/migrations/002_vision_usage_limits.sql`
- `nutriedu-backend/services/visionUsageService.js`
- `nutriedu-backend/services/vision/openAiVisionProvider.js`
- `nutriedu-backend/controllers/foodAnalysisController.js`
- `nutriedu-mobile/src/app/(app)/analyze.tsx`
- `nutriedu-mobile/src/types/api.ts`

Estado de configuracion:

- La migracion `002_vision_usage_limits.sql` debe ejecutarse en Supabase antes de cambiar `VISION_PROVIDER` a `openai`.
- La clave y el saldo prepago pueden configurarse mas adelante; el resto del proyecto puede continuar mientras el proveedor permanezca deshabilitado.

Validacion:

- `npm run test:vision-contract`: detalle `low`, razonamiento `minimal`, limite de salida, esquema estricto y costo estimado verificados sin red.
- `npm run test:vision-usage`: limite diario, presupuesto mensual y liberacion de reservas fallidas verificados sin red.
- Caso contractual de 4000 tokens de entrada y 800 de salida: costo estimado de USD 0.0026.
- `npm run typecheck`: correcto.
- `npm run lint`: correcto.
- `npx expo export --platform all`: 18 rutas exportadas para Android, iOS y web.
- Smoke autenticado contra Supabase: correcto con proveedor deshabilitado; no hubo llamadas facturables.

## Movimiento recomendado anterior

- Ejecutar `002_vision_usage_limits.sql` en Supabase cuando decidamos habilitar vision real.
- Mantener `VISION_PROVIDER=disabled` hasta entonces.
- Continuar con correccion manual de porcion y nutrientes o con el siguiente modulo mobile sin necesidad de configurar facturacion ahora.

### 2026-08-22 - Correccion manual de porcion y nutrientes

Tipo: cierre de revision humana para el analisis visual estructurado.

Implementacion:

- El usuario puede corregir la descripcion y el peso estimado de la porcion.
- Los ocho nutrientes del esquema son editables: calorias, proteina, carbohidratos, grasa, grasa saturada, azucar, fibra y sodio.
- Los campos numericos aceptan decimales, conservan valores desconocidos en blanco y muestran sus unidades.
- Una correccion marca la evaluacion como pendiente y oculta score y alertas anteriores hasta reevaluar.
- La accion de reevaluacion se bloquea visual y funcionalmente ante ingredientes vacios o numeros fuera de rango.
- El backend normaliza decimales y aplica limites conservadores a porciones, ingredientes y nutrientes; la app no es la frontera de seguridad.
- La reevaluacion sigue siendo local al motor de reglas y no consume una segunda llamada de IA.
- En desarrollo, una imagen validada puede abrir un resultado de prueba tipado para revisar toda la interfaz sin proveedor ni costo; la accion se oculta fuera de `__DEV__`.

Archivos principales:

- `nutriedu-mobile/src/components/food-analysis-review.tsx`
- `nutriedu-mobile/src/fixtures/food-analysis-review.ts`
- `nutriedu-mobile/src/app/(app)/analyze.tsx`
- `nutriedu-backend/services/vision/foodAnalysisSchema.js`
- `nutriedu-backend/scripts/visionProviderContractTest.js`

Validacion:

- `npm run typecheck`: correcto.
- `npm run lint`: correcto, sin advertencias.
- `npm run test:vision-contract`: respuesta normal aceptada y calorias fuera de rango rechazadas.
- Smoke autenticado contra Supabase: correccion y reevaluacion clinica correctas con proveedor deshabilitado.
- `npx expo export --platform all`: 18 rutas exportadas para Android, iOS y web.
- No se ejecuto ninguna llamada facturable.

## Movimiento recomendado anterior

- Confirmar en Expo la edicion con teclado decimal, campos vacios, errores y reevaluacion usando `Abrir resultado de prueba`.
- Iniciar Fase 5 con intake seguro de documentos medicos, consentimiento especifico y pantalla de revision sin actualizar automaticamente el perfil.
- Mantener la extraccion por IA deshabilitada hasta definir tipos de documento, retencion y datos que el usuario debe confirmar.

### 2026-08-22 - Fase 5: intake seguro de documentos medicos

Tipo: primer incremento funcional de documentos sensibles, sin IA ni persistencia.

Implementacion:

- Se agrego una pantalla autenticada accesible desde `Perfil > Salud > Documentos medicos`, sin saturar la navegacion inferior.
- El usuario puede fotografiar una formula o elegir un PDF, JPEG o PNG del dispositivo.
- Las fotos de camara se normalizan a JPEG, ancho maximo de 2000 px y compresion 0.85 para compatibilidad y menor transferencia.
- Se definen cinco tipos: formula o receta, laboratorio, indicacion nutricional, resumen clinico y otro.
- Cada carga exige consentimiento explicito version `1.0` con finalidad de extraccion medica.
- El endpoint autenticado acepta un archivo de hasta 10 MB, usa memoria temporal de la solicitud y valida MIME y firma binaria.
- La respuesta declara `retained: false`, `extraction: null` y `profileUpdated: false`.
- No se almacena el documento, no se simulan hallazgos y ninguna condicion o meta se modifica automaticamente.
- Se incorporo `expo-document-picker` en version compatible con Expo SDK 54.

Archivos principales:

- `nutriedu-backend/controllers/medicalDocumentController.js`
- `nutriedu-backend/routes/medicalDocumentRoutes.js`
- `nutriedu-backend/server.js`
- `nutriedu-backend/scripts/clinicalProfileSmokeTest.js`
- `nutriedu-mobile/src/app/(app)/medical-documents.tsx`
- `nutriedu-mobile/src/app/(app)/profile.tsx`
- `nutriedu-mobile/src/app/(app)/_layout.tsx`
- `nutriedu-mobile/src/types/api.ts`

Validacion:

- `node --check` para controlador y ruta: correcto.
- `npm run typecheck`: correcto.
- `npm run lint`: correcto, sin advertencias.
- `npx expo install --check`: dependencias compatibles con el mapa local de SDK 54.
- Smoke autenticado: PDF valido aceptado, sin retencion ni actualizacion de perfil.
- Smoke autenticado: documento sin consentimiento rechazado con HTTP `400`.
- Smoke autenticado: archivo falso con MIME PDF rechazado con HTTP `415`.
- `npx expo export --platform all`: 20 rutas exportadas para Android, iOS y web.
- No se ejecuto IA ni se genero costo externo.

Riesgo de dependencias conocido:

- `npm install` sigue informando vulnerabilidades transitivas moderadas y altas de Expo; no se aplico `npm audit fix --force` porque exige cambios incompatibles con SDK 54.

## Movimiento recomendado anterior

- Definir un esquema versionado para texto, medicamentos, indicaciones, posibles condiciones, restricciones y metas detectadas.
- Crear una pantalla de revision donde cada dato propuesto pueda aceptarse, corregirse o descartarse por separado.
- Mantener la aplicacion al perfil como una accion posterior, explicita y auditada; ningun resultado de IA debe confirmarse solo.

### 2026-08-22 - Fase 5: esquema y revision humana de hallazgos medicos

Tipo: segundo incremento funcional de documentos sensibles, todavia sin proveedor de extraccion ni escritura clinica.

Implementacion:

- Se definio el esquema estructurado `1.0` para resumen, fecha, profesional, medicamentos, posibles condiciones, indicaciones alimentarias, metas nutricionales e incertidumbres.
- Cada hallazgo tiene ID estable y confianza `low`, `medium` o `high`.
- El backend limita cantidades, longitudes, fechas, campos nutricionales, unidades y rangos numericos.
- IDs duplicados, metas desconocidas y selecciones que no existen en la extraccion son rechazadas.
- `POST /api/medical-documents/review` recibe la extraccion corregida y `acceptedFindingIds`, y devuelve los hallazgos aceptados agrupados.
- La respuesta de revision siempre declara `profileUpdated: false` y exige una operacion posterior para aplicar cambios.
- Mobile permite aceptar o descartar cada hallazgo mediante checkbox.
- Medicamentos, condiciones e indicaciones pueden corregirse como texto antes de revisar.
- Las metas permiten corregir campo, valor, unidad derivada y periodo por dia o por comida.
- El teclado se mantiene visible mediante una vista ajustable y los valores invalidos bloquean la confirmacion.
- En desarrollo, `Abrir extraccion de prueba` usa el contrato y endpoint reales sin ejecutar OCR o IA.

Archivos principales:

- `nutriedu-backend/services/medicalDocument/medicalDocumentSchema.js`
- `nutriedu-backend/controllers/medicalDocumentController.js`
- `nutriedu-backend/routes/medicalDocumentRoutes.js`
- `nutriedu-backend/scripts/medicalDocumentSchemaContractTest.js`
- `nutriedu-backend/scripts/clinicalProfileSmokeTest.js`
- `nutriedu-mobile/src/components/medical-document-review.tsx`
- `nutriedu-mobile/src/fixtures/medical-document-review.ts`
- `nutriedu-mobile/src/app/(app)/medical-documents.tsx`
- `nutriedu-mobile/src/types/api.ts`

Validacion:

- `npm run test:medical-document-schema`: esquema, seleccion, ID inexistente y rango invalido verificados sin red.
- `node --check` para esquema y controlador: correcto.
- `npm run typecheck`: correcto.
- `npm run lint`: correcto, sin advertencias.
- Smoke autenticado: 3 hallazgos aceptados, estado `reviewed` y `profileUpdated: false`.
- `npx expo export --platform all`: 20 rutas exportadas para Android, iOS y web.
- No se ejecuto OCR, IA ni una operacion facturable.

## Siguiente movimiento recomendado

- Crear una migracion de auditoria para revisiones y aplicaciones de hallazgos, sin guardar el archivo medico.
- Resolver condiciones aceptadas contra `condiciones_clinicas` y rechazar codigos no catalogados.
- Crear un endpoint `apply` separado que muestre exactamente que campos cambiara y exija confirmacion final.
- Implementar proveedor de extraccion solo despues de cerrar auditoria, aplicacion y politica de retencion.

### 2026-08-22 - Fase 5: vista previa y aplicacion clinica auditada

Tipo: tercer incremento funcional de documentos sensibles, sin OCR ni proveedor de IA.

Implementacion:

- Se creo `migrations/003_medical_document_audit.sql` con revisiones y aplicaciones separadas.
- La migracion guarda extraccion estructurada, seleccion del usuario y cambios aplicados; nunca guarda PDF o imagen original.
- El backend resuelve condiciones aceptadas unicamente contra codigos activos de `condiciones_clinicas`.
- Codigos desconocidos, metas repetidas y metas por comida son rechazados antes de modificar el perfil.
- La vista previa muestra condiciones que se agregaran o ya existen, y valores nutricionales actuales y propuestos.
- Medicamentos e indicaciones libres quedan visibles en auditoria, pero no se escriben en campos de perfil inexistentes.
- Las condiciones nuevas se agregan sin borrar condiciones previas.
- Las metas diarias actualizan solo los campos aceptados y conservan los demas valores existentes.
- La confirmacion usa un hash SHA-256 de la vista previa; si el perfil cambia, el backend exige revisar de nuevo.
- La aplicacion usa una transaccion, registra el resultado y rechaza una segunda aplicacion con HTTP `409`.
- Mobile incorpora una pantalla final con cambios exactos, exclusiones, checkbox y estado aplicado.

Archivos principales:

- `nutriedu-backend/migrations/003_medical_document_audit.sql`
- `nutriedu-backend/services/medicalDocument/medicalDocumentProfileChanges.js`
- `nutriedu-backend/services/medicalDocument/medicalDocumentApplicationService.js`
- `nutriedu-backend/controllers/medicalDocumentController.js`
- `nutriedu-backend/routes/medicalDocumentRoutes.js`
- `nutriedu-backend/scripts/medicalDocumentProfileChangesContractTest.js`
- `nutriedu-mobile/src/components/medical-document-application-preview.tsx`
- `nutriedu-mobile/src/components/medical-document-review.tsx`
- `nutriedu-mobile/src/app/(app)/medical-documents.tsx`
- `nutriedu-mobile/src/types/api.ts`

Validacion actual:

- `npm run test:medical-document-schema`: correcto.
- `npm run test:medical-document-profile`: correcto; valida catalogo, periodo, exclusiones y hash determinista.
- `node --check` para controlador, rutas y servicios medicos: correcto.
- `npm run typecheck`: correcto despues de la integracion final.
- `npm run lint`: correcto, sin errores ni advertencias.
- `npx expo export --platform all`: 20 rutas exportadas para Android, iOS y web.
- Antes de migrar localmente, el smoke confirmo el bloqueo seguro `503 MEDICAL_DOCUMENT_AUDIT_MIGRATION_REQUIRED`.
- Despues de ejecutar `003`, el smoke autenticado verifico 3 hallazgos revisados, 2 cambios previstos, aplicacion correcta y rechazo de segunda aplicacion con HTTP `409`.
- No se ejecuto OCR, IA ni una operacion facturable.

Estado operativo:

- Codigo y UI: implementados.
- Migracion local en repositorio: preparada.
- Migracion remota en Supabase: ejecutada correctamente por el usuario.
- Migracion de desarrollo local: ejecutada correctamente sobre la base `nutriedu`.
- Smoke de aplicacion completa: correcto.

## Siguiente movimiento recomendado

- Probar en Expo con la extraccion de desarrollo y confirmar que Perfil refleja hipertension y sodio maximo.
- Definir politica de retencion de hallazgos antes de conectar un proveedor real de documentos.

### 2026-08-22 - Fase 5: retencion e historial medico

Tipo: cuarto incremento funcional de documentos sensibles y evaluacion de producto.

Implementacion:

- Se definio politica versionada `1.0`: archivo original sin retencion, revision no aplicada por 30 dias y auditoria aplicada hasta eliminar la cuenta.
- Se creo `migrations/004_medical_document_retention.sql` con `retention_policy_version`, `expires_at` e indice parcial de expiracion.
- La migracion `004` fue aplicada a la base local `nutriedu`; queda pendiente en Supabase.
- `GET /api/medical-documents/history` lista revisiones con paginacion por cursor.
- `GET /api/medical-documents/history/:reviewId` devuelve hallazgos y aplicacion estructurada del usuario autenticado.
- `DELETE /api/medical-documents/history/:reviewId` elimina solo revisiones no aplicadas.
- Intentar eliminar una auditoria aplicada responde HTTP `409`.
- `npm run cleanup:medical-reviews` elimina revisiones vencidas y puede ejecutarse desde cron.
- Mobile incorpora `Historial medico` dentro de Perfil > Salud, sin ocupar una pestana inferior.
- El historial muestra estado, resumen, fecha, expiracion, hallazgos aceptados y politica aplicable.
- La eliminacion usa confirmacion nativa y declara que no modifica el perfil.
- Se corrigio una futura incompatibilidad con `pg@9`: las consultas de un mismo cliente transaccional ahora son secuenciales.

Evaluacion de producto:

- Se creo `docs/backlog_modulos_producto.md` con prioridades para privacidad, notificaciones, admin, progreso, offline y colaboracion profesional.
- El siguiente bloque recomendado es eliminacion de cuenta y centro de privacidad.
- Notificaciones deben comenzar con bandeja y preferencias; push remoto requiere development build y no debe bloquear el MVP.
- El admin debe evolucionar desde recetas e ingredientes hacia catalogos, reglas, costos y auditoria con permisos separados.

Validacion actual:

- `node --check` para controlador, rutas, historia, aplicacion y cleanup: correcto.
- Contratos de esquema y aplicacion medica: correctos.
- Smoke autenticado: historial aplicado correcto, eliminacion aplicada rechazada `409`, revision no aplicada eliminada y cleanup de expiracion con 1 registro.
- `npm run typecheck`: correcto.
- `npm run lint`: correcto, sin advertencias.
- `npx expo export --platform all`: correcto, 22 rutas para Android, iOS y web.
- `npm run cleanup:medical-reviews`: correcto e idempotente; segunda ejecucion con `deletedCount: 0`.
- No se ejecuto OCR, IA ni una operacion facturable.

Estado operativo:

- Backend y mobile: implementados.
- Migracion local `004`: aplicada.
- Migracion Supabase `004`: ejecutada correctamente por el usuario.
- Backend local: activo en puerto `3002`.

## Siguiente movimiento recomendado

- Ejecutar `nutriedu-backend/migrations/004_medical_document_retention.sql` en Supabase SQL Editor.
- Probar Perfil > Salud > Historial medico en Expo.
- Implementar eliminacion de cuenta y centro de privacidad.
- Despues, iniciar bandeja de notificaciones y preferencias antes de push remoto.

### 2026-08-22 - Privacidad: eliminacion integral de cuenta

Tipo: seguridad, privacidad y ciclo de vida de cuenta.

Implementacion:

- Se agrego `npm run audit:user-deletion` para inspeccionar todas las claves foraneas directas hacia `usuarios`.
- La auditoria inicial encontro dos relaciones inseguras: `plan_semanal` y `usuario_restricciones` usaban `NO ACTION`.
- Se creo `migrations/005_account_deletion_cascades.sql` para convertir ambas relaciones a `ON DELETE CASCADE`.
- La migracion `005` fue aplicada localmente y la auditoria final confirmo 9 de 9 relaciones con cascada.
- `DELETE /api/users/account` exige JWT, contrasena actual y confirmacion `DELETE_MY_ACCOUNT`.
- La eliminacion ocurre dentro de una transaccion y captura dependencias inesperadas sin borrar parcialmente.
- El ultimo administrador no puede eliminar su propia cuenta hasta asignar otro administrador.
- `verifyToken` ahora confirma que el usuario siga existiendo; un JWT de una cuenta eliminada recibe HTTP `401`.
- Mobile incorpora `Privacidad y cuenta` dentro de Perfil > Personal.
- El centro muestra la retencion medica activa, enlaza al historial y enumera los grupos de datos eliminados.
- La UI exige contrasena, checkbox y una segunda confirmacion nativa destructiva.
- Tras eliminar, SecureStore/localStorage se limpia y la sesion vuelve al login.

Validacion:

- Auditoria de claves foraneas: `ok: true`, 9 relaciones seguras y 0 inseguras.
- Contrasena incorrecta: HTTP `401`.
- Cuenta temporal completa eliminada correctamente.
- JWT anterior despues de borrar: HTTP `401`.
- Conteos restantes para usuario, perfil, restricciones, revisiones y aplicaciones: todos `0`.
- `npm run typecheck`: correcto.
- `npm run lint`: correcto, sin advertencias.
- `npx expo export --platform all`: correcto, 24 rutas para Android, iOS y web.

Estado operativo:

- Backend y mobile: implementados.
- Migracion local `005`: aplicada.
- Migracion Supabase `005`: pendiente.
- Backend local: activo en puerto `3002`.

## Siguiente movimiento recomendado

- Ejecutar `nutriedu-backend/migrations/005_account_deletion_cascades.sql` en Supabase SQL Editor.
- Probar Perfil > Personal > Privacidad y cuenta con una cuenta de prueba, nunca con la cuenta administradora principal.
- Iniciar bandeja de notificaciones y preferencias como siguiente modulo de uso diario.

### 2026-08-22 - Paginacion de recetas y base i18n mobile

Tipo: rendimiento del catalogo y arquitectura de internacionalizacion.

Implementacion:

- `GET /api/recipes/search/:userId` acepta ahora `paginated=true`, `limit` y `offset`.
- El contrato historico sin paginacion conserva el arreglo de recetas para no romper el frontend web.
- La consulta paginada solicita una fila adicional para calcular `hasMore` sin ejecutar un conteo completo.
- El orden incluye ID como ultimo criterio para mantener paginas estables.
- Mobile carga 12 recetas inicialmente y permite solicitar el siguiente bloque de forma explicita.
- Cambiar filtros reemplaza la pagina actual; refrescar vuelve al inicio y cargar mas deduplica por ID.
- Una secuencia de solicitud impide mezclar respuestas obsoletas cuando el usuario escribe o cambia filtros rapidamente.
- Se incorporaron `i18next`, `react-i18next` y `expo-localization` compatibles con Expo SDK 54.
- La app detecta espanol o ingles desde el dispositivo y conserva la eleccion manual mediante SecureStore o localStorage.
- El centro de privacidad incluye un selector de idioma accesible.
- Pestanas, encabezados, catalogo, filtros, tarjetas y detalle de recetas ya usan recursos traducibles.
- Los nombres y descripciones de recetas siguen usando el contenido almacenado en PostgreSQL; traducir datos editoriales requerira un modelo de contenido localizado separado.

Validacion:

- Smoke autenticado completo: respuesta paginada de limite 2 correcta y contrato historico conservado.
- Smoke clinico, evaluacion de recetas y eliminacion integral de cuenta: correctos.
- `node --check` del controlador y smoke: correcto.
- `npm run typecheck`: correcto.
- `npm run lint`: correcto, sin errores ni advertencias.
- `npx expo export --platform all`: correcto, 24 rutas para Android, iOS y web.

Estado operativo:

- Backend local actualizado y activo en puerto `3002`.
- No requiere una migracion de base de datos.
- i18n es incremental: recetas y navegacion estan completas; los demas modulos permanecen principalmente en espanol.

## Siguiente movimiento recomendado

- Probar cargar mas, cambiar filtros durante una busqueda y alternar idioma desde Privacidad y cuenta.
- Completar i18n en autenticacion, perfil, analisis, plan y compras por modulos, evitando una traduccion masiva sin revision.
- Iniciar bandeja de notificaciones y preferencias como siguiente incremento funcional, antes de notificaciones locales o push.

### 2026-08-22 - Bandeja de notificaciones y preferencias

Tipo: modulo de uso diario sin push ni proveedor externo.

Implementacion:

- Se creo `migrations/006_in_app_notifications.sql` con preferencias e inbox durable.
- Las preferencias incluyen zona horaria, horas silenciosas y categorias de comidas, plan, compras, seguimiento y seguridad.
- La bandeja usa cursor por ID, limite maximo de 50, conteo de no leidas e indices parciales para consultas frecuentes.
- Los registros usan `ON DELETE CASCADE`; la auditoria confirma 11 de 11 referencias de usuario seguras.
- La API permite listar, marcar una, marcar todas, consultar preferencias y actualizarlas.
- La pertenencia se obtiene siempre desde el JWT; no se aceptan IDs de usuario enviados por el cliente.
- Las preferencias desactivadas impiden crear eventos de esa categoria.
- Registro y guardado del plan generan eventos internos no bloqueantes.
- Los eventos guardan un tipo estable y copy seguro de respaldo, sin datos clinicos sensibles.
- Mobile incorpora Perfil > Personal > Notificaciones, sin agregar otra pestana inferior.
- La pantalla separa Bandeja y Preferencias, carga mas por cursor y abre solo destinos internos permitidos.
- Los eventos usan claves traducibles; en la version actual solo espanol esta habilitado publicamente.
- Las horas silenciosas quedan preparadas para recordatorios futuros, pero todavia no programan notificaciones del sistema.

Validacion:

- Migracion `006`: aplicada correctamente en la base local.
- Smoke autenticado: pagina de 2 elementos, 3 no leidas iniciales y cursor siguiente correcto.
- Marcar una y marcar todas: conteo final de no leidas en 0.
- Categoria desactivada: insercion suprimida correctamente.
- Horas silenciosas `22:00` a `06:00`: persistencia verificada.
- Eliminacion de cuenta: preferencias y notificaciones restantes en 0.
- Auditoria FK: 11 relaciones seguras, 0 inseguras.
- `npm run typecheck` y `npm run lint`: correctos.
- `npx expo export --platform all`: correcto, 26 rutas para Android, iOS y web.

Estado operativo:

- Backend local actualizado y activo en puerto `3002`.
- Migracion local `006`: aplicada.
- Migracion Supabase `006`: pendiente.
- Push remoto, tokens de dispositivo y permisos del sistema: no implementados deliberadamente.

## Siguiente movimiento recomendado

- Ejecutar `005_account_deletion_cascades.sql` y despues `006_in_app_notifications.sql` en Supabase.
- Probar Profile > Personal > Notifications: idioma, lectura, categorias y horas silenciosas.
- Continuar con recordatorios locales configurables o con la migracion i18n del siguiente modulo; push remoto permanece posterior al development build.

### 2026-08-22 - Correccion de rollout i18n incompleto

Tipo: correccion de consistencia de producto.

Problema detectado:

- Ingles se habilito cuando solo navegacion, recetas y notificaciones usaban recursos traducidos.
- Autenticacion, perfil, plan, compras, analisis y documentos conservaban copy estatico en espanol.
- Catalogos, recetas y alertas clinicas tambien llegan en espanol desde PostgreSQL y el backend.
- El resultado era una interfaz mezclada, aunque cada modulo traducido funcionara de forma aislada.

Correccion:

- Espanol vuelve a ser el unico idioma habilitado para usuarios.
- Una preferencia `en` guardada anteriormente se reemplaza por `es` al iniciar la app.
- Se retiro el selector de idioma del centro de privacidad.
- Se retiro `expo-localization` y su declaracion nativa mientras no exista un segundo idioma completo.
- `i18next` y `react-i18next` permanecen como arquitectura interna.
- Los recursos ingleses parciales se conservan como trabajo de desarrollo, pero no se anuncian ni activan.

Criterio para reactivar ingles:

- todo el copy estatico de mobile debe usar claves i18n;
- objetivos, condiciones, restricciones y recetas necesitan campos o tablas de traduccion;
- alertas y errores del backend necesitan codigos estables que mobile pueda localizar;
- ambos idiomas deben superar un recorrido completo de autenticacion, perfil, recetas, plan, analisis, documentos, compras, privacidad y notificaciones.

## Siguiente movimiento recomendado

- Reiniciar Expo para que la restauracion cambie cualquier preferencia inglesa previa a espanol.
- Disenar primero el contrato de contenido localizado del backend; despues traducir la UI por modulos.
- No volver a mostrar el selector hasta completar la matriz de pruebas de ambos idiomas.

### 2026-08-22 - Preferencias de avisos y control de migraciones

Tipo: correccion de experiencia mobile y operacion de base de datos.

Problema detectado:

- La zona horaria era un campo de texto libre, por lo que aceptaba valores que el backend no podria usar de forma confiable para programar recordatorios.
- Los switches no tenian una columna estable y su relacion con titulo y descripcion era dificil de leer.
- Las migraciones se ejecutaban manualmente y no existia un ledger para saber que versiones habian sido registradas en cada base.

Implementacion:

- La zona horaria ahora se elige desde un modal buscable con nombre de ciudad, identificador IANA y offset UTC.
- La lista inicial prioriza zonas comunes de Latinoamerica e incluye UTC, Espana, Estados Unidos y Canada.
- Cada categoria muestra icono, titulo, descripcion funcional y un switch alineado en una columna fija.
- Se agregaron textos explicativos para zona horaria, horas silenciosas y categorias.
- Se creo `scripts/runMigrations.js` con seleccion explicita de versiones, checksums SHA-256, advisory lock y tabla `schema_migrations`.
- Se agregaron `npm run migrate` y `npm run migrate:status`.
- Las migraciones `005` y `006` quedaron aplicadas y registradas en PostgreSQL local.
- El ledger comienza en `005`; `001` a `004` ya existian localmente antes de crear el runner y aparecen como no registradas, no como esquema ausente.

Validacion:

- Recorrido real en viewport `390x844`: registro, Perfil, Notificaciones, Preferencias y apertura del selector de zona horaria.
- Consola del navegador: 0 errores.
- La cuenta temporal de la prueba se elimino mediante el endpoint autenticado de eliminacion de cuenta.
- `npm run typecheck`: correcto.
- `npm run lint`: correcto.
- `npx expo export --platform all`: correcto, 26 rutas para Android, iOS y web.
- `npm run migrate:status`: `005` y `006` registradas localmente.
- Smoke clinico completo: correcto, incluidos avisos, preferencias, horas silenciosas y cascadas sin registros huerfanos.

Estado operativo:

- Backend local activo en puerto `3002` con la configuracion normal del proyecto.
- `.env` de mobile restaurado a la direccion LAN usada por Expo Go.
- Supabase aun no fue modificado: el workspace no contiene `DATABASE_URL` de produccion ni una sesion autenticada de Supabase CLI.
- El intento con Supabase CLI se detuvo de forma segura antes de conectarse por falta de `SUPABASE_ACCESS_TOKEN` o `supabase login`.

## Siguiente movimiento recomendado

- Autenticar Supabase CLI localmente sin pegar secretos en el repositorio ni en el chat.
- Ejecutar `npm run migrate -- 005 006` con `DATABASE_URL` apuntando al pooler de Supabase y confirmar con `npm run migrate:status`.
- Continuar con recordatorios locales programados usando estas preferencias; las preferencias actuales guardan la politica, pero todavia no disparan avisos del sistema.

### 2026-08-22 - Baseline seguro para migraciones ya ejecutadas

Tipo: correccion del proceso de produccion.

Contexto:

- Se confirmo que `005` y `006` pudieron haberse ejecutado anteriormente mediante Supabase SQL Editor.
- Volver a ejecutar SQL solo para llenar un ledger no es una practica segura ni necesaria.

Implementacion:

- Se agrego `npm run migrate:baseline -- 005 006`.
- El modo baseline no ejecuta los archivos SQL.
- Para `005`, verifica las dos llaves foraneas esperadas y `ON DELETE CASCADE` hacia `usuarios`.
- Para `006`, verifica tablas, todas las columnas del contrato, ambos indices y cascadas hacia `usuarios`.
- Solo despues de superar esas comprobaciones registra nombre, version y checksum en `schema_migrations`.
- Una version sin verificador explicito es rechazada; no existe baseline generico o basado en suposiciones.

Validacion local:

- `005`: esquema verificado y registro existente respetado.
- `006`: esquema verificado y registro existente respetado.
- No se volvio a ejecutar ninguna de las dos migraciones.

Estado Supabase:

- Pendiente unicamente de acceso a la conexion PostgreSQL de produccion.
- `.env.production.local` esta protegido por `.gitignore` y es el lugar previsto para proporcionar temporalmente `DATABASE_URL` y `DB_SSL=true`.

### 2026-08-23 - Fundacion de repositorios, CI y medicion de avance

Tipo: preparacion profesional para entrega continua.

Implementacion:

- Se confirmo que backend y frontend son repositorios independientes conectados a Render y Vercel.
- El repositorio raiz `master` se clasifico como workspace heredado con gitlinks incompletos; no se usara para despliegues.
- Mobile se inicializo como tercer repositorio Git independiente en rama `main`.
- Backend y frontend se movieron a ramas locales `chore/release-readiness`, evitando despliegues automaticos durante la preparacion.
- Se retiraron `.env` y `.env copy.example` del seguimiento Git sin borrar las copias locales.
- Se agrego CI independiente para backend, frontend y mobile.
- Backend CI ejecuta cuatro contratos deterministas y validacion sintactica sin base de datos ni secretos.
- Frontend CI exige lint sin advertencias y build de produccion.
- Mobile CI exige typecheck, lint y export para Android, iOS y web.
- Se corrigieron tres advertencias de dependencias de Hooks y se cancela el debounce de busqueda al cambiar filtros.
- Se crearon commits locales de preservacion para los tres productos; todavia no se publicaron ni desplegaron.

Validacion:

- Backend: cuatro contratos correctos, incluidos limites diarios/mensuales de IA y hash medico determinista.
- Frontend: 0 errores, 0 advertencias y build correcto.
- Mobile: typecheck, lint y export de 26 rutas correctos.
- Auditoria de staging: ningun `.env`, secreto, `node_modules`, cache Expo o `dist` incluido.

Dashboard de avance:

| Area | Avance | Estado resumido |
| --- | ---: | --- |
| Backend y API | 82% | Contratos clinicos amplios; falta operacion productiva y observabilidad |
| Web de usuario | 85% | Desplegada y estable; queda deuda de sesion, pruebas y localizacion |
| Mobile MVP | 78% | Flujos principales completos en Expo Go; falta distribucion nativa |
| Perfil y reglas clinicas | 80% | Datos, catalogos, metas y evaluacion implementados |
| IA de comida | 65% | Flujo y limites listos; proveedor real sin calibracion productiva |
| Documentos medicos | 60% | Intake, revision y auditoria listos; extraccion real pendiente |
| Notificaciones | 45% | Inbox y preferencias listas; recordatorios locales y push pendientes |
| Panel administrativo | 30% | CRUD basico de recetas e ingredientes solamente |
| i18n | 20% | Arquitectura parcial; solo espanol habilitado de forma segura |
| CI, builds y despliegue mobile | 35% | CI local preparado; remoto mobile y EAS pendientes |
| **Preparacion general para produccion** | **69%** | MVP demostrable, aun no release clinico ni de stores |

Siguiente movimiento:

- Configurar recordatorios locales sobre las preferencias existentes.
- Preparar EAS development/preview/production sin activar push remoto todavia.
- Inspeccionar Supabase cuando exista una conexion local protegida.

### 2026-08-23 - Horarios, EAS y administracion operativa

Tipo: segundo incremento de preparacion para release.

Implementacion de recordatorios:

- Se creo `007_notification_schedules.sql` para horarios de desayuno, almuerzo, cena, plan semanal y compras.
- La API valida objetos de horarios, dias de semana entre 0 y 6 y horas `HH:MM`.
- Mobile muestra selectores de hora en intervalos de 30 minutos y controles segmentados de dia; no usa texto libre para estos valores.
- El contrato smoke incluye persistencia de los nuevos horarios.
- La entrega nativa permanece desacoplada: todavia no se solicitan permisos ni se programan avisos del sistema.

Configuracion de builds:

- Android e iOS usan `com.xrhon0s.nutriedu` como identidad nativa.
- `eas.json` define development, preview interno y production con incremento remoto de version.
- `.easignore` excluye dependencias, builds, caches y variables locales.
- Expo resuelve correctamente SDK 54, runtime por version, bundle ID y package Android.

Administracion:

- `GET /api/admin/overview` expone solo metricas agregadas protegidas por JWT y rol administrador.
- El resumen incluye cobertura de perfiles, catalogos, avisos sin leer, consumo/presupuesto de IA y ledger de migraciones.
- Se excluyen filas de usuario, datos clinicos, contrasenas, tokens y secretos.
- Se agregaron rutas reales para editar y eliminar ingredientes; las llamadas existentes del frontend ya no terminan en 404.
- Se retiro el modal de recetas que estaba desconectado de la eliminacion efectiva.
- El panel web ahora separa Operacion, Recetas e Ingredientes en una superficie de trabajo compacta.

Validacion disponible:

- Backend: sintaxis correcta y cinco contratos deterministas correctos.
- Contrato admin: 70% de cobertura de perfil calculada, siete migraciones descubiertas y campos sensibles ausentes.
- Frontend: lint estricto con 0 advertencias y build correcto.
- Mobile: typecheck y lint correctos; configuracion Expo/EAS valida.

Bloqueos externos actuales:

- El sistema de aprobaciones alcanzo su limite temporal al intentar instalar `expo-notifications` y ejecutar la migracion local `007`.
- No se intento eludir el bloqueo; ambos comandos requieren autorizacion cuando vuelva a estar disponible.
- EAS aun necesita login, vinculacion de proyecto, `expo-dev-client`, credenciales de firma y primer build real.
- Supabase sigue sin una conexion local protegida para inspeccion.

Dashboard actualizado:

| Area | Avance | Cambio |
| --- | ---: | --- |
| Backend y API | 86% | Horarios y overview admin agregados |
| Web de usuario/admin | 88% | Admin operativo y CRUD de ingredientes reparado |
| Mobile MVP | 80% | UI de horarios y configuracion nativa preparadas |
| Notificaciones | 60% | Inbox, preferencias y horarios; entrega nativa pendiente |
| Panel administrativo | 50% | Operacion agregada; catalogos clinicos y auditoria pendientes |
| CI, builds y despliegue mobile | 55% | Perfiles EAS listos; remoto y builds reales pendientes |
| **Preparacion general para produccion** | **80%** | Fundaciones completas; integraciones nativas/productivas pendientes |

Preservacion y cierre del incremento:

- Backend `chore/release-readiness`: `374d222` y `fea2eb0`.
- Frontend `chore/release-readiness`: `2244ab9` y `9f9339e`.
- Mobile `main`: `747e956` y `9241aa4`.
- Ninguna rama fue publicada ni fusionada a las ramas de despliegue.
- Verificacion final repetida: cinco contratos backend, sintaxis, lint web sin advertencias, build Vite, typecheck mobile, lint mobile y export Android/iOS/web correctos.
- Preparacion general verificada al cierre: **81%**.

### 2026-08-23 - Entrega local de recordatorios

Tipo: integracion nativa mobile y verificacion de migracion.

Implementacion:

- Se ejecuto localmente `007_notification_schedules.sql` mediante el runner; quedo registrada con checksum en `schema_migrations`.
- Se instalaron versiones compatibles con Expo SDK 54 de `expo-notifications` y `expo-dev-client`.
- Guardar preferencias ahora cancela y reconstruye solamente los recordatorios que pertenecen a NutriEdu.
- Comidas usan recurrencia diaria; plan semanal y compras usan recurrencia semanal.
- Los intervalos de horas silenciosas funcionan tanto dentro del mismo dia como al cruzar medianoche.
- El permiso del sistema solo se solicita cuando existe al menos un recordatorio activo.
- Si el permiso es rechazado, la preferencia queda guardada y la UI explica como habilitar la entrega en el dispositivo.
- Los avisos no muestran informacion clinica y abren exclusivamente Plan o Compras mediante destinos permitidos.
- Android usa un canal privado sin sonido ni badge; iOS solicita alertas sin sonido ni badge.
- El modulo nativo se carga de forma diferida para no ejecutar Expo Notifications durante el render estatico web.
- La configuracion Expo incluye un icono monocromatico propio derivado del emblema NutriEdu, color de marca y canal por defecto; se retiro el placeholder visual de Expo para los avisos.

Validacion:

- API reiniciada con el codigo actual en `http://localhost:3002`.
- Smoke clinico completo correcto contra PostgreSQL, incluida persistencia de preferencias y limpieza en cascada.
- Mobile: typecheck y lint correctos.
- Export Android/iOS/web correcto para 26 rutas.
- Export web repetido sin el error de `localStorage` que producia la carga estatica del modulo nativo.
- Pendiente: confirmar permiso, disparo y apertura del aviso en un development build fisico; compilacion no sustituye esa prueba.

Estado operativo:

- Migracion `007`: aplicada localmente; Supabase continua sin inspeccion desde este workspace.
- Push remoto: fuera de este incremento; no existen tokens ni proveedor de entrega.
- EAS: configurado localmente; falta login, vinculacion, credenciales y primer build remoto.
- `npm audit` informa 23 hallazgos transitivos en tooling Expo (14 moderados y 9 altos); no se aplicara `--force` porque implicaria cambios mayores sin validacion.

Dashboard actualizado:

| Area | Avance | Estado resumido |
| --- | ---: | --- |
| Backend y API | 87% | Migracion local y contrato de horarios verificados |
| Mobile MVP | 84% | Recordatorios integrados; prueba nativa fisica pendiente |
| Notificaciones | 82% | Inbox, preferencias y entrega local; push remoto pendiente |
| Panel administrativo | 50% | Overview y catalogos basicos; reglas y auditoria pendientes |
| i18n | 25% | Modulo de notificaciones bilingue; cobertura global incompleta |
| CI, builds y despliegue mobile | 62% | Modulos nativos y EAS listos; primer development build pendiente |
| **Preparacion general para produccion** | **87%** | Flujo local integrado; faltan validacion fisica y servicios productivos |

Siguiente movimiento:

- Vincular EAS y crear el primer development build Android para validar recordatorios en hardware.
- Despues, continuar catalogos/reglas del panel administrativo o completar i18n por flujo, sin iniciar push remoto todavia.

### 2026-08-24 - Gate de autenticacion EAS

- `npx eas-cli whoami` confirmo que esta maquina no tiene una sesion Expo activa.
- Se inicio dos veces el flujo oficial de autenticacion por navegador, sin solicitar ni exponer credenciales en terminal o chat.
- Ninguno de los callbacks recibio la aprobacion antes de expirar; ambos procesos se cerraron limpiamente.
- No se vinculo ningun proyecto, no se generaron credenciales y no se inicio ningun build remoto.
- Estado conservado: Expo Go disponible para desarrollo; APK/AAB independiente pendiente de login EAS.

### 2026-08-24 - Proyecto EAS y primer build Android

- Autenticacion confirmada como `apol0x`, propietario de la cuenta personal y `apol0xs-team`.
- Se creo y vinculo `@apol0x/nutriedu-mobile` con project ID `8e9d3e40-5629-4f26-97c1-a55cd6bb80b8`.
- EAS inicializo `versionCode` remoto en `1` y creo el primer keystore Android.
- El build `development` se envio correctamente con ID `75dec52a-0a97-45b6-9d29-d94b333eaf20`; permanece en la cola gratuita al registrar este movimiento.
- Se retiro `channel` de los perfiles porque `expo-updates` no esta instalado; no se declara OTA sin implementar y validar esa capacidad.
- Se retiro `android.versionCode` local porque `appVersionSource` esta configurado como `remote`.
- El development client usara Metro y el `.env` local para acceder a `http://172.20.10.2:3002/api` durante pruebas en la misma red.
- Verificacion Render: restricciones devuelve `401` como ruta existente; profile, notifications y food-analysis devuelven `404`, confirmando que el backend de expansion aun no esta desplegado.
- Por lo anterior, preview y production permanecen bloqueados hasta desplegar y verificar el backend actual.

Avance actualizado:

- EAS y distribucion Android: **90%**; falta completar el build, instalarlo y validar en hardware.
- Preparacion general: **90%**; el siguiente riesgo principal es sincronizar backend productivo antes de builds autonomos.

Estado de publicacion de ramas:

- Se repitieron correctamente cinco contratos backend, lint/build frontend y typecheck/lint mobile antes de publicar.
- Backend y frontend permanecen en `chore/release-readiness`; `main` no fue modificado.
- El intento de publicar las ramas fue detenido por el control de seguridad porque exporta codigo del workspace a GitHub.
- Se requiere confirmacion explicita del propietario de `xrhon0s/NutriEdu` y `xrhon0s/NutriEdu-frontend` antes de reintentar; no se aplico ningun workaround.

Resultado del primer build Android:

- Build `75dec52a-0a97-45b6-9d29-d94b333eaf20`: `FINISHED`.
- Android, distribution `INTERNAL`, development client, SDK 54, version `1.0.0`, build `1`.
- Tiempo remoto total aproximado: 32 minutos, repartido entre unos 16 minutos de cola gratuita y 16 minutos de ejecucion.
- APK disponible hasta el 7 de septiembre de 2026 desde el registro EAS del proyecto.
- EAS y distribucion Android avanzan a **97%**; falta instalar el APK y validar permisos, entrega y navegacion de recordatorios en hardware.
- Preparacion general actualizada a **92%**.

Publicacion autorizada y entorno de prueba:

- El propietario confirmo control de `xrhon0s/NutriEdu` y `xrhon0s/NutriEdu-frontend` y autorizo publicar `chore/release-readiness`.
- Ambas ramas se publicaron correctamente y ahora siguen sus ramas remotas; `main` no fue modificado ni desplegado.
- Pull request backend: `https://github.com/xrhon0s/NutriEdu/pull/new/chore/release-readiness`.
- Pull request frontend: `https://github.com/xrhon0s/NutriEdu-frontend/pull/new/chore/release-readiness`.
- Se detuvo el Metro anterior y se inicio una unica sesion con `npx expo start --dev-client`.
- Metro detecto la LAN actual como `192.168.0.100`; se actualizo el `.env` local ignorado por Git para usar `http://192.168.0.100:3002/api` en lugar de la IP antigua del hotspot.
- Backend local activo en `3002` y Metro development-client activo en `8081`.
- Preparacion general actualizada a **93%**; falta aceptacion en hardware y revision/merge deliberado de las ramas publicadas.

### 2026-08-25 - Development client conectado y pull requests verificados

- El development build Android se instalo y conecto correctamente a Metro mediante el deep link completo del development client.
- La red local activa usa `192.168.1.98`: Metro esta disponible en `8081` y la API local en `3002`.
- Se programo una prueba fisica de recordatorio para las 15:30; entrega, apertura y navegacion siguen pendientes de confirmacion en el dispositivo.
- Se abrio el PR backend `#1`: `https://github.com/xrhon0s/NutriEdu/pull/1`.
- Se abrio el PR frontend `#1`: `https://github.com/xrhon0s/NutriEdu-frontend/pull/1`.
- Backend CI: contrato `contracts` aprobado.
- Frontend CI: `quality`, despliegue preview de Vercel y comentarios preview aprobados.
- Ningun PR fue fusionado y `main` continua sin cambios.

Avance actualizado:

- Aceptacion Android: **90%**; conexion comprobada, recordatorio fisico pendiente.
- Preparacion de release: **85%**; PR y CI listos, faltan revision de migraciones, merge y despliegue controlado.
- Preparacion general: **94%**.

### 2026-08-25 - Baseline completo y auditoria local de migraciones

- La auditoria detecto que el runner solo podia verificar y hacer baseline seguro de `005` y `006`.
- Se agregaron verificadores explicitos para `001-004` y `007`; ahora las siete versiones comprueban sus objetos esenciales antes de registrar un checksum.
- El README backend ahora separa claramente `status`, baseline de versiones ya existentes y aplicacion de versiones pendientes.
- La primera verificacion local registro `001` y se detuvo correctamente al descubrir que `002` no existia; no genero un baseline falso.
- `003` y `004` fueron verificados y baselined; `005-007` ya estaban registrados y se conservaron.
- La migracion realmente ausente `002_vision_usage_limits.sql` se aplico a PostgreSQL local mediante el runner.
- La verificacion final confirmo `001-007` completos y registrados con sus checksums.
- Los cinco contratos backend volvieron a aprobar despues del cambio.
- Supabase no fue conectado ni modificado durante este movimiento.
- El cambio se publico como commit backend `4720a7f` en el PR `#1`; el contrato de GitHub Actions aprobo nuevamente.

Avance actualizado:

- Migraciones locales: **100%**.
- Preparacion de release: **90%**; falta inspeccionar el estado real de Supabase, actualizar el PR y ejecutar el rollout deliberado.
- Preparacion general: **95%**.

### 2026-08-25 - Diagnostico de recordatorios Android

- La prueba de las 15:30 no produjo una notificacion visible en el dispositivo Android.
- Metro confirmo que la aplicacion y `expo-notifications` compilaron sin error, pero la entrega local ocurre en el sistema operativo y no deja confirmacion suficiente en Metro.
- La configuracion nativa no declaraba `android.permission.SCHEDULE_EXACT_ALARM`, requerido desde Android 12 para avisos a una hora exacta.
- Se agrego el permiso al proyecto; entrara en vigor al generar e instalar el siguiente APK.
- Se creo el canal nuevo `nutriedu-reminders-v2` con prioridad alta para evitar heredar un canal anterior deshabilitado o con configuracion inmutable.
- Se agrego **Probar notificacion ahora**: solicita permiso, programa un aviso local a cinco segundos y muestra cuantos recordatorios NutriEdu registra Android.
- Typecheck y lint mobile aprobaron despues del cambio.
- Pendiente inmediato: ejecutar la prueba de cinco segundos en el development client actual y registrar el resultado visible.
- Cambio mobile confirmado en commit `15faa18`.
- Replacement development build Android enviado a EAS con ID `4b2eef28-5b8d-45c3-a37f-141d0e3d2b71`; estado inicial `IN_QUEUE`.

Avance actualizado:

- Aceptacion Android: **85%** mientras se identifica la capa de entrega.
- Notificaciones locales: **85%**; diagnostico implementado, permiso exacto requiere nuevo APK.
- Preparacion general: **94%** hasta recuperar la prueba fisica.

### 2026-08-25 - Correccion del modelo de avance

La cifra anterior de preparacion general mezclaba el estado del release tecnico actual con la vision completa del producto. Desde este punto se informan por separado:

1. **Release actual**: que tan listo esta el codigo ya implementado para revisar, migrar y desplegar.
2. **Expansion completa**: avance frente al alcance clinico, mobile, IA, administracion, i18n y operacion definido para NutriEdu.

Estado recalculado:

| Area | Avance estimado | Estado real |
| --- | ---: | --- |
| Release tecnico actual | 90% | PR y CI listos; faltan Supabase, merge, rollout y aceptacion nativa |
| Backend clinico | 82% | Perfiles, metas, reglas base, documentos y controles principales implementados |
| Mobile MVP | 78% | Flujos principales listos; Android en diagnostico e iOS sin aceptacion fisica |
| IA de alimentos | 60% | Contrato, proveedor y limites listos; falta operacion productiva y evaluacion de calidad |
| IA de documentos medicos | 35% | Revision estructurada y confirmacion listas; OCR/IA real y validacion clinica pendientes |
| Panel administrativo completo | 35% | Overview y CRUD de recetas/ingredientes; modulos operativos principales pendientes |
| Notificaciones | 65% | Inbox y horarios listos; entrega Android en correccion y push remoto pendiente |
| i18n completo | 25% | Infraestructura y algunos flujos; cobertura global incompleta |
| Despliegue productivo | 60% | Infraestructura inicial lista; backend expandido y migraciones aun no desplegados |
| **Expansion completa del producto** | **58%** | Base solida, pero queda trabajo funcional y operativo importante |

Alcance pendiente del panel administrativo:

- usuarios, estado de cuenta, roles y cobertura de perfil;
- objetivos, condiciones clinicas, restricciones y reglas nutricionales;
- detalle de consumo de IA, limites y fallos por solicitud;
- operacion de notificaciones y plantillas de eventos;
- auditoria de revisiones medicas sin exponer documentos sensibles;
- historial de acciones administrativas y controles de permisos;
- reportes operativos, filtros, paginacion y exportacion.

Siguiente orden recomendado:

1. Cerrar la prueba Android y validar el replacement APK.
2. Construir Admin Fase 1: usuarios y catalogos clinicos.
3. Construir Admin Fase 2: reglas nutricionales, restricciones y consumo IA.
4. Construir Admin Fase 3: notificaciones, auditoria y reportes.

### 2026-08-25 - Inicio Android reproducible por LAN

- Se identifico que la IP Wi-Fi del Mac cambio a `192.168.0.102`; el `.env` mobile todavia apuntaba a `192.168.1.98`.
- Backend `3002` y Metro `8081` estaban activos, pero el cliente usaba la direccion anterior.
- Se actualizo el `.env` local ignorado por Git y se comprobo desde LAN: Metro responde `packager-status:running` y la API responde `401` sin token, ambos resultados esperados.
- Se agrego `npm run android:lan` mediante `scripts/start-android-lan.js`.
- El comando detecta la IP privada actual, actualiza `EXPO_PUBLIC_API_URL`, comprueba el backend, imprime la URL manual de Android e inicia Metro development-client.
- README mobile actualizado con este procedimiento como ruta principal de desarrollo Android.
- Sintaxis, lint y ejecucion real del launcher: correctos.

### 2026-08-25 - Admin Fase 1: usuarios y catalogos clinicos

- Se agrego listado administrativo de usuarios con busqueda, filtro por rol, paginacion y conteos de objetivos, condiciones y restricciones.
- La API nunca devuelve `password_hash` y limita busqueda, pagina y tamano de respuesta.
- Se agrego cambio transaccional de rol; el ultimo administrador no puede ser degradado.
- Se agrego gestion de objetivos y condiciones: crear, editar, activar y desactivar sin borrar relaciones historicas.
- El nombre del catalogo se resuelve mediante allowlist y los codigos clinicos tienen formato estable validado.
- El panel web incorpora pestanas Usuarios y Catalogos clinicos con estados de carga, error, filtros y paginacion.
- Se agrego un contrato administrativo y un smoke autenticado con cuenta local temporal eliminada automaticamente.
- Seis contratos backend, lint frontend y build frontend: correctos.

Avance actualizado:

- Panel administrativo completo: **50%**.
- Admin Fase 1: **100% en codigo local**, pendiente revision de PR y despliegue.
- Expansion completa del producto: **61%**.
- Backend `2248684` y frontend `6be90ae` publicados en sus PR `#1`.
- GitHub contracts, frontend quality y Vercel preview: aprobados.
- Admin Fase 1: **100% implementado y verificado en PR**, pendiente merge y despliegue productivo.

### 2026-09-04 - Guía integral para exposición técnica

- Se creó `docs/guia_estudio_exposicion_tecnica.md` como documento único de estudio y defensa del proyecto.
- Incluye problema, propuesta, arquitectura, composición del workspace, web, mobile, backend, API, modelo relacional, migraciones, motor de reglas, IA, notificaciones, correo, seguridad, despliegue y pruebas.
- Diferencia explícitamente funciones implementadas, limitaciones actuales y roadmap para evitar afirmaciones incorrectas durante la exposición.
- Incluye diagramas Mermaid de arquitectura y relaciones, guion de 10 minutos, demostración sugerida, preguntas probables, conceptos clave y checklist previo.
- Se vinculó desde el README general y se corrigieron referencias obsoletas sobre panel administrativo, migraciones y pruebas.
- Validación: 656 líneas, siete enlaces locales resueltos y `git diff --check` correcto.
- Estado de publicación: documento disponible localmente; la documentación raíz todavía no se ha publicado en un remoto dedicado.

### 2026-09-04 - Admin Fase 2: reglas, restricciones y uso de IA

- Se agregaron endpoints administrativos protegidos para listar, crear, editar, activar y desactivar reglas nutricionales.
- El backend valida alcance, código asociado, nutriente, tipo de regla, límites, unidad y severidad mediante allowlists y comprobación de catálogos.
- Se agregó gestión no destructiva de restricciones con conteos de usuarios e ingredientes relacionados.
- La migración `008_restriction_catalog_lifecycle.sql` agrega `is_active`; fue aplicada y registrada en la base local.
- El catálogo público oculta restricciones inactivas, pero las relaciones históricas siguen disponibles para evaluación de seguridad.
- Se agregó auditoría paginada de uso de IA con filtros por usuario y estado, tokens, costo comprometido y código de error.
- Los límites de IA aparecen como solo lectura porque se controlan mediante variables protegidas del entorno del backend.
- El panel web incorpora las pestañas Reglas y Uso de IA, además de navegación horizontal adaptable en pantallas estrechas.
- Siete contratos backend, smoke administrativo autenticado, lint frontend y build Vite: correctos.

Avance actualizado:

- Backend clínico: **85%**.
- Panel administrativo completo: **75%**.
- Admin Fase 2: **100% implementado y verificado en PR**; falta despliegue coordinado de la migración `008`.
- Expansión completa del producto: **67%**.
- Backend `e3dcc53` y frontend `fa5ae1c` publicados en sus PR `#1`.
- GitHub contracts, frontend quality y Vercel preview: aprobados.

### 2026-09-05 - Enfoque web: credenciales y catalogos escalables

- La aceptacion iOS se pospuso por friccion operativa con Expo; el trabajo continua en web y backend sin declarar iOS como validado.
- Se definio una politica comun para registro y restablecimiento: 10 a 72 caracteres, mayuscula, minuscula, numero y simbolo.
- El frontend muestra una lista de requisitos en vivo, confirma cuando todos se cumplen y bloquea el envio invalido.
- El backend aplica la misma politica y devuelve `WEAK_PASSWORD`; `1234` se rechaza aunque se omita la interfaz.
- La vista publica de recetas consulta bloques de 12 mediante el endpoint paginado existente.
- Recetas, ingredientes y restricciones administrativas ahora usan busqueda y paginacion del lado del servidor.
- La seleccion de restricciones en el perfil web incorpora busqueda y paginas de ocho opciones sin perder IDs seleccionados entre paginas.
- Ingredientes incorpora diez grupos alimentarios, filtro administrativo y edicion de categoria.
- La migracion `009_ingredient_food_groups.sql` clasifica el catalogo conocido, usa `other` como respaldo y fue aplicada localmente.
- Nueve contratos backend, lint frontend, build Vite, verificador de migracion y smoke autenticado: correctos.

Avance actualizado:

- Backend clinico: **86%**.
- Panel administrativo completo: **78%**.
- Expansion completa del producto: **69%**.
- Migraciones `008` y `009`: aplicadas localmente y pendientes de rollout controlado en Supabase.
- Backend `d971b5c` y frontend `f131c9a` publicados en sus PR `#1`.
- GitHub contracts, frontend quality y Vercel preview: aprobados.

### 2026-09-05 - Selector paginado de ingredientes en recetas

- El formulario administrativo de creación y edición de recetas dejó de descargar el catálogo completo de ingredientes.
- Consulta 12 ingredientes por página mediante la paginación protegida del backend.
- Incluye búsqueda por nombre, estado de carga, estado vacío y navegación anterior/siguiente.
- Los IDs seleccionados se conservan al cambiar de página o búsqueda y se muestra el conteo seleccionado.
- Frontend lint y build de producción: correctos.
- Frontend `f65a8c0` publicado en el PR `#1`; GitHub quality y Vercel preview aprobados.

### 2026-09-07 - Unicidad de ingredientes no seguros

- Se reprodujo la alerta duplicada de `pollo` en el detalle de receta.
- La causa fue una relación muchos a muchos válida: `pollo` está asociado con las restricciones `vegano` y `vegetariano`, por lo que el `JOIN` devolvía una fila por coincidencia.
- Los evaluadores de seguridad clásico y clínico ahora seleccionan ingredientes distintos por `id` y `nombre`.
- Se evita duplicar alertas, grupos de sustitutos y penalizaciones en la puntuación clínica.
- Se agregó `test:recipe-safety` al conjunto `test:contracts`; los diez contratos backend están correctos.
- Backend `7ed3f2d` publicado en el PR `#1`.
- Expansión completa del producto: **69%**. Es una corrección de confiabilidad dentro del alcance existente.

### 2026-09-07 - Ajustes de navegación, credenciales y recetas web

- La raíz pública redirige a `/recipes` cuando existe una sesión, y el logo de la navegación autenticada vuelve al espacio de recetas sin borrar credenciales.
- `Cerrar sesión` permanece como la única acción de la barra que elimina `token` y `user` de `localStorage`.
- El campo de autenticación compartido incorpora iconos de ojo para mostrar u ocultar contraseñas en login, registro y restablecimiento.
- La lista inicial consulta seis recetas seguras por página, que forman dos filas de tres tarjetas en escritorio; las búsquedas conservan páginas de 12.
- Frontend lint y build de producción: correctos. La inspección visual automatizada quedó pendiente porque no había un navegador conectado a la sesión.
- Frontend `584dcab` publicado en el PR `#1`.
- Expansión completa del producto: **69%**. Son mejoras de usabilidad dentro del alcance web existente.

### 2026-09-07 - Auditoría de correlación del perfil y recomendaciones

- Las restricciones sí actúan como exclusiones duras mediante `usuario_restricciones`, `ingrediente_restricciones` y `receta_ingredientes`.
- Objetivos, condiciones y metas numéricas participan en `evaluateRecipeForUser`, pero todavía no ordenan el listado de recomendaciones.
- `getRecommendedRecipes` excluye recetas inseguras y luego selecciona cinco al azar; por ello aún no debe considerarse un recomendador clínico completo.
- La prioridad de objetivos y las variables personales o de estilo de vida se almacenan, pero no intervienen todavía en el puntaje.
- La base local contiene 50 recetas con calorías, pero ninguna tiene aún proteína, carbohidratos, grasas, grasa saturada, azúcar, fibra o sodio. Las reglas asociadas a esos nutrientes se omiten por falta de datos.
- Se identificó una diferencia de periodo que debe resolverse: las reglas sembradas son por comida, mientras las metas del usuario representan valores diarios.
- Próxima línea recomendada: completar datos nutricionales y porciones; construir un perfil nutricional efectivo con precedencia y detección de conflictos; sustituir la selección aleatoria por ranking determinista y explicable; integrar el mismo endpoint en web y mobile.
- Expansión completa del producto: **69%**. La auditoría aclara deuda funcional, no agrega funcionalidad terminada.

### 2026-09-07 - Motor de recomendaciones v1

- Se sustituyó la selección aleatoria por un ranking determinista y paginado en `GET /api/recipes/recommendations`.
- Las restricciones explícitas y las derivadas de estilo alimentario o condiciones compatibles se aplican como exclusiones duras.
- El contexto efectivo combina objetivos con prioridad, condiciones con riesgo, reglas, metas, comidas diarias, variables antropométricas aplicables y tiempo de cocina.
- Las metas se definen como valores diarios y se convierten a referencias por comida; cuando corresponde, la energía se estima con ecuaciones EER de NASEM 2023 y se identifica su fuente.
- Cada resultado declara score, estado, confianza, razones, advertencias y nutrientes faltantes. Los conflictos solicitan revisión en lugar de promediar límites incompatibles.
- Web y mobile consumen el nuevo endpoint cuando no hay filtros de búsqueda; el endpoint histórico conserva compatibilidad.
- Administración captura nutrientes por porción y procedencia. Las escrituras de receta e ingredientes son transaccionales.
- La migración `010_recipe_nutrition_provenance.sql` fue aplicada y registrada localmente; sigue pendiente en Supabase antes del despliegue.
- Once contratos backend, smoke clínico autenticado, lint/build web y lint/typecheck mobile: correctos antes del ajuste documental final.
- Limitación vigente: las 50 recetas actuales tienen calorías, pero todavía carecen del resto de nutrientes; por eso el motor informa confianza limitada hasta completar el catálogo.
- Backend `cec24d9` y frontend `ab6751f` publicados en sus ramas `chore/release-readiness`. Mobile `8534c7b` guardado localmente; ese repositorio todavía no tiene remoto configurado.
- GitHub Actions backend y frontend aprobados; el preview de Vercel del frontend también terminó correctamente.
- Expansión completa del producto: **78%**. El algoritmo funcional está integrado; faltan enriquecimiento nutricional masivo, validación clínica externa y rollout productivo.

### 2026-09-07 - Plantilla de catálogo de recetas v1

- Se preservaron las exportaciones históricas de `Schemas/` y se creó una plantilla de autoría independiente con encabezados y claves externas estables.
- `recipes.csv`, `ingredients.csv` y `recipe_ingredients.csv` separan recetas, composición de ingredientes y cantidades sin depender de IDs internos.
- `example.recipe.json` define la representación canónica alineada con porciones, ocho nutrientes y procedencia del motor v1.
- El backend incorpora `POST /api/admin/recipes/template/validate`; valida sin escribir y devuelve errores o advertencias con rutas exactas.
- La validación detecta versiones, claves, rangos, porciones, nutrientes faltantes, fuentes sin referencia, cantidades y duplicados.
- El contrato automatizado confirma receta completa, confianza reducida por datos faltantes y rechazo de duplicados o procedencia incompleta.
- El smoke administrativo autenticado validó la plantilla real a través de HTTP, junto con autorización, rutas y limpieza de la cuenta temporal.
- Importación masiva, persistencia de claves externas/referencias y cálculo automático quedan explícitamente como siguientes pasos.
- Backend `edc3e32` publicado en `chore/release-readiness`; los doce contratos de GitHub Actions están aprobados.
- Expansión completa del producto: **80%**. Plantilla y prevalidación están listas; la ingesta transaccional sigue pendiente.

### 2026-09-08 - Importación idempotente de recetas

- La migración `011_recipe_catalog_imports.sql` agrega claves externas, referencias, revisor e historial de importaciones; fue aplicada y registrada localmente.
- El preview resuelve creación, actualización, adopción por nombre y conflictos sin escribir en PostgreSQL.
- La importación repite el preview bajo advisory lock y guarda ingredientes, recetas, cantidades, relaciones y auditoría en una sola transacción.
- Repetir una clave externa actualiza el mismo registro; las claves o nombres contradictorios se rechazan antes del commit.
- El panel web permite descargar el ejemplo, elegir JSON, inspeccionar conteos, errores y advertencias, y confirmar únicamente previews válidos.
- El límite es 2 MB, 200 recetas y 500 ingredientes por lote. CSV continúa como formato de autoría; el parser directo queda pendiente.
- El smoke autenticado creó un lote aislado, lo actualizó, verificó cantidades y revisor, y eliminó todos los datos temporales.
- Trece contratos backend, ledger de once migraciones, lint frontend y build Vite: correctos.
- La inspección visual automatizada no se completó porque no había navegador conectado a la sesión.
- Backend `15cc746` y frontend `3c9f524` publicados en `chore/release-readiness`.
- GitHub Actions aprobó los contratos backend y la calidad frontend; el preview de Vercel también terminó correctamente.
- La base local quedó sin recetas, ingredientes ni usuarios temporales después de las pruebas.
- Expansión completa del producto: **84%**. El pipeline JSON está listo localmente; faltan rollout de `011`, parser CSV y cálculo automático.

### 2026-09-08 - Rollout Supabase de migraciones 001 a 011

- Se auditó el runner: exige versiones explícitas, usa checksums, verifica objetos y serializa ejecuciones con advisory lock.
- Al iniciar, el entorno solo contenía credenciales de PostgreSQL local; no se reutilizaron secretos visibles en capturas ni se copiaron por chat.
- Para ejecutar las migraciones se usó Supavisor en modo sesión sobre puerto `5432`; el modo transacción `6543` no es apropiado para el advisory lock de sesión.
- La credencial se guardó en `.env.production.local`, archivo cubierto por `.gitignore`, usando Supavisor en modo sesión y SSL.
- El ledger remoto estaba vacío y el verificador de `001` confirmó que las migraciones anteriores solo existían localmente; no se registró un baseline falso.
- Las migraciones `001` a `011` se aplicaron en orden y cada archivo confirmó su propia transacción.
- La verificación posterior aprobó relaciones, columnas, índices, restricciones, claves foráneas y catálogos de las once versiones.
- El ledger remoto registra las once versiones con checksum y fecha de aplicación; no se crearon usuarios ni filas temporales de catálogo.
- Un smoke no destructivo contra Render obtuvo el rechazo esperado para un usuario inexistente, confirmando API, CORS y consulta a Supabase sin crear datos ni token.
- GitHub Actions volvió a aprobar contratos y calidad; el preview de Vercel terminó correctamente después de actualizar los README.
- Rollout productivo de base de datos: **100%**. Expansión completa del producto: **86%**.

### 2026-09-08 - Incidente local de recomendaciones

- La web recibía `500` desde `GET /api/recipes/recommendations`, aunque el listado seguro continuaba funcionando.
- La ejecución directa del motor fue correcta para todos los usuarios locales; David obtuvo 22 recetas elegibles.
- La causa fue un proceso `node server.js` iniciado el 5 de septiembre que conservaba código anterior en memoria; en ese momento `npm run dev` no usaba recarga automática.
- Se reinició el servidor en el puerto `3002` desde la versión actual y `npm run dev` pasó a usar `node --watch server.js`.
- La prueba autenticada posterior devolvió `200`, seis recetas, total 22 y contexto de perfil, sin errores en el log.
- Recuperación del incidente: **100%**. No requirió cambios funcionales ni de base de datos; solo se fortaleció el comando local de desarrollo.

### 2026-09-08 - Inicio del sprint UI/UX web

- Se priorizó estabilizar y mejorar la experiencia web antes de retomar mobile.
- La auditoría detectó estilos repetidos, navegación mobile incompleta, radios y sombras inconsistentes, emojis funcionales y baja densidad informativa en recetas y planificador.
- Se definieron seis fases: fundamentos, recetas, perfil/planificador, autenticación, administración y QA/transferencia a mobile.
- Responsive, accesibilidad, estados de solicitud y consistencia del español serán criterios transversales, no tareas finales opcionales.
- Se creó `docs/roadmap_ui_ux_web.md` con alcance, orden y criterios de salida.
- Fase UI/UX web: **10%**. Expansión completa del producto: **86%**.

### 2026-09-08 - Fundamentos UI y rediseño de Recetas

- Se definieron tokens semánticos y componentes compartidos para botones, paginación, encabezados, mensajes y estados vacíos.
- La navegación autenticada ahora tiene menú responsive accesible, enlaces semánticos, cierre con Escape y una acción de sesión clara.
- El footer evita duplicar el enlace de recetas cuando existe sesión.
- Recetas adoptó filtros etiquetados, tarjetas más compactas sin métricas anidadas, iconos Lucide, skeletons, reintento y estados vacíos.
- Se preservaron el ranking, la seguridad, los tamaños de página y la navegación al detalle.
- Lint y build Vite: correctos. La inspección visual automatizada quedó pendiente por falta de navegador conectado.
- Frontend `4e45b4d` publicado; GitHub quality y preview de Vercel aprobados.
- Fase UI/UX web: **28%**. Expansión completa del producto: **87%**.

### 2026-09-08 - Rediseño del detalle de receta

- El detalle web se reorganizó en compatibilidad, información general, nutrición por porción e ingredientes.
- La descripción de base de datos dejó de repetirse y los ingredientes se consultan mediante su endpoint dedicado.
- Los nutrientes ausentes se muestran como pendientes y no como cero o valores inferidos.
- Las coincidencias con restricciones son visibles tanto en el resumen de seguridad como en la lista de ingredientes.
- El modal compartido presenta alternativas como orientación; cerrar ya no oculta alertas ni aparenta modificar la receta.
- El modal admite Escape, foco inicial y bloqueo del scroll de fondo, y se adapta como hoja inferior en pantallas estrechas.
- Frontend lint sin errores ni advertencias y build Vite: correctos. La inspección visual automatizada continúa pendiente porque no hay navegador conectado.
- Frontend `a7a5ad7` publicado; GitHub quality y preview de Vercel aprobados.
- Fase UI/UX web: **38%**. Expansión completa del producto: **88%**.

### 2026-09-08 - Rediseño del planificador web

- El formulario de asignación, resumen de progreso y semana se reorganizaron con componentes y tokens compartidos.
- Los 21 espacios son compactos y los vacíos pueden seleccionarse directamente para preparar una asignación.
- El frontend compara la firma del plan cargado con el estado actual para mostrar cambios pendientes y deshabilitar guardados innecesarios.
- La carga, el error con reintento, el guardado y los bloqueos por incompatibilidad tienen estados explícitos.
- Si las restricciones cambian y una receta guardada deja de ser segura, permanece marcada y debe retirarse antes de guardar, igual que exige el backend.
- Se documentó que las alternativas todavía no se persisten; la interfaz ya no afirma que reemplazan ingredientes del plan.
- Lint sin errores ni advertencias y build Vite: correctos. La aceptación visual autenticada sigue pendiente por falta de navegador conectado.
- Frontend `16bf1d6` publicado; GitHub quality y preview de Vercel aprobados.
- Fase UI/UX web: **48%**. Expansión completa del producto: **88%**.

### 2026-09-08 - Rediseño del perfil web

- Perfil conserva contratos independientes para datos personales, objetivos, condiciones/restricciones y metas nutricionales.
- Un resumen no diagnóstico muestra cuánto contexto está disponible para el motor.
- La prioridad de objetivos se presenta de forma numérica y coincide con el orden enviado al backend.
- Las condiciones que requieren acompañamiento profesional se identifican explícitamente.
- Restricciones usa búsqueda compacta y paginación compartida con total real de páginas.
- Los 13 valores diarios se agrupan por energía, macronutrientes y límites específicos, manteniendo campos vacíos como ausencia de regla.
- Se incorporaron skeleton, error con reintento y estados vacíos para catálogos.
- Lint sin errores ni advertencias y build Vite: correctos. La aceptación visual autenticada sigue pendiente por falta de navegador conectado.
- Frontend `201114a` publicado; GitHub quality y preview de Vercel aprobados.
- Fase UI/UX web: **58%**. Expansión completa del producto: **89%**.

### 2026-09-08 - Alternativas culinarias precisas

- Se separó la categoría nutricional amplia (`food_group`) de la función culinaria de sustitución (`substitution_group`).
- La migración `012_ingredient_substitution_groups.sql` clasifica el catálogo existente y fue aplicada y verificada tanto en PostgreSQL local como en Supabase.
- El backend solo propone ingredientes seguros del mismo grupo culinario, excluye el ingrediente original y cualquier ingrediente ya presente en la receta.
- No existe fallback para `other` ni hacia otros grupos. Pollo (`poultry`) no recomienda tofu (`plant_protein`), pescado, harina o tubérculos.
- Si no hay otra ave segura en el catálogo, el contrato devuelve una lista vacía y la web comunica que no existe una alternativa suficientemente cercana.
- Administración e importación permiten capturar, filtrar y validar ambos grupos. Las plantillas JSON y CSV ya incluyen el nuevo campo.
- Se corrigió la limpieza del smoke administrativo para eliminar primero las relaciones de la receta importada; se retiraron únicamente sus residuos de prueba y la repetición dejó cero registros temporales.
- Los 13 contratos backend, el smoke administrativo autenticado, lint y build web están aprobados. Una llamada real confirmó `pollo`, grupo `poultry` y cero opciones con el catálogo actual.
- Backend `a399081` y frontend `a261644` publicados en `chore/release-readiness`; contratos y quality de GitHub Actions aprobados, junto con el preview de Vercel.
- Fase UI/UX web: **58%**. Expansión completa del producto: **90%**.

### 2026-09-08 - Rediseño de autenticación web

- Login, registro, recuperación y restablecimiento comparten una superficie visual basada en tokens semánticos, sin el gradiente decorativo anterior.
- Los botones muestran progreso, exponen `aria-busy` y permanecen deshabilitados durante la solicitud.
- Registro incorpora confirmación de contraseña y feedback accesible de coincidencia, además de la política de 10 a 72 caracteres ya validada por backend.
- El correo se normaliza antes de login, registro y recuperación.
- Login diferencia el resultado de autenticación de la consulta de restricciones: una sesión válida se conserva aunque falle esa consulta secundaria.
- Un enlace de recuperación sin token deja de mostrar el formulario y dirige a solicitar un enlace nuevo.
- Lint y build de producción: correctos. La conexión de navegador no estuvo disponible; la aceptación visual e interactiva se mantiene pendiente en QA.
- Frontend `e83f07f` publicado en `chore/release-readiness`; GitHub quality y preview de Vercel aprobados.
- Fase UI/UX web: **72%**. Expansión completa del producto: **91%**.

### 2026-09-08 - Lista de compras web y recalibración de alcance

- La lista de compras dejó de usar el contrato mínimo de ingredientes sin contexto. Web solicita una respuesta detallada; mobile conserva el arreglo anterior sin cambios.
- El backend suma `amount_g` y cantidades por unidad a través del plan, cuenta usos, adjunta recetas de origen y declara relaciones sin cantidad.
- `planSignature` se deriva de receta, día y comida. El frontend guarda checks por usuario y firma, y elimina estados obsoletos del mismo usuario cuando cambia el plan.
- La interfaz agrupa por `food_group`, permite ver todo o solo pendientes e incorpora progreso, actualización, reinicio confirmado, skeleton, vacío, error y reintento.
- Una prueba real de solo lectura devolvió 23 ingredientes para 5 comidas. Los 23 carecen todavía de cantidad, dato que la interfaz muestra sin estimaciones.
- El contrato específico, lint y build web están aprobados. La validación visual automática permanece pendiente porque no existe navegador conectado.
- Backend `9e9f368` y frontend `1a73a93` publicados en `chore/release-readiness`; contratos, quality y preview de Vercel aprobados.
- Fase Shopping List: **100% del alcance actual**. Fase UI/UX web: **78%**.
- Se corrige la métrica global: el 91% anterior describía el roadmap inmediato, no la visión clínica y multiplataforma completa. Expansión completa del producto: **78%**.

### 2026-09-09 - Primera entrega de administración web

- Se reemplazaron las pestañas horizontales por navegación lateral con iconos en escritorio y selector de sección en mobile.
- El panel adopta el shell y controles compartidos sin cambiar los contratos de gestión existentes.
- `GET /api/admin/overview` agrega `catalogQuality` con cobertura nutricional, revisión, cuantificación, clasificación alimentaria y precisión de sustituciones.
- La vista Operación presenta cada métrica con progreso, dato absoluto y navegación al catálogo que debe corregirse.
- La consulta de solo lectura contra PostgreSQL local confirmó el SQL y estableció la línea base: 80/80 ingredientes clasificados y con grupo de sustitución; 0 recetas nutricionalmente completas/revisadas y 0/281 relaciones cuantificadas.
- No fue necesaria una migración. El contrato administrativo, lint y build Vite están aprobados; QA visual autenticado sigue pendiente por falta de navegador conectado.
- Fase Administración UI: **35%**. Fase UI/UX web: **84%**. Expansión completa del producto: **79%**.

### 2026-09-09 - Catálogos administrativos responsive

- Recetas e ingredientes muestran tarjetas en mobile y tablas con columnas prioritarias desde tablet, eliminando el scroll horizontal forzado de 900-1100 px.
- Ambos listados comparten búsqueda, filtros, conteos, carga, vacío, mensajes y `Pagination`.
- Las acciones editar/eliminar usan iconos y texto; eliminar abre un modal accesible con progreso en vez de `window.confirm`.
- `ConfirmModal` ahora controla foco, Escape, scroll de fondo y cierre por backdrop, y puede reutilizarse en los demás módulos.
- Lint y build Vite aprobaron; el servidor local respondió `200` en `/admin/recipes`. La aceptación visual autenticada sigue pendiente porque no hay navegador conectado.
- Fase Administración UI: **60%**. Fase UI/UX web: **88%**. Expansión completa del producto: **79%**.

### 2026-09-09 - Usuarios y catálogos clínicos responsive

- Usuarios elimina la tabla ancha en mobile y conserva nombre, correo, perfil, contexto clínico y rol en tarjetas legibles.
- Los filtros y la paginación usan controles compartidos; vacío, carga, error y éxito tienen estados específicos.
- Los cambios de rol ya no se ejecutan al seleccionar accidentalmente una opción: requieren una confirmación con el impacto del permiso.
- Objetivos y condiciones incorporan búsqueda, paginación, formulario contextual y vistas responsive.
- Las condiciones distinguen riesgo y necesidad de orientación profesional; activar/desactivar conserva el historial y muestra progreso.
- Lint sin errores ni advertencias, build y respuesta HTTP local: aprobados. QA visual continúa pendiente por falta de navegador conectado.
- Fase Administración UI: **78%**. Fase UI/UX web: **91%**. Expansión completa del producto: **80%**.

### 2026-09-09 - Administración UI completada

- Reglas nutricionales ahora guía alcance, perfil, nutriente, tipo, límites, unidad, severidad, mensaje y estado sin permitir combinaciones visualmente incoherentes.
- La unidad se deriva por nutriente y los límites no aplicables permanecen deshabilitados; el backend conserva validación autoritativa y allowlists.
- Reglas y restricciones adoptan filtros, búsqueda, paginación, tarjetas mobile, tablas compactas y feedback de guardado/activación.
- Uso de IA presenta métricas filtradas, tasa de éxito, política de costo en solo lectura, errores, tokens, costos y referencias de solicitud en todos los anchos.
- Los 14 contratos backend, lint, build y smoke HTTP están aprobados. No se requirieron cambios de API ni migraciones.
- La fase administrativa de UI del alcance actual queda en **100%**. Notificaciones administrativas, auditoría de acciones y reportes/exportaciones permanecen como módulos futuros, no como deuda visual de esta fase.
- Fase UI/UX web: **94%**. Expansión completa del producto: **81%**.

### 2026-09-09 - Retorno a mobile y compras detalladas

- Se retomó el cliente React Native con paridad funcional como criterio de prioridad.
- Compras ahora consume `GET /api/planner/:userId/shopping-list?detailed=true` y dejó de descartar cantidades y contexto del plan.
- Los ingredientes se agrupan por familia alimentaria y muestran gramos, cantidades por unidad, número de usos y recetas de origen.
- La interfaz incluye progreso, vistas Todos/Pendientes, pull-to-refresh, aviso de cantidades incompletas, vacío de lista y confirmación nativa antes de reiniciar.
- Los checks se guardan en SecureStore por usuario junto con `planSignature`; un cambio del plan invalida el progreso anterior sin mezclar cuentas ni listas.
- Se agregó copy completo de Compras a los recursos español e inglés, aunque español continúa como único idioma público.
- `npm run typecheck`, `npm run lint` y `npx expo export --platform all`: correctos. Se generaron bundles de Android, iOS y web sin errores.
- El APK de desarrollo anterior expiró el 7 de septiembre; la siguiente aceptación física requiere un development build nuevo.
- Mobile MVP: **82%**. Expansión completa del producto: **83%**.

### 2026-09-09 - Alternativas culinarias en detalle mobile

- El detalle de receta consulta el contrato autenticado de seguridad además de la evaluación nutricional.
- Los ingredientes restringidos permiten desplegar alternativas seguras dentro de la misma pantalla.
- Mobile presenta únicamente las opciones entregadas por el backend para el mismo `substitution_group`.
- Cuando el catálogo no contiene una alternativa suficientemente cercana, la interfaz lo declara de forma explícita y no inventa reemplazos.
- Se agregó el contrato TypeScript de seguridad y copy español/inglés para todo el flujo.
- TypeScript, Expo lint y exportación Android/iOS/web: correctos.
- Mobile MVP: **84%**. Expansión completa del producto: **84%**.

### 2026-09-09 - Seguridad y localización del planificador mobile

- El planificador compara cada receta guardada con el conjunto seguro devuelto por el backend al cargar el plan.
- Una receta que dejó de ser compatible después de cambiar restricciones se destaca, bloquea el guardado y permite abrir su evaluación y alternativas.
- El backend conserva la segunda validación autoritativa dentro de la transacción de guardado.
- Pull-to-refresh pide confirmación antes de descartar cambios locales.
- Días, tipos de comida, estados, acciones y selector de recetas usan recursos i18n sin cambiar los valores canónicos enviados a la API.
- Se evitó una consulta de seguridad por cada espacio: la detección usa el catálogo seguro ya requerido por el selector y el detalle completo se consulta bajo demanda.
- TypeScript, Expo lint y exportación Android/iOS/web: correctos.
- Mobile MVP: **87%**. Expansión completa del producto: **85%**.

### 2026-09-09 - Preparación del APK autónomo de aceptación

- `eas.json` fija la API pública de Render para los perfiles `preview` y `production`.
- `development` continúa usando la URL LAN del `.env` local, sin mezclar ambientes.
- El perfil preview genera un APK autónomo que no depende de Expo Go ni Metro.
- La configuración fue validada y quedó en el commit mobile `bca3c0c`.
- El build cloud no se inició: subir el código privado a Expo EAS y consumir cuota o costo requiere autorización explícita del propietario.
- Mobile MVP se mantiene en **87%** hasta completar el build y la aceptación física.

### 2026-09-09 - Build preview Android e inicio de aceptación iPhone

- El propietario autorizó explícitamente subir el código mobile privado a Expo EAS y consumir la cuota potencial del build.
- EAS aceptó el perfil `preview`, la API pública de Render, el keystore remoto y el commit `bca3c0c`.
- Build Android finalizado correctamente: `e14617f8-5691-46fa-873d-0c075c508393`. Es un APK autónomo del snapshot SDK 54 y su artefacto temporal vence el 24 de septiembre de 2026.
- Se inició Metro en modo explícito Expo Go contra Render para el iPhone: el QR usa `exp://192.168.1.57:8081` y no requiere backend local.
- Expo Doctor aprobó 18 de 18 comprobaciones del proyecto SDK 54.
- La prueba real del iPhone rechazó el proyecto SDK 54 porque la versión instalada de Expo Go exige SDK 57. Esta comprobación corrigió la suposición inicial de compatibilidad.
- La aceptación de notificaciones continúa reservada al development build propio, no a Expo Go.

### 2026-09-10 - Migración mobile a Expo SDK 57

- La aplicación se migró de forma incremental por SDK 55 y SDK 56 hasta Expo SDK 57 para recuperar compatibilidad con Expo Go en iPhone.
- La versión mobile avanzó a `1.1.0`, React Native `0.86.3`, React `19.2.3` y Expo Router `57.0.20`.
- Se adaptaron los tipos de permisos de notificaciones y dependencias de hooks exigidas por el compilador React actual.
- `npm audit fix` eliminó los hallazgos altos sin forzar cambios incompatibles; quedan 15 alertas moderadas transitivas de herramientas Expo.
- `npm run typecheck`, `npm run lint`, `npx expo-doctor@latest` (21/21) y `npx expo export --platform all`: correctos.
- Metro quedó activo en modo Expo Go contra Render mediante `exp://192.168.1.57:8081`; falta confirmar la aceptación física desde el iPhone.
- El APK preview existente sigue disponible para Android, pero pertenece al snapshot SDK 54. Un APK SDK 57 requerirá un build EAS nuevo.
- Mobile MVP: **90%**. Expansión completa del producto: **86%**.

### 2026-09-10 - Despliegue del backend requerido por mobile

- La aceptación física confirmó que login funcionaba en Android e iPhone, pero las pantallas protegidas no podían recuperar información.
- Un smoke real contra Render aisló la causa: `POST /api/users/login` devolvía `200`, mientras `GET /api/profile` y `GET /api/profile/catalogs` devolvían `404`; recomendaciones devolvía `500`.
- La base de datos no era la causa inmediata. Render continuaba desplegando `main`, mientras los módulos de perfil, recomendaciones, notificaciones y privacidad estaban aprobados únicamente en `chore/release-readiness`.
- Se repitieron los 14 contratos backend y el PR backend `#1` conservó CI correcto y estado fusionable.
- El PR se fusionó en `main` mediante el commit `8a1d091`; Render publicó el cambio y `/api/profile` pasó de `404` a `401 Token requerido`, validando la existencia y protección de la ruta.
- Un smoke autenticado productivo confirmó `200` para perfil, catálogos, restricciones del usuario y recomendaciones. La cuenta temporal utilizada se eliminó correctamente mediante la API.
- La app instalada no requiere un build nuevo para este arreglo porque el defecto estaba en el backend remoto. Basta recargar o iniciar sesión de nuevo.
- Mobile MVP: **92%**. Despliegue: **78%**. Expansión completa del producto: **87%**.

### 2026-09-10 - Paridad de datos entre web y mobile

- La inspección confirmó que la web local usa `http://localhost:3002/api`, mientras iPhone, Android preview y producción usan `https://nutriedu-backend.onrender.com/api`.
- El perfil avanzado de David está almacenado en PostgreSQL local: datos personales completos, una condición, cinco restricciones y una fila de metas. Esos datos no aparecen en mobile porque Supabase es otra base, no porque React Native ignore la respuesta.
- El frontend actualizado fue fusionado en `main` con commit `8dd5291`; web productiva y mobile pasan a compartir los contratos `/profile` y `/recipes/recommendations` del backend de Render.
- Mobile ya usa el mismo ranking determinista que web cuando no hay filtros. Ambos clientes reciben orden, score, razones, advertencias y contexto desde `GET /api/recipes/recommendations`; las diferencias visuales no recalculan el resultado.
- Se agregó `npm run sync:profile` al backend para comparar y trasladar un perfil entre APIs autenticadas. Es dry-run por defecto, relaciona restricciones por nombre, no guarda credenciales y vuelve a consultar recomendaciones después de aplicar.
- Los 15 contratos backend están correctos, incluido el contrato de sincronización de ambientes.
- Falta ejecutar la sincronización interactiva del usuario real y confirmar en ambos clientes el mismo perfil y las seis primeras recomendaciones.
- Mobile MVP: **93%**. Paridad multiplataforma: **90%**. Expansión completa del producto: **88%**.

### 2026-09-10 - Corrección del API local de la web

- Después de promover el frontend, el antiguo `.env` versionado dejó de existir y Vite utilizó el fallback desactualizado `http://localhost:3000/api`.
- El backend local real escucha en `3002`; su preflight desde `http://localhost:5173` respondió `204` con el origen permitido, descartando un defecto en la política CORS.
- Se agregó un `.env.local` ignorado para el workspace, se corrigieron el fallback, `.env.example` y README a `http://localhost:3002/api`.
- Se encontraron tres procesos Vite antiguos en `5173`; se cerraron y se inició una única instancia limpia. El módulo servido por Vite contiene ahora la URL `3002`.
- `npm run lint` y `npm run build`: correctos.

### 2026-09-10 - Paridad del plan, compras y cierre de sesión mobile

- Un smoke autenticado contra Render confirmó que guardar el plan y generar la lista detallada de compras funcionan en producción.
- La cuenta local conserva cinco comidas planificadas que no existen todavía en Supabase. Compras mobile estaba vacía por separación de ambientes, no por un defecto de su pantalla ni de la API.
- `npm run sync:profile` ahora incluye plan semanal y lista de compras. Resuelve recetas por ID y nombre, y recurre a búsqueda por nombre exacto cuando los IDs difieren entre catálogos.
- El estado vacío de Compras permite abrir directamente el plan semanal.
- La acción se denomina `Cerrar sesión`, permanece en Perfil como operación de cuenta y solicita confirmación antes de borrar la sesión local.
- La ampliación backend fue aprobada por CI y fusionada mediante el PR `#3`, commit `4c09236`. La mejora mobile quedó en el commit local `d7eb188`; el proyecto mobile aún no tiene remoto.
- Contrato del sincronizador, TypeScript y Expo lint: correctos. Falta ejecutar `--apply` con la cuenta real y confirmar plan y compras en el dispositivo.
- Mobile MVP: **94%**. Paridad multiplataforma: **93%**. Expansión completa del producto: **89%**.

#### Corrección posterior: planes históricos incompatibles

- La primera ejecución real encontró un plan creado antes de las restricciones actuales. Al copiar primero las restricciones, el backend rechazó correctamente una de sus recetas incompatibles y la operación del plan se detuvo.
- El sincronizador ahora pre-resuelve las recetas, consulta el catálogo seguro después de copiar restricciones, guarda únicamente las comidas compatibles y enumera las omitidas para reemplazo manual.
- La corrección fue aprobada por los 15 contratos y fusionada mediante el PR `#4`, commit `cfd6208`.
- Esta sincronización es una migración puntual de datos de desarrollo local a producción. Las cuentas creadas y utilizadas directamente en producción no requieren este proceso porque web productiva y mobile comparten Render y Supabase.

#### Corrección posterior: clave de progreso de Compras en Expo SDK 57

- La prueba física reveló que Compras fallaba antes de renderizar la respuesta de la API: la clave dinámica `nutriedu_shopping_checked:<usuario>` contenía `:`, carácter rechazado por SecureStore en Expo SDK 57.
- Se auditó todo el acceso a almacenamiento mobile; era la única clave inválida.
- La clave cambió a `nutriedu_shopping_checked_<usuario>`, compatible con Android e iOS. No requiere migración de datos nativos porque SecureStore había rechazado la clave anterior antes de guardarla.

### 2026-09-11 - Auditoría honesta del estado mobile

- Los flujos principales existen y Compras fue aceptada en iPhone, pero cobertura funcional no equivale a calidad de producto ni preparación para tiendas.
- La búsqueda estática encontró 204 textos o etiquetas directos en pantallas y componentes. Autenticación, perfil, análisis, documentos y revisiones aún no completan i18n.
- Mobile no tiene todavía runner de pruebas unitarias, de componentes ni end-to-end; CI comprueba TypeScript y lint, y las exportaciones comprueban que los bundles se generen.
- El análisis visual puede usar el proveedor real cuando está configurado, pero no existe diario alimentario ni seguimiento longitudinal. La extracción de documentos médicos continúa apoyándose en un fixture de desarrollo después del intake.
- Notificaciones locales requieren aceptación final en builds nativos; push remoto, tokens de dispositivo y receipts no existen.
- Faltan modo offline, favoritos/recientes, cantidades completas del catálogo, resumen nutricional del plan, accesibilidad sistemática, observabilidad de errores, repositorio remoto mobile y builds SDK 57 de distribución.
- Recalibración por dimensiones: cobertura del MVP **85%**, calidad para piloto controlado **60%**, preparación para tiendas **40%** y visión clínica mobile ampliada **45%**. No se seguirá comunicando un único porcentaje alto que mezcle alcances distintos.

### 2026-09-11 - Sprint de resiliencia mobile

- `apiRequest` distingue fallos de conectividad, conserva mensajes HTTP y notifica globalmente un `401` de una petición protegida.
- Una sesión expirada borra token y usuario incluso si el almacenamiento seguro falla, redirige a Login y explica que debe iniciarse sesión nuevamente. Un `401` normal de Login no activa ese cierre global.
- El estado de error compartido dejó de usar un fondo rojo completo: incorpora icono, mensaje y reintento accesible.
- Perfil, Recetas, detalle de receta, Plan, Compras, Notificaciones e Historial médico utilizan recuperación explícita.
- Los campos de contraseña de Login y Registro incorporan control de visibilidad reutilizable.
- La política de claves de SecureStore se centralizó para rechazar caracteres incompatibles antes de llamar al módulo nativo.
- Se incorporó Vitest: 6 pruebas validan respuestas correctas, errores HTTP, fallos de red, expiración autenticada y claves de almacenamiento.
- `npm test`, TypeScript, Expo lint y exportación de iOS/Android/web: correctos. La inspección visual web no pudo iniciarse porque no había navegador conectado; la aceptación física queda en el dispositivo.
- Cobertura funcional del MVP: **87%**. Calidad para piloto: **66%**. Preparación para tiendas: **42%**. Visión clínica mobile completa: **47%**.

### 2026-09-11 - Jerarquia y contexto del Perfil mobile

- Perfil muestra las señales que realmente alimentan recomendaciones: datos base presentes, objetivos activos, condiciones/restricciones y metas nutricionales definidas.
- No se usa un porcentaje clinico artificial: cero condiciones puede ser una respuesta valida y no se marca como perfil incompleto.
- Las cuatro areas incorporan icono, conteo y descripcion para explicar su alcance sin alterar contratos ni reglas del backend.
- Notificaciones, privacidad, documentos e historial quedaron agrupados como herramientas y expediente, separados de los botones que guardan datos.
- Los componentes de formulario admiten descripcion de seccion y los campos de texto exponen etiqueta accesible.
- Cobertura funcional del MVP: **88%**. Calidad para piloto: **69%**. Preparacion para tiendas: **42%**. Vision clinica mobile completa: **47%**.

### 2026-09-11 - Inicio operativo mobile

- La sesion autenticada abre ahora en Inicio y no directamente en un formulario de Perfil.
- Inicio reúne progreso de las 21 comidas semanales, las tres comidas del dia, la primera receta del ranking compartido, señales del perfil y notificaciones no leidas.
- Perfil salió de la barra inferior para conservar cinco destinos claros y sigue disponible desde el control de cuenta y la accion Editar perfil.
- La pantalla tolera fallos parciales: si una fuente secundaria falla conserva las secciones disponibles y permite reintentar con pull-to-refresh.
- Dias y tipos de comida se traducen visualmente, pero conservan los valores canonicos en español exigidos por la API.
- TypeScript, Expo lint y las 6 pruebas Vitest: correctos. Falta aceptación visual en iPhone y Android.
- Cobertura funcional del MVP: **90%**. Calidad para piloto: **72%**. Preparacion para tiendas: **42%**. Vision clinica mobile completa: **48%**.

### 2026-09-11 - Flujo guiado de analisis visual

- Analizar presenta tres fases reconocibles: Foto, Procesar y Revisar.
- La fase de captura explica como obtener una imagen util y si el proceso consumira cuota del proveedor o funcionara como demostracion sin costo externo.
- Cuando existe un resultado se ocultan los controles de captura para priorizar la revision humana; Nuevo analisis limpia imagen, consentimiento y resultado anterior.
- La consulta del proveedor visual ofrece reintento explicito y el flujo conserva la cuota diaria y la politica de no retencion ya existentes.
- TypeScript, Expo lint y las 6 pruebas Vitest: correctos. Falta verificar visualmente camara, galeria y teclado en ambos dispositivos.
- Cobertura funcional del MVP: **91%**. Calidad para piloto: **74%**. Preparacion para tiendas: **42%**. Vision clinica mobile completa: **49%**.

#### Localizacion del modulo Analizar

- Captura, permisos, cuota, consentimiento, validacion, revision, confianza, nutrientes, evaluacion y etiquetas accesibles usan recursos i18n.
- Los recursos español e ingles mantienen la misma estructura; los mensajes clinicos producidos por el backend se muestran sin reinterpretarlos en el cliente.
- i18n global avanza aproximadamente de **25% a 35%**. Permanecen Perfil, autenticacion, documentos medicos y componentes secundarios.

### 2026-09-12 - Plan semanal mobile compacto y nutricion auditable

- El planificador muestra un dia a la vez mediante siete pestanas compactas, con el conteo de espacios ocupados sobre tres; conserva los valores canonicos en espanol que exige la API y traduce solo las etiquetas.
- La cabecera distingue el plan sincronizado de los cambios locales todavia no guardados.
- El resumen semanal suma calorias, proteina, carbohidratos y grasa. Cada nutriente informa su propia cobertura sobre las comidas planificadas y excluye valores ausentes o invalidos, sin convertir el resultado en una prescripcion profesional.
- `GET /api/planner/:userId` incorpora los ocho campos nutricionales ya existentes en `recetas`; no fue necesaria una migracion de base de datos.
- Un nuevo contrato backend verifica tanto los campos nutricionales como el uso de la identidad autenticada. Los dieciseis contratos backend quedan aprobados.
- Vitest mobile agrega dos casos para suma, cobertura parcial y descarte de datos invalidos. TypeScript, Expo lint y las 8 pruebas mobile: correctos.
- Cobertura funcional del MVP: **92%**. Calidad para piloto: **77%**. Preparacion para tiendas: **42%**. Vision clinica mobile completa: **51%**.
- Pendiente operativo: desplegar el backend ampliado para que iPhone y Android reciban macronutrientes; la utilidad del resumen seguira limitada hasta completar los nutrientes faltantes del catalogo.

### 2026-09-12 - Diagnostico y seguridad de recordatorios mobile

- Preferencias muestra el permiso real del sistema operativo y cuántos recordatorios propiedad de NutriEdu están programados en el dispositivo.
- Cuando el permiso fue rechazado, la pantalla explica que las preferencias sí se guardaron y ofrece acceso directo a los ajustes de la aplicación.
- La prueba de cinco segundos confirma únicamente la notificación creada por esa acción; ya no presenta el total histórico como resultado de la prueba.
- Las horas silenciosas dejaron de exigir texto `HH:MM`: se activan explícitamente y reutilizan el selector visual de horas.
- La zona horaria permanece vinculada a la cuenta, mientras la interfaz declara que los recordatorios recurrentes locales siguen el reloj del dispositivo y advierte si ambas zonas difieren.
- Cerrar sesión o recibir un `401` cancela todos los recordatorios locales de NutriEdu para no transferir avisos al siguiente usuario del dispositivo.
- La lógica determinista de permisos y horas silenciosas se separó del módulo nativo. TypeScript, Expo lint y las 11 pruebas Vitest: correctos.
- Cobertura funcional del MVP: **92%**. Calidad para piloto: **79%**. Preparación para tiendas: **42%**. Notificaciones: **72%**. Visión clínica mobile completa: **52%**.
- Pendiente: aceptación física de permisos, entrega y navegación en iPhone/Android; push remoto, tokens y receipts continúan fuera del alcance implementado.

### 2026-09-12 - Recetas guardadas sincronizadas

- Se creó `013_user_recipe_favorites.sql` con relación muchos a muchos, clave compuesta, índice cronológico y cascadas hacia usuario y receta.
- La migración `013` fue aplicada, registrada y verificada en PostgreSQL local; permanece pendiente en Supabase para el rollout coordinado.
- Tres consultas no destructivas al ledger de Supabase terminaron en `ECONNRESET`; no se ejecutó SQL remoto. El host y el puerto `5432` sí responden, por lo que el corte ocurre durante el handshake PostgreSQL. Corresponde renovar la cadena de conexión desde `Connect > Session pooler` antes de reintentar.
- La API lista favoritos en páginas, guarda mediante `PUT` idempotente y elimina mediante `DELETE` idempotente. Todos los endpoints usan `req.user.id` y no aceptan identidad del cliente.
- Ranking, búsqueda y detalle incluyen `isFavorite` sin peticiones por tarjeta. El listado guardado revalida incompatibilidades contra las restricciones actuales.
- Mobile agrega las vistas Recomendadas y Guardadas, acción de corazón en tarjetas y detalle, actualización optimista y reversión cuando falla la red.
- Eliminar una receta desde Guardadas recarga la primera página para impedir saltos de offset después de modificar el conjunto.
- La migración real, los 17 contratos backend, TypeScript, Expo lint y las 11 pruebas mobile: correctos.
- Cobertura funcional del MVP: **93%**. Calidad para piloto: **80%**. Preparación para tiendas: **42%**. Backend clínico: **93%**. Visión clínica mobile completa: **53%**.
- Pendiente: aplicar `013` en Supabase antes de desplegar el backend, aceptar visualmente en ambos dispositivos y llevar la misma gestión de favoritos a web.

### 2026-09-12 - Autenticacion mobile alineada e internacionalizada

- Login, registro y recuperacion dejaron de contener copy fijo: titulos, campos, botones, mensajes y etiquetas accesibles usan recursos estructurados en espanol e ingles.
- El registro mobile reemplazo la validacion obsoleta de seis caracteres por la misma politica del backend: minimo 10 caracteres, maximo 72 bytes UTF-8, mayuscula, minuscula, numero y simbolo.
- Cada requisito se muestra junto al campo y cambia de estado mientras se escribe. El backend sigue siendo la autoridad y vuelve a validar antes de crear la cuenta.
- `ApiError` conserva el codigo estable devuelto por la API. Los errores conocidos se traducen por codigo o estado HTTP; recuperacion mantiene una respuesta neutral para no confirmar si una cuenta existe.
- Vitest agrega el contrato mobile de contrasenas y replica los casos debiles/fuertes del backend. TypeScript, Expo lint, 18 pruebas y la exportacion multiplataforma: correctos.
- Cobertura funcional del MVP: **94%**. Calidad para piloto: **81%**. Preparacion para tiendas: **42%**. i18n global: **43%**. Vision clinica mobile completa: **53%**.
- Siguiente bloque: migrar Perfil a i18n por secciones y validar autenticacion fisicamente en iPhone y Android.

### 2026-09-12 - Perfil mobile bilingue sin alterar contratos

- Las cuatro areas de Perfil migraron su copy estatico a recursos `es/en`: datos personales, objetivos, salud y metas nutricionales.
- Sexo, actividad, condicion fisica, frecuencia, estilo alimentario y tiempo de cocina conservan sus valores canonicos en ingles para la API; solo se localiza la etiqueta visible.
- Estados de carga/guardado, validaciones, busquedas, ayuda alimentaria, accesos de cuenta y etiquetas accesibles tambien usan i18n.
- Los recursos de Perfil viven en un modulo aislado y una prueba compara recursivamente las claves de ambos idiomas para impedir traducciones estructuralmente incompletas.
- Los nombres y descripciones de objetivos, condiciones y restricciones llegan actualmente en espanol desde PostgreSQL. Se registra como pendiente una estrategia de catalogos localizables en backend.
- TypeScript, Expo lint, 19 pruebas y exportacion Android/iOS/web: correctos.
- Cobertura funcional del MVP: **94%**. Calidad para piloto: **82%**. Preparacion para tiendas: **42%**. i18n global: **55%**. Vision clinica mobile completa: **53%**.
- Siguiente bloque recomendado: documentos medicos e historial i18n; luego catalogos clinicos localizables y selector publico de idioma.

### 2026-09-12 - Auditoria nutricional y seguimiento longitudinal

- i18n queda pausado deliberadamente en **55%** para priorizar el nucleo clinico; la configuracion de IA se mueve a la ultima fase.
- `npm run audit:nutrition` midio el catalogo local: 50/50 recetas con calorias y 0/50 con proteina, carbohidratos, grasa, fibra, sodio, porcion o fuente nutricional.
- Se evita fabricar nutrientes. El siguiente trabajo de catalogo debe usar el importador transaccional existente y referencias verificables.
- La migracion `014_user_progress_tracking.sql` crea historia de peso, cintura, grasa corporal, adherencia y energia, con una medicion por dia, rangos, procedencia, indice y cascada.
- `014` fue aplicada, registrada y verificada en PostgreSQL local. Supabase permanece sin cambios; el rollout remoto debe ejecutar `013` y luego `014` antes del backend.
- La API autenticada lista con paginacion y resumen constante, crea/reemplaza por fecha y elimina solo registros propios. El ultimo peso se sincroniza con el perfil dentro de una transaccion.
- Mobile incorpora `/progress`, acceso desde Perfil, captura parcial, comparacion desde linea base, historial incremental y eliminacion confirmada.
- Los 18 contratos backend, TypeScript, Expo lint, 19 pruebas mobile y exportacion Android/iOS/web: correctos.
- Cobertura funcional del MVP: **95%**. Calidad para piloto: **83%**. Backend clinico: **95%**. Vision clinica mobile completa: **61%**. Preparacion para tiendas: **42%**.
- Siguiente fase: completar nutrientes y porciones con fuente; despues usar tendencias confirmadas para contextualizar objetivos y recomendaciones. IA real queda al final.

### 2026-09-12 - Trazabilidad de progreso y cola nutricional

- El motor incorpora la medicion de peso mas reciente a su contexto explicable y devuelve fecha, valor y el factor `latest_progress_weight`.
- El peso vigente participa en la estimacion energetica; las tendencias no cambian el ranking hasta contar con reglas clinicas validadas.
- Recetas mobile muestra la procedencia temporal del peso usado para que la recomendacion no parezca una caja negra.
- Administracion filtra recetas por estado nutricional: incompleta, completa o sin revision. La vista inicia en incompletas para priorizar el trabajo pendiente.
- Los 18 contratos backend, lint/build web, TypeScript, Expo lint y 19 pruebas mobile: correctos.
- Cobertura funcional del MVP: **95%**. Calidad para piloto: **84%**. Backend clinico: **95%**. Vision clinica mobile completa: **63%**. Preparacion para tiendas: **42%**.
- Cobertura de infraestructura nutricional: completa. Cobertura util del catalogo nutricional: **20%**, porque solo calorias tiene datos y faltan porcion, fuente y macronutrientes verificables.
- Siguiente bloque: preparar la actualizacion masiva y auditable del catalogo sin duplicar recetas ni inventar nutrientes.

### 2026-09-12 - Actualizacion nutricional masiva sin alterar ingredientes

- Administracion descarga las recetas pendientes reales como `nutrition_patch`, con claves estables, valores existentes preservados y faltantes expresos en `null`.
- El contrato reducido solicita porcion, ocho nutrientes, tipo de fuente y referencia. No incluye ni modifica las relaciones receta-ingrediente.
- La vista previa resuelve cada identidad existente y rechaza claves ambiguas, recetas nuevas, valores incompletos o fuentes no trazables.
- La aplicacion repite la resolucion bajo advisory lock, actualiza en una transaccion y registra hash, administrador y cantidad en `recipe_catalog_imports`.
- La edicion individual tambien exige referencia cuando la fuente deja de ser `unknown` y conserva el administrador responsable de la revision.
- La consulta local genero 50 recetas pendientes. El contrato general producia 893 problemas al exigir cantidades de ingredientes; el flujo reducido concentra 500 faltantes nutricionales reales y deja intactas las 281 relaciones.
- Los 19 contratos backend y lint/build web: correctos.
- Cobertura funcional del MVP: **95%**. Calidad para piloto: **85%**. Backend clinico: **96%**. Vision clinica mobile completa: **64%**. Preparacion para tiendas: **42%**.
- Siguiente bloque: escoger y documentar la fuente primaria, completar un lote piloto pequeno y medir nuevamente la cobertura antes de escalar a las 50 recetas.

### 2026-09-12 - Cantidades de ingredientes preservadas en administracion

- El formulario de recetas conserva selecciones entre paginas y permite registrar cantidad, unidad y equivalencia en gramos para cada ingrediente.
- Cantidad y unidad se validan como pareja y mejoran Compras; gramos se validan por separado y preparan el calculo nutricional desde perfiles por 100 g.
- La API mantiene compatibilidad con arreglos historicos de IDs y agrega el contrato estructurado sin exigir una migracion nueva.
- Crear, actualizar y volver a consultar una receta preserva `amount`, `unit` y `amount_g`; no se sustituyen faltantes por cero.
- Los 19 contratos backend y lint/build web: correctos.
- Cobertura funcional del MVP: **96%**. Calidad para piloto: **86%**. Backend clinico: **97%**. Vision clinica mobile completa: **65%**. Preparacion para tiendas: **42%**.
- Siguiente bloque: calculo determinista por porcion cuando todos los ingredientes tengan gramos y perfiles nutricionales con fuente.

### 2026-09-12 - Calculo nutricional determinista preparado

- La API suma perfiles por 100 g usando los gramos registrados y divide el lote por el numero de porciones.
- Solo admite ingredientes existentes con ocho nutrientes, fuente y fecha de revision; ante faltantes devuelve los ingredientes y campos bloqueantes sin estimarlos.
- La respuesta incluye porcion, ocho nutrientes, fuente `calculated` y una huella reproducible de perfiles y fechas usados.
- El formulario aplica el resultado como borrador. Cambiar gramos, porciones o nutrientes invalida automaticamente la procedencia calculada.
- La auditoria local confirma el siguiente trabajo de datos: 0/80 ingredientes completos/revisados y 0/281 relaciones con gramos o cantidad.
- Los 20 contratos backend y lint/build web: correctos.
- Los porcentajes se mantienen: MVP **96%**, piloto **86%**, backend clinico **97%**, vision clinica mobile **65%**, tiendas **42%**. La infraestructura mejoro, pero la cobertura de datos reales no.
- Siguiente bloque: flujo de enriquecimiento de ingredientes con fuente primaria y un lote piloto, dejando IA para el final.

### 2026-09-12 - Integracion asistida con USDA FoodData Central

- El backend protege `USDA_FDC_API_KEY` y expone busqueda administrativa solo para `Foundation` y `SR Legacy`.
- La interfaz muestra hasta diez candidatos con descripción, categoría, FDC ID y cobertura de los ocho nutrientes; la elección siempre es humana.
- Al confirmar, el backend vuelve a consultar el detalle, rechaza perfiles incompletos y registra nutrientes por 100 g, FDC ID, URL, administrador y fecha.
- El contrato usa los IDs oficiales para energía, proteína, carbohidratos, grasa, grasa saturada, azúcares, fibra y sodio.
- Una prueba real con `DEMO_KEY` devolvió diez candidatos para `chicken breast`; el primero tenía cobertura 1/8 y, correctamente, no es aplicable como perfil completo.
- Los 21 contratos backend y lint/build web: correctos.
- MVP **96%**, piloto **87%**, backend clinico **98%**, vision clinica mobile **66%**, tiendas **42%**. La cobertura de datos sigue en 0 hasta revisar y aplicar el primer lote.
- Siguiente bloque: configurar una clave gratuita de data.gov en desarrollo y revisar un lote piloto de ingredientes de alto uso; IA permanece al final.

### 2026-09-12 - Cola de cobertura nutricional de ingredientes

- La administración inicia mostrando ingredientes incompletos y permite consultar todos, completos o pendientes de fuente/revisión.
- Cada fila y tarjeta muestra cobertura de `0/8` a `8/8`, procedencia y cantidad de recetas afectadas.
- El backend compone estado, búsqueda y taxonomías en la misma consulta paginada; los resultados administrativos se priorizan por uso descendente.
- Los selectores internos con `all=true` conservan su orden taxonómico y compatibilidad previa.
- Los 21 contratos backend y lint/build web: correctos. La revisión visual automatizada no pudo ejecutarse porque no había un navegador conectado; queda prueba manual del panel.
- MVP **96%**, piloto **88%**, backend clínico **98%**, visión clínica mobile **66%**, tiendas **42%**. La operativa del piloto mejoró, pero la cobertura nutricional real continúa en **0/80** hasta aplicar perfiles verificados.
- Siguiente bloque: configurar `USDA_FDC_API_KEY`, revisar los ingredientes de mayor uso y volver a ejecutar `npm run audit:nutrition`; IA permanece al final.

### 2026-09-12 - Carga manual trazable de perfiles por 100 g

- La edición de ingredientes permite completar energía, proteína, carbohidratos, grasa, grasa saturada, azúcares, fibra y sodio cuando USDA no ofrece un candidato completo.
- El backend rechaza perfiles parciales, negativos, sin referencia o con una procedencia incompatible; solo admite carga manual documentada o revisión profesional.
- Cada escritura registra administrador y fecha. Una edición manual limpia el FDC ID previo para no conservar una atribución incorrecta a USDA.
- El formulario muestra los valores existentes, exige los ocho al modificarlos y presenta errores del servidor en contexto.
- Contrato administrativo, lint y build web: correctos. MVP **96%**, piloto **89%**, backend clínico **99%**, visión clínica mobile **66%**, tiendas **42%**.
- La cobertura real sigue en **0/80** porque no se inventaron datos durante la implementación. Siguiente paso: ejecutar un lote piloto verificado y medir cuánto habilita el cálculo de recetas.

### 2026-09-12 - Primer piloto nutricional end-to-end aplicado

- Se verificaron en USDA SR Legacy yogur natural entero (`171284`), almendras (`170567`) y miel (`169640`), todos con cobertura `8/8`.
- El piloto versiona una porción editorial explícita de 170 g, 15 g y 10 g; no se presenta como prescripción clínica.
- El comando es dry-run por defecto, valida identidades y relaciones, usa transacción/advisory lock y solo escribe con `--apply`.
- La aplicación local guardó los tres perfiles, cantidades, revisor y la receta calculada: 195 g, 220.95 kcal, 9.1 g proteína, 19.39 g carbohidratos, 13.01 g grasa, 4.14 g grasa saturada, 16.78 g azúcares, 1.9 g fibra y 78.75 mg sodio.
- La auditoría posterior confirma 1/50 recetas completas y 3/80 ingredientes completos. “Yogur con almendras” tiene cero bloqueadores.
- El motor real la devolvió para usuarios compatibles con score `94`, confianza `1`, sin nutrientes ausentes y alerta explicable de fibra; para un usuario incompatible fue excluida por seguridad.
- Los porcentajes se recalibran por evidencia: MVP **96%**, piloto **90%**, backend clínico **99%**, visión clínica mobile **67%**, stores **42%** y cobertura nutricional del catálogo **2% de recetas**.
- Siguiente bloque: escalar perfiles/cantidades comenzando por ingredientes compartidos y aplicar/verificar migraciones `013`/`014` en Supabase antes del cierre de producción. IA continúa al final.

### 2026-09-12 - Protección de autenticación y dependencias

- Registro, login, solicitud de recuperación y cambio de contraseña tienen límites independientes por IP mediante `express-rate-limit` 8.7.
- Login admite 10 fallos por 15 minutos y omite éxitos; recuperación admite 5 solicitudes por hora. Todos los límites son configurables por entorno.
- Render confía exactamente en un salto de proxy por defecto en producción; `TRUST_PROXY_HOPS` permite ajustarlo sin usar una confianza abierta.
- El bloqueo responde `429` con código, mensaje y segundos de reintento, usa headers IETF draft-8 y desactiva headers heredados.
- `npm audit fix` actualizó `multer` y `qs` de forma compatible; auditoría posterior: **0 vulnerabilidades conocidas**.
- Los **23 contratos backend** pasan. MVP **96%**, piloto **91%**, backend clínico **99%**, visión clínica mobile **67%** y stores **43%**.
- El contador en memoria es suficiente para una instancia Render; antes de escalar horizontalmente deberá usarse un store compartido como Redis.

### 2026-09-12 - Observabilidad HTTP mínima

- Cada solicitud recibe `X-Request-ID` y produce un log JSON con método, ruta sin parámetros de consulta, estado, duración y usuario autenticado cuando aplica.
- Los logs excluyen cuerpos, correos, contraseñas y tokens; un contrato comprueba esa minimización con datos señuelo.
- Se normalizaron rutas inexistentes a `404`, CORS denegado a `403` y errores inesperados a `500`, todos en JSON y correlacionables.
- `X-Powered-By` fue desactivado. Una prueba HTTP real confirmó `404`, `403`, IDs compartidos entre respuesta/log y niveles `warn` para errores controlados.
- Los **24 contratos backend** pasan. MVP **96%**, piloto **92%**, backend clínico **99%**, visión clínica mobile **67%** y stores **44%**.

### 2026-09-12 - Límites previos a cargas sensibles

- Los endpoints de análisis/intake de comida admiten 20 cargas por usuario/hora y el intake médico 10 por usuario/hora.
- El middleware corre después de validar JWT y antes de Multer, por lo que una cuenta limitada no reserva memoria para el archivo.
- Los valores son configurables por entorno y responden con el mismo contrato `RATE_LIMITED` de autenticación.
- Esta capa protege CPU/memoria HTTP; la cuota durable de visión continúa protegiendo consumo mensual y costo del proveedor.
- Los **25 contratos backend** pasan. MVP **96%**, piloto **92%**, backend clínico **99%**, visión clínica mobile **68%** y stores **45%**.

### 2026-09-12 - Errores y límites correlacionables en mobile

- `ApiError` conserva estado, código, `retryAfterSeconds` y `requestId` del backend.
- Login, registro y recuperación distinguen `RATE_LIMITED` y muestran el tiempo restante redondeado en minutos.
- El mensaje está disponible en español e inglés sin reabrir el alcance general de i18n, que permanece pausado.
- Vitest: **20 pruebas**; TypeScript y Expo lint: correctos.
- MVP **97%**, piloto **93%**, backend clínico **99%**, visión clínica mobile **69%** y stores **45%**.

### 2026-09-12 - Cierre consolidado del bloque clínico

- `npm run audit:nutrition` informa cobertura global, doce ingredientes priorizados por uso y diez recetas ordenadas por bloqueadores de perfil y cantidad.
- La medición inicial de `0/80` perfiles completos permitió escoger el piloto; ya no representa el estado vigente.
- El piloto aplicado y verificado deja **3/80 ingredientes** completos/revisados y **1/50 recetas** con cálculo nutricional reproducible. La cobertura nutricional real del catálogo es **2% de recetas**.
- Prioridad para el siguiente lote: aceite de oliva y sal afectan 24 recetas cada uno; cebolla 20; tomate 15; limón 12; ajo 11; zanahoria 10 y pollo 9.
- Backend y frontend están publicados en `chore/release-readiness`; mobile está versionado localmente y todavía no tiene remoto configurado.
- Estado vigente: MVP **97%**, piloto **93%**, backend clínico **99%**, visión clínica mobile **69%** y preparación para tiendas **45%**.
- Bloqueos externos: renovar la conexión Session pooler de Supabase para verificar/aplicar `013` y `014`, desplegar el lote piloto en producción, configurar un remoto mobile y completar aceptación física en iPhone/Android. La configuración de IA permanece deliberadamente al final.

### 2026-09-14 - Migraciones y piloto nutricional en Supabase

- Se renovó localmente la cadena Session pooler y se validó su estructura sin imprimir credenciales: host oficial del proyecto, puerto `5432`, usuario `postgres.<project-ref>` y SSL habilitado.
- `migrate:status` confirmó `001-012` registradas y `013-014` pendientes. El runner aplicó únicamente `013_user_recipe_favorites.sql` y `014_user_progress_tracking.sql`; una segunda inspección confirmó ambas con fecha de aplicación en producción.
- El piloto nutricional se ejecutó primero en dry-run con rollback y verificó receta, ingredientes, cantidades, revisor y hash `40d913ac4fc112fd`. La aplicación posterior confirmó el mismo resultado en Supabase.
- La auditoría remota de solo lectura confirma 50 recetas, 100% con calorías y 1/50 (2%) con proteína, carbohidratos, grasa, fibra, sodio, porción y fuente. “Yogur con almendras” tiene cero bloqueadores de perfil o cantidad.
- Un smoke público sobre Render confirmó que `/api/profile/progress` y `/api/recipes/favorites` existen y rechazan solicitudes sin JWT con `401`; el backend desplegado ya reconoce los contratos asociados a `013` y `014`.
- Estado vigente: MVP **97%**, piloto **95%**, backend clínico **99%**, despliegue **92%**, visión clínica mobile **69%** y preparación para tiendas **45%**.
- Pendiente: smoke autenticado de progreso/favoritos, aceptación física en iPhone/Android, configurar un remoto mobile y ampliar el catálogo nutricional por lotes trazables. La IA permanece al final.

### 2026-09-28 - Diagnóstico de login mobile bloqueado

- Render respondió al preflight y a un login con credenciales ficticias en menos de un segundo; el backend no era el origen del bloqueo.
- El development client conservaba `EXPO_PUBLIC_API_URL=http://192.168.0.102:3002/api`, mientras el Mac había cambiado a `172.20.10.2`. La API local respondió `401` desde la nueva dirección, confirmando conectividad sin usar credenciales reales.
- Se actualizó el entorno LAN y se reinició Metro con caché limpia en `172.20.10.2:8081`.
- Para la aceptación física final de esta sesión, `.env` quedó apuntando por HTTPS a Render/Supabase; solo Metro permanece en la LAN. Así el perfil y las recomendaciones coinciden con web y el login no depende de mantener Express local encendido.
- `apiRequest` ahora aborta a los 30 segundos, distingue `REQUEST_TIMEOUT` y `NETWORK_ERROR`, respeta abortos externos y siempre permite que el `finally` del formulario recupere el botón.
- Login evita envíos duplicados; login, registro y recuperación muestran mensajes específicos de red, timeout y rate limit.
- Vitest: **21 pruebas**; TypeScript y Expo lint: correctos. Queda pendiente la confirmación física del login en el dispositivo.

### 2026-10-01 - Publicación coordinada en GitHub

- Backend aprobó los 25 contratos y avanzó `main` por fast-forward hasta `f65ec19` en `xrhon0s/NutriEdu`.
- Frontend aprobó lint/build, incorporó el título final del documento y avanzó `main` hasta `6c84f39` en `xrhon0s/NutriEdu-frontend`.
- Mobile aprobó 21 pruebas, TypeScript y Expo lint; su historial se normalizó en `main` y se publicó hasta `6638ffd` en el nuevo repositorio `xrhon0s/NutriEdu-mobile`.
- La raíz se publica como `xrhon0s/NutriEdu-project`, separada del backend, con documentación, manuales, esquemas, landing y los tres productos enlazados como submódulos.
- Los `.env`, `.codegraph`, dependencias, builds y respaldos locales permanecen excluidos; `.DS_Store` se retira del índice.
