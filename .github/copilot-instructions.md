# NutriEdu - AI Coding Assistant Instructions

## Project Overview

NutriEdu is a full-stack web application for personalized recipe recommendations based on dietary restrictions. The system filters recipes to ensure users only see meals compatible with their restrictions (allergies, intolerances, medical conditions).

**Tech Stack:**
- Frontend: React 19 + Vite + Tailwind CSS
- Backend: Node.js + Express.js
- Database: PostgreSQL
- Auth: JWT + bcrypt

---

## Architecture & Data Flow

### The Personalization Core

The system's central logic revolves around **restriction-based filtering**:

```
User has Restrictions → Restrictions linked to Ingredients →
Recipes containing those Ingredients are filtered out → Safe Recipes returned
```

This is implemented in `recipeController.js` using a NOT IN subquery that joins:
- `usuario_restricciones` (user's restrictions)
- `ingrediente_restricciones` (which ingredients violate restrictions)
- `receta_ingredientes` (which ingredients are in each recipe)

**Key insight:** Always check the backend's recipe queries - they implement the core business logic of ingredient exclusion.

### Authentication Flow

1. User registers/logs in via frontend (`Register.jsx`, `Login.jsx`)
2. Backend validates credentials, hashes passwords with bcrypt
3. Backend generates JWT token (1-hour expiry in `process.env.JWT_SECRET`)
4. Frontend stores token in `localStorage`
5. `api.jsx` interceptor automatically adds `Authorization: Bearer {token}` to all requests

**Token management:** Stored in `localStorage.getItem("token")` - used in `ProtectedRoute.jsx` for route protection.

### Database Schema

**Critical relationships for filtering logic:**
- `usuario_restricciones`: Links users to their restrictions (N:M)
- `ingrediente_restricciones`: Maps restrictions to forbidden ingredients (N:M)
- `receta_ingredientes`: Lists ingredients per recipe (N:M)

When adding new restrictions or ingredients, maintain referential integrity through these junction tables.

---

## Development Workflows

### Backend Setup
```bash
cd nutriedu-backend
npm install
# Requires: .env file with DB_USER, DB_HOST, DB_NAME, DB_PASSWORD, DB_PORT, JWT_SECRET
node server.js
```

Runs on `http://localhost:3000` - Express auto-loads routes from `/routes` folder.

### Frontend Setup
```bash
cd nutriedu-frontend
npm install
npm run dev        # Vite dev server, hot reload enabled
npm run build      # Produces optimized build
npm run lint       # ESLint validation
```

Runs on `http://localhost:5173` (default Vite port). API calls target `http://localhost:3000/api`.

### Debugging Notes
- Backend: Server logs go to console - add `console.log()` for debugging
- Frontend: React DevTools + browser console for component state inspection
- Database errors: Check `.env` database connection vars and SQL syntax in controllers

---

## Code Patterns & Conventions

### Backend Patterns

**Controllers** (in `/controllers`) handle business logic:
- Use try/catch for async operations
- Parameterized queries with `$1, $2` syntax (protects against SQL injection)
- Return JSON responses with `message` field for errors/success
- Example status codes: `201` (created), `400` (validation), `401` (auth), `500` (server error)

**Route structure** (`/routes/userRoutes.js` exemplifies pattern):
```javascript
router.post("/endpoint", controllerFunction);
router.get("/resource/:id", getResourceById);
```

**Database pool** (`database/db.js`):
- Single `Pool` instance shared across app
- All queries use parameterized syntax: `pool.query("SELECT * FROM users WHERE id = $1", [id])`

### Frontend Patterns

**Pages** (in `/pages`) are full-screen components using `ProtectedRoute` wrapper:
- Use `useState` for local UI state
- Use `localStorage.getItem("user")` to access current user (set during login)
- Navigate after async completion: `setTimeout(() => navigate("/path"), duration)`

**API service** (`services/api.jsx`):
- Single axios instance with interceptor
- All API calls go through this service
- Base URL: `http://localhost:3000/api`
- Token automatically injected by interceptor

**Component styling:**
- Tailwind CSS utility-first approach (no CSS modules)
- Recurring pattern: gradient backgrounds `from-green-50 via-emerald-100 to-white`
- Status messages use color coding: green for success, red for errors

**Example request pattern** (from `Profile.jsx`):
```javascript
const res = await api.get(`/users/restrictions/${user.id}`);
// Check for data structure in response, not direct status
if (res.data.hasRestrictions) { /* process */ }
```

### Shared Convention

**Spanish naming:** All UI text, database columns, and comments are in Spanish. Keep this consistent when adding strings or database fields.

---

## Critical Integration Points

### API Endpoints to Know

**Users:**
- `POST /api/users/register` - Create new user
- `POST /api/users/login` - Authenticate user (returns token + user data)
- `POST /api/users/restrictions` - Save user's dietary restrictions
- `GET /api/users/restrictions/:userId` - Fetch user's restrictions

**Recipes:**
- `GET /api/recipes/safe/:userId` - Get non-filtered recipes for user
- `GET /api/recipes/recommended/:userId` - Get recipes sorted by health level & calories
- `GET /api/recipes/:id` - Get recipe details (ingredients, instructions)

**Planner:** (see `plannerRoutes.js` for meal planning endpoints)

### Cross-Component Communication

- No global state management (no Redux/Context used) - rely on `localStorage` and direct API calls
- User data passed through URL params (e.g., `/recipes/:id`) when needed
- Component state resets on page navigation

---

## Common Tasks & Solutions

**Adding a new dietary restriction:**
1. Insert into `restricciones` table
2. Link ingredients to it via `ingrediente_restricciones`
3. Frontend will automatically filter recipes (existing query logic handles new restrictions)

**Modifying recipe filter logic:**
- Edit the SQL query in `recipeController.js` `getSafeRecipes()` and `getRecommendedRecipes()`
- Both use the same NOT IN pattern - keep them in sync
- Test with users having different restriction combinations

**Fixing authentication issues:**
- Verify `JWT_SECRET` in `.env` matches between login generation and route protection
- Check `localStorage` for token presence in browser DevTools
- Confirm token expiry (currently 1 hour) meets UX expectations

---

## When to Refactor or Extend

**Current limitations to be aware of:**
- No refresh token mechanism (JWT expires after 1 hour, user must re-login)
- Restrictions and ingredients hardcoded on frontend (`restricciones` array in `Profile.jsx`)
- No email validation beyond regex
- No password strength requirements

**Recommended future improvements:**
- Move restriction definitions to database, fetch on app load
- Implement refresh token flow
- Add comprehensive error boundaries for React
- Add integration tests for API endpoints

---

## File Reference Guide

| Purpose | Location |
|---------|----------|
| Main entry point (routes) | `src/App.jsx` |
| API configuration & interceptor | `src/services/api.jsx` |
| Auth pattern exemplar | `src/components/ProtectedRoute.jsx` |
| Restriction selection pattern | `src/pages/Profile.jsx` |
| Recipe filtering logic | `nutriedu-backend/controllers/recipeController.js` |
| User auth endpoints | `nutriedu-backend/routes/userRoutes.js` |
| Database config | `nutriedu-backend/database/db.js` |
| Server setup | `nutriedu-backend/server.js` |
| Schema & entity relationships | `docs/bases_de_datos.md` |

---

## Questions or Ambiguities?

When extending this project, consult:
1. Existing controller patterns for similar features
2. `docs/arquitectura.md` for system design rationale
3. Database schema in `docs/bases_de_datos.md` before modifying queries
