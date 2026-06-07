CREATE VIEW exchange_office_balance_report AS
SELECT
  eo.id AS office_id,
  eo.office_name,
  et.currency,
  COALESCE(SUM(et.amount) FILTER (WHERE et.transaction_type = 'Receive'), 0) AS total_received,
  COALESCE(SUM(et.amount) FILTER (WHERE et.transaction_type = 'Send'), 0) AS total_sent,
  COALESCE(SUM(CASE WHEN et.transaction_type = 'Receive' THEN et.amount ELSE -et.amount END), 0) AS balance
FROM exchange_offices eo
LEFT JOIN exchange_transactions et ON et.office_id = eo.id
GROUP BY eo.id, eo.office_name, et.currency;

CREATE VIEW border_office_balance_report AS
SELECT
  bo.id AS border_id,
  bo.office_name,
  COALESCE(bp.total_payments, 0) AS total_payments,
  COALESCE(be.total_expenses, 0) AS total_expenses,
  COALESCE(bp.total_payments, 0) - COALESCE(be.total_expenses, 0) AS balance
FROM border_offices bo
LEFT JOIN (
  SELECT border_id, SUM(amount) AS total_payments
  FROM border_payments
  GROUP BY border_id
) bp ON bp.border_id = bo.id
LEFT JOIN (
  SELECT border_id, SUM(amount) AS total_expenses
  FROM border_expenses
  GROUP BY border_id
) be ON be.border_id = bo.id;
