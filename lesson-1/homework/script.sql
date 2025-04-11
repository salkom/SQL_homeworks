1. Define the following terms: data, database, relational database, and table.

Data is a piece or collection of facts, information, or values, be it text, numbers, dates, images, and so on. 
A database is an organized collection of data that is stored and managed so that it can be easily accessed, retreived, and updated. 
A relational database is a database that stores data in tables and uses relationships between them. 
A table is a structured format to store data in rows and columns. 

2. List five key features of SQL Server.

- Relational database engine
- High availability and disaster recovery
- Scalability and performance
- Cloud integration
- Business Intelligence (BI) integration

3. What are the different authentication modes available when connecting to SQL Server? (Give at least 2)

- Windows authentication
- SQL Server authentication
- Microsoft Entra MFA
- Microsoft Entra Password
- Microsoft Entra Integrated

4. Create a new database in SSMS named SchoolDB.

CREATE DATABASE SchoolDB

5. Write and execute a query to create a table called Students with columns: StudentID (INT, PRIMARY KEY), Name (VARCHAR(50)), Age (INT).

CREATE TABLE Students (StudentID INT PRIMARY KEY, Name VARCHAR(50), Age INT);

6. Describe the differences between SQL Server, SSMS, and SQL.

SQL Server is a relational database management studio created by Microsoft. It is a software that is used to store and manage databases.
SSMS is an app, particularly graphical user interface tool which is developer by Microsoft for managing SQL Server. It allows to interact
with SQL Server databases using a visual interface rather than writing SQL commands. 
SQL is a programming language used to manage and trasforming relational databases. It is used to query, update, and manage data in a
relational database. 

7. Research and explain the different SQL commands: DQL, DML, DDL, DCL, TCL with examples.
DQL – Data Query Language, used to query data from a database. Command: SELECT
Example: 
SELECT FirstName, LastName FROM Customers WHERE City = 'Tashkent';

DML - Data Manipulation Language, used to modify or manipulate data in existing tables. Commands: INSERT, UPDATE, DELETE
Examples:
-- Insert new data
INSERT INTO Customers (FirstName, LastName, City) VALUES ('Alice', 'Smith', 'Tashkent');
-- Update existing data
UPDATE Customers SET City = 'Samarkand' WHERE CustomerID = 1;
-- Delete data
DELETE FROM Customers WHERE CustomerID = 2;

DDL - Data Definition Language, used to define and manage database structures (like tables, schemas). Commands: CREATE, ALTER, DROP, TRUNCATE
Examples:
-- Create a new table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);
-- Alter a table (add a column)
ALTER TABLE Products ADD Stock INT;
-- Drop a table
DROP TABLE Products;
-- Delete all rows (but keep the structure)
TRUNCATE TABLE Products;

DCL – Data Control Language, used to control acces and permissions to the database. Commands: GRANT, REVOKE
Examples:
-- Give SELECT permission to a user
GRANT SELECT ON Customers TO user1;
-- Remove SELECT permission from a user
REVOKE SELECT ON Customers FROM user1;	

TCL – Transaction Control Language, used to manage transactions in SQL (groups of operations treated as a single unit).Commands: BEGIN, COMMIT, ROLLBACK, SAVEPOINT
Examples:
BEGIN TRANSACTION;
UPDATE Accounts SET Balance = Balance - 100 WHERE AccountID = 1;
UPDATE Accounts SET Balance = Balance + 100 WHERE AccountID = 2;
-- Save changes permanently
COMMIT;
-- Or, if something goes wrong:
-- ROLLBACK;

8. Write a query to insert three records into the Students table.

INSERT INTO [dbo].[Students] VALUES (1, 'Jon Snow', 25), (2, 'Arya Stark', 12), (3, 'Tirion Lannister', 30);

9. Create a backup of your SchoolDB database and restore it. (write its steps to submit)
To create a backup:
- In the Object Explorer panel, right-click on the database name (SchoolDB)
- Go to Task, then Back up...
- Once Back Up Database dialog opens,  click OK button. 

To restore a backed up database:
- In Object Explorer, right-click on Databases and select Restore Database…
- In the Restore Database window, select Device
- Click the ... button next to it
- In the Select backup devices window, choose File and click Add.
- Browse and select your .bak file.
- Click OK.
