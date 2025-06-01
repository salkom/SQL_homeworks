-- 1. Write a SQL query to split the Name column by a comma into two separate columns: Name and Surname.(TestMultipleColumns)

select 
	Id,
	LEFT(Name, CHARINDEX(',', Name) - 1) as Name,
	RIGHT(Name, LEN(Name) - CHARINDEX(',', Name)) as Surname
from TestMultipleColumns

-- 2. Write a SQL query to find strings from a table where the string itself contains the % character.(TestPercent)

select *
from TestPercent
where Strs like '%\%%' ESCAPE '\'

-- 3. In this puzzle you will have to split a string based on dot(.).(Splitter)

select 
	Vals,
	value as Parts
from Splitter
cross apply string_split(Vals, '.')


-- 4. Write a SQL query to replace all integers (digits) in the string with 'X'.(1234ABC123456XYZ1234567890ADS)

SELECT TRANSLATE('1234ABC123456XYZ1234567890ADS', '0123456789', 'XXXXXXXXXX') AS Result;


-- 5. Write a SQL query to return all rows where the value in the Vals column contains more than two dots (.).(testDots)

;with cte as (
select
	ID,
	Vals,
	value as Parts
from testDots
cross apply string_split(Vals, '.')
), cte2 as (
select ID, Vals, count(Parts) as CntParts
from cte
group by ID, Vals
) 
select ID, Vals from cte2
where CntParts > 3


-- 6. Write a SQL query to count the spaces present in the string.(CountSpaces)

select *, len(texts) - len(replace(texts, ' ', '')) as NumOfSpaces
from CountSpaces


-- 7. write a SQL query that finds out employees who earn more than their managers.(Employee)

select e.Id, e.Name as EmpName, e.Salary as EmpSalary, m.Name as ManName, m.Salary as ManSalary
from Employee as e
left join Employee as m
on e.ManagerId = m.Id
where e.Salary > m.Salary;


-- 8. Find the employees who have been with the company for more than 10 years, but less than 15 years. 
-- Display their Employee ID, First Name, Last Name, Hire Date, and the Years of Service (calculated as 
-- the number of years between the current date and the hire date).(Employees)

select EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE, DATEDIFF(YEAR, HIRE_DATE, GETDATE()) as YEARS_OF_SERVICE
from Employees
where DATEDIFF(YEAR, HIRE_DATE, GETDATE()) between 10 and 15


-- 9. Write a SQL query to separate the integer values and the character values into two different columns.(rtcfvty34redt)

declare @string varchar(100) = 'rtcfvty34redt'
declare @i int = 1;
declare @len int = len(@string)
declare @char char(1)

declare @letters varchar(100) = ''
declare @digits varchar(100) = ''

while @i <= @len
begin
	set @char = substring(@string, @i, 1)

	if @char like '[0-9]'
		set @digits += @char;
	else if @char like '[A-Za-z]'
		set @letters += @char

	set @i += 1
end

select @letters as Characters, @digits as Integers

-- 10. write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.(weather)

select w1.Id
from weather as w1
join weather as w2
on w1.RecordDate = DATEADD(day, 1, w2.RecordDate)
where w1.Temperature > w2.Temperature


-- 11. Write an SQL query that reports the first login date for each player.(Activity)

select 
	player_id,
	MIN(event_date) as first_login
from Activity
group by player_id


-- 12. Your task is to return the third item from that list.(fruits)

SELECT
  LTRIM(RTRIM(
    SUBSTRING(
      fruit_list,
      CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) + 1,
      CHARINDEX(',', fruit_list + ',', CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) + 1) 
        - CHARINDEX(',', fruit_list, CHARINDEX(',', fruit_list) + 1) - 1
    )
  )) AS third_fruit
FROM fruits;


-- 13. Write a SQL query to create a table where each character from the string will be converted into a row.(sdgfhsdgfhs@121313131)
create table newtable (
	char char(1)
)

declare @string varchar(100) = 'sdgfhsdgfhs@121313131'
declare @i int = 1

while @i < len(@string)
begin
	insert into newtable values (SUBSTRING(@string, @i, 1))

	set @i += 1
end

select * from newtable

-- 14. You are given two tables: p1 and p2. Join these tables on the id column. The catch is: when the value of p1.code is 0, replace it with the value of p2.code.(p1,p2)

select 
	p1.id, 
	CASE 
		WHEN p1.code = 0 THEN p2.code
		ELSE p1.code
	END AS p1_code, 
	p2.code as p2_code
from p1
join p2
on p1.id = p2.id

-- 15. Write an SQL query to determine the Employment Stage for each employee based on their HIRE_DATE. The stages are defined as follows:
-- If the employee has worked for less than 1 year → 'New Hire'
-- If the employee has worked for 1 to 5 years → 'Junior'
-- If the employee has worked for 5 to 10 years → 'Mid-Level'
-- If the employee has worked for 10 to 20 years → 'Senior'
-- If the employee has worked for more than 20 years → 'Veteran'(Employees)

select
	*,
	case 
		when DATEDIFF(year, HIRE_DATE, GETDATE()) < 1 then 'New Hire'
		when DATEDIFF(year, HIRE_DATE, GETDATE()) between 1 and 5 then 'Junior'
		when DATEDIFF(year, HIRE_DATE, GETDATE()) between 6 and 10 then 'Mid-level'
		when DATEDIFF(year, HIRE_DATE, GETDATE()) between 11 and 20 then 'Senior'
		else 'Veteran'
	end as EmploymentStage
from Employees


-- 16. Write a SQL query to extract the integer value that appears at the start of the string in a column named Vals.(GetIntegers)

select * from GetIntegers

select *,
	case
		when LEFT(VALS, 1) like '[0-9]' then 
			LEFT(VALS, PATINDEX('%[^0-9]%', VALS + 's') - 1)
		else null
	end as StartingInt
from GetIntegers


-- 17. In this puzzle you have to swap the first two letters of the comma separated string.(MultipleVals)

select * from MultipleVals

select *,
	CONCAT(
		SUBSTRING(Vals, CHARINDEX(',', Vals) + 1, 1), 
		',',
		LEFT(Vals, 1),
		',',
		SUBSTRING(Vals, CHARINDEX(',', Vals, CHARINDEX(',', Vals) + 1) + 1, len(Vals))
	) as SwappedVals
from MultipleVals

-- 18. Write a SQL query that reports the device that is first logged in for each player.(Activity)

select a.player_id, a.device_id, a.event_date as first_login
from Activity as a
JOIN (
	select player_id, MIN(event_date) as first_login
	from Activity
	group by player_id
) as b
on a.player_id = b.player_id
where a.event_date = b.first_login;


-- 19. You are given a sales table. Calculate the week-on-week percentage of sales per area for each financial week. 
-- For each week, the total sales will be considered 100%, and the percentage sales for each day of the week 
-- should be calculated based on the area sales for that week.(WeekPercentagePuzzle)

select * from WeekPercentagePuzzle

;WITH DailySales AS (
    SELECT
        Area,
        [Date],
        FinancialWeek,
        FinancialYear,
        [DayName],
        [DayOfWeek],
        SalesLocal + SalesRemote AS TotalSales
    FROM WeekPercentagePuzzle
),
WeeklyTotals AS (
    SELECT
        Area,
        FinancialWeek,
        FinancialYear,
        SUM(SalesLocal + SalesRemote) AS WeeklySales
    FROM WeekPercentagePuzzle
    GROUP BY Area, FinancialWeek, FinancialYear
),
SalesWithPercentage AS (
    SELECT
        d.Area,
        d.[Date],
        d.FinancialWeek,
        d.FinancialYear,
        d.[DayName],
        d.[DayOfWeek],
        d.TotalSales,
        w.WeeklySales,
        CAST(d.TotalSales * 100.0 / NULLIF(w.WeeklySales, 0) AS DECIMAL(5,2)) AS SalesPercentage
    FROM DailySales d
    INNER JOIN WeeklyTotals w
        ON d.Area = w.Area
        AND d.FinancialWeek = w.FinancialWeek
        AND d.FinancialYear = w.FinancialYear
)
SELECT
    Area,
    [Date],
    FinancialWeek,
    FinancialYear,
    [DayName],
    [DayOfWeek],
    SalesPercentage
FROM SalesWithPercentage
ORDER BY Area, FinancialYear, FinancialWeek, DayOfWeek;
