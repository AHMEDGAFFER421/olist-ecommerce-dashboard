CREATE VIEW repeated_customers AS
SELECT
    customer_id,
    COUNT(order_id) AS order_count,
    CASE WHEN COUNT(order_id) = 1 THEN 'New' ELSE 'Returning' END AS customer_type
FROM fact_table
GROUP BY customer_id