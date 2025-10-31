/*
===============================================================================================================================================
Customer Report
===============================================================================================================================================
Purpose:
	- This reprt comnslidates key customer metrics and behaviours

Highlights:
		1. Gathers essential field s sucha as names, ages, and transaction details.
		2. Segments customers into categories (VIP, Regular, New) and age groups.
		3. Aggregates custoemr_level metrics:
			- total orders
			-total sales
			-total quantity purchased
			-total products
			-lifespan (in months)
		4. Calculates valuable KPIs:
			-recency (Months Since last order)
			-average order value
			-average monthly spend
================================================================================================================================================
*/

/*-----------------------------------------------------------------------------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
------------------------------------------------------------------------------------------------------------------------------------------------
*/
CREATE VIEW gold.report_customers AS

WITH base_query AS (
/*-----------------------------------------------------------------------------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_customers
------------------------------------------------------------------------------------------------------------------------------------------------
*/
SELECT
s.order_number,
s.product_key,
s.order_date,
s.sales_amount,
s.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
DATEDIFF(YEAR, birthdate, GETDATE()) AS age
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON c.customer_key = s.customer_key
WHERE s.order_date IS NOT NULL
),

customer_aggregation AS (
/*-----------------------------------------------------------------------------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
------------------------------------------------------------------------------------------------------------------------------------------------
*/
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date))AS lifespan
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age
)

SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE 
		WHEN age < 20 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50 and above'
	END AS age_group,
	CASE 
		WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
		END customer_segment,
	total_orders,
	total_sales,
	total_quantity,
	last_order_date,
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency, ------------ Recency: Months since last order
	total_products,
	lifespan,
	---COmpute average order value (AVO)
	CASE WHEN total_sales = 0 THEN 0 -----------------This is to make sure we are not dividing by 0
	ELSE total_sales / total_orders	----Average order value = total sales/ total number of orders
	END AS avg_order_value,
	---Compute Average Montly Spend
	CASE WHEN lifespan = 0 THEN total_sales -----------------This is to make sure we are not dividing by 0 but where lifespan is 0, the value of total_sale shoudl be used instead
	ELSE total_sales / lifespan----Average order value = total sales/ lifespan
	END AS AVG_monthly_spend
	FROM customer_aggregation
