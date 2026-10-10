# Guía temporal de implementación y prueba de patrones

> **Documento académico temporal.** Esta guía se publica para facilitar la revisión y sustentación de la actividad. No contiene credenciales, datos personales ni configuración privada. Debe retirarse de `docs/` y del índice del README cuando termine la evaluación.

## Motor de recomendaciones de NutriEdu

Esta guía indica qué archivos abrir, qué fragmentos mostrar, qué explicar y qué evitar durante la demostración técnica de los patrones de diseño.

## Alcance implementado

La actividad reorganiza el motor real de recomendaciones de NutriEdu, sin crear un ejemplo separado del producto. La implementación incluye:

- **Facade:** ofrece una entrada única al caso de uso completo de recomendaciones.
- **Factory Method:** decide qué estrategia construir según el objetivo prioritario del usuario.
- **Strategy:** modifica la priorización para ganancia muscular, pérdida de grasa, control cardiometabólico o balance general.
- **Chain of Responsibility:** divide la evaluación entre reglas nutricionales, metas, calidad, tiempo de preparación y confianza.
- **Pruebas contractuales:** validan estructura, comportamiento, ranking determinista y explicabilidad.
- **Smoke test autenticado:** recorre HTTP, autenticación, PostgreSQL y el motor con un usuario temporal que se elimina al finalizar.

## Mapa rápido de archivos

| Responsabilidad | Archivo |
| --- | --- |
| Ruta autenticada | `nutriedu-backend/routes/recipeRoutes.js` |
| Adaptación HTTP | `nutriedu-backend/controllers/recipeController.js` |
| Fachada del caso de uso | `nutriedu-backend/services/recommendation/recommendationFacade.js` |
| Creador y fábrica concreta | `nutriedu-backend/services/recommendation/strategyFactory.js` |
| Estrategias de objetivos | `nutriedu-backend/services/recommendation/strategies.js` |
| Cadena de evaluación | `nutriedu-backend/services/recommendation/evaluationChain.js` |
| Integración con datos y dominio | `nutriedu-backend/services/recommendationService.js` |
| Contrato específico del motor | `nutriedu-backend/scripts/recommendationEngineContractTest.js` |
| Integración autenticada | `nutriedu-backend/scripts/recommendationArchitectureSmokeTest.js` |

## Verificación rápida

Desde `nutriedu-backend/`:

```bash
npm test
npm run test:recommendations
```

Con el backend y PostgreSQL disponibles:

```bash
npm run test:recommendations-smoke
```

Los dos primeros comandos no requieren utilizar una cuenta personal. El smoke test crea y elimina su propio usuario de prueba.

---

## 1. Objetivo de la demostración

La demostración debe probar tres cosas:

1. Los patrones existen realmente en el código.
2. Los patrones participan en el flujo funcional de recomendaciones.
3. La implementación puede comprobarse mediante una prueba automatizada y una solicitud real.

No es necesario leer archivos completos. Debes explicar responsabilidades y colaboración entre componentes.

---

## 2. Preparación de VS Code

Antes de comenzar:

1. Abre el proyecto `NutriEdu` en VS Code.
2. Abre previamente los archivos indicados en esta guía.
3. Organiza las pestañas en el mismo orden del recorrido.
4. Oculta la barra lateral con `Cmd + B` en macOS o `Ctrl + B` en Windows/Linux.
5. Aumenta el tamaño del texto con `Cmd/Ctrl + +`.
6. Deja una terminal integrada abierta en la parte inferior.
7. Cierra archivos `.env` y cualquier pestaña que pueda mostrar credenciales.

Orden recomendado de pestañas:

```text
recipeRoutes.js
recipeController.js
recommendationFacade.js
strategyFactory.js
strategies.js
evaluationChain.js
recommendationService.js
recommendationEngineContractTest.js
```

---

## 3. Introducción oral

Puedes comenzar diciendo:

> Voy a recorrer una solicitud real desde el endpoint hasta el motor de recomendaciones. El controlador delega el caso de uso a una fachada; la fachada solicita una estrategia mediante Factory Method; una cadena evalúa cada receta y la estrategia adapta el puntaje al objetivo prioritario.

---

## 4. Paso 1: entrada HTTP y autenticación

### Archivo

`nutriedu-backend/routes/recipeRoutes.js`

### Fragmento

Líneas aproximadas 20 a 23:

```js
router.use(verifyToken);
router.get("/recommendations", getRankedRecommendations);
```

### Qué decir

> Esta es la entrada del módulo. Todas las rutas de recetas pasan primero por el middleware JWT. El endpoint de recomendaciones utiliza la identidad autenticada y no confía en un identificador arbitrario enviado por el cliente.

### Concepto demostrado

- Seguridad.
- Separación entre transporte HTTP y lógica de negocio.

---

## 5. Paso 2: controlador delgado

### Archivo

`nutriedu-backend/controllers/recipeController.js`

### Fragmento

Líneas aproximadas 43 a 51:

```js
const getRankedRecommendations = async (req, res) => {
  const limit = req.query.limit === undefined ? 6 : Number(req.query.limit);
  const offset = req.query.offset === undefined ? 0 : Number(req.query.offset);

  const result = await getRecipeRecommendations(pool, {
    userId: req.user.id,
    limit,
    offset
  });

  return res.json(result);
};
```

### Qué decir

> El controlador valida parámetros de transporte y delega. No contiene fórmulas nutricionales, reglas clínicas ni selección de estrategias. Esto evita mezclar HTTP con dominio.

### Pregunta probable

**¿Por qué no implementar todo en el controlador?**

Porque tendría múltiples motivos de cambio, sería difícil de probar y acoplaría el algoritmo a Express.

---

## 6. Paso 3: patrón Facade

### Archivo

`nutriedu-backend/services/recommendation/recommendationFacade.js`

### Fragmento principal

Líneas aproximadas 18 a 33:

```js
const context = await this.loadContext(pool, userId, now);
const recipes = await this.loadRecipes(
  pool,
  userId,
  context.effectiveRestrictions
);
const strategy = this.strategyFactory.create(context);

const ranked = recipes.map((recipe) => ({
  ...recipe,
  recommendation: this.evaluateRecipe(recipe, context, strategy)
}));
```

### Qué decir

> RecommendationFacade proporciona una entrada sencilla a un subsistema formado por persistencia, Factory Method, Strategy, Chain of Responsibility, ranking y paginación.

Después muestra las líneas aproximadas 35 a 50:

```js
return {
  recipes: page,
  pagination: { /* ... */ },
  profileContext: {
    ...this.buildContextSummary(context),
    recommendationStrategy: {
      code: strategy.code,
      label: strategy.label
    }
  }
};
```

### Idea para memorizar

> La fachada coordina, pero no implementa las reglas nutricionales.

### Ventaja

El controlador solo conoce una operación y no necesita conocer las clases internas.

### Riesgo

Una fachada puede crecer demasiado. Por eso debe coordinar y delegar, no concentrar cálculos.

---

## 7. Paso 4: patrón Factory Method

### Archivo

`nutriedu-backend/services/recommendation/strategyFactory.js`

### Creador base

```js
class RecommendationStrategyCreator {
  create(context) {
    const primaryGoal = [...(context.goals || [])]
      .sort(/* prioridad */)[0];

    return this.factoryMethod(primaryGoal);
  }

  factoryMethod() {
    throw new Error("Debe implementarse");
  }
}
```

### Creador concreto

```js
class RecommendationStrategyFactory
  extends RecommendationStrategyCreator {
  factoryMethod(primaryGoal) {
    if (primaryGoal?.code === "gain_muscle") {
      return new MuscleGainRecommendationStrategy();
    }

    if (primaryGoal?.code === "lose_body_fat") {
      return new FatLossRecommendationStrategy();
    }

    return new BalancedRecommendationStrategy();
  }
}
```

### Qué decir

> El creador base define el proceso de creación y delega el producto concreto al método `factoryMethod`, implementado por la subclase. La fachada solicita una estrategia sin construir directamente sus clases concretas.

### Diferencia importante

Una fábrica simple tendría un único método con condicionales. Aquí existe un creador base y una subclase que implementa el método de fabricación; por eso se presenta como Factory Method.

### Pregunta probable

**¿Qué ocurre si no existe un objetivo especializado?**

La fábrica devuelve `BalancedRecommendationStrategy`, que funciona como comportamiento predeterminado.

---

## 8. Paso 5: patrón Strategy

### Archivo

`nutriedu-backend/services/recommendation/strategies.js`

### Contrato común

```js
class RecommendationStrategy {
  constructor(code, label) {
    this.code = code;
    this.label = label;
  }

  apply(_recipe, _context, evaluation) {
    return evaluation;
  }
}
```

### Ganancia muscular

```js
class MuscleGainRecommendationStrategy
  extends RecommendationStrategy {
  apply(recipe, context, evaluation) {
    const protein = numericValue(recipe.protein_g);
    const target = context.targetProfile.perMeal.protein_g?.min ?? 25;

    if (protein !== null && protein >= target) {
      evaluation.score += 6;
      addReason(evaluation,
        "Aporte proteico alineado con el objetivo de ganar masa muscular."
      );
    }

    return evaluation;
  }
}
```

### Pérdida de grasa

```js
class FatLossRecommendationStrategy
  extends RecommendationStrategy {
  apply(recipe, context, evaluation) {
    // Considera control energético y fibra.
    return evaluation;
  }
}
```

### Qué decir

> Strategy encapsula algoritmos intercambiables. Todas las estrategias respetan `apply`, pero cada una interpreta el objetivo de forma diferente. El cliente puede utilizar cualquiera sin cambiar su flujo.

### Aclaración clínica

La estrategia solo añade ajustes limitados de priorización. No elimina advertencias ni convierte una receta insegura en segura.

### Pregunta probable

**¿Por qué Strategy si las reglas ya están en la base de datos?**

Las reglas representan límites configurables. Strategy representa la política de priorización para un objetivo. Son responsabilidades diferentes.

---

## 9. Paso 6: patrón Chain of Responsibility

### Archivo

`nutriedu-backend/services/recommendation/evaluationChain.js`

### Manejador base

```js
class EvaluationHandler {
  setNext(handler) {
    this.next = handler;
    return handler;
  }

  handle(recipe, context, evaluation, dependencies) {
    this.process(recipe, context, evaluation, dependencies);

    if (this.next) {
      return this.next.handle(
        recipe,
        context,
        evaluation,
        dependencies
      );
    }

    return evaluation;
  }
}
```

### Ensamblaje de la cadena

Líneas aproximadas 193 a 200:

```js
const rules = new NutritionRuleHandler();
const targets = rules.setNext(new NutritionTargetHandler());
const quality = targets.setNext(new RecipeQualityHandler());
const cooking = quality.setNext(new CookingTimeHandler());
cooking.setNext(new ConfidenceHandler());
```

### Orden

```text
nutrition_rules
  -> nutrition_targets
  -> recipe_quality
  -> cooking_time
  -> confidence
```

### Qué decir

> Cada manejador atiende una responsabilidad y pasa la evaluación al siguiente. El orden está definido en un único lugar y podemos agregar otro paso sin reescribir los existentes.

### Manejador para mostrar

Usa `NutritionRuleHandler` como ejemplo. Explica que:

- obtiene el nutriente relacionado con una regla;
- registra el nutriente como faltante cuando no existe;
- aplica una penalización si se incumple;
- genera una advertencia explicable.

### Pregunta probable

**¿Por qué se considera Chain of Responsibility si todos los pasos se ejecutan?**

Porque la solicitud circula por objetos enlazados mediante un manejador base. Es una variante acumulativa: cada eslabón procesa una parte y entrega el control al siguiente.

---

## 10. Paso 7: integración real de los patrones

### Archivo

`nutriedu-backend/services/recommendationService.js`

### Fragmento de evaluación

Líneas aproximadas 201 a 218:

```js
const evaluation = getRecipeEvaluationChain()
  .evaluate(recipe, context);

strategy.apply(recipe, context, evaluation);
```

### Fragmento de fachada

Líneas aproximadas 380 a 387:

```js
const recommendationFacade = new RecommendationFacade({
  loadContext: loadRecommendationContext,
  loadRecipes: loadEligibleRecipes,
  evaluateRecipe,
  buildContextSummary
});

const getRecipeRecommendations = (pool, options) =>
  recommendationFacade.getRecommendations(pool, options);
```

### Qué decir

> Este fragmento demuestra que los patrones no son ejemplos aislados. La función usada por el controlador delega realmente en RecommendationFacade, y la evaluación ejecuta la cadena y después la estrategia seleccionada.

---

## 11. Paso 8: prueba automatizada

### Archivo

`nutriedu-backend/scripts/recommendationEngineContractTest.js`

### Fragmentos que debes señalar

```js
assert.ok(
  strategyFactory.create({
    goals: [{ code: "gain_muscle", prioridad: 1 }]
  }) instanceof MuscleGainRecommendationStrategy
);
```

```js
assert.deepEqual(
  getRecipeEvaluationChain().getHandlerNames(),
  [
    "nutrition_rules",
    "nutrition_targets",
    "recipe_quality",
    "cooking_time",
    "confidence"
  ]
);
```

```js
assert.equal(
  result.profileContext.recommendationStrategy.code,
  "gain_muscle"
);
```

### Comando

```bash
cd nutriedu-backend
npm run test:recommendations
```

### Resultado esperado

```json
{
  "ok": true,
  "dailyTargetsConverted": true,
  "energyEstimateAttributed": true,
  "conflictsDetected": true,
  "deterministicRanking": true,
  "explainableResults": true,
  "patternsVerified": [
    "strategy",
    "factory_method",
    "chain_of_responsibility",
    "facade"
  ]
}
```

### Qué decir

> Esta prueba no comprueba solamente que las clases existan. Verifica que la fábrica produzca estrategias concretas, que la cadena tenga el orden esperado y que el resultado final utilice la estrategia correcta.

---

## 12. Prueba completa de integración

Con el backend encendido:

```bash
npm run test:recommendations-smoke
```

Este comando:

1. crea un usuario temporal;
2. inicia sesión por HTTP;
3. guarda perfil, objetivo y metas;
4. consulta PostgreSQL a través de la API;
5. obtiene recomendaciones;
6. verifica estrategia, paginación, puntajes y orden;
7. elimina el usuario temporal.

Durante la sustentación basta con ejecutar la prueba contractual. Conserva el smoke test como evidencia adicional o alternativa.

---

## 13. Demostración en navegador

1. Inicia sesión.
2. Abre **Perfil**.
3. Selecciona **Ganar masa muscular** como objetivo principal.
4. Guarda los cambios.
5. Abre **Recetas**.
6. En DevTools abre **Network**.
7. Selecciona la solicitud `recommendations?limit=6&offset=0`.
8. En `Response`, busca `recommendationStrategy`.

Debe aparecer:

```json
"recommendationStrategy": {
  "code": "gain_muscle",
  "label": "Ganancia de masa muscular"
}
```

Cambia el objetivo principal a **Perder grasa corporal** y repite. Ahora debe aparecer:

```json
"recommendationStrategy": {
  "code": "lose_body_fat",
  "label": "Pérdida de grasa corporal"
}
```

Esto demuestra visualmente Factory Method y Strategy utilizando el mismo endpoint.

---

## 14. Guion resumido de siete minutos

### Minuto 0-1

Presenta el problema, el alcance y el flujo general.

### Minuto 1-2

Muestra ruta y controlador.

### Minuto 2-3

Muestra Facade y explica su coordinación.

### Minuto 3-4

Muestra Factory Method y Strategy.

### Minuto 4-5

Muestra Chain of Responsibility.

### Minuto 5-6

Ejecuta la prueba automatizada.

### Minuto 6-7

Muestra la respuesta en DevTools y concluye.

---

## 15. Frase de cierre

> Los patrones no fueron incorporados para aumentar artificialmente el número de clases. Cada uno resuelve un problema real: Facade simplifica el caso de uso, Factory Method desacopla la creación, Strategy encapsula variaciones por objetivo y Chain of Responsibility separa los pasos de evaluación. El contrato de la API se conserva y el comportamiento queda probado y explicado.

---

## 16. Qué no debes hacer

- No mostrar archivos `.env`.
- No leer código línea por línea.
- No abrir todo `recommendationService.js` desde el inicio.
- No afirmar que el sistema diagnostica.
- No afirmar que el puntaje es una probabilidad clínica.
- No ocultar que existen nutrientes pendientes en el catálogo.
- No llamar Factory Method a un simple condicional sin explicar el creador base.
- No ejecutar comandos que no hayas probado previamente.

---

## 17. Lista de ensayo

- [ ] Puedo explicar el flujo sin mirar el documento.
- [ ] Encuentro cada archivo rápidamente.
- [ ] Distingo Facade, Factory Method, Strategy y Chain of Responsibility.
- [ ] Puedo explicar por qué cada patrón fue necesario.
- [ ] Puedo ejecutar `npm run test:recommendations`.
- [ ] Sé buscar `recommendationStrategy` en DevTools.
- [ ] Sé explicar los valores nutricionales `null` y la confianza baja.
- [ ] Puedo terminar la demostración en siete minutos.

---

## Retiro después de la actividad

La eliminación normal es suficiente porque este documento no contiene secretos. Deben retirarse el archivo y su enlace en el README mediante un commit posterior:

```bash
git rm docs/guia_temporal_actividad_patrones.md
```

No se debe reescribir el historial de Git para eliminarlo. Las guías personales y notas de estudio deben mantenerse en `private-docs/`, directorio ignorado por Git.
