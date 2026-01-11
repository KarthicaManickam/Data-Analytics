--` TRANSACTION with TransactionID INTEGER PRIMARY KEY, Description TEXT NOT NULL, Amount REAL NOT NULL, TransactionDate TEXT NOT NULL, CategoryID INTEGER, Type TEXT CHECK(Type IN ('Income', 'Expense')
CREATE TABLE Categories (
    CategoryID INTEGER PRIMARY KEY,
    CategoryName TEXT NOT NULL UNIQUE
);
CREATE table Transactions (
    TransactionID INTEGER PRIMARY KEY,
    Description TEXT NOT NULL,
    Amount REAL NOT NULL,
    TransactionDate TEXT NOT NULL,
    CategoryID INTEGER,
    Type TEXT CHECK(Type IN ('Income', 'Expense')),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
); 
insert into Categories (CategoryID, CategoryName) values 
(1, 'Salary'),
(2, 'Groceries'),
(3, 'Utilities'),
(4, 'Entertainment'),
(5, 'Transportation');

insert into Transactions (TransactionID, Description, Amount, TransactionDate, CategoryID, Type) values
(1, 'Monthly Salary', 5000.00, '2024-01-01', 1, 'Income'),
(2, 'Grocery Shopping', -150.75, '2024-01-03', 2, 'Expense'),
(3, 'Electricity Bill', -60.50, '2024-01-05', 3, 'Expense'),
(4, 'Movie Tickets', -30.00, '2024-01-07', 4, 'Expense'),
(5, 'Bus Pass', -45.00, '2024-01-10', 5, 'Expense');

SELECT * FROM Transactions;
select * from Categories;

SELECT * FROM Transactions JOIN Categories ON Transactions.CategoryID = Categories.CategoryID 
ORDER BY TransactionDate DESC;

select t.TransactionID,t.Description,t.Amount   ,c.CategoryName,t.Type
from Transactions t
join Categories c on t.CategoryID = c.CategoryID
ORDER BY t.TransactionDate DESC;

update Transactions
set Amount = 1250.00,
    Description = 'Grocery Shopping - Updated',
    TransactionDate = '2024-01-04',
    CategoryID = 2,
    Type = 'Expense'
where TransactionID = 2;
--How much did I spend on 'Food' this month?
SELECT SUM(Amount) AS TotalSpentOnGroceries
FROM Transactions
WHERE CategoryID = 2 AND Type = 'Expense' 
AND strftime('%Y-%m', TransactionDate) = '2024-01';


SELECT
      SUM(Amount) AS TotalSpent
FROM Transactions t
WHERE CategoryID = (
    SELECT CategoryID
    FROM Categories
    WHERE CategoryName = 'Salary'
)
AND Type = 'Expense'
AND strftime('%Y-%m', TransactionDate) = '2024-06';

--Load categories into a dropdown (simulated here with a SELECT statement)
SELECT CategoryID, CategoryName
FROM Categories
ORDER BY CategoryName;