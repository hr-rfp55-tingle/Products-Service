-- ---
-- This file needs to be edited for POSTGRES it is currently mySQL format
-- ---

-- SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
-- SET FOREIGN_KEY_CHECKS=0;

-- ---
-- Table 'products'
--
-- ---

DROP TABLE IF EXISTS `products`;

CREATE TABLE `products` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `selected_product_id_external` INTEGER NULL DEFAULT NULL,
  `product_id` INTEGER NULL DEFAULT NULL,
  `id_style` INTEGER NULL DEFAULT NULL,
  `name` VARCHAR(40) NULL DEFAULT NULL,
  `slogan` VARCHAR(255) NULL DEFAULT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `category` VARCHAR(60) NULL DEFAULT NULL,
  `default_price` DECIMAL NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
KEY (),
KEY ()
);

-- ---
-- Table 'styles'
--
-- ---

DROP TABLE IF EXISTS `styles`;

CREATE TABLE `styles` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `style_id` INTEGER NOT NULL AUTO_INCREMENT DEFAULT NULL,
  `product_id` INTEGER NULL DEFAULT NULL,
  `name` VARCHAR(60) NULL DEFAULT NULL,
  `sale_price` DECIMAL NULL DEFAULT NULL,
  `original_price` DECIMAL NULL DEFAULT NULL,
  `default` INTEGER NULL DEFAULT NULL COMMENT 'boolean value',
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'features'
--
-- ---

DROP TABLE IF EXISTS `features`;

CREATE TABLE `features` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `feature_id` INTEGER NULL DEFAULT NULL,
  `product_id` INTEGER NULL DEFAULT NULL,
  `feature` VARCHAR(60) NULL DEFAULT NULL,
  `value` VARCHAR(60) NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'photos'
--
-- ---

DROP TABLE IF EXISTS `photos`;

CREATE TABLE `photos` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `style_id` INTEGER NULL DEFAULT NULL,
  `url` VARCHAR(255) NULL DEFAULT NULL,
  `thumbnail_url` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'skus'
--
-- ---

DROP TABLE IF EXISTS `skus`;

CREATE TABLE `skus` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `sku_number` INTEGER NOT NULL DEFAULT NULL,
  `style_id` INTEGER NULL DEFAULT NULL,
  `size` VARCHAR(10) NULL DEFAULT NULL,
  `quantity` INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'related_products'
-- considering moving this table into a json column on the products table. Going to leave the schema as is for now
-- ---

DROP TABLE IF EXISTS `related_products`;

CREATE TABLE `related_products` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `product_id` INTEGER NOT NULL DEFAULT NULL,
  `related_id` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) COMMENT 'considering moving this table into a json column on the prod';

-- ---
-- Foreign Keys
-- ---

ALTER TABLE `styles` ADD FOREIGN KEY (product_id) REFERENCES `products` (`id`);
ALTER TABLE `features` ADD FOREIGN KEY (product_id) REFERENCES `products` (`id`);
ALTER TABLE `photos` ADD FOREIGN KEY (style_id) REFERENCES `styles` (`id`);
ALTER TABLE `skus` ADD FOREIGN KEY (style_id) REFERENCES `styles` (`id`);
ALTER TABLE `related_products` ADD FOREIGN KEY (product_id) REFERENCES `products` (`id`);

-- ---
-- Table Properties
-- ---

-- ALTER TABLE `products` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `styles` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `features` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `photos` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `skus` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `related_products` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ---
-- Test Data
-- ---

-- INSERT INTO `products` (`id`,`selected_product_id_external`,`product_id`,`id_style`,`name`,`slogan`,`description`,`category`,`default_price`) VALUES
-- ('','','','','','','','','');
-- INSERT INTO `styles` (`id`,`style_id`,`product_id`,`name`,`sale_price`,`original_price`,`default`) VALUES
-- ('','','','','','','');
-- INSERT INTO `features` (`id`,`feature_id`,`product_id`,`feature`,`value`) VALUES
-- ('','','','','');
-- INSERT INTO `photos` (`id`,`style_id`,`url`,`thumbnail_url`) VALUES
-- ('','','','');
-- INSERT INTO `skus` (`id`,`sku_number`,`style_id`,`size`,`quantity`) VALUES
-- ('','','','','');
-- INSERT INTO `related_products` (`id`,`product_id`,`related_id`) VALUES
-- ('','','');