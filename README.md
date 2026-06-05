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
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst roles range from $124,000 to $650,000 showing a potential for high salaries in this field
- **Diverse Employers:** Companies like SmartAsset, Meta and AT&T are some of the companies offering high salaries with employers spanning a diverse array of industries.
- **Job Title Variety:** There's a diverse range of job titles, ranging from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics

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

