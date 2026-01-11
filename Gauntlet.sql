create table movies (
    movie_id integer PRIMARY KEY,
    title text NOT NULL,
    release_year INT not NULL,
    runtime INT not NULL
);
INSERT INTO movies (movie_id, title, release_year, runtime) VALUES
(1, 'Inception star', 2010, 148),
(2, 'The Dark Knight', 2008, 152),
(3, 'Interstellar', 2014, 169),
(4, 'The Matrix-star', 1999, 136),
(5, 'Pulp Fiction', 1994, 154),
(6, 'The Shawshank Redemption', 1994, 142),
(7, 'The Godfather star', 1972, 175);
select * from movies;
select * from movies where release_year >= 1990 AND release_year < 2000;
select * from movies WHERE Title LIKE '%Star%';
select * from movies ORDER BY runtime DESC LIMIT 3;

create table Actors(
    actor_id integer PRIMARY KEY,
    first_name text NOT NULL,
    last_name text NOT NULL     
);

Insert into actors (actor_id, first_name, last_name) VALUES
(1, 'Leonardo', 'DiCaprio'),
(2, 'Christian', 'Jones'),
(3, 'Matthew', 'McConaughey'),
(4, 'Keanu', 'Jones'),
(5, 'John', 'Travolta'
);
select * from actors where last_name IN ('Jones','DiCaprio');
select * from actors where last_name like '%J%';

