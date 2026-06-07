const express = require('express');
const { allowRoles } = require('../middleware/role.middleware');

function crudRoutes(controller) {
  const router = express.Router();
  const write = allowRoles('Admin', 'Manager', 'Accountant', 'Operator');

  router.get('/', controller.list);
  router.get('/:id', controller.get);
  router.post('/', write, controller.create);
  router.put('/:id', write, controller.update);
  router.delete('/:id', allowRoles('Admin', 'Manager'), controller.remove);

  return router;
}

module.exports = crudRoutes;
