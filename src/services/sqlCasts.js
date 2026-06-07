function placeholderFor(key, index) {
  if (key.endsWith('_id')) return `$${index}::uuid`;
  if (key.endsWith('_date') || key === 'entry_date') return `$${index}::date`;
  if (key === 'tracking_date') return `$${index}::timestamptz`;
  if (/amount|charge/i.test(key)) return `$${index}::numeric`;
  return `$${index}`;
}

function assignmentFor(key, index) {
  return `"${key}" = ${placeholderFor(key, index)}`;
}

module.exports = { placeholderFor, assignmentFor };
