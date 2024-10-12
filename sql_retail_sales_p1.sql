-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p1;
-- Create table 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
transactions_id	INT PRIMARY KEY,
sale_date DATE,	
sale_time TIME,	
customer_id	INT,
gender VARCHAR(10),	
age INT,
category VARCHAR(20),	
quantiy	INT,
price_per_unit FLOAT,	
cogs FLOAT,	
total_sale FLOAT )

--Data Cleaning 
SELECT * FROM retail_sales 
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL
 
DELETE FROM retail_sales 
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL

-- Data Exploration 

--How many sales we have 
SELECT COUNT(*) AS total_sale FROM retail_sales

--How many customers do we have 
SELECT COUNT(DISTINCT customer_id) AS No_of_customers FROM retail_sales

--Data Analysis & Key  Business Problems 

--Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05'
ORDER BY sale_time 

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
SELECT  * FROM retail_sales
WHERE (category = 'Clothing') AND (quantiy >= 4) AND 
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'

--Write a SQL query to calculate the total sales (total_sale) for each category
SELECT category, SUM(total_sale) AS total_sale FROM retail_sales
GROUP BY category

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT ROUND(AVG(age),2) AS Average_age_of_customers FROM retail_sales
WHERE category = 'Beauty'

--Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT * FROM retail_sales 
WHERE total_sale > 1000

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT Gender, category, COUNT(transactions_id) FROM retail_sales
GROUP BY Gender, category

--Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year
SELECT year,month,Average_sale FROM 
(SELECT EXTRACT(YEAR FROM sale_date) AS Year, 
       EXTRACT(MONTH FROM sale_date) AS Month, 
	   ROUND(AVG(total_sale)) AS Average_sale,
	   RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY ROUND(AVG(total_sale)) DESC) as rn
	   FROM retail_sales
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)) AS x
WHERE x.rn = 1

--Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) AS total_sales FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5

--Write a SQL query to find the number of unique customers who purchased items from each category
SELECT category,COUNT(DISTINCT customer_id) AS no_of_unique_custs FROM retail_sales 
GROUP BY category

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sales AS
(SELECT *, 
      CASE 
	      WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
		  WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		  ELSE 'Evening'
		  END AS shift
FROM retail_sales)
SELECT shift,COUNT(shift) AS total_orders
FROM hourly_sales 
GROUP BY shift

--End of project