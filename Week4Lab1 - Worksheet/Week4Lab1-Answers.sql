-- DB3 Worksheet mandha1

-- 1. List the titles and prices of all books that have the cheapest price.
SELECT title, price FROM titles
WHERE price IS NOT NULL AND price < 3.00
ORDER BY price

--	2. List all titles that have sold more than 40 copies at a single store.
SELECT t.title, s.qty FROM titles t
JOIN sales s ON t.title_id = s.title_id
WHERE s.qty > 40 

--	3. List all authors who have not published any books.
SELECT * FROM authors a
WHERE a.au_id NOT IN (SELECT ta.au_id FROM titleauthor ta)

--	4. List all the publishers who have published any business books.
SELECT DISTINCT p.pub_name, t.type FROM publishers p
JOIN titles t ON p.pub_id = t.pub_id
WHERE t.type = 'business'

--	5. List all authors who have published a “popular computing” book (thesebooks have type = 'popular_comp' in the titles table).
SELECT ta.au_id, a.au_lname, a.au_fname FROM titleauthor ta
JOIN authors a ON ta.au_id = a.au_id
WHERE ta.title_id IN (SELECT t.title_id FROM titles t
					WHERE t.type = 'popular_comp')

--	6. List all the cities where both an author (or authors) and a publisher (orpublishers) are located.
SELECT DISTINCT a.city FROM authors a
JOIN titleauthor ta ON a.au_id = ta.au_id
JOIN titles t ON ta.title_id = t.title_id
JOIN publishers p ON t.pub_id = p.pub_id
WHERE a.city = p.city

--	7. List all cities where an author, but no publisher, is located.
SELECT DISTINCT a.city FROM authors a
WHERE a.city NOT IN (SELECT city FROM publishers)

--	8. List all titles that have sold no copies.
SELECT * FROM titles t
WHERE t.title_id NOT IN (SELECT s.title_id FROM sales s)

--	9.List the title and total sales of each book whose total sales is less than theaverage totals sales across all books.
SELECT t.title, SUM(s.qty) FROM titles t
JOIN sales s ON s.title_id = t.title_id
GROUP BY t.title
HAVING SUM(s.qty) < (SELECT AVG(sumTable.sumQty) FROM (SELECT SUM(qty) AS sumQty FROM sales
GROUP BY title_id) AS sumTable) 

-- 10. List the publishers, and the number of books each has published, who arenot located in California.
SELECT DISTINCT p.pub_name, COUNT(t.title) FROM publishers p
JOIN titles t ON p.pub_id = t.pub_id
WHERE p.state != 'CA'
GROUP BY p.pub_name

--	11. For each book, list the number of stores where it has been sold.
SELECT DISTINCT t.title, COUNT(ss.stor_id) FROM titles t
JOIN sales s ON t.title_id = s.title_id
JOIN stores ss ON s.stor_id = ss.stor_id
WHERE t.title_id = s.title_id
GROUP BY t.title

--	12. For each book, list its title, the largest quantity of it sold at any one store,and the name of that store.
SELECT DISTINCT t.title, ss.stor_name, MAX(s.qty) FROM titles t
JOIN sales s ON t.title_id = s.title_id
JOIN stores ss ON s.stor_id = ss.stor_id
GROUP BY t.title, ss.stor_name
ORDER BY t.title

-- 13. Increase by two points the royalty rate for all books that have sold more than 30 copies total.
UPDATE roysched SET royalty = royalty + 2
WHERE title_id IN (SELECT s.title_id FROM sales s
						GROUP BY s.title_id
						HAVING SUM(s.qty) > 30)

--	14. List all types of books published by more than one publisher.
SELECT DISTINCT t.type FROM titles t
GROUP BY t.type
HAVING COUNT(DISTINCT t.pub_id) > 1

