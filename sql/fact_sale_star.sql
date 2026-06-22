--Daily sales figures
--How many customers?
--How many orders?
--How many items sold?

DROP MATERIALIZED VIEW IF EXISTS mv_sales_daily;

CREATE MATERIALIZED VIEW mv_sales_daily AS

SELECT
    fs.order_date,

    COUNT(DISTINCT fs.order_id) AS total_orders,

    COUNT(DISTINCT fs.customer_id) AS total_customers,

    SUM(fs.quantity) AS total_quantity,

    SUM(fs.gross_revenue) AS total_revenue,

    AVG(fs.gross_revenue) AS avg_item_revenue

FROM fact_sales fs

GROUP BY fs.order_date;