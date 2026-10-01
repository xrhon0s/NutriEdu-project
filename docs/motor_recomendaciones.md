# Motor de recomendaciones de NutriEdu

## 1. Objetivo

Construir un ranking determinista, explicable y auditable de recetas. El motor no diagnostica ni sustituye al profesional de salud. La IA puede extraer información, pero no decide la compatibilidad final: las restricciones, reglas y metas estructuradas son la fuente de verdad.

## 2. Principios

1. **Seguridad antes que afinidad.** Una receta incompatible con una restricción efectiva no participa en el ranking.
2. **No confundir ausencia de datos con compatibilidad.** Los nutrientes desconocidos reducen la confianza y se muestran como datos faltantes.
3. **No promediar conflictos clínicos.** Si un mínimo supera un máximo efectivo, el motor solicita revisión y conserva la procedencia de ambas reglas.
4. **Metas diarias y recetas por porción no se comparan directamente.** Las metas diarias se convierten a una referencia por comida usando el número de comidas del usuario.
5. **Resultados reproducibles.** El mismo perfil, reglas y catálogo produce el mismo orden.
6. **Explicabilidad.** Cada resultado incluye razones favorables, advertencias, factores utilizados, datos faltantes y nivel de confianza.

## 3. Fuentes del perfil

| Fuente | Uso |
| --- | --- |
| Restricciones explícitas | Exclusión dura por ingredientes |
| Estilo vegano o vegetariano | Restricción efectiva derivada del perfil |
| Objetivos activos | Reglas nutricionales ponderadas por prioridad |
| Condiciones confirmadas | Reglas clínicas y requisito de revisión profesional |
| Metas nutricionales | Rangos diarios convertidos a referencia por comida |
| Edad, sexo, peso, estatura y actividad | Estimación energética cuando no existe meta explícita y el perfil es aplicable |
| Comidas por día | Conversión de referencias diarias a valores por comida |
| Tiempo disponible para cocinar | Compatibilidad práctica |
| Frecuencia de comidas fuera de casa | Contexto visible; todavía no altera el score sin una regla validada |
| Condición física y notas libres | Contexto visible; no alteran el score sin una regla validada |

La estimación energética debe identificarse como estimación del sistema. Se basa en las ecuaciones EER por edad, sexo, peso, estatura y actividad de las [Dietary Reference Intakes for Energy 2023](https://www.ncbi.nlm.nih.gov/books/NBK591034/). No se calcula con sexo no binario/no informado, datos incompletos, menores de 19 años o embarazo; estos casos requieren una meta explícita o revisión profesional.

## 4. Precedencia

1. Restricciones y alergias efectivas.
2. Indicaciones profesionales confirmadas.
3. Reglas de condiciones clínicas, priorizando severidad.
4. Metas numéricas del usuario.
5. Objetivos activos según prioridad.
6. Preferencias y practicidad.
7. Regla global de calidad alimentaria.

## 5. Evaluación

### 5.1 Elegibilidad

Se excluye cualquier receta que contenga un ingrediente asociado con una restricción efectiva. Las condiciones no se convierten automáticamente en diagnósticos ni restricciones; una asociación sugerida por IA requiere confirmación.

### 5.2 Referencia por comida

Las metas explícitas se consideran diarias. Para una primera referencia neutral:

```txt
meta_por_comida = meta_diaria / comidas_por_día
```

La distribución podrá evolucionar por tipo de comida cuando el planificador almacene desayuno, almuerzo, cena y refrigerios con porcentajes configurables.

Si no existen límites explícitos de calorías y el perfil admite la ecuación EER, el motor crea un intervalo operativo de `EER ± 10%` antes de dividirlo entre las comidas. Ese margen es una decisión configurable del producto, no una prescripción clínica.

### 5.3 Score

El score empieza en 100 y registra cada ajuste:

- infracción clínica: penalización según severidad y riesgo;
- infracción de objetivo: penalización según severidad y prioridad;
- desviación de meta por comida: penalización proporcional y limitada;
- incompatibilidad de tiempo: penalización práctica limitada;
- calidad general: aporte pequeño basado en `nivel_salud`;
- datos faltantes: reducen confianza, no generan una falsa alerta de cumplimiento.

Las exclusiones duras no reciben score porque no son candidatas.

## 6. Datos nutricionales

Los nutrientes de una receta representan una porción. Cada registro debe conservar tamaño de porción, fuente y fecha de revisión. Desde la migración `010`, `receta_ingredientes` puede almacenar cantidades y unidades; la fase siguiente utilizará esos campos para calcular totales a partir de una fuente auditable como [USDA FoodData Central](https://fdc.nal.usda.gov/api-guide/).

## Sustituciones culinarias

Las sustituciones no forman parte del puntaje y no convierten automáticamente una receta insegura en segura. Primero se detecta un ingrediente incompatible; después se consultan ingredientes que no estén restringidos, no aparezcan ya en la receta y compartan su `substitution_group`. Esta taxonomía es más específica que `food_group`: pollo, tofu y salmón son proteínas, pero pertenecen a aves, proteína vegetal y pescado respectivamente.

Cuando el grupo es `other` o no existen candidatos de la misma función culinaria, el sistema devuelve cero alternativas. Es preferible declarar ausencia de datos que sugerir un reemplazo poco útil o clínicamente confuso.

Las nuevas recetas se preparan con la [plantilla de catálogo](plantilla_catalogo_recetas.md). La receta registra hechos nutricionales y no asociaciones directas con objetivos o condiciones: esas relaciones pertenecen al motor y a sus reglas versionadas.

## 7. Contrato de API

```txt
GET /api/recipes/recommendations?limit=6&offset=0
```

Respuesta resumida:

```json
{
  "recipes": [
    {
      "id": 1,
      "nombre": "Ejemplo",
      "recommendation": {
        "score": 88,
        "status": "suitable_with_adjustments",
        "confidence": 0.75,
        "reasons": [],
        "warnings": [],
        "missingNutrients": []
      }
    }
  ],
  "pagination": {},
  "profileContext": {
    "usedFactors": [],
    "missingFactors": [],
    "conflicts": [],
    "clinicalReviewRequired": false
  }
}
```

## 8. Estado de implementación

- [x] Restricciones como exclusiones duras.
- [x] Evaluación individual por objetivos, condiciones y metas.
- [x] Contexto efectivo único del perfil.
- [x] Conversión diaria a referencia por comida.
- [x] Ranking determinista y explicable.
- [x] Integración web y mobile.
- [x] Captura y procedencia nutricional en administración.
- [ ] Cantidades por ingrediente y cálculo nutricional automático.
- [ ] Completar nutrientes y porciones auditables del catálogo actual.
- [x] Plantilla canónica y validador previo a importación.
- [x] Importación JSON transaccional e idempotente.
- [ ] Conversión directa desde plantillas CSV.
- [ ] Validación clínica externa de reglas y ponderaciones.
