CREATE TABLE invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_number TEXT NOT NULL CHECK (length(trim(invoice_number)) > 0),
  customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
  invoice_date DATE NOT NULL DEFAULT CURRENT_DATE,
  total_amount NUMERIC(14, 2) NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
  status TEXT NOT NULL DEFAULT 'Draft'
    CHECK (status IN ('Draft', 'Issued', 'Partially Paid', 'Paid', 'Overdue', 'Cancelled')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE invoice_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_id UUID NOT NULL REFERENCES invoices(id) ON DELETE CASCADE,
  description TEXT NOT NULL CHECK (length(trim(description)) > 0),
  amount NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
  invoice_id UUID REFERENCES invoices(id) ON DELETE SET NULL,
  amount NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
  payment_date DATE NOT NULL DEFAULT CURRENT_DATE,
  payment_method TEXT NOT NULL
    CHECK (payment_method IN ('Cash', 'Bank Transfer', 'Exchange Office', 'Cheque', 'Other')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX invoices_invoice_number_uidx ON invoices (invoice_number);
CREATE INDEX invoices_customer_id_idx ON invoices (customer_id);
CREATE INDEX invoices_invoice_date_idx ON invoices (invoice_date);
CREATE INDEX invoice_items_invoice_id_idx ON invoice_items (invoice_id);
CREATE INDEX payments_customer_id_idx ON payments (customer_id);
CREATE INDEX payments_invoice_id_idx ON payments (invoice_id);
CREATE INDEX payments_payment_date_idx ON payments (payment_date);
SELECT sync_updated_at('invoices');
SELECT sync_updated_at('invoice_items');
SELECT sync_updated_at('payments');
