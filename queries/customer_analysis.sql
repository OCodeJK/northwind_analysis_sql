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