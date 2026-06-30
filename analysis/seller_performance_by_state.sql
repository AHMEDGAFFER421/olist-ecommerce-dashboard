SELECT 
    s.seller_state,
    COUNT(DISTINCT f.seller_id) AS total_sellers,
    ROUND(AVG(f.review_score), 2) AS avg_review,
    ROUND(AVG(CASE WHEN f.delivery_status = 'Late' THEN 1.0 ELSE 0.0 END) * 100, 1) AS late_pct,
    ROUND(AVG(f.delivery_days), 1) AS avg_delivery_days
FROM fact_table f
JOIN sellers s 
ON f.seller_id = s.seller_id
GROUP BY s.seller_state
HAVING COUNT(DISTINCT f.seller_id) > 5
ORDER BY avg_review ASC 


