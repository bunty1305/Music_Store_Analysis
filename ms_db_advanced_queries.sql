/* Question Set 3 - Advance */

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

/* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
for each artist. */

 WITH best_selling_artist AS (
	SELECT
		ar.artist_id,
		ar.name AS artist_name,
		ROUND(SUM(il.unit_price*il.quantity), 2) AS total_price
	FROM artist ar 
	JOIN album2 al
		ON ar.artist_id = al.artist_id
	JOIN track t 
		ON t.album_id = al.album_id
	JOIN invoice_line il
		ON il.track_id = t.track_id
	GROUP BY artist_id, artist_name
    ORDER BY total_price DESC
    LIMIT 1
)
SELECT
	c.first_name,
    c.last_name,
    bsa.artist_name,
    ROUND(SUM(il.unit_price*il.quantity),2) AS total_amount
FROM customer c 
JOIN invoice i 
	ON c.customer_id = i.customer_id
JOIN invoice_line il
	ON il.invoice_id = i.invoice_id
JOIN track t
	ON t.track_id = il.track_id
JOIN album2 al 
	ON al.album_id = t.album_id
JOIN best_selling_artist bsa
	ON bsa.artist_id = al.artist_id
GROUP BY 1, 2, 3
ORDER BY total_amount DESC;

/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

/* Steps to Solve:  There are two parts in question- first most popular music genre and second need data at country level. */

/* Method 1: Using CTE */
WITH popular_genre AS (
	SELECT
		g.genre_id,
        g.name,
        i.billing_country,
        COUNT(i.billing_country) AS purchases,
        ROW_NUMBER() OVER(PARTITION BY i.billing_country ORDER BY COUNT(i.billing_country) DESC) AS row_no
	FROM invoice i
    JOIN invoice_line il
		ON il.invoice_id = i.invoice_id
	JOIN track t 
		ON t.track_id = il.track_id
	JOIN genre g 
		ON g.genre_id = t.genre_id
	GROUP BY 1, 2, 3
    ORDER BY 3 , 4 DESC
)
SELECT
	*
FROM popular_genre
WHERE row_no <= 1;

/* Method 2: Using Recursive */
WITH RECURSIVE
	sales_per_country AS (
		SELECT 
			g.genre_id,
			g.name,
			i.billing_country AS country,
			COUNT(i.billing_country) AS purchases
		FROM invoice i
		JOIN invoice_line il
			ON il.invoice_id = i.invoice_id
		JOIN track t 
			ON t.track_id = il.track_id
		JOIN genre g 
			ON g.genre_id = t.genre_id
		GROUP BY 1, 2, 3
        ORDER BY 3
    ),
    max_genre_per_country AS (
		SELECT 
			MAX(purchases) AS purchases_per_country,
            country
		FROM sales_per_country
        GROUP BY 2
        ORDER BY 2
    )
SELECT 
	spc.*
FROM sales_per_country spc
JOIN max_genre_per_country mgpc
	ON spc.country = mgpc.country
WHERE spc.purchases = mgpc.purchases_per_country;

/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

/* Steps to Solve:  Similar to the above question. There are two parts in question- 
first find the most spent on music for each country and second filter the data for respective customers. */

WITH country_sales AS (
	SELECT 
		c.first_name,
        c.last_name,
		i.billing_country AS country,
        SUM(i.total) AS total_amount,
        ROW_NUMBER() OVER(PARTITION BY i.billing_country ORDER BY SUM(i.total) DESC) AS row_no
	FROM invoice i
    JOIN customer c 
		ON c.customer_id = i.customer_id
	GROUP BY 1, 2, 3
    ORDER BY 3, 5 
)
SELECT *
FROM country_sales
WHERE row_no <= 1;
    