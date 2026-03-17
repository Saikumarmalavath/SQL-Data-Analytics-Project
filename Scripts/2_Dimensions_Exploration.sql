--===Dimensions Exploration===--

--Explore All Countries Our Customers comee from
SELECT DISTINCT
	Country
FROM gold.dim_customers

--Explore all categories 'The major Divisions'
SELECT DISTINCT
	category,
	subcategory,
	product_name 
FROM gold.dim_products
Order By 
	1,2,3