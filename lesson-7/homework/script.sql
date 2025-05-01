-- 1. Write a query to find the minimum (MIN) price of a product in the Products table.
SELECT MIN(Price) AS MinPrice
FROM Products;

-- 2. Write a query to find the maximum (MAX) Salary from the Employees table.
SELECT MAX(Salary) AS MaxSalary
FROM Employees;

-- 3. Write a query to count the number of rows in the Customers table using COUNT(*).
SELECT COUNT(*) [NumberOfRows]
FROM Customers;

-- 4. Write a query to count the number of unique product categories (COUNT(DISTINCT Category)) from the Products table.
SELECT COUNT(DISTINCT Category) AS NumberOfUniqueProducts
FROM Products;

-- 5. Write a query to find the total (SUM) sales amount for the product with id 7 in the Sales table.
SELECT SUM(SaleAmount) AS TotalSales
FROM Sales
WHERE ProductID = 7;

-- 6. Write a query to calculate the average (AVG) age of employees in the Employees table.
SELECT AVG(Age) AS AverageAge
FROM Employees;

-- 7. Write a query that uses GROUP BY to count the number of employees in each department.
SELECT DepartmentName, COUNT(*) AS NumberOfEmployees
FROM Employees
GROUP BY DepartmentName;

-- 8. Write a query to show the minimum and maximum Price of products grouped by Category. Use products table.
SELECT Category, MIN(Price) AS [Min_price], MAX(Price) AS [Max_price]
FROM Products
GROUP BY Category;

-- 9. Write a query to calculate the total (SUM) sales per Customer in the Sales table.
SELECT CustomerID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID;

-- 10. Write a query to use HAVING to filter departments having more than 5 employees from the Employees table.(DeptID is enough, if you don't have DeptName).
SELECT DepartmentName, COUNT(EmployeeID) AS NumberOfEmployees
FROM Employees
GROUP BY DepartmentName
HAVING COUNT(EmployeeID) > 5;

-- 11. Write a query to calculate the total sales and average sales for each product category from the Sales table.
SELECT ProductID, SUM(SaleAmount) as TotalSales, AVG(SaleAmount) AS AvgSales
FROM Sales
GROUP BY ProductID;

-- 12. Write a query that uses COUNT(columnname) to count the number of employees from the Department HR.
SELECT COUNT(EmployeeID) AS NumberOfEmployees
FROM Employees
WHERE DepartmentName = 'HR';

-- 13. Write a query that finds the highest (MAX) and lowest (MIN) Salary by department in the Employees table.(DeptID is enough, if you don't have DeptName).
SELECT DepartmentName, MAX(Salary) AS HighestSalary, MIN(Salary) AS LowestSalary
FROM Employees
GROUP BY DepartmentName;

-- 14. Write a query that uses GROUP BY to calculate the average salary per Department.(DeptID is enough, if you don't have DeptName).
SELECT AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentName;

-- 15. Write a query to show the AVG salary and COUNT(*) of employees working in each department.(DeptID is enough, if you don't have DeptName).
SELECT DepartmentName, AVG(Salary) AS AvgSalary, COUNT(EmployeeID) AS NumberOfEmployees
FROM Employees
GROUP BY DepartmentName;

-- 16. Write a query that uses HAVING to filter product categories with an average price greater than 400.
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 400;

-- 17. Write a query that calculates the total sales for each year in the Sales table, and use GROUP BY to group them.
SELECT YEAR(SaleDate) AS Year, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY YEAR(SaleDate);

-- 18. Write a query that uses COUNT to show the number of customers who placed at least 3 orders.
SELECT CustomerID, COUNT(CustomerID) AS NumberOfCustomers
FROM Orders
GROUP BY CustomerID
HAVING COUNT(CustomerID) >= 3;

-- 19. Write a query that applies the HAVING clause to filter out Departments with total salary expenses greater than 500,000.(DeptID is enough, if you don't have DeptName).
SELECT DepartmentName, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentName
HAVING SUM(Salary) > 500000;

-- 20. Write a query that shows the average (AVG) sales for each product category, and then uses HAVING to filter categories with an average sales amount greater than 200.
SELECT ProductID, AVG(SaleAmount) AS AvgSales
FROM Sales
GROUP BY ProductID
HAVING AVG(SaleAmount) > 200;

-- 21. Write a query to calculate the total (SUM) sales for each Customer, then filter the results using HAVING to include only Customers with total sales over 1500.
SELECT CustomerID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID
HAVING SUM(SaleAmount) > 1500;

-- 22. Write a query to find the total (SUM) and average (AVG) salary of employees grouped by department, and use HAVING to include only departments with an average salary greater than 65000.
SELECT DepartmentName, SUM(Salary) AS TotalSalary, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 65000;

-- 23. Write a query that finds the maximum (MAX) and minimum (MIN) order value for each customer, and then applies HAVING to exclude customers with an order value less than 50.
SELECT CustomerID, MAX(TotalAmount) AS MaxValue, MIN(TotalAmount) AS MinValue
FROM Orders
GROUP BY CustomerID
Having MIN(TotalAmount) >=50;

-- 24. Write a query that calculates the total sales (SUM) and counts distinct products sold in each month, and then applies HAVING to filter the months with more than 8 products sold.
SELECT MONTH(SaleDate) AS Month, SUM(SaleAmount) AS TotalSales, COUNT(DISTINCT ProductID) AS DistinctProductsNumber
FROM Sales
GROUP BY MONTH(SaleDate)
HAVING COUNT(DISTINCT ProductID) > 8;

-- 25. Write a query to find the MIN and MAX order quantity per Year. From orders table. (Do some research) 
SELECT YEAR(OrderDate) AS Year, MIN(Quantity) AS MinQuantity, MAX(Quantity) AS MaxQuantity
FROM Orders
GROUP BY YEAR(OrderDate);
