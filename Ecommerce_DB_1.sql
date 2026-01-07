CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100)
);
CREATE TABLE Products (
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(100),
    Price NUMERIC(10,2)
);
CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID),
    OrderDate DATE
);
CREATE TABLE OrderDetails (
    OrderDetailID SERIAL PRIMARY KEY,
    OrderID INT REFERENCES Orders(OrderID),
    ProductID INT REFERENCES Products(ProductID),
    Quantity INT
);

INSERT INTO Customers (CustomerName, Email) VALUES
('John Smith', 'john@example.com'),
('Jane Doe', 'jane@example.com');

INSERT INTO Products (ProductName, Price) VALUES
('Laptop', 800.00),
('Mobile Phone', 500.00),
('Headphones', 100.00);

INSERT INTO Orders (CustomerID, OrderDate) VALUES
(1, '2024-01-10'),
(2, '2024-01-15');

INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1);

select * from Orders;
select * from Orderdetails;
select * from customers;
select * from products;
select * from ProductCategories;

CREATE TABLE ProductCategories (
    CategoryID SERIAL PRIMARY KEY,
    CategoryName VARCHAR(100)
);

INSERT INTO ProductCategories (CategoryName) VALUES
('Electronics'),
('Clothing'),
('Books'),
('Accessories');

ALTER TABLE Products
ADD COLUMN CategoryID INT;

UPDATE Products
SET CategoryID = 1
WHERE ProductName IN ('Laptop', 'Mobile Phone');

UPDATE Products
SET CategoryID = 4
WHERE ProductName = 'Headphones';

UPDATE Products
SET CategoryID = 2
WHERE ProductName IN ('T-Shirt', 'Jeans');

UPDATE Products
SET CategoryID = 3
WHERE ProductName = 'Novel';

SELECT
    pc.CategoryName,
    SUM(p.Price * od.Quantity) AS TotalRevenue
FROM ProductCategories pc
JOIN Products p
    ON pc.CategoryID = p.CategoryID
JOIN OrderDetails od
    ON p.ProductID = od.ProductID
GROUP BY pc.CategoryName
ORDER BY TotalRevenue DESC;


----top 5 customers by total spending

SELECT
    c.CustomerID,
    c.CustomerName,
    SUM(p.Price * od.Quantity) AS TotalSpending
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpending DESC
LIMIT 5;

---average number of items per order
SELECT
    AVG(order_item_count) AS avg_items_per_order
FROM (
    SELECT
        OrderID,
        SUM(Quantity) AS order_item_count
    FROM OrderDetails
    GROUP BY OrderID
) sub;

--- List all products that have never been ordered
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN OrderDetails od
    ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL;

---- Stored Proceddure

CREATE PROCEDURE sp_GetCustomerOrders(
IN p_CustomerID INT
)
Language plpgsql
AS $$
BEGIN
	RAISE NOTICE 'Searcing for orders belonging to CustomerID:%',p_CustomerID;
	perform c.CustomerName,o.orderID
	from customers c
	join orders o on c.customerID=o.customerID
	where c.customerid=p_customerID;
END;
$$

CALL sp_GetCustomerOrders(1)
CALL sp_GetCustomerOrders(2)

CREATE TABLE OrderItems (
    ItemID INT PRIMARY KEY,
    OrderID INT,
    ProductName VARCHAR(50),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

select * from OrderItems;
select * from Orders;

BEGIN;
INSERT into Orders values(201,1,'2023-11-01');
INSERT into OrderItems values(501,201,'Mouse',1),(502,201,'Mousepad',1);
select * from OrderItems;
commit;
select * from Orders where orderID=201;
select * from OrderItems where orderID=201;


-- Start a new transaction block
BEGIN;
 
-- Step 1: Insert a different order record
INSERT INTO Orders VALUES (999, 2,'2023-11-02');
 
-- Step 2: Insert the items
INSERT INTO OrderItems (ItemID, OrderID, ProductName, Quantity)
VALUES (801, 999, 'Monitor', 1);
 
-- Step 3: Decide to discard all changes made since 'BEGIN'
ROLLBACK;
 
-- VERIFICATION: Run these. You will see NO rows for Order 999.
-- It is as if the INSERT statements never happened.
SELECT * FROM Orders WHERE OrderID = 999;
SELECT * FROM OrderItems WHERE OrderID = 999;