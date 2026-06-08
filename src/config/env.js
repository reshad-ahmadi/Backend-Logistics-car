require('dotenv').config({ quiet: true });
const crypto = require('crypto');

function resolveDatabaseUrl() {
  if (process.env.DATABASE_URL) return process.env.DATABASE_URL;

  const host = process.env.PGHOST || process.env.POSTGRES_HOST;
  const user = process.env.PGUSER || process.env.POSTGRES_USER;
  const password = process.env.PGPASSWORD || process.env.POSTGRES_PASSWORD;
  const database = process.env.PGDATABASE || process.env.POSTGRES_DB;
  const port = process.env.PGPORT || process.env.POSTGRES_PORT || '5432';

  if (host && user && password && database) {
    const userPart = encodeURIComponent(user);
    const passPart = encodeURIComponent(password);
    return `postgresql://${userPart}:${passPart}@${host}:${port}/${database}`;
  }

  return null;
}

function resolveJwtSecret() {
  if (process.env.JWT_SECRET) return process.env.JWT_SECRET;

  if (process.env.RENDER) {
    const secret = crypto.randomBytes(32).toString('hex');
    console.warn(
      '[warn] JWT_SECRET is not set on Render. Using a temporary secret for this deploy. Add JWT_SECRET in Environment for stable logins.'
    );
    return secret;
  }

  return null;
}

const databaseUrl = resolveDatabaseUrl();
const jwtSecret = resolveJwtSecret();
const missing = [];

if (!databaseUrl) missing.push('DATABASE_URL');
if (!jwtSecret) missing.push('JWT_SECRET');

if (missing.length) {
  const onRender = Boolean(process.env.RENDER);
  const hint = onRender
    ? [
        '',
        'This is NOT a code bug. Render has no database connection configured.',
        '',
        'Fix in Render Dashboard (5 minutes):',
        '1. New → PostgreSQL → Create database',
        '2. Open Backend-Logistics-car → Environment',
        '3. Click "Add Environment Variable" → "Add from database" → pick your Postgres',
        '   (this adds DATABASE_URL automatically)',
        '4. Add JWT_SECRET manually (any long random string, 32+ chars)',
        '5. Save → wait for redeploy → Shell: npm run db:apply:node && npm run admin:create',
        '',
        'See RENDER_DEPLOY.md in the repo for full steps.'
      ].join('\n')
    : 'Copy .env.example to .env and set DATABASE_URL and JWT_SECRET.';
  throw new Error(`Missing required environment variables: ${missing.join(', ')}\n${hint}`);
}

process.env.DATABASE_URL = databaseUrl;

module.exports = {
  port: Number(process.env.PORT || 5000),
  databaseUrl,
  jwtSecret,
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || '8h',
  corsOrigin: process.env.CORS_ORIGIN || '*'
};
