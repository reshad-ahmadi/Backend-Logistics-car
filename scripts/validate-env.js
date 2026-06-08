#!/usr/bin/env node
/**
 * Quick check before deploy — run: node scripts/validate-env.js
 * Exits 0 when DATABASE_URL and JWT_SECRET are set.
 */
require('dotenv').config({ quiet: true });

const hasDb = Boolean(
  process.env.DATABASE_URL?.trim() ||
    process.env.POSTGRES_URL?.trim() ||
    process.env.PGHOST ||
    process.env.POSTGRES_HOST
);
const hasJwt = Boolean(process.env.JWT_SECRET?.trim() || process.env.RENDER);

if (hasDb && hasJwt) {
  console.log('OK: required environment variables are set.');
  process.exit(0);
}

console.error('Missing environment variables for deploy:');
if (!hasDb) console.error('  - DATABASE_URL (or linked Postgres on Render)');
if (!hasJwt) console.error('  - JWT_SECRET');
console.error('\nSee RENDER_DEPLOY.md');
process.exit(1);
