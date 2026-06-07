const express = require('express');
const controller = require('../controllers/report.controller');

const router = express.Router();

router.get('/', controller.list);
router.get('/:name', controller.get);

module.exports = router;
