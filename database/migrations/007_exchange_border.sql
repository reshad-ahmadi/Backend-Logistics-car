CREATE TABLE exchange_offices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  office_name TEXT NOT NULL UNIQUE CHECK (length(trim(office_name)) > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE exchange_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  office_id UUID NOT NULL REFERENCES exchange_offices(id) ON DELETE RESTRICT,
  transaction_type TEXT NOT NULL CHECK (transaction_type IN ('Receive', 'Send')),
  amount NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
  currency TEXT NOT NULL DEFAULT 'AFN'
    CHECK (currency IN ('AFN', 'USD', 'CNY', 'INR', 'AED', 'EUR')),
  transaction_date DATE NOT NULL DEFAULT CURRENT_DATE,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE border_offices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  office_name TEXT NOT NULL UNIQUE CHECK (length(trim(office_name)) > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE border_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  border_id UUID NOT NULL REFERENCES border_offices(id) ON DELETE RESTRICT,
  transaction_type TEXT NOT NULL CHECK (transaction_type IN ('Payment', 'Expense', 'Balance Adjustment')),
  amount NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
  description TEXT,
  transaction_date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX exchange_transactions_office_id_idx ON exchange_transactions (office_id);
CREATE INDEX exchange_transactions_transaction_date_idx ON exchange_transactions (transaction_date);
CREATE INDEX border_transactions_border_id_idx ON border_transactions (border_id);
CREATE INDEX border_transactions_transaction_date_idx ON border_transactions (transaction_date);
SELECT sync_updated_at('exchange_offices');
SELECT sync_updated_at('exchange_transactions');
SELECT sync_updated_at('border_offices');
SELECT sync_updated_at('border_transactions');
