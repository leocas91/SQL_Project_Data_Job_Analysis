/*
Answer: what are the top skills based on salary?
- Look at the average salary associated with each skill for Business Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Business Analysts and
    helps indentify the most financially rewarding skills to acquire or improve
*/

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


/*
	1.	Specialized Tools and Frameworks Dominate: High salaries are tied to niche expertise in tools like Chef ($220K), Numpy ($157.5K), and Airflow ($135.4K), reflecting demand for automation, workflow orchestration, and data manipulation.
	2.	Machine Learning and Data Science Lead: Libraries like Pytorch ($120.3K), TensorFlow ($120.3K), and Scikit-learn ($120K) highlight the premium on advanced analytics and AI expertise.
	3.	Cloud and Big Data Skills Command Premiums: Technologies such as Hadoop ($139.2K), Snowflake ($112.5K), and NoSQL ($119.3K) underscore the importance of scalable, modern data management in driving business insights.

[
  {
    "skills": "chef",
    "avg_salary": "220000"
  },
  {
    "skills": "numpy",
    "avg_salary": "157500"
  },
  {
    "skills": "ruby",
    "avg_salary": "150000"
  },
  {
    "skills": "hadoop",
    "avg_salary": "139201"
  },
  {
    "skills": "julia",
    "avg_salary": "136100"
  },
  {
    "skills": "airflow",
    "avg_salary": "135410"
  },
  {
    "skills": "phoenix",
    "avg_salary": "135248"
  },
  {
    "skills": "electron",
    "avg_salary": "131000"
  },
  {
    "skills": "c",
    "avg_salary": "123329"
  },
  {
    "skills": "pytorch",
    "avg_salary": "120333"
  },
  {
    "skills": "tensorflow",
    "avg_salary": "120333"
  },
  {
    "skills": "seaborn",
    "avg_salary": "120000"
  },
  {
    "skills": "matlab",
    "avg_salary": "120000"
  },
  {
    "skills": "matplotlib",
    "avg_salary": "120000"
  },
  {
    "skills": "scikit-learn",
    "avg_salary": "120000"
  },
  {
    "skills": "nosql",
    "avg_salary": "119330"
  },
  {
    "skills": "mongodb",
    "avg_salary": "118667"
  },
  {
    "skills": "snowflake",
    "avg_salary": "112543"
  },
  {
    "skills": "looker",
    "avg_salary": "110581"
  },
  {
    "skills": "pandas",
    "avg_salary": "110558"
  },
  {
    "skills": "node.js",
    "avg_salary": "110000"
  },
  {
    "skills": "elasticsearch",
    "avg_salary": "110000"
  },
  {
    "skills": "mxnet",
    "avg_salary": "110000"
  },
  {
    "skills": "chainer",
    "avg_salary": "110000"
  },
  {
    "skills": "cassandra",
    "avg_salary": "108488"
  }
]

*/