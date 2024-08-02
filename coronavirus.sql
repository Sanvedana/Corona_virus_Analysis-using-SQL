select * from [corona_virus].[dbo].[Corona Virus Dataset];
SELECT
    SUM(CASE WHEN Province IS NULL THEN 1 ELSE 0 END) AS Province_nulls,
    SUM(CASE WHEN [Country Region] IS NULL THEN 1 ELSE 0 END) AS Country_nulls,
    SUM(CASE WHEN Latitude IS NULL THEN 1 ELSE 0 END) AS Latitude_nulls,
    SUM(CASE WHEN Longitude IS NULL THEN 1 ELSE 0 END) AS Longitude_nulls,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Date_nulls,
    SUM(CASE WHEN Confirmed IS NULL THEN 1 ELSE 0 END) AS Confirmed_nulls,
    SUM(CASE WHEN Deaths IS NULL THEN 1 ELSE 0 END) AS Deaths_nulls,
    SUM(CASE WHEN Recovered IS NULL THEN 1 ELSE 0 END) AS Recovered_nulls
FROM [corona_virus].[dbo].[Corona Virus Dataset];

UPDATE [corona_virus].[dbo].[Corona Virus Dataset]
SET
    Confirmed = ISNULL(Confirmed, 0),
    Deaths = ISNULL(Deaths, 0),
    Recovered = ISNULL(Recovered, 0);

SELECT COUNT(*) AS total_rows FROM [corona_virus].[dbo].[Corona Virus Dataset];

SELECT 
    MIN(Date) AS start_date,
    MAX(Date) AS end_date
FROM [corona_virus].[dbo].[Corona Virus Dataset];

SELECT 
    COUNT(DISTINCT CONVERT(VARCHAR(7), Date, 120)) AS number_of_months
FROM [corona_virus].[dbo].[Corona Virus Dataset];



SELECT 
    DATEPART(YEAR, TRY_CAST(Date AS DATE)) AS year,
    DATEPART(MONTH, TRY_CAST(Date AS DATE)) AS month,
    AVG(TRY_CAST(Confirmed AS INT)) AS avg_confirmed,
    AVG(TRY_CAST(Deaths AS INT)) AS avg_deaths,
    AVG(TRY_CAST(Recovered AS INT)) AS avg_recovered
FROM [corona_virus].[dbo].[Corona Virus Dataset]
WHERE ISDATE(Date) = 1 
GROUP BY DATEPART(YEAR, TRY_CAST(Date AS DATE)), DATEPART(MONTH, TRY_CAST(Date AS DATE))
ORDER BY year, month;


WITH MonthlyData AS (
    SELECT
        DATEPART(YEAR, TRY_CAST(Date AS DATE)) AS year,
        DATEPART(MONTH, TRY_CAST(Date AS DATE)) AS month,
        TRY_CAST(Confirmed AS INT) AS Confirmed,
        TRY_CAST(Deaths AS INT) AS Deaths,
        TRY_CAST(Recovered AS INT) AS Recovered
    FROM [corona_virus].[dbo].[Corona Virus Dataset]
),
ConfirmedFreq AS (
    SELECT year, month, Confirmed, COUNT(*) AS freq,
           ROW_NUMBER() OVER (PARTITION BY year, month ORDER BY COUNT(*) DESC) AS rn
    FROM MonthlyData
    GROUP BY year, month, Confirmed
),
DeathsFreq AS (
    SELECT year, month, Deaths, COUNT(*) AS freq,
           ROW_NUMBER() OVER (PARTITION BY year, month ORDER BY COUNT(*) DESC) AS rn
    FROM MonthlyData
    GROUP BY year, month, Deaths
),
RecoveredFreq AS (
    SELECT year, month, Recovered, COUNT(*) AS freq,
           ROW_NUMBER() OVER (PARTITION BY year, month ORDER BY COUNT(*) DESC) AS rn
    FROM MonthlyData
    GROUP BY year, month, Recovered
)
SELECT
    cf.year, cf.month,
    cf.Confirmed AS most_frequent_confirmed,
    df.Deaths AS most_frequent_deaths,
    rf.Recovered AS most_frequent_recovered
FROM ConfirmedFreq cf
JOIN DeathsFreq df ON cf.year = df.year AND cf.month = df.month AND cf.rn = 1
JOIN RecoveredFreq rf ON cf.year = rf.year AND cf.month = rf.month AND cf.rn = 1
WHERE cf.rn = 1
ORDER BY cf.year, cf.month;

SELECT 
    DATEPART(YEAR, TRY_CAST(Date AS DATE)) AS year,
    MIN(TRY_CAST(Confirmed AS INT)) AS min_confirmed,
    MIN(TRY_CAST(Deaths AS INT)) AS min_deaths,
    MIN(TRY_CAST(Recovered AS INT)) AS min_recovered
FROM [corona_virus].[dbo].[Corona Virus Dataset]
WHERE ISDATE(Date) = 1
GROUP BY DATEPART(YEAR, TRY_CAST(Date AS DATE))
ORDER BY year;


SELECT 
    DATEPART(YEAR, TRY_CAST(Date AS DATE)) AS year,
    MAX(TRY_CAST(Confirmed AS INT)) AS max_confirmed,
    MAX(TRY_CAST(Deaths AS INT)) AS max_deaths,
    MAX(TRY_CAST(Recovered AS INT)) AS max_recovered
FROM [corona_virus].[dbo].[Corona Virus Dataset]
WHERE ISDATE(Date) = 1
GROUP BY DATEPART(YEAR, TRY_CAST(Date AS DATE))
ORDER BY year;

SELECT 
    DATEPART(YEAR, TRY_CAST(Date AS DATE)) AS year,
    DATEPART(MONTH, TRY_CAST(Date AS DATE)) AS month,
    SUM(TRY_CAST(Confirmed AS INT)) AS total_confirmed,
    SUM(TRY_CAST(Deaths AS INT)) AS total_deaths,
    SUM(TRY_CAST(Recovered AS INT)) AS total_recovered
FROM [corona_virus].[dbo].[Corona Virus Dataset]
WHERE ISDATE(Date) = 1
GROUP BY DATEPART(YEAR, TRY_CAST(Date AS DATE)), DATEPART(MONTH, TRY_CAST(Date AS DATE))
ORDER BY year, month;


SELECT
    SUM(TRY_CAST(Confirmed AS INT)) AS total_confirmed,
    AVG(TRY_CAST(Confirmed AS INT)) AS avg_confirmed,
    VAR(TRY_CAST(Confirmed AS INT)) AS variance_confirmed,
    STDEV(TRY_CAST(Confirmed AS INT)) AS stdev_confirmed
FROM [corona_virus].[dbo].[Corona Virus Dataset]
WHERE ISDATE(Date) = 1;


SELECT
    DATEPART(YEAR, TRY_CAST(Date AS DATE)) AS year,
    DATEPART(MONTH, TRY_CAST(Date AS DATE)) AS month,
    SUM(TRY_CAST(Deaths AS INT)) AS total_deaths,
    AVG(TRY_CAST(Deaths AS INT)) AS avg_deaths,
    VAR(TRY_CAST(Deaths AS INT)) AS variance_deaths,
    STDEV(TRY_CAST(Deaths AS INT)) AS stdev_deaths
FROM [corona_virus].[dbo].[Corona Virus Dataset]
WHERE ISDATE(Date) = 1
GROUP BY DATEPART(YEAR, TRY_CAST(Date AS DATE)), DATEPART(MONTH, TRY_CAST(Date AS DATE))
ORDER BY year, month;


SELECT
    SUM(TRY_CAST(Recovered AS INT)) AS total_recovered,
    AVG(TRY_CAST(Recovered AS INT)) AS avg_recovered,
    VAR(TRY_CAST(Recovered AS INT)) AS variance_recovered,
    STDEV(TRY_CAST(Recovered AS INT)) AS stdev_recovered
FROM [corona_virus].[dbo].[Corona Virus Dataset]
WHERE ISDATE(Date) = 1;

SELECT 
    [Country Region],
    SUM(TRY_CAST(Confirmed AS INT)) AS total_confirmed
FROM [corona_virus].[dbo].[Corona Virus Dataset]
WHERE ISDATE(Date) = 1
GROUP BY [Country Region]
ORDER BY total_confirmed DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;


SELECT 
    [Country Region],
    SUM(TRY_CAST(Deaths AS INT)) AS total_deaths
FROM [corona_virus].[dbo].[Corona Virus Dataset]
WHERE ISDATE(Date) = 1
GROUP BY [Country Region]
ORDER BY total_deaths ASC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;


SELECT 
    [Country Region],
    SUM(TRY_CAST(Recovered AS INT)) AS total_recovered
FROM [corona_virus].[dbo].[Corona Virus Dataset]
WHERE ISDATE(Date) = 1
GROUP BY [Country Region]
ORDER BY total_recovered DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
