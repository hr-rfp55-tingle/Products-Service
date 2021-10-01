// notice here I'm requiring my database adapter file
// and not requiring node-postgres directly
const db = require('./db');

// create a new express-promise-router
// this has the same API as the normal express router except
// it allows you to use async functions as route handlers
const Router = require('express-promise-router');
const router = new Router();


router.get('/products/:id', async (req, res) => {
  const { id } = req.params
  const { rows } =  await db.query('SELECT * FROM products WHERE id = $1', [id]);
  const featureResults =  await db.query('SELECT * FROM features WHERE product_id = $1', [id]);
  rows[0].features = featureResults.rows;
  res.send(rows[0]);
  // res.send({product: rows[0], features: featureResults.rows});
});

router.get('/features/:productId', async (req, res) => {
  const { productId } = req.params
  const { rows } = await db.query('SELECT * FROM features WHERE product_id = $1', [productId]);
  res.send(rows);
});

router.get('/photos/:styleId', async (req, res) => {
  const { styleId } = req.params
  const { rows } = await db.query('SELECT * FROM photos WHERE style_id = $1', [styleId]);
  res.send(rows);
});

router.get('/styles/:productId', async (req, res) => {
  const { productId } = req.params
  // const { rows } = await db.query('SELECT * FROM styles WHERE product_id = $1', [productId]);
  db.query('SELECT * FROM styles WHERE product_id = $1', [productId])
    .then((results) => {
      const keys = Object.keys(results.rows);
      const last = keys[keys.length - 1];
      for (let row in results.rows ) {
        // console.log(results.rows[row]);
        db.query('SELECT thumbnail_url, url FROM photos WHERE style_id = $1', [results.rows[row].style_id])
          .then((photoResults) => {
            results.rows[row].photos = photoResults.rows;
            // console.log(row);

            if (row === last) {
              res.send(results.rows);
            }
          }).catch(err => console.log(err));
      }
    }).catch(err => console.log(err));
});

// export our router to be mounted by the parent application
module.exports = router;