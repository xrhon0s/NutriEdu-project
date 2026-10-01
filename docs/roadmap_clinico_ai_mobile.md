# Roadmap Clinico, IA y Mobile - NutriEdu

Este documento define la expansion de NutriEdu hacia una plataforma de nutricion personalizada con enfoque clinico, aplicacion movil y modulos de inteligencia artificial para analisis de alimentos y documentos medicos.

El objetivo no es reemplazar a un profesional de salud, sino apoyar decisiones alimentarias con informacion organizada, alertas claras y recomendaciones personalizadas.

## Vision del producto

NutriEdu debe evolucionar desde un sistema de recetas seguras por restricciones alimentarias hacia una plataforma capaz de:

- construir un perfil nutricional mas completo;
- considerar condiciones medicas, objetivos y habitos del usuario;
- limitar o recomendar variables nutricionales como calorias, proteina, carbohidratos, sodio, azucar, grasas y fibra;
- analizar fotos de comida desde el celular;
- analizar documentos medicos o recetas medicas con confirmacion del usuario;
- ofrecer una experiencia movil para uso diario en Android e iOS.

## Prioridad estrategica

La aplicacion movil debe priorizarse temprano porque los casos de uso de IA son naturalmente portables:

- el usuario toma una foto del plato antes de comer;
- el usuario escanea una receta medica, formula o resultado;
- el usuario consulta rapidamente si un alimento es seguro;
- el usuario recibe recomendaciones en contexto, fuera del computador.

Por esto, el roadmap no deja mobile como fase final. La app movil debe construirse como cliente principal de uso diario, mientras la web puede mantenerse como panel administrativo, consulta ampliada y soporte para gestion.

## Principios de diseno clinico

- Toda recomendacion debe explicar el motivo.
- Toda lectura de IA debe mostrar nivel de confianza.
- La IA no debe modificar informacion medica sin confirmacion del usuario.
- Las condiciones medicas deben tratarse como datos sensibles.
- Las recomendaciones deben usar lenguaje de apoyo, no diagnostico.
- El sistema debe permitir que el usuario corrija datos detectados por IA.
- Las reglas clinicas deben estar separadas del texto visual de la interfaz.

## Modulos principales

### 1. Perfil nutricional avanzado

El perfil se convierte en la fuente principal de personalizacion.

Variables sugeridas:

- edad;
- sexo;
- estatura;
- peso;
- nivel de actividad;
- condicion fisica;
- objetivo principal;
- objetivos secundarios;
- habitos alimentarios;
- horarios de comida;
- preferencias alimentarias;
- alergias;
- restricciones personales;
- condiciones medicas;
- medicamentos relevantes, si el usuario los confirma;
- metas nutricionales calculadas;
- limites nutricionales personalizados.

Ejemplos de limites o metas:

- calorias diarias;
- proteina diaria;
- carbohidratos diarios;
- grasa total;
- grasa saturada;
- azucar;
- sodio;
- fibra;
- agua.

### 2. Objetivos nutricionales

Los objetivos deben ser un catalogo controlado, no texto libre como unica fuente de verdad.

Objetivos iniciales sugeridos:

- ganar masa muscular;
- perder grasa corporal;
- mantener peso;
- mejorar salud general;
- controlar glucosa;
- reducir colesterol;
- controlar presion arterial;
- mejorar digestion;
- aumentar energia;
- mejorar rendimiento deportivo;
- seguir una dieta por indicacion medica;
- manejar alergias o intolerancias.

Cada objetivo debe definir variables relevantes.

Ejemplo:

```txt
Objetivo: ganar masa muscular
Variables clave:
- proteina objetivo;
- calorias de mantenimiento o superavit;
- frecuencia de comidas;
- actividad fisica;
- recuperacion;
- distribucion de proteina por comida.
```

```txt
Objetivo: perder grasa corporal
Variables clave:
- deficit calorico;
- proteina suficiente;
- control de azucar;
- control de ultraprocesados;
- alimentos de alta saciedad;
- seguimiento de peso y adherencia.
```

### 3. Condiciones clinicas y restricciones

Las restricciones actuales deben ampliarse para diferenciar:

- alergias;
- intolerancias;
- restricciones personales;
- restricciones religiosas o culturales;
- condiciones medicas;
- restricciones temporales;
- restricciones sugeridas por documento medico.

Condiciones iniciales sugeridas:

- diabetes;
- hipertension;
- colesterol alto;
- enfermedad renal;
- enfermedad cardiaca;
- celiaquia;
- intolerancia a lactosa;
- alergias alimentarias;
- gastritis;
- colon irritable;
- anemia;
- embarazo;
- obesidad.

Cada condicion debe mapearse a reglas nutricionales.

Ejemplo:

```txt
Condicion: hipertension
Variables relevantes:
- limite de sodio;
- alerta por alimentos procesados;
- alerta por embutidos, caldos concentrados y snacks altos en sal.
```

```txt
Condicion: enfermedad renal
Variables relevantes:
- proteina;
- sodio;
- potasio;
- fosforo;
- liquidos, si aplica.
Nota: esta condicion requiere especial cuidado y lenguaje conservador.
```

### 4. Motor de reglas nutricionales

Antes de depender de IA, NutriEdu necesita un motor de reglas claro.

Entrada:

```txt
Usuario + Perfil + Objetivo + Condiciones + Restricciones + Receta/Plato
```

Salida:

```txt
Evaluacion nutricional + Riesgos + Recomendaciones + Ajustes
```

Preguntas que debe responder:

- La receta contiene ingredientes prohibidos?
- La receta excede calorias para el perfil?
- La proteina es adecuada para el objetivo?
- El sodio es alto para la condicion del usuario?
- El azucar es alto para el objetivo o condicion?
- Hay ingredientes que se deben retirar?
- Hay ingredientes que se pueden reemplazar?
- Falta algun componente recomendado?
- La porcion debe reducirse o aumentarse?

Resultado esperado:

```txt
Suitability score: 82
Estado: apto con ajustes
Motivos:
- buen aporte de proteina;
- sodio moderado;
- calorias adecuadas para almuerzo.
Sugerencias:
- reducir salsa;
- agregar vegetales;
- evitar bebida azucarada.
```

### 5. IA para analisis de imagenes de comida

Este modulo debe ser mobile-first.

Flujo:

```txt
Usuario toma/sube foto desde mobile
  -> Backend recibe imagen
  -> IA identifica posible plato e ingredientes
  -> IA estima porcion y nutrientes con incertidumbre
  -> Motor de reglas evalua contra perfil
  -> Usuario recibe resultado y puede corregir
```

Respuesta esperada:

- plato probable;
- ingredientes detectados;
- ingredientes inciertos;
- estimacion nutricional;
- compatibilidad con el perfil;
- alertas;
- recomendaciones de retirar, reemplazar o agregar;
- nivel de confianza.

La IA debe evitar respuestas absolutas cuando la imagen no sea clara.

Ejemplo:

```txt
Detectado: pasta con pollo y salsa cremosa
Confianza: media
Riesgos:
- posible lactosa;
- grasa saturada moderada;
- calorias altas si la porcion es grande.
Recomendacion:
- reducir salsa;
- agregar ensalada;
- confirmar si la salsa contiene leche.
```

### 6. IA para documentos medicos

Este modulo permite analizar fotos o archivos de documentos.

Tipos de documentos:

- formula medica;
- receta medica;
- resultado de laboratorio;
- indicacion nutricional;
- historia clinica resumida, si el usuario decide subirla.

Flujo:

```txt
Usuario sube documento
  -> IA extrae texto y datos relevantes
  -> Sistema propone posibles condiciones o restricciones
  -> Usuario revisa y confirma
  -> Perfil se actualiza solo con aprobacion
```

Regla clave:

```txt
La IA nunca debe actualizar automaticamente condiciones medicas sin confirmacion explicita del usuario.
```

Ejemplo:

```txt
Detectamos posible tratamiento para presion arterial.
Quieres agregar "control de presion arterial" a tu perfil nutricional?
```

### 7. Aplicacion movil React Native

La app movil debe compartir backend, base de datos y autenticacion con la web.

Pantallas iniciales:

- login;
- registro;
- recuperacion de contrasena;
- onboarding de perfil;
- seleccion de objetivo;
- restricciones y condiciones;
- recetas recomendadas;
- detalle de receta;
- planificador;
- lista de compras;
- camara para analizar comida;
- subida de documento medico;
- resumen del perfil.

Uso esperado:

```txt
Mobile = experiencia diaria del usuario
Web = administracion, gestion amplia y soporte
```

Arquitectura recomendada:

```txt
React Native App
  -> HTTP/JSON
Backend Express existente
  -> PostgreSQL/Supabase

Web React
  -> HTTP/JSON
Mismo Backend Express
```

## Propuesta de base de datos

Nuevas entidades sugeridas:

### `user_profiles`

Datos antropometricos, estilo de vida y preferencias principales.

Campos posibles:

- `usuario_id`;
- `age`;
- `sex`;
- `height_cm`;
- `weight_kg`;
- `activity_level`;
- `physical_condition`;
- `eating_habits`;
- `created_at`;
- `updated_at`.

### `nutrition_goals`

Catalogo de objetivos.

- `id`;
- `code`;
- `name`;
- `description`;
- `is_active`.

### `user_goals`

Objetivos seleccionados por usuario.

- `usuario_id`;
- `goal_id`;
- `priority`;
- `status`;
- `created_at`.

### `clinical_conditions`

Catalogo de condiciones.

- `id`;
- `code`;
- `name`;
- `description`;
- `risk_level`;
- `requires_professional_guidance`.

### `user_conditions`

Condiciones confirmadas por usuario.

- `usuario_id`;
- `condition_id`;
- `source`;
- `confirmed_at`;
- `notes`.

### `nutrition_rules`

Reglas aplicables por objetivo o condicion.

- `id`;
- `scope_type`;
- `scope_id`;
- `nutrient`;
- `rule_type`;
- `min_value`;
- `max_value`;
- `unit`;
- `severity`;
- `message`.

### `user_nutrition_targets`

Metas calculadas o personalizadas por usuario.

- `usuario_id`;
- `calories_min`;
- `calories_max`;
- `protein_min_g`;
- `protein_max_g`;
- `carbs_max_g`;
- `fat_max_g`;
- `sodium_max_mg`;
- `sugar_max_g`;
- `fiber_min_g`;
- `updated_at`.

### `ai_analysis_logs`

Historial de analisis por IA.

- `id`;
- `usuario_id`;
- `analysis_type`;
- `input_file_url`;
- `ai_result_json`;
- `confidence`;
- `user_confirmed`;
- `created_at`.

## Flowjob principal

```txt
Registro/Login
  -> Onboarding movil
  -> Perfil basico: edad, peso, estatura, actividad
  -> Seleccion de objetivo principal
  -> Seleccion de restricciones y condiciones
  -> Calculo de metas nutricionales
  -> Motor de reglas queda activo
  -> Usuario consulta recetas o planifica comidas
  -> Usuario analiza foto de comida desde mobile
  -> IA identifica plato e ingredientes
  -> Motor de reglas evalua compatibilidad
  -> Usuario recibe recomendaciones
  -> Usuario puede subir documento medico
  -> IA extrae datos posibles
  -> Usuario confirma cambios
  -> Perfil se actualiza
  -> Recomendaciones futuras mejoran
```

## Roadmap recomendado

### Fase 1: Perfil y reglas base

Objetivo: preparar la base clinica sin IA.

- definir catalogo inicial de objetivos;
- definir catalogo inicial de condiciones;
- crear modelo de perfil avanzado;
- crear metas nutricionales por usuario;
- crear motor de reglas nutricionales;
- actualizar perfil web;
- preparar endpoints reutilizables por mobile.

### Fase 2: Mobile MVP

Objetivo: construir la experiencia movil base.

- crear proyecto React Native;
- conectar login y registro;
- conectar perfil;
- conectar objetivos y restricciones;
- mostrar recetas recomendadas;
- mostrar detalle de receta;
- permitir planificador simple;
- permitir lista de compras;
- preparar permisos de camara y subida de archivos.

### Fase 3: Evaluacion avanzada de recetas

Objetivo: mejorar lo que ya existe.

- agregar score de compatibilidad;
- mostrar motivos de la evaluacion;
- mostrar alertas nutricionales;
- sugerir reemplazos;
- sugerir ajustes de porcion;
- adaptar receta segun objetivo.

### Fase 4: IA para imagen de comida

Objetivo: analizar platos desde mobile.

- endpoint para subir imagen;
- integracion con modelo de vision;
- respuesta estructurada;
- evaluacion con motor de reglas;
- pantalla movil de resultado;
- correccion manual por usuario.

### Fase 5: IA para documentos medicos

Objetivo: extraer informacion sensible con confirmacion.

- endpoint para subir documento;
- extraccion de texto;
- deteccion de posibles condiciones;
- pantalla de revision;
- confirmacion antes de actualizar perfil;
- historial de cambios.

### Fase 6: Seguridad, privacidad y calidad

Objetivo: preparar una version mas profesional.

- consentimiento para datos medicos;
- logs de cambios del perfil;
- eliminacion de archivos sensibles;
- rate limiting;
- validaciones estrictas;
- pruebas automatizadas del motor de reglas;
- documentacion OpenAPI;
- monitoreo de errores.

## Riesgos y decisiones pendientes

- Definir si la IA guardara imagenes o solo resultados.
- Definir proveedor de almacenamiento para archivos.
- Definir proveedor de IA.
- Definir limites de responsabilidad medica.
- Definir si habra perfiles supervisados por nutricionista.
- Definir si los calculos nutricionales seran aproximados o certificados por fuente externa.
- Definir si mobile se hara con Expo o React Native CLI.

## Recomendacion tecnica inicial

Para avanzar sin romper el sistema actual:

1. Mantener el backend Express como API central.
2. Crear primero tablas nuevas sin eliminar las existentes.
3. Construir el motor de reglas como servicio backend independiente.
4. Crear endpoints pensados para web y mobile.
5. Iniciar mobile con React Native usando la misma API.
6. Agregar IA cuando el perfil y las reglas ya puedan evaluar resultados.

El orden recomendado es:

```txt
Perfil avanzado
  -> Objetivos y condiciones
  -> Motor de reglas
  -> Mobile MVP
  -> IA de comida
  -> IA de documentos
```
