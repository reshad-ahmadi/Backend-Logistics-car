CREATE VIEW monthly_report AS
SELECT date_trunc('month', report_date)::DATE AS month_start,
  SUM(total_invoiced) AS total_invoiced,
  SUM(total_paid) AS total_paid,
  SUM(container_expenses) AS container_expenses,
  SUM(truck_expenses) AS truck_expenses,
  SUM(border_expenses) AS border_expenses
FROM daily_report
GROUP BY date_trunc('month', report_date)::DATE;

CREATE VIEW profit_and_loss_report AS
SELECT
  COALESCE((SELECT SUM(total_amount) FROM invoices WHERE status <> 'Cancelled'), 0) AS revenue,
  COALESCE((SELECT SUM(amount) FROM container_expenses), 0) AS container_expenses,
  COALESCE((SELECT SUM(amount) FROM truck_expenses), 0) AS truck_expenses,
  COALESCE((SELECT SUM(amount) FROM border_expenses), 0) AS border_expenses,
  COALESCE((SELECT SUM(balance) FROM account_balances WHERE account_type = 'Expense'), 0) AS ledger_expenses,
  COALESCE((SELECT SUM(balance) FROM account_balances WHERE account_type = 'Revenue'), 0) AS ledger_revenue,
  COALESCE((SELECT SUM(total_amount) FROM invoices WHERE status <> 'Cancelled'), 0)
    - COALESCE((SELECT SUM(amount) FROM container_expenses), 0)
    - COALESCE((SELECT SUM(amount) FROM truck_expenses), 0)
    - COALESCE((SELECT SUM(amount) FROM border_expenses), 0) AS net_profit;

CREATE VIEW general_balance_report AS
SELECT
  COALESCE((SELECT SUM(balance) FROM customer_balance_report), 0) AS customer_receivables,
  COALESCE((SELECT SUM(amount) FROM payments), 0) AS total_cash_received,
  COALESCE((SELECT SUM(balance) FROM exchange_office_balance_report), 0) AS exchange_balance,
  COALESCE((SELECT SUM(balance) FROM border_office_balance_report), 0) AS border_balance,
  COALESCE((SELECT SUM(balance) FROM account_balances), 0) AS ledger_balance,
  COALESCE((SELECT net_profit FROM profit_and_loss_report), 0) AS net_profit;
