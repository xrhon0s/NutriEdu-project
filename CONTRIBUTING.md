# Contribuir a NutriEdu

NutriEdu se distribuye en repositorios públicos. Todo archivo versionado debe ser útil para comprender, ejecutar, verificar o mantener el producto sin exponer información personal, académica o secreta.

## Límites de los repositorios

- `NutriEdu-project`: documentación técnica general, arquitectura, esquemas y referencias a los productos.
- `NutriEdu`: backend Node.js/Express y migraciones PostgreSQL.
- `NutriEdu-frontend`: cliente web React/Vite.
- `NutriEdu-mobile`: cliente React Native/Expo.

Cada producto conserva su propio historial, pruebas y workflow de integración continua.

## Documentación pública

Puede versionarse:

- arquitectura y decisiones técnicas;
- modelo de datos y migraciones;
- contratos de API;
- instrucciones de instalación, pruebas y despliegue;
- roadmaps técnicos sin datos personales;
- limitaciones verificables y estado del producto;
- diagramas y ejemplos con datos ficticios.

No debe versionarse:

- guías personales de estudio o libretos de exposición;
- actividades académicas, rúbricas o portadas con datos del curso;
- notas privadas, borradores personales o retroalimentación del docente;
- capturas con correos, tokens, IDs sensibles o información médica real;
- archivos `.env`, credenciales, claves API o cadenas de conexión;
- exportaciones de bases de datos con datos de usuarios.

Los materiales personales se conservan localmente en `private-docs/`, carpeta ignorada por Git.

## Seguridad y privacidad

Antes de confirmar cambios:

```bash
git status --short
git diff --check
git diff --cached
```

Revisa especialmente:

- secretos o valores reales dentro de ejemplos;
- logs con cuerpos, correos, tokens o contraseñas;
- datos médicos o nutricionales asociados a personas reales;
- archivos generados, respaldos y dependencias.

Si un secreto llegó a GitHub, eliminar el archivo en un commit posterior no invalida el secreto. Debe rotarse inmediatamente y, cuando sea necesario, limpiarse del historial.

## Verificación antes de un pull request

Backend:

```bash
cd nutriedu-backend
npm ci
npm test
```

Frontend:

```bash
cd nutriedu-frontend
npm ci
npm run lint -- --max-warnings=0
npm run build
```

Mobile:

```bash
cd nutriedu-mobile
npm ci
npm test
npm run typecheck
npm run lint
npx expo export --platform all
```

Las pruebas smoke que escriben datos temporales no forman parte del CI sin credenciales. Deben declarar su limpieza y ejecutarse conscientemente contra el ambiente elegido.

## Cambios de base de datos

- Crear una migración nueva; no editar una migración aplicada.
- Ejecutar `npm run migrate:status` antes de migrar.
- No usar baseline cuando el verificador de una migración falla.
- Mantener consultas parametrizadas y restricciones de integridad.
- Documentar cualquier cambio de contrato consumido por web o mobile.

## Criterios de revisión

Un cambio está listo cuando:

- respeta las fronteras del módulo afectado;
- incluye pruebas proporcionales al riesgo;
- conserva compatibilidad o documenta la ruptura;
- no añade secretos ni información personal;
- actualiza README y documentación técnica cuando corresponde;
- pasa el workflow de CI del repositorio modificado.
