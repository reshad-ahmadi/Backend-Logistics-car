const bcrypt = require('bcrypt');
const prisma = require('../config/database');
const { signToken } = require('../utils/tokens');
const { fail } = require('../utils/http');

async function login({ username, password, ip, userAgent }) {
  const rows = await prisma.$queryRaw`
    SELECT u.id, u.username, u.email, u.password_hash, u.is_active, r.role_name
    FROM users u JOIN roles r ON r.id = u.role_id
    WHERE lower(u.username) = lower(${username}) OR lower(u.email) = lower(${username})
    LIMIT 1
  `;

  const user = rows[0];
  const ok = user && user.is_active && await bcrypt.compare(password, user.password_hash);
  await writeLogin(user && user.id, ip, userAgent, Boolean(ok));
  if (!ok) throw fail(401, 'Invalid username or password');

  return {
    token: signToken(user),
    user: { id: user.id, username: user.username, email: user.email, role: user.role_name }
  };
}

async function writeLogin(userId, ip, userAgent, wasSuccessful) {
  if (!userId) return;
  await prisma.$executeRaw`
    INSERT INTO login_history (user_id, ip_address, user_agent, was_successful)
    VALUES (${userId}::uuid, ${ip}::inet, ${userAgent}, ${wasSuccessful})
  `;
}

module.exports = { login };
