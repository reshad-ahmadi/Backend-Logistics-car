require('dotenv').config({ quiet: true });

const required = ['DATABASE_URL', 'JWT_SECRET'];
const missing = required.filter((key) => !process.env[key]);

if (missing.length) {
  const onRender = Boolean(process.env.RENDER);
  const hint = onRender
    ? [
        '',
        'Render setup:',
        '1. Create a PostgreSQL database on Render.',
        '2. Web Service → Environment → add DATABASE_URL (Internal Connection String).',
        '3. Add JWT_SECRET (any long random string, 32+ characters).',
        '4. Optional: JWT_EXPIRES_IN=8h, CORS_ORIGIN=*',
        '5. Redeploy, then Shell: npm run db:apply:node && npm run admin:create',
        '',
        'Or redeploy with New → Blueprint (uses render.yaml and links the database automatically).'
      ].join('\n')
    : 'Copy .env.example to .env and fill in DATABASE_URL and JWT_SECRET.';
  throw new Error(`Missing required environment variables: ${missing.join(', ')}\n${hint}`);
}

module.exports = {
  port: Number(process.env.PORT || 5000),
  databaseUrl: process.env.DATABASE_URL,
  jwtSecret: process.env.JWT_SECRET,
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || '8h',
  corsOrigin: process.env.CORS_ORIGIN || '*'
};
