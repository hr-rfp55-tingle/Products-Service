const { Pool } = require('pg');
const { connectionString } = require('../../config');

const pool = new Pool({
  connectionString,
});

pool.connect()
  .then((res) => {
    console.log('now connected to db');
  })
  .catch((err) => {
    console.log(err);
  });

module.exports = {
  async query(text, params) {
    const start = Date.now();
    const res = await pool.query(text, params);
    const duration = Date.now() - start;
    console.log('executed query', { text, duration, rows: res.rowCount });
    return res;
  },
}