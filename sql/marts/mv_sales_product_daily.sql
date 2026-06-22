DROP MATERIALIZED VIEW IF EXISTS mv_sales_product_daily;

CREATE MATERIALIZED VIEW mv_sales_product_daily AS
SELECT
    fs.order_date,
    dp.product_category_name AS category_name,
    COUNT(DISTINCT fs.order_id) AS total_orders,
    SUM(fs.quantity) AS total_quantity_sold,
    SUM(fs.gross_revenue) AS total_category_revenue,
    AVG(fs.gross_revenue) AS avg_item_revenue
FROM 
    fact_sales fs
JOIN 
    dim_product dp ON fs.product_id = dp.product_id
GROUP BY 
    fs.order_date,
    dp.product_category_name;

-- Create unique index to allow CONCURRENTLY refresh and optimize queries
CREATE UNIQUE INDEX idx_mv_sales_product_daily 
ON mv_sales_product_daily (order_date, category_name);