# Introduction
The data job market runs hot! This project is a barometer for top paying jobs, sought after skills and the point where high demand meets high salary in the field of data analytics, with a focus on Data Analyst roles.

SQL Queries: Check it out here: [project_sql folder](/project_sql)

# Background
To find a better way to navigate the data analyst job market, this project aims to focus on top paid and in-demand skills to optimize the job finding process.

Data is taken from Luke's [SQL Course](https://lukebarousse.com/sql). The data set is a rich collection of job titles salaries, locations and essential skills.

### The questions being answered through these SQL queries are:

1. What are the top paying analyst jobs?
2. What skills are required for these top paying jobs?
3. What are the most in demand skills for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
I used several powerful tools to do a deep dive into the data analyst job market.

- **SQL**: The backbone of the analysis, allowing me to query the database and unearth critical insights
- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data
- **Visual Studio Code**: My go-to for database management and executing SQL queries
- **Git & Github**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking

# The Analysis

### 1. Top Paying Data Analyst Jobs

To identify the highest paying roles, I filtered the data analyst positions by average yearly salary and location focusing on remote jobs. This query highlights the high paying jobs in the remote field.

```sql
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
```
```
| job_title                                       | salary_year_avg | company_name                            |
|-------------------------------------------------|-----------------|-----------------------------------------|
| Data Analyst                                    | 650000.0        | Mantys                                  |
| Director of Analytics                           | 336500.0        | Meta                                    |
| Associate Director- Data Insights               | 255829.5        | AT&T                                    |
| Data Analyst, Marketing                         | 232423.0        | Pinterest Job Advertisements            |
| Data Analyst (Hybrid/Remote)                    | 217000.0        | Uclahealthcareers                       |
| Principal Data Analyst (Remote)                 | 205000.0        | SmartAsset                              |
| Director, Data Analyst - HYBRID                 | 189309.0        | Inclusively                             |
| Principal Data Analyst, AV Performance Analysis | 189000.0        | Motional                                |
| Principal Data Analyst                          | 186000.0        | SmartAsset                              |
| ERM Data Analyst                                | 184000.0        | Get It Recruit - Information Technology |
```


Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst roles range from $124,000 to $650,000 showing a potential for high salaries in this field
- **Diverse Employers:** Companies like SmartAsset, Meta and AT&T are some of the companies offering high salaries with employers spanning a diverse array of industries.
- **Job Title Variety:** There's a diverse range of job titles, ranging from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics

### 2. Skills for Top Paying Jobs

To get the skills required for top paying jobs, I joined the job postings table with the skills data, revealing what employers look for in high salary roles.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_work_from_home = True AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
INNER JOIN skills_job_dim
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```
- SQL is clearly the leader 
- It is followed by Python 


```
| job_title                         | salary_year_avg | skills     |
|-----------------------------------|-----------------|------------|
| Associate Director- Data Insights | 255829.5        | sql        |
| Associate Director- Data Insights | 255829.5        | python     |
| Associate Director- Data Insights | 255829.5        | r          |
| Associate Director- Data Insights | 255829.5        | azure      |
| Associate Director- Data Insights | 255829.5        | databricks |
| Associate Director- Data Insights | 255829.5        | aws        |
| Associate Director- Data Insights | 255829.5        | pandas     |
| Associate Director- Data Insights | 255829.5        | pyspark    |
| Associate Director- Data Insights | 255829.5        | jupyter    |
| Associate Director- Data Insights | 255829.5        | excel      |

```

### 3.Top Demand Skills for Data Analysts

This query identifies the most required skills in job postings, giving a good idea of areas of demand.

```sql
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
```
- SQL, Excel and occupy the top 2 spots
- Programming skills in Python and Data Visualization tools like Tableau, R and Power BI show the demand for technical skills and data story telling skills
```
| skills  | skill_count |
|---------|-------------|
| sql     | 3083        |
| excel   | 2143        |
| python  | 1840        |
| tableau | 1659        |
| r       | 1073        |
```

### 4.Top Skills Based On Salary
This gives the average salaries of various skills and gives us a glimpse of highest paying ones.

```sql
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
```
- **Big Data & ML Skills are Toppers**: Data analysts with Big Data skills and Machine Learning technologies earn the highest. This shows the industry's recognition of predictive modeling and mega amounts of data processing.

- **Software Development & Deploment**: There is a trend of crossover between data analysis and data engineering, with automation and data pipeline build and management gaining recognition.

- **Cloud Computing Skills**: They have their place in the top order of skills,indicating growth of cloud analytics environments and cloud analytics processing.

```
| skills     | avg_salary |
|------------|------------|
| kafka      | 129999.16  |
| pytorch    | 125226.20  |
| perl       | 124685.75  |
| tensorflow | 120646.83  |
| cassandra  | 118406.68  |
| atlassian  | 117965.60  |
| airflow    | 116387.26  |
| scala      | 115479.53  |
| linux      | 114883.20  |
| confluence | 114153.12  |
```

### 5. Most optimal skills to learn
Meaning of Optimal: High Demand AND High Paying

This gives a great idea of the high demand skills, accompanied by high salaries. This gives any aspiring data analyst the idea to develop a critical skill set.

```sql
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
```
```
| skills     | skill_count | avg_salary |
|------------|-------------|------------|
| sql        | 3083        | 96435.33   |
| excel      | 2143        | 86418.90   |
| python     | 1840        | 101511.85  |
| tableau    | 1659        | 97978.08   |
| r          | 1073        | 98707.80   |
| power bi   | 1044        | 92323.60   |
| word       | 527         | 82940.76   |
| powerpoint | 524         | 88315.61   |
| sas        | 500         | 93707.36   |
```
- **High Demand Programming Languages**: Python and R still rank at the top with decent salaries. Their popularity ensures a large pool of talent is also available for them.

- **Data Visualization & BI Tools**: Tableau and Power BI feature prominently with solid salaries. This highlights the importance of data visualization and story telling.

# What I Learned
Throughout this exercise, I have exploited the power of SQL to the hilt:

- **Complex Query Crafting**: Well versed with the art of advanced SQL, merging tables and utilizing CTEs' WITH clauses for temp table manipulations
- **Data Aggregation:** Comfortable with using GROUP BY and summarizing data with powerful functions like COUNT() and AVG()
- **Analytical Skills Sharpening** Gained expertise in real-world problem-solving skills, turning questions into actionable, insightful SQL queries

# Conclusions
From the analysis, several general insights emerged:

1. **Top Paying Data Analyst Jobs**: The highest paying jobs for data analysts are spread over a wide range, the highest on offer being $650,000
2. **Skills for Top Paying Jobs**: High paying data analyst jobs demand highest SQL skills showing it is a critical skill needed for earning high salary
3. **Most In-Demand Skills**: SQL is the most demanded skill in the data analyst job sector making it an essential skill for job seekers
4. **Skills with Higher Salaries**: Specialized skills such as Kafka and PyTorch are also in demand showing the earning power of niche skills
5. **Optimal Skills for Job Market Value**: SQL leads the skills list in terms of higher earning potential and optimal skills to possess for data analysts to maximize their market value

