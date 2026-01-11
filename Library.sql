-- Enable foreign key enforcement (important in SQLite)
PRAGMA foreign_keys = ON;

CREATE TABLE Books (
    BookID INTEGER PRIMARY KEY,   
    -- Title of the book (required)
    Title TEXT NOT NULL,    
    -- Author of the book
    Author TEXT NOT NULL,    
    -- ISBN number (must be unique)
    ISBN TEXT NOT NULL UNIQUE
);


CREATE TABLE Members (
    MemberID INTEGER PRIMARY KEY,    
    -- Full name of the member
    Name TEXT NOT NULL,    
    -- Email address (must be unique)
    Email TEXT NOT NULL UNIQUE
);

CREATE TABLE Loans (
    LoanID INTEGER PRIMARY KEY,    
    -- Foreign key to the borrowed book
    BookID INTEGER NOT NULL,    
    -- Foreign key to the member who borrowed the book
    MemberID INTEGER NOT NULL,    
    -- Date the book is due to be returned
    DueDate TEXT NOT NULL,    
    -- Enforce relationships
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);
INSERT INTO Books (Title, Author, ISBN)
VALUES
    ('1984', 'George Orwell', '9780451524935'),
    ('To Kill a Mockingbird', 'Harper Lee', '9780061120084'),
    ('The Hobbit', 'J.R.R. Tolkien', '9780547928227');
INSERT INTO Members (Name, Email)
VALUES
    ('Alice Johnson', 'alice.johnson@example.com'),
    ('Bob Smith', 'bob.smith@example.com');
INSERT INTO Loans (BookID, MemberID, DueDate)
VALUES
    (1, 1, '2026-01-20'),
    (3, 2, '2026-01-25');
SELECT * FROM Books;
SELECT * FROM Members;
SELECT * FROM Loans;

--------------------------
PRAGMA FOREIGN_KEYS = ON;
 
CREATE TABLE Venues (
    VenueID INT PRIMARY KEY,
    VenueName TEXT NOT NULL,
    Capacity INT CHECK (Capacity > 0)  
);
 
CREATE TABLE Events (
    EventID INT PRIMARY KEY,
    EventName TEXT NOT NULL,
    EventDate TEXT,
    VenueID INT NOT NULL,
    FOREIGN KEY (VenueID) REFERENCES Venues(VenueID)
);
 
CREATE TABLE Tickets (
    TicketID INT PRIMARY KEY,
    EventID INT NOT NULL,
    CustomerEmail TEXT,
    Price REAL CHECK (Price >= 0),
    FOREIGN KEY (EventID) REFERENCES Events(EventID)
);
 
--insert venue
INSERT INTO Venues (VenueID, VenueName, Capacity) VALUES
(1, 'Grand Hall', 500);
--insert event
INSERT INTO Events (EventID, EventName, EventDate, VenueID) VALUES
(1, 'Rock Concert', '2024-09-15', 1);  
--insert ticket
INSERT INTO Tickets (TicketID, EventID, CustomerEmail, Price) VALUES
(1, 1, 'customer@example.com', 50.00);
 
SELECT * FROM Venues;
SELECT * FROM Events;
SELECT * FROM Tickets;
 
--insert invalid ticket with negative price
INSERT INTO Tickets (TicketID, EventID, CustomerEmail, Price) VALUES
(2, 1, 'customer2@example.com', -10.00);
 
--insert event with non-existent venue
INSERT INTO Events (EventID, EventName, EventDate, VenueID) VALUES  
(2, 'Jazz Night', '2024-10-20', 999);
 
--invalid capacity for venue
INSERT INTO Venues (VenueID, VenueName, Capacity) VALUES
(2, 'Small Club', -50);

