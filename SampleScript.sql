
WITH
cte_min as (SELECT r.year, q.position, MIN(q.position) OVER (PARTITION BY q.raceId,q.constructorId) minim,q.raceId,q.driverId,
q.constructorId FROM qualifying q JOIN races r ON r.raceId = q.raceId)

SELECT m.year, d.driverRef,c.constructorRef, COUNT(m.minim) FROM cte_min AS m
JOIN drivers d
ON d.driverId = m.driverId
JOIN constructors c
ON c.constructorId = m.constructorId
WHERE m.position = m.minim
GROUP BY m.year,m.constructorId,d.driverRef
ORDER BY m.year
