DROP MATERIALIZED VIEW IF EXISTS mv_sales_customer_daily;

CREATE MATERIALIZED VIEW mv_sales_customer_daily AS
SELECT
    fs.order_date,
    dc.customer_unique_id,
    COUNT(DISTINCT fs.order_id) AS daily_orders,
    SUM(fs.gross_revenue) AS daily_spend,
    SUM(fs.quantity) AS daily_items_purchased
FROM 
    fact_sales fs
JOIN 
    dim_customer dc ON fs.customer_id = dc.customer_id
GROUP BY 
    fs.order_date,
    dc.customer_unique_id;

CREATE UNIQUE INDEX idx_mv_sales_customer_daily 
ON mv_sales_customer_daily (order_date, customer_unique_id);