-- === RANKING === --

-- TOP 5 HIGHEST REVENUE GENERATING PRODUCTS
SELECT TOP 5
    P.product_name,
    SUM(F.sales_amount) Tot_revenue
FROM gold.fact_sales F
LEFT JOIN gold.dim_products P
    ON P.product_key = F.product_key
GROUP BY P.product_name
ORDER BY Tot_revenue DESC;


-- WORST 5 REVENUE GENERATING PRODUCTS
SELECT TOP 5
    P.product_name,
    SUM(F.sales_amount) Tot_revenue
FROM gold.fact_sales F
LEFT JOIN gold.dim_products P
    ON P.product_key = F.product_key
GROUP BY P.product_name
ORDER BY Tot_revenue;


-- USING WINDOW FUNCTIONS
SELECT *
FROM (
    SELECT
        P.product_name,
        SUM(F.sales_amount) Tot_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(F.sales_amount) DESC) Ranking
    FROM gold.fact_sales F
    LEFT JOIN gold.dim_products P
        ON P.product_key = F.product_key
    GROUP BY P.product_name
) t
WHERE Ranking <= 5;


-- Top 10 customers generating highest revenue
SELECT TOP 10
    C.customer_key,
    C.first_name,
    C.last_name,
    SUM(F.sales_amount) Tot_revenue
FROM gold.fact_sales F
LEFT JOIN gold.dim_customers C
    ON C.customer_key = F.customer_key
GROUP BY
    C.customer_key,
    C.first_name,
    C.last_name
ORDER BY Tot_revenue DESC;


-- Top 10 customers generating lowest revenue
SELECT TOP 10
    C.customer_key,
    C.first_name,
    C.last_name,
    SUM(F.sales_amount) Tot_revenue
FROM gold.fact_sales F
LEFT JOIN gold.dim_customers C
    ON C.customer_key = F.customer_key
GROUP BY
    C.customer_key,
    C.first_name,
    C.last_name
ORDER BY Tot_revenue;


-- TOP 3 CUSTOMERS WITH FEWEST ORDERS
SELECT TOP 3
    C.customer_key,
    C.first_name,
    C.last_name,
    COUNT(DISTINCT F.order_number) Tot_orders
FROM gold.fact_sales F
LEFT JOIN gold.dim_customers C
    ON C.customer_key = F.customer_key
GROUP BY
    C.customer_key,
    C.first_name,
    C.last_name
ORDER BY Tot_orders;
