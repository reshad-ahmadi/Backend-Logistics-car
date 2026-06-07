CREATE VIEW daily_report AS
SELECT
  d.report_date,
  COALESCE(i.total_invoiced, 0) AS total_invoiced,
  COALESCE(p.total_paid, 0) AS total_paid,
  COALESCE(ce.container_expenses, 0) AS container_expenses,
  COALESCE(te.truck_expenses, 0) AS truck_expenses,
  COALESCE(be.border_expenses, 0) AS border_expenses
FROM (
  SELECT invoice_date AS report_date FROM invoices
  UNION SELECT payment_date FROM payments
  UNION SELECT expense_date FROM container_expenses
  UNION SELECT expense_date FROM truck_expenses
  UNION SELECT expense_date FROM border_expenses
) d
LEFT JOIN (
  SELECT invoice_date, SUM(total_amount) AS total_invoiced
  FROM invoices WHERE status <> 'Cancelled' GROUP BY invoice_date
) i ON i.invoice_date = d.report_date
LEFT JOIN (
  SELECT payment_date, SUM(amount) AS total_paid
  FROM payments GROUP BY payment_date
) p ON p.payment_date = d.report_date
LEFT JOIN (
  SELECT expense_date, SUM(amount) AS container_expenses
  FROM container_expenses GROUP BY expense_date
) ce ON ce.expense_date = d.report_date
LEFT JOIN (
  SELECT expense_date, SUM(amount) AS truck_expenses
  FROM truck_expenses GROUP BY expense_date
) te ON te.expense_date = d.report_date
LEFT JOIN (
  SELECT expense_date, SUM(amount) AS border_expenses
  FROM border_expenses GROUP BY expense_date
) be ON be.expense_date = d.report_date;

CREATE VIEW weekly_report AS
SELECT date_trunc('week', report_date)::DATE AS week_start,
  SUM(total_invoiced) AS total_invoiced, SUM(total_paid) AS total_paid,
  SUM(container_expenses) AS container_expenses, SUM(truck_expenses) AS truck_expenses,
  SUM(border_expenses) AS border_expenses
FROM daily_report GROUP BY date_trunc('week', report_date)::DATE;
