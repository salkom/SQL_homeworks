--1
CREATE TABLE Employees (
	EmpID INT, 
	Name VARCHAR(50),
	Salary DECIMAL(10,2)
);

--2
Single-row insert:
INSERT INTO Employees VALUES
(1, 'Botir', 540.25)
  
Multiple-row insert:
INSERT INTO Employees VALUES
(2, 'Sevara', 625),
(3, 'Anvar', 428.5)

--3
UPDATE Employees
SET Salary = 815.35
WHERE EmpID = 1

--4
DELETE FROM Employees WHERE EmpID = 2;

--5
DELETE command removes rows from a table. For example:
DELETE FROM Employees WHERE EmployeeID = 3;
TRUNCATE command clears up the table removing all the rows and leaving only column names.
TRUNCATE TABLE Employees;
DROP command completely deletes the table. 
DROP TABLE Employees;

--6
ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);

--7
ALTER TABLE Employees
ADD Department VARCHAR(50);

--8
ALTER TABLE Employees
ALTER COLUMN Salary FLOAT;

--9
DepartmentName (VARCHAR(50)).
CREATE TABLE Departments (
	DepartmentID INT PRIMARY KEY,
	DepartmentName VARCHAR(50)
);

--10
TRUNCATE TABLE Employees;

--11
INSERT INTO Departments(DepartmentID, DepartmentName)
SELECT 1, 'Marketing'
UNION ALL
SELECT 2, 'IT'
UNION ALL
SELECT 3, 'Production'
UNION ALL
SELECT 4, 'Finance'
UNION ALL
SELECT 5, 'Operations'

--12
UPDATE Employees
SET Department = 'Marketing'
WHERE Salary > 5000;

--13
TRUNCATE TABLE Employees;

--14
ALTER TABLE Employees
DROP COLUMN Department;

--15
EXEC sp_rename 'Employees', 'StaffMembers';

--16
DROP TABLE Departments;

--17
ProductName (VARCHAR), Category (VARCHAR), Price (DECIMAL)
CREATE TABLE Products (
	ProductID INT PRIMARY KEY,
	ProductName VARCHAR(50),
	Category VARCHAR(50),
	Price Decimal(12, 2),
	Brand VARCHAR(50)
);

--18
ALTER TABLE Products
ADD CONSTRAINT CK_Price CHECK (Price > 0);

--19
ALTER TABLE Products
ADD StockQuantity INT DEFAULT 50;

--20
EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';

--21
INSERT INTO Products VALUES
(1, 'iPhone 16 Pro', 'Smartphone', 1200, 'Apple', 70), 
(2, 'Redmi Buds 6', 'Headphones', 26.50, 'Mi', 120), 
(3, 'Poco F7 Pro', 'Smartphone', 610, 'Mi', 40),
(4, 'AirPods Pro 2', 'Headphones', 250, 'Apple', 200),
(5, 'Galaxy Watch 7', 'Watches', 240, 'Samsung',50);

--22
SELECT *
INTO Products_Backup
FROM Products;

--23
EXEC sp_rename 'Products', 'Inventory';

--24
ALTER TABLE Inventory
DROP CONSTRAINT CK_Price;

ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;

ALTER TABLE Inventory
ADD CONSTRAINT CK_Price CHECK (Price >= 0);

--25
ALTER TABLE Inventory
ADD ProductCode INT IDENTITY(1000, 5);	

