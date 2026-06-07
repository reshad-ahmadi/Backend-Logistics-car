require('dotenv').config({ quiet: true });
const fs = require('fs');
const path = require('path');
const { Client } = require('pg');

const files = [
  'migrations/001_core.sql',
  'migrations/002_security.sql',
  'migrations/003_customers.sql',
  'migrations/004_containers.sql',
  'migrations/005_container_routes.sql',
  'migrations/006_trucks.sql',
  'migrations/007_exchange_border.sql',
  'migrations/008_border_expenses.sql',
  'migrations/009_invoices.sql',
  'migrations/010_accounting.sql',
  'migrations/011_audit.sql',
  'migrations/012_audit_triggers.sql',
  'migrations/013_customer_reports.sql',
  'migrations/014_operation_reports.sql',
  'migrations/015_office_reports.sql',
  'migrations/016_period_reports.sql',
  'migrations/017_financial_reports.sql',
  'seeds/001_roles_permissions.sql',
  'seeds/002_offices.sql',
  'seeds/003_accounts.sql'
];

async function main() {
  const url = process.env.DATABASE_URL;
  if (!url) throw new Error('DATABASE_URL is required');

  const client = new Client({
    connectionString: url,
    ssl: url.includes('localhost') ? false : { rejectUnauthorized: false }
  });

  await client.connect();
  const root = path.join(__dirname, '..', 'database');

  for (const file of files) {
    const sql = fs.readFileSync(path.join(root, file), 'utf8');
    process.stdout.write(`Applying ${file}... `);
    await client.query(sql);
    process.stdout.write('ok\n');
  }

  await client.end();
  console.log('Database schema applied.');
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
