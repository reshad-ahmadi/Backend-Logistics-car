# Deploy on Render

## Why the app crashes

Render starts the API without your local `.env` file. The app **requires**:

| Variable | Purpose |
|----------|---------|
| `DATABASE_URL` | PostgreSQL connection string |
| `JWT_SECRET` | Signs login tokens |

If either is missing, the service crashes with:

`Missing required environment variables: DATABASE_URL, JWT_SECRET`

---

## Fix (existing Web Service)

### 1. Create PostgreSQL

- Render Dashboard → **New** → **PostgreSQL**
- Name: `backend-logistics-db`
- Plan: **Free** → **Create**

### 2. Link database + add JWT secret

Open **Backend-Logistics-car** → **Environment**:

**A) DATABASE_URL (recommended — one click)**  
- **Add Environment Variable** → **Add from database**  
- Select your PostgreSQL database  
- Render adds `DATABASE_URL` automatically  

**B) Or paste manually**  
- Key: `DATABASE_URL`  
- Value: Postgres → **Connections** → **Internal Database URL**

**C) JWT_SECRET (required — type manually)**  
| Key | Value |
|-----|--------|
| `JWT_SECRET` | Long random secret, e.g. `logistics_jwt_2026_change_me_to_random_32chars` |
| `JWT_EXPIRES_IN` | `8h` |
| `CORS_ORIGIN` | `*` or your frontend URL |

Click **Save Changes** (Render redeploys automatically).

> Pushing code to GitHub does **not** set these variables. You must add them in the Render dashboard.

### 3. Initialize database

When deploy status is **Live** → **Shell**:

```sh
npm run db:apply:node
npm run admin:create
```

### 4. Test

- `https://YOUR-SERVICE.onrender.com/health`
- `https://YOUR-SERVICE.onrender.com/api/docs`
- Login: `admin` / `Admin@12345`

---

## Alternative: Blueprint (auto env vars)

1. **New** → **Blueprint**
2. Connect repo `reshad-ahmadi/Backend-Logistics-car`
3. Render reads `render.yaml` and creates web + database with linked `DATABASE_URL`
4. After deploy, run Shell commands from step 3 above

---

## Frontend

Set in Cargo `.env`:

```env
VITE_API_URL=https://YOUR-SERVICE.onrender.com/api
```

Local data on your Mac is **not** copied to Render automatically.
