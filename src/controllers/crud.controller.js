const service = require('../services/crud.service');
const { ok, created } = require('../utils/http');

function makeController(table) {
  return {
    list: async (req, res, next) => {
      try { return ok(res, await service.list(table, req.query.page, req.query.limit)); }
      catch (error) { return next(error); }
    },
    get: async (req, res, next) => {
      try { return ok(res, await service.getById(table, req.params.id)); }
      catch (error) { return next(error); }
    },
    create: async (req, res, next) => {
      try { return created(res, await service.create(table, req.body)); }
      catch (error) { return next(error); }
    },
    update: async (req, res, next) => {
      try { return ok(res, await service.update(table, req.params.id, req.body)); }
      catch (error) { return next(error); }
    },
    remove: async (req, res, next) => {
      try { return ok(res, await service.remove(table, req.params.id)); }
      catch (error) { return next(error); }
    }
  };
}

module.exports = makeController;
