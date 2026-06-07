CREATE TABLE containers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  container_number TEXT NOT NULL CHECK (length(trim(container_number)) > 0),
  bl_number TEXT NOT NULL CHECK (length(trim(bl_number)) > 0),
  origin_country TEXT NOT NULL CHECK (origin_country IN ('China', 'India', 'Dubai')),
  loading_date DATE NOT NULL,
  current_status TEXT NOT NULL DEFAULT 'Loaded'
    CHECK (current_status IN ('Loaded', 'In Transit', 'Customs', 'Unloaded', 'Delivered')),
  customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE bl_information (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  container_id UUID NOT NULL UNIQUE REFERENCES containers(id) ON DELETE CASCADE,
  bl_number TEXT NOT NULL,
  shipping_company TEXT,
  vessel_name TEXT,
  goods_description TEXT,
  gross_weight NUMERIC(14, 3),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE container_status (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  container_id UUID NOT NULL REFERENCES containers(id) ON DELETE CASCADE,
  status TEXT NOT NULL
    CHECK (status IN ('Loaded', 'In Transit', 'Customs', 'Unloaded', 'Delivered')),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX containers_container_number_uidx ON containers (container_number);
CREATE INDEX containers_bl_number_idx ON containers (bl_number);
CREATE INDEX containers_customer_id_idx ON containers (customer_id);
CREATE INDEX containers_loading_date_idx ON containers (loading_date);
CREATE INDEX container_status_container_id_idx ON container_status (container_id);
SELECT sync_updated_at('containers');
SELECT sync_updated_at('bl_information');
