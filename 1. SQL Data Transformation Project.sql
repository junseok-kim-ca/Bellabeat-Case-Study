/*
-----------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------Queries-------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
*/


/* Ask (Problem Statement):
1. What are some trends in smart device usage?
2. How could these trends apply to Bellabeat customers?
3. How could these trends help influence Bellabeat marketing strategy? 
*/


/* Prepare: 
- Let's create tables from csv files and insert the values respectively
*/


USE GoogleProject;
GO

CREATE TABLE DailyActivity (
    Id						 BIGINT,	
    ActivityDate			 VARCHAR(50), -- Let's Strictly follow the original datatype from the dataset
    TotalSteps				 INT,
    TotalDistance			 NUMERIC(10, 3),
    TrackerDistance			 NUMERIC(10, 3),
    LoggedActivitiesDistance NUMERIC(10, 3),
    VeryActiveDistance		 NUMERIC(10, 3),
    ModeratelyActiveDistance NUMERIC(10, 3),
    LightActiveDistance		 NUMERIC(10, 3),
    SedentaryActiveDistance  NUMERIC(10, 3),
    VeryActiveMinutes		 INT,
    FairlyActiveMinutes		 INT,
    LightlyActiveMinutes	 INT,
    SedentaryMinutes		 INT,
    Calories				 INT
);

USE GoogleProject;
GO

CREATE TABLE SleepDay (
    Id					BIGINT,	
    SleepDay			VARCHAR(50),
    TotalSleepRecords	INT,
    TotalMinutesAsleep	INT,
    TotalTimeInBed		INT
);


USE GoogleProject;
GO

CREATE TABLE WeightLogInfo (		
    Id			   BIGINT,
    Date		   VARCHAR(50),
    WeightKg	   NUMERIC(10, 3),
    WeightPounds   NUMERIC(10, 3),
    Fat			   NUMERIC(10, 3), 		
    BMI			   NUMERIC(10, 3),
    IsManualReport VARCHAR(25),
	LogId		   BIGINT
);


-- INSERT all values from csv files

BULK INSERT DailyActivity
FROM 'C:\Users\ysysa\Downloads\Bellabeat\dailyActivity_merged.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT SleepDay 
FROM 'C:\Users\ysysa\Downloads\Bellabeat\sleepDay_merged.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT WeightLogInfo
FROM 'C:\Users\ysysa\Downloads\Bellabeat\weightLogInfo_merged.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);


-- "Let's look at each table's columns and data types to verify that the tables were created successfully.
USE GoogleProject;
GO

SELECT 
	COLUMN_NAME, 
	DATA_TYPE
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE 
	TABLE_NAME = 'DailyActivity'

USE GoogleProject;
GO

SELECT 
	COLUMN_NAME, 
	DATA_TYPE
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE 
	TABLE_NAME = 'SleepDay'

USE GoogleProject;
GO

SELECT 
	COLUMN_NAME, 
	DATA_TYPE
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE 
	TABLE_NAME = 'WeightLogInfo'


-- Check the total rows & columns in each tables
SELECT
	COUNT(*) AS TotalRows 
FROM
	GoogleProject..DailyActivity;

SELECT
	COUNT(*) AS TotalRows
FROM
	GoogleProject..SleepDay;

SELECT
	COUNT(*) AS TotalRows
FROM
	GoogleProject..WeightLogInfo;

SELECT 
	COUNT(*) AS ColumnCount
FROM 
	sys.columns
WHERE 
	object_id = OBJECT_ID('GoogleProject..DailyActivity');

SELECT 
	COUNT(*) AS ColumnCount
FROM 
	sys.columns
WHERE 
	object_id = OBJECT_ID('GoogleProject..SleepDay');

SELECT 
	COUNT(*) AS ColumnCount
FROM 
	sys.columns
WHERE 
	object_id = OBJECT_ID('GoogleProject..WeightLogInfo');


-- Investigate the data in each tables

SELECT
	TOP 5 * 
FROM 
	GoogleProject..DailyActivity;

SELECT
	TOP 5 * 
FROM 
	GoogleProject..SleepDay;

SELECT
	TOP 5 * 
FROM 
	GoogleProject..WeightLogInfo;

/* 

1. In DailyActivity, there are 15 columns and 940 rows. This dataset offers a detailed record of physical activity 
and calorie expenditure for each participant on different days.

2. There are 5 columns and 413 rows in SleepDay. This dataset contains information about the sleep patterns of participants, 
including how long they slept and how much time they spent in bed.

3. WeightLogInfo table logs the weight, and BMI of participants over time.
This dataset contains 8 columns and 67 rows. Also, the table contains null value in "Fat" column. 

4. Each table's date column is currently set to the "VARCHAR" data type, so we need to convert or modify the table to use the appropriate data types, such as "DATE" or "DATETIME".

*/



-- Let's see how many people are in the datasets. In order to figure out the people, we have to find unique value of "Id" column in each tables
-- Count the number of unique values in Id column in all datasets

SELECT 
	COUNT(DISTINCT id) AS TotalUniqueId -- 33 unique id 
FROM 
	GoogleProject..DailyActivity;


SELECT
	COUNT(DISTINCT id) AS TotalUniqueId -- 24 unique id
FROM 
	GoogleProject..SleepDay;

SELECT
	COUNT(DISTINCT id) AS TotalUniqueId -- 8 unique id
FROM 
	GoogleProject..WeightLogInfo;

-- Let's investigate what period of data was collected
-- We are going to convert the datatype; VARCHAR to DATETIME to get correct results


SELECT
	MIN(CAST(ActivityDate AS DATETIME)) AS StartDate,
	MAX(CAST(ACtivityDate AS DATETIME)) AS EndDate
FROM 
	GoogleProject..DailyActivity;

SELECT
	MIN(CAST(SleepDay AS DATETIME)) AS StartDate,
	MAX(CAST(SleepDay AS DATETIME)) AS EndDate
FROM 
	GoogleProject..SleepDay;
	
SELECT
	MIN(CAST(Date AS DATETIME)) AS StartDate,
	MAX(CAST(Date AS DATETIME)) AS EndDate
FROM 
	GoogleProject..WeightLogInfo;

-- All three tables contain data from April 12, 2016 to May 12, 2016.
-- Let's use aggregate functions such as AVG, MIN, MAX to understand the data more


-- DailyActivity Table

SELECT
	ROUND(AVG(TotalSteps * 1.0), 0) AS AvgDailySteps, -- put 1.0 to avoid Integer Division
	ROUND(AVG(SedentaryMinutes) / 60.0, 1) AS AvgSedentaryHours, 
	ROUND(AVG(VeryActiveMinutes * 1.0), 1) AS AvgVeryActiveMinutes
FROM 
	GoogleProject..DailyActivity;


-- SleepDay table
SELECT
	ROUND(AVG(TotalMinutesAsleep) / 60.0, 1) AS AvgTotalHoursAsleep,
	ROUND(AVG(TotalTimeInBed) / 60.0, 1) As AvgTotalHoursInBed,
	ROUND(MAX(TotalTimeInBed) / 60.0, 1) AS MaxTotalHoursInBed
FROM 
	GoogleProject..SleepDay


-- WeightLogInfo table

SELECT
	ROUND(MIN(BMI), 1) AS LowestBMI,
	ROUND(AVG(BMI), 1) AS AvgBMI,
	ROUND(MAX(BMI), 1) AS HighestBMI
FROM 
	GoogleProject..WeightLogInfo

-- 

/* 
Observation:
- DailyActivity
average steps taken: 7638 (average participants' step is insufficient compared to 10,000 steps)
average sedentary time: 16.5 hours
very active time on average 21.1 min 

- SleepDay
average total time in bed: 7.6 hours
average total time asleep: 7 hours
maximum total time in bed: 16 hours (could be for an ill person)

- WeightLogInfo
average BMI: 25.19 (healthy BMI is considered from 18.5 to 24.9)
min and max BMI are 21 and 47 respectively

*/ 




/* Process (Data Transformation):

*/ 

-- The date columns are in string (VARCHAR) format. Let's convert the string data to date time format in all tables
SELECT
	*
FROM 
	GoogleProject..SleepDay


ALTER TABLE GoogleProject..DailyActivity
ALTER COLUMN ActivityDate DATE;

ALTER TABLE GoogleProject..SleepDay
ALTER COLUMN SleepDay DATE;

ALTER TABLE GoogleProject..WeightLogInfo
ALTER COLUMN Date DATE;

-- Let's rename the 3 column names as "Date" 
USE GoogleProject;
GO

EXEC sp_rename 'dbo.DailyActivity.ActivityDate', 'Date', 'COLUMN';

USE GoogleProject;
GO

EXEC sp_rename 'dbo.SleepDay.SleepDay', 'Date', 'COLUMN';


USE GoogleProject;
GO

EXEC sp_rename 'dbo.WeightLogInfo.Date', 'Date', 'COLUMN';

SELECT 
	COLUMN_NAME, 
	DATA_TYPE, 
	IS_NULLABLE
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE 
	TABLE_NAME = 'DailyActivity';

SELECT 
	COLUMN_NAME, 
	DATA_TYPE, 
	IS_NULLABLE
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE 
	TABLE_NAME = 'SleepDay';

SELECT 
	COLUMN_NAME, 
	DATA_TYPE, 
	IS_NULLABLE
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE 
	TABLE_NAME = 'WeightLogInfo';


-- Check if there are unexpected data transformation in each date columns 

SELECT
	TOP 5 *
FROM 
	GoogleProject..DailyActivity

SELECT
	TOP 5 *
FROM 
	GoogleProject..SleepDay 
	
SELECT
	TOP 5 *
FROM 
	GoogleProject..WeightLogInfo

-- It seems the data types are successfully changed without any issues!
-- Now, let's check if there are any duplicated rows. 
SELECT
	*,
	COUNT(*) AS TotalRow
FROM 
	GoogleProject..DailyActivity
GROUP BY 
	Id,
	Date,
	TotalSteps,
	TotalDistance,
	TrackerDistance,
	LoggedActivitiesDistance,
	VeryActiveDistance,
	ModeratelyActiveDistance,
	LightActiveDistance,
	SedentaryActiveDistance,
	VeryActiveMinutes,
	FairlyActiveMinutes,
	LightlyActiveMinutes,
	SedentaryMinutes,
	Calories
HAVING
	COUNT(*) > 1;

SELECT
	*,
	COUNT(*) AS TotalRow
FROM 
	GoogleProject..SleepDay
GROUP BY 
	Id,
	Date,
	TotalSleepRecords,
	TotalMinutesAsleep,
	TotalTimeInBed
HAVING
	COUNT(*) > 1; -- 3 duplicated rows in SleepDay 


SELECT
	*,
	COUNT(*) AS TotalRow
FROM 
	GoogleProject..WeightLogInfo
GROUP BY 
	Id,
	Date,
	WeightKg,
	WeightPounds,
	Fat,
	BMI,
	IsManualReport,
	LogId
HAVING
	COUNT(*) > 1;

-- There are 3 duplicated rows in SleepDay table. Let's remove them. 
WITH SleepDataDuplicates AS (
	SELECT
		*,
		ROW_NUMBER() OVER( -- Use Row_number to figure out the duplicate values
			PARTITION BY 
				Id, 
				Date, 
				TotalSleepRecords, 
				TotalMinutesAsleep,
				TotalTimeInBed
			ORDER BY 
				Id 
		) AS UniqueRowNumber
	FROM 
		GoogleProject..SleepDay
)

DELETE FROM SleepDataDuplicates
WHERE 
	UniqueRowNumber > 1;
	
-- Check the duplicated values are successfully deleted

SELECT
	*,
	COUNT(*) AS TotalRow
FROM 
	GoogleProject..SleepDay
GROUP BY 
	Id,
	Date,
	TotalSleepRecords,
	TotalMinutesAsleep,
	TotalTimeInBed
HAVING
	COUNT(*) > 1;

-- Let's check if there are NULL values in each columns 

SELECT
	*
FROM 
	GoogleProject..DailyActivity
WHERE
	Id IS NULL
	OR Date IS NULL
	OR TotalSteps IS NULL 
	OR TotalDistance IS NULL 
	OR TrackerDistance IS NULL
	OR LoggedActivitiesDistance IS NULL
	OR VeryActiveDistance IS NULL
	OR ModeratelyActiveDistance IS NULL
	OR LightActiveDistance IS NULL
	OR SedentaryActiveDistance IS NULL
	OR VeryActiveMinutes IS NULL
	OR FairlyActiveMinutes IS NULL
	OR LightlyActiveMinutes IS NULL
	OR SedentaryActiveDistance IS NULL
	OR Calories IS NULL;
	
SELECT
	*
FROM 
	GoogleProject..SleepDay
WHERE
	Id IS NULL
	OR Date IS NULL
	OR TotalSleepRecords IS NULL
	OR TotalMinutesAsleep IS NULL
	OR TotalTimeInBed IS NULL;


SELECT
	*
FROM 
	GoogleProject..WeightLogInfo
WHERE
	Id IS NULL
	OR Date IS NULL
	OR WeightKg IS NULL
	OR WeightPounds IS NULL
	OR Fat IS NULL -- Fat has 65 NULL values
	OR BMI IS NULL
	OR IsManualReport IS NULL
	OR LogID IS NULL;

-- Since WeightLogInfo table total rows are 67 rows, let's just delete the Fat column 
	
ALTER TABLE GoogleProject..WeightLogInfo
DROP COLUMN Fat;

SELECT
	TOP 5 * 
FROM 
	GoogleProject..WeightLogInfo

-- Let's modify the data Minute to Hour in TotalMinutesAsleep and TotalTimeInBed columns in SleepDay table to analyze easily
ALTER TABLE GoogleProject..SleepDay
ADD TotalHoursAsleep NUMERIC(10, 1),
	TotalHoursInBed  NUMERIC(10, 1); 

UPDATE GoogleProject..SleepDay
SET
    TotalHoursAsleep = ROUND(CAST(TotalMinutesAsleep / 60.0 AS NUMERIC(10, 1)), 1),
    TotalHoursInBed  = ROUND(CAST(TotalTimeInBed / 60.0 AS NUMERIC(10, 1)), 1);


SELECT
	*
FROM 
	GoogleProject..SleepDay;



/* 
Let's use "View" instead of creating a new table due to followings: 
1. View provides real-time access to the underlying data. 
This means retrieved through a view always reflects the current state of the source tables

2. View can help avoid data duplication issues. 
This means it eliminates the need to update multiple copies of the same data, 
so that view can reduce storage requirements. 

3. If Bellabeat needs change a report (e.g. start reporting monthly instead of quarterly) 
View can easily modified without doing resturcutre physical tables. 
*/ 


-- Let's merge DailyActivity and SleepDay in a one table

CREATE VIEW VwActivitySleep AS 
SELECT
	COALESCE(da.Id, sd.Id) AS Id, -- merge the Id column from both table DailyActivity and SleepDay into a single Id column 
    COALESCE(da.Date, sd.Date) AS Date,
	da.TotalSteps,
	da.TotalDistance,
	da.TrackerDistance,
	da.LoggedActivitiesDistance,
	da.VeryActiveDistance,
	da.ModeratelyActiveDistance,
	da.LightActiveDistance,
	da.SedentaryActiveDistance,
	da.VeryActiveMinutes,
	da.FairlyActiveMinutes,
	da.LightlyActiveMinutes,
	da.SedentaryMinutes,
	da.Calories,
	sd.TotalSleepRecords,
	sd.TotalMinutesAsleep,
	sd.TotalTimeInBed,
	sd.TotalHoursAsleep,
	sd.TotalHoursInBed
FROM 
	GoogleProject..DailyActivity AS da
INNER JOIN 
	GoogleProject..SleepDay AS sd 
	ON da.Id = sd.Id
	AND da.Date = sd.Date;

SELECT
	*
FROM 
	GoogleProject..VwActivitySleep

SELECT
	COUNT(DISTINCT ID) AS UniqueId, -- 24 Unique Id 
	COUNT(DISTINCT Date) AS UniqueDate -- 31 Unique Date 
FROM 
	GoogleProject..VwActivitySleep

-- DROP VIEW VwActivitySleep


-- Creating a new Table with Average Steps per days of the week
/* 
First, let's convert the dates into the corresponding days of the week. 
Then, we can calculate the average number of steps for each day of the week 
to gain insights into the average steps taken by participants on each days of the week.
*/ 

-- Let's try to use View this time

CREATE VIEW VwWeekDaySleep AS 
WITH WeekCTE AS (
	SELECT
		DATENAME(WEEKDAY, Date) AS Days,
		ROUND(AVG(TotalHoursAsleep), 2) AS AverageTotalHoursAsleep
	FROM
		GoogleProject..SleepDay
	GROUP BY
		DATENAME(WEEKDAY, Date)
)
SELECT
	Days,
	AverageTotalHoursAsleep
FROM 
	WeekCTE
ORDER BY 
	CASE 
		WHEN Days = 'Monday'     THEN 1 
		WHEN Days = 'Tuesday'    THEN 2
		WHEN Days = 'Wednesday'  THEN 3
		WHEN Days = 'Thursday'   THEN 4
		WHEN Days = 'Friday'	 THEN 5
		WHEN Days = 'Saturday'   THEN 6
		WHEN Days = 'Sunday'     THEN 7
	END;
		
/*
- Error message occured: 
Msg 1033, Level 15, State 1, Procedure WeekDaySleep, Line 25 [Batch Start Line 788]
The ORDER BY clause is invalid in views, inline functions, derived tables, subqueries, and common table expressions, unless TOP, OFFSET or FOR XML is also specified.
*/

-- To avoid this error, we can use TOP Clause, OFFSET-FETCH Clause, and FOR XML Clause, but it is not recommend to use them
-- because they have certain limitations and potential drawbacks which leads to wrong result


-- Let's CREATE a new TABLE (WeekdayActivity) instead of using VIEW

USE GoogleProject;
GO

CREATE TABLE WeekActivity (
    Days VARCHAR(50),  -- contain weekday names like 'Monday', 'Tuesday', etc., 
    AverageTotalSteps NUMERIC(10, 2)  
);

INSERT INTO WeekActivity (Days, AverageTotalSteps)
SELECT
    DATENAME(WEEKDAY, Date) AS Days,
    AVG(TotalSteps) AS AverageTotalSteps
FROM 
    GoogleProject..DailyActivity
GROUP BY
    DATENAME(WEEKDAY, Date)
ORDER BY
    CASE 
        WHEN DATENAME(WEEKDAY, Date) = 'Monday'     THEN 1
        WHEN DATENAME(WEEKDAY, Date) = 'Tuesday'    THEN 2
        WHEN DATENAME(WEEKDAY, Date) = 'Wednesday'  THEN 3
        WHEN DATENAME(WEEKDAY, Date) = 'Thursday'   THEN 4
        WHEN DATENAME(WEEKDAY, Date) = 'Friday'     THEN 5
        WHEN DATENAME(WEEKDAY, Date) = 'Saturday'   THEN 6
        WHEN DATENAME(WEEKDAY, Date) = 'Sunday'     THEN 7
    END;

SELECT
	*
FROM 
	WeekActivity

-- The ordering weekday is not working, to solve this problem we are going to add a computed column in WeekdayActivity
-- Computed column: is a virtual column in database calculated from an expression using other columns in the same table.


ALTER TABLE WeekActivity
ADD WeekOrder AS 
    CASE 
        WHEN Days = 'Monday'     THEN 1
        WHEN Days = 'Tuesday'    THEN 2
        WHEN Days = 'Wednesday'  THEN 3
        WHEN Days = 'Thursday'   THEN 4
        WHEN Days = 'Friday'     THEN 5
        WHEN Days = 'Saturday'   THEN 6
        WHEN Days = 'Sunday'     THEN 7
    END;

CREATE CLUSTERED INDEX IX_WeekActivity_WeekOrder 
ON WeekActivity (WeekOrder); -- helps to define the physical storage order of the data(WeekDay) in a table


SELECT
	*
FROM 
	GoogleProject..WeekActivity


 -- Let's create WeekdaySleep table in a same way
USE GoogleProject;
GO 

CREATE TABLE WeekSleep (
	Days VARCHAR(50),
	AverageTotalHoursAsleep NUMERIC(10, 2),
	WeekOrder AS (
		CASE 
			WHEN Days = 'Monday'     THEN 1
			WHEN Days = 'Tuesday'    THEN 2
			WHEN Days = 'Wednesday'  THEN 3
			WHEN Days = 'Thursday'   THEN 4
			WHEN Days = 'Friday'     THEN 5
			WHEN Days = 'Saturday'   THEN 6
			WHEN Days = 'Sunday'     THEN 7
		END
	) PERSISTED
);


INSERT INTO WeekSleep (
	Days,
	AverageTotalHoursAsleep
)
SELECT 
	DATENAME(WEEKDAY, Date) AS Days,
	AVG(TotalHoursAsleep) AS AverageTotalHoursAsleep
FROM 
	GoogleProject..SleepDay
GROUP BY 
    DATENAME(WEEKDAY, Date);


CREATE CLUSTERED INDEX IX_WeekSleep_WeekOrder
ON WeekSleep (WeekOrder);


SELECT
	*
FROM 
	GoogleProject..WeekSleep

-- Let's merge 2 tables in a one (WeekActivitySleep)


USE GoogleProject;
GO 

CREATE TABLE WeekActivitySleep (
	Days VARCHAR(50),
	AverageTotalSteps NUMERIC(10, 2),
	AverageTotalHoursAsleep NUMERIC(10, 2),
	WeekOrder AS (
		CASE 
			WHEN Days = 'Monday'     THEN 1
			WHEN Days = 'Tuesday'    THEN 2
			WHEN Days = 'Wednesday'  THEN 3
			WHEN Days = 'Thursday'   THEN 4
			WHEN Days = 'Friday'     THEN 5
			WHEN Days = 'Saturday'   THEN 6
			WHEN Days = 'Sunday'     THEN 7
		END
	) PERSISTED
);

INSERT INTO WeekActivitySleep (
	Days,
	AverageTotalSteps,
	AverageTotalHoursAsleep
)
SELECT
	COALESCE(wa.Days, ws.Days) As Days,
	wa.AverageTotalSteps AS AverageTotalSteps,
	ws.AverageTotalHoursAsleep AS AverageTotalHoursAsleep
FROM
	GoogleProject..WeekActivity AS wa
FULL OUTER JOIN 
	GoogleProject..WeekSleep AS ws 
	ON wa.Days = ws.Days 


SELECT
	*
FROM 
	GoogleProject..WeekActivitySleep



-- Now let's export the files: DailyActivity, SleepDay, WeightLogInfo, VwActivitySleep, and WeekActivitySleep
-- In order to do data visualization in Excel Environment. 

/* 
Export csv file from SSMS
1. Create a new csv file in Excel, or Notepad, etc
2. Click the current database, GoogleProject -> Tasks -> Export Data
3. Click Next -> Data source: Microsoft OLE DB Provider For SQL Server, Click next 
4. Destination: Flat File Destination, Browse the file, check Unicode, Click next 
5. Choose Copy data from one or more tables or views, Click next 
6. Choose the right source table or view, Click next 
7. Click next 
8. Click Finish
*/ 

/*
While exporting the tables: WeekdayActivitySleep there are export errors
- Error msg: Error 0xc00470d4: Data Flow Task 1: The code page on Destination - WeekdayActivitySleep_csv.Inputs[Flat File Destination Input].Columns[WeekDay] is 949 and is required to be 1252.
 (SQL Server Import and Export Wizard)

- This error message is related to a character encoding mismatch during a data import process in SQL Server.
- To fix this issue, we are going to check the datatypes in two tables
*/

USE GoogleProject;
GO

SELECT 
	COLUMN_NAME, 
	DATA_TYPE, 
	IS_NULLABLE
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE 
	TABLE_NAME = 'WeekActivitySleep'


-- Data type in Week is VARCHAR. Let's change VARCHAR to NVARCHAR
/* 
-- Why change to NVARCHAR?
1. NVARCHAR stores characters using Unicode encoding, which supports a wider range of characters from different languages. 
In contrast, VARCHAR stores characters using non-Unicode encoding, which can lead to code page errors when dealing with characters outside the specific code page's range.

2. By changing to NVARCHAR we will prevent the potential issues because: 
i) It uses, and stores Unicode encoding data
ii) Unicode can represent both Western European (code page 1252) and Korean (code page 949) characters without conflict.
iii) This prevents the code page mismatch issue because NVARCHAR does not rely on code pages. 

*/

-- Let's convert the data type VARCHAR to NVARCHAR
ALTER TABLE GoogleProject..WeekActivitySleep
ALTER COLUMN Days NVARCHAR(50); -- Error: ALTER TABLE ALTER COLUMN Days failed because one or more objects access this column.


-- This error occured because we used the INDEX column. Let's DROP the column used the INDEX column

ALTER TABLE GoogleProject..WeekActivitySleep 
DROP COLUMN WeekOrder;

-- Change the data type: NVARCHAR
ALTER TABLE GoogleProject..WeekActivitySleep
ALTER COLUMN Days NVARCHAR(20);

-- Remake the WeekDayOrder column
ALTER TABLE WeekActivitySleep
ADD WeekOrder AS (
	CASE 
		WHEN [Days]='Monday'	  THEN 1 
		WHEN [Days]='Tuesday'	  THEN 2 
		WHEN [Days]='Wednesday'   THEN 3 
		WHEN [Days]='Thursday'    THEN 4 
		WHEN [Days]='Friday' 	  THEN 5 
		WHEN [Days]='Saturday'    THEN 6 
		WHEN [Days]='Sunday'	  THEN 7  
	END
);


-- Check the datatype is successfully changed 
USE GoogleProject;
GO

SELECT 
	COLUMN_NAME, 
	DATA_TYPE, 
	IS_NULLABLE
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE 
	TABLE_NAME = 'WeekActivitySleep';

SELECT
	*
FROM 
	GoogleProject..WeekActivitySleep;

-- Analysis, Share, Act phase will perform in Excel environment 
