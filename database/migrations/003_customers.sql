CREATE TABLE customers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_name TEXT NOT NULL CHECK (length(trim(customer_name)) > 0),
  phone TEXT,
  address TEXT,
  company_name TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE customer_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  currency TEXT NOT NULL DEFAULT 'AFN',
  opening_balance NUMERIC(14, 2) NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (customer_id, currency),
  CHECK (currency IN ('AFN', 'USD', 'CNY', 'INR', 'AED', 'EUR'))
);

CREATE TABLE customer_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
  transaction_type TEXT NOT NULL CHECK (transaction_type IN ('Debit', 'Credit')),
  amount NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
  description TEXT,
  transaction_date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX customers_customer_name_idx ON customers (customer_name);
CREATE INDEX customer_accounts_customer_id_idx ON customer_accounts (customer_id);
CREATE INDEX customer_transactions_customer_id_idx ON customer_transactions (customer_id);
CREATE INDEX customer_transactions_transaction_date_idx ON customer_transactions (transaction_date);
SELECT sync_updated_at('customers');
SELECT sync_updated_at('customer_accounts');
SELECT sync_updated_at('customer_transactions');
