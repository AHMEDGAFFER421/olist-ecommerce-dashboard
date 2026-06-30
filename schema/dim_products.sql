DROP VIEW dim_products;
CREATE OR REPLACE VIEW dim_products AS

SELECT 
	p.product_id,
	COALESCE(t.product_category_name_english, 'Uncategorized') AS category_name
	
FROM products p
LEFT JOIN product_category_translation t 
    ON p.product_category_name = t.product_category_name
