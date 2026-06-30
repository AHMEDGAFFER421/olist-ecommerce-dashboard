DROP VIEW dim_sellers;
CREATE VIEW dim_sellers AS

SELECT
	seller_id,
	seller_city AS city,
	seller_state As state
FROM sellers

