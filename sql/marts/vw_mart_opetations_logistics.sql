CREATE OR REPLACE VIEW vw_mart_operations_logistics AS
SELECT 
    o.order_id,
    o.customer_id,
    c.customer_state AS delivery_state,
    o.order_status,
    o.order_purchase_timestamp,
    
    -- Revenue & Freight Calculation
    SUM(oi.price) AS total_item_value,
    SUM(oi.freight_value) AS total_freight_value,
    
    -- Freight Ratio
    ROUND(
        CAST(SUM(oi.freight_value) / NULLIF(SUM(oi.price), 0) AS numeric), 
        4
    ) AS freight_to_price_ratio,
    
    -- Lead Time Breakdown
    -- packing time
    ROUND(
        CAST(EXTRACT(EPOCH FROM (o.order_delivered_carrier_date - o.order_purchase_timestamp)) / 86400.0 AS numeric),
        2
    ) AS seller_processing_days,
    
    -- Shipping time
    ROUND(
        CAST(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_delivered_carrier_date)) / 86400.0 AS numeric),
        2
    ) AS carrier_shipping_days,
    
    -- Total delivery time (from order to delivery)
    ROUND(
        CAST(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400.0 AS numeric),
        2
    ) AS actual_total_delivery_days,
    
    -- Service Level Agreement (SLA)
    ROUND(
        CAST(EXTRACT(EPOCH FROM (o.order_estimated_delivery_date - o.order_purchase_timestamp)) / 86400.0 AS numeric),
        2
    ) AS estimated_delivery_days,
    
    -- Late Delivery Indicator (1 = Delivered later than scheduled, 0 = On time or earlier)
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 
        ELSE 0 
    END AS is_late_delivery

FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    customers c ON o.customer_id = c.customer_id
WHERE 
    o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 
    o.order_id,
    o.customer_id,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date;