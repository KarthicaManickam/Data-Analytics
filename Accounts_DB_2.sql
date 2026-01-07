-- 1. Create the Accounts table
CREATE TABLE Accounts (
    AccountName VARCHAR(1) PRIMARY KEY,
    Balance DECIMAL(10,2)
);
 
-- 2. Insert starting balances
INSERT INTO Accounts (AccountName, Balance) VALUES ('A', 1000.00), ('B', 500.00);
 
-- 3. Verify starting state
SELECT * FROM Accounts;

update accounts set balance = balance-100 where accountname='A';

update accounts set balance = 1000 where accountname='A';
update accounts set balance = 500 where accountname='B';

-- Start Transaction
BEGIN;
-- Deduct from A--
UPDATE Accounts SET Balance = Balance - 100 WHERE Accountname = 'A';
-- Add to B--
UPDATE Accounts SET Balance = Balance + 100 WHERE Accountname = 'B';

COMMIT;

ROLLBACK;
 
SELECT * FROM Accounts;


 

 
