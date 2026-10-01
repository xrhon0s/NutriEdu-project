# Backlog de Modulos de Producto - NutriEdu

Este documento prioriza modulos nuevos a partir del estado real del backend, la app mobile y el panel web. No reemplaza el roadmap clinico; lo convierte en una secuencia de producto implementable.

## Criterios de prioridad

Cada modulo se evalua por:

- valor diario para el usuario;
- riesgo clinico y de privacidad;
- dependencia de infraestructura externa;
- costo operativo;
- cercania con capacidades ya implementadas;
- capacidad de probarse de extremo a extremo.

## Estado actual relevante

- Mobile ya cubre perfil, objetivos, condiciones, metas, recetas, analisis, plan y compras.
- Los documentos medicos tienen intake seguro, revision humana, aplicacion explicita, auditoria e historial.
- El backend ya tiene JWT, roles, reglas nutricionales, cuotas de vision y transacciones.
- El panel administrativo web solo gestiona recetas e ingredientes.
- La bandeja, preferencias y recordatorios locales ya existen; aun no hay tokens ni entrega push remota.
- La eliminacion integral de cuenta ya existe en API y mobile. El estado de `005` en Supabase debe verificarse porque pudo ejecutarse anteriormente desde SQL Editor.
- El catalogo mobile de recetas ya tiene paginacion. La base i18n esta activa, pero solo espanol se habilita hasta traducir toda la UI y el contenido servido por backend.
- No existe seguimiento longitudinal de peso, medidas, energia percibida o adherencia.

## P0 - Cerrar seguridad y operacion

### Retencion e historial medico

Estado: implementado y validado localmente; estado de `004` en Supabase aun no inspeccionado desde este workspace.

- archivos originales descartados inmediatamente;
- revisiones no aplicadas con expiracion de 30 dias;
- auditoria aplicada conservada hasta eliminar la cuenta;
- historial y detalle visibles para el usuario;
- eliminacion individual solo para revisiones no aplicadas;
- script idempotente para limpieza programada.

### Eliminacion de cuenta

Estado: implementado y validado localmente; `005` debe verificarse en Supabase antes de ejecutar o registrar un baseline.

- confirmacion con contrasena actual;
- revocacion de tokens y sesiones;
- eliminacion transaccional aprovechando `ON DELETE CASCADE`;
- comprobacion explicita de tablas que no tengan cascada;
- correo de confirmacion sin incluir datos clinicos;
- auditoria administrativa sin conservar informacion medica del usuario.

## P1 - Notificaciones utiles, no invasivas

### Etapa 1: bandeja y preferencias

Estado: implementado y validado localmente; `006` puede existir ya en Supabase, pero falta comprobar su estructura desde una conexion autorizada.

- `notification_preferences`: zona horaria, horas silenciosas y categorias activas;
- `notifications`: bandeja durable con `read_at`, tipo, titulo, cuerpo y destino interno;
- categorias iniciales: comidas, plan semanal, compras, seguimiento y seguridad;
- pantalla mobile con no leidas, marcar como leida y abrir el modulo relacionado;
- ningun dato clinico sensible en titulo o cuerpo visible en pantalla bloqueada.

### Etapa 2: recordatorios locales

Estado: implementado y validado por compilacion; falta la prueba funcional final en un development build Android/iOS.

- recordatorio de comida configurado por el usuario;
- recordatorio para preparar el plan semanal;
- recordatorio de lista de compras antes del dia elegido;
- cancelacion y reprogramacion al cambiar preferencias.
- permiso solicitado al guardar solo cuando hay recordatorios activos;
- horas silenciosas aplicadas, incluyendo intervalos que cruzan medianoche;
- apertura segura de Plan o Compras al tocar un recordatorio;
- los disparadores siguen la hora local del dispositivo; la zona IANA queda disponible para la futura entrega remota.

Expo soporta notificaciones locales y remotas, pero el push remoto requiere development build y no esta disponible en Expo Go para Android. Referencias: [Expo Notifications](https://docs.expo.dev/versions/latest/sdk/notifications/) y [tipos de notificacion](https://docs.expo.dev/push-notifications/what-you-need-to-know/).

### Etapa 3: push remoto

- `device_push_tokens` por dispositivo, plataforma y ultima actividad;
- consentimiento separado de notificaciones;
- envio mediante Expo Push Service;
- registro de tickets y receipts;
- desactivar tokens `DeviceNotRegistered`;
- reintentos con limite y sin duplicar mensajes;
- development build Android/iOS antes de pruebas reales.

El servicio push de Expo es gratuito actualmente, pero no ofrece SLA y exige manejar receipts y errores. Referencias: [servicio push de Expo](https://docs.expo.dev/push-notifications/sending-notifications/) y [FAQ](https://docs.expo.dev/push-notifications/faq/).

## P1 - Panel administrativo operativo

El panel debe ser denso, auditable y orientado a tareas. No debe convertirse en una vista libre de datos medicos.

### Primera entrega

- resumen de usuarios activos y perfiles completos;
- recetas con todos los nutrientes usados por el motor de reglas;
- CRUD de objetivos, condiciones y restricciones;
- CRUD de reglas nutricionales con validacion de unidad y rango;
- relaciones ingrediente-restriccion;
- consumo diario y mensual de IA, errores y presupuesto restante;
- estado de migraciones y salud de servicios;
- historial administrativo de cambios.

### Seguridad administrativa

- separar permisos: contenido, soporte, clinico y superadmin;
- exigir JWT y permiso por endpoint, no solo ocultar menus;
- no mostrar hashes, tokens, secretos ni documentos originales;
- mostrar datos clinicos solo cuando exista una tarea y permiso definidos;
- registrar actor, accion, entidad, antes/despues y fecha;
- impedir que administradores generales modifiquen condiciones confirmadas.

### Segunda entrega

- usuarios con busqueda, estado y bloqueo de acceso;
- plantillas y campañas transaccionales de notificacion;
- revisiones de IA agregadas y anonimizadas para calidad;
- exportacion CSV de metricas operativas, no de expedientes clinicos;
- alertas por presupuesto, errores repetidos y datos nutricionales incompletos.

## P2 - Seguimiento y progreso

### Check-ins periodicos

- peso y medidas opcionales;
- energia, hambre, digestion y adherencia percibida;
- frecuencia configurable, sin exigir registro diario;
- tendencias por objetivo con advertencia de que no sustituyen evaluacion profesional;
- historial editable con auditoria minima.

### Diario alimentario ligero

- registrar una receta, analisis visual o comida manual;
- asociar entrada con desayuno, almuerzo o cena;
- comparar rangos diarios sin afirmar precision clinica de una fotografia;
- reutilizar ingredientes y nutrientes ya revisados;
- evitar convertir estimaciones de IA en valores exactos.

### Progreso del objetivo

- hitos definidos por objetivo;
- periodo, estado y notas;
- resumen semanal de adherencia al plan;
- ajustes siempre confirmados por el usuario.

## P2 - Experiencia mobile

- modo offline de lectura para plan, recetas guardadas y compras;
- cola de acciones para marcar compras y sincronizar al recuperar red;
- favoritos y recetas recientes;
- escaneo de codigo de barras como complemento, no fuente clinica unica;
- accesibilidad: tamanos de texto, contraste, lectores de pantalla y movimiento reducido;
- centro de privacidad para consentimiento, historial, exportacion y eliminacion de cuenta.

## P3 - Colaboracion profesional

- exportar un resumen elegido por el usuario;
- compartir mediante enlace temporal y revocable;
- rol profesional separado del administrador;
- comentarios o recomendaciones con autor y fecha;
- nunca habilitar acceso profesional general a todos los usuarios.

Este bloque requiere una revision legal y de privacidad mas profunda antes de implementarse.

## Automatizacion recomendada

El cleanup medico ya puede ejecutarse con:

```bash
npm run cleanup:medical-reviews
```

En produccion puede programarse como Cron Job de Render. Los cron usan UTC, tienen garantia de una sola ejecucion concurrente y actualmente cobran un minimo mensual por servicio; por eso conviene agrupar limpiezas periodicas en un solo job. Referencia: [Render Cron Jobs](https://render.com/docs/cronjobs).

## Orden recomendado de ejecucion

1. Inspeccionar Supabase; aplicar solo migraciones ausentes y registrar con baseline las que ya superen la verificacion estructural.
2. Probar recordatorios locales en development build y completar i18n por modulos.
3. Expandir admin con catalogos, reglas, costos y auditoria.
4. Migrar a development build e incorporar push remoto.
5. Implementar check-ins y progreso por objetivos.
6. Integrar extraccion real de documentos con limites de costo.
7. Evaluar colaboracion profesional solo despues de cerrar permisos y privacidad.
