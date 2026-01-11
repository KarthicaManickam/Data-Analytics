create table Articles(
    ArticleID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Content TEXT NOT NULL,
    Author VARCHAR(100),
    PublishedDate text NOT NULL,    
    IsFavourite integer DEFAULT 0
);
INSERT  into Articles(ArticleID,Title,Content,Author,PublishedDate,IsFavourite) VALUES
(1,'The Rise of AI','Content about AI...','Alice Smith','2024-01-15',0),
(2,'Climate Change Impacts','Content about Climate Change...','Bob Johnson','2024-02-20',1),
(3,'Advancements in Renewable Energy','Content about Renewable Energy...','Carol White','2024-03-10',0);

SELECT * FROM Articles;

SELECT * FROM Articles ORDER BY PublishedDate DESC;
UPDATE Articles SET IsFavourite = 1 WHERE ArticleID = 3;
SELECT * FROM Articles where IsFavourite = 1 ORDER BY PublishedDate DESC;   