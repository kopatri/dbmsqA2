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
-- DECLARATIONS
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

INSERT INTO customer
VALUES
  ('CU12345678','Mike Miller','mikemiller@gmail.com','2Waterloo','Edinburgh','EH1 3EG','Scotland'),
  ('CU11111111','Franz Ferdinand','franzf@gmail.com','4 Waterloo Street','Edinburgh','EH1 3EG','Scotland'),
  ('CU22222222','Lisa McDoll','lisa@mcdoll.com','42 Lyon Street','Edinburgh','EH1 3EG','Scotland');
  

INSERT INTO order_
VALUES
  ('OR12345678','2Waterloo','Edinburgh','EH1 3EG','Scotland','2018-10-10','2018-10-15','CU12345678'),
  ('OR11111111','4 Waterloo Street','Edinburgh','EH1 3EG','Scotland','2019-04-04','2019-04-07','CU11111111'),
  ('OR22222222','42 Lyon Street','Edinburgh','EH1 3EG','Scotland','2020-08-11','2020-08-14','CU22222222');

 INSERT INTO phone_customer
VALUES
  ('CU12345678', 'private', '+4413 1608 1133'),
  ('CU11111111', 'business', '+4477 1112 5810'),
  ('CU22222222', 'business', '+4479 2310 7845'); 

INSERT INTO book
VALUES
  ('0-6879-4771-5','Database Design','Fred Heypen','Ultimate Books'),
  ('0-7185-5614-3','Greenlights','Charles Johnston','Ultimate Books'),
  ('0-4404-6826-4','Untamed','Michael Gray','Ultimate Books');

INSERT INTO review
VALUES
  ("CU12345678", '0-6879-4771-5', 5),
  ("CU11111111", '0-7185-5614-3', 3),
  ("CU22222222", '0-4404-6826-4', 2);

INSERT INTO genre
VALUES
  ('0-6879-4771-5', 'Science and Technology'),
  ('0-7185-5614-3', 'Science and Technology'),
  ('0-4404-6826-4', 'Science and Technology');

INSERT INTO supplier
VALUES
  ('SUP1234567', 'Libsupply Limited', 'ACC1234567'),
  ('SUP1111111', 'Alibaba', 'ACC1111111'),
  ('SUP2222222', 'Amazon UK', 'ACC2222222');

INSERT INTO phone_supplier
VALUES
  ('SUP1234567', '+4477 7487 3428'),
  ('SUP1111111', '+4477 7741 4268'),
  ('SUP2222222', '+4477 4180 7779');

INSERT INTO edition_
VALUES
  ('0-6879-4771-5','Edition3','hardcover',29.99,10),
  ('0-7185-5614-3','Edition1','paperback',39.99,9),
  ('0-4404-6826-4','Edition4','audiobook',49.99,8);

INSERT INTO contains
VALUES
  ('0-6879-4771-5','OR12345678','Edition3','hardcover'),
  ('0-7185-5614-3','OR11111111','Edition1','paperback'),
  ('0-4404-6826-4','OR22222222','Edition4','audiobook');

INSERT INTO supplies
VALUES
  ('0-6879-4771-5','SUP1234567','Edition3','hardcover',9.99),
  ('0-7185-5614-3','SUP1111111','Edition1','paperback',19.99),
  ('0-4404-6826-4','SUP2222222','Edition4','audiobook',29.99);
