-- == 12. REPORT == --
/*
===================================================================
Customer Report
===================================================================
Purpose:
    This report consolidates key customer metrics and behaviors.

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
        total orders
        total sales
        total quantity purchased
        total products
        lifespan (in months)
    4. Calculates valuable KPIs:
        recency (months since last order)
        average order value
        average monthly spend
*/
CREATE VIEW gold.report_products AS
WITH BaseQuery AS
(
/* =========================================================
1) Base Query - Retrieve important columns from tables
========================================================= */

    SELECT
        C.customer_key,
        customer_number,
        CONCAT(first_name,' ',last_name) AS FullName,
        gender,
        DATEDIFF(YEAR, birthdate, GETDATE()) AS Age,
        order_number,
        product_key,
        order_date,
        sales_amount,
        quantity,
        price
    FROM gold.fact_sales F
    LEFT JOIN gold.dim_customers C
        ON F.customer_key = C.customer_key
    WHERE order_date IS NOT NULL
),

Customer_Aggregation AS
(
/* ====================================================
Customer Aggregations: Summarizes key metrics
at the customer level
==================================================== */

    SELECT
        customer_key,
        customer_number,
        FullName,
        gender,
        Age,
        COUNT(DISTINCT order_number) AS Total_Orders,
        MAX(order_date) AS Last_Order,
        COUNT(DISTINCT product_key) AS Total_Products,
        SUM(sales_amount) AS Total_Sales,
        SUM(quantity) AS Total_Quantity,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS Life_Span
    FROM BaseQuery
    GROUP BY
        customer_key,
        customer_number,
        FullName,
        gender,
        Age
)

SELECT
    customer_key,
    customer_number,
    FullName,
    gender,
    Age,

    CASE
        WHEN Age < 20 THEN 'Under 20'
        WHEN Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 & Above 50'
    END AS Age_Group,

    Total_Products,
    Total_Quantity,
    Total_Sales,

    -- Average monthly spend
    CASE
        WHEN Life_Span = 0 THEN 0
        ELSE Total_Sales / Life_Span
    END AS Avg_Monthly_Spends,

    Total_Orders,
    Last_Order,

    DATEDIFF(MONTH, Last_Order, GETDATE()) AS Recency,

    -- Average order value
    CASE
        WHEN Total_Sales = 0 THEN 0
        ELSE Total_Sales / Total_Orders
    END AS Avg_Order_Value,

    Life_Span,

    -- Customer Segment
    CASE
        WHEN Life_Span > 12 AND Total_Sales >= 5000 THEN 'VIP'
        WHEN Life_Span > 12 AND Total_Sales < 5000 THEN 'Regular'
        ELSE 'New_Customer'
    END AS Customer_Segment

FROM Customer_Aggregation;


/* Results can be directly viewed
SELECT
    customer_segment,
    COUNT(customer_number) AS Total_Customers,
    SUM(Total_Sales) AS TotalSales
FROM gold.report_customers
GROUP BY customer_segment
*/