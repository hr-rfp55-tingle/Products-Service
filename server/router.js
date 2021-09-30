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

router.get('/styles/:productId', async (req, res) => {
  const { productId } = req.params
  // const { rows } = await db.query('SELECT * FROM styles WHERE productid = $1', [productId]);
  db.query('SELECT * FROM styles WHERE productid = $1', [productId])
    .then((results) => {
      for (let row in results.rows ) {
        console.log(results.rows[row]);
        db.query('SELECT thumbnail_url, url FROM photos WHERE styleid = $1', [results.rows[row].id])
          .then((photoResults) => {
            row.photos = photoResults.rows;
            console.log(row);
          }).catch(err => console.log(err));
      }
      res.send(results.rows);
    }).catch(err => console.log(err));

  // for (let row in rows ) {
  //   const photoResults = await db.query('SELECT thumbnail_url, url FROM photos WHERE styleid = $1', [row.id]);
  //   row.photos = photoResults.rows;
  // }
  // res.send(rows);
  // const getInfo = async () => {
  //   rows.forEach((row) => {
  //     const photoResults =  await db.query('SELECT thumbnail_url, url FROM photos WHERE styleid = $1', [row.id]);
  //     row.photos = photoResults.rows;
  //   });
  //   res.send(rows);
  // };
  // await getInfo();
  // const styles = await
});

// export our router to be mounted by the parent application
module.exports = router;