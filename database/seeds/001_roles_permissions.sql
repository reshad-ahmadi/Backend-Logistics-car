INSERT INTO roles (role_name)
VALUES ('Admin'), ('Accountant'), ('Operator'), ('Manager')
ON CONFLICT (role_name) DO NOTHING;

INSERT INTO permissions (permission_key, description)
VALUES
  ('users.manage', 'Create and manage users'),
  ('customers.manage', 'Manage customers and accounts'),
  ('containers.manage', 'Manage containers and tracking'),
  ('trucks.manage', 'Manage trucks and drivers'),
  ('offices.manage', 'Manage exchange and border offices'),
  ('invoices.manage', 'Create and manage invoices'),
  ('payments.manage', 'Record customer payments'),
  ('accounting.manage', 'Manage journal and ledger entries'),
  ('reports.view', 'View financial and operations reports')
ON CONFLICT (permission_key) DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON r.role_name = 'Admin'
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.permission_key IN (
  'customers.manage', 'invoices.manage', 'payments.manage',
  'accounting.manage', 'reports.view'
)
WHERE r.role_name = 'Accountant'
ON CONFLICT DO NOTHING;
