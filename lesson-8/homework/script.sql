-- 1. Using Products table, find the total number of products available in each category.
SELECT Category, COUNT(ProductID) AS NumberOfProducts
FROM Products
GROUP BY Category;

-- 2. Using Products table, get the average price of products in the 'Electronics' category.
SELECT AVG(Price) as AvgPrice
FROM Products
WHERE Category = 'Electronics';

-- 3. Using Customers table, list all customers from cities that start with 'L'.
SELECT *
FROM Customers
WHERE City LIKE 'L%';

-- 4. Using Products table, get all product names that end with 'er'.
SELECT ProductName
FROM Products
WHERE ProductName LIKE '%er';

-- 5. Using Customers table, list all customers from countries ending in 'A'.
SELECT * 
FROM Customers
WHERE Country LIKE '%A';

-- 6. Using Products table, show the highest price among all products.
SELECT MAX(Price) AS HighestPrice
FROM Products

-- 7. Using Products table, label stock as 'Low Stock' if quantity < 30, else 'Sufficient'.
SELECT *, CASE WHEN StockQuantity < 30 THEN 'Low Stock'
		  ELSE 'Sufficient'
		  END AS 'StockLabel'
FROM Products

-- 8. Using Customers table, find the total number of customers in each country.
SELECT Country, COUNT(CustomerID) AS NumberOfCustomers
FROM Customers
GROUP BY Country;

-- 9. Using Orders table, find the minimum and maximum quantity ordered.
SELECT MIN(Quantity) AS MinQuantity, MAX(Quantity) AS MaxQuantity
FROM Orders;

-- 10. Using Orders and Invoices tables, list customer IDs who placed orders in 2023 January to find those who did not have invoices.
SELECT *
FROM Orders AS o
LEFT JOIN Invoices AS i
	ON o.CustomerID = i.CustomerID
WHERE YEAR(o.OrderDate) = 2023 AND MONTH(o.OrderDate) = 1 AND i.InvoiceID IS NULL;

-- 11. Using Products and Products_Discounted table, Combine all product names from Products and Products_Discounted including duplicates.
SELECT ProductName
FROM Products
UNION ALL
SELECT ProductName
FROM Products_Discounted;

-- 12. Using Products and Products_Discounted table, Combine all product names from Products and Products_Discounted without duplicates.
SELECT ProductName
FROM Products
UNION
SELECT ProductName
FROM Products_Discounted;

-- 13. Using Orders table, find the average order amount by year.
SELECT YEAR(OrderDate) AS Year, AVG(TotalAmount) AS AvgAmount
FROM Orders
GROUP BY YEAR(OrderDate);

-- 14. Using Products table, group products based on price: 'Low' (<100), 'Mid' (100-500), 'High' (>500). Return productname and pricegroup.
SELECT ProductName,
       CASE 
           WHEN Price < 100 THEN 'Low'
           WHEN Price <= 500 THEN 'Mid'
           ELSE 'High'
       END AS PriceGroup
FROM Products;

-- 15. Using City_Population table, use Pivot to show values of Year column in seperate columns ([2012], [2013]) and copy results to a new Population_Each_Year table.
SELECT * FROM 
(
	SELECT district_id, district_name, year, population
	FROM city_population
) AS a
PIVOT
(
	SUM(population)
	FOR year in ([2012],[2013])
) AS Population_Each_Year;

-- 16. Using Sales table, find total sales per product Id.
SELECT ProductID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ProductID;

-- 17. Using Products table, use wildcard to find products that contain 'oo' in the name. Return productname.
SELECT ProductName
FROM Products
WHERE ProductName LIKE '%oo%';

-- 18. Using City_Population table, use Pivot to show values of City column in seperate columns (Bektemir, Chilonzor, Yakkasaroy) and copy results to a new Population_Each_City table.
SELECT * FROM
( 
	SELECT district_name, year, population
	FROM city_population
) AS a
PIVOT
(
	SUM(population)
	FOR district_name in ([Bektemir],[Chilonzor],[Yakkasaroy])
) AS Population_Each_City

-- 19. Using Invoices table, show top 3 customers with the highest total invoice amount. Return CustomerID and Totalspent.
SELECT TOP (3) CustomerID, TotalAmount
FROM Invoices
ORDER BY TotalAmount DESC;

-- 20. Transform Population_Each_Year table to its original format (City_Population).
SELECT district_id, district_name, year, population FROM
(
    SELECT district_id, district_name, [2012], [2013]
    FROM Population_Each_Year
) AS a
UNPIVOT
(
    population FOR year IN ([2012], [2013])
) AS City_Population;

-- 21. Using Products and Sales tables, list product names and the number of times each has been sold. (Research for Joins)
SELECT ProductName, COUNT(p.ProductID) as CntProductsSold
FROM Products as p
JOIN Sales as s
ON p.ProductID = s.ProductID
GROUP BY ProductName;

-- 22. Transform Population_Each_City table to its original format (City_Population).
SELECT year, district_name, population 
FROM
(
    SELECT year, [Bektemir], [Chilonzor], [Yakkasaroy]
    FROM Population_Each_City
) AS a
UNPIVOT
(
    population FOR district_name IN ([Bektemir],[Chilonzor],[Yakkasaroy])
) AS City_Population;
