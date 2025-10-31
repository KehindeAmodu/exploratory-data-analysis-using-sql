/*
===============================================================================================================================================
7. CHANGE OVER TIME
===============================================================================================================================================
SCRIPT PURPOSE
		This script perform and explore change over time trends:

      -Change Over Time analyses how a measure evolves over time. 
      -This helps to track trends and identify seasonality in the data
USAGE NOTES
	- The queries below calculate summation of measures by date dimension e.g Total sales by year, Avergae cost by month, e.t.c
    - check for trend of
				- total sales
				- total customers
				- total quantity sold
	over the months and the year.
===============================================================================================================================================

*/

SELECT 
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,------------to check for trend over months, switch YEAR for MONTH
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)


SELECT 
FORMAT(order_date, 'MMM-yyyy') AS order_month_year,------------to use date format of your choice
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'MMM-yyyy')
ORDER BY FORMAT(order_date, 'MMM-yyyy')
