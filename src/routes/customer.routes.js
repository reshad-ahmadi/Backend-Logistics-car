const crudRoutes = require('./crud.routes');
const controller = require('../controllers/customer.controller');

module.exports = crudRoutes(controller);
