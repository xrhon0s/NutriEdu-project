# Arquitectura - NutriEdu

NutriEdu sigue una arquitectura cliente-servidor con clientes web y mobile, una API backend central y PostgreSQL. Ademas, integra Resend para correos transaccionales y deja los proveedores de IA detras de adaptadores opcionales del backend.

## Vista general

```txt
Usuario
  ↓
Frontend React + Vite
Aplicacion React Native + Expo
  ↓ HTTP/JSON o multipart con JWT
Backend Node.js + Express
  ↓ SQL con pg
PostgreSQL local / Supabase

Backend
  ↓ API Resend
Correo transaccional

Backend
  ↓ Adaptador de vision opcional
Proveedor de IA configurado por entorno
```

## Capas

### Frontend

Responsabilidades:

- presentar la interfaz de usuario;
- manejar formularios y navegacion;
- proteger rutas privadas desde la experiencia del cliente;
- consumir la API mediante Axios;
- guardar `token` y `user` en `localStorage`;
- enviar el JWT en `Authorization: Bearer <token>`;
- mostrar mensajes de exito, error, carga y estados vacios.

### Mobile

Responsabilidades:

- ofrecer la experiencia diaria en Android e iOS mediante Expo Router;
- almacenar el JWT con Expo SecureStore;
- reutilizar la misma API y reglas clinicas del cliente web;
- sincronizar recetas guardadas por cuenta en lugar de mantener favoritos aislados por dispositivo;
- capturar imagenes de comida y documentos desde camara o archivos;
- solicitar consentimiento antes de procesar datos sensibles;
- permitir revision y correccion humana antes de aceptar resultados.

### Backend

Responsabilidades:

- exponer la API REST;
- validar entradas;
- autenticar usuarios;
- generar JWT;
- proteger endpoints privados con `verifyToken`;
- verificar permisos administrativos con `verifyAdmin`;
- hashear contrasenas;
- consultar y modificar PostgreSQL;
- aplicar logica de restricciones alimentarias;
- enviar correos de bienvenida y recuperacion de contrasena.
- evaluar recetas y analisis visuales con el motor de reglas clinicas;
- mantener las API keys de IA fuera de los clientes;
- aplicar limites diarios y presupuesto mensual antes de llamadas externas;
- validar archivos sensibles en memoria sin almacenarlos durante la etapa actual.
- exponer administracion protegida de reglas, restricciones y auditoria de consumo de IA;
- mantener limites y secretos de IA en configuracion de entorno de solo lectura para los clientes.

### Base de datos

Responsabilidades:

- persistir usuarios, recetas, ingredientes, restricciones, favoritos y planes;
- mantener relaciones muchos a muchos;
- almacenar hashes de tokens de recuperacion;
- conservar integridad referencial mediante claves foraneas.
- paginar y filtrar catalogos crecientes desde SQL en lugar de descargar todas las filas al cliente.

### Servicio de correo

Resend se usa desde el backend para:

- correo de bienvenida;
- correo de recuperacion de contrasena.

El frontend nunca conoce la API key de Resend.

### IA opcional

La extraccion visual usa un adaptador configurable. El proveedor puede permanecer deshabilitado durante desarrollo. La IA produce observaciones estructuradas; el motor determinista de NutriEdu evalua restricciones, condiciones, objetivos y metas. La IA no confirma diagnosticos ni modifica automaticamente el perfil.

## Flujos principales

### Seguimiento de progreso

```txt
Usuario registra una medicion en mobile
  ↓
API valida JWT, fecha, presencia y rangos
  ↓
PostgreSQL inserta o actualiza usuario_progreso por fecha
  ↓
La misma transaccion sincroniza el ultimo peso con perfiles_usuario
  ↓
El motor de recomendaciones usa el peso vigente y el historial conserva la evolucion
```

Los cambios se presentan como diferencias descriptivas desde la linea base. No se interpretan como diagnostico ni se ajustan automaticamente metas clinicas.

El contexto explicable del ranking expone la fecha y el peso de la medicion mas reciente. Ese peso actualiza la estimacion energetica actual; la tendencia historica no modifica puntuaciones hasta disponer de una regla clinica validada.

### Registro

```txt
Usuario llena /register
  ↓
Cliente web o mobile muestra y valida la politica de contrasena
  ↓
Cliente envia POST /api/users/register
  ↓
Backend vuelve a validar datos y hashea la contrasena con bcrypt
  ↓
Backend crea usuario en PostgreSQL
  ↓
Backend dispara correo de bienvenida con Resend
  ↓
Web redirige a /login; mobile inicia sesion con la cuenta creada
```

### Login

```txt
Usuario llena /login
  ↓
Frontend envia POST /api/users/login
  ↓
Backend valida email y contrasena
  ↓
Backend firma JWT
  ↓
Frontend guarda token y user en localStorage
  ↓
Frontend redirige segun restricciones existentes
```

### Recuperacion de contrasena

```txt
Usuario solicita recuperacion en /forgot-password
  ↓
Backend busca el correo
  ↓
Backend genera token aleatorio
  ↓
Backend guarda SHA-256(token) en password_reset_tokens
  ↓
Backend envia enlace por Resend
  ↓
Usuario abre /reset-password?token=...
  ↓
Backend valida hash, expiracion y uso del token
  ↓
Backend actualiza password_hash
```

### Recetas seguras

```txt
Usuario autenticado
  ↓
Restricciones del usuario
  ↓
Ingredientes asociados a restricciones
  ↓
Exclusion de recetas incompatibles
  ↓
Motor combina reglas, metas y preferencias
  ↓
Ranking determinista con explicaciones y confianza
  ↓
Frontend muestra recomendaciones personalizadas
```

### Alternativas de ingredientes

```txt
Ingrediente incompatible detectado
  ↓
Backend consulta su substitution_group
  ↓
Excluye ingredientes restringidos y los ya presentes en la receta
  ↓
Conserva únicamente candidatos seguros del mismo grupo culinario
  ↓
Devuelve alternativas cercanas o una lista vacía, sin fallback arbitrario
```

`food_group` describe la familia nutricional general; `substitution_group` describe una función culinaria intercambiable. Por eso pollo y tofu pueden ser proteínas, pero no se sugieren entre sí. La ausencia de un candidato cercano se muestra explícitamente y no se interpreta como autorización para preparar la receta original.

### Planificador y compras

```txt
Usuario agrega recetas al plan semanal
  ↓
Frontend guarda plan con POST /api/planner
  ↓
Backend persiste comidas por dia y tipo
  ↓
Lista de compras consulta ingredientes del plan
  ↓
Backend agrega gramos o cantidades por unidad y conserva recetas de origen
  ↓
Respuesta detallada incluye grupo alimentario, faltantes y firma del plan
  ↓
Web guarda checks localmente por usuario + firma, sin mezclar planes
```

El contrato histórico de lista como arreglo continúa disponible para clientes antiguos. Web y mobile usan `?detailed=true`; si una relación no tiene `amount_g` ni `amount`, el backend la declara incompleta en lugar de estimarla. Ambos clientes agrupan por `food_group`, y mobile conserva los checks en SecureStore por usuario y `planSignature` para invalidarlos cuando cambia el plan.

### Importación de recetas

```txt
Administrador selecciona catálogo JSON
  ↓
Backend valida contrato y resuelve identidades
  ↓
Panel muestra creación, actualización, errores y advertencias
  ↓
Administrador confirma
  ↓
Backend obtiene advisory lock y repite el preview
  ↓
Transacción guarda ingredientes, recetas, cantidades y auditoría
  ↓
Commit completo o rollback completo
```

Para completar el catalogo historico existe un flujo reducido `nutrition_patch`: descarga recetas pendientes con claves estables, conserva valores conocidos y deja faltantes como `null`. La previsualizacion exige porcion, ocho nutrientes y fuente trazable. La aplicacion actualiza exclusivamente informacion nutricional y registra actor, fecha y hash; no elimina ni reemplaza relaciones con ingredientes.

La administracion individual conserva el contrato legado de IDs y agrega cantidades estructuradas por ingrediente: cantidad y unidad para Compras, y `amount_g` para futuros calculos desde nutrientes por 100 g. Los tres campos regresan en las consultas administrativas para evitar perdida silenciosa al volver a editar.

El calculo nutricional es determinista: suma `nutriente_por_100g × amount_g / 100` para el lote y divide entre porciones. Solo admite perfiles completos, con fuente y fecha de revision; devuelve una huella derivada del snapshot utilizado. Si cambia un dato de entrada en el cliente, la etiqueta `calculated` se invalida hasta repetir el calculo.

Los perfiles de ingredientes pueden cargarse desde USDA FoodData Central. El navegador solo envía la consulta y el FDC ID seleccionado; la clave de data.gov permanece en backend. La búsqueda prioriza `Foundation` y `SR Legacy`, presenta alternativas para revisión humana y la aplicación vuelve a obtener el detalle para exigir ocho nutrientes antes de escribir.

El listado administrativo convierte esta carga en una cola medible: filtra perfiles completos, incompletos o sin revisión; expone cobertura sobre ocho nutrientes y cuenta relaciones con recetas. Los pendientes se ordenan por uso descendente, mientras `all=true` mantiene el orden taxonómico para no alterar los selectores internos.

Cuando no existe un candidato USDA completo, la edición manual exige un perfil atómico de ocho valores y referencia verificable. El backend limita la procedencia a `manual` o `professional`, registra actor y fecha, y limpia `fdc_id`; así una corrección humana no conserva una atribución externa falsa.

El primer piloto versionado demuestra la cadena completa sin IA: tres snapshots SR Legacy, cantidades en gramos, cálculo por porción, procedencia y evaluación personalizada. Se ejecuta primero con rollback y solo escribe al recibir `--apply`; valida identidades exactas y usa advisory lock para impedir ejecuciones concurrentes.

### Analisis de comida

```txt
Mobile captura y normaliza una imagen
  ↓ consentimiento por imagen
Backend valida archivo y reserva cuota/costo
  ↓ proveedor visual opcional
Backend valida respuesta estructurada
  ↓ motor de reglas clinicas
Usuario corrige ingredientes, porcion y nutrientes
  ↓ reevaluacion sin nueva llamada de IA
Resultado personalizado
```

### Documentos medicos

```txt
Usuario fotografia o elige PDF/JPEG/PNG
  ↓ consentimiento medico versionado
Backend autentica, valida MIME y firma binaria
  ↓
Archivo descartado al terminar la solicitud
  ↓
Extraccion real deshabilitada; fixture de desarrollo usa esquema 1.0
  ↓
Usuario corrige y acepta o descarta cada hallazgo
  ↓
Backend valida la revision y mantiene profileUpdated=false
  ↓ auditoria estructurada, sin archivo original
Backend resuelve condiciones y prepara cambios exactos
  ↓ hash + confirmacion final
Transaccion aplica condiciones aditivas y metas diarias
  ↓
Historial muestra auditoria estructurada y retencion
  ↓ 30 dias si no se aplica
Cleanup elimina revision vencida
```

## Seguridad actual

Implementado:

- contrasenas con hash bcrypt;
- JWT al iniciar sesion;
- middleware `verifyToken` en endpoints privados;
- validacion de rol administrador en backend;
- CORS restringido por `FRONTEND_URL`;
- token de recuperacion aleatorio;
- hash del token de recuperacion en base de datos;
- expiracion de tokens de recuperacion;
- invalidacion de tokens anteriores al solicitar uno nuevo.
- limites de tamano, MIME y firma binaria para imagenes y documentos;
- consentimiento versionado para procesamiento visual y medico;
- imagenes y documentos descartados al terminar cada solicitud;
- cuota diaria y presupuesto mensual durable para vision;
- API keys externas disponibles solo en backend.
- vista previa inmutable mediante hash antes de aplicar datos medicos;
- aplicacion clinica transaccional, explicita y separada de la revision;
- auditoria estructurada sin conservar el archivo medico original mediante migracion `003`.
- retencion versionada para revisiones, eliminacion del usuario antes de aplicar y cleanup programable.
- eliminacion transaccional de cuenta con contrasena actual, cascadas auditadas y revocacion efectiva del JWT al desaparecer el usuario.
- limites por IP en registro, login y recuperación, con headers estándar y `429` estructurado;
- correlación por `X-Request-ID`, logs HTTP JSON sin cuerpos ni query strings y errores terminales JSON;
- límites por usuario antes de recibir imágenes/documentos en memoria, separados de las cuotas durables de IA;
- clientes mobile que conservan `requestId` y traducen `RATE_LIMITED` con el tiempo de reintento;

Pendiente recomendado:

- validacion mas estricta de datos de entrada;
- agregación externa, alertas y métricas sobre los logs estructurados.
- politica formal de retencion y eliminacion para hallazgos medicos estructurados.

## Despliegue actual/recomendado

```txt
Frontend: Vercel
Mobile: Expo / builds Android e iOS
Backend: Render
Base de datos: Supabase PostgreSQL
Correo: Resend
```

Variables clave:

- Frontend: `VITE_API_URL`.
- Backend: `DATABASE_URL`, `DB_SSL`, `JWT_SECRET`, `FRONTEND_URL`, `RESEND_API_KEY`, `RESEND_FROM_EMAIL`, `TRUST_PROXY_HOPS`, límites `AUTH_*`/`UPLOAD_*` y variables `VISION_*`/`OPENAI_*` cuando se habilita visión.

En Render, `FRONTEND_URL` define los origenes permitidos por CORS. Si se necesita usar local y produccion:

```env
FRONTEND_URL=http://localhost:5173,https://tu-frontend.vercel.app
```

Para Resend en modo demo se puede usar `NutriEdu <onboarding@resend.dev>`. Para envio publico a cualquier destinatario se requiere dominio verificado.

## Escalabilidad

La separacion frontend/backend permite:

- desplegar el frontend en Vercel, Netlify u otro hosting estatico;
- desplegar el backend en Render, Railway, Fly.io, etc.;
- usar PostgreSQL administrado;
- cambiar el proveedor de correo sin tocar el frontend;
- agregar endpoints sin modificar la estructura general.
