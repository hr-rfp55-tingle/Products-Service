\c devbox;

DROP TABLE IF EXISTS related;
DROP TABLE IF EXISTS skus;
DROP TABLE IF EXISTS photos;
DROP TABLE IF EXISTS features;
DROP TABLE IF EXISTS styles;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
  id SERIAL,
  "name" VARCHAR(40),
  slogan VARCHAR(255) NULL DEFAULT NULL,
  "description" TEXT NULL DEFAULT NULL,
  category VARCHAR(60) NULL DEFAULT NULL,
  default_price DECIMAL NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE related (
  id SERIAL,
  current_product_id BIGINT references products(id),
  related_product_id INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE styles (
  id SERIAL,
  productId BIGINT references products(id),
  "name" VARCHAR(60) NULL DEFAULT NULL,
  sale_price VARCHAR(50) NULL DEFAULT 0,
  original_price DECIMAL DEFAULT 0,
  default_style BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (id)
);

CREATE TABLE features (
  id SERIAL,
  product_id BIGINT references products(id),
  feature VARCHAR(60) NULL DEFAULT NULL,
  "value" VARCHAR(60) NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE photos (
  id SERIAL,
  styleId INTEGER NULL DEFAULT NULL,
  "url" TEXT NULL DEFAULT NULL,
  thumbnail_url TEXT NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE skus (
  id SERIAL,
  styleId INTEGER NULL DEFAULT NULL,
  size VARCHAR(10) NULL DEFAULT NULL,
  quantity INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
);

COPY products (id, name, slogan, description, category, default_price)
FROM '/Users/devbox/HackReactor/RFP55/SDC/Products-Service/csv/product.csv'
DELIMITER ',' CSV HEADER;

COPY features  (id, product_id, feature, value)
FROM '/Users/devbox/HackReactor/RFP55/SDC/Products-Service/csv/features.csv'
DELIMITER ',' CSV HEADER;

COPY related (id, current_product_id, related_product_id)
FROM '/Users/devbox/HackReactor/RFP55/SDC/Products-Service/csv/related.csv'
DELIMITER ',' CSV HEADER;

COPY photos (id, styleId, url, thumbnail_url)
FROM '/Users/devbox/HackReactor/RFP55/SDC/Products-Service/csv/photos.csv'
DELIMITER ',' CSV HEADER;

COPY styles (id, productId, name, sale_price, original_price,default_style)
FROM '/Users/devbox/HackReactor/RFP55/SDC/Products-Service/csv/styles.csv'
DELIMITER ',' CSV HEADER;

COPY skus (id, styleId, size, quantity)
FROM '/Users/devbox/HackReactor/RFP55/SDC/Products-Service/csv/skus.csv'
DELIMITER ',' CSV HEADER;