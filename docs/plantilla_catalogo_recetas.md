# Plantilla de catálogo de recetas

## Objetivo

La plantilla v1 permite preparar recetas nuevas en una hoja de cálculo sin depender de IDs internos de PostgreSQL. Usa claves externas estables para relacionar recetas e ingredientes y conserva los datos que necesita el motor de recomendaciones.

Los archivos están en `nutriedu-backend/templates/recipe_catalog/`, dentro del repositorio que valida y posteriormente importará el catálogo:

- `recipes.csv`: receta y nutrientes por porción;
- `ingredients.csv`: catálogo de ingredientes y nutrientes por 100 g;
- `recipe_ingredients.csv`: cantidades que relacionan ambas hojas;
- `example.recipe.json`: representación canónica de una receta completa.
- `example.catalog.json`: lote JSON que el panel puede previsualizar e importar.

Los archivos históricos de `Schemas/` son exportaciones de base de datos y no deben utilizarse como plantilla de autoría.

## Regla principal

Una receta no declara que es "para hipertensión", "para ganar músculo" o "para diabetes". Registra hechos observables: ingredientes, cantidades, porción y nutrientes. El motor cruza esos datos con restricciones, condiciones, objetivos, prioridades y metas del usuario. Así se evita duplicar reglas clínicas dentro del catálogo.

## Campos de receta

| Campo | Regla |
| --- | --- |
| `external_key` | Obligatorio, único, estable y con formato `a-z`, números y guion bajo. |
| `nombre` | Obligatorio, máximo 160 caracteres. |
| `descripcion` | Descripción real del plato, máximo 2000 caracteres. |
| `calorias` | Kilocalorías por porción, valor positivo. |
| `tiempo_preparacion` | Minutos, entero positivo. |
| `nivel_salud` | Entero entre 1 y 5; es una señal secundaria, no una decisión clínica. |
| `serving_size_g` | Peso de la porción evaluada en gramos. |
| `servings` | Número de porciones producidas por la preparación. |
| nutrientes | Proteína, carbohidratos, grasas, grasa saturada, azúcar, fibra y sodio por porción. |
| `nutrition_source` | `manual`, `usda_fdc`, `calculated`, `ai_estimate` o `professional`. |
| `source_reference` | Referencia trazable, por ejemplo el ID de FoodData Central o documento profesional. |

Los ocho valores del bloque nutricional son los que determinan la confianza máxima del ranking. Un valor vacío se considera desconocido, nunca cero.

## Campos de ingrediente

`external_key` identifica el ingrediente entre archivos. `food_group` describe la familia nutricional general y `substitution_group` su función culinaria específica. Por ejemplo, pollo y tofu pertenecen a proteína, pero usan `poultry` y `plant_protein`, por lo que no se recomiendan automáticamente entre sí. `fdc_id` y los nutrientes por 100 g permiten recalcular recetas cuando cambian cantidades. `amount_g` es la cantidad normalizada que utilizará el cálculo; `amount` y `unit` conservan la medida comprensible para la receta.

## Flujo profesional de carga

```txt
Completar las tres hojas
  -> validar formato, claves, unidades y rangos
  -> resolver ingredientes existentes o nuevos
  -> calcular nutrientes desde amount_g cuando sea posible
  -> comparar cálculo con nutrientes declarados
  -> revisión humana y procedencia
  -> importación transaccional
  -> recomendación y reporte de confianza
```

La IA puede ayudar a proponer ingredientes o cantidades, pero una estimación conserva `nutrition_source=ai_estimate` y no se transforma automáticamente en dato profesional.

Actualmente el panel importa `example.catalog.json` o archivos con ese contrato. Las hojas CSV permiten trabajar en una hoja de cálculo, pero todavía deben convertirse al objeto JSON canónico; el parser CSV directo es trabajo pendiente.

La vista previa distingue `create`, `update` y `claim_and_update`. Esta última acción asigna una clave externa a una fila histórica encontrada por nombre solamente cuando no existe ambigüedad ni otra clave propietaria.

## Relación con el motor

1. Ingredientes y restricciones determinan la elegibilidad; el grupo de sustitución limita alternativas a funciones culinarias cercanas.
2. Nutrientes por porción se comparan con reglas y metas efectivas.
3. Porción y comidas por día permiten comparar periodos compatibles.
4. Tiempo de preparación se compara con las preferencias del usuario.
5. Procedencia y cobertura nutricional permiten comunicar confianza.

## Estado

- [x] Plantilla CSV y ejemplo JSON definidos.
- [x] Campos alineados con migraciones `010`, `011`, `012` y motor v1.
- [x] Validador JSON con rutas exactas de error.
- [x] Vista previa administrativa antes de importar.
- [x] Importación transaccional e idempotente por `external_key`.
- [ ] Cálculo automático desde nutrientes por 100 g y `amount_g`.
- [x] Persistencia de clave externa, fuente, referencia y revisor.
- [ ] Parser directo para las tres hojas CSV.
