

USE sakila;
-- use sakila database 


SHOW TABLES;
-- show all tables in sakila schema


SELECT * FROM actor;
-- view actor table to display the column names


# 1a)
SELECT first_name, last_name FROM actor;
-- displays the first and last names of all actors in table 'actor'



# 1b)
SELECT CONCAT(first_name, ' ', last_name) AS `Actor Name` FROM actor;
-- displays the first and last name of each actor in column 'Actor Name'



# 2a)
SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name = "JOE";
-- displays Joe Swank with actor id 9 as the only actor with the first name Joe



# 2b) 
SELECT CONCAT(first_name, ' ', last_name) AS `Actor Name`
FROM actor
WHERE last_name LIKE '%GEN%';
-- displays actors with the letters GEN in their last name



# 2c)
SELECT CONCAT(first_name, ' ', last_name) AS `Actor Name`
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;
-- displays all actors who last names contain the letters LI and ordered by last name and first name



# 2d)
SELECT country_id, country
FROM country 
WHERE country IN('Afghanistan', 'Bangladesh', 'China');
-- displays the country id for the Afghanistan, Bangladesh, and China



# 3a)
ALTER TABLE actor
ADD description BLOB;
-- add a column for actor description in the table actor



# 3b)
ALTER TABLE actor
DROP COLUMN description; 
-- delete the description column in the table actor



# 4a)
SELECT last_name AS `Last Name`, COUNT(last_name) AS `Number of Actors`
FROM actor 
GROUP BY last_name;
-- lists the last names of actors and count of actors with that last name



# 4b)
SELECT last_name AS `Last Name`, COUNT(last_name) AS `Number of Actors`
FROM actor 
GROUP BY last_name 
HAVING `Number of Actors` >= 2; 
-- lists the last names of actors and the count of actors (at least 2)



# 4c)
UPDATE actor 
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';
-- fixes the record with actor HARPOL WILLIAMS to GROUCHO WILLIAMS



# 4d)
UPDATE actor 
SET first_name = 'HARPO' 
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
-- changes back actor record GROUCHO WILLIAMS back to HARPO WILLIAMS



# 5a)
SHOW CREATE TABLE address;
-- displays the scheme of the address table



# 6a)
SELECT staff.first_name, staff.last_name, address.address
FROM staff INNER JOIN address
ON staff.address_id = address.address_id;
-- displays the staff's first and last name and their address



# 6b) 
SELECT staff.first_name, staff.last_name, COUNT(payment.payment_id) AS `Number of Payments`
FROM staff INNER JOIN payment 
ON staff.staff_id = payment.staff_id
GROUP BY payment_date = '2005-08%';



# 6c)
SELECT film.title AS `Film Title`, count(film_actor.actor_id) AS `Number of Actors`
FROM film INNER JOIN film_actor 
ON film.film_id = film_actor.film_id
GROUP BY film_actor.actor_id;
-- lists the number of actors in each film 



# 6d)
SELECT film.title, COUNT(inventory.inventory_id) AS `Count` 
FROM inventory INNER JOIN film
ON inventory.film_id = film.film_id 
WHERE film.title = 'HUNCHBACK IMPOSSIBLE';
-- lists the number of copies of the film Hunchback Impossible in the inventory system 



# 6e) 
SELECT c.first_name AS `First Name`, c.last_name AS `Last Name`, SUM(p.amount) AS `Total Amount Paid`
FROM payment AS P INNER JOIN customer AS c
ON p.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;
-- list of total paid by each customer and listed alphabetically by last name



# 7a)
SELECT title 
FROM film
WHERE language_id IN(
					SELECT language_id 
					FROM `language`
					WHERE `language`.`name` = 'English')
		AND (title LIKE 'K%' OR title LIKE 'Q%');
-- display title of movies starting with letters K and Q whose language is English



# 7b)
SELECT first_name AS `First Name`, last_name AS `Last Name`
FROM actor 
WHERE actor_id IN(
				SELECT actor_id FROM film_actor 
				WHERE film_id IN(
								SELECT film_id FROM film 
								WHERE title = 'ALONE TRIP'));
-- displays all the actors who appear in the film Alone Trip




# 7c)
SELECT cust.first_name, cust.last_name, cust.email
FROM customer as cust, address, city, country
WHERE country = 'Canada' AND country.country_id = city.country_id
	AND city.city_id = address.city_id AND cust.address_id = address.city_id;
-- displays the names and email addresses of all Canadian customers 




# 7d) 
SELECT film.title
FROM film
	INNER JOIN film_category 
		ON film_category.film_id = film.film_id 
	INNER JOIN category 
		ON category.category_id = film_category.category_id
		WHERE category.`name` = 'FAMILY';
-- displays all movies categorized as family films



# 7e)
SELECT title, rental_duration
FROM film
ORDER BY rental_duration DESC;
-- displays the most frequently rented movies in descending order 



# 7f) 
SELECT * FROM store;
-- displays the store_id (1 or 2), address_id
SELECT * FROM staff;
-- displays the staff_id, address_id 
SELECT * FROM rental;
-- displays the staff_id, rental_id
SELECT * FROM payment;
-- displays the staff_id, rental_id, amount

CREATE VIEW revenue_table AS
SELECT staff_id, SUM(amount) AS Revenue
FROM payment 
GROUP BY staff_id;

SELECT staff.store_id AS Store, revenue_table.Revenue
FROM revenue_table
INNER JOIN rental
	ON revenue_table.staff_id = rental.staff_id 
INNER JOIN staff 
	ON staff.staff_id = rental.staff_id
GROUP BY staff.staff_id;
-- displays how much business, in dollars, each brought in


# 7g)

SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address
	ON store.address_id = address.address_id
INNER JOIN city 
	ON address.city_id = city.city_id
INNER JOIN country 
	ON city.country_id = country.country_id;
-- display the store id, city, and country for each store



# 7h)

SELECT category.`name` AS Genre, SUM(payment.amount) AS `Gross Revenue`
FROM category
INNER JOIN film_category
	ON category.category_id = film_category.category_id
INNER JOIN inventory
	ON film_category.film_id = inventory.film_id 
INNER JOIN rental
	ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment 
	ON rental.rental_id = payment.rental_id
GROUP BY category.`name`
ORDER BY `Gross Revenue` DESC
LIMIT 5;
-- lists the top five genres in gross revenue in descending order 



# 8a)

CREATE VIEW top_five_genres AS 
SELECT category.`name` AS Genre, SUM(payment.amount) AS `Gross Revenue`
FROM category
INNER JOIN film_category
	ON category.category_id = film_category.category_id
INNER JOIN inventory
	ON film_category.film_id = inventory.film_id 
INNER JOIN rental
	ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment 
	ON rental.rental_id = payment.rental_id
GROUP BY category.`name`
ORDER BY `Gross Revenue` DESC
LIMIT 5;
-- create a view of the lists the top five genres in gross revenue in descending order 



# 8b)

SELECT * FROM top_five_genres;
-- lists the top five genres in gross revenue in descending order 


# 8c)

DROP VIEW top_five_genres;
-- deleting the view of top_five_genres 