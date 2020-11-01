/*
 Usage:
 - To connect to a transient in-memory database:
 
 sqlite3 --init bookstore.sql
 
 - To connect to a named database:
 
 sqlite3 <name.db> --init bookstore.sql
 */
.mode column.headers 
on.width 18 18 18 18 -- enforce foreign keys check
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
  date_ordered DATE,
  date_delivered DATE,
  customer_id CHAR(10),
  PRIMARY KEY (order_id),
  FOREIGN KEY (customer_id) REFERENCES customer 
);

CREATE TABLE customer (
  customer_id CHAR(10),
  customer_name VARCHAR(50),
  --Alteration
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
  --Alteration
  phone_number VARCHAR(30),
  --Alteration
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


CREATE TABLe book(
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

CREATE TABLE edition_(
  book_id CHAR(13),
  book_edition VARCHAR(20),
  book_type VARCHAR(9),
  --Alteration, admissible values: "audiobook", "hardcover", "paperback"
  price NUMERIC(4, 2),
  quantity_in_stock INTEGER,
  PRIMARY KEY (book_id, book_edition, book_type),
  FOREIGN KEY (book_id) REFERENCES book 
);

CREATE TABLE contains (
  book_id CHAR(13),
  order_id CHAR (10),
  book_edition VARCHAR(20),
  --Alteration
  book_type VARCHAR(9),
  --Alteration, admissible values: "audiobook", "hardcover", "paperback"
  PRIMARY KEY (book_id, order_id, book_edition, book_type),
  FOREIGN KEY (book_id) REFERENCES book,
  FOREIGN KEY (order_id) REFERENCES order_,
  FOREIGN KEY (book_edition) REFERENCES edition_,
  FOREIGN KEY (book_type) REFERENCES edition_
);

CREATE TABLE supplies (
  book_id CHAR(13),
  supplier_id CHAR(10),
  book_edition VARCHAR(20),
  --Alteration
  book_type VARCHAR(9),
  --Alteration, admissible values: "audiobook", "hardcover", "paperback"
  supply_price NUMERIC(4, 2),
  PRIMARY KEY (book_id, book_edition, book_type),
  FOREIGN KEY (book_id) REFERENCES book,
  FOREIGN KEY (book_edition) REFERENCES edition_,
  FOREIGN KEY (book_type) REFERENCES edition_
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
  PRIMARY KEY (supplier_id) FOREIGN KEY (supplier_id) REFERENCES supplier
);

/*
 CREATE TABLE department (
 dept_id    CHAR(5),
 dept_name  VARCHAR(20) NOT NULL,
 building   VARCHAR(15),
 budget     NUMERIC(12,2),
 PRIMARY KEY (dept_id)
 );
 
 CREATE TABLE instructor (
 instr_id    CHAR (5),
 instr_name  VARCHAR(20) NOT NULL,
 dept_id     VARCHAR(5),
 salary      NUMERIC (8,2),
 PRIMARY KEY (instr_id),
 FOREIGN KEY (dept_id) REFERENCES department);
 
 CREATE TABLE student (
 stud_id   CHAR(5),
 name      VARCHAR(20) NOT NULL,
 dept_id   VARCHAR(20),
 tot_cred  NUMERIC(3,0) DEFAULT 0,
 PRIMARY KEY (stud_id),
 FOREIGN KEY (dept_id) REFERENCES department);
 
 CREATE TABLE course (
 course_id  VARCHAR(8),
 title      VARCHAR(50),
 dept_id    VARCHAR(20),
 credits    NUMERIC(2,0),
 PRIMARY KEY (course_id),
 FOREIGN KEY (dept_id) references department
 ON DELETE CASCADE
 ON UPDATE CASCADE);
 
 CREATE TABLE course_runs (
 course_id  VARCHAR(8),
 year       INTEGER,
 semester   INTEGER,
 PRIMARY KEY (course_id, year, semester),
 FOREIGN KEY (course_id) references course);
 
 CREATE TABLE teaches (
 instr_id  CHAR(5),
 course_id VARCHAR(8),
 PRIMARY KEY (instr_id,course_id),
 FOREIGN KEY (instr_id) references instructor,
 FOREIGN KEY (course_id) references course);
 
 CREATE TABLE prereq (
 course_id  VARCHAR(8),
 prereq_id  VARCHAR(8),
 PRIMARY KEY (course_id),
 FOREIGN KEY (prereq_id) references course(course_id)
 ON DELETE CASCADE
 ON UPDATE CASCADE);
 */
----------------------------------------------------------------------
-- TEST DATA
----------------------------------------------------------------------
INSERT INTO
  order_
VALUES
  (
    'OR12345678',
    '2 Waterloo',
    'Edinburgh',
    'EH1 3EG',
    'Scotland',
    2010 -10 -10,
    2016 -10 -15,
    'CUS12345678'
  ),
  (
    'OR87654321',
    '4 Waterloo',
    'Edinburgh',
    'EH1 3EG',
    'Scotland',
    2010 -10 -10,
    2016 -10 -15,
    'CUS87654321'
  );

INSERT INTO
  customer
VALUES
  (
    'CU12345678',
    'Mike Miller',
    'mikemiller@gmail.com',
    '2 Waterloo',
    'Edinburgh',
    'EH1 3EG',
    'Scotland'
  ),
  (
    'CU87654321',
    'Thomas McDonald',
    'thomasmcdonald@hotmail.com',
    '4 Waterloo',
    'Edinburgh',
    'EH1 3EG',
    'Scotland'
  );

INSERT INTO
  phone_customer
VALUES
  ('CU12345678', 'private', '+441316081133'),
  ('CU87654321', 'business', '+441315295299');

INSERT INTO
  review
VALUES
  ("CU12345678", '0-6879-4771-5', 5),
  ("CU87654321", '0-8016-2185-2', 2);

INSERT INTO book
VALUES
  (
    '0-6879-4771-5',
    'Database Design',
    'Fred Heypen',
    'Ultimate Books'
  ),
  --TASK 3 requirement
  (
    '0-8016-2185-2',
    'Database Concept',
    'Larry Fink',
    'Ultimate Books'
  );

--TASK 3 requirement
INSERT INTO
  genre
VALUES
  ('0-6879-4771-5', 'Science and Technology'),
  --TASK 3 requirement
  ('0-8016-2185-2', 'Science and Technology');

--TASK 3 requirement
INSERT INTO
  edition_
VALUES
  (
    '0-6879-4771-5',
    'Volume 3',
    'hardcover',
    29.99,
    1
  ),
  --TASK 3 requirement
  (
    '0-8016-2185-2',
    'Volume 2',
    'paperback',
    24.99,
    4
  );

--TASK 3 requirement
INSERT INTO
  contains
VALUES
  (
    '0-6879-4771-5',
    'OR12345678',
    'Volume 3',
    'harcover'
  ),
  --TASK3 requirement
  (
    '0-8016-2185-2',
    'OR87654321',
    'Volume 2',
    'paperback'
  );

--TASK3 requirement
INSERT INTO
  supplies
VALUES
  (
    '0-6879-4771-5',
    'SUP1234567',
    'Volume 3',
    'hardcover',
    9.99
  ),
  --TASK 3 requirement
  (
    '0-8016-2185-2',
    'SUP7654321',
    'Volume 2',
    'paperback',
    4.99
  );

--TASK 3 requirement
INSERT INTO
  supplier
VALUES
  ('SUP1234567', 'Libsupply Limited', 'ACC1234567'),
  --TASK 3 requirement
  ('SUP7654321', 'Bookworm Limited', 'ACC7654321');

--TASK 3 requirement
INSERT INTO
  phone_supplier
VALUES
  ('SUP1234567', '+447774873428'),
  -- TASK3 requirement
  ('SUP7654321', '+447842279009');

-- TASK3 requirement
/*
 ----------------------------------------------------------------------
 -- VISUAL DATA CONTROL
 ----------------------------------------------------------------------
 
 -- An asterisk denotes "all attributes"
 -- This "control" does not check anything, but if we can't see the
 -- tables, then something definitely went wrong with defining them.
 
 SELECT * FROM department;
 
 SELECT * FROM instructor;
 
 SELECT * FROM student;
 
 SELECT * FROM course;
 
 SELECT * FROM course_runs;
 
 SELECT * FROM teaches;
 
 SELECT * FROM prereq;
 ----------------------------------------------------------------------
 -- EXAMPLE QUERIES FOR LECTURE 8
 ----------------------------------------------------------------------
 
 
 -- Simple queries
 
 -- Find the department names of all instructors
 SELECT instr_name FROM instructor;
 
 -- Find the department names of all instructors and remove duplicated
 SELECT DISTINCT dept_id FROM instructor;
 
 -- Explicitly specify that duplicated should not be removed
 SELECT ALL dept_id FROM instructor;
 
 -- Using arithmetic operations in queries
 SELECT instr_id, instr_name, salary/12 FROM instructor;
 
 
 -- Using WHERE
 
 -- Specify conditions that the result must satisfy.
 SELECT instr_name
 FROM instructor
 WHERE dept_id = 'PHYS' AND salary > 30000;
 
 -- Generates every possible (instructor, teaches) pair
 -- with all attributes from both relations.
 SELECT * FROM instructor, teaches;
 
 -- For all instructors who have taught courses, find their names
 -- and the course ID of the courses they taught.
 SELECT instr_name, course_id
 FROM instructor, teaches
 WHERE instructor.instr_id = teaches.instr_id;
 
 
 -- NATURAL JOIN
 
 -- `NATURAL JOIN` matches tuples with the same values for all
 -- common attributes, retaining only one copy of each common column
 SELECT * FROM instructor NATURAL JOIN teaches;
 
 -- Compare NATURAL JOIN with the following (it has `instr_id` twice )
 SELECT *
 FROM instructor, teaches
 WHERE instructor.instr_id = teaches.instr_id;
 
 -- Also compare the following NATURAL JOIN
 SELECT instr_name, course_id FROM instructor NATURAL JOIN teaches;
 
 -- and the next query. Are they equivalent?
 SELECT instr_name, course_id
 FROM instructor, teaches
 WHERE instructor.instr_id = teaches.instr_id;
 
 
 -- AS for renaming
 
 -- Renaming relations and attributes using the AS clause
 SELECT instr_id, instr_name, salary/12 as monthly_salary
 FROM instructor;
 
 -- Find the names of all instructors who have a higher salary
 -- than some instructor in Physics:
 
 SELECT DISTINCT T.instr_name
 FROM instructor AS T, instructor AS S
 WHERE T.salary > S.salary
 AND S.dept_id = 'PHYS';
 
 
 -- More examples of INSERT
 
 INSERT INTO course (course_id, title, dept_id, credits)
 VALUES ('IS5102', 'DBMS','CS', 15);
 
 INSERT INTO course (course_id, title, credits, dept_id)
 VALUES ('IS5040', 'HCI', 15, 'CS');
 
 INSERT INTO student
 VALUES ('65467', 'Emma', 'CS', NULL);
 
 INSERT INTO student (stud_id, name, dept_id)
 VALUES ('83456', 'Nick', 'MATH' );
 
 ----------------------------------------------------------------------
 -- EXAMPLE QUERIES FOR LECTURE 9
 ----------------------------------------------------------------------
 
 -- Add all instructors to the student relation with `tot_creds`
 -- set to zero
 INSERT INTO student
 SELECT instr_id, instr_name, dept_id, 0
 FROM instructor;
 
 -- Revert the previous update (we rely on the ID of students and
 -- instructors being non-overlapping)
 DELETE FROM student
 WHERE stud_id IN
 (SELECT instr_id
 FROM instructor);
 
 -- Increase salaries of instructors whose salary is over £30,000
 -- by 3%, and all others receive a 5% raise
 UPDATE instructor
 SET salary =
 CASE
 WHEN salary <= 30000
 THEN salary * 1.05
 ELSE salary * 1.03
 END;
 
 -- Find the names of all instructors whose name includes
 -- the substring `PH`
 SELECT instr_name
 FROM instructor
 WHERE dept_id LIKE '%PH%';
 
 -- List in alphabetic order the names of all instructors
 SELECT DISTINCT instr_name
 FROM instructor
 ORDER BY instr_name;
 
 -- List instructors by descending order of their salaries
 SELECT DISTINCT instr_name, salary
 FROM instructor
 ORDER BY salary DESC;
 
 -- Find all students whose total credits is NULL.
 SELECT name
 FROM student
 WHERE tot_cred IS NULL;
 
 -- Find the average salary of instructors in the Physics department
 SELECT AVG (salary)
 FROM instructor
 WHERE dept_id = 'PHYS';
 
 -- Find the total number of instructors who teach at least one course
 SELECT COUNT (DISTINCT instr_id)
 FROM teaches;
 
 -- Find the number of tuples in the `course` relation
 SELECT COUNT (*)
 FROM course;
 
 -- Find the average salary of instructors in each department
 SELECT dept_id, AVG (salary) AS "Average Salary"
 FROM instructor
 GROUP BY dept_id;
 
 -- Now use NATURAL JOIN to output department name instead of ID
 SELECT dept_name, AVG (salary) AS "Average Salary"
 FROM instructor NATURAL JOIN department
 GROUP BY dept_id;
 
 -- Find the names and average salaries of all departments whose
 --  average salary is greater than 30000
 SELECT dept_id, AVG (salary)
 FROM instructor
 GROUP BY dept_id
 HAVING AVG (salary) > 30000;
 
 -- Find the total sum of all annual salaries
 SELECT SUM (salary)
 FROM instructor;
 
 ----------------------------------------------------------------------
 -- EXAMPLE QUERIES FOR LECTURE 10
 ----------------------------------------------------------------------
 
 -- Find courses that ran in Semester 2 of 2019 or in Semester 1 of 2020
 SELECT course_id
 FROM course_runs
 WHERE semester = 2
 AND year = 2019
 UNION -- you can also try `UNION ALL`
 SELECT course_id
 FROM course_runs
 WHERE semester = 1
 AND year = 2020;
 
 -- Find courses that ran in Semester 2 of 2019 and in Semester 2 of 2020
 SELECT course_id
 FROM course_runs
 WHERE semester = 2
 AND year = 2019
 INTERSECT
 SELECT course_id
 FROM course_runs
 WHERE semester = 2
 AND year = 2020;
 
 -- Find courses that ran in Semester 1 of 2019 but not in Semester 1 of 2020
 SELECT course_id
 FROM course_runs
 WHERE semester = 1
 AND year = 2019
 EXCEPT
 SELECT course_id
 FROM course_runs
 WHERE semester = 1
 AND year = 2020;
 
 -- A view of instructors without their salary
 CREATE VIEW faculty AS
 SELECT instr_id, instr_name, dept_id
 FROM instructor;
 
 SELECT * from faculty;
 
 -- A view of department salary totals
 -- (note specifying attribute names )
 CREATE VIEW departments_total_salary(dept_code, total_salary) AS
 SELECT dept_id, SUM (salary)
 FROM instructor
 GROUP BY dept_id;
 
 SELECT * from departments_total_salary;
 
 -- Views defined using other views
 CREATE VIEW acad_year_2020 AS
 SELECT semester, course_id, dept_id, title
 FROM course_runs NATURAL JOIN course
 WHERE year  = 2020;
 
 SELECT * FROM acad_year_2020;
 
 CREATE VIEW cs_acad_year_2020 AS
 SELECT semester, course_id, title
 FROM acad_year_2020
 WHERE dept_id= 'CS';
 
 SELECT * FROM cs_acad_year_2020;
 
 ----------------------------------------------------------------------
 -- EXAMPLE QUERIES FOR LECTURE 11
 ----------------------------------------------------------------------
 
 -- Find the average instructors' salaries of those departments
 -- where the average salary is greater than £31,000.
 SELECT dept_id, avg_salary
 FROM (SELECT dept_id, avg (salary) as avg_salary
 FROM instructor
 GROUP BY dept_id)
 WHERE avg_salary > 31000;
 
 -- Scalar subquery is one which is used where a single value is expected
 -- For example, count number of instructors for each department
 SELECT dept_id,
 (SELECT count(*)
 FROM instructor
 WHERE department.dept_id = instructor.dept_id)
 AS num_instructors
 FROM department;
 
 -- Create view for courses at the Mathematic department
 CREATE VIEW math_courses AS
 SELECT *
 FROM course
 WHERE dept_id = 'MATH';
 
 -- This join lists only courses having a prerequisite
 SELECT *
 FROM math_courses NATURAL JOIN prereq;
 
 -- This join lists all courses, and puts NULL if there is no prerequisite
 SELECT *
 FROM math_courses NATURAL LEFT OUTER JOIN prereq;
 
 ----------------------------------------------------------------------
 -- EXAMPLES FOR LECTURE 12
 ----------------------------------------------------------------------
 
 -- Examples of using scalar functions
 SELECT RANDOM() AS 'RANDOM',
 ABS(-42) AS 'ABS',
 LENGTH('SQL') AS 'LENGTH';
 
 -- Examples of using date and time functions
 SELECT DATETIME('NOW') AS 'Current date/time',
 DATE('NOW') AS 'Date',
 TIME('NOW') AS 'Time',
 JULIANDAY('2020-12-07') - JULIANDAY('NOW')
 AS 'Days until exams';
 
 -- Enforcing naming conventions for courses depending on the department
 CREATE TRIGGER validate_course
 BEFORE INSERT ON course
 BEGIN
 SELECT
 CASE
 WHEN NEW.dept_id = 'CS' AND
 (NEW.course_id NOT LIKE 'CS____' AND
 NEW.course_id NOT LIKE 'IS____') THEN
 RAISE (ABORT,'CS courses ID should start with CS or IS')
 WHEN NEW.dept_id = 'MATH' AND
 NEW.course_id NOT LIKE 'MT____' THEN
 RAISE (ABORT,'MATH courses ID should start with MT')
 END;
 END;
 
 INSERT INTO course
 VALUES ('MT4320', 'Ring theory', 'MATH', 15);
 
 INSERT INTO course
 VALUES ('CS5210', 'Computer algebra','CS', 15);
 
 INSERT INTO course
 VALUES ('IS5485', 'Digital humanities', 'CS', 15);
 
 SELECT * FROM course;
 
 -- Logging updates of student credits
 CREATE TABLE credit_logs (
 id INTEGER PRIMARY KEY,
 stud_id TEXT,
 old_credits NUMERIC,
 new_credits NUMERIC,
 updated_at TEXT
 );
 
 CREATE TRIGGER log_credits_update
 AFTER UPDATE ON student
 WHEN OLD.tot_cred <> NEW.tot_cred
 BEGIN
 INSERT INTO credit_logs (stud_id, old_credits, new_credits, updated_at)
 VALUES (OLD.stud_id, OLD.tot_cred, NEW.tot_cred, DATETIME('NOW')) ;
 END;
 
 SELECT * FROM student WHERE stud_id = '79879';
 UPDATE student SET tot_cred = 120 WHERE stud_id = '79879';
 SELECT * FROM student WHERE stud_id = '79879';
 SELECT * FROM credit_logs;
 
 SELECT * FROM student WHERE stud_id = '78778';
 UPDATE student SET tot_cred = 120 WHERE stud_id = '78778';
 SELECT * FROM student WHERE stud_id = '78778';
 SELECT * FROM credit_logs;
 
 
 */