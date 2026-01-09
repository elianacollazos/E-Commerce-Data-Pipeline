WITH delivered_orders AS (
    SELECT
        o.order_id,
        o.order_delivered_customer_date,
        p.payment_value
    FROM olist_orders o
    JOIN olist_order_payments p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
),
order_items_with_category AS (
    SELECT
        do.order_id,
        do.payment_value,
        t.product_category_name_english AS category
    FROM delivered_orders do
    JOIN olist_order_items i ON do.order_id = i.order_id
    JOIN olist_products pr ON i.product_id = pr.product_id
    JOIN product_category_name_translation t ON pr.product_category_name = t.product_category_name
    WHERE t.product_category_name_english IS NOT NULL
),
category_aggregates AS (
    SELECT
        category AS Category,
        COUNT(DISTINCT order_id) AS Num_order,
        ROUND(SUM(payment_value), 2) AS Revenue
    FROM order_items_with_category
    GROUP BY category
)
SELECT *
FROM category_aggregates
ORDER BY Revenue DESC
LIMIT 10;
