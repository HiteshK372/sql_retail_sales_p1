# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `sql_project_p1`

The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project_p1;
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings


1. **Query to retrieve all columns for sales made on '2022-11-05**:

SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05'
ORDER BY sale_time 

2. **Query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**

SELECT  * FROM retail_sales
WHERE (category = 'Clothing') AND (quantiy >= 4) AND 
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'

3. **Query to calculate the total sales (total_sale) for each category.**

SELECT category, SUM(total_sale) AS total_sale FROM retail_sales
GROUP BY category

4. **Query to find the average age of customers who purchased items from the 'Beauty' category.**

SELECT ROUND(AVG(age),2) AS Average_age_of_customers FROM retail_sales
WHERE category = 'Beauty'

5. **Query to find all transactions where the total_sale is greater than 1000.**

SELECT * FROM retail_sales 
WHERE total_sale > 1000

6. **Query to find the total number of transactions (transaction_id) made by each gender in each category.**

SELECT Gender, category, COUNT(transactions_id) FROM retail_sales
GROUP BY Gender, category

7. **Query to calculate the average sale for each month. Find out best selling month in each year**

SELECT year,month,Average_sale FROM 
(SELECT EXTRACT(YEAR FROM sale_date) AS Year, 
       EXTRACT(MONTH FROM sale_date) AS Month, 
	   ROUND(AVG(total_sale)) AS Average_sale,
	   RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY ROUND(AVG(total_sale)) DESC) as rn
	   FROM retail_sales
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)) AS x
WHERE x.rn = 1

8. **Query to find the top 5 customers based on the highest total sales **
SELECT customer_id, SUM(total_sale) AS total_sales FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5


9. **Query to find the number of unique customers who purchased items from each category.**
SELECT category,COUNT(DISTINCT customer_id) AS no_of_unique_custs FROM retail_sales 
GROUP BY category

10. **Query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**
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

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.
