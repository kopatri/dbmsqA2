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