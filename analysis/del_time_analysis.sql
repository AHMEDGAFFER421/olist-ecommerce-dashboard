SELECT
    ROUND(AVG(delivery_days)::numeric, 1) AS avg_delivery_days,
    delivery_status,
    COUNT(*) AS total_orders
FROM fact_table
GROUP BY delivery_status
ORDER BY total_orders DESC
