CREATE VIEW dim_date AS

SELECT
    date::date AS date,
    EXTRACT(DAY FROM date)::int AS day,
    EXTRACT(MONTH FROM date)::int AS month,
    TO_CHAR(date, 'Month') AS month_name,
    EXTRACT(QUARTER FROM date)::int AS quarter,
    EXTRACT(YEAR FROM date)::int AS year
FROM generate_series(
    '2016-01-01'::date,
    '2018-12-31'::date,
    '1 day'::interval
) AS date
