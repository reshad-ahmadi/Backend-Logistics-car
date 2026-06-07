const app = require('./app');
const env = require('./config/env');

app.listen(env.port, () => {
  console.log(`Logistics API running on port ${env.port}`);
});
