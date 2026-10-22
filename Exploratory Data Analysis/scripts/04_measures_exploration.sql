-- MEASURES EXPLORATION

-- Find the Total Sales
SELECT
SUM(sales_amount) as total_sales
FROM gold.fact_sales

-- Find How Many Items Are Solid
SELECT
SUM(quantity) as total_quiantity
FROM gold.fact_sales


-- Find the average selling price
SELECT
AVG(price)as avg_price
FROM gold.fact_sales

-- Find the Total Number of Orders
SELECT
COUNT(DISTINCT order_number) as total_orders
FROM gold.fact_sales


-- Find the Total Number of Products
SELECT 
COUNT(DISTINCT product_name) AS total_prodects,
COUNT(DISTINCT product_key) AS total_prodects
FROM gold.dim_products


-- Find the Total Number of Customers
SELECT 
COUNT(DISTINCT customer_id) AS total_customers,
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.dim_customers

-- Find the Total Number of CUstomers that has placed an order

SELECT 
COUNT(DISTINCT customer_key) as total_customer_placed_orders
FROM gold.fact_sales



--Generate a Report taht shows all akey metrics of the business
SELECT 'total sales' as measured_name, SUM(sales_amount) as total_sales
FROM gold.fact_sales

UNION ALL

SELECT 'total quantity',
SUM(quantity) as total_quiantity
FROM gold.fact_sales

UNION ALL

SELECT 'avg_price',
AVG(price)as avg_price
FROM gold.fact_sales

UNION ALL

SELECT 'total_orders',
COUNT(DISTINCT order_number) as total_orders
FROM gold.fact_sales

UNION ALL

SELECT 'total_prodects',
COUNT(DISTINCT product_key) AS total_prodects
FROM gold.dim_products
UNION ALL

SELECT 'total_customers',
COUNT(DISTINCT customer_id) AS total_customers
FROM gold.dim_customers

UNION ALL

SELECT 'total_customer_placed_orders',
COUNT(DISTINCT customer_key) as total_customer_placed_orders
FROM gold.fact_sales