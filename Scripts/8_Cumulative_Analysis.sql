-- 8. CUMULATIVE ANALYSIS --

-- Total Sales Each Month and Running Total Sales Over Time
SELECT
    Order_Date,
    Total_Sales,
    SUM(Total_Sales) OVER (ORDER BY Order_Date) AS Running_Total_Sales
FROM
(
    SELECT
        DATETRUNC(MONTH, order_date) Order_Date,
        SUM(sales_amount) Total_Sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
) t;


-- Total Sales Each Month and Running Total Sales Over Each Year
SELECT
    Order_Date,
    Total_Sales,
    SUM(Total_Sales) OVER (PARTITION BY Order_Date ORDER BY Order_Date) AS Running_Total_Sales_By_Year
FROM
(
    SELECT
        DATETRUNC(MONTH, order_date) Order_Date,
        SUM(sales_amount) Total_Sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
) t;


-- Total Sales Each Year and Running Total Sales Over Time
SELECT
    Order_Date,
    Total_Sales,
    SUM(Total_Sales) OVER (ORDER BY Order_Date) AS Running_Total_Sales
FROM
(
    SELECT
        DATETRUNC(YEAR, order_date) Order_Date,
        SUM(sales_amount) Total_Sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(YEAR, order_date)
) t;


-- AVG Price Each Year and Running Total Sales Over Time By Year
SELECT
    Order_Date,
    Total_Sales,
    SUM(Total_Sales) OVER (ORDER BY Order_Date) AS Running_Total_Sales,
    SUM(Avg_Price) OVER (ORDER BY Order_Date) AS Moving_Avg
FROM
(
    SELECT
        DATETRUNC(YEAR, order_date) Order_Date,
        SUM(sales_amount) Total_Sales,
        AVG(price) Avg_Price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(YEAR, order_date)
) t;