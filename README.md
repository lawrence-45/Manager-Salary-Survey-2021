# Manager-Salary-Survey-2021-Analysis
## Overview
Data cleaning and analysis of real-life dataset using SQL.  
This project showcases my SQL skills.

## Dataset Overview
The dataset includes columns like timestamp, age range, work industry, job title, job_title_additional_context, annual_salary, additional_monetary_compensation, currency, Other_currency, income_additional_context, work_country, works_in_us_state, work_city, professional_work_experience, professional_work_experience_field, level_of_education, gender, race.  
Individuals from different countries and regions filled these columns, making the dataset messy and less useable.  
To download the dataset, Click [Here](https://eyowhite.com/wp-content/uploads/2024/06/Data-cleaning-Salary-survey.zip)

## Key Questions To Be Answered
* Which industry pays the most?
* How does salary increase with experience?
* Salary variations for the same role with different experience levels?
* Salary differences by gender & experience?
* Correlation of race and education level with salary?

## SQL Functions Used
* Common Table Expressions(CTE)
* Group By
* Order By
* Having
* Subqueries
* Alias
* Temp Table
* Aggregate Function
* Case Statement
* Windows Function etc.

## Data Cleaning 
This was done fully using SQL, duplicating the initial dataset, and working my way through the dataset.  
To see the full SQL codes used in the cleaning process Click [Here]([manager_salary_survey_2021_cleaning_and_analysis_file](https://github.com/lawrence-45/Manager-Salary-Survey-2021/blob/main/manager_salary_survey_2021_cleaning_and_analysis_file.sql))

## Data Analysis 
The questions were answered using SQL queries, from the analysis of the already-cleaned dataset, we were able to deduce the following
* Media/communication pays the highest: $163,600.22 on average.
* Average salary vs. experience: 1 year or less ($133,086.01) surprisingly tops, followed by 21-30 years ($110,524.87).
* Salary for the same role varies significantly by location, reflecting local economic conditions and cost of living.
* Salary by gender: Females earn the most on average, followed by males and non-binary individuals.
* Bachelor's degree holders earn the highest on average across most races.

 _Thanks for reading😄._
