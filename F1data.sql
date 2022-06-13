
-- 1. Table creations
--      4 tables are created, qualifying, constructors, races and the drivers table
--      All 4 table data is imported from the CSV file which corresponds to the name of the table from the data source here: 
--      https://www.kaggle.com/code/anandaramg/f1-champ-eda-classification-100-accuracy/data

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

