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