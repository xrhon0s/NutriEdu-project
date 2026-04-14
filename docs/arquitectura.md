# 🏗️ Arquitectura del Sistema - NutriEdu

NutriEdu sigue una arquitectura cliente-servidor dividida en tres capas principales: frontend, backend y base de datos.

---

## 🧩 Componentes del sistema

### Frontend

Aplicación web desarrollada con React.

Responsabilidades:
- interfaz de usuario
- captura de datos
- navegación entre vistas
- envío de solicitudes al backend
- almacenamiento del token de autenticación

---

### Backend

API REST desarrollada con Node.js y Express.

Responsabilidades:
- lógica de negocio
- autenticación de usuarios
- validación de datos
- procesamiento de restricciones alimentarias
- comunicación con la base de datos

---

### Base de datos

Sistema relacional en PostgreSQL.

Responsabilidades:
- almacenamiento persistente de datos
- relaciones entre entidades
- integridad referencial

---

## 🔄 Flujo general del sistema

```txt
Usuario
  ↓
Frontend (React)
  ↓ HTTP (Axios)
Backend (Express)
  ↓ SQL (pg)
Base de datos (PostgreSQL)
🔐 Flujo de autenticación
Usuario ingresa credenciales
        ↓
Frontend envía login
        ↓
Backend valida usuario
        ↓
Genera JWT
        ↓
Frontend guarda token
        ↓
Usuario autenticado
🍽️ Flujo de recomendación de recetas
Usuario
  ↓
Restricciones del usuario
  ↓
Ingredientes prohibidos
  ↓
Filtrado de recetas
  ↓
Recetas seguras / recomendadas
🧠 Lógica central del sistema

El núcleo del sistema se basa en un modelo de filtrado:

cada usuario tiene restricciones alimentarias

cada restricción afecta ciertos ingredientes

cada receta contiene ingredientes

el sistema excluye recetas con ingredientes no permitidos

Este enfoque permite personalizar el contenido para cada usuario.

📡 Comunicación entre capas
Frontend → Backend

mediante HTTP (Axios)

envía datos en formato JSON

recibe respuestas JSON

Backend → Base de datos

mediante consultas SQL usando pg

operaciones CRUD

consultas complejas para filtrado de recetas

⚙️ Consideraciones técnicas

arquitectura desacoplada (frontend separado del backend)

uso de API REST

autenticación basada en JWT

modelo relacional en base de datos

uso de tablas intermedias para relaciones N:M

🚀 Escalabilidad

El sistema permite crecer fácilmente mediante:

separación de responsabilidades

posibilidad de agregar nuevos endpoints

integración con servicios externos

despliegue independiente de frontend y backend

🔮 Posibles mejoras arquitectónicas

implementación de middleware de autenticación

uso de ORM (Prisma o Sequelize)

cacheo de consultas frecuentes

sistema de microservicios (a futuro)

despliegue en la nube (Docker, AWS, etc.)