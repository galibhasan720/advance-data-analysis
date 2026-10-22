--Which 5 products generate the highest revenue
SELECT TOP 5
	p.subcategory,
	SUM(f.sales_amount) AS total_revenue

FROM gold.dim_products p
LEFT JOIN gold.fact_sales f
ON p.product_key = f.product_key
GROUP BY p.subcategory
ORDER BY total_revenue DESC



--Bu Using Window Function- ROW_NUMBER()
SELECT * FROM(
SELECT
	p.subcategory,
	SUM(f.sales_amount) AS total_revenue,
	ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
FROM gold.dim_products p
LEFT JOIN gold.fact_sales f
ON p.product_key = f.product_key
WHERE f.sales_amount IS NOT NULL
GROUP BY p.subcategory
)t
WHERE rank_products <= 5





-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
	p.subcategory,
	SUM(f.sales_amount) AS total_revenue

FROM gold.dim_products p
LEFT JOIN gold.fact_sales f
ON p.product_key = f.product_key
WHERE f.sales_amount IS NOT NULL
GROUP BY p.subcategory
ORDER BY total_revenue



--Bu Using Window Function- RANK()
SELECT * FROM(
SELECT
	p.subcategory,
	SUM(f.sales_amount) AS total_revenue,
	RANK() OVER (ORDER BY SUM(f.sales_amount) ASC) AS rank_products
FROM gold.dim_products p
LEFT JOIN gold.fact_sales f
ON p.product_key = f.product_key
WHERE f.sales_amount IS NOT NULL
GROUP BY p.subcategory
--ORDER BY total_revenue
)t
WHERE rank_products <= 5