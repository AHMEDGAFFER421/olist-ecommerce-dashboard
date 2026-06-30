SELECT 
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    COUNT(oi.order_id) AS total_orders,
    ROUND(SUM(oi.price)::numeric, 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY month
ORDER BY month