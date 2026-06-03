/*
Advanced Practice Problem 8:
Find job postings from the first quarter that have a salary greater than $70K
Combine job posting tables from the first quarter of 2023 (Jan-Mar)
Get job postings with an average yearly salary > $70000
*/

WITH q1_postings AS (
    SELECT
        job_id,
        salary_year_avg
    FROM 
        january_jobs
    UNION ALL
    SELECT
        job_id,
        salary_year_avg
    FROM 
        february_jobs
    UNION ALL
    SELECT
        job_id,
        salary_year_avg
    FROM 
        march_jobs
)

SELECT 
    qp.job_id,
    qp.salary_year_avg
FROM 
    q1_postings AS qp  
WHERE
    qp.salary_year_avg > 70000;
    
/*
Luke's solution using the tables for the 3 months
Find job postings from the first quarter that have a salary greater than $70K
Combine job posting tables from the first quarter of 2023 (Jan-Mar)
Get job postings with an average yearly salary > $70000
Adding a twist - only interested in data analyst roles
*/

SELECT 
    q1_job_postings.job_title_short,
    q1_job_postings.job_location,
    q1_job_postings.job_via,
    q1_job_postings.job_posted_date::date,
    q1_job_postings.salary_year_avg
FROM (
SELECT *
FROM
    january_jobs
UNION ALL
SELECT *
FROM
    february_jobs
UNION ALL
SELECT *
FROM
    march_jobs
) AS q1_job_postings
WHERE
    q1_job_postings.salary_year_avg > 70000 AND
    q1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    q1_job_postings.salary_year_avg DESC;
