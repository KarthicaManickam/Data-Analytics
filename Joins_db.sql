create table Employees(
emp_id INT primary key,
emp_name VARCHAR(50),
Dept_id INT
);

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,        -- Unique ID for each department
    dept_name VARCHAR(50)           -- Name of the department
);

select * from Employees;
select * from departments;

-- Insert sample records into Employees table

INSERT INTO employees (emp_id, emp_name, dept_id) VALUES

(1, 'Alice', 10),      -- Has matching department
(2, 'Bob', 20),        -- Has matching department
(3, 'Charlie', 30),    -- Has NO matching department
(4, 'David', NULL);    -- Employee without any department
 
-- Insert sample records into Departments table

INSERT INTO departments (dept_id, dept_name) VALUES

(10, 'Sales'),         -- Matched with Alice
(20, 'HR'),            -- Matched with Bob
(40, 'Finance');       -- NO employee belongs to this department

 Select 
 	e.emp_id,
	e.emp_name,
	d.dept_name
From Employees e
inner join departments d
on e.dept_id=d.dept_id;

-- LEFT JOIN

 Select 
 	e.emp_id,
	e.emp_name,
	d.dept_name
From Employees e
LEFT join departments d
on e.dept_id=d.dept_id;

-- Right Join
 Select 
 	e.emp_id,
	e.emp_name,
	d.dept_name
From Employees e
right join departments d
on e.dept_id=d.dept_id;

 Select 
 	e.emp_id,
	e.emp_name,
	d.dept_name
From Employees e
Full join departments d
on e.dept_id=d.dept_id;