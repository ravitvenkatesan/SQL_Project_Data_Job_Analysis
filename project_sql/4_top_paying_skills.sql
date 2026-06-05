-- Q4: What are the top skills based on salary for my role
SELECT
    sd.skills,
    ROUND(AVG(jpf.salary_year_avg), 2) AS avg_salary
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
GROUP BY
    sd.skill_id,
    sd.skills
HAVING
    COUNT(jpf.job_id) > 10
ORDER BY
    avg_salary DESC
LIMIT 10;   

