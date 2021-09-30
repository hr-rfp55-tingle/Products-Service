const express = require('express');
// const cors = require('cors');
// const compression = require('compression');
const PORT = 6879;
const app = express();

const router  = require('./router.js');

app.use(express.json());
// app.use(compression());
// app.use(cors());
app.use('/', router);




app.listen(PORT, () => {
  console.log(`Server listening at localhost:${PORT}!`);
});