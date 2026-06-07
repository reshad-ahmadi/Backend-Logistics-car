CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sync_updated_at(table_name text)
RETURNS void AS $$
BEGIN
  EXECUTE format(
    'CREATE TRIGGER set_%I_updated_at BEFORE UPDATE ON %I
     FOR EACH ROW EXECUTE FUNCTION set_updated_at()',
    table_name,
    table_name
  );
END;
$$ LANGUAGE plpgsql;
