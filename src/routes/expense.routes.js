const express = require('express');
const crudRoutes = require('./crud.routes');
const makeController = require('../controllers/crud.controller');

const router = express.Router();

router.use('/containers', crudRoutes(makeController('container_expenses')));
router.use('/trucks', crudRoutes(makeController('truck_expenses')));
router.use('/borders', crudRoutes(makeController('border_expenses')));
router.use('/border-payments', crudRoutes(makeController('border_payments')));

module.exports = router;
