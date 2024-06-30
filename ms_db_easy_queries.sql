/* Question Set 1 - Easy */

## Q1: Find the senior most employee based on job title.
SELECT CONCAT(first_name,' ', last_name) as full_name, title
FROM employee
ORDER BY levels DESC
LIMIT 1;

## Q2: Which Countries have the most invoices?
SELECT
	billing_country,
    COUNT(*) AS total_invoices
FROM invoice
GROUP BY billing_country
ORDER BY total_invoices DESC;

## Q3: What are top 3 values of invoices?
SELECT *
FROM invoice
ORDER BY total DESC
LIMIT 3;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
SELECT
	billing_city,
    SUM(total) AS total_invoices
FROM invoice
GROUP BY billing_city
ORDER BY total_invoices DESC
LIMIT 1;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ROUND(SUM(i.total), 2) AS invoice_total
FROM customer AS c
JOIN invoice AS i
	ON c.customer_id = i.customer_id
GROUP BY customer_name
ORDER BY invoice_total DESC
LIMIT 1