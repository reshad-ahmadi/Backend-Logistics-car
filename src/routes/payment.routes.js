const crudRoutes = require('./crud.routes');
const controller = require('../controllers/payment.controller');

module.exports = crudRoutes(controller);
