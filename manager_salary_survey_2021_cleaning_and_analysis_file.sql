---Creating a database
CREATE DATABASE Manager_Salary_Survey;

---Checking out the initial dataset
SELECT *
FROM [Manager Salary Survey 2021];

------Duplicating the dataset
SELECT *
INTO manager_sal_surv_2021_copy_1
FROM [Manager Salary Survey 2021];

---Checking for duplicates
SELECT 
      age_range,
	  work_industry,
	  Job_title,
	  job_title_additional_context,
	  annual_salary,
	  additional_monetary_compensation,
	  currency,Other_currency,
	  income_additional_context,
	  work_country,
	  works_in_us_state,
	  work_city,
	  professional_work_experience,
	  professional_work_experience_field,
	  level_of_education,gender,
	  race,
	  COUNT(*)
FROM manager_sal_surv_2021_copy_1
GROUP BY age_range,
         work_industry,
		 Job_title,
		 job_title_additional_context,
		 annual_salary,
		 additional_monetary_compensation,
		 currency,
		 Other_currency,
		 income_additional_context,
		 work_country,
		 works_in_us_state,
		 work_city,
		 professional_work_experience,
		 professional_work_experience_field,
		 level_of_education,
		 gender,
		 race
HAVING COUNT(*) > 1;

--From this, i found some duplicate 
--Removing the duplicates
IF OBJECT_ID('temp_manager_sal_surv_2021', 'U') IS NOT NULL
    DROP TABLE temp_manager_sal_surv_2021;

-- Step 1: Create a temporary table with unique rows
SELECT 
    timestamp,
    age_range, 
    work_industry, 
    Job_title, 
    job_title_additional_context, 
    annual_salary, 
    additional_monetary_compensation, 
    currency, 
    Other_currency, 
    income_additional_context, 
    work_country, 
    works_in_us_state, 
    work_city, 
    professional_work_experience, 
    professional_work_experience_field, 
    level_of_education, 
    gender, 
    race
INTO temp_manager_sal_surv_2021
FROM (
    SELECT 
	    timestamp,
        age_range, 
        work_industry, 
        Job_title, 
        job_title_additional_context, 
        annual_salary, 
        additional_monetary_compensation, 
        currency, 
        Other_currency, 
        income_additional_context, 
        work_country, 
        works_in_us_state, 
        work_city, 
        professional_work_experience, 
        professional_work_experience_field, 
        level_of_education, 
        gender, 
        race,
        ROW_NUMBER() OVER (PARTITION BY  age_range, work_industry, Job_title, job_title_additional_context, annual_salary, additional_monetary_compensation, currency, Other_currency, income_additional_context, work_country, works_in_us_state, work_city, professional_work_experience, professional_work_experience_field, level_of_education, gender, race ORDER BY (SELECT NULL)) AS rn
    FROM manager_sal_surv_2021_copy_1
) t
WHERE t.rn = 1;

--Truncating the original table to remove all rows
TRUNCATE TABLE manager_sal_surv_2021_copy_1;

--Inserting the unique rows back into the original table
INSERT INTO manager_sal_surv_2021_copy_1
SELECT *
FROM temp_manager_sal_surv_2021;

--Droping the temporary table as it is no longer needed
DROP TABLE temp_manager_sal_surv_2021;

--Checking total Null values per column
SELECT 
       SUM(CASE WHEN timestamp IS NULL THEN 1 ELSE 0 END) timestamp_count,
       SUM(CASE WHEN work_industry IS NULL THEN 1 ELSE 0 END) work_indus_count,
	   SUM(CASE WHEN job_title IS NULL THEN 1 ELSE 0 END) job_title_count,
	   SUM(CASE WHEN age_range IS NULL THEN 1 ELSE 0 END) age_range_count,
	   SUM(CASE WHEN job_title_additional_context IS NULL THEN 1 ELSE 0 END) job_title_add_count,
	   SUM(CASE WHEN annual_salary IS NULL THEN 1 ELSE 0 END) annual_sal_count,
	   SUM(CASE WHEN additional_monetary_compensation IS NULL THEN 1 ELSE 0 END) add_mon_comp_count,
	   SUM(CASE WHEN currency IS NULL THEN 1 ELSE 0 END) currency_count,
	   SUM(CASE WHEN Other_currency IS NULL THEN 1 ELSE 0 END) other_currency_count,
	   SUM(CASE WHEN income_additional_context IS NULL THEN 1 ELSE 0 END) income_add_context_count,
	   SUM(CASE WHEN work_country IS NULL THEN 1 ELSE 0 END) work_country_count,
	   SUM(CASE WHEN works_in_us_state IS NULL THEN 1 ELSE 0 END) works_in_us_state_count,
	   SUM(CASE WHEN work_city IS NULL THEN 1 ELSE 0 END) work_city_count,
	   SUM(CASE WHEN professional_work_experience IS NULL THEN 1 ELSE 0 END) professional_work_experience_count,
	   SUM(CASE WHEN professional_work_experience_field IS NULL THEN 1 ELSE 0 END) professional_work_experience_field_count,
	   SUM(CASE WHEN level_of_education IS NULL THEN 1 ELSE 0 END) level_of_education_count,
	   SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) gender_count,
	   SUM(CASE WHEN race IS NULL THEN 1 ELSE 0 END) race_count
FROM manager_sal_surv_2021_copy_1;
--timestamp 0nulls
--age_range 0nulls
--work_industry 74nulls
--job title 0nulls
--annual_salary 0nulls
--currency_count 0nulls
--work_country 0nulls
--work_in_us 4996nulls
--work_city 8nulls
--prof_work_exp 0nulls
--prof_work_exp_field 0nulls
--level_of_ed 216nulls
--gender 169nulls
--race 174nulls

--Checking for rows with annual salary as 0
SELECT *
FROM manager_sal_surv_2021_copy_1
WHERE annual_salary = '0';
 
--Dropping rows with annual salary equal to 0
DELETE FROM manager_sal_surv_2021_copy_1
WHERE annual_salary = '0';

--Standadizing and cleaning the _work_country column
UPDATE manager_sal_surv_2021_copy_1
SET work_country = TRIM(work_country);

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United States of America'
WHERE work_country IN ('U.S ','U.S. ','The US','The United States','U.S.A','U.S.A.','U.S>','U.SA','Uniited States','Unite States','United  States','United Sates','United Sates of America','United Stares','United State','United State of America','United Statea','united stated','United Stateds','United Statees','United States','United States (I work from home and my clients are all over the US/Canada/PR','United States is America','United States of American ','United States of Americas','United Statesp','United States- Puerto Rico','United statew','United Statss','United Stattes','United Statues','United Status','United Statws','United Sttes','United y','UnitedStates','Uniteed States','Unitef Stated','Uniter Statez','Unites States ','Unitied States','Uniyed states','Uniyes States','Unted States','Untied States','US','USA','US govt employee overseas, country withheld','US of A','USA (company is based in a US territory, I work remote)','USA tomorrow ','USA-- Virgin Islands','USA, but for foreign gov''t','USaa','USAB','Usat','USD','USS','UXZ');

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United States of America'
WHERE work_country IN ('Worldwide (based in US but short term trips aroudn the world)');

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United Kingdom'
WHERE work_country LIKE 'wales%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United Kingdom'
WHERE work_country LIKE 'UK %';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United Kingdom'
WHERE work_country LIKE 'UK,%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United Kingdom'
WHERE work_country LIKE 'United King%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United Kingdom'
WHERE work_country LIKE 'engl%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United Kingdom'
WHERE work_country LIKE 'U.K%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United Kingdom'
WHERE work_country LIKE 'Scotl%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United Kingdom'
WHERE work_country LIKE 'Northern ire%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United Kingdom'
WHERE work_country IN ('Unites kingdom','United Kindom','UK');

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Autralia'
WHERE work_country LIKE 'Austra%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Austria'
WHERE work_country LIKE 'Austri%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Argentina'
WHERE work_country LIKE 'Argen%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'New Zealand'
WHERE work_country LIKE 'new %';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'New Zealand'
WHERE work_country LIKE '% new %';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Brazil'
WHERE work_country LIKE 'bra%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United Kingdom'
WHERE work_country LIKE '%bri%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Canada'
WHERE work_country LIKE '%can%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Spain'
WHERE work_country LIKE 'cat%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'China'
WHERE work_country LIKE '%chin%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Croatia'
WHERE work_country LIKE '%croa%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Canada'
WHERE work_country = 'Csnada';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Czech Republic'
WHERE work_country LIKE '%czec%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Denmark'
WHERE work_country LIKE '%mark%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Finland'
WHERE work_country LIKE '%finl%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United States of America'
WHERE work_country LIKE '%hart%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'China'
WHERE work_country LIKE '%hong%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United States of America'
WHERE work_country = 'i.s.';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Italy'
WHERE work_country LIKE '%ital%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Japan'
WHERE work_country LIKE '%japa%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United Kingdom'
WHERE work_country LIKE '%lon%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Luxembourg'
WHERE work_country LIKE '%luxem%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Mexico'
WHERE work_country LIKE '%xic%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Netherlands'
WHERE work_country LIKE '%nether%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Netherlands'
WHERE work_country = 'Nederland';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Netherlands'
WHERE work_country = 'Nl';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'New Zealand'
WHERE work_country = 'Nz';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Pakistan'
WHERE work_country LIKE '%pakis%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Panama'
WHERE work_country LIKE '%Pana%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Philippines'
WHERE work_country LIKE '%Philipp%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United States of America'
WHERE work_country LIKE '%san franc%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'South Sudan'
WHERE work_country = 'ss';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United Arab Emirates'
WHERE work_country IN ('U.A.','UA','UAE');

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United States of America'
WHERE work_country LIKE '%virg%';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Yemen'
WHERE work_country = 'Y';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Argentina'
WHERE work_country = 'I work for an US based company but I''m from Argentina.';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United States of America'
WHERE work_country IN ('I work for a UAE-based organization, though I am personally in the US.','For the United States government, but posted overseas');

--Checking out the out of place work country entries
SELECT work_country,
       works_in_us_state,
	   work_city
FROM manager_sal_surv_2021_copy_1
WHERE work_country IN 
        ('$2,175.84/year is deducted for benefits','????', 'Africa', 'bonus based on meeting yearly goals set w/ my supervisor', 'Cayman Islands', 'Contracts','Currently finance','dbfemf','europe','Global','I earn commission on sales. If I meet quota, I''m guaranteed another 16k min. Last year i earned an additional 27k. It''s not uncommon for people in my space to earn 100k+ after commission.','I was brought in on this salary to help with the EHR and very quickly was promoted to current position but compensation was not altered.','International','Isle of Man','Jersey, Channel islands','LOUTRELAND','n/a (remote from wherever I want)','Policy','Remote','We don''t get raises, we get quarterly bonuses, but they periodically asses income in the area you work, so I got a raise because a 3rd party assessment showed I was paid too little for the area we were located')
ORDER BY LEN(work_country) desc;

--Using the works_in_us_state column to fill the needed work_country columns
UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United States of America'
WHERE work_country IN ('$2,175.84/year is deducted for benefits','????', 'Africa', 'bonus based on meeting yearly goals set w/ my supervisor', 'Cayman Islands', 'Contracts','Currently finance','dbfemf','europe','Global','I earn commission on sales. If I meet quota, I''m guaranteed another 16k min. Last year i earned an additional 27k. It''s not uncommon for people in my space to earn 100k+ after commission.','I was brought in on this salary to help with the EHR and very quickly was promoted to current position but compensation was not altered.','International','Isle of Man','Jersey, Channel islands','LOUTRELAND','n/a (remote from wherever I want)','Policy','Remote','We don''t get raises, we get quarterly bonuses, but they periodically asses income in the area you work, so I got a raise because a 3rd party assessment showed I was paid too little for the area we were located') AND works_in_us_state IS NOT NULL;

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'United States of America'
WHERE work_country IN ('U. S.','U. S','IS','ISA','America');

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Autralia'
WHERE work_country = 'Austria';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Romania'
WHERE work_country = 'From Romania, but for an US based company';

--Using the work city to determine the work country as the individual stated a continent 
UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Czech Republic'
WHERE work_country = 'Europe';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Canada'
WHERE work_country = 'global';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Canada'
WHERE work_country = '$2,175.84/year is deducted for benefits';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'India'
WHERE work_country = 'Remote';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Canada'
WHERE work_country = 'policy';

UPDATE manager_sal_surv_2021_copy_1
SET work_country = 'Not Stated'
WHERE work_country IN 
      ('LOUTRELAND','Africa','n/a (remote from wherever I want)');

--Standadizing and cleaning the age_range column
UPDATE manager_sal_surv_2021_copy_1
SET age_range = TRIM(age_range);

--Checking for irregularities in the age_range column
SELECT DISTINCT(age_range)
FROM manager_sal_surv_2021_copy_1;

--Standadizing and cleaning the work_industry column
UPDATE manager_sal_surv_2021_copy_1
SET work_industry = TRIM(work_industry);

--Standadizing  the job_title column
UPDATE manager_sal_surv_2021_copy_1
SET Job_title = TRIM(Job_title);

--Checking for irregularities in the work_industry column
SELECT DISTINCT(work_industry)
FROM manager_sal_surv_2021_copy_1
ORDER BY work_industry ASC;

--Filling the Nulls in the work_industry column with job_title values 
UPDATE manager_sal_surv_2021_copy_1
SET work_industry = Job_title
WHERE work_industry IS NULL;

--Creating a new column to group the work industries
ALTER TABLE manager_sal_surv_2021_copy_1
ADD industry_group VARCHAR(MAX);

----Updating the new column added
UPDATE manager_sal_surv_2021_copy_1
SET industry_group =
       CASE
    WHEN work_industry LIKE '%Academia%' OR work_industry LIKE '%University%' OR work_industry LIKE '%Education%' OR work_industry LIKE '%School%' THEN 'Education'
    WHEN work_industry LIKE '%Government%' OR work_industry LIKE '%Public%' THEN 'Government'
    WHEN work_industry LIKE '%Healthcare%' OR work_industry LIKE '%Health%' OR work_industry LIKE '%Medical%' OR work_industry LIKE '%Pharma%' THEN 'Healthcare'
    WHEN work_industry LIKE '%Nonprofit%' OR work_industry LIKE '%Charity%' OR work_industry LIKE '%Foundation%' THEN 'Nonprofit'
    WHEN work_industry LIKE '%Tech%' OR work_industry LIKE '%Software%' OR work_industry LIKE '%Computing%' THEN 'Tech'
    WHEN work_industry LIKE '%Finance%' OR work_industry LIKE '%Banking%' OR work_industry LIKE '%Investment%' OR work_industry LIKE '%Account%'  THEN 'Finance'
    WHEN work_industry LIKE '%Retail%' OR work_industry LIKE '%Ecommerce%' OR work_industry LIKE '%Sales%' OR work_industry LIKE '%Consumer%' THEN 'Retail'
    WHEN work_industry LIKE '%Construction%' OR work_industry LIKE '%Real Estate%' OR work_industry LIKE '%Property%' OR work_industry LIKE '%Architect%' THEN 'Construction/Real Estate'
    WHEN work_industry LIKE '%Media%' OR work_industry LIKE '%Publishing%' OR work_industry LIKE '%Journalism%' OR work_industry LIKE '%Communications%' THEN 'Media/Publishing'
    WHEN work_industry LIKE '%Energy%' OR work_industry LIKE '%Oil%' OR work_industry LIKE '%Gas%' OR work_industry LIKE '%Utilities%' THEN 'Energy/Utilities'
    WHEN work_industry LIKE '%Manufacturing%' OR work_industry LIKE '%Production%' OR work_industry LIKE '%Industrial%' THEN 'Manufacturing'
    WHEN work_industry LIKE '%Transportation%' OR work_industry LIKE '%Logistics%' OR work_industry LIKE '%Supply Chain%' THEN 'Transportation/Logistics'
    WHEN work_industry LIKE '%Food%' OR work_industry LIKE '%Beverage%' OR work_industry LIKE '%Restaurant%' OR work_industry LIKE '%Catering%' THEN 'Food/Beverage'
    WHEN work_industry LIKE '%Agriculture%' OR work_industry LIKE '%Forestry%' THEN 'Agriculture/Forestry'
    WHEN work_industry LIKE '%Art%' OR work_industry LIKE '%Culture%' OR work_industry LIKE '%Entertainment%' THEN 'Arts/Entertainment'
    WHEN work_industry LIKE '%Research%' OR work_industry LIKE '%Science%' OR work_industry LIKE '%Lab%' THEN 'Research/Science'
    WHEN work_industry LIKE '%Consulting%' OR work_industry LIKE '%Professional Services%' OR work_industry LIKE '%Advisory%' THEN 'Consulting/Professional Services'
    WHEN work_industry LIKE '%Legal%' OR work_industry LIKE '%Law%' OR work_industry LIKE '%Compliance%' THEN 'Legal'
    WHEN work_industry LIKE '%Hospitality%' OR work_industry LIKE '%Tourism%' OR work_industry LIKE '%Travel%' THEN 'Hospitality/Tourism'
	WHEN work_industry LIKE '%Aerospace%' OR work_industry LIKE '%Airline%' THEN 'Aerospace'
	WHEN work_industry LIKE '%Animal%' OR work_industry LIKE '%Animal Care%' THEN 'Veterinary/Animal Services'
	WHEN work_industry LIKE '%Apparel%' THEN 'Fashion and Textile'
	WHEN work_industry LIKE '%Archaeologist%' OR work_industry LIKE '%Anthropology%' THEN 'Archaeologist'
    ELSE work_industry END;

--Adding a new column to further group industry group
ALTER TABLE manager_sal_surv_2021_copy_1
ADD industry_category VARCHAR(MAX);

--Update the new column with the further grouping
UPDATE manager_sal_surv_2021_copy_1
SET industry_category = CASE
    WHEN industry_group IN (
        'IT', 'Tech', 'Technology', 'Cybersecurity', 'Internet', 'Digital', 'Digital strategy manager', 'Order Management Analyst',
        'Data Analytics', 'Data Analytics Engineer', 'SAAS', 'Software', 'Software Development', 'Animation',
        'Game Development', 'Video Game Industry', 'Video games', 'Information services', 'Cybersecurity senior risk specialist',
        'Information Management/Archives', 'Information', 'Information services (libraries)','UX Designer', 'Games development',
        'Information Services/Libraries', 'Information Technology', 'e-learning', 'Online learning', 'GIS Analyst',
        'Content Review - Copyright/DMCA', 'IT Security', 'Business Analyst', 'Data Breach','Analytics','IT Manager') THEN 'IT/Technology'
    WHEN industry_group IN (
        'Healthcare', 'Hospital', 'Medical', 'Medicine', 'Clinical', 'Clinical trials', 'Veterinary','Veterinarian', 
        'Veterinary medicine', 'Veterinary care', 'Veterinary Diagnostics', 'Veterinary services','Veterinary m&a', 
        'Veterinary/Animal Services', 'Pharmacy', 'Pharmaceutical', 'Biotechnology','Pet care industry', 
        'Mental Health', 'Psychology', 'Psychologist', 'Nursing', 'Dentistry', 'Dental', 'Chemist','Vet',
        'Public Health', 'Health and Wellness', 'Health', 'Medical Device','Toxicology','Drug development') THEN 'Healthcare'
    WHEN industry_group IN (
        'Education', 'Teaching', 'Librarian','Teacher', 'Trainer', 'Training', 'Academic', 'Academics', 'Associate professor','Ecology','Literature','Biologist 1','Libraries/Museums/Archives',
        'Instructional Design', 'Instructional Designer', 'Education Management', 'Information services (library)','Library/Archive','Biologist','Early childhood teacher','ESL Teacher',
        'Education Technology', 'Higher Education', 'Elementary Education', 'Scientific R&D','Archives/Libraries','Biology','Graduate assistant and also events','PhD','Library and Information Services',
        'Early Childhood Education', 'Special Education', 'Graduate Student','Professional training','Analytical Chemistry', 'Libraries and Archives (Academic)','Adult Services Librarian','religious educator',
        'Student', 'Graduate Assistant', 'College Athletics', 'Library','Library (its a non-profit and its a govt job - how would I list that? Not all libraries are govt jobs)', 'Libraries','librarian--Contractor for NASA', 'Libraries and Archives','Librarian and Assistant Manager of a library','Libraries / Archives / Information', 'chemistry', 'Libraries & Archives', 'Library/archives') THEN 'Education'
    WHEN industry_group IN (
        'Nonprofit', 'Charity', 'Fundraising', 'Philanthropy', 'Volunteer', 'NGO', 
        'Nonprofit Organization', 'Non-profit Theatre', 'Non Profit Theater', 'Social Services', 
        'Social Work', 'Human Services', 'Community Services', 'Disability Services', 'Child Care Resource and Referral Agency',
        'Child Care', 'Childcare', 'Direct support professional', 'Family Services', 'Pet care/grooming',
        'Youth Services', 'Community Management','AmeriCorps','Child and Yout Care') THEN 'Nonprofit/Social Services'
    WHEN industry_group IN (
        'Government', 'Public Sector', 'Municipal', 'Federal', 'State Government', 'Union/political organizing',
        'Local Government', 'Public Administration', 'Policy', 'Political Campaign', 'Soldier','Immigration','Unions',
        'Politics', 'Government contractor', 'Defense', 'Defense Contracting', 'Political Campaigning','Fire protection',
        'Defense Contractor', 'Military', 'DoD Contracting', 'Public Safety', 'State and federal contractor','Obligatory Military service',
        'Emergency Management', 'Law Enforcement', 'Regulatory Affairs', 'Govt contractor - not direct govt but they pay my company who in turn pays me',
        'Public Policy', 'International Organization', 'Multilateral Organization', 'Political Campaigns', 'Politics/Campaigns') THEN 'Government/Public Sector'
    WHEN industry_group IN (
        'Finance', 'Banking', 'Investment', 'Insurance', 'Actuarial', 'Accounting', 
        'Financial Services', 'Financial Planning', 'Wealth Management', 'Private Equity', 
        'Venture Capital', 'Corporate Finance', 'Credit', 'Credit Supervisor', 'Investing','commodities trading',
        'Economics', 'Pension Benefit Administration''Auto liability representative 2','Pension Benefit Administration') THEN 'Finance'
    WHEN industry_group IN (
        'Engineering', 'Civil Engineering', 'Mechanical Engineering', 'Electrical Engineering', 'Engineering - Mining',
        'Software Engineering', 'Industrial Engineering', 'Mining Engineering', 'Interior landscaping',
        'Petroleum Engineering', 'Environmental Engineering', 'Chemical Engineering', 'Commercial Landscaping',
        'Biomedical Engineering', 'Construction Engineering', 'Construction', 'Landscape Contracting',
        'Architecture', 'Design', 'Urban Planning', 'Landscaping', 'Engineering/Construction', 'Surveying') THEN 'Engineering/Construction'
    WHEN industry_group IN (
        'Retail', 'Sales', 'E-commerce', 'Wholesale', 'Wholesale Trade', 'Wholesale Distribution', 'Beauty/service industry',
        'Retail Management', 'Fashion', 'Fashion and Textile', 'Luxury Fashion','Beauty /CPG', 'Wholesale Distribution B2B',
        'Beauty', 'Beauty Industry', 'Cosmetics', 'Consumer Goods', 'Apparel', 'Specialist clothing','Wine Wholesale',
        'Footwear', 'Jewelry', 'Home Goods', 'Automotive Retail', 'Grocery', 'Beauty, Cosmetics, Fragrance') THEN 'Retail/Wholesale'
    WHEN industry_group IN (
        'Hospitality', 'Tourism', 'Travel', 'Hotel', 'Restaurant', 'Food and Beverage','museums & archives (not sure where this would fall)', 
        'Food/Beverage', 'Event Planning', 'Event Management', 'Leisure', 'Recreation', 'Museum (<20 employees)','Museums & archives','Special Collections Library',
        'Entertainment', 'Arts', 'Cultural', 'Museums', 'Theatre', 'Music', 'Arts/Entertainment', 'Museum','cultural (museums/galleries)') THEN 'Hospitality/Entertainment'
    WHEN industry_group IN (
        'Transportation', 'Logistics', 'Shipping', 'Freight', 'Warehousing', 
        'Supply Chain', 'Distribution', 'Delivery', 'Automotive', 'Aviation', 'Grocery delivery',
        'Maritime', 'Trucking', 'Railroad', 'Public Transit', 'Grocery Distribution') THEN 'Transportation/Logistics'
    WHEN industry_group IN (
        'Energy', 'Utilities', 'Oil and Gas', 'Renewable Energy', 'Power Generation', 
        'Electricity', 'Natural Gas', 'Water Supply', 'Waste Management', 'Environmental Services', 
        'Sustainability', 'Energy/Utilities', 'Mining', 'Mining/Resource Extraction', 
        'Mining and natural resources', 'Natural resources', 'Resource Extraction') THEN 'Energy/Utilities'
    WHEN industry_group IN (
        'Real Estate', 'Property Management', 'Construction/Real Estate','Landed Estate', 
        'Commercial Real Estate', 'Residential Real Estate', 'Land Development', 'Subsidized Seniors Housing',
        'Property Development', 'Real Estate Investment', 'Real Estate Finance', 
        'Real Estate Services') THEN 'Real Estate'
    WHEN industry_group IN (
        'Legal', 'Law', 'Legal Services', 'Legal Assistance', 'Paralegal', 'Attorney', 
        'Lawyer', 'Litigation', 'Corporate Law', 'Criminal Law', 'Family Law', 
        'Intellectual Property', 'Regulatory Affairs') THEN 'Legal'
    WHEN industry_group IN (
        'Media', 'Publishing', 'Journalism', 'Broadcasting', 'Television', 
        'Radio', 'Digital Media', 'Print Media', 'Media/Publishing', 'Communications', 
        'Public Relations', 'Advertising', 'Marketing', 'Marketing Coordinator', 
        'Content Creation', 'Content Management', 'Creative Writing', 
        'Copywriting') THEN 'Media/Communications'
    WHEN industry_group IN (
        'Agriculture', 'Farming', 'Forestry', 'Fishery', 'Agribusiness', 
        'Horticulture', 'Animal Husbandry', 'Agricultural Science', 'Agronomy', 
        'Agroforestry', 'Aquaculture', 'Agrotechnology') THEN 'Agriculture/Forestry'
    WHEN industry_group IN (
        'Manufacturing', 'Production', 'Industrial', 'Factory', 'Textile', 
        'Electronics Manufacturing', 'Automotive Manufacturing', 'Chemical Manufacturing', 
        'Food Manufacturing', 'Pharmaceutical Manufacturing', 'Machinery', 
        'Metallurgy', 'Plastic', 'Glass Manufacturing', 'Printing', 'Packaging') THEN 'Manufacturing'
    WHEN industry_group IN (
        'Consulting', 'Business Services', 'Professional Services', 'Management Consulting', 
        'Strategy Consulting', 'Human Resources', 'HR', 'Recruitment', 'Staffing', 
        'Talent Acquisition', 'Training and Development', 'Organizational Development', 
        'Learning and Development', 'Workforce Development') THEN 'Consulting/Professional Services'
    WHEN industry_group IN (
        'Security', 'Safety', 'Private Security', 'Corporate Security', 
        'Security Services', 'Surveillance', 'Cybersecurity', 'Risk Management', 
        'Loss Prevention', 'Emergency Management', 'Disaster Management', 'Security') THEN 'Security'
    WHEN industry_group IN (
        'Food', 'Beverage', 'Culinary', 'Restaurant', 'Cafe', 'Catering', 
        'Food Services', 'Food/Beverage', 'Grocery', 'Food Distribution', 
        'Baking', 'Brewing', 'Winemaking', 'Food Manufacturing') THEN 'Food/Beverage'
    WHEN industry_group IN (
        'Digital Marketing', 'Digital Marketing Specialist', 'Digital strategy manager', 'E commerce', 
        'e-comm', 'e-commerce', 'In-House Marketing', 'Marketing', 'Marketing at a Non Profit', 
        'Marketing Coordinator', 'Marketing, Advertising & PR', 'Marketing', 'Advertising', 
        'Public Relations', 'Advertising & PR''I have two jobs. Marketing / Business') THEN 'Marketing'
      ELSE  industry_group END;


--Checking the annual_salary and additional_monetary_compensation column
SELECT DISTINCT annual_salary
FROM manager_sal_surv_2021_copy_1;

SELECT DISTINCT additional_monetary_compensation
FROM manager_sal_surv_2021_copy_1;

--Creating a column that sums up the annual salary and the additiona monetary compensation
ALTER TABLE manager_sal_surv_2021_copy_1
ADD total_monetary_comp INT;

--Updating the newly created column
UPDATE manager_sal_surv_2021_copy_1
SET total_monetary_comp = CASE
                             WHEN additional_monetary_compensation IS NULL THEN annual_salary
                             ELSE annual_salary + additional_monetary_compensation
                          END;

--Checking the currency column
 SELECT DISTINCT currency 
 FROM manager_sal_surv_2021_copy_1;

--Trimming the currency column 
UPDATE manager_sal_surv_2021_copy_1
SET currency = TRIM(currency);

--Trimming the other_currency column 
UPDATE manager_sal_surv_2021_copy_1
SET Other_currency = TRIM(Other_currency);

--Filling the rows in currency having 'other' with values from other_currency
UPDATE manager_sal_surv_2021_copy_1
SET currency =
      CASE 
	   WHEN currency = 'Other' AND Other_currency IS NOT NULL THEN Other_currency ELSE currency END; 

--Checking out the updated currency column
SELECT DISTINCT currency 
FROM manager_sal_surv_2021_copy_1
ORDER BY currency;

--Cleaning the updated currency column
UPDATE manager_sal_surv_2021_copy_1
SET currency = 'USD'
WHERE currency IN ('American Dollars','US Dollar');

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'ARS'
WHERE currency LIKE '%Argentin%';

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'AUD'
WHERE currency IN ('AUD Australian','Australian Dollars');

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'BRL'
WHERE currency LIKE 'BR%';

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'CNY'
WHERE currency IN ('China RMB','CNY','RMB (chinese yuan)');

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'HRK'
WHERE currency = 'croatian kuna';

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'CZK'
WHERE currency = 'czech crowns';

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'DKK'
WHERE currency = 'Danish Kroner'

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'Other'
WHERE currency = 'Equity';

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'EUR'
WHERE currency = 'Euro';

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'ILS'
WHERE currency IN ('ILS (Shekel)','ILS/NIS','Israeli Shekels','NIS (new Israeli shekel)');

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'INR'
WHERE currency LIKE '%INDIA%';

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'KRW'
WHERE currency LIKE '%KOREAN%';

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'MXN'
WHERE currency = 'Mexican Pesos';

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'MYR'
WHERE currency = 'RM';

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'NOK'
WHERE currency = 'Norwegian kroner (NOK)';

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'TWD'
WHERE currency IN ('NTD','Taiwanese dollars');

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'PHP'
WHERE currency LIKE '%PHILIPPINE%';

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'PLN'
WHERE currency IN ('PLN (Polish zloty)','PLN (Zwoty)','Polish Z?oty');

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'INR'
WHERE currency = 'Rupees';

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'SGD'
WHERE currency = 'Singapore Dollara';

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'THB'
WHERE currency IN ('THAI  BAHT','Thai Baht');

--Checking out rows which have currency as 'Others' and other_currency as NULL
SELECT *
FROM manager_sal_surv_2021_copy_1
WHERE currency = 'Other' AND Other_currency IS NULL;

--Filling up these columns using there work country
UPDATE manager_sal_surv_2021_copy_1
SET currency = 'USD'
WHERE work_country = 'United States of America' 
         AND currency = 'Other' 
		 AND Other_currency = 'Equity';

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'USD'
WHERE work_country = 'United States of America' 
         AND currency = 'Other' 
		 AND Other_currency IS NULL;

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'MYR'
WHERE work_country = 'Malaysia' 
         AND currency = 'Other' 
		 AND Other_currency IS NULL;

UPDATE manager_sal_surv_2021_copy_1
SET currency = 'INR'
WHERE work_country = 'India' 
         AND currency = 'Other' 
		 AND Other_currency IS NULL;


--Updating the currency column to upper case
UPDATE manager_sal_surv_2021_copy_1
SET currency = UPPER(currency);

--Inspecting the currency column
SELECT DISTINCT currency
FROM manager_sal_surv_2021_copy_1
ORDER BY currency;

--Inspecting the professional_work_experience column 
SELECT DISTINCT professional_work_experience
FROM manager_sal_surv_2021_copy_1;

--Standadizing the professional_work_experience column 
UPDATE manager_sal_surv_2021_copy_1
SET professional_work_experience = TRIM(professional_work_experience);

--Inspecting the professional_work_experience_field column 
SELECT DISTINCT professional_work_experience_field
FROM manager_sal_surv_2021_copy_1;

--Standadizing the professional_work_experience_field column 
UPDATE manager_sal_surv_2021_copy_1
SET professional_work_experience_field = TRIM(professional_work_experience_field);

--Inspecting the level_of_education column 
SELECT DISTINCT level_of_education
FROM manager_sal_surv_2021_copy_1;

--Updating the level_of_education column 
UPDATE manager_sal_surv_2021_copy_1
SET level_of_education = CASE
            WHEN level_of_education = 'Professional degree (MD, JD, etc.)' THEN 'Professional Degree'
			WHEN level_of_education = 'PhD' THEN 'Doctorate Degree'
			WHEN level_of_education = 'High School' THEN 'High School Diploma'
			WHEN level_of_education = 'College degree' THEN 'Bachelor''s Degree'
			WHEN level_of_education = 'Master''s degree' THEN 'Master''s Degree'
			WHEN level_of_education = 'Some college' THEN 'Some College, No Degree'
			ELSE level_of_education 
			END; 

--Inspecting the level_of_education column 
SELECT DISTINCT level_of_education
FROM manager_sal_surv_2021_copy_1;

--Inspecting the gender column
SELECT DISTINCT gender,COUNT(*)
FROM manager_sal_surv_2021_copy_1
GROUP BY gender;

--Updating the level_of_education column 
UPDATE manager_sal_surv_2021_copy_1
SET gender = CASE
     WHEN gender = 'woman' THEN 'Female'
	 WHEN gender = 'man' THEN 'Male'
	 WHEN gender = 'Other or prefer not to answer' OR gender = 'Prefer not to answer' THEN 'Other or prefer not to answer'
	 WHEN gender = 'Non-binary' THEN 'Non-Binary'
	 ELSE gender
	 END;

--Inspecting the race column
SELECT DISTINCT race, 
       COUNT(*) AS cn
FROM manager_sal_surv_2021_copy_1
GROUP BY race 
ORDER BY cn DESC;

--Trimming the race column 
UPDATE manager_sal_surv_2021_copy_1
SET race = TRIM(race);

--Updating the race column
UPDATE manager_sal_surv_2021_copy_1
SET race = 'Another option not listed here or prefer not to answer'
WHERE race IS NULL;

--Inspecting the race column
SELECT DISTINCT race, 
       COUNT(*) AS cn
FROM manager_sal_surv_2021_copy_1
GROUP BY race 
ORDER BY cn DESC;

--Cleaning the job_title column 
UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'High School Teacher'
WHERE Job_title LIKE '%High School%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Software Engineer'
WHERE Job_title LIKE '%senior software engineer%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Software Engineer'
WHERE Job_title IN ('Director of software engineering','Software Engineer Team Lead','Director, Software Engineering','Head Of Software Engineering','Software engineering team lead','Software Engineer 2 Lead','Software Engineer, Sr','Sr. Software Engineer, Test','Sr Software Engineering Manager','Sr Staff Software Engineer','Sr. Manager, Software Engineering','Senior staff software engineer','Senor software engineer','Senior Principal Software Engineer','Senior Principle Software Engineer','Senior Embedded Software Engineer','Sr. Software Engineer','Sr software engineer','Senior Back-End Software Engineer','Software Engineer senior principal','Senior Manager of Software Engineering','Senior Manager, Software Engineering','Senior Principle Cyber Software Engineer','Lead Software Engineer');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Software Engineer'
WHERE Job_title IN ('Software engineer','Associate Software Engineer','Staff Software Engineering Manager','Specialist Software engineer','Advisory Software Engineer','Principal iOS Software Engineer','Software Engineering Director','','Software Engineering Instructor','Software Engineer Principal II','Staff Software Engineer','Principal Software Engineer','Software Engineer II','Software Engineering Manager','Software Engineer 2','Software Engineer 3','Software Engineer III','Embedded Software Engineer','Software Engineer IV','iOS software engineer','Software Engineer I','Software Engineer in Test','Principal Software Engineering Manager','Principle Software Engineer','R&D Software Engineer','Research Software Engineer','Robotics Software Engineer','Front End Software Engineer','Frontend Software Engineer','Graduate Software Engineer','Backend Software Engineer','Co-founder / Software Engineer','Database Software Engineer','Developer (software engineer/programmer)','Software Engineer III (VP)','Software Engineer for Safety Critical & Fault Tolerant Systems','Mobile Software Engineer','Software Engineer (Front End)','Software Engineer (SE1)','Software Engineer 1','Software Engineering Principal Member of Technical Staff','SVP, Software Engineering','System Software Engineer','Web Software Engineer III','Software Engineer L2','Software Engineer Mid','Software Engineer Technical Support','Software Engineer, Infrastructure','Software Engineer, Test II','Software Engineer, Security','Software Engineer Principal II','Full Stack Software Engineer II','Full Stack Software Engineer','Principal iOS Software Engineer','Advisory Software Engineer');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Software Engineer Intern'
WHERE Job_title IN ('Software Engineer Intern','Software Engineering Intern');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Project Manager'
WHERE Job_title LIKE '%Senior%Project Manager%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Project Manager'
WHERE Job_title LIKE '%Sr%Project Manager%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Project Manager'
WHERE Job_title = 'Lead Project Manager';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Project Manager'
WHERE Job_title = 'Project manager senior';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Junior Project Manager'
WHERE Job_title = 'Jr. Project Manager';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Project Manager'
WHERE Job_title LIKE '%comm%Project Manager%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Project Manager'
WHERE Job_title IN ('Medical Affairs Project Manager','Office Manager/Project Manager Assistant','Registered Architect & Project Manager','Regulatory Affairs Associate/Project Manager','System administration and project manager','Deployment Project Manager','Customer Education Project Manager','consultant / project manager','Construction Project Manager','Clinical Research Project Manager','Clinical project manager, clinical trials','Pricing Strategy Project Manager','Architectural Project Manager','Architectural Project Manager/Designer');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Librarian'
WHERE Job_title LIKE '%Senior%Librarian%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Librarian'
WHERE Job_title LIKE '%Librarian%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Program Manager'
WHERE Job_title LIKE '%senior%program manager%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Program Manager'
WHERE Job_title LIKE '%sr%program manager%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Program Manager'
WHERE Job_title LIKE 'Program manager%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Program Manager'
WHERE Job_title IN ('Technical Program Manager','Principal Program Manager','Education Program Manager','Associate Program Manager','Research Program Manager','Privacy Program Manager','Supplier & Subcontractor Program Manager','Statistical Program Manager','State Railroad Program Manager','Design Program Manager','Assistant Program Manager','Advanced Program Manager','Principal Technical Program Manager','Policy and program manager','Operations and Program Manager','Nonprofit Program Manager','Marketing and Program Manager','Learning Program Manager','Hardware Engineering program manager','Governance, risk, and compliance program manager','Global Program Manager','Global Mobility Program Manager','Engineering Program Manager','Digital Program Manager',
                    'Disaster Program Manager','Sales Program Manager','DEI Program Manager','Community Program Manager','Climate and Health Program Manager','Case Management Program Manager','Capability program manager','Campaign and Program Manager','Business Program Manager','Benefits Program Manager','Sales operations program manager','Research scientist and program manager','Renewable Energy Program Manager','Volunteer and Partnerships Program Manager','Training Consultant/ Program Manager','Technology Transformation Project/Program Manager','IT Program Manager','HR Program Manager','Influencer Program Manager','Information and Program Manager','International program manager','Disaster Program Manager','Food and Wellness Program Manager','Environmental program manager','HIV/STD/Viral Hepatitis Surveillance Program Manager');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Product Manager'
WHERE Job_title LIKE 'senior%Product Manager%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Product Manager'
WHERE Job_title LIKE 'sr%Product Manager%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Product Manager'
WHERE Job_title LIKE 'Product Manager%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Product Manager'
WHERE Job_title IN ('Marketing Manager / Senior Product Manager');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Product Manager'
WHERE Job_title IN ('Associate Product Manager','Principal Product Manager','Data and Analytics Product Manager','Digital Product Manager','Technical Product Manager','Global Product Manager','Group Product Manager','HR Product Manager','Insurance product manager','Investment product manager','Lead Product Manager','Loyalty product manager','Assistant Product Manager','data product manager','Staff Product Manager','Software Product Manager','Staff Technical Product Manager');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Administrative Assistant'
WHERE Job_title LIKE '%senior%Administrative Assistant%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Administrative Assistant'
WHERE Job_title LIKE '%sr%Administrative Assistant%'

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Administrative Assistant'
WHERE Job_title LIKE 'Administrative Assistant%'

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Administrative Assistant'
WHERE Job_title IN ('AR Administrative Assistant','Student Administrative Assistant','School Administrative Assistant 1','Sales Administrative Assistant','Program & Administrative Assistant','Maintenance Administrative Assistant','Library Administrative Assistant','Judicial Administrative Assistant','HR & Administrative Assistant','Finance/Administrative Assistant','Executive administrative assistant to the Superintendent','Executive administrative assistant');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Registered Nurse'
WHERE Job_title = 'RN';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Registered Nurse'
WHERE Job_title = 'NURSE';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Registered Nurse'
WHERE Job_title = 'Nurse manager';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Registered Nurse'
WHERE Job_title = 'Assistant Nurse Manager';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Registered Nurse'
WHERE Job_title LIKE 'Registered Nurse%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Registered Nurse'
WHERE Job_title = 'RN - Nurse Supervisor';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Registered Nurse'
WHERE Job_title IN ('Critical Care Registered Nurse','Home healthcare nurse','Senior nurse','Staff nurse','School nurse','Pediatric/Nicu Nurse','Scrub Nurse','Nursery Nurse','Licensed Practical Nurse','Hospice Nurse','Public Health Nurse','Charge Nurse','Professional Nurse 1','Senior Clinical Nurse II','Certified Nurse Midwife','Certified Registered Nurse Anesthetist','Clinical nurse (inpatient)','Clinical Nurse I');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Nurse Practitioner'
WHERE Job_title LIKE '%Nurse Practitioner%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Teacher'
WHERE Job_title LIKE '%teacher%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Data Analyst'
WHERE Job_title LIKE '%senior%Data Analyst';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Data Analyst'
WHERE Job_title LIKE '%sr%Data Analyst%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Data Analyst'
WHERE Job_title = 'Master Data Analyst';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Data Analyst'
WHERE Job_title IN('Research and Data Analyst','Data Analyst II','Data Analyst III','Media and Data Analyst','Quality Improvement Data Analyst','Recruiter & Data Analyst','Reporting & Data Analyst','Research Data Analyst','Technical Data Analyst','Data Analyst (EC-05)','Associate Data Analyst','Business Data Analyst',
                   'Research Data Analyst Associate','Operations Data Analyst','Product Data Analyst','Provider Data Analyst','Quality data analyst','Healthcare Data Analyst','HR Data Analyst','Intermediate Data analyst','Statistical Programmer/Data Analyst','Data Analyst 2','Business Operations (Data Analyst)','Client Data Analyst',
				   'IT Project Manager and Data Analyst','Management Analyst IV (Data Analyst)','Data Analyst Manager','Data Analyst Supervisor (Public Health)','Data Analyst, Fundraising','Research Specialist/Data Analyst','Spatial Data Analyst','Data Analyst Engineer','Cloud Data Analyst','Consultant, data analyst','Crime Data Analyst');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Data Scientist'
WHERE Job_title LIKE '%sr%Data scientist%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Data Scientist'
WHERE Job_title LIKE '%senior%Data scientist%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Data Scientist'
WHERE Job_title IN ('Lead Data Scientist','Chief Data Scientist','Head data scientist','Principal Data Scientist');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Data Scientist'
WHERE Job_title IN ('Data Scientist II','Data Scientist III','Research Data Scientist','Data scientist /epidemiologist','Data Scientist 2','Applied Data Scientist','Associate Data Scientist','Staff Data Scientist');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Business Analyst'
WHERE Job_title LIKE '%SENIOR%Business Analyst%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Business Analyst'
WHERE Job_title LIKE '%SR%Business Analyst%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Business Analyst'
WHERE Job_title IN ('Lead Business Analyst','Principal Business Analyst');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Business Analyst'
WHERE Job_title LIKE 'Business Analyst%'

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Business Analyst'
WHERE Job_title IN ('IT Business Analyst','IT Network and Business Analyst','EHR Business Analyst','Engineering Business Analyst','HR Business Analyst','HRIS Business Analyst','Import coordinator and business analyst','Software Business Analyst','Supply Change Business Analyst');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Software Developer'
WHERE Job_title LIKE '%SENIOR%Software Developer%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Software Developer'
WHERE Job_title LIKE '%SR%Software Developer%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Software Developer'
WHERE Job_title LIKE 'Software Developer%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Software Developer'
WHERE Job_title IN ('Associate Software Developer','Graduate software developer','Mainframe COBOL Software Developer III','Staff Software Developer','Sysadmin + Software Developer','Java Software Developer');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Software Developer'
WHERE Job_title IN ('Lead Software Developer','Principal software developer');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Software Developer Intern'
WHERE Job_title = 'Intern software developer';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Executive Assistant'
WHERE Job_title LIKE '%Senior%Executive Assistant%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Executive Assistant'
WHERE Job_title LIKE '%Sr%Executive Assistant%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Executive Assistant'
WHERE Job_title LIKE 'Executive Assistant%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Executive Assistant'
WHERE Job_title IN ('Personal Executive Assistant','Virtual Executive Assistant');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Assistant Professor'
WHERE Job_title LIKE '%Assistant Professor%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Professor'
WHERE Job_title LIKE 'Professor%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Professor'
WHERE Job_title LIKE 'Analyst%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Attorney Advisor'
WHERE Job_title IN ('Attorney-Advisor','Attorney Adviser');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Attorney'
WHERE Job_title IN ('Attorney 2','Attorney 4 / Supervisor','Attorney (shareholder)','Attorney (11+ years experience)','Attorney (Junior Partner)','Attorney - Class B Shareholder','attorney, legal aid','Attorney and regulatory compliance director');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Paralegal'
WHERE Job_title LIKE '%SENIOR%Paralegal%';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Paralegal'
WHERE Job_title = 'Paralegal (Sr)';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Paralegal Intern'
WHERE Job_title = 'Paralega (Intern)';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Paralegal'
WHERE Job_title IN ('Paralegal Specialist','Paralegal, Trusts & Estates','Paralegal/EA','Paralegal & Admin Assistant','Paralegal / Legal Assistant','Paralegal / Legal Secretary','Paralegal and Assistant to General Counsel','Paralegal Casehandler');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Editor'
WHERE Job_title LIKE 'Editor %';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Manager'
WHERE Job_title = 'manager';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Graphic Designer'
WHERE Job_title IN ('Lead graphic designer','Sr. Graphic Designer');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Graphic Designer'
WHERE Job_title IN ('Graphic Designer (print)','Graphic Designer / Webmaster','graphic designer 1','Graphic Designer & Sign Fabrication');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Senior Consultant'
WHERE Job_title IN ('Sr. Consultant','Sr Consultant');

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Consultant'
WHERE Job_title = 'Consultant II';

UPDATE manager_sal_surv_2021_copy_1
SET Job_title = 'Legal Assistant'
WHERE Job_title = 'Legal Assistant/Paralegal';

--Inspecting the work_city column
SELECT DISTINCT work_city
FROM manager_sal_surv_2021_copy_1
ORDER BY work_city;

--Adding a conversion to usd column 
ALTER TABLE manager_sal_surv_2021_copy_1
ADD conv_to_USD DECIMAL(10,6);

--Updating the conversion values into the new column 
UPDATE manager_sal_surv_2021_copy_1
SET conv_to_USD = CASE 
                  WHEN currency ='ARS' THEN '0.011'
				  WHEN currency = 'AUD' THEN '0.75'
				  WHEN currency  ='AUD/NZD' THEN '0.75'
				  WHEN currency = 'BDT' THEN '0.012'
				  WHEN currency = 'BRL' THEN '0.20'
				  WHEN currency = 'CAD' THEN '0.80'
				  WHEN currency = 'CHF' THEN '1.10'
				  WHEN currency = 'CNY' THEN '0.15'
				  WHEN currency = 'COP' THEN '0.00027'
				  WHEN currency = 'CZK' THEN '0.044'
				  WHEN currency = 'DKK' THEN '0.16'
				  WHEN currency = 'EUR' THEN '1.18'
				  WHEN currency = 'GBP' THEN '1.39'
				  WHEN currency = 'HKD' THEN '0.13'
				  WHEN currency = 'HRK' THEN '0.16'
				  WHEN currency = 'IDR' THEN '0.00007'
				  WHEN currency = 'ILS' THEN '0.31'
				  WHEN currency = 'INR' THEN '0.013'
				  WHEN currency = 'JPY' THEN '0.009'
				  WHEN currency = 'KRW' THEN '0.00089'
				  WHEN currency = 'LKR' THEN '0.005'
				  WHEN currency = 'MXN' THEN '0.05'
				  WHEN currency = 'MYR' THEN '0.24'
				  WHEN currency = 'NGN' THEN '0.0026'
				  WHEN currency = 'NOK' THEN '0.12'
				  WHEN currency = 'NZD' THEN '0.70'
				  WHEN currency = 'PHP' THEN '0.020'
				  WHEN currency = 'PLN' THEN '0.26'
				  WHEN currency = 'SAR' THEN '0.27'
				  WHEN currency = 'SEK' THEN '0.11'
				  WHEN currency = 'SGD' THEN '0.74'
				  WHEN currency = 'THB' THEN '0.031'
				  WHEN currency = 'TRY' THEN '0.11'
				  WHEN currency = 'TTD' THEN '0.15'
				  WHEN currency = 'TWD' THEN '0.035'
				  WHEN currency = 'USD' THEN '1.00'
				  WHEN currency = 'ZAR' THEN '0.069' 
				  ELSE conv_to_USD 
				  END;
--Adding a column to hold the converted version of the annual sal to USD
ALTER TABLE manager_sal_surv_2021_copy_1
ADD  annual_sal_USD DECIMAL(18,6); 

--Adding a column to hold the converted version of the total monetary comp to USD
ALTER TABLE manager_sal_surv_2021_copy_1
ADD  tot_mon_comp_USD DECIMAL(18,6); 

--Updating the annual_sal_usd column
UPDATE manager_sal_surv_2021_copy_1
SET annual_sal_USD = (annual_salary * conv_to_USD);

--Changing the datatype of the annual_sal_USD column
ALTER TABLE manager_sal_surv_2021_copy_1
ALTER COLUMN  annual_sal_USD  DECIMAL(12,2);

--Updating the tot_mon_comp_usd column
UPDATE manager_sal_surv_2021_copy_1
SET tot_mon_comp_USD = (total_monetary_comp * conv_to_USD);

---Dropping unneccessary columns
ALTER TABLE manager_sal_surv_2021_copy_1
DROP COLUMN timestamp;

ALTER TABLE manager_sal_surv_2021_copy_1
DROP COLUMN work_industry;

ALTER TABLE manager_sal_surv_2021_copy_1
DROP COLUMN job_title_additional_context;

ALTER TABLE manager_sal_surv_2021_copy_1
DROP COLUMN Other_currency;

ALTER TABLE manager_sal_surv_2021_copy_1
DROP COLUMN income_additional_context;

ALTER TABLE manager_sal_surv_2021_copy_1
DROP COLUMN works_in_us_state;

ALTER TABLE manager_sal_surv_2021_copy_1
DROP COLUMN work_city;

ALTER TABLE manager_sal_surv_2021_copy_1
DROP COLUMN industry_group;

--Viewing the cleaned dataset
SELECT *
FROM manager_sal_surv_2021_copy_1;


-------ANSWERING SOME ASKED QUESTIONS.
---WHICH INDUSTRY PAYS THE MOST?
SELECT TOP 1
    industry_category work_industry, 
    CAST(AVG(annual_sal_USD) AS DECIMAL (12,2)) avg_sal
FROM 
    manager_sal_surv_2021_copy_1
	 WHERE industry_category IN 
	 ('IT/Technology','Education','Nonprofit/Social Services','Finance','Healthcare','Government/Public Sector','Manufacturing','Media/Communications','Legal','Marketing','Consulting/Professional Services','Retail/Wholesale','Hospitality/Entertainment','Real Estate','Recruitment or HR','Hospitality/Tourism','Transportation/Logistics','Research/Science','Agriculture/Forestry','Energy/Utilities')
GROUP BY 
    industry_category
ORDER BY 
    avg_sal DESC;

---HOW DOES SALARY INCREASE WITH EXPERIENCE?
SELECT 
    professional_work_experience_field,
    CAST(AVG(annual_sal_USD) AS DECIMAL (12,2)) avg_sal
FROM 
    manager_sal_surv_2021_copy_1
GROUP BY 
    professional_work_experience_field
ORDER BY 
   avg_sal DESC;

---HOW DO SALARIES FOR THE SAME ROLE VARY BY LOCATION?
WITH cte AS (
  SELECT 
    job_title,
    annual_sal_USD,   
    work_country
FROM 
    manager_sal_surv_2021_copy_1
WHERE 
	job_title IN (
        SELECT 
            job_title
        FROM 
            manager_sal_surv_2021_copy_1
        GROUP BY 
            job_title
        HAVING 
            COUNT(*) >= 30
    )) 
	SELECT 
	      Job_title,
		  work_country,
		  CAST(AVG(annual_sal_USD) AS DECIMAL (12,2)) avg_sal
	FROM cte
	GROUP BY Job_title,work_country
	ORDER BY Job_title, avg_sal DESC;

---HOW DO SALARY DIFFER BY GENDER AND EXPERIENCE?
SELECT 
      professional_work_experience_field,
	  gender,
	  CAST(AVG(annual_sal_USD) AS DECIMAL (12,2)) avg_sal
FROM manager_sal_surv_2021_copy_1
WHERE 
  gender IN (
     SELECT 
	      gender
	 FROM manager_sal_surv_2021_copy_1
	 WHERE 
	      gender IN('Male','Female','Non-Binary'))
GROUP BY  professional_work_experience_field,gender
ORDER BY  professional_work_experience_field,gender,avg_sal DESC;

---HOW DO RACE AND EDUCATION LEVEL CORRELATE WITH SALARY?
SELECT 
      race,
	  level_of_education,
	  CAST(AVG(annual_sal_USD) AS DECIMAL (12,2)) avg_sal
FROM manager_sal_surv_2021_copy_1
WHERE 
     level_of_education IS NOT NULL
     AND race <> 'Another option not listed here or prefer not to answer'
GROUP BY  race,level_of_education
ORDER BY  race,level_of_education,avg_sal DESC;




