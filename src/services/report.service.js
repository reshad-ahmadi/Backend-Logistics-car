const prisma = require('../config/database');
const { fail } = require('../utils/http');

const views = {
  daily: 'daily_report',
  weekly: 'weekly_report',
  monthly: 'monthly_report',
  customers: 'customer_balance_report',
  containers: 'container_expense_report',
  trucks: 'truck_expense_report',
  exchange: 'exchange_office_balance_report',
  border: 'border_office_balance_report',
  profitLoss: 'profit_and_loss_report',
  generalBalance: 'general_balance_report',
  containerSummary: 'container_report',
  ledger: 'account_balances'
};

async function getReport(name) {
  const view = views[name];
  if (!view) throw fail(404, 'Report not found');
  return prisma.$queryRawUnsafe(`SELECT * FROM "${view}"`);
}

module.exports = { getReport, views };
