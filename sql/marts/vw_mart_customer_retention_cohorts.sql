-- View: vw_mart_customer_retention_cohorts
-- Purpose: Calculates monthly customer retention cohorts and retention rates for Page 4 analytics

DROP VIEW IF EXISTS vw_mart_customer_retention_cohorts;

CREATE VIEW vw_mart_customer_retention_cohorts AS
WITH customer_first_order AS (
    SELECT 
        dc.customer_unique_id,
        MIN(DATE_TRUNC('month', fs.order_date)) AS acquisition_cohort
    FROM fact_sales fs
    JOIN dim_customer dc ON fs.customer_id = dc.customer_id
    GROUP BY dc.customer_unique_id
),
customer_activities AS (
    SELECT DISTINCT
        dc.customer_unique_id,
        cfo.acquisition_cohort,
        DATE_TRUNC('month', fs.order_date) AS activity_month,
        (EXTRACT(YEAR FROM DATE_TRUNC('month', fs.order_date)) - EXTRACT(YEAR FROM cfo.acquisition_cohort)) * 12 +
        (EXTRACT(MONTH FROM DATE_TRUNC('month', fs.order_date)) - EXTRACT(MONTH FROM cfo.acquisition_cohort)) AS cohort_index
    FROM fact_sales fs
    JOIN dim_customer dc ON fs.customer_id = dc.customer_id
    JOIN customer_first_order cfo ON dc.customer_unique_id = cfo.customer_unique_id
),
cohort_sizes AS (
    SELECT 
        acquisition_cohort,
        COUNT(DISTINCT customer_unique_id) AS cohort_size
    FROM customer_first_order
    GROUP BY acquisition_cohort
)
SELECT 
    ca.acquisition_cohort::date AS acquisition_cohort,
    ca.cohort_index::integer AS cohort_index,
    cs.cohort_size,
    COUNT(DISTINCT ca.customer_unique_id) AS retained_customers,
    ROUND((COUNT(DISTINCT ca.customer_unique_id)::numeric / cs.cohort_size) * 100, 2) AS retention_rate_pct
FROM customer_activities ca
JOIN cohort_sizes cs ON ca.acquisition_cohort = cs.acquisition_cohort
GROUP BY ca.acquisition_cohort, ca.cohort_index, cs.cohort_size
ORDER BY ca.acquisition_cohort, ca.cohort_index;
