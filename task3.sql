

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


-- not yet delivered, still needs test
/*
SELECT * FROM order_
WHERE date_delivered = 'NULL'
AND date('now') - date_ordered > 15;
*/
SELECT customer_name, street, city postcode, country, order_id as late_order
FROM customer
NATURAL JOIN order_
WHERE order_.date_delivered - order_.date_ordered > 5 ;

SELECT customer_name, street, city postcode, country, date_ordered, date_delivered, order_id as late_order
FROM customer
NATURAL JOIN order_
WHERE order_.date_ordered - order_.date_delivered > 10 ;

CREATE VIEW covid_orders AS
SELECT street, city, postcode, country, date_ordered FROM customer 
NATURAL JOIN phone_customer 
NATURAL JOIN order_
WHERE customer.country = 'England'
AND phone_customer.phone_type = 'business'
ORDER BY order_.date_ordered DESC;

SELECT * FROM covid_order;


--Wales is a small country
SELECT order_id, customer_name, street, city, postcode, country, date_ordered, date_delivered
FROM order_ 
NATURAL JOIN customer
WHERE date_ordered - date_delivered < 4
AND customer.country = 'Wales';