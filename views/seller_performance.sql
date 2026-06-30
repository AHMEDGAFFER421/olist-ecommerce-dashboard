CREATE OR REPLACE VIEW seller_performance AS
SELECT 
    f.seller_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(f.price)::numeric, 2) AS total_revenue,
    ROUND(AVG(f.review_score)::numeric, 2) AS avg_review,
    ROUND(AVG(CASE WHEN f.delivery_status = 'Late' THEN 1.0 ELSE 0.0 END) * 100, 1) AS late_pct,
    ROUND(AVG(f.delivery_days)::numeric, 1) AS avg_delivery_days,
    s.seller_state,
    CASE 
        WHEN COUNT(*) < 20 THEN 'Small'
        WHEN COUNT(*) BETWEEN 20 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS seller_size
FROM fact_table f
JOIN sellers s ON f.seller_id = s.seller_id
GROUP BY f.seller_id, s.seller_state
HAVING COUNT(*) > 10