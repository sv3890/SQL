DROP TABLE if EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(10),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year TEXT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(100),
    description  VARCHAR(550)
);

SELECT * FROM netflix;

SELECT COUNT(*) as total_content FROM netflix;

SELECT DISTINCT Type from netflix;


-- 1

SELECT 
	Type,
	COUNT (*) as total_content
FROM netflix 
GROUP BY Type


--2
SELECT 
	type,
	rating 
	
FROM 
(
	SELECT 
		type,
		rating,
		COUNT(*),
		RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	
	FROM netflix
	GROUP BY 1,2 
) as t1 
WHERE 
	ranking = 1
--ORDER BY 1,3 DESC


--3

SELECT * FROM netflix 
WHERE 
	type = 'Movie'
	AND
	release_year = 2020

--4
SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country
FROM netflix
GROUP BY 1




--5
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) from netflix)


--6
SELECT 
	* 	
FROM netflix 
WHERE 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
	
SELECT CURRENT_DATE - INTERVAL '5 years'

--7 using ilike
SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilka%'


--8 spilt function
SELECT 
	*
FROM netflix
WHERE
	type = 'Tv Show'
	AND
	SPLIT_PART(duration, ' ', 1)::numeric > 5 

-- 9 Using STRING_TOARRAY
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
	
FROM netflix
GROUP BY 1

--10 Using Extract, Finding Average per year
SELECT 
	EXTRACT (YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as date,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*)::numeric /(SELECT COUNT(*) FROM netflix WHERE country = 'India')* 100
	,2)as average_content_per_year
FROM netflix

WHERE country ='India'
GROUP BY 1

--11 using ILIKE

SELECT * FROM netflix
WHERE listed_in ILIKE '%documentaries'

--12 finding NULL in a coloumn

SELECT * FROM netflix
WHERE
 	director is NULL


--13 Finding particular value in last 10 years exsisted rows 

SELECT * FROM netflix
WHERE
	casts LIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

--14 top 10 actors in more number of movies produced in india, UNNEST(USING STING_TO_ARRAY)
SELECT
--show_id,
--casts,
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
	COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

--15
WITH new_table
AS 
(
SELECT 
*,
	CASE
	WHEN description ILIKE '%Kill%' OR 
		description ILIKE  '%violence%' THEN 'Bad_content'
		ELSE 'Good_content'
	END category
FROM netflix
)

SELECT 
	category,
	COUNT(*) as total_content
FROM new_table
GROUP BY 1
