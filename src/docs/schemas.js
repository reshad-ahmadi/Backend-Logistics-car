const bearerAuth = {
  type: 'http',
  scheme: 'bearer',
  bearerFormat: 'JWT',
  description: 'JWT from POST /api/auth/login'
};

const schemas = {
  Success: {
    type: 'object',
    properties: {
      success: { type: 'boolean', example: true },
      data: {}
    }
  },
  Error: {
    type: 'object',
    properties: {
      success: { type: 'boolean', example: false },
      message: { type: 'string' }
    }
  },
  LoginRequest: {
    type: 'object',
    required: ['username', 'password'],
    properties: {
      username: { type: 'string', example: 'admin' },
      password: { type: 'string', format: 'password', example: 'Admin@12345' }
    }
  }
};

module.exports = { bearerAuth, schemas };
