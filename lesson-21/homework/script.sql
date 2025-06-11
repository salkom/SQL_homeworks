
-- 1. Write a query to assign a row number to each sale based on the SaleDate.
select *, ROW_NUMBER() over (order by SaleDate) as RN
from ProductSales

-- 2. Write a query to rank products based on the total quantity sold. give the same rank for the same amounts without skipping numbers.
;with cte as (
	select ProductName, sum(Quantity) as TotalQuantity, sum(SaleAmount) as TotalAmount
	from ProductSales
	group by ProductName
)
select *,
	DENSE_RANK() over (order by TotalQuantity desc) as Rank
from cte

-- 3. Write a query to identify the top sale for each customer based on the SaleAmount.
;with cte as (
	select *,
		RANK() over (partition by CustomerID order by SaleAmount desc) as Rank
	from ProductSales
)
select * from cte where Rank = 1

-- 4. Write a query to display each sale's amount along with the next sale amount in the order of SaleDate.

select SaleID, SaleDate, SaleAmount,
	LEAD(SaleAmount) over (order by SaleDate) as NextSale
from ProductSales

-- 5. Write a query to display each sale's amount along with the previous sale amount in the order of SaleDate.
select SaleID, SaleDate, SaleAmount,
	LAG(SaleAmount) over (order by SaleDate) as PrevSale
from ProductSales

-- 6. Write a query to identify sales amounts that are greater than the previous sale's amount
;with cte as (
	select SaleID, SaleDate, SaleAmount,
		LAG(SaleAmount) over (order by SaleDate) as PrevSale
	from ProductSales
)
select * from cte where SaleAmount > PrevSale

-- 7. Write a query to calculate the difference in sale amount from the previous sale for every product
select SaleID, ProductName, SaleDate, 
	SaleAmount - LAG(SaleAmount) over (partition by ProductName order by SaleDate) as SaleDif
from ProductSales

-- 8. Write a query to compare the current sale amount with the next sale amount in terms of percentage change.
select SaleID, ProductName, SaleDate, 
	SaleAmount,
	LEAD(SaleAmount) over (order by SaleDate) as NextSale,
	cast(100 * (LEAD(SaleAmount) over (order by SaleDate) / SaleAmount - 1) as decimal (10, 1)) as [PercChange (%)]
from ProductSales

-- 9. Write a query to calculate the ratio of the current sale amount to the previous sale amount within the same product.
select SaleID, ProductName, SaleDate, 
	SaleAmount,
	LAG(SaleAmount) over (partition by ProductName order by SaleDate) as PrevSale,
	cast(SaleAmount / LAG(SaleAmount) over (partition by ProductName order by SaleDate) as decimal (10, 3)) as Ratio
from ProductSales

-- 10. Write a query to calculate the difference in sale amount from the very first sale of that product.
select SaleID, ProductName, SaleDate, SaleAmount,
	FIRST_VALUE(SaleAmount) over (partition by ProductName order by SaleDate) as FirstSale,
	SaleAmount - FIRST_VALUE(SaleAmount) over (partition by ProductName order by SaleDate) as SaleDif
from ProductSales

-- 11. Write a query to find sales that have been increasing continuously for a product (i.e., each sale amount is greater than the previous sale amount for that product).
;with cte as (
	select SaleID, ProductName, SaleDate, SaleAmount,
		LAG(SaleAmount) over (partition by ProductName order by SaleDate) as PrevSale
	from ProductSales
)
select * from cte where SaleAmount > PrevSale

-- 12. Write a query to calculate a "closing balance"(running total) for sales amounts which adds the current sale amount to a running total of previous sales.
select *,
	sum(SaleAmount) over (order by SaleDate rows between unbounded preceding and current row) as RunningTotalSaleAmount
from ProductSales

-- 13. Write a query to calculate the moving average of sales amounts over the last 3 sales.
select *,
	cast(avg(SaleAmount) over (order by SaleDate rows between 2 preceding and current row) as decimal(10,2)) as MovingAverageSaleAmount
from ProductSales

-- 14. Write a query to show the difference between each sale amount and the average sale amount.
select *,
	cast(SaleAmount - avg(SaleAmount) over (order by SaleDate rows between unbounded preceding and unbounded following) as decimal(10,2)) as SaleDif
from ProductSales

-- 15. Find Employees Who Have the Same Salary Rank
;with cte as (
	select *,
		rank() over (order by Salary desc) as SalaryRank
	from Employees1
),
cte1 as (
	select *,
		lag(SalaryRank) over (order by SalaryRank) as PrevSalaryRank
	from cte
)
select * from cte1 where SalaryRank = PrevSalaryRank

-- 16. Identify the Top 2 Highest Salaries in Each Department
;with cte as (
	select *,
		rank() over (partition by Department order by Salary desc) as SalaryRank
	from Employees1
)
select * from cte where SalaryRank <= 2

-- 17. Find the Lowest-Paid Employee in Each Department
;with cte as (
	select *,
		rank() over (partition by Department order by Salary asc) as SalaryRank
	from Employees1
)
select * from cte where SalaryRank = 1

-- 18. Calculate the Running Total of Salaries in Each Department
select *,
	sum(Salary) over (partition by Department order by EmployeeID rows between unbounded preceding and current row) as SalaryRank
from Employees1

-- 19. Find the Total Salary of Each Department Without GROUP BY
;with cte as (	
	select *,
		sum(Salary) over (partition by Department order by EmployeeID rows between unbounded preceding and unbounded following) as TotalSalary
	from Employees1
)
select distinct Department, TotalSalary 
from cte

-- 20. Calculate the Average Salary in Each Department Without GROUP BY
;with cte as (	
	select *,
		avg(Salary) over (partition by Department order by EmployeeID rows between unbounded preceding and unbounded following) as AverageSalary
	from Employees1
)
select distinct Department, AverageSalary 
from cte

-- 21. Find the Difference Between an Employee’s Salary and Their Department’s Average
select *,
	salary - avg(Salary) over (partition by Department order by EmployeeID rows between unbounded preceding and unbounded following) as SalaryDif
from Employees1

-- 22. Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
select *,
	avg(Salary) over (order by EmployeeID rows between 1 preceding and 1 following) as MovingAvgSalary
from Employees1

-- 23. Find the Sum of Salaries for the Last 3 Hired Employees
;with cte as (
	select *,
		rank() over (order by HireDate desc) as HireDateRank
	from Employees1
)
select sum(Salary) as SalarySum from cte where HireDateRank <= 3

