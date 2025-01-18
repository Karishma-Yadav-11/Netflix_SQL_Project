--Netflix Project

--Delete table if table already exists
DROP TABLE IF EXISTS netflix;


CREATE TABLE netflix
(
show_id	VARCHAR(6),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250)
);


-- To Check table
SELECT * FROM netflix;

-- Total Content
SELECT COUNT(*) AS Total_content
FROM netflix;

-- to find out distinct type of content
SELECT DISTINCT(type)
FROM netflix;


--Business Problems and Solutions

-- 1. Count the Number of Movies vs TV Shows


SELECT type, COUNT(*) AS Total_content
FROM netflix
GROUP BY type;


-- 2. Find the Most Common Rating for Movies and TV Shows

WITH rank_table AS
(
SELECT type, rating, COUNT(*),
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranks
FROM netflix
GROUP BY type, rating
)

SELECT type, rating
FROM rank_table
WHERE ranks = 1;

-- 3. List All Movies Released in a Specific Year (e.g., 2020)

SELECT title AS movies
FROM netflix
WHERE type = 'Movie' AND release_year= 2020;

-- 4. Find the Top 5 Countries with the Most Content on Netflix

SELECT UNNEST(STRING_TO_ARRAY(country,',')) AS Countries, count(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 5. Identify the Longest Movie

SELECT title AS Longest_Movies, duration
FROM netflix
WHERE type = 'Movie' AND duration = (SELECT MAX(duration) FROM netflix);

-- 6. Find Content Added in the Last 5 Years

SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'month DD, YYYY') >= current_date - INTERVAL '5 years';

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'

-- 8. List All TV Shows with More Than 5 Seasons

SELECT *
FROM netflix
WHERE type = 'TV Show' AND SPLIT_PART(duration,' ',1)::numeric >5;

-- 9. Count the Number of Content Items in Each Genre

SELECT UNNEST(STRING_TO_ARRAY(listed_in,',')) AS Genre, count(show_id) AS Total_Content
FROM netflix
GROUP BY 1
ORDER BY 1,2;

-- 10.Find each year and the average numbers of content release in India on netflix.

SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'month DD, YYYY')) as year, COUNT(*),
	   ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country ILIKE '%India%')::numeric * 100, 2) AS avg_content_per_year
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 1;

-- 11. List All Movies that are Documentaries

SELECT *
FROM Netflix
WHERE listed_in ILIKE '%Documentaries%';

-- 12. Find All Content Without a Director

SELECT *
FROM Netflix
WHERE director IS NULL;

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT count(title) AS Total_Salman_Khan_Movies_Last_10yrs
FROM Netflix
WHERE casts ILIKE '%Salman Khan%' AND release_year >= EXTRACT (YEAR FROM CURRENT_DATE) - 10;

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors, COUNT(*) AS total_movies
FROM Netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

WITH Label AS	
(
SELECT title,
	   CASE
	   		WHEN description ILIKE '%Kill%' OR description ILIKE '%Violence%' THEN 'Bad_content'
			ELSE 'Good_content'
		END AS Category, description
FROM netflix
)

SELECT category, COUNT(*) AS total_content
FROM label
GROUP BY 1;
