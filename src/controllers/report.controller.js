const reportService = require('../services/report.service');
const { ok } = require('../utils/http');

async function get(req, res, next) {
  try {
    return ok(res, await reportService.getReport(req.params.name));
  } catch (error) {
    return next(error);
  }
}

async function list(req, res) {
  return ok(res, Object.keys(reportService.views));
}

module.exports = { get, list };
