create table Venues (
    id Integer PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    event_date DATE NOT NULL,
    tickets_sold INTEGER NOT NULL,
    ticket_price NUMERIC(10, 2) NOT NULL
);

create table Events(
    id Integer PRIMARY KEY,
    venue_id INTEGER REFERENCES Venues(id),
    event_name VARCHAR(100) NOT NULL,
    event_date DATE NOT NULL,
    tickets_sold INTEGER NOT NULL,
    ticket_price NUMERIC(10, 2) NOT NULL
);

INSERT into Venues (id, event_name, event_date, tickets_sold, ticket_price) VALUES
(1, 'Rock Concert', '2024-07-15', 5000, 75.00),
(2, 'Jazz Festival', '2024-08-20', 3000, 60.00),
(3, 'Tech Conference', '2024-09-10', 2000, 150.00),
(4, 'Art Expo', '2024-10-05', 1500, 40.00),
(5, 'Food Carnival', '2024-11-12', 4000, 25.00);

insert into events(id, venue_id, event_name, event_date, tickets_sold, ticket_price) VALUES
(1, 1, 'Rock Concert - Day 1', '2024-07-15', 2500, 75.00),
(2, 1, 'Rock Concert - Day 2', '2024-07-16', 2500, 75.00),
(3, 2, 'Jazz Festival - Evening', '2024-08-20', 3000, 60.00),
(4, 3, 'Tech Conference - Keynote', '2024-09-10', 2000, 150.00),
(5, 4, 'Art Expo - Opening Day', '2024-10-05', 1500, 40.00),
(6, 5, 'Food Carnival - Weekend', '2024-11-12', 4000, 25.00); 

create table tickets(
    id Integer PRIMARY KEY,
    event_id INTEGER REFERENCES Events(id),
    purchaser_name VARCHAR(100) NOT NULL,
    purchase_date DATE NOT NULL,
    seat_number VARCHAR(10) NOT NULL
);

insert into tickets(id, event_id, purchaser_name, purchase_date, seat_number) VALUES
(1, 1, 'Alice Johnson', '2024-06-01', 'A1'),
(2, 1, 'Bob Smith', '2024-06-02', 'A2'),
(3, 2, 'Charlie Brown', '2024-06-03', 'B1'),
(4, 3, 'Diana Miller', '2024-06-04', 'C1'),
(5, 4, 'Ethan Davis', '2024-06-05', 'D1'),
(6, 5, 'Fiona Wilson', '2024-06-06', 'E1'),
(7, 6, 'George Clark', '2024-06-07', 'F1');
select * from Venues;
select * from Events;
select * from tickets;
--all the events happening at a specific venue
select e.event_name,v.event_name as venue_name, e.event_date, t.purchaser_name, t.seat_number
from tickets t
join events e on t.event_id = e.id
join venues v on e.venue_id = v.id
where e.id = 1;

--Who has bought tickets for a specific event?
select t.purchaser_name, t.seat_number, e.event_name, e.event_date
from tickets t
join events e on t.event_id = e.id
where e.event_name = 'Rock Concert - Day 1';

--total revenue from ticket sales for a specific event
select e.event_name, sum(e.ticket_price) as total_revenue
from events e
join tickets t on e.id = t.event_id
where e.event_name = 'Rock Concert - Day 1';

--List all events happening in the next 30 days.
select e.event_name, e.event_date, v.event_name as venue_name
from events e
join venues v on e.venue_id = v.id
where e.event_date between date('2024-01-09') and date('2025-02-08');
--where e.event_date between date(now) and date('NOW','+30DAYS');