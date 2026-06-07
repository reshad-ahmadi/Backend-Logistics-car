INSERT INTO accounts (account_code, account_name, account_type)
VALUES
  ('1000', 'Cash', 'Asset'),
  ('1010', 'Bank', 'Asset'),
  ('1100', 'Customer Receivables', 'Asset'),
  ('2000', 'Payables', 'Liability'),
  ('3000', 'Owner Equity', 'Equity'),
  ('4000', 'Logistics Revenue', 'Revenue'),
  ('5000', 'Container Expenses', 'Expense'),
  ('5100', 'Truck Expenses', 'Expense'),
  ('5200', 'Border Expenses', 'Expense'),
  ('5300', 'Commission Expenses', 'Expense')
ON CONFLICT (account_code) DO NOTHING;
