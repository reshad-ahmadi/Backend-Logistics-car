const authService = require('../services/auth.service');
const { ok } = require('../utils/http');

async function login(req, res, next) {
  try {
    const result = await authService.login({
      username: req.body.username,
      password: req.body.password,
      ip: req.ip,
      userAgent: req.headers['user-agent']
    });
    return ok(res, result);
  } catch (error) {
    return next(error);
  }
}

async function logout(req, res) {
  return ok(res, { message: 'Logout handled by deleting token on client' });
}

module.exports = { login, logout };
