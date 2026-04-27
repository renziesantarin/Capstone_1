-- Capstone 1: EmporiUm Sales Territory Analysis
-- Sales Manager: Lana Ilana
-- Territory: Florida
-- Region: South

-- Analysis by: Marenza Santarin
-- Date: April 27, 2026

USE sample_sales;

-- Find assigned sales territory for Lana Ilana
SELECT Region, RegionalDirector, State, SalesManager
FROM Management
WHERE SalesManager = 'Lana Ilana';

/* 1. What is total revenue overall for sales in the assigned
territory, plus the start date and end date that tell you 
what period the data covers? */

SELECT sl.State,
SUM(ss.Sale_Amount) AS Total_Revenue,
MIN(ss.Transaction_Date) AS Start_Date,
MAX(ss.Transaction_Date) AS End_Date
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Florida'
GROUP BY sl.state;

/* LOGIC: I only need sales from Florida. To do this, I use 
store_sales for the sales amounts and dates, and joined it to 
store_locations to filter for Florida. */

/* 2. What is the month by month revenue breakdown for the 
sales territory? */

SELECT DATE_FORMAT(ss.Transaction_Date, '%Y-%m') AS Sales_Month,
SUM(ss.Sale_Amount) AS Monthly_Revenue
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreID
WHERE sl.State = 'Florida'
GROUP BY DATE_FORMAT(ss.Transaction_Date, '%Y-%m')
ORDER BY Sales_Month;

/* LOGIC: I'm still filtering for Florida, but now I want to
group the sales by month to see the revenue trends over time. */


/* 3. Provide a comparison of total revenue for the specific 
sales territory and the region it belongs to. */

SELECT m.Region, sl.State,
SUM(ss.Sale_Amount) AS Total_Revenue
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreID
JOIN management m ON sl.State = m.State
WHERE m.Region = 'South'
GROUP BY m.Region, sl.State
ORDER BY Total_Revenue DESC;

/* LOGIC: Florida is in the South region. This query compares 
Florida’s revenue with other states in that region. */

/* 4. 