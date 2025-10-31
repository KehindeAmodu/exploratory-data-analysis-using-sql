/*
===============================================================================================================================================
4. MEASURE EXPLORATION 
===============================================================================================================================================
SCRIPT PURPOSE
		This script perform measure exploration:

      -Defined key performance measures (e.g., sales, profit, quantity).

      -Assessed measure distributions, averages, and variances across different dimensions.
USAGE NOTES
	  - Run the script to calculate the key metric of the business
    - Aggregate function like SUM(), AVG(), COUNT() are used to query the level of aggregation
    -Find the average selling price
    -Find how many items are sold
    -Find the average selling price
    -Find the Total number of Orders
    -Find the total number of products
    -Find the total number of customers that has placed an order
    -GENERATE a Report that shows all Key Metrics of the business
===============================================================================================================================================

*/

-----FInd the total Sales

SELECT SUM(sales_amount) AS Total_sales FROM Gold.fact_sales

----Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

---Find the average selling price
SELECT AVG(price) AS total_quantity FROM gold.fact_sales

---Find the Total number of Orders
SELECT COUNT(order_number) AS total_order FROM gold.fact_sales
SELECT COUNT(DISTINCT(order_number)) AS total_order FROM gold.fact_sales ----DISTINCT FILTER OUT DUPLICATES GIVING EXACT TOTAL NUMBER OF UNIQUE ORDERS

---Find the total number of products
SELECT COUNT(product_name) FROM gold.dim_products
SELECT COUNT(DISTINCT(product_name)) FROM gold.dim_products

---Find the total number of customers that has placed an order
SELECT COUNT(customer_key) FROM gold.dim_customers
SELECT COUNT(DISTINCT(customer_key)) FROM gold.dim_customers

----GENERATE a Report that shows all Key Metrics of the business
SELECT 'Total Sales' AS 'Measure Name', SUM(sales_amount) AS 'Measure value' FROM gold.fact_sales
UNION ALL
SELECT 'Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Product', COUNT(product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Nr. Customers', COUNT(customer_key) FROM gold.dim_customers
