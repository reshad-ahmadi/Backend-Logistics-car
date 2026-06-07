const crudRoutes = require('./crud.routes');
const controller = require('../controllers/truck.controller');

module.exports = crudRoutes(controller);
