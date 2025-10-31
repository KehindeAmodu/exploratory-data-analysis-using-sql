/*
===============================================================================================================================================
10. PART TO WHOLE ANALYSIS
===============================================================================================================================================
SCRIPT PURPOSE
		This script perform to find proportional of a part relative to the overall. exploration:

    - Measured the contribution of individual segments to overall totals (e.g., product share of total sales).

	- Visualized proportional relationships using percentage breakdowns.
USAGE NOTES
		-it is used to analyse how an individual part is performing compared to overall, allowing us to understand which category has the greatest impact in the business. 
		e.g
	  -Which catgeories contribute the most to overall sales? 

===============================================================================================================================================

*/
----Which catgeories contribute the most to overall sales? 
WITH catgeory_sales AS (
SELECT
category,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales s
LEFT JOIN
gold.dim_products p
ON p.product_key = s.product_key
GROUP BY category
)
SELECT 
category,
total_sales,
SUM(total_sales) OVER() AS overall_sales,
CONCAT(ROUND(CAST(total_sales AS FLOAT) / SUM(total_Sales) OVER() *100, 2),'%')  AS percent_of_total_sales
FROM catgeory_sales
--GROUP BY category,total_sales
ORDER BY total_sales DESC
