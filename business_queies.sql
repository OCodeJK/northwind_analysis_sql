-- Revenue and Sales
-- What is the total revenue per year and per quarter? Is the business growing?
-- Query: 
SELECT 
    EXTRACT(YEAR FROM o.order_date) AS order_year,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS total_revenue
FROM order_details as od
INNER JOIN orders as o ON o.order_id = od.order_id
GROUP BY order_year
ORDER BY order_year;

-- Which are the top 10 products by total revenue?
-- Query:
SELECT 
    p.product_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS total_revenue
FROM order_details AS od
INNER JOIN 
	products AS p ON od.product_id = p.product_id
GROUP BY od.product_id, p.product_name
ORDER BY total_revenue desc
LIMIT 10;


-- Which product categories generate the most revenue?
-- Query:
SELECT
	c.category_name,
	ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS total_revenue
FROM products as p
INNER JOIN  
	categories as c on p.category_id = c.category_id
INNER JOIN 
	order_details as od on p.product_id = od.product_id
GROUP BY c.category_name
ORDER BY total_revenue DESC
LIMIT 1;


-- Customers
-- Who are the top 10 customers by lifetime value?
-- Query:
SELECT
    c.contact_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS total_revenue
FROM order_details AS od
INNER JOIN 
	orders AS o ON o.order_id = od.order_id
INNER JOIN
	customers AS c ON c.customer_id = o.customer_id
GROUP BY od.product_id, c.contact_name
ORDER BY total_revenue desc
LIMIT 10;


-- Which country generates the most revenue?
-- Query:
SELECT
    c.country,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS total_revenue
FROM order_details AS od
INNER JOIN 
	orders AS o ON o.order_id = od.order_id
INNER JOIN
	customers AS c ON c.customer_id = o.customer_id
GROUP BY od.product_id, c.country
ORDER BY total_revenue desc
LIMIT 1;


-- What percentages of revenue comes from the top 20% of customers? (Pareto Analysis)
-- Query:
WITH customer_revenue AS (
	SELECT 
	    o.customer_id,
	    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS customer_revenue
	FROM order_details AS od
	INNER JOIN orders AS o ON o.order_id  = od.order_id
	GROUP BY o.customer_id
),
ranked AS (
	SELECT 
		customer_id,
		customer_revenue,
		NTILE(5) OVER (ORDER BY customer_revenue DESC) AS quintile
	FROM customer_revenue
)
SELECT 
	ROUND(SUM(CASE WHEN quintile = 1 THEN customer_revenue ELSE 0 END) / SUM(customer_revenue) * 100, 2) AS top_20_percent_revenue_share
FROM ranked;


-- Operations & Employees
-- Which employees have processed the most orders?
-- Query:
SELECT 
	e.first_name, 
	COUNT(o.order_id) AS processed_most_orders
FROM orders AS o
INNER JOIN
	employees AS e ON o.employee_id = e.employee_id
GROUP BY
	e.first_name
ORDER BY
	processed_most_orders DESC
LIMIT 1;


-- Which shipper has the best/worst average delivery time?
-- Query:
SELECT
	s.company_name,
	ROUND(AVG(o.shipped_date - o.order_date), 1) AS avg_days_to_ship
FROM orders AS o
INNER JOIN
	shippers AS s ON o.ship_via = s.shipper_id
WHERE o.shipped_date IS NOT NULL 
GROUP BY s.company_name
ORDER BY avg_days_to_ship ASC;


-- Are there any orders that were delivered late? (compare required_date vs shipped_date)
-- Query:
SELECT * 
FROM (
	SELECT
		o.required_date,
		o.shipped_date,
		CASE WHEN o.shipped_date > o.required_date THEN 'Yes' ELSE 'No' END AS late,
		s.company_name
	FROM
		orders AS o
	INNER JOIN 
		shippers AS s ON o.ship_via = s.shipper_id
)
WHERE late = 'Yes';


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