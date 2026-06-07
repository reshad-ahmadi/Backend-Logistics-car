CREATE TABLE container_routes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  container_id UUID NOT NULL REFERENCES containers(id) ON DELETE CASCADE,
  border_name TEXT NOT NULL CHECK (length(trim(border_name)) > 0),
  arrival_date DATE,
  departure_date DATE,
  remarks TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (departure_date IS NULL OR arrival_date IS NULL OR departure_date >= arrival_date)
);

CREATE TABLE container_tracking (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  container_id UUID NOT NULL REFERENCES containers(id) ON DELETE CASCADE,
  location_name TEXT NOT NULL CHECK (length(trim(location_name)) > 0),
  tracking_status TEXT NOT NULL,
  tracking_date TIMESTAMPTZ NOT NULL DEFAULT now(),
  remarks TEXT,
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE container_expenses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  container_id UUID NOT NULL REFERENCES containers(id) ON DELETE CASCADE,
  expense_type TEXT NOT NULL
    CHECK (expense_type IN ('Customs', 'Commission', 'Loading', 'Border Fee', 'License', 'Other')),
  amount NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
  expense_date DATE NOT NULL DEFAULT CURRENT_DATE,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX container_routes_container_id_idx ON container_routes (container_id);
CREATE INDEX container_tracking_container_id_idx ON container_tracking (container_id);
CREATE INDEX container_tracking_date_idx ON container_tracking (tracking_date);
CREATE INDEX container_expenses_container_id_idx ON container_expenses (container_id);
CREATE INDEX container_expenses_expense_date_idx ON container_expenses (expense_date);
SELECT sync_updated_at('container_routes');
SELECT sync_updated_at('container_expenses');
