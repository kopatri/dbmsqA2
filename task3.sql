--Query 1
SELECT * FROM book NATURAL JOIN genre 
WHERE book.publisher = "Ultimate Books" 
AND genre.genre_description = "Science and Technology";

--Query 2
SELECT * FROM order_
WHERE city = "Edinburgh" AND date_ordered > '2015-12-31'
ORDER BY date_ordered DESC;

--Query 3
SELECT book_id, book_edition, book_type, quantity_in_stock, supply_price, supplier_id, account_no 
FROM edition_ 
NATURAL JOIN supplies 
NATURAL JOIN supplier 
WHERE quantity_in_stock < 5 
GROUP BY book_id
HAVING MIN (supply_price);
/*Own queries*/
--Own Query 1 - Business Contact from England
/*
SELECT * FROM customer NATURAL JOIN phone_customer
WHERE customer.country = 'England'
AND phone_customer.phone_type = 'business';
*/

--Own Query 2 - Late deliveries
/*
SELECT * FROM order_ 
WHERE date_ordered - date_delivered < 2;
*/

--Own Query 2 - Late deliveres in Wales
/*
SELECT * FROM order_ NATURAL JOIN customer
WHERE date_ordered - date_delivered < 4
AND customer.country = 'Wales';
*/

--high margin
/*
SELECT * FROM edition_ NATURAL JOIN supplies
WHERE edition_.price - supplies.supply_price > 5
ORDER BY edition_.quantity_in_stock;
*/
-- ORDER BY supplies.supply_price

-- not yet delivered, still needs test
/*
SELECT * FROM order_
WHERE date_delivered = NULL
AND date('now') - date_ordered > 15;
*/