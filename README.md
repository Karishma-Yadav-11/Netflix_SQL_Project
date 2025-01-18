# Netflix Movies and TV Shows Data Analysis using SQL
![Netflix_logo](https://github.com/Karishma-Yadav-11/Netflix_SQL_Project/blob/main/logo.png)

# Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

# Objectives
Analyze the distribution of content types (movies vs TV shows).
Identify the most common ratings for movies and TV shows.
List and analyze content based on release years, countries, and durations.
Explore and categorize content based on specific criteria and keywords.
# Dataset
The data for this project is sourced from the Kaggle dataset:

# Dataset Link: Movies Dataset(https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

# Schema

```sql
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
```

# Business Problems and Solutions
# 1. Count the Number of Movies vs TV Shows

```sql
SELECT type, COUNT(*) AS Total_content
FROM netflix
GROUP BY type;
```

# 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

# 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT title AS movies
FROM netflix
WHERE type = 'Movie' AND release_year= 2020;
```

# 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT UNNEST(STRING_TO_ARRAY(country,',')) AS Countries, count(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

# 5. Identify the Longest Movie

```sql
SELECT title AS Longest_Movies, duration
FROM netflix
WHERE type = 'Movie' AND duration = (SELECT MAX(duration) FROM netflix);
```

# 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'month DD, YYYY') >= current_date - INTERVAL '5 years';
```

# 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```

# 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM netflix
WHERE type = 'TV Show' AND SPLIT_PART(duration,' ',1)::numeric >5;
```

# 9. Count the Number of Content Items in Each Genre

```sql
SELECT UNNEST(STRING_TO_ARRAY(listed_in,',')) AS Genre, count(show_id) AS Total_Content
FROM netflix
GROUP BY 1
ORDER BY 1,2;
```

# 10.Find each year and the average numbers of content release in India on netflix.

```sql
SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'month DD, YYYY')) as year, COUNT(*),
	   ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country ILIKE '%India%')::numeric * 100, 2) AS avg_content_per_year
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 1;
```

# 11. List All Movies that are Documentaries

```sql
SELECT *
FROM Netflix
WHERE listed_in ILIKE '%Documentaries%';
```

# 12. Find All Content Without a Director

```sql
SELECT *
FROM Netflix
WHERE director IS NULL;
```

# 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT count(title) AS Total_Salman_Khan_Movies_Last_10yrs
FROM Netflix
WHERE casts ILIKE '%Salman Khan%' AND release_year >= EXTRACT (YEAR FROM CURRENT_DATE) - 10;
```

# 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors, COUNT(*) AS total_movies
FROM Netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

# 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

# Findings and Conclusion
* Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
