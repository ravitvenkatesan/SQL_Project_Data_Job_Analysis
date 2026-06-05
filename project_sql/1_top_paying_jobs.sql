/*
Qn: What are the top paying data analyst jobs?
Identify the top 10 highest paying Data Analyst roles that are available remotely
Focuses on job postings with specified salaries (remove nulls)
Why? Highlight the top paying opportunities for Data Analysts, offering insights into
*/

SELECT
    jpf.job_id,
    jpf.job_title,
    jpf.job_location,
    jpf.job_schedule_type,
    jpf.salary_year_avg,
    jpf.job_posted_date,
    cd.name AS company_name
FROM
    job_postings_fact AS jpf
JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE
    jpf.job_title_short = 'Data Analyst' AND
    jpf.job_work_from_home = True AND
    jpf.salary_year_avg IS NOT NULL
ORDER BY
    jpf.salary_year_avg DESC
LIMIT 10;

--Q1: What are the top paying jobs for my role?
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_location,
    jpf.salary_year_avg,
    jpf.job_posted_date
FROM
    job_postings_fact AS jpf
WHERE
    jpf.job_title_short = 'Data Analyst' AND
    jpf.salary_year_avg IS NOT NULL
ORDER BY
    jpf.salary_year_avg DESC
LIMIT 10;
