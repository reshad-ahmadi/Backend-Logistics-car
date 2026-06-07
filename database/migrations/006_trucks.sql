CREATE TABLE drivers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  driver_name TEXT NOT NULL CHECK (length(trim(driver_name)) > 0),
  phone TEXT,
  license_number TEXT,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE trucks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  truck_number TEXT NOT NULL CHECK (length(trim(truck_number)) > 0),
  driver_id UUID REFERENCES drivers(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE truck_loads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  truck_id UUID NOT NULL REFERENCES trucks(id) ON DELETE RESTRICT,
  container_id UUID NOT NULL REFERENCES containers(id) ON DELETE RESTRICT,
  loading_date DATE NOT NULL,
  destination TEXT NOT NULL CHECK (length(trim(destination)) > 0),
  transport_charge NUMERIC(14, 2) NOT NULL DEFAULT 0 CHECK (transport_charge >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE truck_expenses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  truck_id UUID NOT NULL REFERENCES trucks(id) ON DELETE CASCADE,
  expense_type TEXT NOT NULL CHECK (expense_type IN ('Transport Fee', 'Penalty', 'Forklift', 'Other')),
  amount NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
  expense_date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX trucks_truck_number_uidx ON trucks (truck_number);
CREATE INDEX trucks_driver_id_idx ON trucks (driver_id);
CREATE INDEX truck_loads_truck_id_idx ON truck_loads (truck_id);
CREATE INDEX truck_loads_container_id_idx ON truck_loads (container_id);
CREATE INDEX truck_expenses_truck_id_idx ON truck_expenses (truck_id);
SELECT sync_updated_at('drivers');
SELECT sync_updated_at('trucks');
SELECT sync_updated_at('truck_loads');
SELECT sync_updated_at('truck_expenses');
