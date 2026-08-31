-- SQL script to define Primary Keys, Unique constraints, and Foreign Keys for Star Schema tables

-- Drop existing constraints if present
ALTER TABLE IF EXISTS fact_sales DROP CONSTRAINT IF EXISTS fk_fact_sales_customer;
ALTER TABLE IF EXISTS fact_sales DROP CONSTRAINT IF EXISTS fk_fact_sales_product;
ALTER TABLE IF EXISTS fact_sales DROP CONSTRAINT IF EXISTS fk_fact_sales_seller;
ALTER TABLE IF EXISTS fact_sales DROP CONSTRAINT IF EXISTS fk_fact_sales_date;

ALTER TABLE IF EXISTS dim_customer DROP CONSTRAINT IF EXISTS uk_dim_customer_id;
ALTER TABLE IF EXISTS dim_product DROP CONSTRAINT IF EXISTS uk_dim_product_id;
ALTER TABLE IF EXISTS dim_seller DROP CONSTRAINT IF EXISTS uk_dim_seller_id;
ALTER TABLE IF EXISTS dim_customer_rfm DROP CONSTRAINT IF EXISTS pk_dim_customer_rfm;

-- 1. Add Unique / Primary Key constraints on dimension tables
ALTER TABLE dim_customer ADD CONSTRAINT uk_dim_customer_id UNIQUE (customer_id);
ALTER TABLE dim_product ADD CONSTRAINT uk_dim_product_id UNIQUE (product_id);
ALTER TABLE dim_seller ADD CONSTRAINT uk_dim_seller_id UNIQUE (seller_id);
ALTER TABLE dim_customer_rfm ADD CONSTRAINT pk_dim_customer_rfm PRIMARY KEY (customer_unique_id);

-- 2. Add Foreign Keys connecting fact_sales to dimension tables
ALTER TABLE fact_sales
ADD CONSTRAINT fk_fact_sales_customer
FOREIGN KEY (customer_id) REFERENCES dim_customer (customer_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_fact_sales_product
FOREIGN KEY (product_id) REFERENCES dim_product (product_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_fact_sales_seller
FOREIGN KEY (seller_id) REFERENCES dim_seller (seller_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_fact_sales_date
FOREIGN KEY (order_date) REFERENCES dim_date (full_date);
