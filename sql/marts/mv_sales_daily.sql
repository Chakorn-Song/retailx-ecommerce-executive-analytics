DROP MATERIALIZED VIEW IF EXISTS mv_sales_daily;

CREATE MATERIALIZED VIEW mv_sales_daily AS
SELECT
    fs.order_date,
    COUNT(DISTINCT fs.order_id) AS total_orders,
    COUNT(DISTINCT fs.customer_id) AS total_customers,
    SUM(fs.quantity) AS total_quantity_sold,
    SUM(fs.gross_revenue) AS total_revenue,
    SUM(fs.gross_revenue) / NULLIF(COUNT(DISTINCT fs.order_id), 0) AS avg_order_value,
    AVG(fs.gross_revenue) AS avg_item_revenue
FROM 
    fact_sales fs
GROUP BY 
    fs.order_date;

CREATE UNIQUE INDEX idx_mv_sales_daily 
ON mv_sales_daily (order_date);