// what if I attempt to use sequelize to add each csv using the appropriate data model?
// dont use sequelize just use pg so we can directly access the COPY FROM command
const { db, user, password } = require('../config.js');

const { Pool, Client } = require('pg');

const pool = new Pool({
  user: user,
  host: 'localhost',
  database: db,
  password: password,
  port: port,
});

pool.query('SELECT NOW()', (err, res) => {
  console.log(err, res)
  pool.end()
});

const client = new Client({
  user: user,
  host: 'localhost',
  database: db,
  password: password,
  port: port,
});

client.connect()
client.query('SELECT NOW()', (err, res) => {
  console.log(err, res)
  client.end()
});


// data.csv
// NAME,AGE
// Daffy Duck,24
// Bugs Bunny,22


const csv = require('csv-parser')
const fs = require('fs')
const results = [];

fs.createReadStream('data.csv')
  .pipe(csv())
  .on('data', (data) => results.push(data))
  .on('end', () => {
    console.log(results);
    // [
    //   { NAME: 'Daffy Duck', AGE: '24' },
    //   { NAME: 'Bugs Bunny', AGE: '22' }
    // ]
  });