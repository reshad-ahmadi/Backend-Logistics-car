const prisma = require('../config/database');
const columns = require('./columns');
const { placeholderFor, assignmentFor, idPlaceholder } = require('./sqlCasts');
const { fail } = require('../utils/http');
const { fromDbError } = require('./dbErrors');

const required = {
  containers: ['container_number', 'bl_number', 'origin_country', 'loading_date', 'customer_id']
};

function dataFor(table, body) {
  const allowed = columns[table] || [];
  return Object.fromEntries(Object.entries(body).filter(([key]) => allowed.includes(key)));
}
const quoted = (names) => names.map((name) => `"${name}"`).join(', ');
const placeholders = (keys, start = 1) =>
  keys.map((key, i) => placeholderFor(key, i + start)).join(', ');

async function list(table, page = 1, limit = 50) {
  const offset = (Number(page) - 1) * Number(limit);
  return prisma.$queryRawUnsafe(
    `SELECT * FROM "${table}" ORDER BY created_at DESC LIMIT $1 OFFSET $2`,
    Number(limit),
    offset
  );
}

async function getById(table, id) {
  const rows = await prisma.$queryRawUnsafe(
    `SELECT * FROM "${table}" WHERE id = ${idPlaceholder(1)}`,
    id
  );
  if (!rows[0]) throw fail(404, 'Record not found');
  return rows[0];
}
function assertRequired(table, data) {
  for (const field of required[table] || []) {
    if (data[field] === undefined || data[field] === null || data[field] === '') {
      throw fail(400, `Missing required field: ${field}`);
    }
  }
}

async function runWrite(fn) {
  try {
    return await fn();
  } catch (error) {
    if (error.status) throw error;
    throw fromDbError(error) || error;
  }
}

async function create(table, body) {
  const data = dataFor(table, body);
  const keys = Object.keys(data);
  if (!keys.length) throw fail(400, 'No valid fields provided');
  assertRequired(table, data);
  const sql = `INSERT INTO "${table}" (${quoted(keys)}) VALUES (${placeholders(keys)}) RETURNING *`;
  return runWrite(() => prisma.$queryRawUnsafe(sql, ...Object.values(data)).then((rows) => rows[0]));
}
async function update(table, id, body) {
  const data = dataFor(table, body);
  const keys = Object.keys(data);
  if (!keys.length) throw fail(400, 'No valid fields provided');
  const set = keys.map((key, i) => assignmentFor(key, i + 2)).join(', ');
  const sql = `UPDATE "${table}" SET ${set} WHERE id = ${idPlaceholder(1)} RETURNING *`;
  return runWrite(async () => {
    const row = (await prisma.$queryRawUnsafe(sql, id, ...Object.values(data)))[0];
    if (!row) throw fail(404, 'Record not found');
    return row;
  });
}
async function remove(table, id) {
  const row = (
    await prisma.$queryRawUnsafe(
      `DELETE FROM "${table}" WHERE id = ${idPlaceholder(1)} RETURNING *`,
      id
    )
  )[0];
  if (!row) throw fail(404, 'Record not found');
  return row;
}

module.exports = { list, getById, create, update, remove };
