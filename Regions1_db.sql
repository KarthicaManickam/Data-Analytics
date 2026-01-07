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
 
 
-- Create a view to centralize complex join and aggregation logic
CREATE OR REPLACE VIEW vw_MonthlyRevenueByRegion AS
SELECT 
    r.region_name,                               -- Get readable region name
    DATE_TRUNC('month', s.sale_date) AS sale_month, -- Truncate date to the first of the month
    SUM(s.amount) AS total_revenue,              -- Aggregate total sales
    COUNT(s.id) AS transaction_count             -- Count total number of orders
FROM sales s
JOIN regions r ON s.region_id = r.id             -- Join 1: Link sales to regions
JOIN products p ON s.product_id = p.id           -- Join 2: Link sales to products
JOIN categories c ON p.category_id = c.id        -- Join 3: Link products to categories
GROUP BY r.region_name, sale_month               -- Group by region and month for the KPI
ORDER BY sale_month DESC, total_revenue DESC;    -- Sort by most recent and highest performing
 
SELECT * FROM vw_MonthlyRevenueByRegion;
 
-- The "Time Machine" Function (Date Range Report)
CREATE OR REPLACE FUNCTION sp_GetRevenueForDateRange(start_date DATE, end_date DATE)
RETURNS TABLE (region TEXT, revenue NUMERIC) 
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT r.region_name::TEXT, SUM(s.amount)
    FROM sales s
    JOIN regions r ON s.region_id = r.id
    WHERE s.sale_date BETWEEN start_date AND end_date
    GROUP BY r.region_name;
END; $$;
 
 
-- Test the KPI View
SELECT * FROM vw_MonthlyRevenueByRegion;
-- Test the function for just the year 2026
SELECT * FROM sp_GetRevenueForDateRange('2026-01-01', '2026-12-31');