-- == Measure Exploration == --

-- TOTAL SALES
SELECT
    SUM(sales_amount) AS TOTAL_SALES_AMOUNT
FROM gold.fact_sales;


-- How many items are sold
SELECT
    SUM(quantity) AS TOTAL_QUANTITY
FROM gold.fact_sales;


-- AVERAGE SELLING PRICE
SELECT
    AVG(price) AS AVG_SELLING_PRICE
FROM gold.fact_sales;


-- TOTAL NUMBER OF ORDERS
SELECT
    COUNT(order_number) AS TOT_ORDERS_REPEATED,
    COUNT(DISTINCT order_number) AS TOT_ORDERS
FROM gold.fact_sales;


-- TOTAL NUMBER OF PRODUCTS
SELECT
    COUNT(product_name) AS TOTAL_PRODUCTS
FROM gold.dim_products;


-- FIND THE TOTAL CUSTOMERS
SELECT
    COUNT(customer_key) AS TOT_CUSTOMERS
FROM gold.dim_customers;


-- TOTAL CUSTOMERS WHO PLACED ORDERS
SELECT
    COUNT(DISTINCT customer_key) AS CUSTOMERS_PLACED_ORDERS
FROM gold.fact_sales;


-- REPORT SHOWING ALL KEY METRICS OF THE BUSINESS

SELECT
    'Total Sales' AS MEASURE_NAME,
    SUM(sales_amount) AS MEASURE_VALUE
FROM gold.fact_sales

UNION ALL

SELECT
    'Total Quantity' AS MEASURE_NAME,
    SUM(quantity) AS MEASURE_VALUE
FROM gold.fact_sales

UNION ALL

SELECT
    'Avg Selling Price' AS MEASURE_NAME,
    AVG(price) AS MEASURE_VALUE
FROM gold.fact_sales

UNION ALL

SELECT
    'Total Orders' AS MEASURE_NAME,
    COUNT(DISTINCT order_number) AS MEASURE_VALUE
FROM gold.fact_sales

UNION ALL

SELECT
    'Total Products' AS MEASURE_NAME,
    COUNT(DISTINCT product_name) AS MEASURE_VALUE
FROM gold.dim_products

UNION ALL

SELECT
    'Total Customers' AS MEASURE_NAME,
    COUNT(customer_key) AS MEASURE_VALUE
FROM gold.dim_customers

UNION ALL

SELECT
    'Customers Placed Orders' AS MEASURE_NAME,
    COUNT(DISTINCT customer_key) AS MEASURE_VALUE
FROM gold.fact_sales;