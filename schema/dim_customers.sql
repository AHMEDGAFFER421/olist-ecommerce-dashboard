CREATE OR REPLACE VIEW dim_customers AS
SELECT DISTINCT ON (customer_unique_id)
    customer_unique_id       AS customer_id,
    customer_city            AS city,
    customer_state           AS state,
    customer_zip_code_prefix AS zip_code
FROM customers
ORDER BY customer_unique_id