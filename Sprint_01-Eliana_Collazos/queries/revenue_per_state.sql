-- TODO: This query will return a table with two columns; customer_state, and 
-- Revenue. The first one will have the letters that identify the top 10 states 
-- with most revenue and the second one the total revenue of each.
-- HINT: All orders should have a delivered status and the actual delivery date 
-- should be not null. 
WITH delivered_orders AS (
    SELECT
        o.order_id,
        o.customer_id,
        p.payment_value
    FROM olist_orders o
    JOIN olist_order_payments p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
),
orders_with_state AS (
    SELECT
        d.payment_value,
        c.customer_state
    FROM delivered_orders d
    JOIN olist_customers c ON d.customer_id = c.customer_id
)
SELECT
    customer_state,
    ROUND(SUM(payment_value), 2) AS Revenue
FROM orders_with_state
GROUP BY customer_state
ORDER BY Revenue DESC
LIMIT 10;
