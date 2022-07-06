-- The SQL used in Project 1.) Exploratory Analysis, Web Scraping and Visualization of Formula 1 Qualifying Data
-- is shown here


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

-- 4. Return current drivers that dominate a track in qualifying
--    Track domination in qualifying is subjectively defined as a track whereby a driver has more than 5 qualifying battles won versus his teammate 
--    with a win rate of minimum 75%

WITH cte_won AS (
WITH cte_min AS (SELECT r.year,r.name track, q.position, MIN(q.position) OVER (PARTITION BY q.raceId,q.constructorId) minim,
q.raceId,q.driverId,
q.constructorId, COUNT(r.name) OVER (PARTITION BY q.driverId, r.name) times_entered_race FROM qualifying q 
JOIN races r ON r.raceId = q.raceId)
SELECT  d.driverRef,m.track, m.driverId, COUNT(m.minim) OVER (PARTITION BY m.track,m.driverID) won, m.times_entered_race 
FROM cte_min m
JOIN drivers d ON d.driverId = m.driverId
WHERE m.position = m.minim)
SELECT w.driverRef, q22.number,w.track, w.won, w.times_entered_race, ROUND(w.won/w.times_entered_race *100,2) percent_win
FROM cte_won W
JOIN (SELECT name FROM races WHERE year = 2022) r ON r.name = w.track 
JOIN (SELECT q2022.driverRef, r.year FROM qualifying_2022 q2022
JOIN races r ON r.raceId = q2022.raceId
GROUP BY r.year,q2022.driverRef) current_year
ON current_year.driverRef = w.driverRef
JOIN qualifying_2022 q22 ON q22.driverRef = w.driverRef
WHERE w.won > 5 AND ROUND(w.won/w.times_entered_race *100,2) > 75 AND w.driverRef != "hulkenberg" 
GROUP BY w.track, w.driverRef 
ORDER BY w.won DESC
;

-- 5. Return current drivers who have more than 100 qualifying entrances in their career up until 2021 and their win rate

WITH cte_win_rate AS (
WITH min_cte AS (SELECT driverID, position,raceId, constructorId, MIN(position) OVER (PARTITION BY raceId,constructorId)
 min FROM qualifying),
qualis_entered_cte AS ( SELECT driverId, count(raceID) qualis_entered
 FROM qualifying
 GROUP BY driverId)
SELECT d.driverRef, r.qualis_entered, count(m.min) won, CONCAT(ROUND(count(m.min)/r.qualis_entered*100,2),"%") 
win_rate FROM min_cte as m
JOIN qualis_entered_cte AS r
ON m.driverId = r.driverId
JOIN drivers AS d
ON r.driverId = d.driverId
WHERE m.position = m.min AND qualis_entered > 100 
GROUP BY r.driverId
ORDER BY win_rate DESC
)
SELECT cw.*,q2022.number FROM cte_win_rate cw
JOIN qualifying_2022 q2022 ON q2022.driverRef = cw.driverRef
WHERE cw.driverRef != 'hulkenberg'
GROUP BY driverRef
ORDER BY win_rate DESC

--6. Return remaining grand prix where there is track domination by a driver

WITH cte_won AS (
WITH cte_min AS (SELECT r.year,r.name track, q.position, MIN(q.position) OVER (PARTITION BY q.raceId,q.constructorId) minim,
q.raceId,q.driverId,
q.constructorId, COUNT(r.name) OVER (PARTITION BY q.driverId, r.name) times_entered_race FROM qualifying q 
JOIN races r ON r.raceId = q.raceId)
SELECT  d.driverRef,m.track, m.driverId, COUNT(m.minim) OVER (PARTITION BY m.track,m.driverID) won, m.times_entered_race 
FROM cte_min m
JOIN drivers d ON d.driverId = m.driverId
WHERE m.position = m.minim)
SELECT w.track, r.date 
FROM cte_won W
JOIN (SELECT name,date FROM races WHERE year = 2022) r ON r.name = w.track 
JOIN (SELECT q2022.driverRef, r.year FROM qualifying_2022 q2022
JOIN races r ON r.raceId = q2022.raceId
GROUP BY r.year,q2022.driverRef) current_year
ON current_year.driverRef = w.driverRef
JOIN qualifying_2022 q22 ON q22.driverRef = w.driverRef
JOIN(SELECT r.name, r.date FROM races r 
WHERE r.date > CURDATE()) future_race
WHERE w.won > 5 AND ROUND(w.won/w.times_entered_race *100,2) > 75 AND w.driverRef != "hulkenberg" 
AND future_race.name = w.track 
GROUP BY w.track 
ORDER BY r.date 
;

--7. 
