-- Netflix Project
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
select * from netflix1
select count (*) as total_content
from netflix1

-- 16 Business Problem Questions 

--1. How many total shows (Movies + TV Shows) are there?

 SELECT COUNT(*) AS total_shows FROM netflix1;

-- 2. How many movies and TV shows are there separately?

 SELECT type, COUNT(*) AS total FROM netflix1 GROUP BY type;

-- 3. What are the top 10 countries with the most Netflix shows?

 SELECT country, COUNT(*) AS total FROM netflix1 
GROUP BY country ORDER BY total DESC LIMIT 10;

--4. Find the top 5 countries with the most content on Netflix

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

-- 5. Find the oldest show available on Netflix.

 SELECT * FROM netflix1 ORDER BY release_year ASC LIMIT 1;

-- 6. Find the most recent show added to Netflix.

SELECT * FROM netflix1 ORDER BY date_added DESC LIMIT 1;

--7. List all shows directed by 'Rajkumar Hirani'.

 SELECT * FROM netflix1 WHERE director = 'Rajkumar Hirani';

-- 8. How many shows have a rating of 'TV-MA'?

 SELECT COUNT(*) AS total FROM netflix1 WHERE rating = 'TV-MA';

-- 9. Find all the shows where 'Shah Rukh Khan' is in the casts.

 SELECT * FROM netflix1 WHERE casts LIKE '%Shah Rukh Khan%';

-- -- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !


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

-- 11. List the top 10 directors with the most shows.

 SELECT director, COUNT(*) AS total FROM netflix1 
WHERE director IS NOT NULL 
GROUP BY director ORDER BY total DESC LIMIT 10;

--12. List the shows that belong to the 'Drama' category.

 SELECT * FROM netflix1 WHERE listed_in LIKE '%Drama%';

--13. Count of shows released each year.

 SELECT release_year, COUNT(*) AS total FROM netflix1 
GROUP BY release_year ORDER BY release_year;

-- 14. Find shows with no director mentioned.

 SELECT * FROM netflix1 WHERE director IS NULL

/* 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/


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

-- 16. Find all shows that were added in September.

SELECT * FROM netflix1 WHERE date_added LIKE 'September%';

-- 17. Find the most common rating for movies and TV shows.

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







 





