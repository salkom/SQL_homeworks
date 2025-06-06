-- Easy tasks

-- 1. Create a numbers table using a recursive query from 1 to 1000.

WITH Numbers AS (
    SELECT 1 AS num
    UNION ALL
    SELECT num + 1
    FROM Numbers
    WHERE num < 1000
)
SELECT * FROM Numbers
OPTION (MAXRECURSION 1000);

-- 2. Write a query to find the total sales per employee using a derived table.(Sales, Employees)

;with EmployeeSalesTotals as (
	select EmployeeID, sum(SalesAmount) as TotalSales
	from Sales
	group by EmployeeID )
select e.EmployeeID, e.FirstName, e.LastName, cte.TotalSales
from EmployeeSalesTotals as cte
join Employees as e
on cte.EmployeeID = e.EmployeeID;


-- 3. Create a CTE to find the average salary of employees.(Employees)
;with AvgSalary as (select AVG(Salary) as AvgSal from Employees) 
select * from AvgSalary;

-- 4. Write a query using a derived table to find the highest sales for each product.(Sales, Products)

;with ProductsHighestSales as (
	select ProductID, max(SalesAmount) as MaxSale
	from Sales
	group by ProductID
)
select p.ProductID, p.ProductName, cte.MaxSale
from ProductsHighestSales as cte
join Products as p
on cte.ProductID = p.ProductID;


-- 5. Beginning at 1, write a statement to double the number for each record, the max value you get should be less than 1000000.
;with r_cte as (
	select 1 as num
	union all
	select num * 2
	from r_cte
	where num * 2 < 1000000
)
select * from r_cte
option (maxrecursion 100);


-- 6. Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)
select * from sales
select * from Employees

;with EmpWithMoreFiveSales as (
	select EmployeeID, count(SalesID) as SalesCount
	from Sales
	group by EmployeeID
	having count(SalesID) > 5
)
select e.EmployeeID, e.FirstName, e.LastName, cte.SalesCount
from Employees as e
join EmpWithMoreFiveSales as cte
on e.EmployeeID = cte.EmployeeID;


-- 7. Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)

;with TotalSalesByProduct as (
	select ProductID, sum(SalesAmount) as TotalSales
	from Sales
	group by ProductID
	having sum(SalesAmount) > 500
)
select p.ProductID, p.ProductName, cte.TotalSales
from Products as p
join TotalSalesByProduct as cte
on p.ProductID = cte.ProductID;

-- 8. Create a CTE to find employees with salaries above the average salary.(Employees)

;with EmpAboveAvgSalary as (
	select *
	from Employees
	where Salary > (
		select avg(Salary) from Employees
	)
)
select * from EmpAboveAvgSalary;

-- Medium Tasks

-- 1. Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)

;with OrdersByEmployees as (
	select EmployeeID, count(SalesID) as SalesCount
	from Sales
	group by EmployeeID
)
select top (5) *
from Employees as e
join OrdersByEmployees as o
on e.EmployeeID = o.EmployeeID
order by SalesCount DESC


-- 2. Write a query using a derived table to find the sales per product category.(Sales, Products)

;with JoinedSales as (
	select p.CategoryID, s.SalesAmount
	from Sales as s
	join Products as p
	on s.ProductID = p.ProductID
)
select CategoryID, sum(SalesAmount) as TotalSales
from JoinedSales
group by CategoryID

-- 3. Write a script to return the factorial of each value next to it.(Numbers1)

;with r_fact as (
	select Number, 1 as Factorial, 1 as Incr
	from Numbers1
	union all
	select Number, Factorial * (Incr + 1) as Factorial, Incr + 1 as Incr
	from r_fact
	where Incr < Number
)
select Number, Factorial
from r_fact as r
where Number = Incr;


-- 4. This script uses recursion to split a string into rows of substrings for each character in the string.(Example)

;with r_SplitString as (
	select String, left(String, 1) as Charact, 1 as i
	from Example
	union all 
	select String, SUBSTRING(String, i + 1, 1) as Charact, i + 1 as i
	from r_SplitString
	where i < len(String)
)
select String, Charact
from r_SplitString
order by String, i

-- 5. Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)

;with SalesByMonth as (
	select FORMAT(SaleDate, 'yyyy-MM') as Month, sum(SalesAmount) as MonthlySales
	from Sales
	group by FORMAT(SaleDate, 'yyyy-MM')
),
MonthWithPrevious as (
	select 
		curr.Month AS CurrentMonth,
        curr.MonthlySales AS CurrentSales,
        prev.Month AS PreviousMonth,
        prev.MonthlySales AS PreviousSales,
        curr.MonthlySales - prev.MonthlySales AS SalesDifference
	from SalesByMonth as curr
	join SalesByMonth as prev
	on prev.Month = (
		select max(Month)
		from SalesByMonth
		where Month < curr.Month
	)
)
select * from MonthWithPrevious;

-- 6. Create a derived table to find employees with sales over $45000 in each quarter.(Sales, Employees)

;with SalesByQuarter as (
select
	EmployeeID,
	datepart(quarter, SaleDate) as Quarter,
	sum(SalesAmount) as QuarterSales
from Sales
group by
	EmployeeID,
	datepart(quarter, SaleDate)
),
EmpQuarterSales as (
select e.EmployeeID, e.FirstName, e.LastName, s.QuarterSales, s.Quarter
from SalesByQuarter as s
join Employees as e
on s.EmployeeID = e.EmployeeID
)
select EmployeeID, FirstName, LastName
from EmpQuarterSales
group by EmployeeID, FirstName, LastName
having count(*) = count(case when QuarterSales > 4500 then 1 end);


-- Difficult Tasks

-- 1. This script uses recursion to calculate Fibonacci numbers

;with r_fib as (
	select 0 as num, 1 as helper_num
	union all
	select num + helper_num as num, num as helper_num
	from r_fib
	where num < 100
)
select num from r_fib

-- 2. Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)

select *
from FindSameCharacters
where len(Vals) > 1
	and Vals = REPLICATE(left(Vals, 1), len(Vals))


-- 3. Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.(Example:n=5 | 1, 12, 123, 1234, 12345)

;with r_cte as (
	select 1 as val, 2 as i
	union all
	select val * 10 + i as val, i + 1 as i
	from r_cte
	where i <= 5
)
select val from r_cte

-- 4. Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales)

;with SalesLastSixMonthsByEmp as (
	select EmployeeID, sum(SalesAmount) as SalesAmount
	from Sales
	where SaleDate between DATEADD(MONTH, -6, GETDATE()) and GETDATE()
	group by EmployeeID
)
select top (3) e.EmployeeID, e.FirstName, e.LastName, s.SalesAmount
from SalesLastSixMonthsByEmp as s
join Employees as e
on s.EmployeeID = e.EmployeeID
order by SalesAmount desc

-- 5. Write a T-SQL query to remove the duplicate integer values present in the string column. Additionally, remove the single integer character that appears in the string.(RemoveDuplicateIntsFromNames)
select * from RemoveDuplicateIntsFromNames

;WITH Extracted AS (
    SELECT 
        PawanName,
        Prefix = LEFT(Pawan_slug_name, CHARINDEX('-', Pawan_slug_name) - 1),
        Suffix = RIGHT(Pawan_slug_name, LEN(Pawan_slug_name) - CHARINDEX('-', Pawan_slug_name))
    FROM RemoveDuplicateIntsFromNames
),
DigitsExpanded AS (
    SELECT 
        e.PawanName,
        e.Prefix,
        e.Suffix,
        Digit = SUBSTRING(e.Suffix, v.Number, 1)
    FROM Extracted e
    JOIN master.dbo.spt_values v 
        ON v.Type = 'P' AND v.Number BETWEEN 1 AND 100
        AND v.Number <= LEN(e.Suffix)
),
DigitCounts AS (
    SELECT 
        PawanName,
        Digit,
        Cnt = COUNT(*)
    FROM DigitsExpanded
    GROUP BY PawanName, Digit
),
HasDuplicates AS (
    SELECT DISTINCT PawanName
    FROM DigitCounts
    WHERE Cnt > 1
),
Filtered AS (
    SELECT 
        e.PawanName,
        New_slug_name = 
            CASE 
                WHEN LEN(e.Suffix) = 1 THEN e.Prefix
                ELSE e.Prefix + '-' + e.Suffix
            END
    FROM Extracted e
    LEFT JOIN HasDuplicates d ON e.PawanName = d.PawanName
    WHERE d.PawanName IS NULL AND LEN(e.Suffix) > 1
)
SELECT * FROM Filtered;

