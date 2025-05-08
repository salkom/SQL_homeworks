-- 1. Combine Two Tables

select p.firstName, p.lastName, a.city, a.state
from Person as p
left join Address as a
on p.personId = a.personId


-- 2. Employees Earning More Than Their Managers

select e1.name as Employee
from Employee as e1
join Employee as e2 
on e1.managerId = e2.id
where e1.salary > e2.salary


-- 3. Duplicate Emails

select p1.email as Email
from Person as p1
join Person as p2
on p1.email = p2.email
group by p1.email
having count(p1.email) > 1


-- 4. Delete Duplicate Emails

DELETE FROM Person
WHERE id NOT IN (
    SELECT MIN(id)
    FROM Person
    GROUP BY email
)

SELECT *
FROM Person
ORDER BY id;


-- 5. Find those parents who has only girls.

select distinct g.ParentName 
from boys as b
right join girls as g
on b.ParentName = g.ParentName
where b.ParentName is null


-- 6. Total over 50 and least

SELECT o.custid,
	   SUM(od.unitprice * od.qty * (1 - od.discount)) AS TotalSalesAmount,
	   MIN(o.freight) AS LeastWeight
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS od
ON o.orderid = od.orderid
WHERE o.freight > 50
GROUP BY o.custid
ORDER BY o.custid;


-- 7. Carts

select isnull(c1.Item, '') as [Item Cart 1], isnull(c2.Item, '') as [Item Cart 2]
from Cart1 as c1
full join Cart2 as c2
on c1.Item = c2.Item
order by 
	case 
		when c1.Item = 'Sugar' or c2.Item = 'Sugar' then 0
		when c1.Item = 'Bread' or c2.Item = 'Bread' then 1
		when c1.Item = 'Juice' or c2.Item = 'Juice' then 2
		when c1.Item = 'Soda' or c2.Item = 'Soda' then 3
		when c1.Item = 'Flour' or c2.Item = 'Flour' then 4
		when c1.Item = 'Butter' or c2.Item = 'Butter' then 5
		when c1.Item = 'Cheese' or c2.Item = 'Cheese' then 6
		when c1.Item = 'Fruit' or c2.Item = 'Fruit' then 7
	end 


-- 8. Customers Who Never Order

select c.name as Customers
from Customers as c
left join Orders as o
on c.id = o.customerId
where o.id is null;


-- 9. Students and Examinations

SELECT 
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM 
    Students s
CROSS JOIN 
    Subjects sub
LEFT JOIN 
    Examinations e 
    ON s.student_id = e.student_id 
    AND sub.subject_name = e.subject_name
GROUP BY 
    s.student_id,
    s.student_name,
    sub.subject_name
ORDER BY 
    s.student_id,
    sub.subject_name;

