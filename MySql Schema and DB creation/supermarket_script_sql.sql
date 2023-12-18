LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Dataset_Sql_members.csv'
INTO TABLE sales_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Skip header row if present

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Dataset_Sql_products.csv'
INTO TABLE sales_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Skip header row if present

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Dataset_Sql_sales.csv'
INTO TABLE sales_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Skip header row if present

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Dataset_Sql_demographics.csv'
INTO TABLE sales_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Skip header row if present

SELECT
loyalty_card_number, SUM(quantity_sold), SUM(total_sales) AS total_sales
FROM
sales_data
GROUP BY 
loyalty_card_number
ORDER BY 
total_sales 
DESC;

SELECT  
lifestage as Life_Stage, COUNT(loyalty_card_number) as COUNT
FROM 
members
GROUP BY 
Life_Stage
ORDER BY 
COUNT 
DESC;

SELECT  
affluence as Affluence, COUNT(loyalty_card_number) as COUNT
FROM 
members
GROUP BY 
Affluence
ORDER BY 
COUNT 
DESC;

SELECT 
SD.store_number, S.city, S.state, SUM(SD.total_sales) AS Total_Sales, COUNT(M.loyalty_card_number) AS Total_Customers 
FROM 
sales_data AS SD
LEFT JOIN 
stores as S ON SD.store_number = S.store_number
LEFT JOIN 
members AS M ON SD.loyalty_card_number = M.loyalty_card_number 
GROUP BY 
SD.store_number 
ORDER BY 
Total_Sales
DESC;

SELECT 
SD.store_number as Store_Number, 
MAX(SD.date_sold) AS Current_Sales_Month,
SUM(SD.total_sales) as Total_Sales
FROM 
sales_data AS SD
GROUP BY 
SD.store_number
ORDER BY 
Total_Sales DESC;

DELIMITER //
CREATE PROCEDURE last_month_sales (IN store_number INTEGER)
BEGIN 
SELECT 
SD.store_number as Store_Number, 
MAX(SD.date_sold) AS Current_Sales_Date,
SUM(SD.total_sales) as Total_Sales
FROM 
sales_data AS SD
WHERE 
SD.store_number = store_number
GROUP BY 
SD.store_number
ORDER BY 
Total_Sales DESC;
END //
DELIMITER ;

CALL last_month_sales(27);

DELIMITER //
CREATE PROCEDURE store_sales_brand (IN Store_Number INTEGER)
BEGIN 
SELECT 
P.brand_name AS Brand, 
SUM(SD.total_sales) as Total_Sales
FROM 
products AS P
LEFT JOIN 
sales_data AS SD ON P.product_number = SD.product_number
WHERE SD.store_number = Store_Number
GROUP BY P.brand_name
ORDER BY Total_Sales DESC;
END //
DELIMITER ;

CALL store_sales_brand(27)