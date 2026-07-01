CREATE VIEW analysis_on_products AS
SELECT 
	AVG(f.review_score) AS avg_score,
	AVG(delivery_days)  AS avg_days,
    ROUND(COUNT(CASE WHEN delivery_status = 'Late' THEN 1 END) * 100.0 / COUNT(*), 1)/100 AS late_pct,
	p.category_name
	FROM dim_products p
	LEFT JOIN Fact_table f
	ON f.product_id = p.product_id
	GROUP BY  p.category_name
	HAVING AVG(f.review_score) IS NOT NULL AND COUNT(*) > 100
	ORDER BY late_pct DESC
