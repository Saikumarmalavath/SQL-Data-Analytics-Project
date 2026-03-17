-- == 11. DATA SEGMENTATION == --

/* Segmenting products into cost ranges
and counting how many products fall into each category */

WITH Product_Segmentation AS
(
    SELECT
        product_key,
        product_name,
        cost,
        CASE
            WHEN cost < 100 THEN 'BELOW 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            WHEN cost > 1000 THEN 'ABOVE 1000'
        END AS CostRange
    FROM gold.dim_products
)

SELECT
    CostRange,
    COUNT(product_key) TotalProducts
FROM Product_Segmentation
GROUP BY CostRange
ORDER BY TotalProducts DESC;


/* THREE CATEGORIES OF CUSTOMERS
VIP -- 12 months history, spending > 5000
REGULAR -- 12 months history, spending <= 5000
NEW -- lifespan < 12 months

Total number of customers by each group */

WITH CustomerSpending AS
(
    SELECT
        C.customer_key,
        SUM(F.sales_amount) TotalSales,
        MIN(order_date) FirstOrder,
        MAX(order_date) LastOrder,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) Order_Span
    FROM gold.fact_sales F
    LEFT JOIN gold.dim_customers C
        ON F.customer_key = C.customer_key
    GROUP BY C.customer_key
)

SELECT
    CustomerSegment,
    COUNT(customer_key) Total_Customers
FROM
(
    SELECT
        customer_key,
        TotalSales,
        Order_Span,
        CASE
            WHEN TotalSales >= 5000 AND Order_Span >= 12 THEN 'VIP'
            WHEN TotalSales <= 5000 AND Order_Span >= 12 THEN 'Regular'
            ELSE 'New_Customer'
        END CustomerSegment
    FROM CustomerSpending
) t
GROUP BY CustomerSegment
ORDER BY Total_Customers DESC;