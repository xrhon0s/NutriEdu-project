# 🥗 NutriEdu

Sistema web para la gestión de recetas seguras y personalizadas según restricciones alimentarias.

---

## 🧠 Descripción

NutriEdu es una plataforma que permite a los usuarios:

* Registrarse e iniciar sesión
* Definir restricciones alimentarias (alergias, intolerancias, etc.)
* Obtener recetas seguras según su perfil
* Recibir recomendaciones basadas en nivel de salud y calorías

El sistema filtra automáticamente las recetas para evitar ingredientes no compatibles con cada usuario.

---

## 🏗️ Arquitectura del sistema

El proyecto sigue una arquitectura cliente-servidor:

```txt
Frontend (React)
        ↓
Backend (Node.js + Express)
        ↓
Base de datos (PostgreSQL)
```

---

## 📦 Estructura del proyecto

```txt
NutriEdu/
├── frontend/        # Aplicación React (Vite)
├── backend/         # API REST (Node.js + Express)
├── docs/            # Documentación adicional
│   └── base-de-datos.md
└── README.md        # Documentación principal
```

---

## 🛠️ Tecnologías utilizadas

### Frontend

* React
* Vite
* Tailwind CSS
* Axios
* React Router DOM

### Backend

* Node.js
* Express
* PostgreSQL
* pg
* bcrypt
* jsonwebtoken
* dotenv
* cors

### Base de datos

* PostgreSQL

---

## 🚀 Instalación y ejecución

### 1. Clonar el repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
cd NutriEdu
```

---

### 2. Configurar el backend

```bash
cd backend
npm install
```

Crear archivo `.env`:

```env
PORT=3000
DB_USER=nuevo
DB_HOST=localhost
DB_NAME=nutriedu
DB_PASSWORD=1234
DB_PORT=5432
JWT_SECRET=tu_clave_secreta
```

Ejecutar servidor:

```bash
node server.js
```

---

### 3. Configurar la base de datos

* Crear base de datos en PostgreSQL
* Ejecutar el archivo `schema.sql`

---

### 4. Configurar el frontend

```bash
cd frontend
npm install
npm run dev
```

Abrir en navegador:

```
http://localhost:5173
```

---

## 🔐 Autenticación

El sistema utiliza JWT (JSON Web Tokens):

* El usuario inicia sesión
* El backend genera un token
* El frontend lo guarda en `localStorage`
* El token se utiliza para futuras solicitudes

---

## 📡 API

### Usuarios

* `POST /api/users/register`
* `POST /api/users/login`
* `POST /api/users/restrictions`

### Recetas

* `GET /api/recipes/safe/:userId`
* `GET /api/recipes/recommended/:userId`

---

## 🗄️ Base de datos

La base de datos sigue un modelo relacional basado en:

* usuarios
* restricciones
* ingredientes
* recetas

Incluye tablas intermedias para relaciones muchos a muchos.

Más detalles en:

```
docs/base-de-datos.md
```

---

## 🧠 Lógica principal

El sistema filtra recetas mediante:

* Restricciones del usuario
* Ingredientes asociados a restricciones
* Exclusión de recetas incompatibles

Esto permite generar resultados personalizados.

---

## ⚠️ Estado del proyecto

### ✅ Implementado

* Registro de usuarios
* Autenticación con JWT
* Asignación de restricciones
* Filtrado de recetas seguras
* Recomendación de recetas

### 🚧 Pendiente

* Protección de rutas con middleware
* Manejo avanzado de errores
* Interfaz de usuario más completa
* Módulo de recetas en frontend
* Mejora en experiencia de usuario
* Documentación con Swagger

---

## 💡 Mejoras futuras

* Implementación de middleware de autenticación
* Uso de variables de entorno en toda la configuración
* Sistema de favoritos
* Perfil de usuario
* Recomendación basada en preferencias
* Despliegue en la nube (Vercel + Render)

---

## 👨‍💻 Autor

Proyecto desarrollado por **David Garcés**

---

## 📄 Licencia

Pendiente de definir
