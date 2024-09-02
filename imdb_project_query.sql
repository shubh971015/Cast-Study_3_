use subquery_practice_campusx;
select * from directors;
select * from movies;
select movie_title, duration,
(case when duration > 120 then "yes" else "no" end) runtime
from movies
order by runtime asc
;


alter table directors rename column Directors to Directors_name;


-- 4.	What is the highest and lowest grossing, highest and lowest budget movies in the Database?
select movie_title ,gross from movies
where gross = (select max(gross) from movies);
select movie_title ,gross from movies
where gross = (select min(gross) from movies);


select movie_title ,budget from movies
where budget = (select max(budget) from movies);
select movie_title ,budget from movies
where budget = (select min(budget) from movies)
limit 1
;
-- 6.	Find the top 5 genres based on the number of movies released in the last 5 years.
select * from movies;
select  genres,count(*) as no_of_movies_relesed from movies
group by genres
order by no_of_movies_relesed  desc
limit 5;

-- 7.	Retrieve the movie titles directed by a director whose average movie duration is above the overall average duration.


SELECT d.Directors_name, t1.movie_title, t1.duration
FROM directors AS d
	JOIN
    (SELECT movie_title, Director_ID, duration
    FROM movies
    WHERE duration > (SELECT 
                     AVG(duration) FROM movies)
ORDER BY duration ASC) AS t1 ON d.D_id = t1.Director_ID
ORDER BY t1.duration ASC;





-- 8.	Calculate the average budget of movies over the last 3 years, including the average budget for each movie.
'''
# khup pareshan kela question n check again practice it again 
'''

 select m.movie_title,m.budget,t.avg_yearly_budget from movies m 
 join 
(select m.title_year,
avg(budget) over(partition by title_year) as avg_yearly_budget
from movies
group by title_year
order by title_year desc) as t 
;

'''select title_year,round(avg(budget) over (partition by title_year),3) from movies order by title_year desc;'''

SELECT 
    title_year, 
    ROUND(AVG(budget) OVER (ORDER BY title_year DESC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 3) AS avg_budget_last_3_years,
    budget
FROM movies
ORDER BY title_year DESC;
SELECT title_year, ROUND(AVG(budget) OVER (PARTITION BY title_year), 3) AS avg_budget_per_year 
FROM movies 
ORDER BY title_year DESC;
    
"" wrong one""
'''(SELECT ROUND(AVG(budget), 2) AS average_budget_last_3_years FROM movies
WHERE title_year IN (
    SELECT DISTINCT title_year
    FROM movies
    ORDER BY title_year DESC
    LIMIT 3
);
SELECT ROUND(AVG(budget), 2) AS average_budget_last_3_years FROM movies
JOIN (
    SELECT DISTINCT title_year
    FROM movies
    ORDER BY title_year DESC
    LIMIT 3
) AS last_3_years
ON movies.title_year = last_3_years.title_year;'''

-- corrected by chatgpt 
SELECT 
	m.title_year,
    m.movie_title,
    m.budget,
    t.avg_yearly_budget
FROM 
    movies m
JOIN 
    (SELECT 
         movie_id,
         ROUND(AVG(budget) OVER (PARTITION BY title_year), 2) AS avg_yearly_budget
     FROM 
         movies
     WHERE 
         title_year > 2013
    ) AS t ON m.movie_id = t.movie_id;
    
   ######################################################################################################## 
-- 9.	Retrieve a list of movies with their genres, including only those genres that have more than 5 movies.

select * from directors;
select * from movies;
'''select * from
(select movie_title , genres, count(movie_title) as movie_count from movies
group by genres
order by  count(movie_title) desc ) as t 
where movie_count > 5 ; '''  -- dont need to  make temporary table ( i forgot having clause)

select movie_title , genres, count(movie_title) as movie_count from movies
group by genres
having movie_count >5
order by  movie_count asc;

######################################################################################################## 
-- 10.	Find the directors who have directed at least 3 movies and have an average IMDb score above 7.

select  Director_ID,count(*) as no_of_movie_directed, round(avg(imdb_score)) as avg_score from movies
group by Director_ID
having  count(*) >=3 and avg(imdb_score) > 7  -- having clause is calculated field clause because they are calculated fields and not available at that stage of query processing.
                                              --  You need to use the original aggregate functions or expressions in the HAVING clause.
order by no_of_movie_directed desc;


select * from movies;
#########################################################################################################
"good question"
-- 11.	List the top 3 actors who have appeared in the most movies, and for each actor, 
	 -- provide the average IMDb score of the movies they appeared in.

#########################################################################################################
-- 12.	For each year, find the movie with the highest gross, and retrieve the second highest gross in the same result set.
-- need practice such type of question
    SELECT 
        movie_title,
        gross,
        title_year,
        RANK() OVER (PARTITION BY title_year ORDER BY gross DESC) AS rank_within_year
    FROM 
        movies;


SELECT 
   *
FROM (
    SELECT 
        movie_title,
        gross,
        title_year,
        RANK() OVER (PARTITION BY title_year ORDER BY gross DESC) AS rank_within_year
    FROM 
        movies
) AS ranked_movies
where rank_within_year = 2
ORDER BY title_year DESC;

#######################################################################################################################
-- 14.	Retrieve the top 3 movies based on IMDb score, and include their ranking.
select * from movies
order by imdb_score desc
limit 3;

#######################################################################################################################
-- 15.	For each director, list their movies along with the IMDb score and the ranking of each movie based on IMDb score.
select Director_ID, imdb_score, movie_title,
rank() over( partition by Director_ID  order by imdb_score desc ) as rank_within_director from movies
;
-- 16.	Find the movie with the highest budget in each genre, and include the row number for each movie within its genre.
select count(*) from movies
group by genres; 
select * from
(select movie_title,budget, 
row_number() over(partition by genres) as row_numbers ,genres from movies)as t
where row_numbers=1 ; 





 



