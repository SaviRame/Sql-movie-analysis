USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

select table_name, 
	   table_rows 
from information_schema.tables 
where table_schema = 'imdb';

--my learining count(*) value is precise but the information_schema table_rows is an estimate not accurate but faster



show columns from movie;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select sum(case when title is null then 1 else 0 end) as column2_null_count,
		sum(case when year is null then 1 else 0 end) as column3_null_count,
		sum(case when date_published is null then 1 else 0 end) as column4_null_count,
		sum(case when duration is null then 1 else 0 end) as column5_null_count,
		sum(case when country is null then 1 else 0 end) as column6_null_count,
		sum(case when worlwide_gross_income is null then 1 else 0 end) as column7_null_count,
		sum(case when languages is null then 1 else 0 end) as column8_null_count,
		sum(case when production_company is null then 1 else 0 end) as column9_null_count
from movie;


-- 4 columns has null values. Column 7 worldwide_cross_income has the most null values of 3724





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


select year, 
	   count(id) as number_of_movies 
from movie group by year; 

select month(date_published) as month_num , 
	   count(id) as number_of_movies 
from movie 
group by month(date_published) 
order by number_of_movies desc;

-- Highest number of movies is produced in the month of march 824 and 809 in the month of september




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select count(id) 
from movie 
where country in('USA','India') and year = 2019;


select count(id) 
from movie 
where (country = 'USA' or country = 'India') and year = 2019;

--learning when using OR and AND condition together put paranthesis correctly because AND has higher precedence than OR


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select DISTINCT genre 
from genre;








/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


select genre, 
	   count(id) as movie_count 
from movie m join genre g 
on m.id = g.movie_id 
group by genre 
order by movie_count desc 
limit 1; 







/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

select count(*) as movie_count 
from(select id from movie m join genre g 
on m.id = g.movie_id 
group by id 
having count(*) = 1)as t;




/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

select genre, 
		round(avg(duration),2)  as avg_duration 
from movie m join genre g 
on m.id = g.movie_id 
group by genre 
order by avg_duration DESC ;

-- action genre movie has the highest average duration and horror genre movies has the lowest average duration




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

select genre, 
	   movie_count ,
	   dense_rank() over(order by movie_count desc) 
from(select genre, 
			count(id) as movie_count 
	 from movie m join genre g on m.id = g.movie_id 
	 group by genre 
	 )as t
-- Drama has the most movies next two highest movie genres are comedy and thriller.







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


select min(avg_rating), 
	   max(avg_rating), 
	   min(total_votes), 
	   max(total_votes), 
	   min(median_rating), 
	   max(median_rating) 
from ratings;



    

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


 select title, 
		avg_rating, 
		dense_rank() over(order by avg_rating desc) as movie_rank 
 from movie m join ratings r on m.id = r.movie_id 
 order by movie_rank 
 limit 10;


select title, 
	   avg_rating 
from movie m join ratings r 
on m.id = r.movie_id 
where title = 'Love in Kilnerry';

-- as of now love in kilnerrry avg_rating is only 5.5 

-- kirket and love in kilnerry are the top rated films

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

select median_rating,
	   count(movie_id) as movie_count
from ratings 
group by median_rating 
order by movie_count desc;



-- median rating 7,6,8 has 2257,1975,1030 movies respectively median rating 1 has least 94 movies




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

select production_company, count(id) as movie_count, dense_rank() over(order by count(id) desc) as prod_company_rank 
from movie m join ratings r 
on m.id = r.movie_id 
where avg_rating > 8
group by production_company ;







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


select genre,
	   count(id) as movie_count 
from movie m join genre g
on m.id = g.movie_id 
join ratings r 
on m.id = r.movie_id 
where country = 'USA' and (date_published between '2017-03-01' and '2017-03-31') and total_votes > 1000
group by genre
order by movie_count desc;





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

select title,
	   avg_rating,
	   genre
from movie m join ratings r
on m.id = r.movie_id
join genre g 
on m.id = g.movie_id 
where avg_rating > 8 and title like 'The%';







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select median_rating, 
	   count(id) as movie_count 
from movie m join ratings r
on m.id = r.movie_id 
where date_published BETWEEN '2018-04-01' and '2019-04-01' and median_rating =8; 







-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select country, 
	   sum(total_votes) as sum_votes
from movie m join ratings r
on m.id = r.movie_id 
where country in('Germany', 'Italy')
group by country;


-- Germany has 106,710 votes. Italy has 77,965 votes



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

select sum(case when name is null then 1 else 0 end) as name_nulls,
	   sum(case when height is null then 1 else 0 end) as height_nulls,
	   sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
	   sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls
from names;






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


WITH top_genres AS (
    SELECT g.genre
    FROM genre g
    JOIN movie m ON g.movie_id = m.id
    GROUP BY g.genre
    ORDER BY COUNT(g.movie_id) DESC
    LIMIT 3
),
top_genre_movies AS (
    SELECT r.movie_id
    FROM ratings r
    JOIN genre g ON r.movie_id = g.movie_id
    WHERE g.genre IN (SELECT genre FROM top_genres)
    GROUP BY r.movie_id
    HAVING AVG(r.avg_rating) > 8
),
director_movie_count AS (
    SELECT d.name_id, COUNT(DISTINCT d.movie_id) AS movie_count
    FROM director_mapping d
    JOIN top_genre_movies tgm ON d.movie_id = tgm.movie_id
    GROUP BY d.name_id
)
SELECT n.name AS director_name,
       dmc.movie_count AS movie_count
FROM names n
JOIN director_movie_count dmc ON n.id = dmc.name_id
order by movie_count desc
limit 3;


							 


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
use imdb;
select category from role_mapping;



with med_rating_8_actors as
(select name_id, movie_id 
 from role_mapping 
 where movie_id in(
       select movie_id 
	   from ratings 
	   where median_rating >=8) and category = 'actor'
)
select name, 
	   count(movie_id) as movie_count 
from names n join med_rating_8_actors m on n.id = m.name_id 
group by name
order by movie_count desc
limit 2;




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

select production_company, vote_count, dense_rank() over(order by vote_count desc) prod_comp_rank 
from(select production_company, sum(total_votes) as vote_count
from movie m join ratings r on m.id = r.movie_id
group by production_company
) as t;








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


with indian_movie as(
     select name_id 
     from movie m join role_mapping r on m.id = r.movie_id 
     where country = 'India' and category = 'actor'
     group by name_id
     having count(id) >= 5),
actors as(    
	select n.name, r.movie_id, total_votes,avg_rating
	from indian_movie i join role_mapping r on i.name_id = r.name_id 
	join names n on n.id = r.name_id
	join ratings rt on rt.movie_id = r.movie_id
	)
select name as actor_name, sum(total_votes) as total_votes, 
	   count(movie_id), round(avg(avg_rating),2) as actor_avg_rating, 
	   dense_rank() over(order by ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC, 
            SUM(rt.total_votes) DESC)
from actors
group by name;








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

with indian_movie as(
     select name_id 
     from movie m join role_mapping r on m.id = r.movie_id 
     where languages = 'Hindi' and category = 'actress'
     group by name_id
     having count(id) >= 3),
actors as(    
	select n.name, r.movie_id, total_votes,avg_rating
	from indian_movie i join role_mapping r on i.name_id = r.name_id 
	join names n on n.id = r.name_id
	join ratings rt on rt.movie_id = r.movie_id
	)
select name as actor_name, sum(total_votes) as total_votes, 
	   count(movie_id), round(avg(avg_rating),2) as actress_avg_rating, 
	   dense_rank() over(order by ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC, 
            SUM(rt.total_votes) DESC)
from actors
group by name;







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

select title, genre, case when avg_rating > 8 then 'Superhit movies' 
			   when avg_rating between 7 and 8 then 'Hit movies'
			   when avg_rating between 5 and 7 then 'One-time-watch movies'
			   else 'Flop movie'
			  end as Rating_category
from 
	genre g 
join 
	movie m on m.id = g.movie_id
join 
	ratings r on g.movie_id = r.movie_id
where genre = 'Thriller';







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



SELECT 
    g.genre, 
    AVG(m.duration) over(PARTITION by genre)AS avg_duration, 
    SUM(m.duration) OVER (ORDER BY m.duration ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_duration,
    AVG(m.duration) OVER (ORDER BY m.duration ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_duration
FROM 
    genre g
JOIN 
    movie m ON g.movie_id = m.id
   order by avg_duration;


-- Action genre movies has the most average duration and crime has the lowest average duration



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



WITH top_genre AS (
    SELECT 
        g.genre, 
        COUNT(m.id) AS movie_count
    FROM 
        genre g
    JOIN 
        movie m ON g.movie_id = m.id
    GROUP BY 
        g.genre
    ORDER BY 
        movie_count DESC 
    LIMIT 3
),
movie_ranks AS (
    SELECT 
        g.genre, 
        m.year, 
        m.title AS movie_name, 
        m.worlwide_gross_income, 
        DENSE_RANK() OVER (PARTITION BY m.year ORDER BY m.worlwide_gross_income DESC) AS movie_rank
    FROM 
        movie m
    JOIN 
        genre g ON m.id = g.movie_id
    WHERE 
        g.genre IN (SELECT genre FROM top_genre)
)
SELECT 
    mr.genre, 
    mr.year, 
    mr.movie_name, 
    mr.worlwide_gross_income, 
    mr.movie_rank
FROM 
    movie_ranks mr
WHERE 
    mr.movie_rank <= 5;






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

with mul_lingual_prod as(select production_company 
							from movie
							group by production_company 
							having count(languages) >1
						)
select m.production_company, count(movie_id) as movie_count, 
	   dense_rank() over(order by count(movie_id) desc) as prod_comp_rank
from 
	movie m 
join 
	ratings r 
on 
	m.id = r.movie_id
where 
	m.production_company in(select ml.production_company from mul_lingual_prod as ml)
and median_rating >= 8
group by 
	m.production_company ;
	
	

							






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

with drama_actress as(
select g.movie_id,
	   rm.name_id
from 
	genre g
join 
	role_mapping rm
on 
	g.movie_id = rm.movie_id
where rm.category = 'Actress' and genre = 'Drama'
)
select n.name,
	   sum(r.total_votes) as total_votes,
	   count(r.movie_id) as movie_count,
	   avg(avg_rating) as actress_avg_rating,
	   dense_rank() over(order by count(r.movie_id) desc) as actress_rank
	   
from 
	drama_actress da
join 
	ratings r
on 
	da.movie_id = r.movie_id
join 
	names n 
on
	n.id = da.name_id
where avg_rating > 8
group by n.name;






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







