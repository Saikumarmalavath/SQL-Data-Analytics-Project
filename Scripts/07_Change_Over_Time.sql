-- == CHANGE OVER TIME TRENDS == --

-- Sales performance over time (YEAR)
SELECT
    YEAR(order_date) Order_Year,
    SUM(sales_amount) Total_sales,
    COUNT(DISTINCT customer_key) Total_Customers,
    COUNT(quantity) Total_Quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);


-- Sales performance over time (MONTH)
SELECT
    MONTH(order_date) Order_month,
    SUM(sales_amount) Total_sales,
    COUNT(DISTINCT customer_key) Total_Customers,
    COUNT(quantity) Total_Quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date);


-- Sales performance over time using FORMAT
SELECT
    FORMAT(order_date, 'yyyy-MMM') Order_month,
    SUM(sales_amount) Total_sales,
    COUNT(DISTINCT customer_key) Total_Customers,
    COUNT(quantity) Total_Quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM');


-- Using DATETRUNC
SELECT
    DATETRUNC(MONTH, order_date) Order_Date,
    SUM(sales_amount) Total_Sales,
    COUNT(customer_key) Total_customers,
    COUNT(quantity) Total_Quantity
FROM gold.fact_sales
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date);
