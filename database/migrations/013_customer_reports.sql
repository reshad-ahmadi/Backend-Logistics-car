CREATE VIEW customer_balance_report AS
SELECT
  c.id AS customer_id,
  c.customer_name,
  c.company_name,
  COALESCE(ca.opening_balance, 0) AS opening_balance,
  COALESCE(i.total_invoiced, 0) AS total_invoiced,
  COALESCE(p.total_paid, 0) AS total_paid,
  COALESCE(t.total_debit, 0) AS manual_debits,
  COALESCE(t.total_credit, 0) AS manual_credits,
  COALESCE(ca.opening_balance, 0) + COALESCE(i.total_invoiced, 0)
    + COALESCE(t.total_debit, 0) - COALESCE(p.total_paid, 0)
    - COALESCE(t.total_credit, 0) AS balance
FROM customers c
LEFT JOIN customer_accounts ca ON ca.customer_id = c.id AND ca.currency = 'AFN'
LEFT JOIN (
  SELECT customer_id, SUM(total_amount) AS total_invoiced
  FROM invoices
  WHERE status <> 'Cancelled'
  GROUP BY customer_id
) i ON i.customer_id = c.id
LEFT JOIN (
  SELECT customer_id, SUM(amount) AS total_paid
  FROM payments
  GROUP BY customer_id
) p ON p.customer_id = c.id
LEFT JOIN (
  SELECT
    customer_id,
    SUM(amount) FILTER (WHERE transaction_type = 'Debit') AS total_debit,
    SUM(amount) FILTER (WHERE transaction_type = 'Credit') AS total_credit
  FROM customer_transactions
  GROUP BY customer_id
) t ON t.customer_id = c.id;
