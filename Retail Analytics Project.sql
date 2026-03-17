CREATE DATABASE RetailAnalyticsDB;
USE RetailAnalyticsDB;

CREATE TABLE Retail_Transactions (
    row_id INT,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(20),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(200),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(10,2)
);

ALTER TABLE Retail_Transactions
MODIFY order_date VARCHAR(20),
MODIFY ship_date VARCHAR(20);

SELECT COUNT(*) FROM Retail_Transactions;
SELECT COUNT(*) AS total_rows 
FROM Retail_Transactions;

-- Business Question 1:
-- Calculate total revenue and total profit. -- Source Table: Retail_Transactions. -- Columns Used: sales, profit
SELECT 
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM Retail_Transactions;

-- Business Question 2:
-- Calculate overall profit margin percentage. -- Formula: (Total Profit / Total Sales) * 100. -- Source Table: Retail_Transactions
SELECT 
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_percentage
FROM Retail_Transactions;

-- Business Question 3:
-- Calculate total sales and total profit for each product category. -- Source Table: Retail_Transactions. -- Columns Used: category, sales, profit
SELECT 
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM Retail_Transactions
GROUP BY category
ORDER BY total_sales DESC;

-- Business Question 4:
-- Calculate profit margin percentage for each category. -- Formula: (Total Profit / Total Sales) * 100. -- Source Table: Retail_Transactions
SELECT 
    category,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_percentage
FROM Retail_Transactions
GROUP BY category
ORDER BY profit_margin_percentage DESC;

-- Business Question 5:
-- Calculate total sales and total profit by region. -- Source Table: Retail_Transactions. -- Columns Used: region, sales, profit
SELECT 
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM Retail_Transactions
GROUP BY region
ORDER BY total_sales DESC;

-- Business Question 6:
-- Calculate profit margin percentage by region. -- Formula: (Total Profit / Total Sales) * 100. -- Source Table: Retail_Transactions
SELECT 
    region,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_percentage
FROM Retail_Transactions
GROUP BY region
ORDER BY profit_margin_percentage DESC;

-- Business Question 7:
-- Calculate total sales, total profit and profit margin. -- for each Category within each Region. -- Source Table: Retail_Transactions
SELECT 
    region,
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_percentage
FROM Retail_Transactions
GROUP BY region, category
ORDER BY region, profit_margin_percentage DESC;

-- Business Question 8:
-- Identify top 10 most profitable products. -- Objective: Determine which products contribute most to total profit. -- Source Table: Retail_Transactions
SELECT 
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM Retail_Transactions
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;

SELECT 
    product_name,
	ROUND(SUM(profit), 2) AS total_profit
FROM Retail_Transactions
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 5;

-- Business Question 9:
-- Identify top 10 loss-making products. -- Objective: Determine which products are generating negative total profit. 
SELECT 
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM Retail_Transactions
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC
LIMIT 10;

-- Business Question 10:
-- Check average profit at different discount levels. -- Objective : Check whether higher discount leads to lower profit.
SELECT 
    discount,
    ROUND(AVG(profit), 2) AS average_profit
FROM Retail_Transactions
GROUP BY discount
ORDER BY discount;

-- Business Question 11:
-- Calculate total sales and total profit by customer segment. -- Objective: Identify most profitable segment
SELECT 
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM Retail_Transactions
GROUP BY segment
ORDER BY total_profit DESC;

-- Business Question 12:
-- Calculate total sales year-wise. -- Objective: Analyze yearly business growth
SELECT 
    YEAR(order_date) AS order_year,
    ROUND(SUM(sales), 2) AS total_sales
FROM Retail_Transactions
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Convert VARCHAR to DATE
SET SQL_SAFE_UPDATES = 0; -- Step 1: Disable Safe Update 
UPDATE Retail_Transactions -- Step 2: Convert VARCHAR to Proper DATE
SET order_date = STR_TO_DATE(order_date, '%m/%d/%Y');
ALTER TABLE Retail_Transactions -- Step 3: Change Column Type to DATE
MODIFY order_date DATE;

SET SQL_SAFE_UPDATES = 1; -- Step 4 : Able Safe Update 

-- Business Question 13:
-- Calculate percentage contribution of each category to total sales
SELECT 
    category,
    ROUND((SUM(sales) / 
          (SELECT SUM(sales) FROM Retail_Transactions)) * 100, 2) 
    AS sales_percentage
FROM Retail_Transactions
GROUP BY category
ORDER BY sales_percentage DESC;

-- Business Question 14:
-- Count total unique customers
SELECT 
    COUNT(DISTINCT customer_id) AS total_unique_customers
FROM Retail_Transactions;

-- Business Question 15:
-- Calculate average shipping time in days
-- Source Table: Retail_Transactions

SELECT 
    ROUND(AVG(DATEDIFF(ship_date, order_date)), 2) 
    AS avg_shipping_days
FROM Retail_Transactions;

-- Business Question 16:
-- Calculate year-over-year sales growth
SELECT 
    t1.order_year,
    ROUND(((t1.total_sales - t2.total_sales) / t2.total_sales) * 100, 2) 
    AS growth_percentage
FROM 
    (SELECT YEAR(order_date) AS order_year,
            SUM(sales) AS total_sales
     FROM Retail_Transactions
     GROUP BY YEAR(order_date)) t1
JOIN 
    (SELECT YEAR(order_date) AS order_year,
            SUM(sales) AS total_sales
     FROM Retail_Transactions
     GROUP BY YEAR(order_date)) t2
ON t1.order_year = t2.order_year + 1;

-- Business Question 17:
-- Count number of loss-making orders
SELECT 
    SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) 
    AS loss_orders
FROM Retail_Transactions;

-- Business Question 18:
-- Find orders where discount > 0.30 but profit is still positive.
SELECT 
    order_id,
    discount,
    profit
FROM Retail_Transactions
WHERE discount > 0.30 
AND profit > 0
ORDER BY discount DESC;

-- Create a Profit Category (Using CASE)
SELECT 
    order_id,
    profit,
    CASE
        WHEN profit > 0 THEN 'Profitable'
        WHEN profit = 0 THEN 'Break Even'
        ELSE 'Loss'
    END AS profit_status
FROM Retail_Transactions;

-- Top Customers by Revenue. This identifies high-value customers.
SELECT 
    customer_name,
    ROUND(SUM(sales),2) AS total_sales
FROM Retail_Transactions
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- This shows product demand analysis. Companies use this for inventory decisions.
SELECT 
    product_name,
    SUM(quantity) AS total_quantity
FROM Retail_Transactions
GROUP BY product_name
ORDER BY total_quantity DESC
LIMIT 10;

