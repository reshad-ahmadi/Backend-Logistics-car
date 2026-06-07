const express = require('express');
const crudRoutes = require('./crud.routes');
const makeController = require('../controllers/crud.controller');

const router = express.Router();

router.use('/accounts', crudRoutes(makeController('accounts')));
router.use('/journal-entries', crudRoutes(makeController('journal_entries')));
router.use('/journal-lines', crudRoutes(makeController('journal_entry_lines')));

module.exports = router;
