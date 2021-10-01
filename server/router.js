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

router.get('/products/:product_id/styles', async (req, res) => {
  const query = {
    name: 'get-styles',
    text: `
      select styles.product_id,
        (select json_agg(sty)
        from (
          select style_id, name, original_price, sale_price, "default?",
            (select json_agg(pho) from (
              select thumbnail_url, url from photos where style_id=1
              ) pho
            ) as photos,
            (select json_agg(sk) from (
              select quantity, size from skus where style_id=1
              ) sk
            ) as skus
          from styles where product_id=$1
        ) sty
      ) as results
      from styles where styles.product_id=$1
    `,
    values: [req.params.product_id],
  };

  try {
    const results = await db.query(query);
    res.json(results.rows[0]);
  } catch (err) {
    res.json(err);
  }
});

// export our router to be mounted by the parent application
module.exports = router;