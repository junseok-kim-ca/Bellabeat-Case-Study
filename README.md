# Bellabeat Data Analysis Project
There are 3 projects: SQL project, Excel project, PowerPoint project in Bellabeat DA project. 

&nbsp;

## SQL Project - **Data Transformation** 
- Tool: SQL Server Management Studio 20 (SSMS) 

This project aims to load datasets using Data Definition Language (DDL) queries, such as CREATE, ALTER, UPDATE and DELETE, to effectively import the data into SSMS. It also focuses on data cleaning and merging. For example, the SleepDay dataset successfully deletes duplicate rows using Common Table Expressions (CTE) and the ROW_NUMBER window function. In terms of data merging, the WeekActivitySleep table is successfully created by merging two tables (WeekActivity and WeekSleep) using a FULL OUTER JOIN. Additionally, to correctly order the days of the week (from Monday to Sunday), the PERSISTED keyword was used in a computed column (a virtual column in a database table whose values are calculated from an expression using other columns in the same table.)

&nbsp;

## Excel Project - **Data Analysis, Data Visualization, Dashboard**
- Tool: Excel 365  

This project aims to analyze and visualize data from SSMS effectively. In the data analysis phase, StepCategory, SleepCategory, and BMICategory were created using nested IF statements to categorize and visualize each dataset. To track individual participants' sleep and BMI trends, the VLOOKUP function was applied appropriately. The Power Pivot feature was utilized to enable interactive graphs, especially for viewing trends by days of the week. The project developed a data model and KPIs to monitor user activity patterns, including daily steps and sleep hours, providing clearer insights into health trends through the structured analysis of weekly activity and sleep correlations.

&nbsp;

## PowerPoint Project - **Data Analysis Report**
- Tool: PowerPoint 365

This project explores trends in smart device usage related to user activity, sleep, and weight to inform marketing strategies. Using SQL and Excel, data from activity logs, sleep patterns, and BMI were analyzed through functions like Pivot Tables and VLOOKUP. The analysis shows most users engage in moderate activity, taking 4,000 to 11,999 steps daily, but many fall short of recommended step counts on weekdays. Sleep data reveals a common weekday sleep deficit, with users averaging less than the recommended 7.5 hours, although recovery occurs on weekends. Additionally, a significant portion of users falls into the overweight BMI category, indicating potential for targeted interventions.

Recommendations include promoting sleep tracking features to help users improve weekday sleep habits, encouraging hydration as a tool for weight management through the Spring water bottle, and marketing a holistic wellness approach combining activity and sleep optimization. These insights help Bellabeat better tailor its marketing campaigns to improve user health and engagement.



