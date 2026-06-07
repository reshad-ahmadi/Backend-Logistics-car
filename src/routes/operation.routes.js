const express = require('express');
const crudRoutes = require('./crud.routes');
const makeController = require('../controllers/crud.controller');

const router = express.Router();

router.use('/drivers', crudRoutes(makeController('drivers')));
router.use('/truck-loads', crudRoutes(makeController('truck_loads')));
router.use('/container-routes', crudRoutes(makeController('container_routes')));
router.use('/container-tracking', crudRoutes(makeController('container_tracking')));

module.exports = router;
