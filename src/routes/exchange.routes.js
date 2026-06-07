const crudRoutes = require('./crud.routes');
const controller = require('../controllers/exchange.controller');

module.exports = crudRoutes(controller);
