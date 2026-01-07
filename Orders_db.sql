-- Create Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,       -- Unique ID for each customer
    customer_name VARCHAR(100)          -- Full name of the customer
);
 
-- Create Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,         -- Unique ID for each product
    product_name VARCHAR(100)            -- Name of the product
);
 
-- Create Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,            -- Unique order ID
    customer_id INT,                     -- Customer who placed the order
    product_id INT,                      -- Product ordered
    order_date DATE                      -- Date when the order was placed
);
 
-- Insert sample customers
INSERT INTO customers VALUES
(1, 'John Smith'),
(2, 'Alice Brown'),
(3, 'Bob Johnson');

 
-- Insert sample products
INSERT INTO products VALUES
(101, 'Laptop'),
(102, 'Mobile Phone'),
(103, 'Headphones');

-- Insert sample orders
INSERT INTO orders VALUES
(1001, 1, 101, '2024-01-10'),   -- John ordered a Laptop
(1002, 1, 103, '2024-01-15'),   -- John ordered Headphones
(1003, 2, 102, '2024-01-20'),   -- Alice ordered a Mobile
(1004, 3, 103, '2024-01-22');   -- Bob ordered Headphones

select * from orders;
select * from products;
select * from customers;

CREATE VIEW CustomerOrderReport AS
SELECT
    c.Customer_Name,
    p.Product_Name,
    o.Order_Date
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
JOIN Products p
    ON p.Product_ID = o.Product_ID;

select * from CustomerOrderReport where customer_name='John Smith';

 