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
-- Kyle- LUV LNC Gio- RSG DG
SELECT ticker, MIN(day), MAX(day)
FROM Prices
WHERE ticker = "LUV";

-- Q2
SELECT tDays.year, tDays.ticker, s.name, p2.Close-p1.Open as PriceChange, 
      tDays.TotalVolume, tDays.AvgClose, tDays.AvgVol
FROM (Securities s join AdjustedPrices p1 on s.ticker=p1.ticker) join 
      AdjustedPrices p2 on s.ticker=p2.ticker,
      (SELECT s.ticker, YEAR(p.day) as year, MIN(p.DAY) as FirstDay, MAX(p.Day)
                as LastDay, SUM(p.Volume) as TotalVolume, AVG(p.Close) as 
                  AvgClose, AVG(p.Volume) as AvgVol
       FROM Securities s join AdjustedPrices p on s.ticker=p.ticker
       WHERE s.ticker='LUV'
       GROUP BY year) tDays
WHERE s.ticker='LUV' and p1.day=tDays.FirstDay and p2.day=tDays.LastDay;

-- Q3
SELECT MONTH(day) AS Month ,AVG(close), MAX(close), MIN(close), AVG(volume)
FROM Prices,
	(SELECT DISTINCT MAX(YEAR(day)) AS YEAR FROM Prices) AS MAXYEAR
WHERE ticker = "LUV" AND YEAR(day) = MAXYEAR.YEAR
GROUP BY MONTH(day);

-- Q4
SELECT stats.year, stats.month, 100*AVG(close.Price/open.Price) as AvgRelChange
FROM (((SELECT ap.ticker, Year(ap.day) as year, Month(ap.day) as month, MIN(ap.day) as FirstDay,MAX(ap.day) as 
         LastDay
   FROM AdjustedPrices ap
   WHERE ap.ticker='LUV' and ap.day<'2017-06-13'
   GROUP BY year, month) stats 
   LEFT JOIN (SELECT ap.ticker, ap.day, ap.Open as Price
              FROM AdjustedPrices ap
              WHERE ap.ticker='LUV'  and ap.day<'2017-06-13'
              ) open
   ON open.day=stats.FirstDay)
   LEFT JOIN (SELECT ap.ticker, ap.day, ap.close as Price
              FROM AdjustedPrices ap 
              WHERE ap.ticker='LUV' and ap.day<'2017-06-13') close
   ON close.day=stats.LastDay)
GROUP BY stats.year, stats.month;

-- Q7
SELECT month, mainTicker, topFive, PriceDifference, VolumeDifference
FROM (
SELECT MONTHNAME(p1.day) as month, p1.ticker as mainTicker, p2.ticker as topFive, p1.close - p2.close as PriceDifference, v1.vTotal - v2.vtotal as VolumeDifference
FROM
   AdjustedPrices p1, AdjustedPrices p2,

   (SELECT max(day) as start
   FROM AdjustedPrices p
   WHERE YEAR(p.day) = 2016
   GROUP BY MONTH(p.day)) day,

   (SELECT MONTH(p.day) as mon, p.ticker, SUM(volume) as vTotal
   FROM AdjustedPrices p
   WHERE YEAR(p.day) = 2016
   GROUP BY MONTHNAME(p.day), p.ticker) v1,

   (SELECT MONTH(p.day) as mon, p.ticker, SUM(volume) as vTotal
   FROM AdjustedPrices p
   WHERE YEAR(p.day) = 2016
   GROUP BY MONTHNAME(p.day), p.ticker) v2,

   (SELECT rel1.ticker
   FROM (SELECT tDays.year, tDays.ticker, 100*(ap2.Close/ap1.Open) as Relative
   FROM (((SELECT YEAR(day) as year, ticker, min(day) as YearOpen, max(day)
            as YearClose FROM AdjustedPrices p
   GROUP BY year, ticker) tDays JOIN AdjustedPrices ap1
   on (tDays.YearOpen=ap1.day and tDays.ticker=ap1.ticker))
   JOIN AdjustedPrices ap2 ON (tDays.ticker=ap2.ticker and
   tDays.YearClose=ap2.day))
   GROUP BY year, ticker) rel1,
   (SELECT tDays.year, tDays.ticker, 100*(ap2.Close/ap1.Open) as Relative
   FROM (((SELECT YEAR(day) as year, ticker, min(day) as YearOpen, max(day)
   as YearClose
   FROM AdjustedPrices p
   GROUP BY year, ticker) tDays JOIN AdjustedPrices ap1
   on (tDays.YearOpen=ap1.day and tDays.ticker=ap1.ticker))
   JOIN AdjustedPrices ap2 ON (tDays.ticker=ap2.ticker and
   tDays.YearClose=ap2.day))
   GROUP BY year, ticker) rel2
   WHERE rel1.year=rel2.year and rel1.Relative<=rel2.Relative and rel1.year=2016
   GROUP BY rel1.year, rel1.ticker
   HAVING count(*) <= 5) top

WHERE p1.ticker = 'LUV' and YEAR(p1.day) = 2016 and p2.ticker = top.ticker and
   YEAR(p2.day) = 2016 and p1.day = p2.day and p1.day = day.start and MONTH(p1.day) = v1.mon and v1.mon = v2.mon and v1.ticker = p1.ticker and v2.ticker = p2.ticker
ORDER BY p1.day, p2.ticker) f;

-- Q8
SELECT p1.ticker as main, p2.ticker as other, p3.close / p1.open as mainRelativeGrowth, p4.close / p2.open as otherRelativeGrowth,
   v1.vTotal as mainVolumeTraded, v2.vTotal as otherVolumeTraded
FROM AdjustedPrices p1, AdjustedPrices p2, AdjustedPrices p3, AdjustedPrices p4,
   (SELECT p1.ticker as t1, p2.ticker as t2, IF (MAX(p1.day) < MAX(p2.day), MAX(p1.day), MAX(p2.day)) as max
   FROM AdjustedPrices p1, AdjustedPrices p2
   WHERE p1.ticker = 'LUV' and p2.ticker = 'LNC') endDate,

   (SELECT MIN(p1.day) as start
   FROM AdjustedPrices p1,
      (SELECT p1.ticker as t1, p2.ticker as t2, IF (MAX(p1.day) < MAX(p2.day), MAX(p1.day), MAX(p2.day)) as max
      FROM AdjustedPrices p1, AdjustedPrices p2
      WHERE p1.ticker = 'LUV' and p2.ticker = 'LNC') c
   WHERE p1.ticker = c.t1 and YEAR(p1.day) = YEAR(c.max)) startDate,

   (SELECT p.ticker, SUM(volume) vTotal
   FROM AdjustedPrices p
   WHERE YEAR(p.day) = 2016
   GROUP BY p.ticker) v1,

   (SELECT p.ticker, SUM(volume) vTotal
   FROM AdjustedPrices p
   WHERE YEAR(p.day) = 2016
   GROUP BY p.ticker) v2


WHERE p1.ticker = p3.ticker and p2.ticker = p4.ticker and p1.ticker = endDate.t1 and p2.ticker = endDate.t2 and p1.day = endDate.max and p2.day = endDate.max and p3.day = p4.day and p3.day = startDate.start and
   v1.ticker = p1.ticker and v2.ticker = p2.ticker;