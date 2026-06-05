/*
Query 2:
2)What are the skills required for these top paying roles?
*/

SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    sd.skills
FROM
    job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Analyst' AND
    jpf.salary_year_avg IS NOT NULL AND
    sd.skills IS NOT NULL
ORDER BY
    jpf.salary_year_avg DESC
LIMIT 10;

