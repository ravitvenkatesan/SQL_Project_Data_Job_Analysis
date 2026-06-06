/*
Q5: What are the most optimal skills to learn
Meaning of Optimal: High Demand AND High Paying
NOTE: Arithmetic trick for Order By clause: count(job_id) * (avg(salary_year_avg)/1000)
*/
SELECT
    COUNT(jpf.job_id) AS skill_count,
    ROUND(AVG(jpf.salary_year_avg), 2) AS avg_salary,
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
GROUP BY
    sd.skill_id,
    sd.skills
HAVING
    COUNT(jpf.job_id) > 10
ORDER BY
    (COUNT(jpf.job_id) * (AVG(jpf.salary_year_avg) / 1000)) DESC
LIMIT 10;  

-- OPTION B - Using CTEs to find Optimal - high demand and high paying

WITH top_skills_by_demand AS (
    SELECT
    sd.skill_id,
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
),

top_skills_by_salary AS (
    SELECT
    sd.skill_id,
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
)

-- Join both above CTEs to get Optimal
SELECT
    top_skills_by_demand.skills,
    top_skills_by_demand.skill_count,
    top_skills_by_salary.avg_salary    
    FROM 
        top_skills_by_demand
    INNER JOIN top_skills_by_salary
        ON top_skills_by_demand.skill_id = top_skills_by_salary.skill_id
    ORDER BY
        top_skills_by_demand.skill_count DESC
    LIMIT 10;

