CREATE TABLE accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_code TEXT NOT NULL UNIQUE,
  account_name TEXT NOT NULL,
  account_type TEXT NOT NULL CHECK (account_type IN ('Asset', 'Liability', 'Equity', 'Revenue', 'Expense')),
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE journal_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entry_date DATE NOT NULL DEFAULT CURRENT_DATE,
  description TEXT NOT NULL CHECK (length(trim(description)) > 0),
  reference_type TEXT,
  reference_id UUID,
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE journal_entry_lines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  journal_entry_id UUID NOT NULL REFERENCES journal_entries(id) ON DELETE CASCADE,
  account_id UUID NOT NULL REFERENCES accounts(id) ON DELETE RESTRICT,
  debit_amount NUMERIC(14, 2) NOT NULL DEFAULT 0 CHECK (debit_amount >= 0),
  credit_amount NUMERIC(14, 2) NOT NULL DEFAULT 0 CHECK (credit_amount >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK ((debit_amount > 0 AND credit_amount = 0) OR (credit_amount > 0 AND debit_amount = 0))
);

CREATE VIEW account_balances AS
SELECT
  a.id AS account_id,
  a.account_code,
  a.account_name,
  a.account_type,
  COALESCE(SUM(jel.debit_amount), 0) AS total_debit,
  COALESCE(SUM(jel.credit_amount), 0) AS total_credit,
  COALESCE(SUM(jel.debit_amount - jel.credit_amount), 0) AS balance
FROM accounts a
LEFT JOIN journal_entry_lines jel ON jel.account_id = a.id
GROUP BY a.id, a.account_code, a.account_name, a.account_type;

CREATE INDEX journal_entries_entry_date_idx ON journal_entries (entry_date);
CREATE INDEX journal_entries_reference_idx ON journal_entries (reference_type, reference_id);
CREATE INDEX journal_entry_lines_entry_id_idx ON journal_entry_lines (journal_entry_id);
CREATE INDEX journal_entry_lines_account_id_idx ON journal_entry_lines (account_id);
SELECT sync_updated_at('accounts');
