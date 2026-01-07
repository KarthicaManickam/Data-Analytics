-- Create a table to store product categories

CREATE TABLE categories (
    category_id INT PRIMARY KEY,        -- Unique identifier for category
    category_name VARCHAR(50)            -- Name of the category
);
 
-- Create a table to store product details
CREATE TABLE products (
    product_id INT PRIMARY KEY,          -- Unique product ID
    product_name VARCHAR(50),             -- Name of the product
    category_id INT                       -- Category to which product belongs
);
 
-- Create a table to store customer details
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,          -- Unique customer ID
    customer_name VARCHAR(50)             -- Name of the customer
);
 
 
-- Create a table to store sales transactions
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,              -- Unique sale ID
    product_id INT,                       -- Product sold
    customer_id INT,                      -- Customer who bought the product
    sales_rep VARCHAR(50),                -- Sales representative name
    sale_amount NUMERIC(10,2)             -- Sale amount
);
 
-- Insert sample categories
INSERT INTO categories VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Books');
 
-- Insert sample products

INSERT INTO products VALUES
(101, 'Laptop', 1),
(102, 'Mobile', 1),
(103, 'T-Shirt', 2),
(104, 'Jeans', 2),
(105, 'Novel', 3);
 
-- Insert sample customers

INSERT INTO customers VALUES
(201, 'Alice'),
(202, 'Bob'),
(203, 'Charlie');
 
-- Insert sample sales transactions

INSERT INTO sales VALUES
(1, 101, 201, 'John', 800.00),
(2, 102, 201, 'John', 600.00),
(3, 103, 202, 'Mary', 50.00),
(4, 104, 202, 'Mary', 70.00),
(5, 105, 203, 'Steve', 40.00),
(6, 101, 203, 'Steve', 900.00);

select * from sales;
select * from categories;
select * from products;
select * from customers;

--- count number of products in each category

SELECT 
     c.category_name,
	 COUNT(p.product_id) AS total_products
FROM categories c
JOIN products p
    ON c.category_id = p.category_id
GROUP BY
    c.category_name;

---- total sales amount for each customer

Select 
	c.customer_name,
	sum(s.sale_amount) as TotalSales 
from Customers c
join sales s
on c.customer_id =s.customer_id
group by c.customer_id
order by totalsales desc;

---highest average sale amount

select
	s.sales_rep,
	avg(s.sale_amount)as AverageSales
from sales s
group by s.sales_rep
order by AverageSales desc
Limit 2;
 