"""
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
SQL is a programming language used to manage and transform relational databases. It is used to query, update, and manage data in a
relational database. 

7. Research and explain the different SQL commands: DQL, DML, DDL, DCL, TCL with examples.


8. Write a query to insert three records into the Students table.

INSERT INTO [dbo].[Students] VALUES (1, 'Jon Snow', 25), (2, 'Arya Stark', 12), (3, 'Tirion Lannister', 30);

9. Create a backup of your SchoolDB database and restore it. (write its steps to submit)

- Right click on the database name (in our case - SchoolDB)
- Go to Task, then Back up...
- Click OK button
- Then click OK on the appeared window
  """


