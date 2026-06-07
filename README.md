# Backend Logistics
Offline LAN backend for container logistics and accounting.

## Stack
React frontend -> Node.js API -> PostgreSQL 16.

## Modules
- Security: users, roles, permissions, login history.
- Customers: accounts, transactions, balances.
- Containers: BL info, routes, status, tracking, expenses.
- Trucks: drivers, loads, expenses, transport charges.
- Offices: exchange and border transactions/balances.
- Finance: invoices, payments, journal entries, ledger.
- Reports: daily, weekly, monthly, P&L, balances.

## Setup
```sh
cp .env.example .env
npm install
npm run db:generate
docker compose up -d postgres
```

Apply database:
```sh
docker compose exec -T postgres psql -U logistics_user -d backend_logistics -f /database/apply_all.sql
```

Create admin and start API:
```sh
npm run admin:create
npm run dev
```

Base URL: `http://localhost:5000/api`.

## Notes
- bcrypt hashes passwords before storing.
- JWT protects all business routes.
- RBAC guards write and delete actions.
- Reports are read from PostgreSQL views.
