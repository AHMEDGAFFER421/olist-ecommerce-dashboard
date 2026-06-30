CREATE OR REPLACE VIEW fact_table AS
SELECT
    oi.order_id,
    oi.product_id,
    oi.seller_id,
    c.customer_unique_id AS customer_id,
    o.order_purchase_timestamp::date AS order_date,
    oi.price,
    oi.freight_value,
    r.review_score,
    CASE 
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'On Time'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late'
        ELSE 'Not Delivered'
    END AS delivery_status,
    EXTRACT(DAY FROM o.order_delivered_customer_date - o.order_purchase_timestamp)::int AS delivery_days
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')