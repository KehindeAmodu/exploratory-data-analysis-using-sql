/*
===============================================================================================================================================
6. RANKING
===============================================================================================================================================
SCRIPT PURPOSE
		This script perform ranking :

      - This is the order of value of dimension by measure e,g TOP 5 Customer based on order placed

      - This involve ranking of dimension by measure using functions like TOP, RANK(), DENSE_RANK(), ROW_NUMBER()
USAGE NOTES
	  	- USING TOPN: Which 5 Products generate the highest revenue? Best performer
		- What are the 5 worst-performing products in terms of sales?
		- USING WINDOW FUNCTION ROW_NUMBER(): Which 5 Products generate the highest revenue? Best performer
		- TOP 10 Customers who have generated the highest revenue
		- 3 customers with the fewest order placed?
===============================================================================================================================================

*/

SELECT TOP 5
p.product_name,
SUM(s.sales_amount) AS Product_revenue
FROM gold.fact_sales s
LEFT JOIN
gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY Product_revenue DESC



----What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
p.product_name,
SUM(s.sales_amount) AS Product_revenue
FROM gold.fact_sales s
LEFT JOIN
gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY Product_revenue ASC

-----USING WINDOW FUNCTION ROW_NUMBER FOR THE SAME RESULT
SELECT * FROM (
SELECT
p.product_name,
SUM(s.sales_amount) AS Product_revenue,
ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount) DESC) AS ranking
FROM gold.fact_sales s
LEFT JOIN
gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_name
)casey
WHERE ranking <=5

----TOP 10 Customers who have generated the highest revenue

SELECT TOP 10
c.customer_key,c.first_name,c.last_name,
SUM(s.sales_amount) AS Total_revenue
FROM gold.fact_sales s
LEFT JOIN
gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key,c.first_name,c.last_name
ORDER BY Total_revenue DESC

----3 customers with the fewest order placed?
SELECT TOP 3
c.customer_key,c.first_name,c.last_name,
COUNT(DISTINCT order_number) AS Total_order
FROM gold.fact_sales s
LEFT JOIN
gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key,c.first_name,c.last_name
ORDER BY Total_order
