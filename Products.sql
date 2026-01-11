create TABLE products(
    ProductID integer PRIMARY KEY,
    ProductName varchar(100),
    Category varchar(100),
    Price numeric(10,2),
    Stock integer
   );
INSERT INTO products (ProductID, ProductName, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 999.99, 10),
(2, 'Wire', 'Electricals', 499.99, 25),
(3, 'Tablet', 'Electronics', 299.99, 15),
(4, 'Glass cup', 'Cutlery', 89.99, 50),
(5, 'Smartwatch', 'Electronics', 199.99, 30);

select * from products;
select * from products where Category='Electronics';
Update products
SET Price = Price -50.00
WHERE Category='Electronics';

CREATE TABLE user_accounts (
    user_id Integer PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);
INSERT INTO user_accounts (user_id, username, email, is_active) VALUES
(1, 'user_one', 'user_one@example.com', TRUE),
(2, 'user_two', 'user_two@example.com', TRUE),
(3, 'user_three', 'user_three@example.com', FALSE);

SELECT * FROM user_accounts;
select * from user_accounts where is_active=TRUE;
delete from user_accounts where is_active=FALSE;

select username, count(*) as count from user_accounts
group by username
having count(*)>0;

INSERT INTO user_accounts (user_id, username, email, is_active) VALUES
(3, 'user_one', 'user_one@example.com', FALSE);
