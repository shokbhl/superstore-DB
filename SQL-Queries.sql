--Data Exploration Queries:
--View the first 10 rows of the ORDERS table:

SELECT * FROM ORDERS LIMIT 10;

--Get the total number of records in the ORDERS table:
SELECT COUNT(*) FROM ORDERS;

--Calculate total sales for each category:
SELECT Category, SUM(Sales) AS TotalSales FROM ORDERS GROUP BY Category;

--Find the top-selling products:
SELECT ProductName, SUM(quantity) AS TotalQuantity FROM ORDERS GROUP BY ProductName ORDER BY TotalQuantity DESC LIMIT 10;


--Find the top 2 months with the lowest sales in the year 2013:
SELECT EXTRACT(YEAR FROM orderdate) AS OrderYear,
       EXTRACT(MONTH FROM orderdate) AS OrderMonth,
       SUM(sales) AS MonthlySales
FROM ORDERS
WHERE EXTRACT(YEAR FROM orderdate) = 2024
GROUP BY OrderYear, OrderMonth
ORDER BY MonthlySales ASC
LIMIT 2;

--Find duplicate row_id :

SELECT row_id, COUNT(*) AS DuplicateCount
FROM orders
GROUP BY row_id
HAVING COUNT(*) > 1;

--Find the number of orders in each year:
SELECT EXTRACT(YEAR FROM orderdate) AS OrderYear, COUNT(*) AS OrderCount
FROM ORDERS
GROUP BY OrderYear;

--Find the monthly sales of the year 2017:
SELECT EXTRACT(MONTH FROM orderdate) AS OrderMonth, SUM(quantity) AS MonthlySales
FROM orders
WHERE EXTRACT(YEAR FROM orderdate) = 2024
GROUP BY OrderMonth;

--Find the top 2 months with the highest sales in the year 2016:
SELECT EXTRACT(YEAR FROM orderdate) AS OrderYear, EXTRACT(MONTH FROM orderdate) AS OrderMonth, SUM(quantity) AS MonthlySales
FROM orders
WHERE EXTRACT(YEAR FROM orderdate) = 2024
GROUP BY OrderYear, OrderMonth
ORDER BY MonthlySales DESC
LIMIT 2;


--Find the top 2 months with the lowest sales in the year 2017:
SELECT EXTRACT(YEAR FROM orderdate) AS OrderYear, EXTRACT(MONTH FROM orderdate) AS OrderMonth, SUM(quantity) AS MonthlySales
FROM orders
WHERE EXTRACT(YEAR FROM orderdate) = 2024
GROUP BY OrderYear, OrderMonth
ORDER BY MonthlySales ASC
LIMIT 2;


--Extract country code from the id of the ORDERS table:
SELECT LOWER(SUBSTRING(CAST(orderid AS VARCHAR), 1, 2)) AS CountryCode
FROM ORDERS;


--Extract category from the product_id:
SELECT LOWER(SUBSTRING(CAST(productid AS VARCHAR), 1, 2)) AS Category
FROM products;


--Count how many products have been sold in total for each category using only the ORDERS table:

SELECT LOWER(SUBSTRING(CAST(productid AS VARCHAR), 1, 2)) AS Category, COUNT(*) AS ProductCount
FROM ORDERS
GROUP BY Category, productid;




--join all tables together to show all informations in orders table and other joined tables

SELECT *
FROM public.orders AS o
LEFT JOIN public.customers AS c ON o.customerid = c.customerid
LEFT JOIN public.products AS p ON o.productid = p.productid
LEFT JOIN public.product_categories AS pc ON p.categoryid = pc.categoryid
LEFT JOIN public.sales AS s ON o.orderid = s.orderid AND o.productid = s.productid
LEFT JOIN public.returned AS r ON o.orderid = r.orderid AND o.productid = r.productid
LEFT JOIN public.shipping AS sh ON o.orderid = sh.orderid
LEFT JOIN public.transactions AS t ON o.orderid = t.orderid AND o.productid = t.productid
LEFT JOIN public.managers AS m ON pc.categoryid = m.manager_id
LEFT JOIN public.addresses AS a ON o.zipcode = a.zipcode AND o.city = a.city
LEFT JOIN public.regions AS rg ON o.regionid = rg.region_id;

-- Create a temporary table to store the comparison results
CREATE TEMPORARY TABLE comparison_results AS
(
    -- Constraints in the 'orders' table
    SELECT 'orders' AS table_name, constraint_name, column_name
    FROM information_schema.constraint_column_usage
    WHERE table_name = 'orders'

    UNION

    -- Constraints in the 'shipping' table
    SELECT 'shipping' AS table_name, constraint_name, column_name
    FROM information_schema.constraint_column_usage
    WHERE table_name = 'shipping'
);


--RANK() and DENSE_RANK():
--Assigns a rank to each row based on a specified column's values within a partition.
SELECT
  OrderID,
  ProductID,
  Sales,
  RANK() OVER (PARTITION BY OrderID ORDER BY Sales DESC) AS Rank,
  DENSE_RANK() OVER (PARTITION BY OrderID ORDER BY Sales DESC) AS DenseRank
FROM Sales;

--SUM() OVER():
--Calculates a running total or cumulative sum within a partition.

SELECT
  OrderID,
  ProductID,
  Sales,
  SUM(Sales) OVER (PARTITION BY OrderID ORDER BY ProductID) AS CumulativeSales
FROM Sales;

--LEAD() and LAG():
--Access data from subsequent or previous rows within a partition.
SELECT
  OrderID,
  ProductID,
  Sales,
  LEAD(Sales) OVER (PARTITION BY OrderID ORDER BY ProductID) AS NextSales,
  LAG(Sales) OVER (PARTITION BY OrderID ORDER BY ProductID) AS PrevSales
FROM Sales;

--FIRST_VALUE() and LAST_VALUE():
--Retrieve the first and last values within a partition.
SELECT
  OrderID,
  ProductID,
  Sales,
  FIRST_VALUE(ProductID) OVER (PARTITION BY OrderID ORDER BY ProductID) AS FirstProduct,
  LAST_VALUE(ProductID) OVER (PARTITION BY OrderID ORDER BY ProductID) AS LastProduct
FROM Sales;




