const { fail } = require('../utils/http');

function fromDbError(error) {
  const message = String(error?.message ?? '');

  if (message.includes('null value') && message.includes('customer_id')) {
    return fail(400, 'Customer is required. Fill in customer name on the form.');
  }
  if (message.includes('containers_container_number_uidx') || message.includes('containers_container_number')) {
    return fail(409, 'This container number already exists.');
  }
  if (message.includes('expense_type')) {
    return fail(400, 'Invalid expense type for this record.');
  }
  if (message.includes('origin_country')) {
    return fail(400, 'Origin country must be China, India, or Dubai.');
  }
  if (message.includes('current_status') || message.includes('violates check constraint')) {
    return fail(400, 'One of the values does not match allowed options.');
  }
  if (message.includes('duplicate key') || message.includes('unique constraint')) {
    return fail(409, 'A record with this value already exists.');
  }

  return null;
}

module.exports = { fromDbError };
