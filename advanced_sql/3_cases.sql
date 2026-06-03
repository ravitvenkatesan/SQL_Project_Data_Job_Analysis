-- Query to connect to a db
SELECT * 
FROM job_postings_fact 
LIMIT 10;

-- I created 3 tables in 2_dates.sql. I have to rename jan_2023_jobs to january_jobs and so on for Feb and Mar 
ALTER TABLE jan_2023_jobs
RENAME TO january_jobs;

ALTER TABLE feb_2023_jobs 
RENAME TO february_jobs;

ALTER TABLE mar_2023_jobs 
RENAME TO march_jobs;

-- The january_jobs, february_jobs and march_jobs can be created using
-- SubQueries and Common Table Epressions (CTEs)

-- Using SubQuery:
SELECT
FROM ( --SubQuery starts here
   SELECT *
   FROM job_postings_fact
   WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;
-- Subquery ends here

-- Using CTEs:
WITH january_jobs AS ( -- CTE definition starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) -- CTE definition ends here

SELECT *
FROM january_jobs;

-- Using SubQuery, Get a list of companies that offer jobs without requiring a degree

-- Normal query without company name would be:
SELECT 
    company_id, 
    job_no_degree_mention 
FROM 
    job_postings_fact 
WHERE 
    job_no_degree_mention = true;


-- Using SubQuery to get company names and job without degree requirement
SELECT 
    company_id,
    name AS company_name
FROM 
    company_dim 
WHERE company_id IN (
    SELECT 
            company_id 
        FROM
            job_postings_fact
        WHERE
            job_no_degree_mention = true
        ORDER BY
            company_id
)

/*
CTE Problem:
Find the companies that have the most job openings. Get  the total number of job postings
Get the total number of job postings per company id. Return the total number of jobs with the company name
*/
WITH company_job_postings AS (
    SELECT 
        company_id,
        COUNT(*) AS num_job_openings
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT 
    company_job_postings.company_id,
    c.name AS company_name,
    company_job_postings.num_job_openings
FROM 
    company_dim c
LEFT JOIN company_job_postings
    ON c.company_id  = company_job_postings.company_id
ORDER BY
    company_job_postings.num_job_openings DESC;


/*
Practice Problem:
1)Identify the  top 5 skills that are not most frequently mentioned in job postings. Use a subquery to find 
the skill IDs with the highest counts in the skills_job_dim table and then join this result with the skills_dim 
table to get the skill names.
*/
SELECT
    skills_jobs.skill_id,
    skills_dim.skills,
    skills_jobs.skill_counts
FROM 
    skills_dim 
JOIN (

SELECT
    skill_id,
    COUNT(skill_id) AS skill_counts
FROM
    skills_job_dim
GROUP BY
    skill_id
ORDER BY
    skill_counts ASC
LIMIT 5
) AS skills_jobs
ON skills_dim.skill_id = skills_jobs.skill_id
ORDER BY
    skills_jobs.skill_counts ASC
LIMIT 5;

/*
2)Determine the size category ('Small', "Medium' or 'Large') for each company by first identifying the number of 
job postings they have. Use a subquery to calculate the total job postings per company. A company is considered 
'Small' if it has less than 10 job postings. 'Medium' if the number of job postings is between 10 and 50, and 
'Large' if it has more than 50 job postings. Implement a subquery to aggregate job counts per company before 
classifying them based on size.
*/
SELECT
    jobs_per_company.company_id,
    cd.name AS company_name,
    jobs_per_company.job_count,
    CASE 
        WHEN jobs_per_company.job_count = 0 THEN 'No jobs'
        WHEN jobs_per_company.job_count BETWEEN 1 AND 9 THEN 'Small'
        WHEN jobs_per_company.job_count BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS company_size
FROM
(
SELECT
    company_id,
    COUNT(job_id) AS job_count
FROM 
    job_postings_fact AS jpf
GROUP BY
    company_id) AS jobs_per_company
JOIN company_dim AS cd
    ON jobs_per_company.company_id = cd.company_id


/*
Advanced Practice Problem - CTE

Find the count of number of remote job postings per skill 
Display the top 5 skills by their demand in remote jobs
Include skill ID, name and  count of postings requiring the skill
only for data analyst jobs
*/
WITH skill_remote_job_postings AS (
    SELECT 
        COUNT(jpf.job_id) AS count_of_postings,
        skills.skill_id,
        skills.skills AS name
    FROM
        job_postings_fact AS jpf
    JOIN skills_job_dim AS skills_jobs
        ON jpf.job_id = skills_jobs.job_id
    JOIN skills_dim AS skills
        ON skills_jobs.skill_id = skills.skill_id
    WHERE
        jpf.job_work_from_home = True AND
        jpf.job_title_short = 'Data Analyst'
    GROUP BY
        skills.skill_id    
)

SELECT
    srjp.skill_id,
    srjp.name,
    srjp.count_of_postings
FROM
    skill_remote_job_postings AS srjp
ORDER BY srjp.count_of_postings DESC
LIMIT 5;


