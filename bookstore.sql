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
  ('CU12345678','Mike Miller','mikemiller@gmail.com','2Waterloo','Edinburgh','EH1 3EG','Scotland');
  

INSERT INTO order_
VALUES
  ('OR12345678','2Waterloo','Edinburgh','EH1 3EG','Scotland','2018-10-10','2018-10-15','CU12345678');

 INSERT INTO phone_customer
VALUES
  ('CU12345678', 'private', '+4413 1608 1133'); 

INSERT INTO book
VALUES
  ('0-6879-4771-5','Database Design','Fred Heypen','Ultimate Books');

INSERT INTO review
VALUES
  ("CU12345678", '0-6879-4771-5', 5);

INSERT INTO genre
VALUES
  ('0-6879-4771-5', 'Science and Technology');

INSERT INTO supplier
VALUES
  ('SUP1234567', 'Libsupply Limited', 'ACC1234567');

INSERT INTO phone_supplier
VALUES
  ('SUP1234567', '+4477 7487 3428');

INSERT INTO edition_
VALUES
  ('0-6879-4771-5','Edition3','hardcover',29.99,10);

INSERT INTO contains
VALUES
  ('0-6879-4771-5','OR12345678','Edition3','hardcover');

INSERT INTO supplies
VALUES
  ('0-6879-4771-5','SUP1234567','Edition3','hardcover',9.99);
