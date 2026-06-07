const crudRoutes = require('./crud.routes');
const controller = require('../controllers/invoice.controller');

module.exports = crudRoutes(controller);
