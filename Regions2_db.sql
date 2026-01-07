-- 1. Create Regions table (Dimension)
CREATE TABLE regions (
    id SERIAL PRIMARY KEY,            -- Auto-incrementing unique ID
    region_name VARCHAR(50) NOT NULL  -- Name of the geographical area
); 
-- 2. Create Categories table (Dimension)
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,            -- Unique ID for the product category
    name VARCHAR(100) NOT NULL        -- Category name (e.g., Electronics)
);
 -- 3. Create Products table (Dimension)
CREATE TABLE products (
    id SERIAL PRIMARY KEY,            -- Unique ID for the product
    name VARCHAR(100) NOT NULL,       -- Product name
    category_id INTEGER REFERENCES categories(id), -- Foreign key linking to categories
    price NUMERIC(10, 2)              -- Standard price of the product
);
 
-- 4. Create Sales table (Fact table - the "heavy" table)
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,            -- Unique transaction ID
    sale_date DATE NOT NULL,          -- When the sale happened
    product_id INTEGER REFERENCES products(id), -- Link to which product was sold
    region_id INTEGER REFERENCES regions(id),   -- Link to where it was sold
    amount NUMERIC(12, 2) NOT NULL    -- Final sale price/revenue
);
 
-- Insert Sample Data
INSERT INTO regions (region_name) VALUES ('North America'), ('Europe'), ('Asia'); 
INSERT INTO categories (name) VALUES ('Electronics'), ('Office Supplies'); 
INSERT INTO products (name, category_id, price) VALUES 
('Laptop', 1, 1200.00), 
('Monitor', 1, 300.00), 
('Desk Chair', 2, 150.00);
-- Insert random sales data across different months and regions
INSERT INTO sales (sale_date, product_id, region_id, amount) VALUES 
('2025-12-15', 1, 1, 1200.00), -- North America Sale
('2025-12-20', 2, 1, 300.00),  -- North America Sale
('2026-01-05', 1, 2, 1150.00), -- Europe Sale (with discount)
('2026-01-10', 3, 3, 150.00);  -- Asia Sale

select * from regions;
select * from categories;
select * from products;
select * from sales;
 
create or replace view vw_MonthlyRevenueByRegion as
SELECT
    r.region_name,
    date_trunc('month',s.sale_date) as sale_month,
    sum(s.amount) as total_revenue,
    count(s.id) as total_sales
FROM
    sales s
join regions r on s.region_id = r.id
JOIN products p on s.product_id = p.id
GROUP BY r.region_name, sale_month;

select * from vw_MonthlyRevenueByRegion;

CREATE PROCEDURE sp_GetRevenueForDateRange(
    IN p_start_date DATE,
    IN p_end_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT
        r.region_name,
        c.name AS category_name,
        SUM(s.amount) AS total_revenue
    FROM sales s
    JOIN products p
        ON s.product_id = p.id
    JOIN categories c
        ON p.category_id = c.id
    JOIN regions r
        ON s.region_id = r.id
    WHERE s.sale_date BETWEEN p_start_date AND p_end_date
    GROUP BY r.region_name, c.name
    ORDER BY total_revenue DESC;
END;
$$;

SELECT * 
FROM sp_GetRevenueForDateRange('2025-12-01', '2025-12-31');
