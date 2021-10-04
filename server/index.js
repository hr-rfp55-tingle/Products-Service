const express = require('express');

const PORT = 3000;
const app = express();

const router  = require('./router.js');

app.use(express.json());
app.use(express.static('../public'));
app.use('/', router);

app.get('/loaderio-2b79f9fb238cbf6efa0de9b097676545/', (req, res) => {
  res.sendFile('loaderio-2b79f9fb238cbf6efa0de9b097676545.txt');
});


app.listen(PORT, () => {
  console.log(`Server listening at localhost:${PORT}!`);
});