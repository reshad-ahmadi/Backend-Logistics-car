const crudRoutes = require('./crud.routes');
const controller = require('../controllers/border.controller');

module.exports = crudRoutes(controller);
