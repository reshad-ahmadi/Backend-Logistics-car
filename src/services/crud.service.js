const prisma = require('../config/database');
const columns = require('./columns');
const { fail } = require('../utils/http');

function dataFor(table, body) {
  const allowed = columns[table] || [];
  return Object.fromEntries(Object.entries(body).filter(([key]) => allowed.includes(key)));
}
const quoted = (names) => names.map((name) => `"${name}"`).join(', ');
const placeholders = (count, start = 1) =>
  Array.from({ length: count }, (_, i) => `$${i + start}`).join(', ');

async function list(table, page = 1, limit = 50) {
  const offset = (Number(page) - 1) * Number(limit);
  return prisma.$queryRawUnsafe(
    `SELECT * FROM "${table}" ORDER BY created_at DESC LIMIT $1 OFFSET $2`,
    Number(limit),
    offset
  );
}

async function getById(table, id) {
  const rows = await prisma.$queryRawUnsafe(`SELECT * FROM "${table}" WHERE id = $1`, id);
  if (!rows[0]) throw fail(404, 'Record not found');
  return rows[0];
}
async function create(table, body) {
  const data = dataFor(table, body);
  const keys = Object.keys(data);
  if (!keys.length) throw fail(400, 'No valid fields provided');
  const sql = `INSERT INTO "${table}" (${quoted(keys)}) VALUES (${placeholders(keys.length)}) RETURNING *`;
  return (await prisma.$queryRawUnsafe(sql, ...Object.values(data)))[0];
}
async function update(table, id, body) {
  const data = dataFor(table, body);
  const keys = Object.keys(data);
  if (!keys.length) throw fail(400, 'No valid fields provided');
  const set = keys.map((key, i) => `"${key}" = $${i + 2}`).join(', ');
  const sql = `UPDATE "${table}" SET ${set} WHERE id = $1 RETURNING *`;
  const row = (await prisma.$queryRawUnsafe(sql, id, ...Object.values(data)))[0];
  if (!row) throw fail(404, 'Record not found');
  return row;
}
async function remove(table, id) {
  const row = (await prisma.$queryRawUnsafe(`DELETE FROM "${table}" WHERE id = $1 RETURNING *`, id))[0];
  if (!row) throw fail(404, 'Record not found');
  return row;
}

module.exports = { list, getById, create, update, remove };
