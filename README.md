# Bellabeat Data Analysis Project
There are 3 projects: SQL project, Excel project, PowerPoint project in Bellabeat DA project. 

&nbsp;

## SQL Project - **Data Transformation** 
- Tool: SQL Server Management Studio 20 (SSMS)

```sql
USE GoogleProject;
GO

CREATE TABLE DailyActivity (
    Id                       BIGINT,	
    ActivityDate             VARCHAR(50), -- Let's strictly follow the original datatype from the dataset
    TotalSteps               INT,
    TotalDistance            NUMERIC(10, 3),
    TrackerDistance          NUMERIC(10, 3),
    LoggedActivitiesDistance NUMERIC(10, 3),
    VeryActiveDistance       NUMERIC(10, 3),
    ModeratelyActiveDistance NUMERIC(10, 3),
    LightActiveDistance      NUMERIC(10, 3),
    SedentaryActiveDistance  NUMERIC(10, 3),
    VeryActiveMinutes        INT,
    FairlyActiveMinutes      INT,
    LightlyActiveMinutes     INT,
    SedentaryMinutes         INT,
    Calories                 INT
);

BULK INSERT DailyActivity
FROM 'C:\Users\ysysa\Downloads\Bellabeat\dailyActivity_merged.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

```

```sql
WITH SleepDataDuplicates AS (
    SELECT
        ROW_NUMBER() OVER( 
            PARTITION BY 
                Id, 
                Date, 
                TotalSleepRecords, 
                TotalMinutesAsleep,
                TotalTimeInBed
            ORDER BY 
                Id 
        ) AS UniqueRowNumber,
        Id,
        Date,
        TotalSleepRecords,
        TotalMinutesAsleep,
        TotalTimeInBed
    FROM 
        GoogleProject..SleepDay
)

DELETE FROM SleepDataDuplicates
WHERE 
    UniqueRowNumber > 1;

```

```sql
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
    COALESCE(wa.Days, ws.Days) AS Days,
    wa.AverageTotalSteps AS AverageTotalSteps,
    ws.AverageTotalHoursAsleep AS AverageTotalHoursAsleep
FROM
    GoogleProject..WeekActivity AS wa
FULL OUTER JOIN 
    GoogleProject..WeekSleep AS ws 
    ON wa.Days = ws.Days;

```

1. **Project Aim**: 
  - Perform data transformation, including loading datasets, data cleaning, and merging with using SQL Server Management Studio (SSMS)

2. **Data Loading**
	- Load datasets using **Data Definition Language (DDL)** queries like `CREATE`, `ALTER`, `UPDATE`, and `DELETE` to import data into SSMS.

3. **Data Cleaning**: 
  - The SleepDay dataset is Successfully removes duplicate rows using:
      - **Common Table Expressions (CTE)**.
        - Make SleepDataDuplicates CTE in order to delete duplication from CTE effectively
      - The **ROW_NUMBER** window function.
        - Use Row_number to figure out the duplicate values (e.g., if the Row_number is more than 1, that means the data is duplicated) 
      - The `COALESCE(wa.Days, ws.Days)` function:
    	- Returns the first non-`NULL` day value from either the **WeekActivity** or **WeekSleep** table during the full outer join.
    	- Ensures the resulting **Days** column in the **INSERT** statement contains a valid day, even if data is missing from one of the tables.

4. **Data Merging**: 
  - The WeekActivitySleep table:
    - Created by merging WeekActivity and WeekSleep tables using a **FULL OUTER JOIN**.
  
5. **Ordering Days of the Week**:
  - The **PERSISTED** keyword:
    - Used in a computed column to ensure correct ordering of days (Monday to Sunday).
    - A **computed column** is a virtual column whose values are calculated from expressions using other columns in the table.



&nbsp;

## Excel Project - **Data Analysis, Data Visualization, Dashboard**
- Tool: Excel 365

																																
																																
																																
																																
																																
																																
																																
												 																				
																																
																			 													
																																
																																
																																
																																
																																
																																
																																
																																
																																
																																
![image](https://github.com/user-attachments/assets/f9acac2c-eafe-4ef7-ac4e-a5466453cedc)



1. **Project Aim**: 
  - Leverage **Excel** to analyze, visualize, and model data retrieved from **SQL Server Management Studio (SSMS)**. This project will focus on:
    - Performing in-depth **data analysis** to identify trends and insights.
    - Creating **data visualizations** to effectively communicate findings.
    - Defining and tracking key performance indicators (**KPIs**) relevant to the business context.
    - Building comprehensive **data models** to support decision-making.
    - Developing interactive **dashboards** to present the results in an easily digestible format for stakeholders.

2. **Data Categorization**: 
  - **StepCategory**, **SleepCategory**, and **BMICategory**:
    - Created using **nested IF statements** to categorize and visualize each dataset.

3. **Tracking Individual Trends**:
  - **VLOOKUP function**:
    - Applied to track individual participants' sleep and **BMI** trends.

4. **Interactive Visualization**:
  - **Power Pivot feature**:
    - Utilized to create interactive graphs, allowing easy trend visualization by days of the week.

5. **Data Model and KPIs**: 
  - Developed a data model with **Key Performance Indicators (KPIs)** to monitor:
    - **User activity patterns**, including daily steps and sleep hours.
  - Provided clearer insights into health trends through structured analysis of:
    - **Weekly activity and sleep correlations**.

&nbsp;

## PowerPoint Project - **Data Analysis Report**
- Tool: PowerPoint 365

![image](https://github.com/user-attachments/assets/85809507-e622-4ef6-9c2f-c289286edc12)



- **Project Aim**: 
  - Create a Bellabeat data analysis report to explore trends in smart device usage, focusing on user activity, sleep, and weight.
  - The report utilizes insights from Excel graphs to inform marketing strategies and provides recommendations based on data trends. 	  - The project offers solutions to business questions by analyzing the data and generating actionable insights.

- **Data Analysis**:
  - Tools used:
    - **SQL** and **Excel**.
    - Functions like **Pivot Tables** and **VLOOKUP**.
  - **User Activity**:
    - Most users engage in **moderate activity**, taking 4,000 to 11,999 steps daily.
    - Many users fall short of the recommended step count on weekdays.
  - **Sleep Data**:
    - Shows a common **weekday sleep deficit**, with users averaging less than the recommended 7.5 hours.
    - Recovery sleep occurs on weekends.
  - **BMI Data**:
    - A significant portion of users falls into the **overweight BMI category**, indicating potential for targeted interventions.

- **Recommendations**:
  - Promote **sleep tracking features** to help users improve weekday sleep habits.
  - Encourage **hydration** as a tool for weight management using the **Spring water bottle**.
  - Market a **holistic wellness approach** combining activity and sleep optimization.





