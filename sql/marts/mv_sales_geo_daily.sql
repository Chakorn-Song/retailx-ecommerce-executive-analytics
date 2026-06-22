DROP MATERIALIZED VIEW IF EXISTS mv_sales_geo_daily;

CREATE MATERIALIZED VIEW mv_sales_geo_daily AS
SELECT
    fs.order_date,
    dc.customer_state,
    dc.customer_city,
    COUNT(DISTINCT fs.order_id) AS total_orders,
    SUM(fs.gross_revenue) AS total_regional_revenue,
    SUM(fs.gross_revenue) / NULLIF(COUNT(DISTINCT fs.order_id), 0) AS avg_order_value
FROM 
    fact_sales fs
JOIN 
    dim_customer dc ON fs.customer_id = dc.customer_id
GROUP BY 
    fs.order_date,
    dc.customer_state,
    dc.customer_city;

CREATE UNIQUE INDEX idx_mv_sales_geo_daily 
ON mv_sales_geo_daily (order_date, customer_state, customer_city);