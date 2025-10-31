/*
===============================================================================================================================================
DATABASE EXPLORATION 
===============================================================================================================================================
SCRIPT PURPOSE
		This script perform database exploration
    Examined the overall database structure, including tables, relationships, and data types.

    Identified primary and foreign keys to understand entity relationships and data integrity.

    Conducted data profiling to assess completeness, uniqueness, and consistency

USAGE NOTES
		- Run these first to have the understanding of the database after loading the dataset
		
===============================================================================================================================================

*/

---EXPLORE ALL OBJECTS IN THE DATABASE
SELECT * FROM INFORMATION_SCHEMA.TABLES

---EXPLORE ALL OBJECTS IN THE DATABASE AND 'WHERE' CLAUSE IS USED TO FILTER FOR A PARTICULAR DIMENSION
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
