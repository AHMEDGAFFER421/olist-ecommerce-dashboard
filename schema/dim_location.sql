CREATE VIEW dim_location AS

SELECT DISTINCT ON (geolocation_zip_code_prefix)
    geolocation_zip_code_prefix AS zip_code,
    geolocation_city            AS city,
    geolocation_state           AS state,
    geolocation_lat             AS latitude,
    geolocation_lng             AS longitude
FROM geolocation
ORDER BY geolocation_zip_code_prefix