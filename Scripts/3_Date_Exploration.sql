--==EXPLORE DATE INFORMATION==--

--Min,Max,Range of Dates--
SELECT
	MIN(order_date) First_order_date,
	MAX(order_date) Last_order_date,
	DATEDIFF(YEAR,MIN(order_date),MAX(Order_date)) Order_Range_Year,
	DATEDIFF(MONTH,MIN(order_date),MAX(Order_date)) Order_Range_Months
FROM gold.fact_sales

--Find Yougest and Oldest customers--
SELECT 
	MIN(birthdate) AS Oldest_birthdate,
	DATEDIFF(YEAR,MIN(birthdate),GETDATE()) AS Oldest_age,
	MAX(birthdate) AS Youngest_birthdate,
	DATEDIFF(YEAR,MAX(birthdate),GETDATE()) as Youngest_age
FROM gold.dim_customers