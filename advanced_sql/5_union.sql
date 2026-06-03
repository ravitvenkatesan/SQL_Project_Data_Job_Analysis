-- Get jobs and companies from Jauary
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION

--Get jobs and companies from February
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION

-- Get jobs and companies from March
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs;


-- UNION ALL

-- Get jobs and companies from Jauary
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

--Get jobs and companies from February
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL

-- Get jobs and companies from March
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs;

/*
Practice Problem - UNION and UNION ALL
Get the corresponding skill and skill type for each job posting in q1
Includes those without any skills, too
Why? Look at the skills and the type for each job in the first quarter that 
has a salary > $70000
*/
WITH q1_postings AS (
    SELECT 
        job_id
    FROM
        january_jobs
    UNION ALL
    SELECT
        job_id
    FROM
        february_jobs
    UNION ALL
    SELECT
        job_id
    FROM
        march_jobs
)

SELECT 
    sd.skills,
    sd.type
FROM
    skills_dim AS sd
JOIN skills_job_dim AS sjd
    ON sd.skill_id = sjd.skill_id
JOIN q1_postings AS qp
    ON sjd.job_id = qp.job_id;

/*
Include those jobs without any skills, too
Do a LEFT JOIN in a specific order as INNNER JOIN can neutralize results of a LEFT JOIN
*/
WITH q1_postings AS (
    SELECT 
        job_id
    FROM
        january_jobs
    UNION ALL
    SELECT
        job_id
    FROM
        february_jobs
    UNION ALL
    SELECT
        job_id
    FROM
        march_jobs
)

SELECT
    sd.skills,
    sd.type,
    qp.job_id
FROM
    q1_postings AS qp
LEFT JOIN skills_job_dim AS sjd
    ON qp.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id;

/*
Look at the skills and the type for each job in the first quarter that 
has a salary > $70000
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
    sd.skills,
    sd.type,
    qp.salary_year_avg
FROM
    q1_postings AS qp
LEFT JOIN skills_job_dim AS sjd
    ON qp.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    qp.salary_year_avg > 70000;


