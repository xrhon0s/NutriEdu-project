# Base de Datos - NutriEdu

NutriEdu usa PostgreSQL como base de datos relacional. En desarrollo puede ejecutarse localmente y en despliegue se usa Supabase PostgreSQL. El modelo almacena usuarios, restricciones alimentarias, ingredientes, recetas, planes semanales y tokens de recuperacion de contrasena.

## Entidades principales

### `usuarios`

Almacena las cuentas registradas.

- `id` como clave primaria.
- `nombre`.
- `food_group`: `protein`, `carbohydrate`, `vegetable`, `fruit`, `dairy`, `fat`, `legume`, `seasoning`, `beverage` u `other`.
- `substitution_group`: función culinaria específica usada para buscar alternativas cercanas, por ejemplo `poultry`, `fish`, `plant_protein`, `grain` o `cooking_fat`.

La migracion `009_ingredient_food_groups.sql` agrega la categoria, una restriccion `CHECK`, un indice compuesto y una clasificacion inicial del catalogo existente. Los grupos describen familias alimentarias; calorias, proteina y carbohidratos medidos siguen siendo nutrientes de recetas, no categorias intercambiables.

La migración `012_ingredient_substitution_groups.sql` agrega una taxonomía distinta y más estricta para sustituciones. Dos ingredientes pueden compartir `food_group=protein` y no ser equivalentes: pollo usa `poultry`, tofu `plant_protein` y salmón `fish`. Solo los ingredientes seguros del mismo `substitution_group` se consideran candidatos; `other` nunca genera alternativas automáticas.
- `email` unico.
- `password_hash`.
- `rol`.
- `fecha_registro`.

### `restricciones`

Catalogo de restricciones alimentarias.

- `id` como clave primaria.
- `nombre`.
- `descripcion`.
- `is_active`, agregado por la migracion `008` para retiro no destructivo.

Las restricciones inactivas no aparecen como nuevas opciones para usuarios, pero sus relaciones existentes se conservan para trazabilidad y seguridad.

### `ingredientes`

Catalogo de ingredientes.

- `id` como clave primaria.
- `nombre`.

### `recetas`

Recetas disponibles en la aplicacion.

- `id` como clave primaria.
- `nombre`.
- `descripcion`.
- `calorias`.
- `tiempo_preparacion`.
- `nivel_salud`.
- `serving_size_g` y `servings` para definir la porcion evaluada.
- `nutrition_source` y `nutrition_reviewed_at` para trazabilidad.
- columnas nutricionales opcionales agregadas por migracion:
  - `protein_g`;
  - `carbs_g`;
  - `fat_g`;
  - `saturated_fat_g`;
  - `sugar_g`;
  - `fiber_g`;
  - `sodium_mg`.

## Perfil clinico avanzado

La expansion clinica inicial se define en:

```txt
nutriedu-backend/migrations/001_clinical_profile_foundation.sql
```

Esta migracion agrega tablas nuevas sin eliminar el modelo actual.

### `perfiles_usuario`

Perfil avanzado asociado a `usuarios`.

- `usuario_id` como clave primaria y foranea.
- `fecha_nacimiento`.
- `sexo`.
- `estatura_cm`.
- `peso_kg`.
- `nivel_actividad`.
- `condicion_fisica`.
- `habitos_alimentarios` como JSONB.
- `preferencias_alimentarias` como JSONB.
- `notas`.
- `created_at`.
- `updated_at`.

### `objetivos_nutricionales`

Catalogo controlado de objetivos.

- `id` como clave primaria.
- `code` unico para uso estable desde frontend, mobile e IA.
- `nombre`.
- `descripcion`.
- `is_active`.

### `usuario_objetivos`

Relacion entre usuario y objetivos nutricionales.

- `usuario_id`.
- `objetivo_id`.
- `prioridad`.
- `estado`: `active`, `paused` o `completed`.
- `created_at`.
- `updated_at`.

### `condiciones_clinicas`

Catalogo controlado de condiciones clinicas.

- `id` como clave primaria.
- `code` unico.
- `nombre`.
- `descripcion`.
- `risk_level`: `low`, `medium` o `high`.
- `requires_professional_guidance`.
- `is_active`.

### `usuario_condiciones`

Condiciones clinicas confirmadas para un usuario.

- `usuario_id`.
- `condicion_id`.
- `source`: `user`, `ai_document`, `professional` o `admin`.
- `confirmed_at`.
- `notes`.
- `created_at`.
- `updated_at`.

La IA no debe insertar condiciones confirmadas sin aprobacion explicita del usuario.

### `reglas_nutricionales`

Reglas aplicables por objetivo, condicion o regla global.

- `scope_type`: `goal`, `condition` o `global`.
- `scope_code`.
- `nutrient`.
- `rule_type`: `min`, `max`, `range` o `recommendation`.
- `min_value`.
- `max_value`.
- `unit`.
- `severity`: `info`, `warning` o `danger`.
- `message`.
- `is_active`.

### `usuario_metas_nutricionales`

Metas o limites nutricionales del usuario.

- `usuario_id`.
- `calories_min`.
- `calories_max`.
- `protein_min_g`.
- `protein_max_g`.
- `carbs_min_g`.
- `carbs_max_g`.
- `fat_min_g`.
- `fat_max_g`.
- `saturated_fat_max_g`.
- `sugar_max_g`.
- `fiber_min_g`.
- `sodium_max_mg`.
- `water_min_ml`.
- `calculation_source`: `manual`, `system`, `ai_document` o `professional`.
- `notes`.
- `created_at`.
- `updated_at`.

## Control de uso de vision

El control durable de costo se define en:

```txt
nutriedu-backend/migrations/002_vision_usage_limits.sql
```

### `vision_analysis_usage`

Registra metadatos operativos de cada intento de analisis visual, nunca la imagen.

- `request_id` UUID como clave primaria.
- `usuario_id` referencia `usuarios.id`.
- `provider` y `model`.
- `status`: `pending`, `succeeded` o `failed`.
- `input_tokens`, `output_tokens` y `total_tokens`.
- `reserved_cost_usd` para reservar presupuesto antes de llamar al proveedor.
- `estimated_cost_usd` calculado con el consumo real informado.
- `error_code` sin contenido de la imagen.
- `created_at` y `completed_at`.

El backend usa una transaccion y un bloqueo asesor de PostgreSQL para que solicitudes concurrentes no superen el presupuesto antes de reservarlo. La tabla no almacena fotografias, ingredientes detectados ni resultados clinicos.

## Auditoria de documentos medicos

La revision y aplicacion explicita de hallazgos se define en:

```txt
nutriedu-backend/migrations/003_medical_document_audit.sql
```

El PDF o la imagen original se procesa en memoria y no se guarda. La auditoria comienza con los datos estructurados que el usuario confirma en la pantalla de revision.

### `revisiones_documentos_medicos`

Registra la extraccion corregida y la seleccion humana antes de modificar el perfil.

- `id` como clave primaria.
- `usuario_id` referencia `usuarios.id`.
- `request_id` identifica el flujo de intake del usuario.
- `schema_version` versiona el contrato estructurado.
- `document_type` clasifica el documento sin almacenar el archivo.
- `extraction` JSONB con la extraccion revisada.
- `accepted_finding_ids` JSONB con IDs aceptados.
- `accepted_findings` JSONB con hallazgos agrupados.
- `status`: `reviewed` o `applied`.
- `reviewed_at` y `updated_at`.

La pareja `usuario_id` y `request_id` es unica. Una revision aplicada no puede reemplazarse.

### `aplicaciones_documentos_medicos`

Registra la confirmacion final y el cambio exacto aplicado.

- `id` como clave primaria.
- `revision_id` referencia unica a `revisiones_documentos_medicos.id`.
- `usuario_id` referencia `usuarios.id`.
- `confirmation_version` identifica el texto de confirmacion.
- `preview_hash` SHA-256 protege la correspondencia entre vista previa y aplicacion.
- `applied_changes` JSONB contiene condiciones, metas y hallazgos excluidos.
- `applied_at`.

La aplicacion se ejecuta en una transaccion. Las condiciones son aditivas y las metas diarias conservan los campos no propuestos. Medicamentos e indicaciones libres no se escriben en campos de perfil inexistentes.

### Retencion de revisiones

La migracion siguiente agrega el ciclo de vida:

```txt
nutriedu-backend/migrations/004_medical_document_retention.sql
```

Agrega a `revisiones_documentos_medicos`:

- `retention_policy_version`, actualmente `1.0`;
- `expires_at`, con 30 dias para revisiones no aplicadas;
- indice parcial para limpiar revisiones `reviewed` vencidas.

Al aplicar una revision, `expires_at` se establece en `NULL`. El registro aplicado se conserva hasta eliminar la cuenta y se elimina por las claves foraneas con `ON DELETE CASCADE`.

## Eliminacion de cuenta

La migracion siguiente completa las cascadas del modelo original:

```txt
nutriedu-backend/migrations/005_account_deletion_cascades.sql
```

Antes de esta migracion, `plan_semanal` y `usuario_restricciones` usaban `NO ACTION`. Despues de aplicarla, las nueve tablas que referencian directamente `usuarios` usan `ON DELETE CASCADE`.

El comando `npm run audit:user-deletion` consulta metadatos de PostgreSQL y falla si encuentra una relacion directa sin cascada. La eliminacion de cuenta se ejecuta dentro de una transaccion y una violacion de clave foranea produce un rechazo seguro en lugar de un borrado parcial.

## Ciclo de vida de restricciones

La migracion siguiente permite administrar el catalogo sin borrar relaciones:

```txt
nutriedu-backend/migrations/008_restriction_catalog_lifecycle.sql
```

Agrega `restricciones.is_active` e `idx_restricciones_active_name`. Esta estrategia permite desactivar una opcion para perfiles nuevos, mientras las asociaciones en `usuario_restricciones` e `ingrediente_restricciones` permanecen intactas.

## Tablas de relacion

### `usuario_restricciones`

Relacion muchos a muchos entre usuarios y restricciones.

- `usuario_id` referencia `usuarios.id`.
- `restriccion_id` referencia `restricciones.id`.

### `ingrediente_restricciones`

Relaciona ingredientes con restricciones alimentarias.

- `ingrediente_id` referencia `ingredientes.id`.
- `restriccion_id` referencia `restricciones.id`.

### `receta_ingredientes`

Relaciona recetas con ingredientes.

- `receta_id` referencia `recetas.id`.
- `ingrediente_id` referencia `ingredientes.id`.
- `amount`, `unit` y `amount_g` permiten registrar cantidades para el calculo nutricional posterior.

La migracion `010_recipe_nutrition_provenance.sql` agrega estos campos y extiende `ingredientes` con `fdc_id`, nutrientes por 100 g, procedencia y fecha de revision.

La lista de compras multiplica naturalmente cada relación por las apariciones de su receta en `plan_semanal`. Suma `amount_g` cuando existe y también agrupa `amount` por `unit`; una relación sin ambos valores queda marcada como cantidad faltante. La API añade una firma determinista construida con receta, día y tipo de comida, sin necesitar una tabla adicional para los checks locales.

La migracion `011_recipe_catalog_imports.sql` agrega `external_key`, referencia de fuente y usuario revisor a recetas e ingredientes. Los indices parciales unicos permiten que filas históricas mantengan una clave nula mientras todo registro importado obtiene identidad estable.

### `recipe_catalog_imports`

Audita cada importación confirmada:

- `imported_by` identifica al administrador y usa `ON DELETE SET NULL`;
- `schema_version` y `payload_sha256` identifican el contrato y contenido;
- conteos separados registran recetas e ingredientes creados o actualizados;
- `report` conserva el resumen y las advertencias;
- `created_at` registra el momento del commit.

La API obtiene un advisory lock transaccional, vuelve a calcular la vista previa y solo entonces aplica todo el lote. Un error revierte recetas, ingredientes, relaciones y auditoría.

La plantilla JSON y `ingredients.csv` admiten `substitutionGroup`/`substitution_group`. Si falta, la validación emite una advertencia y el importador conserva `other`, lo que evita sugerencias hasta que un administrador clasifique el ingrediente.

### `usuario_recetas_favoritas`

Relacion muchos a muchos entre usuarios y recetas, agregada por `013_user_recipe_favorites.sql`.

- `usuario_id` referencia `usuarios.id` con `ON DELETE CASCADE`;
- `receta_id` referencia `recetas.id` con `ON DELETE CASCADE`;
- la clave primaria compuesta evita guardar dos veces la misma receta para una cuenta;
- `created_at` permite ordenar el listado desde la receta guardada mas reciente;
- el indice `(usuario_id, created_at DESC, receta_id DESC)` soporta la paginacion por cuenta.

El favorito expresa interes del usuario, no compatibilidad clinica permanente. Al consultar el listado, el backend vuelve a evaluar las restricciones actuales y marca recetas que requieren revision.

## Planificador

El planificador semanal guarda recetas asociadas a un usuario, un dia y un tipo de comida.

Campos esperados:

- usuario.
- receta.
- dia de la semana.
- tipo de comida: desayuno, almuerzo o cena.

Este modulo permite generar posteriormente la lista de compras.

## Recuperacion de contrasena

### `password_reset_tokens`

Tabla creada automaticamente por el backend cuando se usa el flujo de recuperacion.

- `id` como clave primaria.
- `usuario_id` referencia `usuarios.id`.
- `token_hash`.
- `expires_at`.
- `used_at`.
- `created_at`.

El token real no se guarda en base de datos. El backend guarda un hash SHA-256 del token enviado por correo. Cuando el usuario abre el enlace, el backend hashea el token recibido y lo compara con `token_hash`.

## Logica de recetas seguras

El filtrado de recetas sigue este proceso:

1. Obtener restricciones del usuario desde `usuario_restricciones`.
2. Obtener ingredientes asociados a esas restricciones desde `ingrediente_restricciones`.
3. Buscar recetas que contengan esos ingredientes mediante `receta_ingredientes`.
4. Excluir recetas incompatibles.
5. Evaluar las candidatas mediante el perfil nutricional efectivo.
6. Ordenarlas de forma determinista y devolver explicaciones y confianza.

## Logica de evaluacion nutricional

La evaluacion personalizada de recetas se apoya en:

- restricciones alimentarias existentes;
- objetivos activos del usuario;
- condiciones clinicas confirmadas;
- metas nutricionales del usuario;
- reglas activas en `reglas_nutricionales`;
- datos nutricionales disponibles en `recetas`.

El endpoint inicial es:

```txt
GET /api/recipes/evaluate/:recipeId
```

El ranking para listados se obtiene con:

```txt
GET /api/recipes/recommendations?limit=6&offset=0
```

Las metas introducidas por el usuario son diarias. El motor las divide entre `meals_per_day` antes de compararlas con nutrientes por porcion y conserva la fuente del valor. Si falta informacion nutricional, no asume que la receta cumple: reduce `confidence` y declara `missingNutrients`.

Respuesta esperada:

- `score`: puntaje de compatibilidad de 0 a 100;
- `status`: `suitable`, `suitable_with_adjustments`, `review_required` o `not_suitable`;
- `unsafeIngredients`: ingredientes incompatibles por restricciones;
- `alerts`: alertas por reglas o metas nutricionales;
- `context`: objetivos, condiciones y presencia de metas usadas en la evaluacion.

Si una receta aun no tiene datos como proteina, sodio o azucar, esas reglas no generan una falsa conformidad: el ranking reduce la confianza y muestra los nutrientes faltantes.

## Relaciones principales

- Un usuario puede tener muchas restricciones.
- Una restriccion puede pertenecer a muchos usuarios.
- Una restriccion puede afectar muchos ingredientes.
- Un ingrediente puede estar asociado a muchas restricciones.
- Una receta puede tener muchos ingredientes.
- Un ingrediente puede aparecer en muchas recetas.
- Un usuario puede tener varias comidas planificadas.
- Un usuario puede tener varios tokens de recuperacion historicos, pero solo los no usados y no expirados son validos.

## Consideraciones tecnicas

- Las contrasenas se almacenan como hashes bcrypt.
- El correo del usuario debe ser unico.
- Las tablas intermedias mantienen relaciones muchos a muchos.
- Los tokens de recuperacion expiran y se marcan como usados.
- Se recomienda agregar migraciones versionadas para reproducir el schema en otros entornos.

## Datos de apoyo

El proyecto incluye archivos CSV en `Schemas/` con datos iniciales o de referencia:

- `ingredientes.csv`
- `restricciones.csv`
- `ingredientes_restricciones.csv`
- `recetas.csv`
- `recetas_ingredientes.csv`

Para Supabase, primero se ejecuta el `schema.sql` en el SQL Editor y despues se importan los CSV en orden de dependencias:

1. `restricciones.csv`
2. `ingredientes.csv`
3. `recetas.csv`
4. `ingredientes_restricciones.csv`
5. `recetas_ingredientes.csv`

Despues de importar, se puede validar con:

```sql
SELECT COUNT(*) FROM restricciones;
SELECT COUNT(*) FROM ingredientes;
SELECT COUNT(*) FROM recetas;
SELECT COUNT(*) FROM ingrediente_restricciones;
SELECT COUNT(*) FROM receta_ingredientes;
```
### `usuario_progreso`

Historial longitudinal introducido por `014_user_progress_tracking.sql`:

- pertenece a `usuarios` con `ON DELETE CASCADE`;
- permite una medicion por usuario y `recorded_on`;
- registra opcionalmente peso, cintura, grasa corporal, adherencia, energia y notas;
- exige al menos una variable cuantificable y aplica rangos mediante restricciones `CHECK`;
- conserva `source`, `created_at` y `updated_at` para trazabilidad;
- se indexa por usuario y fecha descendente para historial y ultima medicion.

`perfiles_usuario.peso_kg` representa el valor vigente usado por recomendaciones; `usuario_progreso` conserva su historia. Guardar o eliminar una medicion recalcula el peso vigente a partir del registro con peso mas reciente.
