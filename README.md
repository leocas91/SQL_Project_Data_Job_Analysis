# Introduction
📊 Dive into the data job market! Focusing on business analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [project_sql folder](/project_sql/)

# Background
Driven by a quest to navigate the business analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

Data hails from [Luke Barousse's Course](https://www.lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential skills.

The questions I wanted to answer through my SQL queries were:
What are the top-paying business analyst jobs?
What skills are required for these top-paying jobs?
What skills are most in demand for business analysts?
Which skills are associated with higher salaries?
What are the most optimal skills to learn?

# Tools I used
For my deep dive into the business analyst job market, I harnessed the power of several key tools:

- **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code**: My go-to for database management and executing SQL queries.
- **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the business analyst job market. Here’s how I approached each question:

### 1. Top Paying Business Analyst Jobs
To identify the highest-paying roles, I filtered business analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as company_name
FROM 
job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Business Analyst' AND 
    job_location= 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

Some insights:

***1.	Top Salaries in Remote Work:***
The top full-remote job is “Lead Business Intelligence Engineer” at $220,000/year (Noom), with “Manager II, Applied Science - Marketplace Dynamics” (Uber, $214,500) following closely.

***2.	Prevalence of Leadership and Senior Roles:***
Many of the top roles, such as “Staff Revenue Operations Analyst” (Gladly, $170,500) and “REMOTE - Business Intelligence Analyst (Leadership Role)” (CyberCoders, $162,500), focus on leadership or specialized expertise.

***3.	Strong Demand for Flexibility and High Compensation:***
Filtering for remote jobs showcases competitive salaries, reflecting the increasing willingness of companies to pay premium rates for talent in flexible, full-remote setups.

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS (
SELECT
    job_id,
    job_title,
    salary_year_avg,
    name as company_name
FROM 
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Business Analyst' AND 
    job_location= 'Anywhere' AND
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
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY 
    salary_year_avg DESC;
```

Here are the insights from the “skills” column:
- 	SQL and Python are the most in-demand, appearing 5 times each.
- Excel and Tableau are also highly sought, with 4 mentions each.

### 3. In-Demand Skills for Business Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Business Analyst'
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY 
    demand_count DESC
LIMIT 5;
```

Here's the breakdown of the most demanded skills for data analysts in 2023:

- SQL and Excel remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- Programming and Visualization Tools like Python, Tableau, and Power BI are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT 
    skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Business Analyst' AND
    job_postings_fact.salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY 
    avg_salary DESC
LIMIT 25;
```

Insights into Top-Paying Skills for Business Analysts:

***1.	High Demand for Automation and Advanced BI Tools:***
Skills like Chef ($220K) and Looker ($130.4K) are highly compensated, showcasing the premium on automation and business intelligence capabilities.

***2.	Cloud and Data-Centric Technologies Lead:***
Expertise in GCP ($115.8K), BigQuery ($115.8K), and Snowflake ($114.5K) reflects the growing need for managing and analyzing large datasets on cloud platforms.

***3.	Diverse Tech Skills Add Value:***
Niche skills like Phoenix ($135.9K) and R ($114.6K) show that both general programming and specialized frameworks can drive earning potential.

| Skills  | Avg_salary |
|---------|------------|
|chef     | 220000     |
|phoenix  | 135990     |
|looker   | 130400     |
|mongodb  | 120000     |
|python   | 116516     |
|bigquery | 115833     |
|gcp      | 115833     |
|r        | 114629     |
|snowflake| 114500     |

*Table of the average salary for the top 9 paying skills for business analysts*

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
WITH skills_demand as (
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Business Analyst' AND
    job_work_from_home = TRUE AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
), average_salary AS (
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Business Analyst' AND
    job_postings_fact.salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    skills_demand.demand_count,
    average_salary.avg_salary
FROM
skills_demand
INNER JOIN average_salary ON average_salary.skill_id = skills_demand.skill_id
WHERE
    demand_count>7
ORDER BY avg_salary DESC, demand_count DESC
LIMIT 25;
```

|skill_id|skills	|demand_count	|avg_salary|
|--------|----------|---------------|----------|
|1	     |python	|20	            |116516    |
|5	     |r	        |8	            |114629    |
|182	 |tableau	|27	            |104233    |
|0	     |sql	    |42	            |99120     |
|181	 |excel	    |31	            |94132     |
|183	 |power bi	|12	            |90448     |

*Table of the most optimal skills for business analyst sorted by salary*

***1.	SQL and Excel Dominate Demand:***
- SQL leads with a demand count of 42, highlighting its essential role in business analysis and data management.
- Excel follows with 31, underscoring its continued relevance for data analysis and reporting tasks.

***2.	Higher Pay Correlates with Specialized Skills:***
- Python tops the average salary at $116,516, reflecting its versatility and value in data science, automation, and analytics.
- R ($114,629) and Power BI ($90,448) also show strong salary potential, suggesting that knowledge of specific tools for statistical analysis and visualization is highly compensated.

***3.	Visualization Skills Are Highly Demanded:***
- Tableau ranks second in demand with 27, demonstrating the importance of creating interactive visualizations for business intelligence.

# What I Learned
Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- 🧩 ***Complex Query Crafting:*** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- 📊 ***Data Aggregation:*** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- 💡 ***Analytical Wizardry:*** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusions
This project enhanced my SQL skills and provided valuable insights into the business analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring business analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.

# Credits
Luke Barousse's [Course](https://www.lukebarousse.com/sql).