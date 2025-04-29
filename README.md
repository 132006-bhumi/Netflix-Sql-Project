# Netflix Movies and TV Shows Data Anlysis Unsing SQL 
![Netflix Logo](https://github.com/132006-bhumi/netflix_sql_project/blob/main/download%20(3).jpeg)
# Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.
# Objectives
Analyze the distribution of content types (movies vs TV shows).
Identify the most common ratings for movies and TV shows.
List and analyze content based on release years, countries, and durations.
Explore and categorize content based on specific criteria and keywords.
# Schema
```sql
create table netflix1(
show_id varchar(6),
type  varchar(10),
tittle varchar(150),
director varchar(208),
casts  varchar(1000),
country varchar(150),
date_added varchar(50),
release_year  int,
rating varchar(10),
duration varchar(15),
listed_in varchar(100),
description varchar(250)
);
```
***
# Business Problems and Solutions
--1. How many total shows (Movies + TV Shows) are there?
```sql
 SELECT COUNT(*) AS total_shows FROM netflix1;
```
--2. How many movies and TV shows are there separately?
```sql
 SELECT type, COUNT(*) AS total FROM netflix1 GROUP BY type;
```
--3. What are the top 10 countries with the most Netflix shows?
```sql
 SELECT country, COUNT(*) AS total FROM netflix1 
GROUP BY country ORDER BY total DESC LIMIT 10;
```
--4. Find the top 5 countries with the most content on Netflix
```sql
SELECT * 
FROM
(
	SELECT 
		-- country,
		UNNEST(STRING_TO_ARRAY(country, ',')) as country,
		COUNT(*) as total_content
	FROM netflix1
	GROUP BY 1
)as t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5
```
--5. Find the oldest show available on Netflix.
```sql
 SELECT * FROM netflix1 ORDER BY release_year ASC LIMIT 1;
```
--6. Find the most recent show added to Netflix.
```sql
SELECT * FROM netflix1 ORDER BY date_added DESC LIMIT 1;
```
--7. List all shows directed by 'Rajkumar Hirani'.
```sql
 SELECT * FROM netflix1 WHERE director = 'Rajkumar Hirani';
```
--8. How many shows have a rating of 'TV-MA'?
```sql
 SELECT COUNT(*) AS total FROM netflix1 WHERE rating = 'TV-MA';
```
--9. Find all the shows where 'Shah Rukh Khan' is in the casts.
```sql
 SELECT * FROM netflix1 WHERE casts LIKE '%Shah Rukh Khan%';
```
10. /*Find each year and the average numbers of content release by India on netflix. 
    return top 5 year with highest avg content release !
    */
```sql
SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix1 WHERE country = 'India')::numeric * 100 
		,2
		)
		as avg_release
FROM netflix1
WHERE country = 'India' 
GROUP BY country, 2
ORDER BY avg_release DESC 
LIMIT 5
```
--11. List the top 10 directors with the most shows.
```sql
 SELECT director, COUNT(*) AS total FROM netflix1 
WHERE director IS NOT NULL 
GROUP BY director ORDER BY total DESC LIMIT 10;
```
--12. List the shows that belong to the 'Drama' category.
```sql
 SELECT * FROM netflix1 WHERE listed_in LIKE '%Drama%';
```
--13. Count of shows released each year.
```sql
 SELECT release_year, COUNT(*) AS total FROM netflix1 
GROUP BY release_year ORDER BY release_year;
```
--14. Find shows with no director mentioned.
```sql
 SELECT * FROM netflix1 WHERE director IS NULL
```
/*15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/
```sql
SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix1
) AS categorized_content
GROUP BY 1,2
ORDER BY 2
```
-- 16. Find all shows that were added in September.
```sql
SELECT * FROM netflix1 WHERE date_added LIKE 'September%';
```
-- 17. Find the most common rating for movies and TV shows.
```sql
WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix1
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;
```
# Objective:
Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

# Findings and Conclusion
#Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.

#Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.

#Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.

#Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

