-- == 10. PART TO WHOLE ANALYSIS == --

-- Category contributing more to overall sales
WITH Category_Sales AS
(
    SELECT
        P.category,
        SUM(F.sales_amount) Category_Sales
    FROM gold.fact_sales F
    LEFT JOIN gold.dim_products P
        ON F.product_key = P.product_key
    GROUP BY
        P.category
)

SELECT
    category,
    Category_Sales,
    SUM(Category_Sales) OVER() Total_Sales,
    CONCAT(
        ROUND(
            CAST(Category_Sales AS FLOAT) / SUM(Category_Sales) OVER() * 100,
            2
        ),
        '%'
    ) AS Category_Contribution_Percentage
FROM Category_Sales
ORDER BY Category_Sales DESC;