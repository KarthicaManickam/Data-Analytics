-- Create a Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT
);

-- Insert sample students
INSERT INTO Students (student_id, first_name, last_name, age) VALUES
(1, 'Alice', 'Johnson', 20),
(2, 'Bob', 'Smith', 22),
(3, 'Charlie', 'Brown', 19),
(4, 'Diana', 'Miller', 21);

-- Select only the first name and last name of all students
SELECT first_name, last_name
FROM Students;
-- Select all columns from the Students table
SELECT *
FROM Students;
-- Create an Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC(10, 2)
);
-- Insert sample employees
INSERT INTO Employees (employee_id, first_name, last_name, department, salary) VALUES
(101, 'John', 'Doe', 'Sales', 55000),
(102, 'Jane', 'Smith', 'Sales', 65000),
(103, 'Mike', 'Brown', 'HR', 50000),
(104, 'Emily', 'Davis', 'IT', 72000),
(105, 'Chris', 'Wilson', 'Sales', 75000);

SELECT *
FROM Employees
WHERE department = 'Sales';
-- Find employees in the Sales department with a salary greater than 60000
SELECT *
FROM Employees
WHERE department = 'Sales'
  AND salary > 60000;
  -- Create a Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC(10, 2),
    stock INT
);
-- Insert sample products
INSERT INTO Products (product_id, product_name, price, stock) VALUES
(201, 'Notebook', 2.50, 100),
(202, 'Pen', 1.20, 500),
(203, 'Backpack', 35.00, 25),
(204, 'Desk Lamp', 18.99, 15),
(205, 'Calculator', 12.00, 8),
(206, 'Water Bottle', 9.50, 50),
(207, 'Headphones', 45.00, 5);

-- Retrieve the 5 products with the lowest price
SELECT product_name, price
FROM Products
ORDER BY price ASC
LIMIT 5;

-- Retrieve the 3 products with the lowest stock
-- Results are sorted in descending order of stock
SELECT product_name, stock
FROM Products
ORDER BY stock ASC
LIMIT 3;

SELECT * FROM Students;
SELECT * FROM Employees;
SELECT * FROM Products;




