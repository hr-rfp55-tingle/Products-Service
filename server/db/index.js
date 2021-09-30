const { Pool } = require('pg');
const connectionString = 'postgresql://postgres:@localhost:5432/devbox';

const pool = new Pool({
  connectionString,
});

module.exports = {
  // query: (text, params, callback) => {
  //   const start = Date.now()
  //   return pool.query(text, params, (err, res) => {
  //     const duration = Date.now() - start
  //     console.log('executed query', { text, duration, rows: res.rowCount })
  //     callback(err, res)
  //   })
  // },
  async query(text, params) {
    const start = Date.now()
    const res = await pool.query(text, params)
    const duration = Date.now() - start
    console.log('executed query', { text, duration, rows: res.rowCount })
    return res
  },
}