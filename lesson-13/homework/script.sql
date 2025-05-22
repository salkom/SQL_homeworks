-- 1. You need to write a query that outputs "100-Steven King", meaning emp_id + first_name + last_name in that format using employees table.
select concat(EMPLOYEE_ID, '-',FIRST_NAME, ' ', LAST_NAME) as Result
from Employees

-- 2. Update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'
select replace(PHONE_NUMBER, '124', '999') as New_Phone_Number
from Employees

-- 3. That displays the first name and the length of the first name for all employees whose name starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees' first names.(Employees)
select concat(FIRST_NAME, ' ', LEN(FIRST_NAME)) as First_Name_Length
from Employees
where left(FIRST_NAME, 1) in ('A', 'J', 'M')
order by First_Name_Length

-- 4. Write an SQL query to find the total salary for each manager ID.(Employees table)
select MANAGER_ID, SUM(SALARY) as Salary
FROM Employees
group by MANAGER_ID

-- 5. Write a query to retrieve the year and the highest value from the columns Max1, Max2, and Max3 for each row in the TestMax table
select Year1, GREATEST(Max1, Max2, Max3) as Highest_Value
from TestMax

-- 6. Find me odd numbered movies and description is not boring.(cinema)
select *
from cinema
where id % 2 = 1 and description <> 'boring'


-- 7. You have to sort data based on the Id but Id with 0 should always be the last row. Now the question is can you do that with a single order by column.(SingleOrder)
select * 
from SingleOrder
order by case when id = 0 then 9999999999 else id end 

-- 8. Write an SQL query to select the first non-null value from a set of columns. If the first column is null, move to the next, and so on. If all columns are null, return null.(person)
select COALESCE(ssn, passportid, itin, null)
from person

-- 9. Split column FullName into 3 part ( Firstname, Middlename, and Lastname).(Students Table)

select 
	SUBSTRING(FullName, 1, CHARINDEX(' ', FullName) - 1) as Firstname,
	SUBSTRING(FullName, CHARINDEX(' ', FullName) + 1, 
		CHARINDEX(' ', FullName, CHARINDEX(' ', FullName) + 1) - CHARINDEX(' ', FullName) - 1) AS MiddleName,
	SUBSTRING(FullName, CHARINDEX(' ', FullName, CHARINDEX(' ', FullName) + 1) + 1, LEN(FullName)) AS LastName
from Students

-- 10. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas. (Orders Table)
select *
from Orders
where DeliveryState = 'TX' 
	and CustomerID in ( 
		select distinct CustomerID 
		from Orders 
		where DeliveryState = 'CA'
	);

-- 11. Write an SQL statement that can group concatenate the following values.(DMLTable)

select STRING_AGG(String, ' ')
from DMLTable


-- 12. Find all employees whose names (concatenated first and last) contain the letter "a" at least 3 times.
select *
from Employees
where concat(FIRST_NAME, ' ', LAST_NAME) like '%a%a%a%';

-- 13. The total number of employees in each department and the percentage of those employees who have been with the company for more than 3 years(Employees)
select DEPARTMENT_ID, 
	   count(EMPLOYEE_ID) as NumberOfEmployees,
	   (COUNT(CASE WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 3 THEN 1 END) * 100.0 / COUNT(EMPLOYEE_ID)) AS MoreThan3YearsPercentage
from Employees
group by DEPARTMENT_ID

-- 14. Write an SQL statement that determines the most and least experienced Spaceman ID by their job description.(Personal)
with CTE as (
	select JobDescription, MAX(MissionCount) as MaxExp, MIN(MissionCount) as MinExp
	from Personal
	group by JobDescription
)
select c.JobDescription, most.SpacemanID as MostExpID, least.SpacemanID as LeastExpId
from CTE as c
join Personal as most
on c.JobDescription = most.JobDescription and c.MaxExp = most.MissionCount
join Personal as least
on c.JobDescription = least.JobDescription and c.MinExp = least.MissionCount


-- 15. Write an SQL query that separates the uppercase letters, lowercase letters, numbers, and other characters from the given string 'tf56sd#%OqH' into separate columns.

SELECT
    STRING_AGG(CASE 
                   WHEN ASCII(SUBSTRING('tf56sd#%OqH', number, 1)) BETWEEN ASCII('A') AND ASCII('Z') 
                   THEN SUBSTRING('tf56sd#%OqH', number, 1) 
               END, '') AS UppercaseLetters,
    STRING_AGG(CASE 
                   WHEN ASCII(SUBSTRING('tf56sd#%OqH', number, 1)) BETWEEN ASCII('a') AND ASCII('z') 
                   THEN SUBSTRING('tf56sd#%OqH', number, 1) 
               END, '') AS LowercaseLetters,
    STRING_AGG(CASE 
                   WHEN ASCII(SUBSTRING('tf56sd#%OqH', number, 1)) BETWEEN ASCII('0') AND ASCII('9') 
                   THEN SUBSTRING('tf56sd#%OqH', number, 1) 
               END, '') AS Numbers,
    STRING_AGG(CASE 
                   WHEN ASCII(SUBSTRING('tf56sd#%OqH', number, 1)) NOT BETWEEN ASCII('A') AND ASCII('Z')
                        AND ASCII(SUBSTRING('tf56sd#%OqH', number, 1)) NOT BETWEEN ASCII('a') AND ASCII('z')
                        AND ASCII(SUBSTRING('tf56sd#%OqH', number, 1)) NOT BETWEEN ASCII('0') AND ASCII('9')
                   THEN SUBSTRING('tf56sd#%OqH', number, 1) 
               END, '') AS SpecialChars
FROM master.dbo.spt_values
WHERE type = 'P' AND number BETWEEN 1 AND LEN('tf56sd#%OqH');


-- 16. Write an SQL query that replaces each row with the sum of its value and the previous rows' value. (Students table)

select s1.StudentID, sum(s2.StudentID) as RunningTotal
from Students as s1
join Students as s2
on s2.StudentID <= s1.StudentID
group by s1.StudentID
order by s1.StudentID


-- 17. You are given the following table, which contains a VARCHAR column that contains mathematical equations. Sum the equations and provide the answers in the output.(Equations)

WITH Numbers AS (
    SELECT number
    FROM master.dbo.spt_values
    WHERE type = 'P' AND number BETWEEN 1 AND 200
),
Tokens AS (
    SELECT 
        E.Equation,
        N.number AS pos,
        SUBSTRING(E.Equation, N.number, 1) AS ch
    FROM Equations E
    JOIN Numbers N ON N.number <= LEN(E.Equation)
),
Grouped AS (
    -- Assign token groups: each group represents a full number (like 12 or 123)
    SELECT 
        Equation,
        pos,
        ch,
        SUM(CASE WHEN ch IN ('+', '-') THEN 1 ELSE 0 END) OVER (PARTITION BY Equation ORDER BY pos ROWS UNBOUNDED PRECEDING) AS group_id
    FROM Tokens
),
Parts AS (
    -- Rebuild numbers and extract operator preceding each
    SELECT 
        Equation,
        group_id,
        STRING_AGG(ch, '') WITHIN GROUP (ORDER BY pos) AS token
    FROM Grouped
    WHERE ch NOT IN ('+', '-')
    GROUP BY Equation, group_id
),
Operators AS (
    -- Get operator for each group
    SELECT 
        Equation,
        group_id,
        MIN(CASE WHEN ch IN ('+', '-') THEN ch END) AS operator
    FROM Grouped
    GROUP BY Equation, group_id
),
FinalParts AS (
    -- Combine value and operator
    SELECT 
        P.Equation,
        ISNULL(O.operator, '+') AS operator,  -- default first value to '+'
        CAST(P.token AS INT) AS value
    FROM Parts P
    LEFT JOIN Operators O
        ON P.Equation = O.Equation AND P.group_id = O.group_id
)
-- Final aggregation
SELECT 
    Equation,
    SUM(CASE operator WHEN '+' THEN value ELSE -value END) AS TotalSum
FROM FinalParts
GROUP BY Equation;


-- 18. Given the following dataset, find the students that share the same birthday.(Student Table)

select s1.StudentName, s2.StudentName, s1.Birthday
from Student as s1
join Student as s2
on s1.Birthday = s2.Birthday
where s1.StudentName <> s2.StudentName and s1.StudentName < s2.StudentName

-- 19. You have a table with two players (Player A and Player B) and their scores. 
-- If a pair of players have multiple entries, aggregate their scores into a single row 
-- for each unique pair of players. Write an SQL query to calculate the total score 
-- for each unique player pair(PlayerScores)

select PlayerA, PlayerB, SUM(Score)
from PlayerScores
group by PlayerA, PlayerB

