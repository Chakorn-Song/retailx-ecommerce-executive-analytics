DROP TABLE IF EXISTS dim_customer;

CREATE TABLE dim_customer AS
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key,

    customer_id,
    customer_unique_id,

    customer_zip_code_prefix,
    customer_city,
    customer_state

FROM customers;

-- pk
ALTER TABLE dim_customer
ADD CONSTRAINT pk_dim_customer
PRIMARY KEY (customer_key);

-- Unique Constraint
ALTER TABLE dim_customer
ADD CONSTRAINT uk_dim_customer
UNIQUE (customer_id);

-- check 
SELECT *
FROM dim_customer
LIMIT 10;