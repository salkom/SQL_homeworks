
/* 1. Using the Employees and Departments tables, write a query to return the names and salaries of employees whose salary is greater than 50000, along with their department names.
🔁 Expected Columns: EmployeeName, Salary, DepartmentName */

select e.Name, e.Salary, d.DepartmentName
from Employees as e
left join Departments as d
on e.DepartmentID = d.DepartmentID
where e.Salary > 50000;

/* 1. Using the Customers and Orders tables, write a query to display customer names and order dates for orders placed in the year 2023.
🔁 Expected Columns: FirstName, LastName, OrderDate */

select c.FirstName, c.LastName, o.OrderDate
from Customers as c
join Orders as o
on c.CustomerID = o.CustomerID
where YEAR(o.OrderDate) = 2023;

/* 3. Using the Employees and Departments tables, write a query to show all employees along with their department names. Include employees who do not belong to any department.
🔁 Expected Columns: EmployeeName, DepartmentName */

select e.Name, d.DepartmentName
from Employees as e
left join Departments as d
on e.DepartmentID = d.DepartmentID;

/* 4. Using the Products and Suppliers tables, write a query to list all suppliers and the products they supply. Show suppliers even if they don’t supply any product.
🔁 Expected Columns: SupplierName, ProductName */

select s.SupplierName, p.ProductName
from Products as p
right join Suppliers as s 
on p.SupplierID = s.SupplierID;

/* 5. Using the Orders and Payments tables, write a query to return all orders and their corresponding payments. Include orders without payments and payments not linked to any order.
🔁 Expected Columns: OrderID, OrderDate, PaymentDate, Amount */

select o.OrderID, o.OrderDate, p.PaymentDate, p.Amount
from Orders as o
full join Payments as p
on o.OrderID = p.OrderID;

/* 6. Using the Employees table, write a query to show each employee's name along with the name of their manager.
🔁 Expected Columns: EmployeeName, ManagerName */

select a.Name as EmployeeName, b.Name as ManagerName
from Employees as a
left join Employees as b
on a.ManagerID = b.EmployeeID;

/* 7. Using the Students, Courses, and Enrollments tables, write a query to list the names of students who are enrolled in the course named 'Math 101'.
🔁 Expected Columns: StudentName, CourseName */

select s.Name, c.CourseName
from Students as s
join Enrollments as e
on s.StudentID = e.StudentID
join Courses as c
on e.CourseID = c.CourseID
where CourseName = 'Math 101';

/* 8. Using the Customers and Orders tables, write a query to find customers who have placed an order with more than 3 items. Return their name and the quantity they ordered.
🔁 Expected Columns: FirstName, LastName, Quantity */

select c.FirstName, c.LastName, o.Quantity
from Customers as c
join Orders as o
on c.CustomerID = o.CustomerID
where o.Quantity > 3;

/* 9. Using the Employees and Departments tables, write a query to list employees working in the 'Human Resources' department.
🔁 Expected Columns: EmployeeName, DepartmentName */

select e.Name, d.DepartmentName
from Employees as e
join Departments as d
on e.DepartmentID = d.DepartmentID
where d.DepartmentName = 'Human Resources';

/* 10. Using the Employees and Departments tables, write a query to return department names that have more than 5 employees.
🔁 Expected Columns: DepartmentName, EmployeeCount */

select d.DepartmentName, COUNT(e.EmployeeID) as EmployeeCount
from Employees as e
join Departments as d
on e.DepartmentID = d.DepartmentID
group by d.DepartmentName
having COUNT(e.EmployeeID) > 5;

/* 11. Using the Products and Sales tables, write a query to find products that have never been sold.
🔁 Expected Columns: ProductID, ProductName */

select p.ProductID, p.ProductName
from Products as p
left join Sales as s
on p.ProductID = s.ProductID
where s.SaleID is null;

/* 12. Using the Customers and Orders tables, write a query to return customer names who have placed at least one order.
🔁 Expected Columns: FirstName, LastName, TotalOrders */

select c.FirstName, c.LastName, count(o.OrderID) as TotalOrders
from Customers as c
join Orders as o
on c.CustomerID = o.CustomerID
group by c.FirstName, c.LastName;


/* 13. Using the Employees and Departments tables, write a query to show only those records where both employee and department exist (no NULLs).
🔁 Expected Columns: EmployeeName, DepartmentName */

select e.Name, d.DepartmentName
from Employees as e
join Departments as d
on e.DepartmentID = d.DepartmentID;


/* 14. Using the Employees table, write a query to find pairs of employees who report to the same manager.
🔁 Expected Columns: Employee1, Employee2, ManagerID */

select e1.Name as Employee1, e2.Name as Employee2, e1.ManagerID
from Employees as e1
join Employees as e2
on e1.ManagerID = e2.ManagerID AND e1.EmployeeID < e2.EmployeeID
WHERE e1.ManagerID is not null;

/* 15. Using the Orders and Customers tables, write a query to list all orders placed in 2022 along with the customer name.
🔁 Expected Columns: OrderID, OrderDate, FirstName, LastName */

select o.OrderID, o.OrderDate, c.FirstName, c.LastName
from Orders as o
join Customers as c
on o.CustomerID = c.CustomerID
where YEAR(o.OrderDate) = 2022;

/*  16. Using the Employees and Departments tables, write a query to return employees from the 'Sales' department whose salary is above 60000.
🔁 Expected Columns: EmployeeName, Salary, DepartmentName */

select e.Name, e.Salary, d.DepartmentName
from Employees as e
join Departments as d
on e.DepartmentID = d.DepartmentID
where d.DepartmentName = 'Sales' and e.Salary > 60000;

/* 17. Using the Orders and Payments tables, write a query to return only those orders that have a corresponding payment.
🔁 Expected Columns: OrderID, OrderDate, PaymentDate, Amount */

select o.OrderID, o.OrderDate, p.PaymentDate, p.Amount
from Orders as o
join Payments as p
on o.OrderID = p.OrderID;

/* 18. Using the Products and Orders tables, write a query to find products that were never ordered.
🔁 Expected Columns: ProductID, ProductName */

select p.ProductID, p.ProductName
from Products as p
left join Orders as o
on p.ProductID = o.ProductID
where o.OrderID is null;

/* 19. Using the Employees table, write a query to find employees whose salary is greater than the average salary in their own departments.
🔁 Expected Columns: EmployeeName, Salary */

select e1.Name, e1.Salary
from Employees as e1
outer apply 
(
	select AVG(e2.Salary) as AvgSalary
	from Employees as e2
	WHERE e2.DepartmentID = e1.DepartmentID
) as b
where e1.Salary > b.AvgSalary

/* 20. Using the Orders and Payments tables, write a query to list all orders placed before 2020 that have no corresponding payment.
🔁 Expected Columns: OrderID, OrderDate */

select o.OrderID, o.OrderDate
from Orders as o
left join Payments as p
on o.OrderID = p.OrderID
where YEAR(o.OrderDate) < 2020 and p.PaymentID is null;

/* 21. Using the Products and Categories tables, write a query to return products that do not have a matching category.
🔁 Expected Columns: ProductID, ProductName */

select p.ProductID, p.ProductName
from Products as p
left join Categories as c
on p.Category = c.CategoryID
where c.CategoryID is null;


/* 22. Using the Employees table, write a query to find employees who report to the same manager and earn more than 60000.
🔁 Expected Columns: Employee1, Employee2, ManagerID, Salary */

select e1.Name as Employee1, e2.Name as Employee2, e1.ManagerID, e1.Salary
from Employees as e1
join Employees as e2
on e1.ManagerID = e2.ManagerID and e1.EmployeeID < e2.EmployeeID
where e1.Salary > 60000 and e2.Salary > 60000;


/* 23. Using the Employees and Departments tables, write a query to return employees who work in departments which name starts with the letter 'M'.
🔁 Expected Columns: EmployeeName, DepartmentName */

select e.Name, d.DepartmentName
from Employees as e
join Departments as d
on e.DepartmentID = d.DepartmentID
where d.DepartmentName like 'M%';

/* 24. Using the Products and Sales tables, write a query to list sales where the amount is greater than 500, including product names.
🔁 Expected Columns: SaleID, ProductName, SaleAmount */

select s.SaleID, p.ProductName, s.SaleAmount
from Products as p
join Sales as s
on p.ProductID = s.ProductID
where s.SaleAmount > 500;

/* 25. Using the Students, Courses, and Enrollments tables, write a query to find students who have not enrolled in the course 'Math 101'.
🔁 Expected Columns: StudentID, StudentName */

select s.StudentID, s.Name
from Students as s
left join Enrollments as e
on s.StudentID = e.StudentID
left join Courses as c
on e.CourseID = c.CourseID

except 

select s.StudentID, s.Name
from Students as s
left join Enrollments as e
on s.StudentID = e.StudentID
left join Courses as c
on e.CourseID = c.CourseID
where c.CourseName = 'Math 101';

/* 26. Using the Orders and Payments tables, write a query to return orders that are missing payment details.
🔁 Expected Columns: OrderID, OrderDate, PaymentID */

select o.OrderID, o.OrderDate, p.PaymentID
from Orders as o
left join Payments as p
on o.OrderID = p.OrderID
where p.PaymentID is null;

/* 27. Using the Products and Categories tables, write a query to list products that belong to either the 'Electronics' or 'Furniture' category.
🔁 Expected Columns: ProductID, ProductName, CategoryName */

select p.ProductID, p.ProductName, c.CategoryName
from Products as p
join Categories as c
on p.Category = c.CategoryID
where c.CategoryName in ('Electronics', 'Furniture');

