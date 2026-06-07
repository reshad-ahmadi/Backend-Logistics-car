CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  table_name TEXT NOT NULL,
  record_id UUID,
  operation TEXT NOT NULL CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
  old_data JSONB,
  new_data JSONB,
  changed_by TEXT NOT NULL DEFAULT current_user,
  changed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  client_addr INET DEFAULT inet_client_addr()
);

CREATE OR REPLACE FUNCTION audit_row_changes()
RETURNS trigger AS $$
DECLARE
  row_id UUID;
BEGIN
  IF TG_OP = 'DELETE' THEN
    row_id = NULLIF(to_jsonb(OLD)->>'id', '')::UUID;
  ELSE
    row_id = NULLIF(to_jsonb(NEW)->>'id', '')::UUID;
  END IF;

  INSERT INTO audit_logs (table_name, record_id, operation, old_data, new_data)
  VALUES (
    TG_TABLE_NAME,
    row_id,
    TG_OP,
    CASE WHEN TG_OP IN ('UPDATE', 'DELETE') THEN to_jsonb(OLD) ELSE NULL END,
    CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN to_jsonb(NEW) ELSE NULL END
  );

  IF TG_OP = 'DELETE' THEN
    RETURN OLD;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE INDEX audit_logs_table_record_idx ON audit_logs (table_name, record_id);
CREATE INDEX audit_logs_changed_at_idx ON audit_logs (changed_at);
