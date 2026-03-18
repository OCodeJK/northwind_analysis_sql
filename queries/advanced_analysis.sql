-- Advanced analysis
-- Write a month-over-month revenue growth query using windows function
-- Query:
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', orders.order_date) AS order_month,
        ROUND(SUM(order_details.unit_price * order_details.quantity * (1 - order_details.discount))::numeric, 2) AS total_revenue
    FROM orders
    INNER JOIN order_details ON order_details.order_id = orders.order_id
    WHERE orders.order_date IS NOT NULL
    GROUP BY order_month
)
SELECT
    order_month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY order_month) AS prev_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY order_month))
        / LAG(total_revenue) OVER (ORDER BY order_month) * 100
    , 1) AS mom_growth_percent
FROM monthly_revenue
ORDER BY order_month;

-- Do a cohort analysis - group customers by their first order month and track how many reorder in subsequent months
-- Query:
WITH first_orders AS (
    -- Step 1: find each customer's first order month
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(order_date)) AS cohort_month
    FROM orders
    GROUP BY customer_id
),
customer_orders AS (
    -- Step 2: for every order, calculate how many months after cohort it was
    SELECT
        o.customer_id,
        f.cohort_month,
        DATE_TRUNC('month', o.order_date) AS order_month,
        EXTRACT(YEAR FROM AGE(
            DATE_TRUNC('month', o.order_date), f.cohort_month
        )) * 12 +
        EXTRACT(MONTH FROM AGE(
            DATE_TRUNC('month', o.order_date), f.cohort_month
        )) AS months_since_first
    FROM orders o
    INNER JOIN first_orders f ON f.customer_id = o.customer_id
)
-- Step 3: count distinct customers per cohort per month interval
SELECT
    cohort_month,
    months_since_first,
    COUNT(DISTINCT customer_id) AS active_customers
FROM customer_orders
GROUP BY cohort_month, months_since_first
ORDER BY cohort_month, months_since_first;

-- Calculate customer churn - which customers ordered in Year 1 but not Year 2
-- Query:
WITH year1_customers AS (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) = 1996
),
year2_customers AS (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) = 1997
)
SELECT
    y1.customer_id,
    'churned' AS status
FROM year1_customers y1
LEFT JOIN year2_customers y2 ON y2.customer_id = y1.customer_id
WHERE y2.customer_id IS NULL
ORDER BY y1.customer_id;