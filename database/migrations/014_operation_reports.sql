CREATE VIEW container_expense_report AS
SELECT
  c.id AS container_id,
  c.container_number,
  c.bl_number,
  c.origin_country,
  c.current_status,
  cu.customer_name,
  COALESCE(SUM(ce.amount), 0) AS total_expense
FROM containers c
JOIN customers cu ON cu.id = c.customer_id
LEFT JOIN container_expenses ce ON ce.container_id = c.id
GROUP BY c.id, c.container_number, c.bl_number, c.origin_country, c.current_status, cu.customer_name;

CREATE VIEW truck_expense_report AS
SELECT
  t.id AS truck_id,
  t.truck_number,
  d.driver_name,
  COALESCE(te.total_expense, 0) AS total_expense,
  COALESCE(tl.total_transport_charges, 0) AS total_transport_charges
FROM trucks t
LEFT JOIN drivers d ON d.id = t.driver_id
LEFT JOIN (
  SELECT truck_id, SUM(amount) AS total_expense
  FROM truck_expenses
  GROUP BY truck_id
) te ON te.truck_id = t.id
LEFT JOIN (
  SELECT truck_id, SUM(transport_charge) AS total_transport_charges
  FROM truck_loads
  GROUP BY truck_id
) tl ON tl.truck_id = t.id;

CREATE VIEW container_report AS
SELECT
  c.id AS container_id,
  c.container_number,
  c.bl_number,
  c.origin_country,
  c.loading_date,
  c.current_status,
  cu.customer_name,
  MAX(ct.tracking_date) AS last_tracking_at
FROM containers c
JOIN customers cu ON cu.id = c.customer_id
LEFT JOIN container_tracking ct ON ct.container_id = c.id
GROUP BY c.id, c.container_number, c.bl_number, c.origin_country,
  c.loading_date, c.current_status, cu.customer_name;
