CREATE VIEW payment_analysis AS
SELECT 
    f.order_id,
    f.customer_id,
    f.seller_id,
    f.review_score,
    f.delivery_status,
    f.delivery_days,
    f.price,
    op.payment_type,
    op.payment_installments,
    op.payment_value
FROM fact_table f
JOIN order_payments op ON f.order_id = op.order_id