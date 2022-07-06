-- The SQL used in Project 1.) 


-- 1. Table creations
--    5 tables are created, qualifying, constructors, races and the drivers table
--    4 tables had data imported from the CSV file which corresponds to the name of the table from the data source here: 
--    https://www.kaggle.com/code/anandaramg/f1-champ-eda-classification-100-accuracy/data
--    1 table had data imported from the CSV file generated in Python after web scraping.

CREATE table qualifying (
qualifyId INT,
raceId INT,
driverId INT,
constructorId INT,
number INT,
position INT,
q1 TIME(3),
q2 TIME(3),
q3 TIME(3)
)
;

CREATE table constructors (
constructorId INT,
constructorRef VARCHAR(20),
name VARCHAR(30),
nationality VARCHAR(20),
url VARCHAR(90)
)
;

CREATE table races (
raceId INT,
year INT,
round INT,
circuitId INT,
name VARCHAR(40),
date DATE,
time TIME(3)
)
;

CREATE table drivers (
driverId INT,
driverRef VARCHAR(20),
dob DATE,
nationality VARCHAR(20)
)
;

CREATE table qualifying_2022 (
qualifyId INT,
raceId INT,
constructorId INT,
position INT,
number INT,
driverId INT,
q1 TIME(3),
q2 TIME(3),
q3 TIME(3)
)

-- 2. Understanding the data available
--    This query returns the number of races per year detailed in the qualifying csv compared to the actual number of races per year
--    The result of this query shows that the qualifying data is available from years 1994 to 2021 and that years 1996 to 2002 having races missing 

SELECT COUNT(DISTINCT(q.raceId)) quali_data,t.total_races, r.year FROM qualifying q
JOIN races r
ON r.raceId = q.raceId
JOIN (SELECT COUNT(DISTINCT(raceId)) total_races,year FROM races
GROUP BY year) t
ON t.year = r.year
GROUP BY r.year
ORDER BY r.year

-- 3. Creating a function to simplify the conversion of time into seconds and microseconds

DELIMITER //
CREATE FUNCTION convert_time(time1 TIME(3))
RETURNS NUMERIC(9,3)
DETERMINISTIC
BEGIN
DECLARE seconds NUMERIC(9,3);
  set seconds = TIME_TO_SEC(time1)+MICROSECOND(time1)*POWER(10,-6);
RETURN seconds;
END
//

-- 4. Return tracks where a driver excels at in qualifying
--    Excelling at a track is subjectively defined as a track whereby a driver has more than 5 qualifying battles won versus his teammate at a win rate of minimum 80%

WITH cte_won AS (
WITH cte_min AS (SELECT r.year,r.name track, q.position, MIN(q.position) OVER (PARTITION BY q.raceId,q.constructorId) minim,
q.raceId,q.driverId,
q.constructorId, COUNT(r.name) OVER (PARTITION BY q.driverId, r.name) times_entered_race FROM qualifying q 
JOIN races r ON r.raceId = q.raceId)
SELECT  d.driverRef,m.track, m.driverId, COUNT(m.minim) OVER (PARTITION BY m.track,m.driverID) won, m.times_entered_race 
FROM cte_min m
JOIN drivers d ON d.driverId = m.driverId
WHERE m.position = m.minim)
SELECT w.driverRef, w.track, w.won, w.times_entered_race, ROUND(w.won/w.times_entered_race *100,2) percent_win
FROM cte_won W
WHERE w.won > 5 AND ROUND(w.won/w.times_entered_race *100,2) > 80
GROUP BY w.track, w.driverRef 
ORDER BY w.won DESC

-- 5. Return the driver that won the qualifying head to head for each constructor in each year
--    This query excludes years 1996 to 2002 due to incompleteness of data

WITH cte_max2 as(
WITH cte_max as(
WITH
cte_min as (SELECT r.year, q.position, MIN(q.position) OVER (PARTITION BY q.raceId,q.constructorId) minim,q.raceId,q.driverId,
q.constructorId FROM qualifying q JOIN races r ON r.raceId = q.raceId)

SELECT m.year,m.raceid,m.position, d.driverRef,c.constructorRef,COUNT(m.minim) OVER 
(PARTITION BY m.year,m.constructorId,d.driverRef) won 
FROM cte_min AS m
JOIN drivers d
ON d.driverId = m.driverId
JOIN constructors c
ON c.constructorId = m.constructorId
WHERE m.position = m.minim
ORDER BY m.year)
SELECT m.year, m.raceid,m.driverRef,m.constructorRef, MAX(m.won) OVER (PARTITION BY m.year, m.constructorRef) maxim,m.won
FROM cte_max m)
SELECT m.year,m.driverRef,m.constructorRef,m.won, r.total_races
FROM cte_max2 m 
JOIN (SELECT COUNT(raceId) total_races, year from races GROUP BY year) r
ON r.year = m.year
WHERE m.won = m.maxim
GROUP BY m.year, m.constructorRef
HAVING m.year NOT BETWEEN 1996 AND 2002;
