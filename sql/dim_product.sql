DROP TABLE IF EXISTS dim_product;

CREATE TABLE dim_product AS
SELECT
    ROW_NUMBER() OVER (ORDER BY product_id) AS product_key,

    product_id,

    product_category_name,

    product_name_lenght,
    product_description_lenght,

    product_photos_qty,

    product_weight_g,

    product_length_cm,
    product_height_cm,
    product_width_cm

FROM products;

-- pk 
ALTER TABLE dim_product
ADD CONSTRAINT pk_dim_product
PRIMARY KEY (product_key);

-- Unique
ALTER TABLE dim_product
ADD CONSTRAINT uk_dim_product
UNIQUE (product_id);

-- check 
SELECT * 
FROM dim_product
LIMIT 10;