-- ----------------------------------------------------------------------------
-- VARATHARUBAN B
-- AMAZON - SQL ASSIGNMENT
-- ----------------------------------------------------------------------------
-- CRARE NEW DATABASE NAMED <AMAZONDB>
CREATE DATABASE AmazonDB;

-- DISPLAY AVAILABLE DATABASES
SHOW DATABASES;

-- SWICTH TO <AMAZONDB> DATABASE
USE AmazonDB;

-- USERS TABLE
CREATE TABLE USERS (
    USER_ID 		INT AUTO_INCREMENT PRIMARY KEY,
    NAME 			VARCHAR(150) NOT NULL,
    EMAIL 			VARCHAR(150) NOT NULL UNIQUE,
    REGISTERED_DATE DATE NOT NULL,
    MEMBERSHIP 		ENUM('BASIC', 'PRIME') NOT NULL DEFAULT 'BASIC'
);

-- PRODUCTS TABLE
CREATE TABLE PRODUCTS (
    PRODUCT_ID 		INT AUTO_INCREMENT PRIMARY KEY,
    NAME 			VARCHAR(200) NOT NULL,
    PRICE 			DECIMAL(10, 2) NOT NULL,
    CATEGORY 		VARCHAR(100) NOT NULL,
    STOCK			INT NOT NULL
);

-- ORDERS TABLE
CREATE TABLE ORDERS (
    ORDER_ID 		INT AUTO_INCREMENT PRIMARY KEY,
    USER_ID 		INT, FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID),
    ORDER_DATE 		DATE NOT NULL,
    TOTAL_AMOUNT 	DECIMAL(10, 2) NOT NULL
);

-- ORDER_DETAILS TABLE
CREATE TABLE ORDER_DETAILS (
    ORDER_DETAILS_ID	INT AUTO_INCREMENT PRIMARY KEY,
    ORDER_ID 			INT, FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ORDER_ID),
    PRODUCT_ID 			INT, FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID),
    QUANTITY 			INT NOT NULL
);

-- CHECK CRATED TABLE
SELECT * FROM USERS;
SELECT * FROM PRODUCTS;
SELECT * FROM ORDERS;
SELECT * FROM ORDER_DETAILS;

-- DATA INSERTIONS
INSERT INTO USERS (NAME, EMAIL, REGISTERED_DATE, MEMBERSHIP) 
VALUES 
	('Alice Johnson', 'alice.j@example.com', '2024-01-15', 'Prime'),
	('Bob Smith', 'bob.s@example.com', '2024-02-01', 'Basic'),
	('Charlie Brown', 'charlie.b@example.com', '2024-03-10', 'Prime'),
	('Daisy Ridley', 'daisy.r@example.com', '2024-04-12', 'Basic');
    
INSERT INTO PRODUCTS (NAME, PRICE, CATEGORY, STOCK) 
VALUES
	('Echo Dot', 49.99, 'Electronics', 120),
	('Kindle Paperwhite', 129.99, 'Books', 50),
	('Fire Stick', 39.99, 'Electronics', 80),
	('Yoga Mat', 19.99, 'Fitness', 200),
	('Wireless Mouse', 24.99, 'Electronics', 150);
    
INSERT INTO ORDERS (USER_ID, ORDER_DATE, TOTAL_AMOUNT) 
VALUES
	(1, '2024-05-01', 79.98),
	(2, '2024-05-03', 129.99),
	(1, '2024-05-04', 49.99),
	(3, '2024-05-05', 24.99);
    
INSERT INTO ORDER_DETAILS (ORDER_ID, PRODUCT_ID, QUANTITY) 
VALUES
	(1, 1, 2),
	(2, 2, 1),
	(3, 1, 1),
	(4, 5, 1);

-- CHECK THE INSERTED DATA
SELECT * FROM USERS;
SELECT * FROM PRODUCTS;
SELECT * FROM ORDERS;
SELECT * FROM ORDER_DETAILS;

-- ----------------------------------------------------------------------------
-- ASSIGNMENT QUESTIONS
-- ----------------------------------------------------------------------------

-- 01. List all customers who have made purchases of more than $80.
SELECT 	U.*
FROM 	USERS U INNER JOIN ORDERS O ON (U.USER_ID = O.USER_ID)
WHERE 	O.TOTAL_AMOUNT > 80;

-- 02. Retrieve all orders placed in the last 280 days along with the customer name and email.
SELECT 	U.NAME, U.EMAIL
FROM 	USERS U INNER JOIN ORDERS O ON (U.USER_ID = O.USER_ID)
WHERE 	O.ORDER_DATE > (NOW() - INTERVAL 280 DAY);

-- 03. Find the average product price for each category.
SELECT P.CATEGORY, ROUND(AVG(PRICE), 2) AVERAGE_PRICE_PER_CATEGORY
FROM PRODUCTS P
GROUP BY P.CATEGORY;

-- 04. List all customers who have purchased a product from the category Electronics. 
SELECT 	U.*
FROM 	USERS U INNER JOIN ORDERS O ON (U.USER_ID = O.USER_ID)
		INNER JOIN ORDER_DETAILS DET ON (O.ORDER_ID = DET.ORDER_ID)
        INNER JOIN PRODUCTS P ON (P.PRODUCT_ID = DET.PRODUCT_ID)
WHERE 	P.CATEGORY = 'Electronics';

-- 05. Find the total number of products sold and the total revenue generated for each product.
SELECT 		DET.PRODUCT_ID, P.NAME, SUM(DET.QUANTITY) AS TOTAL_SOLD, SUM(P.PRICE) TOTAL_REVENUE
FROM 		PRODUCTS P INNER JOIN ORDER_DETAILS DET ON (P.PRODUCT_ID = DET.PRODUCT_ID)
GROUP BY 	DET.PRODUCT_ID;

-- 06. Update the price of all products in the Books category, increasing it by 10%.
SELECT * FROM PRODUCTS WHERE CATEGORY = 'Books';
SET SQL_SAFE_UPDATES = 0;

UPDATE 	PRODUCTS 
SET 	PRICE = PRICE * 1.1
WHERE 	CATEGORY = 'Books';

-- 07. Remove all orders that were placed before 2020.
SELECT * FROM ORDERS WHERE YEAR(ORDER_DATE) < 2020;
DELETE FROM ORDERS WHERE YEAR(ORDER_DATE) < 2020;

-- 08. Write a query to fetch the order details, including customer name, product name, and quantity, for orders placed on 2024-05-01.
SELECT 	U.NAME AS CUSTOMER_NAME, P.NAME AS PRODUCT_NAME, DET.QUANTITY, O.ORDER_DATE
FROM 	USERS U INNER JOIN ORDERS O ON (U.USER_ID = O.USER_ID)
		INNER JOIN ORDER_DETAILS DET ON (O.ORDER_ID = DET.ORDER_ID)
		INNER JOIN PRODUCTS P ON (DET.PRODUCT_ID = P.PRODUCT_ID)
WHERE 	O.ORDER_DATE = '2024-05-01';

-- 09. Fetch all customers and the total number of orders they have placed.
SELECT 		U.USER_ID, U.NAME, U.EMAIL, U.REGISTERED_DATE, U.MEMBERSHIP, COUNT(O.ORDER_ID) AS NO_OF_ORDERS
FROM 		USERS U INNER JOIN ORDERS O ON (U.USER_ID = O.USER_ID)
GROUP BY 	U.USER_ID;

-- 10. Retrieve the average rating for all products in the Electronics category.
-- RATING COLUMN NOT FOUND

-- 11. List all customers who purchased more than 1 units of any product, including the product name and total quantity purchased.
SELECT 		P.NAME AS PRODUCT_NAME, U.NAME, DET.QUANTITY AS TOTAL_QTY_PURCHASED
FROM 		USERS U INNER JOIN ORDERS O ON (U.USER_ID = O.USER_ID)
			INNER JOIN ORDER_DETAILS DET ON (O.ORDER_ID = DET.ORDER_ID)
			INNER JOIN PRODUCTS P ON (DET.PRODUCT_ID = P.PRODUCT_ID)
GROUP BY 	P.NAME, U.NAME, DET.QUANTITY
HAVING 		DET.QUANTITY > 1;

-- 12. Find the total revenue generated by each category along with the category name
SELECT 		P.CATEGORY,  SUM(P.PRICE * DET.QUANTITY) AS TOTAL_REVENUE_PER_CATEGORY
FROM 		PRODUCTS P INNER JOIN ORDER_DETAILS DET ON (P.PRODUCT_ID = DET.PRODUCT_ID)
GROUP BY 	P.CATEGORY;
