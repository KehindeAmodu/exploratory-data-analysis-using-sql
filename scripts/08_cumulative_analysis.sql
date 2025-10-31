/*
===============================================================================================================================================
8. CUMULATIVE ANALYSIS
===============================================================================================================================================
SCRIPT PURPOSE
		This script perform cumulative analysis:

		
     	- Used cumulative aggregates (SUM() OVER()) to calculate running totals and progressive performance.

		- Built cumulative views for revenue, orders, and customer acquisition.

USAGE NOTES
		- Run the queries to aggregate the data over time. summation of cummulative measure by date dimension
		- Aggregate function like SUM(), AVG(), COUNT() are used to query the level of aggregation and Windows function OVER() to get cummulative of aggregated data e.g
			- Calculate the total sales per month
   			- Calculate the running total of sales over time
===============================================================================================================================================

*/
---Calculate the total sales per month
 SELECT
        CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, order_date), 0) AS DATE) AS order_month,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, order_date), 0) AS DATE)

-- Running total of sales over time
SELECT
    order_month,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_month) AS running_total_sales  -- cumulative total
FROM (
    SELECT
        CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, order_date), 0) AS DATE) AS order_month,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, order_date), 0) AS DATE)
) AS c
ORDER BY order_month


-- Running Total of Sales by Year
SELECT
    DATEPART(YEAR, order_year) AS order_year,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_year) AS running_total_sales
FROM (
    SELECT
        CAST(DATEADD(YEAR, DATEDIFF(YEAR, 0, order_date), 0) AS DATE) AS order_year,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY CAST(DATEADD(YEAR, DATEDIFF(YEAR, 0, order_date), 0) AS DATE)
) AS t
ORDER BY order_year
