
const db = require('./db');

// this has the same API as the normal express router except
// it allows you to use async functions as route handlers
const Router = require('express-promise-router');
const router = new Router();

router.get('/products', async (req, res) => {
  // TODO after testing might want to consider adding a limit
  // to the amount of products to return - 20000 products is about 7MB
  // test and find the sweet spot for the limit
  const count = req.query.count || 5;
  const page = req.query.page || 1;
  const firstProd = (page - 1) * count + 1;
  const lastProd = page * count;

  try {
    const results = await db.query(`SELECT id, 'hr-rfp' as campus, name, slogan, description, category, default_price
    FROM products WHERE id BETWEEN $1 and $2`, [firstProd, lastProd]);
    res.json(results.rows);
  } catch (err) {
    res.json(err);
  }
});

router.get('/products/:id', async (req, res) => {
  const query = {
    name: 'get-product-byId',
    text: `
    SELECT p.id, 'hr-rfp' as campus, p.name, p.slogan, p.description, p.category, p.default_price,
      json_agg(json_build_object(
          'feature', features.feature,
          'value', features.value
        )) AS features
    FROM products as p
    LEFT JOIN features ON p.id = features.product_id WHERE p.id = $1
    GROUP BY p.id, campus,p.name, p.description, p.category, p.default_price`,
    values: [req.params.id],
  }

  try {
    const results = await db.query(query);
    res.json(results.rows[0]);
  } catch (err) {
    res.json(err);
  }
});

router.get('/products/:product_id/related', async (req, res) => {
  try {
    const results =  await db.query('SELECT array_agg(related_product_id) FROM related WHERE current_product_id=$1',[req.params.product_id]);
    res.send(results.rows[0].array_agg);
  } catch (err) {
    res.json(err);
  }
});


router.get('/products/:product_id/styles', async (req, res) => {
  const query = {
    name: 'get-styles-byId',
    text: `
      SELECT product_id, json_agg(json_build_object(
        'style_id', style_id,
        'name', name,
        'sale_price', sale_price,
        'original_price', original_price,
        'default?', "default?",
        'photos',(SELECT json_agg(json_build_object(
          'thumbnail_url', thumbnail_url,
          'url', url
        )) FROM photos WHERE style_id = styles.style_id),
        'skus',(SELECT json_object_agg(id,
          json_build_object(
          'size', size,
          'quantity', quantity
          )) as skus FROM skus WHERE style_id = styles.style_id GROUP by style_id)
      )) as results FROM styles WHERE styles.product_id = $1 GROUP BY product_id`,
    values: [req.params.product_id],
  };

  try {
    const results = await db.query(query);
    res.json(results.rows[0]);
  } catch (err) {
    res.json(err);
  }
});

module.exports = router;
