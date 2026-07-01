CREATE VIEW retention_by_state AS 
SELECT 
    c.state,
    COUNT(DISTINCT c.customer_id)                                    AS total_customers,
    COUNT(DISTINCT CASE 
        WHEN r.customer_type = 'Returning' 
        THEN c.customer_id 
    END)                                                             AS returning_customers,
    ROUND(
        COUNT(DISTINCT CASE 
            WHEN r.customer_type = 'Returning' 
            THEN c.customer_id 
        END) * 100.0 / COUNT(DISTINCT c.customer_id), 1
    )                                                                AS retention_rate
FROM dim_customers c
LEFT JOIN repeated_customers r ON c.customer_id = r.customer_id
GROUP BY c.state
HAVING COUNT(DISTINCT c.customer_id) > 100
ORDER BY retention_rate ASC;
