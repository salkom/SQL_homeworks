
-- Level 1: Basic Subqueries
-- 1. Find Employees with Minimum Salary
-- Task: Retrieve employees who earn the minimum salary in the company. Tables: employees (columns: id, name, salary)

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

-- Solution:

select * 
from employees
where salary = (
	select min(salary) from employees
);

-- 2. Find Products Above Average Price
-- Task: Retrieve products priced above the average price. Tables: products (columns: id, product_name, price)

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO products (id, product_name, price) VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 400),
(3, 'Smartphone', 800),
(4, 'Monitor', 300);

-- Solution:

select * 
from products
where price > (
	select avg(price) from products
);


--Level 2: Nested Subqueries with Conditions
-- 3. Find Employees in Sales Department Task: Retrieve employees who work in the "Sales" department. Tables: employees (columns: id, name, department_id), departments (columns: id, department_name)

CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);
GO
drop table employees
GO
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments (id, department_name) VALUES
(1, 'Sales'),
(2, 'HR');

INSERT INTO employees (id, name, department_id) VALUES
(1, 'David', 1),
(2, 'Eve', 2),
(3, 'Frank', 1);

-- Solution:

select *
from employees
where department_id = (
	select id from departments where department_name = 'Sales'
);


-- 4. Find Customers with No Orders
-- Task: Retrieve customers who have not placed any orders. Tables: customers (columns: customer_id, name), orders (columns: order_id, customer_id)

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_id, name) VALUES
(1, 'Grace'),
(2, 'Heidi'),
(3, 'Ivan');

INSERT INTO orders (order_id, customer_id) VALUES
(1, 1),
(2, 1);

-- Solution:

select *
from customers as c
where not exists (
	select 1
	from orders as o
	where c.customer_id = o.customer_id
)


-- Level 3: Aggregation and Grouping in Subqueries

-- 5. Find Products with Max Price in Each Category
-- Task: Retrieve products with the highest price in each category. Tables: products (columns: id, product_name, price, category_id)
drop table products
GO
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Tablet', 400, 1),
(2, 'Laptop', 1500, 1),
(3, 'Headphones', 200, 2),
(4, 'Speakers', 300, 2);

-- Solution:

select 
	a.id,
	a.product_name,
	a.price,
	a.category_id
from products as a
join (
	select category_id, max(price) as MaxPrice
	from products
	group by category_id		
) as b
on a.category_id = b.category_id and a.price = b.MaxPrice;


-- 6. Find Employees in Department with Highest Average Salary
-- Task: Retrieve employees working in the department with the highest average salary. Tables: employees (columns: id, name, salary, department_id), departments (columns: id, department_name)


drop table departments
GO
CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);
GO

drop table employees
GO
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);
GO
INSERT INTO departments (id, department_name) VALUES
(1, 'IT'),
(2, 'Sales');

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Jack', 80000, 1),
(2, 'Karen', 70000, 1),
(3, 'Leo', 60000, 2);

-- Solution

WITH dept_avg AS (
    SELECT department_id, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY department_id
),
max_dept AS (
    SELECT TOP 1 department_id
    FROM dept_avg
    ORDER BY avg_sal DESC
)
SELECT *
FROM employees
WHERE department_id = (SELECT department_id FROM max_dept);


-- Level 4: Correlated Subqueries

-- 7. Find Employees Earning Above Department Average
-- Task: Retrieve employees earning more than the average salary in their department. Tables: employees (columns: id, name, salary, department_id)
DROP TABLE employees
GO
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),aaaaaaa
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Mike', 50000, 1),
(2, 'Nina', 75000, 1),
(3, 'Olivia', 40000, 2),
(4, 'Paul', 55000, 2);

-- Solution:

select *
from employees as a
where salary > (
	select AVG(b.salary)
	from employees as b
	where b.department_id = a.department_id
)


-- 8. Find Students with Highest Grade per Course
-- Task: Retrieve students who received the highest grade in each course. Tables: students (columns: student_id, name), grades (columns: student_id, course_id, grade)

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE grades (
    student_id INT,
    course_id INT,
    grade DECIMAL(4, 2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students (student_id, name) VALUES
(1, 'Sarah'),
(2, 'Tom'),
(3, 'Uma');

INSERT INTO grades (student_id, course_id, grade) VALUES
(1, 101, 95),
(2, 101, 85),
(3, 102, 90),
(1, 102, 80);

-- Solution:

select 
	g.student_id,
	(select [name]
	from students as s
	where s.student_id = g.student_id
	) as StudName,
	g.course_id,
	g.grade
from grades as g
where grade = (
	select max(grade)
	from grades as g1
	where g1.course_id = g.course_id
)


-- Level 5: Subqueries with Ranking and Complex Conditions
-- 9. Find Third-Highest Price per Category Task: Retrieve products with the third-highest price in each category. Tables: products (columns: id, product_name, price, category_id)
drop table products
GO
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Phone', 800, 1),
(2, 'Laptop', 1500, 1),
(3, 'Tablet', 600, 1),
(4, 'Smartwatch', 300, 1),
(5, 'Headphones', 200, 2),
(6, 'Speakers', 300, 2),
(7, 'Earbuds', 100, 2);

-- Solution:

select *
from products as p1
where 3 = (
	select count(DISTINCT price) 
	from products as p2
	where p1.category_id = p2.category_id and p1.price <= p2.price
	)


-- 10. Find Employees whose Salary Between Company Average and Department Max Salary
-- Task: Retrieve employees with salaries above the company average but below the maximum in their department. Tables: employees (columns: id, name, salary, department_id)

drop table employees
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Alex', 70000, 1),
(2, 'Blake', 90000, 1),
(3, 'Casey', 50000, 2),
(4, 'Dana', 60000, 2),
(5, 'Evan', 75000, 1);

-- Solution:

select * 
from employees as e1
where salary > (
	select avg(salary)
	from employees) 
	and 
	salary < (
	select max(salary)
	from employees as e2
	where e1.department_id = e2.department_id
	)
