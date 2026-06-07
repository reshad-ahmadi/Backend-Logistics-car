const env = require('../config/env');
const { bearerAuth, schemas } = require('./schemas');
const { crudPaths, mergePaths } = require('./crudPaths');

const reportNames = [
  'daily', 'weekly', 'monthly', 'customers', 'containers', 'trucks',
  'exchange', 'border', 'profitLoss', 'generalBalance', 'containerSummary', 'ledger'
];

const paths = mergePaths(
  crudPaths('/api/customers', 'Customers'),
  crudPaths('/api/containers', 'Containers'),
  crudPaths('/api/trucks', 'Trucks'),
  crudPaths('/api/exchange', 'Exchange'),
  crudPaths('/api/border', 'Border'),
  crudPaths('/api/invoices', 'Invoices'),
  crudPaths('/api/payments', 'Payments'),
  crudPaths('/api/expenses/containers', 'Container Expenses'),
  crudPaths('/api/expenses/trucks', 'Truck Expenses'),
  crudPaths('/api/expenses/borders', 'Border Expenses'),
  crudPaths('/api/expenses/border-payments', 'Border Payments'),
  crudPaths('/api/operations/drivers', 'Drivers'),
  crudPaths('/api/operations/truck-loads', 'Truck Loads'),
  crudPaths('/api/operations/container-routes', 'Container Routes'),
  crudPaths('/api/operations/container-tracking', 'Container Tracking'),
  crudPaths('/api/accounting/accounts', 'Accounts'),
  crudPaths('/api/accounting/journal-entries', 'Journal Entries'),
  crudPaths('/api/accounting/journal-lines', 'Journal Lines'),
  {
    '/health': {
      get: {
        tags: ['System'],
        summary: 'Health check',
        responses: { 200: { description: 'API is running' } }
      }
    },
    '/api/auth/login': {
      post: {
        tags: ['Auth'],
        summary: 'Login and receive JWT',
        requestBody: {
          required: true,
          content: { 'application/json': { schema: { $ref: '#/components/schemas/LoginRequest' } } }
        },
        responses: { 200: { description: 'Token issued' }, 401: { description: 'Invalid credentials' } }
      }
    },
    '/api/auth/logout': {
      post: {
        tags: ['Auth'],
        summary: 'Logout (client deletes token)',
        security: [{ bearerAuth: [] }],
        responses: { 200: { description: 'OK' } }
      }
    },
    '/api/reports': {
      get: {
        tags: ['Reports'],
        summary: 'List available report keys',
        security: [{ bearerAuth: [] }],
        responses: { 200: { description: 'Report name list' } }
      }
    },
    '/api/reports/{name}': {
      get: {
        tags: ['Reports'],
        summary: 'Run a report view',
        security: [{ bearerAuth: [] }],
        parameters: [{
          name: 'name',
          in: 'path',
          required: true,
          schema: { type: 'string', enum: reportNames }
        }],
        responses: { 200: { description: 'Report rows' }, 404: { description: 'Unknown report' } }
      }
    }
  }
);

module.exports = {
  openapi: '3.0.3',
  info: {
    title: 'Backend Logistics API',
    version: '1.0.0',
    description: 'Container logistics and accounting API for offline LAN use.'
  },
  servers: [{ url: `http://localhost:${env.port}`, description: 'Local dev' }],
  paths,
  components: { securitySchemes: { bearerAuth }, schemas }
};
