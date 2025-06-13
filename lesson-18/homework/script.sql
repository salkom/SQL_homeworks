
-- 1. Create a temporary table named MonthlySales to store the total quantity sold and total revenue for each product in the current month.
-- Return: ProductID, TotalQuantity, TotalRevenue

create table #MonthlySales (
	ProductID INT, 
	TotalQuantity INT,
	TotalRevenue DECIMAL(10,2)
);

insert into #MonthlySales (ProductID, TotalQuantity, TotalRevenue)
select p.ProductID, sum(s.Quantity) as TotalQuantity, sum(p.Price * s.Quantity) as TotalRevenue
from Products as p
join Sales as s
on p.ProductID = s.ProductID
group by p.ProductID

select * from #MonthlySales

-- 2. Create a view named vw_ProductSalesSummary that returns product info along with total sales quantity across all time.
-- Return: ProductID, ProductName, Category, TotalQuantitySold

create view vw_ProductSalesSummary as 
select p.ProductID, p.ProductName, p.Category, sum(s.Quantity) as TotalQuantitySold
from Products as p
join Sales as s
on p.ProductID = s.ProductID
group by p.ProductID, p.ProductName, p.Category

-- 3. Create a function named fn_GetTotalRevenueForProduct(@ProductID INT)
-- Return: total revenue for the given product ID

CREATE FUNCTION fn_GetTotalRevenueForProduct (@ProductID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.ProductID,
        p.ProductName,
        SUM(s.Quantity * p.Price) AS TotalRevenue
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    WHERE p.ProductID = @ProductID
    GROUP BY p.ProductID, p.ProductName
);

SELECT * FROM dbo.fn_GetTotalRevenueForProduct(1);


-- 4. Create an function fn_GetSalesByCategory(@Category VARCHAR(50))
-- Return: ProductName, TotalQuantity, TotalRevenue for all products in that category.

CREATE FUNCTION fn_GetSalesByCategory (@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantity,
        SUM(s.Quantity * p.Price) AS TotalRevenue
    FROM Products p
    INNER JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.Category = @Category
    GROUP BY p.ProductName
);

SELECT * FROM dbo.fn_GetSalesByCategory('Electronics');


-- 5. You have to create a function that get one argument as input from user and 
-- the function should return 'Yes' if the input number is a prime number and 'No' otherwise. 
-- You can start it like this:

CREATE FUNCTION fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    DECLARE @i INT = 2;
    DECLARE @IsPrime BIT = 1;

    IF @Number <= 1
        RETURN 'No';

    WHILE @i * @i <= @Number
    BEGIN
        IF @Number % @i = 0
        BEGIN
            SET @IsPrime = 0;
            BREAK;
        END
        SET @i = @i + 1;
    END

    RETURN CASE WHEN @IsPrime = 1 THEN 'Yes' ELSE 'No' END;
END;


SELECT dbo.fn_IsPrime(7) AS IsSevenPrime;     -- Returns: Yes
SELECT dbo.fn_IsPrime(20) AS IsTwentyPrime;   -- Returns: No


/*
-- 6. Create a table-valued function named fn_GetNumbersBetween that accepts two integers as input:
@Start INT
@End INT

The function should return a table with a single column:

| Number |
|--------|
| @Start |
...
...
...
|   @end |


It should include all integer values from @Start to @End, inclusive.

*/


CREATE FUNCTION fn_GetNumbersBetween (@Start INT, @End INT)
RETURNS @Numbers TABLE (Number INT)
AS
BEGIN
    ;WITH NumberCTE AS (
        SELECT @Start AS Number
        UNION ALL
        SELECT Number + 1
        FROM NumberCTE
        WHERE Number + 1 <= @End
    )
    INSERT INTO @Numbers (Number)
    SELECT Number FROM NumberCTE
    OPTION (MAXRECURSION 32767);  -- Allows up to 32,767 numbers

    RETURN;
END;

SELECT * FROM dbo.fn_GetNumbersBetween(5, 10);


/*

7. Write a SQL query to return the Nth highest distinct salary from the Employee table. If there are fewer than N distinct salaries, return NULL.
Example 1:
Input.Employee table:

| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
n = 2
Output:

| getNthHighestSalary(2) |
|    HighestNSalary      |
|------------------------|
| 200                    |
Example 2:
Input.Employee table:

| id | salary |
|----|--------|
| 1  | 100    |
n = 2
Output:

| getNthHighestSalary(2) |
|    HighestNSalary      |
|        null            |

*/

CREATE FUNCTION fn_GetNthHighestSalary (@N INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;

    SELECT @Result = Salary
    FROM (
        SELECT DISTINCT Salary, 
               DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
        FROM Employee
    ) AS RankedSalaries
    WHERE SalaryRank = @N;

    RETURN @Result;
END;

SELECT dbo.fn_GetNthHighestSalary(2) AS getNthHighestSalary;

/*

8. Write a SQL query to find the person who has the most friends.
Return: Their id, The total number of friends they have

Friendship is mutual. For example, if user A sends a request to user B and it's accepted, both A and B are considered friends with each other. The test case is guaranteed to have only one user with the most friends.
Input.RequestAccepted table:

| requester_id | accepter_id | accept_date |
+--------------+-------------+-------------+
| 1            | 2           | 2016/06/03  |
| 1            | 3           | 2016/06/08  |
| 2            | 3           | 2016/06/08  |
| 3            | 4           | 2016/06/09  |
Output:

| id | num |
+----+-----+
| 3  | 3   |
Explanation: The person with id 3 is a friend of people 1, 2, and 4, so he has three friends in total, which is the most number than any others.

*/

SELECT TOP 1 id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id FROM RequestAccepted
) AS AllFriends
GROUP BY id
ORDER BY COUNT(*) DESC;


-- 9. Create a View for Customer Order Summary.

CREATE VIEW vw_CustomerOrderSummary AS
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    ISNULL(SUM(o.amount), 0) AS total_amount,
    MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

/*
Write an SQL statement to fill in the missing gaps. You have to write only select statement, no need to modify the table.
| RowNumber | Workflow |
|----------------------|
| 1         | Alpha    |
| 2         |          |
| 3         |          |
| 4         |          |
| 5         | Bravo    |
| 6         |          |
| 7         |          |
| 8         |          |
| 9         |          |
| 10        | Charlie  |
| 11        |          |
| 12        |          |
Here is the expected output.

| RowNumber | Workflow |
|----------------------|
| 1         | Alpha    |
| 2         | Alpha    |
| 3         | Alpha    |
| 4         | Alpha    |
| 5         | Bravo    |
| 6         | Bravo    |
| 7         | Bravo    |
| 8         | Bravo    |
| 9         | Bravo    |
| 10        | Charlie  |
| 11        | Charlie  |
| 12        | Charlie  |

*/

SELECT 
    RowNumber,
    LAST_VALUE(TestCase) IGNORE NULLS OVER (
        ORDER BY RowNumber
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Workflow
FROM Gaps
ORDER BY RowNumber;
