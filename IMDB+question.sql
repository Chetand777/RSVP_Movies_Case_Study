USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT table_name, table_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE table_schema = 'imdb';

-- INFORMATION_SCHEMA.TABLES allows you to get info about all tables 
-- and views within DB. The query will provide the number of rows for each 
-- table. There are 6 columns in movie table. The column 'names' contain
-- max number of rows ie 23345, followed by 'role_mapping' 15693 and 'genre' 14662.





-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT SUM(id IS NULL) id,
	   SUM(title IS NULL) title,
       SUM(year IS NULL) year,
       SUM(date_published IS NULL) date_published,
       SUM(duration IS NULL) duration,
       SUM(country IS NULL) country,
       SUM(worlwide_gross_income IS NULL) worlwide_gross_income,
       SUM(languages IS NULL) languages,
       SUM(production_company IS NULL) production_company
FROM movie;

-- The null values present in column 'country' are 20, 'worlwide_gross_income'
-- 3724, 'language' 194 and 'production_company' 528. The null values in other
-- columns are 0.







-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year, 
	   COUNT(id) AS number_of_movies
FROM movie
GROUP BY year
ORDER BY year;

-- The number of movies released in 2017 are maximum ie 3052 
-- followed by year 2018 2944 and 2019 2001.

SELECT MONTH(date_published) AS month_num, 
	   COUNT(id) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;

-- The maximum number of movies released in march ie 824.
-- In the december month less number of movies are released ie 438.




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT year, 
	   country, 
       COUNT(id) AS number_of_movies
FROM movie 
WHERE (country LIKE '%USA%' OR 
	  country LIKE '%India%' ) 
      and year = '2019'
GROUP BY year; 

-- 1059 movies were produced in USA or India in the year 2019





/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre AS list_of_genre
FROM genre;

-- There are total 13 unique genres present in the data set.







/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


SELECT DISTINCT genre AS list_of_genre,
	   COUNT(movie_id) AS number_of_movies_produced_overall
FROM genre
GROUP BY genre
ORDER BY number_of_movies_produced_overall desc;
	   
-- The number_of_movies produced overall for genre 'Drama' are maximum ie 4285
-- followed by 'Comedy' and 'Thriller'. Less number_of_movies are produced
-- from genre type 'Others' ie 100.






/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH only_one_genre AS 
	(SELECT movie_id,
		   COUNT(genre) AS genre
	FROM genre
	GROUP BY movie_id
	HAVING genre = 1)
SELECT COUNT(movie_id) AS one_genre_movie
FROM only_one_genre;

-- There are 3289 number_of_movies belong to only one genre.








/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, 
	   AVG(duration) AS avg_duration
FROM genre G
INNER JOIN movie M
ON G.movie_id = M.id
GROUP BY genre
ORDER BY genre desc;

-- The movies belong to genre 'Action' have max avg_duration of 113 min and 
-- the movies belong to genre 'Horror' have min avg_duration of 93 min. 






/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT genre,
	   COUNT(movie_id) AS movie_count,
       RANK() OVER( ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM genre
GROUP BY genre;

-- The rank of 'Thriller' genre of movies among all the genres is 3 
-- in terms of number_of_movies produced.











/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(avg_rating) AS min_avg_rating,
	   MAX(avg_rating) AS max_avg_rating,
       MIN(total_votes) AS min_total_votes,
       MAX(total_votes) AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
	   MAX(median_rating) AS max_median_rating
FROM ratings;
       
-- min_avg_rating = 1,
-- max_avg_rating = 10,
-- min_total_votes = 100,
-- max_total_votes= 725138,
-- min_median_rating = 1,
-- max_median_rating = 10.



    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT title,
	   avg_rating,
       DENSE_RANK() OVER (ORDER BY avg_rating DESC) AS movie_rank
FROM ratings R
INNER JOIN movie M
ON R.movie_id = M.id;

-- The movie title 'Kirket' and 'Love in Kilnerry' has highest avg_rating
-- of 10 followed by 'Gini Helida Kathe' and 'Runam'
-- The titles 'Ritoru Kyouta no bouken', 'Pure Hearts: Into Chinese Showbiz',
-- 'Cumali Ceber: Allah Seni Alsin', 'Badang' has lowest avg_rating of 1




/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
	   COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;

-- There are 346 movie_counts which have median_rating of 10 and 
-- 94 movie_counts have median_rating of 1






/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
	   COUNT(id) AS movie_count,
	   DENSE_RANK() OVER (ORDER BY COUNT(id) DESC) AS prod_company_rank
FROM movie M
INNER JOIN ratings R
ON M.id = R.movie_id
WHERE avg_rating>8
GROUP BY production_company;

-- The name of production house which has produced the most number of hit movies
-- is not spcified.
-- The production houses 'National Theatre Live' and 'Dream Warrior Pictures'
-- also produced hit movies followed by the unknown production company.





-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
	   COUNT(G.movie_id)AS movie_count
FROM genre G
INNER JOIN movie M
ON G.movie_id = M.id
INNER JOIN ratings R
ON M.id = R.movie_id
WHERE year = 2017 AND 
	  MONTH(date_published) = 3 AND
      country LIKE '%USA%' AND
      total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;

-- The genre 'Drama' has max number of movie counts 24 which are released
-- during March 2017 in USA with total votes greater than 1000.







-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title,
	   avg_rating,
	   genre
FROM movie M
INNER JOIN ratings R
ON R.movie_id = M.id
INNER JOIN genre G
ON G.movie_id = M.id
WHERE title LIKE 'The%' AND 
	  avg_rating > 8
ORDER BY genre, avg_rating DESC;

-- There are 15 movies whose title starts with 'The' and having avg_rating
-- greater than 8.






-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(id) AS movie_count,
	   median_rating
FROM movie M
INNER JOIN ratings R
ON R.movie_id = M.id
WHERE date_published BETWEEN '2018-4-1' AND '2019-4-1' AND
	  median_rating = 8;

-- 361 movies released between 1 April 2018 and 1 April 2019
-- having a median_rating of 8.





-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT Country,
	   SUM(total_votes) AS total_votes
FROM movie M
INNER JOIN ratings R
ON M.id = R.movie_id
WHERE Country LIKE '%German%';

-- 2026223 is the sum of total votes for German movies

SELECT Country,
	   SUM(total_votes) AS total_votes
FROM movie M
INNER JOIN ratings R
ON M.id = R.movie_id
WHERE Country LIKE 'Ital%';

-- 364051 is the sum of total votes for Italian movies
-- German movies get more votes than Italian movies.

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT SUM(name IS NULL)name,
	   SUM(height IS NULL)height,
       SUM(date_of_birth IS NULL)date_of_birth,
       SUM(known_for_movies IS NULL)known_for_movies
FROM names;

-- Maximum number of null values are present in 'height' column followed by 
-- 'date_of_birth' and 'known_for_movies'.





/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genres AS (
	SELECT genre,
	   COUNT(id) AS movie_count,
       RANK() OVER (ORDER BY COUNT(id) DESC) AS genre_rank
	FROM genre G 
	INNER JOIN movie M
    ON G.movie_id = M.id
    INNER JOIN ratings R
    ON M.id = R.movie_id
    WHERE avg_rating > 8
    GROUP BY genre
)
		   
SELECT name AS director_name,
	   COUNT(N.id) AS movie_count
FROM names N
INNER JOIN director_mapping D
ON N.id = D.name_id
INNER JOIN movie M
ON M.id =  D.movie_id
INNER JOIN genre G
ON G.movie_id = D.movie_id 
INNER JOIN ratings R
ON R.movie_id = D.movie_id
WHERE avg_rating > 8 AND 
	  genre IN ( 
		SELECT DISTINCT genre
        FROM top_3_genres
        WHERE genre_rank <= 3
        )
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;
	
-- The top 3 directors are :
-- James Mangold                    4
-- Joe Russo                        3
-- Anthony Russo                    3
-- The avg_rating of the movies made by these directors is greater than 8.






/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT name AS actor_name,
	   COUNT(N.id) AS movie_count
FROM names N
INNER JOIN role_mapping R
ON N.id = R.name_id
INNER JOIN movie M
ON M.id = R.movie_id
INNER JOIN ratings RT
ON RT.movie_id = R.movie_id
WHERE median_rating >= 8
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

-- The top 2 actors are :
-- Mammootty	8
-- Mohanlal		5
-- The median rating of these actor's movies is greater than or equal to 8.




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
	   SUM(total_votes) AS vote_count,
       RANK() OVER (ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie M
INNER JOIN ratings R
ON M.id = R.movie_id
GROUP BY production_company
LIMIT 3;

-- Top three production houses based on the number of votes received by their movies are:
-- Marvel Studios                                   1
-- Twentieth Century Fox                            2
-- Warner Bros.                                     3






/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH indian_actor AS
(	SELECT name AS actor_name,
		   total_votes,
		   (M.id),
		   avg_rating,
		   total_votes*avg_rating AS w_avg
	FROM names N
	INNER JOIN role_mapping RM
	ON RM.name_id = N.id
	INNER JOIN ratings R
	ON RM.movie_id = R.movie_id
	INNER JOIN movie M
	ON M.id = RM.movie_id
	WHERE category = 'Actor' AND
		  country LIKE 'IND%'
	ORDER BY actor_name
),

Actor AS
(  SELECT *,
	      SUM(w_avg) OVER W1 AS rating,
          SUM(total_votes) OVER W2 AS votes
	FROM indian_actor
    WINDOW W1 AS (PARTITION BY actor_name),
		   W2 AS (PARTITION BY actor_name)
)				
		
SELECT actor_name,
	   votes AS total_votes,
	   COUNT(id) AS movie_count,
       rating/votes AS actor_avg_rating,
       DENSE_RANK() OVER(ORDER BY rating/votes DESC) AS actor_rank
FROM Actor
GROUP BY actor_name
HAVING movie_count >= 5;

       
       
   -- The top actor is Vijay Sethupathi.







-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH indian_actress AS
(	SELECT name AS actress_name,
		   total_votes,
		   (M.id),
		   avg_rating,
		   total_votes*avg_rating AS w_avg
	FROM names N
	INNER JOIN role_mapping RM
	ON RM.name_id = N.id
	INNER JOIN ratings R
	ON RM.movie_id = R.movie_id
	INNER JOIN movie M
	ON M.id = RM.movie_id
	WHERE category = 'Actress' AND
		  languages = 'Hindi'
	ORDER BY actress_name
),

Actress AS
(  SELECT *,
	      SUM(w_avg) OVER W1 AS rating,
          SUM(total_votes) OVER W2 AS votes
	FROM indian_actress
    WINDOW W1 AS (PARTITION BY actress_name),
		   W2 AS (PARTITION BY actress_name)
)				
		
SELECT actress_name,
	   votes AS total_votes,
	   COUNT(id) AS movie_count,
       rating/votes AS actor_avg_rating,
       DENSE_RANK() OVER(ORDER BY rating/votes DESC) AS actress_rank
FROM Actress
GROUP BY actress_name
HAVING movie_count >= 3;


-- The top actress is Taapsee Pannu.




/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT title,
	   avg_rating,
       CASE	WHEN avg_rating > 8 THEN 'Superhit'
		    WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit'
            WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
            ELSE 'Flop'
		END AS movie_type
FROM movie M
INNER JOIN ratings R
ON M.id = R.movie_id
INNER JOIN genre G
ON G.movie_id = M.id
WHERE genre = 'thriller';








/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


WITH genre_summary AS
(	SELECT genre,
			AVG(duration) AS avg_duration
	FROM genre G
	INNER JOIN movie M
	ON M.id = G.movie_id
	GROUP BY genre
)
SELECT *,
	   SUM(avg_duration) OVER W1 AS running_total_duration,
       AVG(avg_duration) OVER W2 AS moving_avg_duration
FROM genre_summary
WINDOW W1 AS (ORDER BY genre ROWS UNBOUNDED PRECEDING),
	   W2 AS (ORDER BY genre ROWS UNBOUNDED PRECEDING);





-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_3_genres AS (
	SELECT genre,
	   COUNT(id) AS movie_count,
       RANK() OVER (ORDER BY COUNT(id) DESC) AS genre_rank
	FROM genre G 
	INNER JOIN movie M
    ON G.movie_id = M.id
    INNER JOIN ratings R
    ON M.id = R.movie_id
    GROUP BY genre
    LIMIT 3
),

Highest_grossing AS(
	SELECT genre,
		   year,
           title AS movie_name,
           worlwide_gross_income,
           RANK() OVER (PARTITION BY genre
						ORDER BY CONVERT(REPLACE(TRIM(worlwide_gross_income), "$ ",""), UNSIGNED INT) DESC) AS movie_rank
	FROM genre G 
	INNER JOIN movie M
    ON G.movie_id = M.id
    WHERE genre IN (SELECT DISTINCT genre FROM top_3_genres)
)

SELECT * 
FROM Highest_grossing
WHERE movie_rank <= 5;





-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
	   COUNT(id) AS movie_count,
       RANK() OVER( ORDER BY  COUNT(id) DESC) AS prod_comp_rank
FROM movie M
INNER JOIN ratings R
ON M.id = R.movie_id
WHERE median_rating >= 8 AND
	  POSITION(','IN languages)>0 AND
      production_company IS NOT NULL 
GROUP BY production_company
LIMIT 2;

-- The top 2 production houses are :
-- Star Cinema                 7                 1
-- Twentienth Century Fox      4                 2





-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT name AS actress_name,
		SUM(total_votes) AS total_votes,
		COUNT(M.id) AS movie_count,
		SUM(total_votes*avg_rating)/SUM(total_votes) AS actress_avg_rating,
		RANK() OVER (ORDER BY SUM(total_votes*avg_rating)/SUM(total_votes) DESC, total_votes DESC) AS actress_rank
FROM names N
INNER JOIN role_mapping RM
ON RM.name_id = N.id
INNER JOIN ratings R
ON RM.movie_id = R.movie_id
INNER JOIN movie M
ON M.id = RM.movie_id
INNER JOIN genre G
ON G.movie_id = RM.movie_id
WHERE category = 'Actress' AND
		avg_rating > 8 AND
          genre = 'Drama'
GROUP BY actress_name
LIMIT 3;

-- The top 3 actresses based on number of Super Hit movies:
-- Sangeetha Bhat                                                 1
-- Fatmire Sahiti                                                 2
-- Pranati Rai Prakash                                            3






/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH top_9_directors AS
(	SELECT N.id AS director_id,
	       N.name AS director_name,
           COUNT(DISTINCT M.id) AS number_of_movies,
           DENSE_RANK() OVER (ORDER BY COUNT(M.id) DESC) AS director_rank
	FROM names N
    INNER JOIN director_mapping D
    ON N.id = D.name_id
    INNER JOIN movie M
    ON M.id = D.movie_id
    GROUP BY director_id
),

movie_summary AS
(	SELECT N.id as director_id,
           N.name as director_name,
           M.id AS movie_id,
           M.date_published,
           R.avg_rating,
           R.total_votes,
           M.duration,
           LEAD(date_published) OVER (PARTITION BY n.id 
									  ORDER BY m.date_published) AS next_date_published,
           DATEDIFF(LEAD(date_published) OVER (PARTITION BY n.id 
											   ORDER BY m.date_published), date_published) AS inter_movie_days 
    FROM names AS N
	INNER JOIN director_mapping AS D
	ON N.id = D.name_id 
	INNER JOIN movie AS M
	ON D.movie_id = M.id 
	INNER JOIN ratings AS R 
	ON M.id = R.movie_id 
    WHERE n.id IN (SELECT director_id 
				   FROM top_9_directors 
                   WHERE director_rank <= 9)
)

SELECT director_id,
       director_name,
       COUNT(DISTINCT movie_id) AS number_of_movies,
	   AVG(inter_movie_days) AS avg_inter_movie_days,
       SUM(avg_rating*total_votes) / SUM(total_votes) AS avg_rating,
       SUM(total_votes) AS total_votes,
       MIN(avg_rating) AS min_rating,
       MAX(avg_rating) AS max_rating,
       SUM(duration) AS total_duration
FROM movie_summary
GROUP BY director_id
ORDER BY number_of_movies DESC,
	     avg_rating DESC;
	   


