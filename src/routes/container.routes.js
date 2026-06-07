const crudRoutes = require('./crud.routes');
const controller = require('../controllers/container.controller');

module.exports = crudRoutes(controller);
