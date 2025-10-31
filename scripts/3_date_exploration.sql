/*
===============================================================================================================================================
3. DATE EXPLORATION 
===============================================================================================================================================
SCRIPT PURPOSE
		This script perform date exploration:

    - Utilized SQL date functions to analyze data across time periods.

    - Explored seasonality, monthly and yearly trends, and temporal gap.

USAGE NOTES
	- Run the script to explore the boundary of time from the earliest and lastest date
    - MIN() AND MAX() are used to query the earliest and lastest dates respectively
    - Find the date of the first and last order
    - Calculate range of order made in months
===============================================================================================================================================

*/

 -- DATE EXPLORATION USING MIN/MAX to know the earliest amd latest value

SELECT 
MIN (order_date) AS first_order_date,							                          	------------Date of first order
MAX(order_date) AS last_order_date,								                          	------------Date of most recent order
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS Order_range_years      				------------Number of months between the time the first and the last order was made
FROM gold.fact_sales

SELECT 
MIN(birthdate) AS oldest_birthdate,								                          	------------Birthdate of oldest customer
DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,		                			-----------------age of oldest customer
DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age,		             				------------Birthdate of youngest customer
MAX(birthdate) AS youngest_birthdate							                          	-----------------age of oldest customer
FROM gold.dim_customers
