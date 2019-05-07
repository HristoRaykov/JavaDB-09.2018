CREATE DATABASE minions;

USE minions;
CREATE TABLE minions (
	id INT PRIMARY KEY,
    name VARCHAR (255),
    age INT 
);
CREATE TABLE towns (
	id INT  PRIMARY KEY,
    name VARCHAR(255)
);

ALTER TABLE minions
ADD town_id INT,
ADD CONSTRAINT fk_town_id
FOREIGN KEY (town_id) REFERENCES towns(id);

ALTER TABLE minions
DROP FOREIGN KEY fk_town_id;
ALTER TABLE minions
DROP COLUMN town_id;

DROP DATABASE minions;

#3
INSERT INTO towns (id,name) VALUES(1,'Sofia'),
(2,'Plovdiv'),
(3,'Varna');
INSERT INTO minions (id,name,age,town_id) VALUES (1,'Kevin', 22, 1),
(2,'Bob', 15, 3),
(3,'Steward', NULL, 2);

SELECT * FROM minions;
SELECT * FROM towns;

UPDATE minions 
SET name = 'Steward'
WHERE id = '3';

#4
TRUNCATE minions;

#5
DROP TABLE minions;
DROP TABLE towns;

#6
CREATE TABLE people (
	id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    name VARCHAR(200) NOT NULL,
    picture BLOB(2048),
    height FLOAT(5,2),
    weight FLOAT(5,2),
    gender ENUM('m','f') NOT NULL,
    birthdate DATE NOT NULL,
    biography TEXT 
);

INSERT INTO people(name,picture,height,weight,gender,birthdate,biography) 
VALUES
('Pesho', NULL, '1.75', '84', 'm', '1991-03-11', NULL),
('Gosho', NULL, '1.69', '81', 'm', '1981-12-01', NULL),
('Ivan', NULL, '1.85', '94', 'm', '1989-04-21', NULL),
('Mariika', NULL, '1.64', '48', 'f', '1994-08-16', NULL),
('Dragan', NULL, '1.79', '74', 'm', '1976-03-11', NULL);

SELECT * FROM people;
DROP TABLE people;

#7
CREATE TABLE users (
	id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(30) NOT NULL UNIQUE,
    password VARCHAR(26) NOT NULL,
    profile_picture VARBINARY(900),
    last_login_time DATETIME,
    is_deleted BIT
);

INSERT INTO users(username,password,profile_picture,last_login_time,is_deleted) 
VALUES
('ivan_88','afhjsdh',NULL,DEFAULT,1);

('ivan_87','afhjsdh',NULL,'1999-12-31 23:59:59',1),
('ivan_82','afhjsdh',NULL,'1999-12-31 23:59:59',0),
('ivan_84','afhjsdh',NULL,'1999-12-31 23:59:59',1),
('ivan_85','afhjsdh',NULL,'1999-12-31 23:59:59',0);

SELECT * FROM users;

DROP TABLE minions;
DROP TABLE users;

#8
ALTER TABLE users
MODIFY COLUMN id INT(11);
ALTER TABLE users
DROP PRIMARY KEY;
ALTER TABLE users
ADD CONSTRAINT pk_users PRIMARY KEY (id,username);

#9
alter TABLE users
MODIFY COLUMN last_login_time DATETIME DEFAULT NOW();

#10
ALTER TABLE users
DROP PRIMARY KEY,
ADD PRIMARY KEY(id);
ALTER TABLE users
ADD CONSTRAINT UNIQUE(username);

drop DATABASE minions;


#11
CREATE DATABASE movies;
USE movies;

CREATE TABLE directors(
	id 	INT PRIMARY KEY AUTO_INCREMENT,
    director_name VARCHAR(60) NOT NULL,
    notes TEXT
);
CREATE TABLE genres(
	id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(60) NOT NULL,
    notes TEXT
);
CREATE TABLE categories(
	id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(60) NOT NULL,
    notes TEXT 
);
CREATE TABLE movies (
	id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    director_id INT NOT NULL,
    copyright_year INT NOT NULL,
    length INT NOT NULL,
    genre_id INT NOT NULL,
    category_id INT NOT NULL,
    rating int NOT NULL,
    notes TEXT
#   FOREIGN KEY (director_id) REFERENCES directors(id),
#   FOREIGN KEY (genre_id) REFERENCES genres(id),
#   FOREIGN KEY (category_id) REFERENCES categories(id)
);
INSERT INTO directors(director_name)
VALUES 
('Dragan1'),
('Dragan2'),
('Dragan3'),
('Dragan4'),
('Dragan5');
INSERT INTO genres(genre_name)
VALUES 
('genre1'),
('genre2'),
('genre3'),
('genre4'),
('genre5');
INSERT INTO categories(category_name)
VALUES 
('category1'),
('category2'),
('category3'),
('category4'),
('category5');
INSERT INTO movies(title,director_id,copyright_year,length,genre_id,category_id,rating,notes)
VALUES 
('title1',2,2014,132,1,5,5,''),
('title2',1,2012,94,3,1,6,'no notes'),
('title3',4,2015,152,5,3,7,''),
('title4',3,2016,109,4,2,5,'bla bla bla'),
('title5',3,2008,122,3,1,6,'');

select * from categories;
select * from directors;
select * from genres;
select * from movies;
TRUNCATE TABLE movies;
drop TABLE movies;


#12
CREATE DATABASE car_rental;
USE car_rental;

CREATE TABLE categories(
	id 				INT PRIMARY KEY AUTO_INCREMENT,
    category 		VARCHAR(60) NOT NULL,
    daily_rate 		DOUBLE(5,2) NOT NULL,
    weekly_rate 	DOUBLE(5,2) NOT NULL,
    monthly_rate 	DOUBLE(5,2) NOT NULL,
    weekend_rate	DOUBLE(5,2) NOT NULL
);

INSERT INTO categories(category, daily_rate, weekly_rate, monthly_rate, weekend_rate)
VALUES
('category1',25.40,24.40,22.40,27.40),
('category2',25.40,24.40,22.40,27.40),
('category3',25.40,24.40,22.40,27.40);

CREATE TABLE cars(
	id 				INT PRIMARY KEY AUTO_INCREMENT,
    plate_number 	VARCHAR(60),
    make 			VARCHAR(60) NOT NULL,
    model 			VARCHAR(60) NOT NULL,
    car_year 		DATE NOT NULL,
    category_id 	INT NOT NULL,
    doors 			INT NOT NULL,
    picture 		BLOB(2048),
    car_condition 	VARCHAR(255),
    available 		INT NOT NULL
);

INSERT INTO cars(plate_number, make, model, car_year, category_id, doors, picture, car_condition, available)
VALUES
('B 1436 PA','make1','model1','2011-05-23',1,4,NULL,'good',1),
('B 1434 PA','make1','model1','2011-05-23',2,4,NULL,'good',1),
('B 1438 PA','make1','model1','2011-05-23',1,4,NULL,'good',1);

CREATE TABLE employees(
	id 			INT PRIMARY KEY AUTO_INCREMENT,
    first_name	VARCHAR(60) NOT NULL,
    last_name	VARCHAR(60) NOT NULL,
	title		VARCHAR(60) NOT NULL,
	notes		TEXT
);

INSERT INTO employees (first_name, last_name, title, notes)
VALUES
('Pesho1','Peshev1','title1',''),
('Pesho1','Peshev1','title1',''),
('Pesho1','Peshev1','title2','');

CREATE TABLE customers(
	id 			INT PRIMARY KEY AUTO_INCREMENT,
    driver_licence_number	VARCHAR(60),
    full_name				VARCHAR(60) NOT NULL,
	address					VARCHAR(60) NOT NULL,
	city					VARCHAR(60) NOT NULL,
    zip_code				VARCHAR(60) NOT NULL,
    notes 					TEXT
);

INSERT INTO customers (driver_licence_number, full_name, address, city, zip_code, notes)
VALUES
('458896','Pesho Peshev1','some adress1','Varna','9000',''),
('458892','Pesho Peshev2','some adress2','Varna','9000',''),
('458891','Pesho Peshev3','some adress3','Varna','9000','');

CREATE TABLE rental_orders(
	id 					INT PRIMARY KEY AUTO_INCREMENT,
    employee_id			INT NOT NULL,
    customer_id			INT NOT NULL,
	car_id				INT NOT NULL,
	car_condition		VARCHAR(60),
    tank_level			DOUBLE(5,2) NOT NULL,
    kilometrage_start	INT NOT NULL,
    kilometrage_end		INT NOT NULL,
    total_kilometrage	INT NOT NULL,
    start_date			DATE NOT NULL,
    end_date			DATE NOT NULL,
    total_days			INT NOT NULL,
    rate_applied		DOUBLE(5,2) NOT NULL,
    tax_rate			INT NOT NULL,
    order_status		VARCHAR(60) NOT NULL,
    notes				TEXT
);

INSERT INTO rental_orders (employee_id, customer_id, car_id, car_condition, tank_level, kilometrage_start, kilometrage_end, total_kilometrage, start_date, end_date, total_days, rate_applied, tax_rate, order_status, notes)
VALUES
(2,1,3,'good',45.25,50000,51000,kilometrage_end-kilometrage_start,'2018-09-12','2018-09-19',datediff(end_date,start_date),25.20,15,'some status',''),
(1,2,1,'good',45.25,50000,51000,kilometrage_end-kilometrage_start,'2018-09-12','2018-09-19',datediff(end_date,start_date),25.20,15,'some status',''),
(3,3,2,'good',45.25,50000,51000,kilometrage_end-kilometrage_start,'2018-09-12','2018-09-19',datediff(end_date,start_date),25.20,15,'some status','');


drop DATABASE car_rental;

SELECT * FROM cars;
SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM employees;
SELECT * FROM rental_orders;


#-------------13-------------
CREATE DATABASE hotel;
USE hotel;

CREATE TABLE employees(
	id 			INT PRIMARY KEY AUTO_INCREMENT,
    first_name	VARCHAR(60),
    last_name	VARCHAR(60),
    title		VARCHAR(60),
	notes		TEXT
);

INSERT INTO employees (first_name, last_name, title, notes)
VALUES
('first_name1','last_name1','title1',''),
('first_name2','last_name2','title2',''),
('first_name3','last_name3','title3','');


CREATE TABLE customers(
	account_number 		INT PRIMARY KEY,
    first_name			VARCHAR(60),
    last_name			VARCHAR(60),
	phone_number		VARCHAR(60), 
    emergency_name		VARCHAR(60), 
    emergency_number	VARCHAR(60), 
    notes				TEXT
);

INSERT INTO customers (account_number, first_name, last_name, phone_number, emergency_name, emergency_number, notes)
VALUES
(4357,'first_name1','last_name1','467589406','name1','489238567',''),
(4356,'first_name1','last_name1','467589406','name1','489238567',''),
(4359,'first_name1','last_name1','467589406','name1','489238567','');

CREATE TABLE room_status(
	room_status		VARCHAR(60) PRIMARY KEY, 
    notes			TEXT
);

INSERT INTO room_status (room_status, notes)
VALUES
('free',''),
('occupied',''),
('cleaning','');

CREATE TABLE room_types(
	room_type VARCHAR(60) PRIMARY KEY,
    notes TEXT
);

INSERT INTO room_types (room_type, notes)
VALUES
('single',''),
('double',''),
('apartment','');

CREATE TABLE bed_types(
	bed_type VARCHAR(60) PRIMARY KEY,
    notes TEXT
);

INSERT INTO bed_types (bed_type, notes)
VALUES
('single',''),
('double',''),
('halfperson','');

CREATE TABLE rooms (
	room_number		INT PRIMARY KEY, 
    room_type		VARCHAR(60), 
    bed_type		VARCHAR(60),  
    rate			DOUBLE(5,2), 
    room_status		VARCHAR(60), 
    notes			TEXT
);

INSERT INTO rooms (room_number, room_type, bed_type, rate, room_status, notes)
VALUES
(1,'single','halfperson',55.90,'free',''),
(2,'single','halfperson',55.90,'free',''),
(3,'single','halfperson',55.90,'free','');

CREATE TABLE payments (
	id						INT PRIMARY KEY AUTO_INCREMENT, 
    employee_id				INT NOT NULL, 
    payment_date			DATETIME NOT NULL, 
    account_number			INT NOT NULL, 
    first_date_occupied		DATE NOT NULL, 
    last_date_occupied		DATE NOT NULL, 
    total_days				INT, 
    amount_charged			DECIMAL(5,2) NOT NULL, 
    tax_rate				INT NOT NULL, 
    tax_amount				DECIMAL(5,2) NOT NULL, 
    payment_total			DECIMAL(5,2), 
    notes TEXT
);

INSERT INTO payments (employee_id, payment_date, account_number, first_date_occupied, last_date_occupied, total_days, amount_charged, tax_rate, tax_amount, payment_total, notes)
VALUES
(1,'2018-08-22 18:42:33',34567834, '2018-08-22','2018-08-30',datediff(last_date_occupied,first_date_occupied),452.80, 15, amount_charged*tax_rate/100.0, amount_charged+tax_amount,''),
(2,'2018-08-22 18:42:33',34567833, '2018-08-22','2018-08-30',datediff(last_date_occupied,first_date_occupied),452.80, 15, amount_charged*tax_rate/100.0, amount_charged+tax_amount,''),
(3,'2018-08-22 18:42:33',34567831, '2018-08-22','2018-08-30',datediff(last_date_occupied,first_date_occupied),452.80, 15, amount_charged*tax_rate/100.0, amount_charged+tax_amount,'');

CREATE TABLE occupancies (
	id				INT PRIMARY KEY AUTO_INCREMENT, 
    employee_id		INT NOT NULL, 
    date_occupied	DATE NOT NULL, 
    account_number	INT NOT NULL, 
    room_number		INT NOT NULL, 
    rate_applied	DECIMAL(5,2) NOT NULL, 
    phone_charge	DECIMAL(5,2), 
    notes			TEXT
);

INSERT INTO occupancies (employee_id, date_occupied, account_number, room_number, rate_applied, phone_charge, notes)
VALUES
(1,'2018-08-22',5739348,2,55.80,20.35,''),
(1,'2018-08-22',5739348,2,55.80,20.35,''),
(1,'2018-08-22',5739348,2,55.80,20.35,'');



DROP DATABASE hotel;


#---------14-----------

CREATE DATABASE soft_uni;
USE soft_uni;

CREATE TABLE towns(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20)
);

CREATE TABLE addresses (
	id 				INT PRIMARY KEY AUTO_INCREMENT, 
    address_text	TEXT, 
    town_id			INT NOT NULL,
    FOREIGN KEY (town_id) REFERENCES towns(id)
);

CREATE TABLE departments  (
	id		INT PRIMARY KEY AUTO_INCREMENT, 
    name 	VARCHAR(60)
);

CREATE TABLE employees (
	id				INT PRIMARY KEY AUTO_INCREMENT, 
    first_name		VARCHAR(60) NOT NULL, 
    middle_name		VARCHAR(60) NOT NULL, 
    last_name		VARCHAR(60) NOT NULL, 
    job_title		VARCHAR(60) NOT NULL, 
    department_id	INT NOT NULL, 
    hire_date		DATE NOT NULL, 
    salary			DOUBLE(10,2), 
    address_id		INT,
    FOREIGN KEY (department_id) REFERENCES departments(id),
    FOREIGN KEY (address_id) REFERENCES addresses(id)
);


INSERT INTO addresses (address_text,town_id)
VALUES
('some addresses',1);


drop TABLE employees;

DROP DATABASE soft_uni;

#-----------15---------
/*
mysqldump -u root -p soft_uni > D:\db_softuni_backup.sql

mysqladmin -u root -p create soft_uni
mysql -u root -p soft_uni <  D:\db_softuni_backup.sql
*/

#---------16------
USE soft_uni;

INSERT INTO towns (name)
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO departments (name)
VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

INSERT INTO employees (first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar ', 'Petrov ', 'Petrov ', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);

TRUNCATE TABLE addresses;
TRUNCATE TABLE departaments;
TRUNCATE TABLE employees;
TRUNCATE TABLE towns;

SELECT * FROM addresses;
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM towns;


#-------17----------

SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

#-------18----------

SELECT * FROM towns ORDER BY name;
SELECT * FROM departments ORDER BY name;
SELECT * FROM employees ORDER BY salary DESC;

#-------19----------

SELECT name FROM towns ORDER BY name;
SELECT name FROM departments ORDER BY name;
SELECT first_name,last_name,job_title,salary FROM employees ORDER BY salary DESC;


#-------20----------

UPDATE employees
SET salary = 1.1*salary;
SELECT salary FROM employees;


#-------21----------
use hotel;
UPDATE payments
SET tax_rate = tax_rate*0.97;
SELECT tax_rate FROM payments;




#-------22----------

use hotel;
TRUNCATE occupancies;
