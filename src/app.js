const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const env = require('./config/env');
const { requireAuth } = require('./middleware/auth.middleware');
const { notFound, errorHandler } = require('./middleware/error.middleware');

const app = express();

app.use('/api/docs', require('./config/swagger'));
app.get('/', (req, res) => res.redirect('/api/docs'));
app.use(helmet());
app.use(cors({ origin: env.corsOrigin === '*' ? true : env.corsOrigin }));
app.use(express.json({ limit: '1mb' }));
app.use(morgan('dev'));

app.get('/health', (req, res) => res.json({ success: true, status: 'ok' }));
app.use('/api/auth', require('./routes/auth.routes'));
app.use('/api/customers', requireAuth, require('./routes/customer.routes'));
app.use('/api/containers', requireAuth, require('./routes/container.routes'));
app.use('/api/trucks', requireAuth, require('./routes/truck.routes'));
app.use('/api/exchange', requireAuth, require('./routes/exchange.routes'));
app.use('/api/border', requireAuth, require('./routes/border.routes'));
app.use('/api/invoices', requireAuth, require('./routes/invoice.routes'));
app.use('/api/payments', requireAuth, require('./routes/payment.routes'));
app.use('/api/expenses', requireAuth, require('./routes/expense.routes'));
app.use('/api/operations', requireAuth, require('./routes/operation.routes'));
app.use('/api/accounting', requireAuth, require('./routes/accounting.routes'));
app.use('/api/reports', requireAuth, require('./routes/report.routes'));

app.use(notFound);
app.use(errorHandler);

module.exports = app;
