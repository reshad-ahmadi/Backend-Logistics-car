const bearer = [{ bearerAuth: [] }];
const idParam = {
  name: 'id',
  in: 'path',
  required: true,
  schema: { type: 'string', format: 'uuid' }
};
const pageParams = [
  { name: 'page', in: 'query', schema: { type: 'integer', minimum: 1, default: 1 } },
  { name: 'limit', in: 'query', schema: { type: 'integer', minimum: 1, maximum: 100, default: 20 } }
];
const jsonBody = {
  required: true,
  content: { 'application/json': { schema: { type: 'object', additionalProperties: true } } }
};
const ok = { description: 'Success', content: { 'application/json': { schema: { $ref: '#/components/schemas/Success' } } } };
const created = { description: 'Created', content: { 'application/json': { schema: { $ref: '#/components/schemas/Success' } } } };

function crudPaths(path, tag) {
  return {
    [path]: {
      get: { tags: [tag], summary: `List ${tag}`, security: bearer, parameters: pageParams, responses: { 200: ok } },
      post: { tags: [tag], summary: `Create ${tag}`, security: bearer, requestBody: jsonBody, responses: { 201: created } }
    },
    [`${path}/{id}`]: {
      get: { tags: [tag], summary: `Get ${tag} by id`, security: bearer, parameters: [idParam], responses: { 200: ok } },
      put: { tags: [tag], summary: `Update ${tag}`, security: bearer, parameters: [idParam], requestBody: jsonBody, responses: { 200: ok } },
      delete: { tags: [tag], summary: `Delete ${tag}`, security: bearer, parameters: [idParam], responses: { 200: ok } }
    }
  };
}

function mergePaths(...groups) {
  return Object.assign({}, ...groups);
}

module.exports = { crudPaths, mergePaths };
