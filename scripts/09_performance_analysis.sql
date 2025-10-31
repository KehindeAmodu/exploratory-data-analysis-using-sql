/*
===============================================================================================================================================
9. PERFORMANCE ANALYSIS
===============================================================================================================================================
SCRIPT PURPOSE
		This script perform performance analysis :

      	- Benchmarked actual metrics against targets or averages.

		- Identified top-performing and underperforming categories based on KPIs by measuring success and comparing performance.
USAGE NOTES
	  - Run the script to calculate the current measure from the target value. (current measure - target value) e.g current year sales - previous year sales e.g
    		-Analyse the yearly performance of products by comparing each product's sales to both its average sales performance and previous year's sales

===============================================================================================================================================

*/

WITH yearly_product_sales AS (                      ------------------------------CTE
SELECT 
 YEAR(order_date) AS order_year ,
 product_name,
 SUM(s.sales_amount) AS current_sales
FROM gold.fact_sales s
LEFT JOIN
gold.dim_products p
ON  s.product_key =  p.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), p.product_name
)

SELECT 
order_year,
product_name,
current_sales,
AVG(current_sales) OVER(PARTITION BY product_name) AS Average_Sales,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_av,-----compare sales performance with the average of the sales
CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
	 WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
ELSE 'Avg'
END AS 'performance',
LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS prev_year_sales,  -----previous year sales of the product
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_prev_year_sales,-----to compare the difference between the current sales and previous sales
CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
	 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
	 ELSE 'No Change'
END AS 'prev_year_changes'
FROM yearly_product_sales
GROUP BY product_name, order_year,current_sales
ORDER BY product_name, order_year
