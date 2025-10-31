/*
===============================================================================================================================================
Product Report
===============================================================================================================================================
Purpose:
	- This reprt consolidates key product metrics and behaviours.

Highlights:
		1. Gathers essential field s sucha as product name, category, subcategory, and cost
		2. Segments products by revenue to identify High perfomrer, Mid-range and Low-performers.
		3. Aggregates product_level metrics:
			-total orders
			-total sales
			-total quantity sold
			-total customers (Unique)
			-lifespan (in months)
		4. Calculates valuable KPIs:
			-recency (Months Since last sale)
			-average order revenue
			-average monthly revenue
================================================================================================================================================
*/

/*
1. BASE QUERY
*/
/*
-------------------------------------------------------------------------------------------------------------------------------------------------
Product Base Query: Retrieves core columns from fact_sales and dim_products
------------------------------------------------------------------------------------------------------------------------------------------------
*/
--- CREATE VIEW gold.report_products AS 
WITH pd_base_query AS (
SELECT 
p.product_key,
s.customer_key,
p.product_name,
p.category,
p.subcategory,
p.cost,
s.order_number,
s.sales_amount,
s.quantity,
s.order_date
FROM gold.fact_sales s
JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
),

/*-----------------------------------------------------------------------------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
------------------------------------------------------------------------------------------------------------------------------------------------
*/
product_aggregation AS (
SELECT 
product_key,
product_name,
category,
subcategory,
cost,
COUNT(DISTINCT customer_key) AS total_customers,
COUNT(DISTINCT order_number) AS total_order,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
DATEDIFF(MONTH,MIN(order_date), MAX(order_date)) AS lifespan,
MAX(order_date) AS last_sale_date,
ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM pd_base_query
GROUP BY product_key,product_name, category,subcategory,cost
)
-----3. Final Query: Combines all product results into one output
SELECT 
product_key,
product_name, 
category,
subcategory,
cost,
last_sale_date,
DATEDIFF(MONTH,last_sale_date,GETDATE()) AS recency_in_months,
CASE
	WHEN total_sales > 50000 THEN 'High_performer'
	WHEN total_sales >= 10000 THEN 'Mid_range'
	ELSE 'Low-performer'
END AS product_segment,
lifespan,
total_order,
total_sales,
total_quantity,
total_customers,
avg_selling_price, 
-----------------Average Order Revenue
CASE 
	WHEN total_order = 0 THEN 0
	ELSE total_sales / total_order
END AS avg_order_revenue,

--------------Average Monthly Revenue

CASE
	WHEN lifespan = 0 THEN total_sales
	ELSE total_sales / lifespan
END AS avg_monthly_revenue
FROM product_aggregation



SELECT 
customer_id,
first_name, last_name
FROM gold.dim_customers
WHERE first_name = 'Jon' AND last_name = 'shen'

SELECT 
(quantity*cost) AS revenue


SELECT * FROM gold.fact_sales
