/* Question Set 2 - Moderate */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */
SELECT 
    c.first_name AS FirstName,
    c.last_name AS LastName,
    g.name AS GenreName,
    c.email AS Email
FROM customer c
JOIN invoice i 
	ON c.customer_id = i.customer_id
JOIN invoice_line il
	ON il.invoice_id = i.invoice_id
JOIN track t
	ON t.track_id = il.track_id
JOIN genre g 
	ON g.genre_id = t.genre_id
WHERE g.name = 'Rock'
GROUP BY c.first_name, c.last_name, c.email, g.name
ORDER BY email;

## 2nd Method
SELECT 
	c.first_name AS FirstName,
    c.last_name AS LastName,
    c.email AS Email
FROM customer c 
JOIN invoice i 
	ON c.customer_id = i.customer_id
JOIN invoice_line il
	ON il.invoice_id = i.invoice_id
WHERE track_id IN (
		SELECT track_id
		FROM genre g
        JOIN track t
			ON t.genre_id = g.genre_id
		WHERE g.name LIKE 'Rock'
)
GROUP BY FirstName, LastName, Email
ORDER BY c.email;

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */
SELECT 
	a.name,
    COUNT(a.artist_id) AS number_of_songs
FROM artist a 
JOIN album2 al
	ON a.artist_id = al.artist_id
JOIN track t 
	ON t.album_id = al.album_id
WHERE t.track_id IN (
	SELECT track_id
	FROM genre g 
	JOIN track t
		ON g.genre_id = t.genre_id
	WHERE g.name LIKE 'Rock'
)
GROUP BY a.name
ORDER BY a.name;

## 2nd method
SELECT 
	a.name,
    COUNT(a.artist_id) AS number_of_songs
FROM artist a 
JOIN album2 al
	ON a.artist_id = al.artist_id
JOIN track t 
	ON t.album_id = al.album_id
JOIN genre g 
	ON g.genre_id = t.genre_id
WHERE g.name = 'Rock'
GROUP BY a.name
ORDER BY number_of_songs DESC
LIMIT 10;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */
SELECT
	name,
    milliseconds,
    milliseconds*0.001 AS seconds,
    ROUND((milliseconds/1000)/60, 2) AS minutes
FROM track
WHERE milliseconds > (
	SELECT 
		AVG(milliseconds)
	FROM track
)
GROUP BY name, milliseconds, seconds
ORDER BY milliseconds DESC;

