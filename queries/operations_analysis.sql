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