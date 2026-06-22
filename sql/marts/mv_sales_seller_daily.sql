-- Drop existing materialized view if it exists
DROP MATERIALIZED VIEW IF EXISTS mv_sales_seller_daily;

-- Create daily sales aggregated by seller
-- Designed for partner performance evaluation and risk concentration analysis
CREATE MATERIALIZED VIEW mv_sales_seller_daily AS
SELECT
    fs.order_date,
    ds.seller_id,
    ds.seller_state,
    COUNT(DISTINCT fs.order_id) AS total_orders,
    SUM(fs.quantity) AS total_units_sold,
    SUM(fs.gross_revenue) AS total_revenue
FROM fact_sales fs
JOIN dim_seller ds ON fs.seller_id = ds.seller_id
GROUP BY 
    fs.order_date, 
    ds.seller_id, 
    ds.seller_state;

-- Create unique index to allow concurrent refresh
CREATE UNIQUE INDEX idx_mv_sales_seller_daily 
ON mv_sales_seller_daily (order_date, seller_id);