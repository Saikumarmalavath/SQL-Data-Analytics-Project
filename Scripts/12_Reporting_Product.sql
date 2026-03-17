/*
=================================================
Product Report
=================================================
Purpose:
    This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
        total orders
        total sales
        total quantity sold
        total customers (unique)
        lifespan (in months)
    4. Calculates valuable KPIs:
        recency (months since last sale)
        average order revenue (AOR)
        average monthly revenue
*/

CREATE VIEW gold.report_product AS

WITH Base_Query AS
(
/* =========================================================
1) Base query - Retrieve important columns from tables
========================================================= */

    SELECT
        P.product_key,
        P.product_number,
        P.product_name,
        P.category,
        P.subcategory,
        P.cost,
        F.customer_key,
        F.order_number,
        F.order_date,
        F.sales_amount,
        F.quantity,
        F.price
    FROM gold.fact_sales F
    LEFT JOIN gold.dim_products P
        ON F.product_key = P.product_key
    WHERE order_date IS NOT NULL
),

/* ====================================================
Product Aggregations: Summarizes key metrics
at the product level
==================================================== */

Product_Aggregation AS
(
    SELECT
        product_key,
        product_number,
        product_name,
        category,
        subcategory,
        cost,
        COUNT(DISTINCT customer_key) AS Total_Customers,
        COUNT(DISTINCT order_number) AS Total_Orders,
        MAX(order_date) AS Last_Order,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS Life_Span,
        SUM(sales_amount) AS Total_Sales,
        SUM(quantity) AS Total_Quantity,
        ROUND(AVG((CAST(sales_amount AS FLOAT) / NULLIF(quantity,0))),2) AS Avg_Selling_Price
    FROM Base_Query
    GROUP BY
        product_key,
        product_number,
        product_name,
        category,
        subcategory,
        cost
)

-- Final results as one output
SELECT
    product_key,
    product_number,
    product_name,
    category,
    subcategory,
    cost,
    Total_Orders,
    Last_Order,
    DATEDIFF(MONTH, Last_Order, GETDATE()) AS Recency,
    Life_Span,
    Total_Sales,

-- Segmentation products by revenue
CASE
    WHEN Total_Sales >= 70000 THEN 'High Performer'
    WHEN Total_Sales >= 20000 THEN 'Mid Performer'
    ELSE 'Low Performer'
END AS Product_Performance,

-- Avg monthly revenue
CASE
    WHEN Life_Span = 0 THEN Total_Sales
    ELSE Total_Sales / Life_Span
END AS Avg_Monthly_Revenue,

-- Avg Order Revenue (AOR)
CASE
    WHEN Total_Orders = 0 THEN 0
    ELSE Total_Sales / Total_Orders
END AS Avg_Order_Revenue,

Avg_Selling_Price

FROM Product_Aggregation;

/* Results can be directly viewed
SELECT *
FROM gold.report_product
*/