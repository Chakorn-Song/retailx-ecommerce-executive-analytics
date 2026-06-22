DROP TABLE IF EXISTS fact_sales;

CREATE TABLE fact_sales AS
SELECT
    ROW_NUMBER() OVER() AS sales_key,

    oi.order_id,
    oi.order_item_id,

    o.customer_id,
    oi.product_id,
    oi.seller_id,

    o.order_status,

    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_customer_date,

    DATE(o.order_purchase_timestamp) AS order_date,

    1 AS quantity,

    oi.price,
    oi.freight_value,

    oi.price + oi.freight_value AS gross_revenue

FROM order_items oi
INNER JOIN orders o
    ON oi.order_id = o.order_id

WHERE o.order_status = 'delivered';

-- check
SELECT *
FROM fact_sales
LIMIT 10;


---------------------------------------------------------------------------------
-- KPI check

-- Revenue
SELECT
    SUM(gross_revenue) as Revenue
FROM fact_sales;

-- Orders
SELECT
    COUNT(DISTINCT order_id) as Orders
FROM fact_sales;

-- Customers
SELECT
    COUNT(DISTINCT product_id) as Customers
FROM fact_sales;

-- null check
SELECT
    COUNT(*) AS total_rows,

    COUNT(product_id) AS product_rows,
    COUNT(customer_id) AS customer_rows,
    COUNT(seller_id) AS seller_rows

FROM fact_sales;--110197

-- pk
ALTER TABLE fact_sales
ADD CONSTRAINT pk_fact_sales
PRIMARY KEY (sales_key);