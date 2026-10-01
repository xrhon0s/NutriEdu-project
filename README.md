# NutriEdu

NutriEdu es una aplicacion web para gestionar recetas, restricciones alimentarias, planificacion semanal y listas de compra de forma personalizada.

El sistema permite que un usuario registre sus restricciones alimentarias y reciba recetas seguras segun su perfil. Tambien incluye autenticacion, recuperacion de contrasena por correo, panel administrativo para recetas e ingredientes, planificador semanal y lista de compras.

La expansion actual agrega una aplicacion movil, perfil clinico confirmado por el usuario, objetivos nutricionales, reglas deterministas, analisis asistido por IA con revision humana y controles de privacidad. NutriEdu apoya decisiones alimentarias; no diagnostica ni sustituye a un profesional de salud.

## Documentacion

- [Roadmap UI/UX web](docs/roadmap_ui_ux_web.md): fases, criterios de salida y orden de mejora de la experiencia web antes de retomar mobile.
- [Guía de estudio y exposición técnica](docs/guia_estudio_exposicion_tecnica.md): documento integral para comprender, presentar y defender la arquitectura, base de datos, seguridad, IA, despliegue y estado real del proyecto.
- [Motor de recomendaciones](docs/motor_recomendaciones.md): precedencia, puntuación, confianza y límites clínicos del ranking.
- [Plantilla del catálogo de recetas](docs/plantilla_catalogo_recetas.md): formato CSV/JSON para preparar recetas, ingredientes, cantidades y procedencia nutricional.
- [Backend](nutriedu-backend/README.md): API REST, variables de entorno, endpoints y servicios.
- [Frontend](nutriedu-frontend/README.md): rutas, paginas, componentes y flujo de usuario.
- [Mobile](nutriedu-mobile/README.md): app Expo/React Native, configuracion y arquitectura inicial.
- [Arquitectura](docs/arquitectura.md): capas del sistema y flujos principales.
- [Base de datos](docs/bases_de_datos.md): entidades, relaciones y tablas de soporte.
- [Roadmap clinico, IA y mobile](docs/roadmap_clinico_ai_mobile.md): expansion del producto hacia perfiles avanzados, reglas nutricionales, app movil e IA.
- [Progreso de expansion clinica y mobile](docs/progreso_expansion_clinica_mobile.md): bitacora viva de decisiones, movimientos y estado del proceso.

## Estructura

```txt
NutriEdu/
├── nutriedu-backend/      # API REST con Node.js, Express y PostgreSQL
├── nutriedu-frontend/     # Aplicacion React con Vite
├── nutriedu-mobile/       # Aplicacion React Native con Expo
├── docs/                  # Documentacion tecnica general
├── Schemas/               # Datos CSV de apoyo para la base de datos
└── README.md              # Vista general del proyecto
```

Este directorio funciona como repositorio coordinador. Backend, frontend y mobile mantienen historiales Git independientes y se enlazan como submodulos:

- [`nutriedu-backend`](https://github.com/xrhon0s/NutriEdu): API desplegada en Render;
- [`nutriedu-frontend`](https://github.com/xrhon0s/NutriEdu-frontend): cliente web desplegado en Vercel;
- [`nutriedu-mobile`](https://github.com/xrhon0s/NutriEdu-mobile): cliente React Native/Expo;
- [`NutriEdu-project`](https://github.com/xrhon0s/NutriEdu-project): documentación, arquitectura, esquemas, manuales, landing y referencias versionadas de los tres productos.

Los despliegues se ejecutan desde cada repositorio de producto. El repositorio coordinador no reemplaza sus historiales ni contiene archivos `.env`.

Para clonar todo el workspace:

```bash
git clone --recurse-submodules https://github.com/xrhon0s/NutriEdu-project.git
```

## Tecnologias

Frontend:

- React
- Vite
- Tailwind CSS
- Axios
- React Router DOM

Mobile:

- React Native
- Expo SDK 57
- Expo Router
- TypeScript
- Expo SecureStore

Backend:

- Node.js
- Express
- PostgreSQL
- pg
- bcrypt
- jsonwebtoken
- Resend
- dotenv
- cors

## Funcionalidades

- Registro e inicio de sesion.
- Correo de bienvenida con Resend.
- Recuperacion de contrasena por correo.
- Perfil de restricciones alimentarias.
- Recetas seguras segun restricciones del usuario.
- Detalle de receta con validacion de ingredientes inseguros.
- Planificador semanal de comidas.
- Lista de compras generada desde el plan.
- Panel administrativo para gestionar recetas, ingredientes, usuarios, catálogos clínicos, reglas, restricciones y auditoría de uso de IA.

## Ejecucion local

### Backend

```bash
cd nutriedu-backend
npm install
cp .env.example .env
node server.js
```

El backend corre por defecto en:

```txt
http://localhost:3000
```

### Frontend

```bash
cd nutriedu-frontend
npm install
npm run dev
```

El frontend corre por defecto en:

```txt
http://localhost:5173
```

### Mobile

```bash
cd nutriedu-mobile
npm install
cp .env.example .env
npm start
```

En un telefono fisico, `EXPO_PUBLIC_API_URL` debe usar la IP local del computador o la URL publica del backend. `localhost` dentro del telefono apunta al propio telefono.

## Variables principales

El backend usa un archivo `.env` basado en `nutriedu-backend/.env.example`.

```env
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=nutriedu
DB_USER=tu_usuario_postgres
DB_PASSWORD=tu_password_postgres
JWT_SECRET=tu_clave_secreta_jwt
FRONTEND_URL=http://localhost:5173
RESEND_API_KEY=re_tu_api_key
RESEND_FROM_EMAIL="NutriEdu <onboarding@resend.dev>"
```

Para produccion o despliegue en Render con Supabase tambien se puede usar:

```env
DATABASE_URL=postgresql://...
DB_SSL=true
FRONTEND_URL=https://tu-frontend.vercel.app
```

En Render, el valor de `RESEND_FROM_EMAIL` debe ir sin comillas:

```env
RESEND_FROM_EMAIL=NutriEdu <onboarding@resend.dev>
```

`onboarding@resend.dev` sirve para pruebas. Para enviar correos a cualquier usuario en produccion, Resend requiere un dominio verificado.

## Flujo general

```txt
Usuario
  ↓
Frontend React
  ↓ HTTP con Axios
Backend Express
  ↓ SQL con pg
PostgreSQL
```

Los correos transaccionales salen desde el backend mediante Resend.

## Estado actual

Implementado:

- Autenticacion con JWT.
- Politica uniforme de contrasenas seguras en registro y restablecimiento.
- Middleware JWT para proteger endpoints privados.
- Backend usa el usuario del token en rutas privadas, no IDs enviados por el cliente.
- Proteccion de rutas privadas en frontend.
- Restricciones alimentarias por usuario.
- Filtrado de recetas seguras.
- Planificador semanal.
- Lista de compras.
- Panel administrativo.
- Paginacion y busqueda de catalogos, con grupos alimentarios para ingredientes.
- Recuperacion de contrasena y correo de bienvenida.
- Perfil clinico avanzado, objetivos y metas nutricionales.
- App movil con autenticacion, perfil clinico, recetas, plan, compras detalladas, analisis, documentos y notificaciones.

Pendiente o mejorable:

- Despliegue controlado de las migraciones SQL versionadas en producción.
- Ampliar pruebas automatizadas y aceptación mobile en dispositivos físicos.
- Documentacion OpenAPI/Swagger.
- Dominio verificado para envio de correos publicos con Resend.

## Despliegue

Configuracion usada/recomendada:

- Backend en Render.
- Frontend en Vercel.
- Base de datos PostgreSQL en Supabase.
- Correos transaccionales con Resend.

Backend en Render:

```txt
Root Directory: nutriedu-backend
Build Command: npm install
Start Command: npm start
```

Frontend en Vercel:

```txt
Root Directory: nutriedu-frontend
Build Command: npm run build
Output Directory: dist
```

Variables importantes:

- Backend Render: `DATABASE_URL`, `DB_SSL`, `JWT_SECRET`, `FRONTEND_URL`, `RESEND_API_KEY`, `RESEND_FROM_EMAIL`.
- Frontend Vercel: `VITE_API_URL`.

## Autor

Proyecto desarrollado por David Sanchez, Nerver Fernandez y Sebastian Marquez.
