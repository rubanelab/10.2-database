-- ----------------------------------------------------------------------------
-- VARATHARUBAN B
-- NETFLIX - SQL ASSIGNMENT
-- ----------------------------------------------------------------------------
-- CRARE NEW DATABASE NAMED <NetflixDB>
CREATE DATABASE NetflixDB;

-- SWICTH TO <NetflixDB> DATABASE
USE NetflixDB;

CREATE TABLE USERS (
    USER_ID 			INT PRIMARY KEY AUTO_INCREMENT,
    NAME 				VARCHAR(100) NOT NULL,
    EMAIL 				VARCHAR(150) UNIQUE NOT NULL,
    REGISTRATION_DATE 	DATE NOT NULL,
    PLAN 				ENUM('BASIC', 'STANDARD', 'PREMIUM') DEFAULT 'BASIC'
);

CREATE TABLE MOVIES (
    MOVIE_ID 		INT PRIMARY KEY AUTO_INCREMENT,
    TITLE 			VARCHAR(200) NOT NULL,
    GENRE 			VARCHAR(100) NOT NULL,
    RELEASE_YEAR 	YEAR NOT NULL,
    RATING 			DECIMAL(3, 1) NOT NULL
);

CREATE TABLE WATCH_HISTORY (
    WATCH_ID 				INT PRIMARY KEY AUTO_INCREMENT,
    USER_ID 				INT, FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID),
    MOVIE_ID 				INT, FOREIGN KEY (MOVIE_ID) REFERENCES MOVIES(MOVIE_ID),
    WATCHED_DATE 			DATE NOT NULL,
    COMPLETION_PERCENTAGE 	INT CHECK (COMPLETION_PERCENTAGE >= 0 AND COMPLETION_PERCENTAGE <= 100)
);

CREATE TABLE REVIEWS (
    REVIEW_ID 	INT PRIMARY KEY AUTO_INCREMENT,
    MOVIE_ID 	INT, FOREIGN KEY (MOVIE_ID) REFERENCES MOVIES(MOVIE_ID),
    USER_ID 	INT, FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID),
    REVIEW_TEXT TEXT,
    RATING 		DECIMAL(2, 1) CHECK (RATING >= 0 AND RATING <= 5),
    REVIEW_DATE DATE NOT NULL
);
-- ----------------------------------------------------------------------------
INSERT INTO USERS (NAME, EMAIL, REGISTRATION_DATE, PLAN) 
VALUES
	('John Doe', 'john.doe@example.com', '2024-01-10', 'Premium'),
	('Jane Smith', 'jane.smith@example.com', '2024-01-15', 'Standard'),
	('Alice Johnson', 'alice.johnson@example.com', '2024-02-01', 'Basic'),
	('Bob Brown', 'bob.brown@example.com', '2024-02-20', 'Premium');
    
INSERT INTO MOVIES (TITLE, GENRE, RELEASE_YEAR, RATING) 
VALUES
	('Stranger Things', 'Drama', 2016, 8.7),
	('Breaking Bad', 'Crime', 2008, 9.5),
	('The Crown', 'History', 2016, 8.6),
	('The Witcher', 'Fantasy', 2019, 8.2),
	('Black Mirror', 'Sci-Fi', 2011, 8.8);
    
INSERT INTO WATCH_HISTORY (USER_ID, MOVIE_ID, WATCHED_DATE, COMPLETION_PERCENTAGE) 
VALUES
	(1, 1, '2024-02-05', 100),
	(2, 2, '2024-02-06', 80),
	(3, 3, '2024-02-10', 50),
	(4, 4, '2024-02-15', 100),
	(1, 5, '2024-02-18', 90);
    
INSERT INTO REVIEWS (MOVIE_ID, USER_ID, REVIEW_TEXT, RATING, REVIEW_DATE) 
VALUES
	(1, 1, 'Amazing storyline and great characters!', 4.5, '2024-02-07'),
	(2, 2, 'Intense and thrilling!', 5.0, '2024-02-08'),
	(3, 3, 'Good show, but slow at times.', 3.5, '2024-02-12'),
	(4, 4, 'Fantastic visuals and acting.', 4.8, '2024-02-16');
-- ----------------------------------------------------------------------------
-- DATA VERIFICATION
SELECT * FROM USERS;
SELECT * FROM MOVIES;
SELECT * FROM WATCH_HISTORY;
SELECT * FROM REVIEWS;
-- ----------------------------------------------------------------------------   
-- 01. List all users subscribed to the Premium plan.
SELECT 	* 
FROM 	USERS
WHERE 	PLAN = 'PREMIUM';

-- 02. Retrieve all movies in the Drama genre with a rating higher than 8.5
SELECT 	* 
FROM 	MOVIES 
WHERE 	GENRE='Drama' AND RATING > 8.5;

-- 03. Find the average rating of all movies released after 2015
SELECT 	AVG(RATING) AVERAGE_RATING_2015 
FROM 	MOVIES 
WHERE 	RELEASE_YEAR > 2015;

-- 04. List the names of users who have watched the movie Stranger Things along with their completion percentage:
SELECT 	U.NAME
FROM 	WATCH_HISTORY WH INNER JOIN USERS U ON (U.USER_ID = WH.USER_ID)
		INNER JOIN MOVIES M ON (M.MOVIE_ID = WH.MOVIE_ID)
WHERE 	WH.COMPLETION_PERCENTAGE = 100
		AND M.TITLE = 'Stranger Things';

-- 05. Find the name of the user(s) who rated a movie the highest among all reviews:
SELECT 	U.* 
FROM 	REVIEWS R INNER JOIN USERS U ON (R.USER_ID = U.USER_ID)
WHERE 	R.RATING = (SELECT MAX(RATING) FROM REVIEWS);

-- 06. Calculate the number of movies watched by each user and sort by the highest count:
SELECT 		WH.USER_ID, U.NAME, COUNT(WH.MOVIE_ID) NO_OF_MOVIES_WATCHED
FROM 		WATCH_HISTORY WH INNER JOIN USERS U ON (WH.USER_ID = U.USER_ID)
GROUP BY 	WH.USER_ID
ORDER BY 	NO_OF_MOVIES_WATCHED DESC;

-- 07.List all movies watched by John Doe, including their genre, rating, and his completion percentage:
SELECT 	U.NAME, M.GENRE, R.RATING, WH.COMPLETION_PERCENTAGE
FROM 	WATCH_HISTORY WH INNER JOIN USERS U ON (WH.USER_ID = U.USER_ID)
		INNER JOIN MOVIES M ON (WH.MOVIE_ID = M.MOVIE_ID)
		INNER JOIN REVIEWS R ON (R.USER_ID = U.USER_ID)
WHERE 	U.NAME = 'John Doe';

-- 08.Update the movie's rating for Stranger Things:
SELECT * FROM MOVIES WHERE TITLE='Stranger Things';
SET SQL_SAFE_UPDATES = 0;
UPDATE MOVIES SET RATING = 9.1 WHERE TITLE='Stranger Things';

-- 09.Remove all reviews for movies with a rating below 4.0:
SELECT * FROM REVIEWS WHERE RATING < 4;
DELETE FROM REVIEWS WHERE RATING < 4;

-- 10. Fetch all users who have reviewed a movie but have not watched it completely (completion percentage < 100):
SELECT 	U.* 
FROM 	USERS U INNER JOIN REVIEWS R ON (U.USER_ID = R.USER_ID)
		INNER JOIN WATCH_HISTORY WH ON (U.USER_ID = WH.USER_ID)
WHERE 	WH.COMPLETION_PERCENTAGE < 100;

-- 11. List all movies watched by John Doe along with their genre and his completion percentage:
SELECT 	M.TITLE, M.GENRE, WH. COMPLETION_PERCENTAGE
FROM 	MOVIES M INNER JOIN WATCH_HISTORY WH ON (M.MOVIE_ID = WH.MOVIE_ID)
		INNER JOIN USERS U ON (U.USER_ID = WH.USER_ID)
WHERE 	U.NAME = 'John Doe';

-- 12.Retrieve all users who have reviewed the movie Stranger Things, including their review text and rating:
SELECT 	U.*, R.RATING, R.REVIEW_TEXT
FROM 	USERS U INNER JOIN REVIEWS R ON (U.USER_ID = R.USER_ID)
		INNER JOIN MOVIES M ON (M.MOVIE_ID = R.MOVIE_ID)
WHERE 	M.TITLE = 'Stranger Things';

-- 13. Fetch the watch history of all users, including their name, email, movie title, genre, watched date, and completion percentage:
SELECT 	U.NAME, U.EMAIL, M.TITLE, M.GENRE, WH.WATCHED_DATE, WH. COMPLETION_PERCENTAGE
FROM 	WATCH_HISTORY WH LEFT JOIN USERS U ON (WH.USER_ID = U.USER_ID)
		INNER JOIN MOVIES M ON (WH.MOVIE_ID = M.MOVIE_ID);

-- 14.List all movies along with the total number of reviews and average rating for each movie, including only movies with at least two reviews:
SELECT 	COUNT(R.REVIEW_ID) NO_OF_REVIEWS, AVG(R.RATING) AVERAGE_RATING
FROM	MOVIES M LEFT JOIN REVIEWS R ON  (M.MOVIE_ID = R.MOVIE_ID)
HAVING 	COUNT(R.REVIEW_ID) > 2;
