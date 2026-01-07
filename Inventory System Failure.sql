-- STEP 1: Create Tables
-- Create the inventory table to track stock levels
CREATE TABLE IF NOT EXISTS inventory (
    product_id SERIAL PRIMARY KEY,    -- Unique ID for each product
    product_name TEXT NOT NULL,       -- Name of the product
    quantity INTEGER NOT NULL         -- Current stock count
);
 
-- Create the sales table to track order statuses
CREATE TABLE IF NOT EXISTS sales (
    id SERIAL PRIMARY KEY,            -- Unique transaction ID
    product_id INTEGER REFERENCES inventory(product_id), -- Link to inventory
    status TEXT NOT NULL              -- Current state (e.g., 'Sold', 'Returned')
);
 
-- Insert sample data for testing
INSERT INTO inventory (product_name, quantity) VALUES ('Laptop', 10);
INSERT INTO sales (product_id, status) VALUES (1, 'Sold');
 
---
 
-- STEP 2: The Transactional Procedure
-- This ensures Atomicity: both updates succeed or both fail.
CREATE OR REPLACE PROCEDURE pr_process_item_return(
    p_sale_id INT,        -- Parameter: ID of the sale record
    p_product_id INT      -- Parameter: ID of the product being returned
)
LANGUAGE plpgsql
AS $$                    -- Start of the code block (Dollar-Quoting)
BEGIN
    -- UPDATE 1: Increase Inventory
    -- Increments the stock level to reflect the returned item
    UPDATE inventory 
    SET quantity = quantity + 1 
    WHERE product_id = p_product_id;
 
    -- UPDATE 2: Update Sales Record
    -- Changes the order status so the customer can be refunded
    UPDATE sales 
    SET status = 'Returned' 
    WHERE id = p_sale_id;
 
    -- Finalize the changes
    COMMIT;
 
EXCEPTION
    -- Error Handling: If any line fails, run this block
    WHEN OTHERS THEN
        -- Revert all changes to prevent data corruption
        ROLLBACK;
        RAISE NOTICE 'Transaction failed and was rolled back.';
END;
$$;                      -- Closing the dollar-quoting (This fixes your error!)
 
/* 1. DATA AUDIT QUERY
   This identifies records that are inconsistent. 
   We look for sales marked 'Returned' that might have missed their inventory update.
*/
SELECT 
    s.id AS sale_id,
    s.product_id,
    s.status,
    i.product_name,
    i.quantity AS current_inventory
FROM sales s
JOIN inventory i ON s.product_id = i.product_id
WHERE s.status = 'Returned'; 
-- In a real production environment, you would join against an 'audit_log' 
-- table to see if a +1 quantity increase ever actually occurred for these IDs.
 
---
 
/* 2. DATA FIX (RECONCILIATION)
   This one-time update fixes the records found in the audit.
   We use a Subquery to increase inventory only for products that have 
   returned sales which weren't accounted for.
*/
UPDATE inventory
SET quantity = quantity + (
    SELECT COUNT(*) 
    FROM sales 
    WHERE sales.product_id = inventory.product_id 
    AND sales.status = 'Returned'
)
WHERE product_id IN (
    SELECT product_id 
    FROM sales 
    WHERE status = 'Returned'
);
-- This query synchronizes the inventory count with the total number of returns found in the sales table.
 
SELECT * FROM inventory;
SELECT * FROM sales;