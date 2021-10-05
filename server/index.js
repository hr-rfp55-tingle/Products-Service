const express = require('express');

const PORT = 3000;
const app = express();

const router  = require('./router.js');

app.use(express.json());

app.use('/', router);

app.get('/loaderio-2b79f9fb238cbf6efa0de9b097676545/', (req, res) => {
  res.send('loaderio-2b79f9fb238cbf6efa0de9b097676545');
});


app.listen(PORT, () => {
  console.log(`Server listening at localhost:${PORT}!`);
});