--1 Define and explain the purpose of BULK INSERT in SQL Server.
BULK INSERT is a SQL Server command used to import large volumes of data from a file (like .csv or .txt) directly into a table. Its purpose is to efficiently load external data into a SQL Server table, especially useful for big datasets or ETL operations.

--2 List four file formats that can be imported into SQL Server.
.csv, .txt, .xml, .json

--3 Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).
CREATE TABLE Products (
	ProductID INT PRIMARY KEY,
	ProductName VARCHAR(50),
	Price DECIMAL(10,2)
);

--4 Insert three records into the Products table using INSERT INTO.
INSERT INTO Products VALUES
(1, 'Samsung Galaxy S25', 800),
(2, 'iPhone 16 Pro', 1200),
(3, 'Xiaomi 14', 850)

--5 Explain the difference between NULL and NOT NULL with examples.
NULL means no value or unknown. NOT NULL means the column must have a value (it cannot be left empty).
Examples:
Column with NULL allowed:
CREATE TABLE Employees (
    ID INT,
    MiddleName VARCHAR(50) NULL
);
You can insert:
INSERT INTO Employees (ID, MiddleName) VALUES (1, NULL);

Column with NOT NULL constraint:
CREATE TABLE Employees (
    ID INT,
    FirstName VARCHAR(50) NOT NULL
);
You cannot insert:
INSERT INTO Employees (ID, FirstName) VALUES (2, NULL);  -- Error!

--6 Add a UNIQUE constraint to the ProductName column in the Products table.
ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName)

--7 Write a comment in a SQL query explaining its purpose.
-- This query creates a table with columns: ID, FirstName
CREATE TABLE Employees (
    ID INT,
    FirstName VARCHAR(50)
);

--8 Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.
CREATE TABLE Categories (
	CategoryID INT PRIMARY KEY,
	CategoryName VARCHAR(50) UNIQUE
);

-9 Explain the purpose of the IDENTITY command in SQL Server.
The IDENTITY command is used to automatically generate unique numeric values for each row in a table.

--10 Use BULK INSERT to import data from a text file into the Products table.
BULK INSERT Products
FROM 'C:\Users\user\Downloads\My_file.txt'
WITH (
FIRSTROW=2, 
FIELDTERMINATOR=',', 
ROWTERMINATOR='\n'
);

--11 Create a FOREIGN KEY in the Products table that references the Categories table.
ALTER TABLE Products
ADD CategoryID INT;

ALTER TABLE Products
ADD FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)

--12 Explain the differences between PRIMARY KEY and UNIQUE KEY with examples.
Both PRIMARY KEY and UNIQUE KEY ensure all values are unique. However, in PRIMARY KEY, NULLs are not allowed while UNIQUE KEY may have. Moreover, a table might have only one PRIMARY KEY while there might be multiple UNIQUE KEYs. 
Example for PRIMARY KEY:
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100)
);
EmployeeID must be unique and not NULL.

Example for UNIQUE KEY:
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Email VARCHAR(100) UNIQUE,
    Name VARCHAR(50) UNIQUE
);
Multiple columns like Email and Name can be UNIQUE KEY as well as they can be NULL (only once).

--13 Add a CHECK constraint to the Products table ensuring Price > 0.
ALTER TABLE Products
ADD CONSTRAINT CK_Products_Price CHECK (Price > 0)

--14 Modify the Products table to add a column Stock (INT, NOT NULL).
ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;

--15 Use the ISNULL function to replace NULL values in a column with a default value.
SELECT *, ISNULL(ProductName, 'No Name') AS ProductNameWithDefault
FROM Products

--16 Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.
A foreign key is a rule in SQL Server that links one table to another. It makes sure that the value in a column matches a value in another table’s column.

--17 Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.
CREATE TABLE Customers (
	Age INT CHECK (Age >= 18)
);

--18 Create a table with an IDENTITY column starting at 100 and incrementing by 10.
CREATE TABLE Products (
	ID INT IDENTITY(100, 10)
);

--19 Write a query to create a composite PRIMARY KEY in a new table OrderDetails.
CREATE TABLE OrderDetails (
	OrderID INT, 
	ProductID INT,
	PRIMARY KEY (OrderID, ProductID)
);

--20 Explain with examples the use of COALESCE and ISNULL functions for handling NULL values.
COALESCE returns the first non-NULL value from a list of expressions.
Example:
SELECT COALESCE (Name, Category, 'N/A') as ProductName
FROM Products;

ISNULL checks a single expression and replaces NULL with a specified replacement value.
Example:
SELECT ISNULL(Name, ‘No name') AS Name
FROM Poducts;

--21 Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.
CREATE TABLE Employees (
	EmpID INT PRIMARY KEY,
	Email VARCHAR(100) UNIQUE
);

--22 Write a query to create a FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE options.
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
