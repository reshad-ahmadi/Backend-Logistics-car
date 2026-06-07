require('../config/env');
const bcrypt = require('bcrypt');
const prisma = require('../config/database');

async function main() {
  const fullName = process.env.ADMIN_NAME || 'System Admin';
  const username = process.env.ADMIN_USERNAME || 'admin';
  const email = process.env.ADMIN_EMAIL || 'admin@local.test';
  const password = process.env.ADMIN_PASSWORD || 'Admin@12345';
  const hash = await bcrypt.hash(password, 10);

  const [role] = await prisma.$queryRaw`SELECT id FROM roles WHERE role_name = 'Admin'`;
  if (!role) throw new Error('Run database seeds before creating admin');

  const [existing] = await prisma.$queryRaw`
    SELECT id FROM users WHERE lower(username) = lower(${username}) LIMIT 1
  `;

  if (existing) {
    await prisma.$executeRaw`
      UPDATE users SET password_hash = ${hash}, role_id = ${role.id}::uuid, is_active = true
      WHERE id = ${existing.id}::uuid
    `;
  } else {
    await prisma.$executeRaw`
      INSERT INTO users (full_name, username, email, password_hash, role_id)
      VALUES (${fullName}, ${username}, ${email}, ${hash}, ${role.id}::uuid)
    `;
  }

  console.log(`Admin ready: ${username}`);
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => prisma.$disconnect());
