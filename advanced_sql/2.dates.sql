SELECT 
  job_posted_date 
FROM job_postings_fact 
LIMIT 10;

SELECT '2023-02-19';

SELECT '2023-02-19'::DATE;

SELECT 
    '2023-02-9'::DATE, 
    '123'::INTEGER,
    'true'::BOOLEAN,
    '3.14'::REAL;

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AS date
FROM
    job_postings_fact
LIMIT 100;

-- Convert timestamp to date as we need only date
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date ::DATE AS date
FROM
    job_postings_fact
LIMIT 100;

/*
As we don't have time zone, by default it is set to UTC. 
We then need to convert it to our time zone of choice. 
In this case, we will convert it to EST (Eastern Standard Time)
EST is 5 hrs behind UTC; Our orig time of 17:46:06 is 12:46:06 EST
*/

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM
    job_postings_fact
LIMIT 5;

-- Exract month from job posting date 
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month 
FROM job_postings_fact 
LIMIT 5;

-- Exract year from job posting date and add to above query
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM job_postings_fact 
LIMIT 5;

-- Find how job postings are trending from month to month 
SELECT 
    job_id,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
LIMIT 5;

--Aggregate by month to find count of job postings by month
SELECT
    COUNT(job_id),
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
GROUP BY 
    month; 

--Aggregate job counts by month for Data Anaalyst roleonly
SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY 
    month
ORDER BY
    job_posted_count DESC;

/*
Practice Problems:
1)Write a query to find the average salary both yearly(salary_year_avg)and hourly(salary_hour_avg) for job 
postings that were posted after June 1, 2023. Group the results by job schedule type.
*/
SELECT 
    AVG(salary_year_avg) AS avg_yearly_salary,
    AVG(salary_hour_avg) AS avg_hourly_salary,
    job_schedule_type
FROM 
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01' 
GROUP BY 
    job_schedule_type; 


/*
2)Write a query to count the number of job postings for each month in 2023, adjusting the job_posted_date 
to be in 'America/New_York' time zone before extracting the month.Assume the job_posted_date is stored in UTC. 
Group by and order by the month.
*/
SELECT
    COUNT(job_id) AS job_posting_count,
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York')AS month
FROM
    job_postings_fact
WHERE 
    EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') = 2023
GROUP BY  
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York')
ORDER BY
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York');


/* 
3)Write a query to find companies (include company name) that have posted jobs offering health  insurance, 
where these postings were made in the second quarter of 2023. Use date extraction to filter by quarter.
*/
SELECT DISTINCT
    c.company_id, 
    c.name AS company_name,
    jpf.job_health_insurance AS health_insurance 
FROM company_dim c 
INNER JOIN job_postings_fact AS jpf 
    ON c.company_id = jpf.company_id
WHERE
    EXTRACT(QUARTER FROM jpf.job_posted_date) = 2 AND
    EXTRACT(YEAR FROM jpf.job_posted_date) = 2023
    AND jpf.job_health_insurance = true;

/*
Practice Problem: Create tables from other tables
Create three tables: Jan 2023 jobs, Feb 2023 jobs and Mar 2023 jobs
HINT: Use CREATE TABLE table_name AS syntax to create your table
Look at a way to filter out only specific months (EXTRACT)
*/
CREATE TABLE Jan_2023_jobs AS 
SELECT *
FROM job_postings_fact 
WHERE EXTRACT(MONTH FROM job_postings_fact.job_posted_date) = 1;
-- AND EXTRACT(YEAR FROM job_postings_fact.job_posted_date) = 2023; 

CREATE TABLE Feb_2023_jobs AS 
SELECT * 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_postings_fact.job_posted_date) = 2;
-- AND EXTRACT(YEAR FROM job_postings_fact.job_posted_date) = 2023;

CREATE TABLE Mar_2023_jobs AS 
SELECT * 
FROM job_postings_fact 
WHERE EXTRACT(MONTH FROM job_postings_fact.job_posted_date) = 3 
--AND  EXTRACT(YEAR FROM job_postings_fact.job_posted_date) = 2023;

-- CASE EXPRESSIONS
SELECT 
    job_title_short, 
    job_location 
FROM job_postings_fact;

/*
Label new column as follows:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- Otherwise 'Onsite'
*/

SELECT 
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote' 
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact;

-- Aggregate the values by different location categories 
SELECT 
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote' 
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
GROUP BY
    location_category
ORDER BY
    location_category DESC;

-- Aggregate for Data Anaalyst jobs
SELECT 
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote' 
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite' 
    END AS location_category 
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst' 
GROUP BY location_category; 

/*
Practice problem for CASE WHEN:
1)I want to categorize the salaries from each job posting. To see if it fits in my desired salary range
Put salary into different buckets
Define what's a high, standard or low salary with our own conditions
Why? It's easy to determine which job postings are worth looking at based on salary.
Bucketing is a common practice in data analysis when viewing categories
I only want to look at data analyst roles
Order from highest to lowest
*/
--Avg salary for data analyst role is $93876
SELECT
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst';

-- Bucket salary into high, standard and low based on the average salary for data analyst role
SELECT 
    salary_year_avg AS salary,
    CASE 
        WHEN salary_year_avg < 50000 THEN 'Low Salary' 
        WHEN salary_year_avg BETWEEN 50000 AND 94000 THEN 'Standard Salary' 
        WHEN salary_year_avg > 94000 THEN 'High Salary' 
        ELSE 'Salary Unknown'
    END AS salary_bucket
FROM 
    job_postings_fact 
WHERE 
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC;


/*
A problem to test my overall SQL skill so far:

The Scenario: You are auditing a database to find high-performing job sectors. You need to identify how many 
jobs exist in each skill category, but you only want to focus on skills that are actually in demand.

The Objective: Write a single query that categorizes skills based on their total job postings, matching these 
exact rules:

The Subquery: Calculate the total number of job postings for each skill_id from the skills_job_dim table.
The Filter: Inside your subquery, filter out any skill that has fewer than 15 total job postings.
The Outer Query: Join this result with the skills_dim table to fetch the actual skill name.
The Conditional Logic: Create a column called demand_level using a CASE WHEN statement:'High Demand': if the
job count is 100 or more.
'Moderate Demand': if the job count is between 15 and 99.
The Presentation: Order the final output so the highest job counts appear at the very top.
Target Columns to Display: Your final output must display exactly these four columns in this order:
skill_id, skills (the skill name), total_jobs (the aggregated count from your subquery) and
demand_level (the text from your CASE WHEN statement)

Table Reference Guide
skills_dim: Contains skill_id and skills.
skills_job_dim: Contains skill_id and job_id.
Take your time to write this out from scratch on a piece of paper or in your text editor.
Do not worry about running it against a live database—just focus on getting the structure, aliases, 
and logic perfectly clean.
Reply with your complete SQL code whenever you are ready, and we will grade it together!
*/
SELECT
    job_skill_counts.skill_id,
    skills.skills,
    job_skill_counts.job_count AS total_jobs,
    CASE
        WHEN job_skill_counts.job_count > 100 THEN 'High Demand'
        WHEN job_skill_counts.job_count BETWEEN 15 and 99 THEN 'Moderate Demand'
    END AS demand_level
FROM 
(
SELECT
    skill_id,
    COUNT(job_id) AS job_count
FROM
    skills_job_dim AS skills_jobs
GROUP BY
    skill_id
HAVING 
    COUNT(job_id) > 15 ) AS job_skill_counts
JOIN skills_dim AS skills
    ON skills.skill_id = job_skill_counts.skill_id
ORDER BY
    job_skill_counts.job_count DESC;

--The above problemm when written as a CTE

WITH job_skill_counts AS (
    SELECT
        skill_id,
        COUNT(job_id) AS job_count
    FROM
        skills_job_dim
    GROUP BY
        skill_id
    HAVING 
        COUNT(job_id) >= 15
)

-- 2. Use it cleanly in your main query below
SELECT
    jsc.skill_id,
    s.skills,
    jsc.job_count AS total_jobs,
    CASE
        WHEN jsc.job_count >= 100 THEN 'High Demand'
        WHEN jsc.job_count BETWEEN 15 AND 99 THEN 'Moderate Demand'
    END AS demand_level
FROM 
    job_skill_counts AS jsc
JOIN skills_dim AS s
    ON s.skill_id = jsc.skill_id
ORDER BY
    jsc.job_count DESC;
