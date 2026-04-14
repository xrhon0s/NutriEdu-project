# Base de Datos - NutriEdu

La base de datos de NutriEdu está diseñada en PostgreSQL y utiliza un modelo relacional para gestionar usuarios, restricciones alimentarias, ingredientes y recetas.

---

## 🧩 Entidades principales

### Usuarios

Almacena la información de los usuarios registrados.

- id (PK)
- nombre
- email (único)
- password_hash
- fecha_registro

---

### Restricciones

Define tipos de restricciones alimentarias.

- id (PK)
- nombre
- descripcion

---

### Ingredientes

Lista de ingredientes disponibles.

- id (PK)
- nombre

---

### Recetas

Contiene las recetas disponibles en el sistema.

- id (PK)
- nombre
- descripcion
- calorias
- tiempo_preparacion
- nivel_salud

---

## 🔗 Relaciones

### usuario_restricciones

Relaciona usuarios con sus restricciones alimentarias.

- usuario_id (FK → usuarios.id)
- restriccion_id (FK → restricciones.id)

---

### ingrediente_restricciones

Relaciona ingredientes con restricciones alimentarias.

- ingrediente_id (FK → ingredientes.id)
- restriccion_id (FK → restricciones.id)

---

### receta_ingredientes

Relaciona recetas con sus ingredientes.

- receta_id (FK → recetas.id)
- ingrediente_id (FK → ingredientes.id)

---

## 🧠 Lógica del sistema

El sistema determina qué recetas son seguras para un usuario mediante el siguiente proceso:

1. Obtiene las restricciones del usuario
2. Identifica los ingredientes asociados a esas restricciones
3. Excluye las recetas que contienen dichos ingredientes

Esto permite generar recetas personalizadas y seguras según el perfil del usuario.

---

## 🧩 Tipo de relaciones

- Un usuario puede tener muchas restricciones (N:M)
- Una restricción puede afectar muchos ingredientes (N:M)
- Una receta puede tener muchos ingredientes (N:M)

---

## ⚙️ Consideraciones técnicas

- Se utilizan claves primarias en todas las entidades principales
- Las tablas intermedias usan claves compuestas
- Se definen claves foráneas para mantener integridad referencial
- El email del usuario es único