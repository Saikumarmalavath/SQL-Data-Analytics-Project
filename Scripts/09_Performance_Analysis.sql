-- === 9. Performance Analysis === --

/*
Analysing the yearly performance of the products
by comparing each product's sales to both its average sales performance
and previous year's sales
*/

WITH Yearly_product_sales AS (
    SELECT
        YEAR(order_date) Order_Year,
        P.product_name,
        SUM(F.sales_amount) Current_Sales
    FROM gold.fact_sales F
    LEFT JOIN gold.dim_products P
        ON F.product_key = P.product_key
    WHERE order_date IS NOT NULL
    GROUP BY
        YEAR(order_date),
        P.product_name
)

SELECT
    Order_Year,
    product_name,
    Current_Sales,
    AVG(Current_Sales) OVER (PARTITION BY product_name) Avg_sales_product,
    Current_Sales - (AVG(Current_Sales) OVER (PARTITION BY product_name)) AS Diff_currentSales_and_Avg,
    CASE
        WHEN Current_Sales - AVG(Current_Sales) OVER (PARTITION BY product_name) > 0 THEN 'Above_Avg'
        WHEN Current_Sales - AVG(Current_Sales) OVER (PARTITION BY product_name) = 0 THEN 'Equal_Avg'
        ELSE 'Below Avg'
    END AS Avg_Change,
    LAG(Current_Sales) OVER (PARTITION BY product_name ORDER BY Order_Year) PreviousYearSales,
    Current_Sales - (LAG(Current_Sales) OVER (PARTITION BY product_name ORDER BY Order_Year)) Diff_PY,
    CASE
        WHEN Current_Sales - (LAG(Current_Sales) OVER (PARTITION BY product_name ORDER BY Order_Year)) > 0 THEN 'Increase'
        WHEN Current_Sales - (LAG(Current_Sales) OVER (PARTITION BY product_name ORDER BY Order_Year)) < 0 THEN 'Decrease'
        ELSE 'No_Change'
    END PY_Change
FROM Yearly_product_sales
ORDER BY
    product_name,
    Order_Year;
