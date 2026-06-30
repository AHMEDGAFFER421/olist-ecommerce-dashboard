CREATE VIEW weight_affect_delivery_time AS  
SELECT 
    CASE 
        WHEN p.product_weight_g < 500 THEN 'Light (<500g)'
        WHEN p.product_weight_g < 2000 THEN 'Medium (500g-2kg)'
        WHEN p.product_weight_g < 5000 THEN 'Heavy (2kg-5kg)'
        ELSE 'Very Heavy (5kg+)'
    END AS weight_bucket,
    ROUND(AVG(f.delivery_days), 1) AS avg_delivery_days,
    ROUND(AVG(CASE WHEN f.delivery_status = 'Late' THEN 1.0 ELSE 0.0 END) * 100, 1) AS late_pct,
    ROUND(AVG(f.review_score), 2) AS avg_review
FROM fact_table f
JOIN dim_products p ON f.product_id = p.product_id
GROUP BY weight_bucket
ORDER BY avg_delivery_days DESC