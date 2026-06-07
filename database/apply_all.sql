\set ON_ERROR_STOP on

BEGIN;
\ir migrations/001_core.sql
\ir migrations/002_security.sql
\ir migrations/003_customers.sql
\ir migrations/004_containers.sql
\ir migrations/005_container_routes.sql
\ir migrations/006_trucks.sql
\ir migrations/007_exchange_border.sql
\ir migrations/008_border_expenses.sql
\ir migrations/009_invoices.sql
\ir migrations/010_accounting.sql
\ir migrations/011_audit.sql
\ir migrations/012_audit_triggers.sql
\ir migrations/013_customer_reports.sql
\ir migrations/014_operation_reports.sql
\ir migrations/015_office_reports.sql
\ir migrations/016_period_reports.sql
\ir migrations/017_financial_reports.sql
\ir seeds/001_roles_permissions.sql
\ir seeds/002_offices.sql
\ir seeds/003_accounts.sql
COMMIT;
