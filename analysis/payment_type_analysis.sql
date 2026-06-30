SELECT 
    payment_type,
    COUNT(*) AS total_orders,
    ROUND(AVG(review_score), 2) AS avg_review,
    ROUND(AVG(CASE WHEN delivery_status = 'Late' THEN 1.0 ELSE 0.0 END) * 100, 1) AS late_pct,
    ROUND(AVG(payment_installments), 1) AS avg_installments,
    ROUND(AVG(price), 2) AS avg_order_value
FROM payment_analysis
GROUP BY payment_type
ORDER BY total_orders DESC