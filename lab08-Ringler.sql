// Get total amount traded at beginning of year #1
SELECT SUM(Volume) FROM Prices WHERE Day = (SELECT MIN(Day) FROM Prices WHERE Year(Day) =  2016 AND Month(Day) = 1) 
;


// Get total amount traded at end of year #1
SELECT SUM(Volume) FROM Prices WHERE Day = (SELECT MAX(Day) FROM Prices WHERE Year(Day) =  2016 AND Month(Day) = 12) 
;


// prices saw increase between end of 2015 and end of 2016 #1
SELECT COUNT(*)
FROM
(SELECT * FROM Prices WHERE Day = (SELECT MAX(Day) FROM Prices WHERE Year(Day) =  2016 AND Month(Day) = 12) GROUP BY Ticker) x,
(SELECT * FROM Prices WHERE Day = (SELECT MAX(Day) FROM Prices WHERE Year(Day) =  2015 AND Month(Day) = 12) GROUP BY Ticker) x1
WHERE x.Ticker = x1.Ticker AND x.Close > x1.Close;

// prices saw decrease between end of 2015 and end of 2016 #1
SELECT COUNT(*)
FROM
(SELECT * FROM Prices WHERE Day = (SELECT MAX(Day) FROM Prices WHERE Year(Day) =  2016 AND Month(Day) = 12) GROUP BY Ticker) x,
(SELECT * FROM Prices WHERE Day = (SELECT MAX(Day) FROM Prices WHERE Year(Day) =  2015 AND Month(Day) = 12) GROUP BY Ticker) x1
WHERE x.Ticker = x1.Ticker AND x.Close < x1.Close;


// Top 5 increase in relative price #3
SELECT x.Ticker
FROM
(SELECT *, Close FROM Prices WHERE Day = (SELECT MAX(Day) FROM Prices WHERE Year(Day) =  2016 AND Month(Day) = 12) GROUP BY Ticker) x,
(SELECT *, Close FROM Prices WHERE Day = (SELECT MIN(Day) FROM Prices WHERE Year(Day) =  2016 AND Month(Day) = 1) GROUP BY Ticker) x1
WHERE x.Ticker = x1.Ticker
ORDER BY ((x.Close - x1.Close)/ x1.Close) DESC
LIMIT 5;

// Top 5 Absolute Price Increase #3
SELECT x.Ticker
FROM
(SELECT *, Close FROM Prices WHERE Day = (SELECT MAX(Day) FROM Prices WHERE Year(Day) =  2016 AND Month(Day) = 12) GROUP BY Ticker) x,
(SELECT *, Close FROM Prices WHERE Day = (SELECT MIN(Day) FROM Prices WHERE Year(Day) =  2016 AND Month(Day) = 12) GROUP BY Ticker) x1
WHERE x.Ticker = x1.Ticker
ORDER BY (x.Close - x1.Close) DESC
LIMIT 5;


// Number 4 #4
SELECT x.Ticker FROM
(SELECT Ticker, AVG(Close) AS Avg FROM Prices WHERE Year(Day) = 2016 AND MONTH(Day) = 1 GROUP BY Ticker) x,
(SELECT Ticker, AVG(Close) AS Avg FROM Prices WHERE Year(Day) = 2016 AND MONTH(Day) = 12 GROUP BY Ticker) x1
WHERE x.Ticker = x1.Ticker
ORDER BY ((x1.Avg - x.Avg) / x.Avg) DESC
LIMIT 10;


// Number 5 #5
SELECT DISTINCT Sector FROM Securities;
^^^ Loop Through list ^^^

SELECT AVG(y.Avg) FROM
(SELECT x1.Ticker, ((x2.Avg - x1.Avg) / x1.Avg) AS Avg FROM
(SELECT Ticker FROM Securities WHERE Sector = "Energy") x,
(SELECT Ticker, AVG(Close) AS Avg
FROM  Prices WHERE MONTH(Day) = 1 AND Year(Day) = 2016 GROUP BY Ticker) x1,
(SELECT Ticker, AVG(Close) AS Avg 
FROM Prices WHERE MONTH(Day) = 12 AND Year(Day) = 2016 GROUP BY Ticker) x2
WHERE x1.Ticker = x2.Ticker AND
x.Ticker = x1.Ticker) y;



// THIS IS INDIV QUERY 4
// Needs to loop through the top SELECT Statement and set year(Day) = that year being looped through and also ticker = (ticker assigned)

// Calculated the relative price increase for each month from the open value of first day of month to close value of last day of month and took the month with the highest.

// query to loop through
SELECT DISTINCT Year(Day) FROM Prices WHERE Ticker = "luv";

SELECT MONTHNAME(p.Day) AS Month
FROM
(SELECT Day, Open FROM Prices WHERE Year(Day) = 2015 AND Ticker = "luv") p, (SELECT Day, Close FROM Prices WHERE Year(Day) = 2015 AND Ticker = "luv") p1
WHERE p.Day IN (SELECT MIN(Day)
FROM Prices
WHERE Ticker = "luv" AND
Year(Day) = 2015
GROUP BY Month(Day)) AND
p1.Day IN (SELECT MAX(Day)
FROM Prices
WHERE Ticker = "luv" AND
Year(Day) = 2015
GROUP BY Month(Day)) AND
Month(p.Day) = Month(p1.Day)
GROUP BY Month(p.Day)
ORDER BY ((p1.Close - p.Open) / (p.Open)) DESC
LIMIT 1;
