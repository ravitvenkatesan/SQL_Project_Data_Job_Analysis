--Q3: What are the most in-demand skills for my role?
SELECT
    sd.skills,
    COUNT(jpf.job_id) AS skill_count
FROM
    job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim as sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Analyst' AND
    jpf.salary_year_avg IS NOT NULL AND
    sd.skills IS NOT NULL
GROUP BY
    sd.skill_id,
    sd.skills
ORDER BY
    COUNT(jpf.job_id) DESC
LIMIT 5;
