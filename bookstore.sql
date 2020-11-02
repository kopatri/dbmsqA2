/*
 Usage:
 - To connect to a transient in-memory database:
 
 sqlite3 --init bookstore.sql
 
 - To connect to a named database:
 
 sqlite3 <name.db> --init bookstore.sql
 */
.mode column
.headers on
.width 18 18 18 18 -- enforce foreign keys check
PRAGMA foreign_keys = TRUE;

-- Uncomment the DROP command below if you need to reset an existing
-- database. Tables are listed in the order which allows to drop them
-- without breaking foreign key constraints.
--
-- book_id barcode generator: https://generate.plus/en/number/isbn  https://www.random.org/strings/
/*
 DROP table order_;
 DROP table customer;
 DROP table phone_customer;
 DROP table review;
 DROP table book;
 DROP table genre;
 DROP table edition_;
 DROP table contains;
 DROP table supplies;
 DROP table supplier;
 DROP table phone_supplier;
 */
----------------------------------------------------------------------
-- Declarations
----------------------------------------------------------------------
CREATE TABLE customer (
  customer_id CHAR(10),
  customer_name VARCHAR(50),
  email VARCHAR(50),
  street VARCHAR(50),
  city VARCHAR(50),
  postcode VARCHAR(30),
  country VARCHAR(30),
  PRIMARY KEY (customer_id)
);

CREATE TABLE order_ (
  order_id CHAR(10),
  street VARCHAR(50),
  city VARCHAR(50),
  postcode VARCHAR(30),
  country VARCHAR(50),
  date_ordered DATE NOT NULL,
  date_delivered DATE NOT NULL,
  customer_id CHAR(10),
  PRIMARY KEY (order_id),
  FOREIGN KEY (customer_id) REFERENCES customer
);


CREATE TABLE phone_customer(
  customer_id CHAR(10),
  phone_type VARCHAR(10),
  phone_number VARCHAR(30),
  PRIMARY KEY (customer_id, phone_type, phone_number),
  FOREIGN KEY (customer_id) REFERENCES customer
);

CREATE TABLE review(
  customer_id CHAR(10),
  book_id CHAR(13),
  rating VARCHAR(1),
  PRIMARY KEY (customer_id, book_id),
  FOREIGN KEY (customer_id) REFERENCES customer,
  FOREIGN KEY (book_id) REFERENCES book
);

CREATE TABLE book(
  book_id CHAR(13),
  title VARCHAR(50),
  author VARCHAR(50),
  publisher VARCHAR(50),
  PRIMARY KEY (book_id)
);

CREATE TABLE genre(
  book_id CHAR(13),
  genre_description VARCHAR(50),
  PRIMARY KEY (book_id, genre_description),
  FOREIGN KEY (book_id) REFERENCES book
);

CREATE TABLE supplier(
  supplier_id CHAR(10),
  supplier_name VARCHAR(50),
  account_no VARCHAR(10),
  PRIMARY KEY (supplier_id)
);

CREATE TABLE phone_supplier(
  supplier_id CHAR(10),
  phone VARCHAR(30),
  PRIMARY KEY (supplier_id),
  FOREIGN KEY (supplier_id) REFERENCES supplier
);

CREATE TABLE edition_ (
  book_id CHAR(13),
  book_edition VARCHAR(20),
  book_type VARCHAR(9), -- (check type)
  price NUMERIC(4, 2),
  quantity_in_stock INTEGER,
  PRIMARY KEY (book_id, book_edition, book_type),
  FOREIGN KEY (book_id) REFERENCES book
);

CREATE TABLE contains (
  book_id CHAR(13),
  order_id CHAR (10),
  book_edition VARCHAR(20),
  book_type VARCHAR(9),
  PRIMARY KEY (book_id, order_id, book_edition, book_type),
  FOREIGN KEY (order_id) REFERENCES order_,
  FOREIGN KEY (book_id, book_edition, book_type) REFERENCES edition_(book_id, book_edition, book_type)
);

CREATE TABLE supplies (
  book_id CHAR(13),
  supplier_id CHAR(10),
  book_edition VARCHAR(20),
  book_type VARCHAR(9),
  supply_price NUMERIC(4, 2),
  PRIMARY KEY (book_id, supplier_id,book_edition, book_type),
  FOREIGN KEY (supplier_id) REFERENCES supplier,
  FOREIGN KEY (book_id, book_edition, book_type) REFERENCES edition_(book_id, book_edition, book_type)
);

----------------------------------------------------------------------
-- Test data
----------------------------------------------------------------------

INSERT INTO customer
VALUES
  ('CU12345678','Mike Miller','mikemiller@gmail.com','2Waterloo','Edinburgh','EH1 3EG','Scotland'),
  ('CU11111111','Franz Ferdinand','franzf@gmail.com','4 Waterloo Street','Edinburgh','EH1 3EG','Scotland'),
  ('CU22222222','Lisa McDoll','lisa@mcdoll.com','42 Lyon Street','Edinburgh','EH1 3EG','Scotland'),
  ('CU33333333','Brennan White','BrennanWhite@dayrep.com','50 Scrimshire Lane','SHWICKEN','PE32 7YH','Scotland'),
  ('CU44444444','Leonardo McMillan','LeonardoMcMillan@armyspy.com','15 Freezeland Lane','CRAIG','PKA19 0NS','Wales'),
  ('CU55555555','Franciszek Thompson','FranciszekThompson@hotmail.com','56 Ash Lane','YSBYTY IFAN','LL24 9BT','Wales'),
  ('CU66666666','Kenzie Bruce','KenzieBruce@hotmail.com','15 Jubilee Drive','CATTON','NR6 8SU','England'),
  ('CU77777777','Maciej Jones','MaciejJones@armyspy.com','76 Golf Road','SWINTON','YO17 3HX','England'),
  ('CU88888888','Ahmed Robertson','AhmedRobertson@rhyta.com','65 Rowland Rd','ORMISCAIG','IV22 6FL','England'),
  ('CU99999999','Zac Findlay','ZacFindlay@hotmail.com','78 High Street','ASHBY FOLVILLE','LE14 0JY','England');

INSERT INTO order_
VALUES
  ('OR12345678','2 Waterloo','Edinburgh','EH1 3EG','Scotland','2016-01-01','2016-01-05','CU12345678'),
  ('OR11111111','4 Waterloo Street','Edinburgh','EH1 3EG','Scotland','2019-04-04','2019-04-07','CU11111111'),
  ('OR22222222','42 Lyon Street','Edinburgh','EH1 3EG','Scotland','2020-08-11','2020-08-14','CU22222222'),
  ('OR33333333','50 Scrimshire Lane','SHWICKEN','PE32 7YH','Scotland','2017-12-12','2017-12-15','CU33333333'),
  ('OR44444444','15 Freezeland Lane','CRAIG','PKA19 0NS','Wales','2019-10-11','2017-10-16','CU44444444'),
  ('OR55555555','56 Ash Lane','YSBYTY IFAN','LL24 9BT','Wales','2020-01-29','2020-02-05','CU55555555'),
  ('OR66666666','15 Jubilee Drive','CATTON','NR6 8SU','England','2020-05-29','2020-06-06','CU66666666'),
  ('OR77777777','76 Golf Road','SWINTON','YO17 3HX','England','2020-07-19','2020-07-26','CU77777777'),
  ('OR88888888','65 Rowland Rd','ORMISCAIG','IV22 6FL','England','2020-07-23','2020-07-29','CU88888888'),
  ('OR99999999','78 High Street','ASHBY FOLVILLE','LE14 0JY','England','2020-07-29','2020-08-09','CU99999999');

 INSERT INTO phone_customer
VALUES
  ('CU12345678', 'private', '+4413 1608 1133'), 
  ('CU11111111', 'business', '+4477 1112 5810'), 
  ('CU22222222', 'business', '+4479 2310 7845'), 
  ('CU33333333', 'private', '+4478 2108 1899'), 
  ('CU44444444', 'business', '+4478 1111 7876'), 
  ('CU55555555', 'private', '+4470 0881 5578'), 
  ('CU66666666', 'private', '+4470 7500 3637'),
  ('CU77777777', 'business', '+4479 0644 1370'), 
  ('CU88888888', 'private', '+4478 6729 5567'), 
  ('CU99999999', 'business', '+4470 6336 3932'); 



INSERT INTO book
VALUES
  ('0-6879-4771-5','Database Design','Fred Heypen','Ultimate Books'),
  ('0-7185-5614-3','Greenlights','Charles Johnston','Ultimate Books'),
  ('0-4404-6826-4','Untamed','Michael Gray','Ultimate Books'),
  ('0-9263-6827-3','Caste','luis shaw','Light Books'),
  ('0-1420-0322-0','Killing crazy horse','Marco Reilly','Light Books'),
  ('0-6859-0667-1','One vote away','Euan Bell','Light Books'),
  ('0-4802-1161-2','A time for mercy','Evan Ross','Shine Books'),
  ('0-6598-5648-4','The return','Caleb McGregor','Shine Books'),
  ('0-9413-7369-1','The searcher','Hubert Murray','Dark Books'),
  ('0-5217-6095-2','Walk the wire','Thomas Walker','Dark Books');


INSERT INTO review
VALUES
  ("CU12345678", '0-6879-4771-5', 5),
  ("CU11111111", '0-7185-5614-3', 3),
  ("CU22222222", '0-4404-6826-4', 2),
  ("CU33333333", '0-9263-6827-3', 2),
  ("CU44444444", '0-1420-0322-0', 4),
  ("CU55555555", '0-6859-0667-1', 5),
  ("CU66666666", '0-4802-1161-2', 3),
  ("CU77777777", '0-6598-5648-4', 4),
  ("CU88888888", '0-1420-0322-0', 3),
  ("CU99999999", '0-5217-6095-2', 1);


INSERT INTO genre
VALUES
  ('0-6879-4771-5', 'Science and Technology'),
  ('0-7185-5614-3', 'Science and Technology'),
  ('0-4404-6826-4', 'Science and Technology'),
  ('0-9263-6827-3', 'Eductioan and Teaching'),
  ('0-1420-0322-0', 'Education and Teaching'),
  ('0-6859-0667-1', 'Innovation and Creativity'),
  ('0-4802-1161-2', 'Innovation and Creativity'),
  ('0-6598-5648-4', 'Management'),
  ('0-9413-7369-1', 'Information Technology'),
  ('0-5217-6095-2', 'Information Technology');

INSERT INTO supplier
VALUES
  ('SUP1234567', 'Libsupply Limited', 'ACC1234567'),
  ('SUP1111111', 'Alibaba', 'ACC1111111'),
  ('SUP2222222', 'Amazon UK', 'ACC2222222'),
  ('SUP3333333', 'Books4people', 'ACC3333333'),
  ('SUP4444444', 'Bookshop24', 'ACC4444444'),
  ('SUP5555555', 'Oberlo', 'ACC5555555'),
  ('SUP6666666', 'LibrarySale', 'ACC6666666'),
  ('SUP7777777', 'Bookdepot', 'ACC7777777'),
  ('SUP8888888', 'Thalia', 'ACC8888888'),
  ('SUP9999999', 'Biggestbook', 'ACC9999999');

INSERT INTO phone_supplier
VALUES
  ('SUP1234567', '+4477 7487 3428'),
  ('SUP1111111', '+4477 7741 4268'),
  ('SUP2222222', '+4477 4180 7779'),
  ('SUP3333333', '+4470 1400 3788'),
  ('SUP4444444', '+4477 5495 9420'),
  ('SUP5555555', '+4479 7413 5810'),
  ('SUP6666666', '+4479 6977 9493'),
  ('SUP7777777', '+4479 3022 4247'),
  ('SUP8888888', '+4478 0612 7863'),
  ('SUP9999999', '+4477 5463 0880');

INSERT INTO edition_
VALUES
  ('0-6879-4771-5','Edition3','hardcover',29.99,10),
  ('0-7185-5614-3','Edition1','paperback',39.99,9),
  ('0-4404-6826-4','Edition4','audiobook',49.99,8),
  ('0-9263-6827-3','Edition1','audiobook',49.99,17),
  ('0-1420-0322-0','Edition5','paperback',59.99,12),
  ('0-6859-0667-1','Edition9','hardcover',79.99,9),
  ('0-4802-1161-2','Edition5','hardcover',69.99,6),
  ('0-6598-5648-4','Edition6','audiobook',129.99,12),
  ('0-9413-7369-1','Edition3','audiobook',69.99,2),
  ('0-5217-6095-2','Edition8','paperback',49.99,2);

INSERT INTO contains
VALUES
  ('0-6879-4771-5','OR12345678','Edition3','hardcover'),
  ('0-7185-5614-3','OR11111111','Edition1','paperback'),
  ('0-4404-6826-4','OR22222222','Edition4','audiobook'),
  ('0-9263-6827-3','OR33333333','Edition1','audiobook'),
  ('0-1420-0322-0','OR44444444','Edition5','paperback'),
  ('0-6859-0667-1','OR55555555','Edition9','hardcover'),
  ('0-4802-1161-2','OR66666666','Edition5','hardcover'),
  ('0-6598-5648-4','OR77777777','Edition6','audiobook'),
  ('0-9413-7369-1','OR88888888','Edition3','audiobook'),
  ('0-5217-6095-2','OR99999999','Edition8','paperback');

INSERT INTO supplies
VALUES
  ('0-6879-4771-5','SUP1234567','Edition3','hardcover',9.99),
  ('0-7185-5614-3','SUP1111111','Edition1','paperback',19.99),
  ('0-4404-6826-4','SUP2222222','Edition4','audiobook',29.99),
  ('0-9263-6827-3','SUP3333333','Edition1','audiobook',29.99),
  ('0-1420-0322-0','SUP4444444','Edition5','paperback',39.99),
  ('0-6859-0667-1','SUP5555555','Edition9','hardcover',39.99),
  ('0-4802-1161-2','SUP6666666','Edition5','hardcover',49.99),
  ('0-6598-5648-4','SUP7777777','Edition6','audiobook',89.99),
  ('0-9413-7369-1','SUP8888888','Edition3','audiobook',39.99),
  ('0-5217-6095-2','SUP9999999','Edition8','paperback',29.99);

----------------------------------------------------------------------
-- Visual data control of the tables
----------------------------------------------------------------------


SELECT * FROM customer;

SELECT * FROM order_;

SELECT * FROM phone_customer;

SELECT * FROM book;

SELECT * FROM review;

SELECT * FROM genre;

SELECT * FROM supplier;

SELECT * FROM phone_supplier;

SELECT * FROM edition_;

SELECT * FROM contains;

SELECT * FROM supplies;

----------------------------------------------------------------------
-- Queries task 3
----------------------------------------------------------------------

--Query 1
--SELECT * FROM book NATURAL JOIN genre 
--WHERE book.publisher = "Ultimate Books" 
--AND genre.genre_description = "Science and Technology";

--Query 2
-- SELECT * FROM order_
-- WHERE city = "Edinburgh" AND date_ordered > '2015-12-31'
-- ORDER BY date_ordered DESC;

--Query 3
