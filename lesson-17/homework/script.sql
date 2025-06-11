-- 1. You must provide a report of all distributors and their sales by region. 
-- If a distributor did not have any sales for a region, rovide a zero-dollar value for that day. 
-- Assume there is at least one sale for each region

-- SQL Setup:

DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

/*
Input:

|Region       |Distributor    | Sales |
|-------------|---------------|--------
|North        |ACE            |   10  |
|South        |ACE            |   67  |
|East         |ACE            |   54  |
|North        |Direct Parts   |   8   |
|South        |Direct Parts   |   7   |
|West         |Direct Parts   |   12  |
|North        |ACME           |   65  |
|South        |ACME           |   9   |
|East         |ACME           |   1   |
|West         |ACME           |   7   |

Expected Output:

|Region |Distributor   | Sales |
|-------|--------------|-------|
|North  |ACE           | 10    |
|South  |ACE           | 67    |
|East   |ACE           | 54    |
|West   |ACE           | 0     |
|North  |Direct Parts  | 8     |
|South  |Direct Parts  | 7     |
|East   |Direct Parts  | 0     |
|West   |Direct Parts  | 12    |
|North  |ACME          | 65    |
|South  |ACME          | 9     |
|East   |ACME          | 1     |
|West   |ACME          | 7     |
*/

-- Solution

;with cte as (
	select distinct a.Distributor, b.Region
	from #RegionSales as a
	cross join #RegionSales as b
)
select c.Region, c.Distributor, ISNULL(r.Sales, 0) as Sales
from cte as c
left join #RegionSales as r
on c.Distributor = r.Distributor and c.Region = r.Region

-- 2. Find managers with at least five direct reports
-- SQL Setup:

CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

/*
Input:

| id  | name  | department | managerId |
+-----+-------+------------+-----------+
| 101 | John  | A          | null      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |

Expected Output:

+------+
| name |
+------+
| John |
+------+
You cal also solve this puzzle in Leetcode: https://leetcode.com/problems/managers-with-at-least-5-direct-reports/description/?envType=study-plan-v2&envId=top-sql-50
*/

-- Solution:
select * from Employee

;with cte as (
	select managerId, COUNT(managerID) as ReportCount
	from Employee
	group by managerId
	having count(managerId) >= 5
)
select e.name
from Employee as e 
join cte as c
on e.id = c.managerId

-- 3. Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.
-- SQL Setup:

drop table Products
drop table Orders

CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

/*
Input:

| product_id  | product_name          | product_category |
+-------------+-----------------------+------------------+
| 1           | Leetcode Solutions    | Book             |
| 2           | Jewels of Stringology | Book             |
| 3           | HP                    | Laptop           |
| 4           | Lenovo                | Laptop           |
| 5           | Leetcode Kit          | T-shirt          |

Expected Output:

| product_name       | unit  |
+--------------------+-------+
| Leetcode Solutions | 130   |
| Leetcode Kit       | 100   |
*/

-- Solution

select 
	p.product_name,
	sum(o.unit) as Total_sale
from Products as p
join orders as o
on p.product_id = o.product_id
where year(order_date) = 2020 and month(order_date) = 2
group by p.product_name
having sum(o.unit) >= 100


-- 4. Write an SQL statement that returns the vendor from which each customer has placed the most orders
-- SQL Setup:

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

/*
Input:

|Order ID   | Customer ID | Order Count|     Vendor     |
---------------------------------------------------------
|Ord195342  |     1001    |      12    |  Direct Parts  |
|Ord245532  |     1001    |      54    |  Direct Parts  |
|Ord344394  |     1001    |      32    |     ACME       |
|Ord442423  |     2002    |      7     |     ACME       |
|Ord524232  |     2002    |      16    |     ACME       |
|Ord645363  |     2002    |      5     |  Direct Parts  |

Expected Output:

| CustomerID | Vendor       |
|------------|--------------|
| 1001       | Direct Parts |
| 2002       | ACME         |
*/

-- Solution

select o.CustomerID, o.Vendor
from Orders as o
where o.Count = (
	select max(Count)
	from Orders as a
	where o.CustomerID = a.CustomerID
)
order by o.CustomerID


-- 5. You will be given a number as a variable called @Check_Prime check 
-- if this number is prime then return 'This number is prime' else eturn 'This number is not prime'

-- Example Input:

-- DECLARE @Check_Prime INT = 91;

-- Your WHILE-based SQL logic here

-- Expected Output:

-- This number is not prime(or "This number is prime")

-- Solution:

declare @Check_Prime int = 61
declare @i int = 1
declare @count int = 0

while @i <= @Check_Prime
begin
	if @Check_Prime % @i = 0
		set @count += 1
	set @i += 1
end

if @count = 2
	print 'This number is prime'
else
	print 'This number is not prime';
	


-- 6. Write an SQL query to return the number of locations,in which location most signals sent, 
-- and total number of signal for each device from the given table.

-- SQL Setup:
drop table Device

CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

/*
Expected Output:

| Device_id | no_of_location | max_signal_location | no_of_signals |
|-----------|----------------|---------------------|---------------|
| 12        | 2              | Bangalore           | 6             |
| 13        | 2              | Secunderabad        | 5             |
*/

-- Solution:

;with cte as (
	select Device_id, Locations, count(Locations) as Locations_count
	from Device
	group by Device_id, Locations
), cte1 as (
	select Device_id, MAX(Locations_count) as Max_locations_count
	from cte
	group by Device_id
), cte2 as (
	select 
		a.Device_id,
		(select Locations from cte as b where b.Locations_count = a.Max_locations_count) as max_signal_location
	from cte1 as a
), cte3 as (
	select Device_id, count(distinct Locations) as no_of_location, COUNT(Locations) as no_of_signals
	from Device
	group by Device_id
)
select 
	cte2.Device_id,
	cte3.no_of_location,
	cte2.max_signal_location,
	cte3.no_of_signals
from cte2 
join cte3 
on cte2.Device_id = cte3.Device_id


-- 7. Write a SQL to find all Employees who earn more than the average salary in their corresponding department. 
-- Return EmpID, EmpName,Salary in your output

-- SQL Setup:

drop table Employee

CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

/*
Expected Output:

| EmpID | EmpName | Salary |
|-------|---------|--------|
| 1001  | Mark    | 60000  |
| 1004  | Peter   | 35000  |
| 1005  | John    | 55000  |
| 1007  | Donald  | 35000  |
*/

-- Solution:

select a.EmpID, a.EmpName, a.Salary
from Employee as a
where a.Salary > (
	select avg(Salary)
	from Employee as b
	where a.DeptID = b.DeptID
)

-- 8. You are part of an office lottery pool where you keep a table of the winning lottery numbers 
-- along with a table of each ticket’s chosen numbers. If a ticket has some but not all the winning numbers, 
-- you win $10. If a ticket has all the winning numbers, you win $100. Calculate the total winnings for today’s drawing.

-- SQL setup:
CREATE TABLE Tickets (
    TicketID VARCHAR(20),
    Number INT
);

INSERT INTO Tickets (TicketID, Number) VALUES
('A23423', 25),
('A23423', 45),
('A23423', 78),
('B35643', 25),
('B35643', 45),
('B35643', 98),
('C98787', 67),
('C98787', 86),
('C98787', 91);

CREATE TABLE ValidNumbers (
    Number INT
);

INSERT INTO ValidNumbers (Number) VALUES
(25),
(45),
(78);

/*
Winning Numbers:

|Number|
--------
|  25  |
|  45  |
|  78  |

Tickets:

| Ticket ID | Number |
|-----------|--------|
| A23423    | 25     |
| A23423    | 45     |
| A23423    | 78     |
| B35643    | 25     |
| B35643    | 45     |
| B35643    | 98     |
| C98787    | 67     |
| C98787    | 86     |
| C98787    | 91     |

Expected Output would be $110, as you have one winning ticket, and one ticket that has some but not all the winning numbers.
*/

-- Solution:

;with cte as (
	select a.TicketID, a.Number as TicketNum, b.Number as ValidNum
	from Tickets as a
	left join ValidNumbers as b
	on a.Number = b.Number
), cte1 as (
	select TicketID, COUNT(ValidNum) as TicketNumCount
	from cte
	group by TicketID
)
select 
	sum (case when TicketNumCount = 3 then 100
		 when TicketNumCount = 0 then 0
		 else 10
	end) as Prize
from cte1


-- 9. The Spending table keeps the logs of the spendings history of users that make purchases from 
-- an online shopping website which has a desktop and a mobile devices.
-- Write an SQL query to find the total number of users and the total amount spent using mobile only, 
-- desktop only and both mobile and desktop together for each date.

-- SQL Setup:

CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);

/*
Expected Output:

| Row | Spend_date | Platform | Total_Amount | Total_users |
|-----|------------|----------|--------------|-------------|
| 1   | 2019-07-01 | Mobile   | 100          | 1           |
| 2   | 2019-07-01 | Desktop  | 100          | 1           |
| 3   | 2019-07-01 | Both     | 200          | 1           |
| 4   | 2019-07-02 | Mobile   | 100          | 1           |
| 5   | 2019-07-02 | Desktop  | 100          | 1           |
| 6   | 2019-07-02 | Both     | 0            | 0           |
*/

-- Solution:
select * from Spending
--
select Spend_date, count(User_id) as UserCount
from Spending
group by Spend_date
--
select User_id, Spend_date, count(distinct Platform) as PlatformCount
from Spending
group by User_id, Spend_date
-- 
select Spend_date, count(distinct Platform) as PlatformCount
from Spending
group by Spend_date
--
select User_id, Spend_date, Platform, count(User_id)
from Spending
group by User_id, Spend_date, Platform
--

;WITH UserPlatform AS (
    SELECT 
        User_id,
        Spend_date,
        SUM(CASE WHEN Platform = 'Mobile' THEN 1 ELSE 0 END) AS UsedMobile,
        SUM(CASE WHEN Platform = 'Desktop' THEN 1 ELSE 0 END) AS UsedDesktop
    FROM Spending
    GROUP BY User_id, Spend_date
),
UserType AS (
    SELECT 
        up.User_id,
        up.Spend_date,
        CASE 
            WHEN UsedMobile = 1 AND UsedDesktop = 1 THEN 'Both'
            WHEN UsedMobile = 1 THEN 'Mobile'
            WHEN UsedDesktop = 1 THEN 'Desktop'
        END AS PlatformType
    FROM UserPlatform up
),
UserSpendings AS (
    SELECT 
        s.User_id,
        s.Spend_date,
        ut.PlatformType,
        s.Amount
    FROM Spending s
    JOIN UserType ut
      ON s.User_id = ut.User_id AND s.Spend_date = ut.Spend_date
),
FinalAgg AS (
    SELECT 
        Spend_date,
        PlatformType AS Platform,
        SUM(Amount) AS Total_Amount,
        COUNT(DISTINCT User_id) AS Total_Users
    FROM UserSpendings
    GROUP BY Spend_date, PlatformType
)
SELECT d.Spend_date, p.Platform, 
       COALESCE(f.Total_Amount, 0) AS Total_Amount,
       COALESCE(f.Total_Users, 0) AS Total_Users
FROM (SELECT DISTINCT Spend_date FROM Spending) as d
CROSS JOIN (VALUES ('Mobile'), ('Desktop'), ('Both')) as p(Platform)
LEFT JOIN FinalAgg as f
  ON d.Spend_date = f.Spend_date AND p.Platform = f.Platform
ORDER BY d.Spend_date, 
         CASE p.Platform
             WHEN 'Mobile' THEN 1
             WHEN 'Desktop' THEN 2
             WHEN 'Both' THEN 3
         END;


-- 10. Write an SQL Statement to de-group the following data.

/*
Input Table: 'Grouped'

|Product  |Quantity|
--------------------
|Pencil   |   3    |
|Eraser   |   4    |
|Notebook |   2    |
Expected Output:

|Product  |Quantity|
--------------------
|Pencil   |   1    |
|Pencil   |   1    |
|Pencil   |   1    |
|Eraser   |   1    |
|Eraser   |   1    |
|Eraser   |   1    |
|Eraser   |   1    |
|Notebook |   1    |
|Notebook |   1    |

SQL Setup:
*/

DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

-- Solution:

;with rCte as (
	select Product, 1 as n
	from Grouped
	where Quantity > 0

	union all

	select r.Product, n + 1
	from rCte as r
	join Grouped as g on r.Product = g.Product
	where r.n + 1 <= g.Quantity
)
select Product, 1 as Quantity
from rCte
order by Product
