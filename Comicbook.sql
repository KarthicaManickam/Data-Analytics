create table Comics (
    ComicID INTEGER PRIMARY KEY,
    Title TEXT NOT NULL,
    IssueNumber INTEGER NOT NULL,
    Publisher TEXT NOT NULL,
    Cost REAL NOT NULL,
    Price REAL NOT NULL
);
create table Sales (
    SaleID INTEGER PRIMARY KEY,
    SaleDate TEXT NOT NULL
);
create table SaleItems (
    SaleID INTEGER,
    ComicID INTEGER,
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID),
    FOREIGN KEY (ComicID) REFERENCES Comics(ComicID),
    PRIMARY KEY (SaleID, ComicID)
);
insert into Comics (ComicID, Title, IssueNumber, Publisher, Cost, Price) values
(1, 'The Amazing Spider Man', 1, 'Marvel', 0.10, 0.25),
(2, 'Batman', 1, 'DC', 0.15, 0.30),
(3, 'Superman', 1, 'DC', 0.12, 0.28);
insert into Sales (SaleID, SaleDate) values
(1, '2023-10-01'),
(2, '2023-10-02');
insert into SaleItems (SaleID, ComicID) values
(1, 1),
(1, 2),
(2, 3);
select * from Comics;
select * from Sales;
select * from SaleItems;

SELECT * FROM Comics WHERE Title LIKE '%Amazing%';

begin TRANSACTION;
INSERT into sales(SaleID, SaleDate) values (3, '2023-10-03');
insert into SaleItems(SaleID, ComicID) values (3, 1), (3, 3);   
commit;

--inventory value report
SELECT 
    SUM(Cost) AS Total_Cost,
    SUM(Price) AS Total_Price,
    SUM(Price) - SUM(Cost) AS Total_Profit
FROM Comics;

--count how manytimes each comic has been sold
SELECT 
    c.Title,
    COUNT(si.ComicID) AS Times_Sold 
FROM SaleItems si
JOIN Comics c ON si.ComicID = c.ComicID
GROUP BY c.Title
ORDER BY Times_Sold DESC;