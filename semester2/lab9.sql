--1
DROP VIEW IF EXISTS films_actors;
CREATE VIEW films_actors AS
    SELECT title,
           concat(first_name, ' ', last_name) AS actor
    FROM film
        INNER JOIN film_actor USING(film_id)
        INNER JOIN actor USING(actor_id)
        ORDER BY title;
SELECT * FROM films_actors;

--2
CREATE OR REPLACE VIEW films_actors AS
    SELECT title,
           concat(first_name, ' ', last_name) AS actor,
           count(inventory.film_id) AS dvd
    FROM film
        INNER JOIN inventory USING(film_id)
        INNER JOIN film_actor USING(film_id)
        INNER JOIN actor USING(actor_id)
        GROUP BY title,
                 concat(first_name, ' ', last_name)
        ORDER BY title;
SELECT * FROM films_actors;

--3
DROP VIEW IF EXISTS films_lang;
CREATE VIEW films_lang AS
    SELECT title,
           name
    FROM film
        INNER JOIN language USING (language_id)
        WHERE name = 'English';
CREATE RULE films_lang_update AS
    ON UPDATE TO films_lang DO INSTEAD UPDATE film
        SET title = NEW.title
        WHERE title = 'Chamber Italian';
SELECT * FROM films_lang;
UPDATE films_lang
    SET title = 'Chamber Italian'
    WHERE title = 'Chamber Italian';

--4
DROP VIEW IF EXISTS customer_country;
CREATE VIEW customer_country AS
    SELECT first_name,
           last_name
    FROM customer AS cust
    WHERE address_id IN (
        SELECT address_id
        FROM address
            INNER JOIN city USING (city_id)
            INNER JOIN country USING (country_id)
            WHERE country = 'United States'
        );
SELECT * FROM customer_country;
UPDATE customer_country
    SET first_name = 'Zachary'
    WHERE first_name = 'Zachary';

--5
DROP VIEW IF EXISTS stuff_cte;
CREATE VIEW stuff_cte AS (
    WITH CTE AS (
        SELECT first_name,
               last_name,
               address.address,
               city.city,
               country.country
        FROM staff
            INNER JOIN address USING (address_id)
            INNER JOIN city USING (city_id)
            INNER JOIN country USING (country_id)
    )
    SELECT * FROM CTE
);
SELECT * FROM stuff_cte;