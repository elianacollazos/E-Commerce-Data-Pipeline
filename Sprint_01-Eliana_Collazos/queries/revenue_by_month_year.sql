-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).

WITH min_payments AS (
    SELECT
        o.order_id,
        o.order_delivered_customer_date,
        o.order_status,
        MIN(p.payment_value) AS payment_value
    FROM olist_orders o
    JOIN olist_order_payments p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
    GROUP BY o.order_id, o.order_delivered_customer_date, o.order_status
),
enriched_orders AS (
    SELECT
        order_id,
        payment_value,
        strftime('%Y', order_delivered_customer_date) AS year,
        strftime('%m', order_delivered_customer_date) AS month_no
    FROM min_payments
),
revenue_by_month AS (
    SELECT
        month_no,
        ROUND(SUM(CASE WHEN year = '2016' THEN payment_value ELSE 0 END), 2) AS Year2016,
        ROUND(SUM(CASE WHEN year = '2017' THEN payment_value ELSE 0 END), 2) AS Year2017,
        ROUND(SUM(CASE WHEN year = '2018' THEN payment_value ELSE 0 END), 2) AS Year2018
    FROM enriched_orders
    WHERE year IN ('2016', '2017', '2018')
    GROUP BY month_no
)
SELECT
    month_no,
    CASE month_no
        WHEN '01' THEN 'Jan'
        WHEN '02' THEN 'Feb'
        WHEN '03' THEN 'Mar'
        WHEN '04' THEN 'Apr'
        WHEN '05' THEN 'May'
        WHEN '06' THEN 'Jun'
        WHEN '07' THEN 'Jul'
        WHEN '08' THEN 'Aug'
        WHEN '09' THEN 'Sep'
        WHEN '10' THEN 'Oct'
        WHEN '11' THEN 'Nov'
        WHEN '12' THEN 'Dec'
    END AS month,
    Year2016,
    Year2017,
    Year2018
FROM revenue_by_month
ORDER BY month_no;

