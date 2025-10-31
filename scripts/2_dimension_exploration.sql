/*
===============================================================================================================================================
DIMENSION EXPLORATION 
===============================================================================================================================================
SCRIPT PURPOSE
		This script perform dimension exploration:
    -  Analyzed categorical dimensions such as country, marital status, and product category. 

    -  Investigated hierarchies (e.g., country → state → city) to identify distribution patterns and relationships.

USAGE NOTES
		- Run the script to identify unique value or categories in each dimension. Making it easy to recognise how data can be grouped or segmented.
    	- DISTINCT[dimension] is used to know the unique values available in the dimension
===============================================================================================================================================

*/

---Explore all available Countries customers come from in the dataset
SELECT DISTINCT country
FROM gold.dim_customers
