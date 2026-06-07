const express = require('express');
const swaggerUi = require('swagger-ui-express');
const spec = require('../docs/openapi');

const router = express.Router();

router.use('/', swaggerUi.serve);
router.get('/', swaggerUi.setup(spec, {
  customSiteTitle: 'Logistics API',
  swaggerOptions: { persistAuthorization: true, docExpansion: 'list' }
}));

module.exports = router;
