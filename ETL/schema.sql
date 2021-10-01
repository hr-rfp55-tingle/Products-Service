DROP DATABASE devbox;
CREATE DATABASE devbox;

\c devbox;

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  "name" VARCHAR(40),
  slogan VARCHAR(255) NULL DEFAULT NULL,
  "description" TEXT NULL DEFAULT NULL,
  category VARCHAR(60) NULL DEFAULT NULL,
  default_price DECIMAL NULL DEFAULT NULL
);

COPY products (id, name, slogan, description, category, default_price)
FROM '/Users/devbox/HackReactor/RFP55/SDC/Products-Service/csv/product.csv'
DELIMITER ',' CSV HEADER;

CREATE INDEX ON products (id);

CREATE TABLE related (
  id SERIAL PRIMARY KEY,
  current_product_id BIGINT references products(id),
  related_product_id INTEGER NULL DEFAULT NULL
);

COPY related (id, current_product_id, related_product_id)
FROM '/Users/devbox/HackReactor/RFP55/SDC/Products-Service/csv/related.csv'
DELIMITER ',' CSV HEADER;

CREATE INDEX ON related (current_product_id);

CREATE TABLE styles (
  style_id SERIAL PRIMARY KEY,
  product_id BIGINT references products(id),
  "name" VARCHAR(60) NULL DEFAULT NULL,
  sale_price VARCHAR(50) NULL DEFAULT 0,
  original_price DECIMAL DEFAULT 0,
  "default?" BOOLEAN NOT NULL DEFAULT FALSE
);

COPY styles (style_id, product_id, name, sale_price, original_price, "default?")
FROM '/Users/devbox/HackReactor/RFP55/SDC/Products-Service/csv/styles.csv'
DELIMITER ',' CSV HEADER;

CREATE INDEX ON styles (product_id);

CREATE TABLE features (
  id SERIAL PRIMARY KEY,
  product_id BIGINT references products(id),
  feature VARCHAR(60) NULL DEFAULT NULL,
  "value" VARCHAR(60) NULL DEFAULT NULL
);

COPY features  (id, product_id, feature, value)
FROM '/Users/devbox/HackReactor/RFP55/SDC/Products-Service/csv/features.csv'
DELIMITER ',' CSV HEADER;

CREATE INDEX ON features (product_id);

CREATE TABLE photos (
  id SERIAL PRIMARY KEY,
  style_id BIGINT references styles(style_id),
  "url" TEXT NULL DEFAULT NULL,
  thumbnail_url TEXT NULL DEFAULT NULL
);

COPY photos (id, style_id, url, thumbnail_url)
FROM '/Users/devbox/HackReactor/RFP55/SDC/Products-Service/csv/photos.csv'
DELIMITER ',' CSV HEADER;

CREATE INDEX ON photos (style_id);

CREATE TABLE skus (
  id SERIAL PRIMARY KEY,
  style_id BIGINT references styles(style_id),
  size VARCHAR(10) NULL DEFAULT NULL,
  quantity INTEGER NOT NULL DEFAULT 0
);

COPY skus (id, style_id, size, quantity)
FROM '/Users/devbox/HackReactor/RFP55/SDC/Products-Service/csv/skus.csv'
DELIMITER ',' CSV HEADER;

CREATE INDEX ON skus (style_id);
