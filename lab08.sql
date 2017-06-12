-- q2
SELECT Name
FROM Securities s, Prices p 
WHERE s.ticker = p.ticker AND
	YEAR(p.day) = 2016
GROUP BY p.ticker 
ORDER BY Sum(p.volume) DESC 
LIMIT 10;

-- q1 part 3
SELECT SUM(s.ticker)
FROM Securities s, 
	(SELECT ticker, open 
	FROM Prices 
	WHERE day = "2015-12-31"
	GROUP BY ticker) p1, 
	(SELECT ticker, close
	FROM Prices 
	WHERE day = "2016-12-30"
	GROUP BY ticker) p2
WHERE s.ticker = p1.ticker and s.ticker = p2.ticker and p1.open < p2.close;


-- subquery of 3
SELECT DISTINCT YEAR(day) FROM Prices;


-- q4
SELECT Name, s.ticker, p2.price, p1.price, (p2.price - p1.price) / p1.price
FROM 
	(SELECT ticker, AVG(close) AS "price"
	FROM Prices
	WHERE YEAR(day) = 2016 AND MONTH(day) = 1
	GROUP BY ticker) p1,
	 (SELECT ticker, AVG(close) AS "price"
	 FROM Prices
	 WHERE YEAR(day) = 2016 AND MONTH(day) = 12
	 GROUP BY ticker) p2,
	 Securities s
WHERE s.ticker = p1.ticker and s.ticker = p2.ticker
ORDER BY (p2.price - p1.price) / p1.price DESC
LIMIT 10
;

-- Individual Queries
-- Q1

SELECT ticker, MIN(day), MAX(day)
FROM Prices
WHERE ticker = <Ticker>;

-- Q3
SELECT AVG(close), MAX(close), MIN(close), AVG(volume)
FROM Prices,
	(SELECT DISTINCT MAX(YEAR(day)) AS YEAR FROM Prices) AS MAXYEAR
WHERE ticker = "LUV" AND YEAR(day) = MAXYEAR.YEAR
GROUP BY MONTH(day);

-- Q4
SELECT *
FROM (SELECT MIN(day) AS Day
	 FROM Prices
	 WHERE ticker = "LUV"
	 GROUP BY YEAR(DAY), MONTH(DAY)

	 UNION

	 SELECT MAX(day)
	 FROM Prices
	 WHERE ticker = "LUV"
	 GROUP BY YEAR(day), MONTH(day)) D,
	 Prices
WHERE Prices.day = D.day AND ticker = "LUV"
ORDER BY Prices.Day
;
