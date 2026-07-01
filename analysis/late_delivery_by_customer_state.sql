SELECT 
    c.state,
    COUNT(*) AS total_orders,
    ROUND(AVG(CASE WHEN f.delivery_status = 'Late' THEN 1.0 ELSE 0.0 END) * 100, 1) AS late_pct,
    ROUND(AVG(f.delivery_days), 1) AS avg_delivery_days
FROM fact_table f
JOIN dim_customers c ON f.customer_id = c.customer_id
GROUP BY c.state
HAVING COUNT(*) > 100
ORDER BY late_pct DESC
LIMIT 10
