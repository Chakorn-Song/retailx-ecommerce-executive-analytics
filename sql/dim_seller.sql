DROP TABLE IF EXISTS dim_seller;

CREATE TABLE dim_seller AS
SELECT
    ROW_NUMBER() OVER (ORDER BY seller_id) AS seller_key,

    seller_id,

    seller_zip_code_prefix,
    seller_city,
    seller_state

FROM sellers;

-- pk
ALTER TABLE dim_seller
ADD CONSTRAINT pk_dim_seller
PRIMARY KEY (seller_key);

-- Unique
ALTER TABLE dim_seller
ADD CONSTRAINT uk_dim_seller
UNIQUE (seller_id);

-- index
CREATE INDEX idx_dim_customer_customer_id
ON dim_customer(customer_id);

CREATE INDEX idx_dim_product_product_id
ON dim_product(product_id);

CREATE INDEX idx_dim_seller_seller_id
ON dim_seller(seller_id);

