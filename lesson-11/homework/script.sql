/* 1. Return: OrderID, CustomerName, OrderDate
Task: Show all orders placed after 2022 along with the names of the customers who placed them.
Tables Used: Orders, Customers */

select o.OrderID, c.FirstName + ' ' + c.LastName as CustomerName, o.OrderDate
from Orders as o
join Customers as c
on o.CustomerID = c.CustomerID
where year(o.OrderDate) >= 2022;

/* 2. Return: EmployeeName, DepartmentName
Task: Display the names of employees who work in either the Sales or Marketing department.
Tables Used: Employees, Departments */

select e.Name as EmployeeName, d.DepartmentName
from Employees as e
join Departments as d
on e.DepartmentID = d.DepartmentID
where d.DepartmentName in ('Sales', 'Marketing');

/* 3. Return: DepartmentName, MaxSalary
Task: Show the highest salary for each department.
Tables Used: Departments, Employees */

select d.DepartmentName, MAX(e.Salary) as MaxSalary
from Employees as e
right join Departments as d
on e.DepartmentID = d.DepartmentID
group by d.DepartmentName;

/* 4. Return: CustomerName, OrderID, OrderDate
Task: List all customers from the USA who placed orders in the year 2023.
Tables Used: Customers, Orders */

select c.FirstName + ' ' + c.LastName as CustomerName, o.OrderID, o.OrderDate
from Customers as c
join Orders as o
on c.CustomerID = o.CustomerID
where c.Country = 'USA' and year(o.OrderDate) = 2023;

/* 5. Return: CustomerName, TotalOrders
Task: Show how many orders each customer has placed.
Tables Used: Orders , Customers */

select c.FirstName + ' ' + c.LastName as CustomerName, count(o.OrderID) as TotalOrders
from Orders as o
join Customers as c
on o.CustomerID = c.CustomerID
group by c.FirstName, c.LastName;

/* 6. Return: ProductName, SupplierName
Task: Display the names of products that are supplied by either Gadget Supplies or Clothing Mart.
Tables Used: Products, Suppliers */

select p.ProductName, s.SupplierName
from Products as p
join Suppliers as s
on p.SupplierID = s.SupplierID
where s.SupplierName in ('Gadget Supplies', 'Clothing Mart')

/* 7. Return: CustomerName, MostRecentOrderDate
Task: For each customer, show their most recent order. Include customers who haven't placed any orders.
Tables Used: Customers, Orders */

select c.FirstName + ' ' + c.LastName as CustomerName, p.OrderDate
from Customers as c
outer apply 
(
	select top 1 o.OrderDate
	from Orders as o
	where c.CustomerID = o.CustomerID
	order by o.OrderDate desc
) as p

/* 8. Return: CustomerName, OrderTotal
Task: Show the customers who have placed an order where the total amount is greater than 500.
Tables Used: Orders, Customers */

select c.FirstName + ' ' + c.LastName as CustomerName, o.TotalAmount as OrderTotal
from Orders as o
join Customers as c
on o.CustomerID = c.CustomerID
where o.TotalAmount > 500;


/* 9. Return: ProductName, SaleDate, SaleAmount
Task: List product sales where the sale was made in 2022 or the sale amount exceeded 400.
Tables Used: Products, Sales */

select p.ProductName, s.SaleDate, s.SaleAmount
from Products as p
join Sales as s
on p.ProductID = s.ProductID
where year(s.SaleDate) = 2022 or s.SaleAmount > 400;

/* 10. Return: ProductName, TotalSalesAmount
Task: Display each product along with the total amount it has been sold for.
Tables Used: Sales, Products */

select p.ProductName, sum(s.SaleAmount) as TotalSalesAmount
from Sales as s
join Products as p
on s.ProductID = p.ProductID
group by p.ProductName


/* 11. Return: EmployeeName, DepartmentName, Salary
Task: Show the employees who work in the HR department and earn a salary greater than 60000.
Tables Used: Employees, Departments */

select e.Name as EmployeeName, d.DepartmentName, e.Salary
from Employees as e
join Departments as d
on e.DepartmentID = d.DepartmentID
where d.DepartmentName = 'Human Resources' and e.Salary > 60000;

/* 12. Return: ProductName, SaleDate, StockQuantity
Task: List the products that were sold in 2023 and had more than 100 units in stock at the time.
Tables Used: Products, Sales */

select p.ProductName, s.SaleDate, p.StockQuantity
from Products as p
join Sales as s 
on p.ProductID = s.ProductID
where year(s.SaleDate) = 2023 and p.StockQuantity > 100;

/* 13. Return: EmployeeName, DepartmentName, HireDate
Task: Show employees who either work in the Sales department or were hired after 2020.
Tables Used: Employees, Departments */

select e.Name as EmployeeName, d.DepartmentName, e.HireDate
from Employees as e
join Departments as d
on e.DepartmentID = d.DepartmentID
where d.DepartmentName = 'Sales' or year(e.HireDate) >= 2020;

/* 14. Return: CustomerName, OrderID, Address, OrderDate
Task: List all orders made by customers in the USA whose address starts with 4 digits.
Tables Used: Customers, Orders */

select c.FirstName + ' ' + c.LastName as CustomerName, o.OrderID, c.Address, o.OrderDate
from Customers as c
join Orders as o
on c.CustomerID = o.CustomerID
where c.Country = 'USA' and c.Address like '[0-9][0-9][0-9][0-9]%';

/* 15. Return: ProductName, Category, SaleAmount
Task: Display product sales for items in the Electronics category or where the sale amount exceeded 350.
Tables Used: Products, Sales */

select p.ProductName, p.Category, s.SaleAmount
from Products as p
join Sales as s
on p.ProductID = s.ProductID
where p.Category = 1 or s.SaleAmount > 350;

/* 16. Return: CategoryName, ProductCount
Task: Show the number of products available in each category.
Tables Used: Products, Categories */

select c.CategoryName, COUNT(p.ProductID) as ProductCount
from Products as p
right join Categories as c
on p.Category = c.CategoryID
group by c.CategoryName

/* 17. Return: CustomerName, City, OrderID, Amount
Task: List orders where the customer is from Los Angeles and the order amount is greater than 300.
Tables Used: Customers, Orders */

select c.FirstName + ' ' + c.LastName as CustomerName, c.City, o.OrderID, o.TotalAmount as Amount
from Customers as c
join Orders as o
on c.CustomerID = o.CustomerID
where c.City = 'Los Angeles' and o.TotalAmount > 300;

/* 18. Return: EmployeeName, DepartmentName
Task: Display employees who are in the HR or Finance department, or whose name contains at least 4 vowels.
Tables Used: Employees, Departments */

select e.Name as EmployeeName, d.DepartmentName
from Employees as e
join Departments as d
on e.DepartmentID = d.DepartmentID
where d.DepartmentName in ('Human Resources', 'Finance') or e.Name like '%[aeiouAEIOU]%[aeiouAEIOU]%[aeiouAEIOU]%[aeiouAEIOU]%';

/* 19. Return: EmployeeName, DepartmentName, Salary
Task: Show employees who are in the Sales or Marketing department and have a salary above 60000.
Tables Used: Employees, Departments */

select e.Name as EmployeeName, d.DepartmentName, e.Salary
from Employees as e
join Departments as d
on e.DepartmentID = d.DepartmentID
where d.DepartmentName in ('Sales', 'Marketing') and e.Salary > 60000;
