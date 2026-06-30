SELECT 
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT CASE WHEN order_count > 1 THEN customer_id END) AS bought_2plus,
    COUNT(DISTINCT CASE WHEN order_count >= 10 THEN customer_id END) AS bought_10plus
FROM repeated_customers;