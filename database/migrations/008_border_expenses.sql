CREATE TABLE border_expenses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  border_id UUID NOT NULL REFERENCES border_offices(id) ON DELETE RESTRICT,
  container_id UUID REFERENCES containers(id) ON DELETE SET NULL,
  expense_type TEXT NOT NULL DEFAULT 'Other',
  amount NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
  expense_date DATE NOT NULL DEFAULT CURRENT_DATE,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE border_payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  border_id UUID NOT NULL REFERENCES border_offices(id) ON DELETE RESTRICT,
  amount NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
  payment_date DATE NOT NULL DEFAULT CURRENT_DATE,
  payment_method TEXT NOT NULL DEFAULT 'Cash',
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX border_expenses_border_id_idx ON border_expenses (border_id);
CREATE INDEX border_expenses_container_id_idx ON border_expenses (container_id);
CREATE INDEX border_expenses_expense_date_idx ON border_expenses (expense_date);
CREATE INDEX border_payments_border_id_idx ON border_payments (border_id);
CREATE INDEX border_payments_payment_date_idx ON border_payments (payment_date);
SELECT sync_updated_at('border_expenses');
SELECT sync_updated_at('border_payments');
