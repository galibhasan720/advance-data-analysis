-- Find the date of the first and last order
-- How many years of sales are available
-- How many month of sales are available
SELECT
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(YEAR, MIN(order_date),MAX(order_date)) AS order_range_years,
	DATEDIFF(MONTH, MIN(order_date),MAX(order_date)) AS order_range_month
FROM gold.fact_sales


--Find the youngest and oldest customer
SELECT 
MIN(birthdate) AS oldest_birthdate,
DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age,
MAX(birthdate) AS youngest_birthdate
FROM gold.dim_customers