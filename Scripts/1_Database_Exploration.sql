--===Database Exploration===--


--Explore all objects in the Database
SELECT*
FROM INFORMATION_SCHEMA.TABLES

--EXPLORE ALL COLUMNS IN THE DATABASE
SELECT*
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='dim_customers'