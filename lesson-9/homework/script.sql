-- 1. Using Products, Suppliers table List all combinations of product names and supplier names.
SELECT * 
FROM Products
CROSS JOIN Suppliers;

-- 2. Using Departments, Employees table Get all combinations of departments and employees.
SELECT *
FROM Departments
CROSS JOIN Employees;

-- 3. Using Products, Suppliers table List only the combinations where the supplier actually supplies the product. Return supplier name and product name
SELECT s.SupplierName, p.ProductName
FROM Products as p
JOIN Suppliers as s
ON p.SupplierID = s.SupplierID;

-- 4. Using Orders, Customers table List customer names and their orders ID.
SELECT c.FirstName, c.LastName, o.OrderID
FROM Orders as o
JOIN Customers as c
ON o.CustomerID = c.CustomerID;

-- 5. Using Courses, Students table Get all combinations of students and courses.
SELECT *
FROM Courses
CROSS JOIN Students;

-- 6. Using Products, Orders table Get product names and orders where product IDs match.
SELECT p.ProductName, o.*
FROM Products as p
JOIN Orders as o
ON p.ProductID = o.ProductID;

-- 7. Using Departments, Employees table List employees whose DepartmentID matches the department.
SELECT e.*
FROM Departments as d
JOIN Employees as e
ON d.DepartmentID = e.DepartmentID;

-- 8. Using Students, Enrollments table List student names and their enrolled course IDs.
SELECT s.Name, e.EnrollmentID
FROM Students as s
JOIN Enrollments as e
ON s.StudentID = e.StudentID;

-- 9. Using Payments, Orders table List all orders that have matching payments.
SELECT o.*
FROM Payments as p
JOIN Orders as o
ON p.OrderID = o.OrderID;

-- 10. Using Orders, Products table Show orders where product price is more than 100.
SELECT o.*
FROM Orders as o
JOIN Products as p
ON o.ProductID = p.ProductID
WHERE p.Price > 100;

-- 11. Using Employees, Departments table List employee names and department names where department IDs are not equal. It means: Show all mismatched employee-department combinations.
SELECT e.Name, d.DepartmentName
FROM Employees as e
CROSS JOIN Departments as d
WHERE e.DepartmentID <> d.DepartmentID;

-- 12. Using Orders, Products table Show orders where ordered quantity is greater than stock quantity.
SELECT *
FROM Orders as o
JOIN Products as p
ON o.ProductID = p.ProductID
WHERE o.Quantity > p.StockQuantity;

-- 13. Using Customers, Sales table List customer names and product IDs where sale amount is 500 or more.
SELECT c.FirstName, c.LastName, s.ProductID
FROM Customers as c
JOIN Sales as s
ON c.CustomerID = s.CustomerID
WHERE s.SaleAmount >= 500;

-- 14. Using Courses, Enrollments, Students table List student names and course names they’re enrolled in.
SELECT s.Name, c.CourseName
FROM Courses as c
JOIN Enrollments as e
ON c.CourseID = e.CourseID
JOIN Students as s
ON e.StudentID = s.StudentID;

-- 15. Using Products, Suppliers table List product and supplier names where supplier name contains “Tech”.
SELECT p.ProductName, s.SupplierName
FROM Products as p
JOIN Suppliers as s
ON p.SupplierID = s.SupplierID
WHERE s.SupplierName LIKE '%Tech%';

-- 16. Using Orders, Payments table Show orders where payment amount is less than total amount.
SELECT o.*
FROM Orders as o
JOIN Payments as p
ON o.OrderID = p.OrderID
WHERE p.Amount < o.TotalAmount;

-- 17. Using Employees and Departments tables, get the Department Name for each employee.
SELECT e.Name, d.DepartmentName
FROM Employees as e
JOIN Departments as d
ON e.DepartmentID = d.DepartmentID;

-- 18. Using Products, Categories table Show products where category is either 'Electronics' or 'Furniture'.
SELECT p.* 
FROM Products as p
JOIN Categories as c
ON p.Category = c.CategoryID
WHERE c.CategoryName = 'Electronics' OR c.CategoryName = 'Furniture';

-- 19. Using Sales, Customers table Show all sales from customers who are from 'USA'.
SELECT s.*
FROM Sales as s
JOIN Customers as c
ON s.CustomerID = c.CustomerID
WHERE c.Country = 'USA';

-- 20. Using Orders, Customers table List orders made by customers from 'Germany' and order total > 100.
SELECT o.*
FROM Orders as o
JOIN Customers as c
ON o.CustomerID = c.CustomerID
WHERE c.Country = 'Germany' AND o.TotalAmount > 100;

-- 21. Using Employees table List all pairs of employees from different departments.
SELECT *
FROM Employees as a
JOIN Employees as b
ON a.DepartmentID <> b.DepartmentID AND a.EmployeeID < b.EmployeeID;

-- 22. Using Payments, Orders, Products table List payment details where the paid amount is not equal to (Quantity × Product Price).
SELECT pa.*
FROM Payments as pa
JOIN Orders as o
ON pa.OrderID = o.OrderID
JOIN Products as pr
ON o.ProductID = pr.ProductID
WHERE pa.Amount <> o.Quantity * pr.Price;

-- 23. Using Students, Enrollments, Courses table Find students who are not enrolled in any course.
SELECT *
FROM Students
EXCEPT
SELECT s.*
FROM Students as s
JOIN Enrollments as e
ON s.StudentID = e.StudentID

-- 24. Using Employees table List employees who are managers of someone, but their salary is less than or equal to the person they manage.
SELECT distinct b.*
FROM Employees as a
JOIN Employees as b
ON a.ManagerID = b.EmployeeID
WHERE b.Salary <= a.Salary
order by b.EmployeeID

-- 25. Using Orders, Payments, Customers table List customers who have made an order, but no payment has been recorded for it.
SELECT c.*
FROM Customers as c
JOIN Orders as o
ON c.CustomerID = o.CustomerID
EXCEPT
SELECT c.*
FROM Orders as o
JOIN Payments as p
ON o.OrderID = p.OrderID
JOIN Customers as c
ON o.CustomerID = c.CustomerID
