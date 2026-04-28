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

/* 4. What is the number of transactions per month and average 
transaction size by product category for the sales territory? */

SELECT DATE_FORMAT(ss.Transaction_Date, '%Y-%m') AS Sales_Month,
ic.Category,
COUNT(*) AS Total_Transactions,
AVG(ss.Sale_Amount) AS Average_Transaction_Size,
SUM(ss.Sale_Amount) AS Total_Revenue
FROM store_sales ss
JOIN store_locations sl ON ss.Store_ID = sl.StoreID
JOIN Products p ON ss.Prod_Num = p.ProdNum
JOIN inventory_categories ic ON p.Categoryid = ic.Categoryid
WHERE sl.State = 'Florida'
GROUP BY DATE_FORMAT(ss.Transaction_Date, '%Y-%m'), ic.Category
ORDER BY Sales_Month, Total_Revenue DESC;

/* LOGIC: I need to find the month, category, number of 
transactions, and the average transaction size. The store_sales 
table has store ID and sales amount. It also has the product 
number, which helps link sales to specific products. 
The products table provides the category information. I grouped 
the data by month and category. Then, I sorted the results 
from highest to lowest to rank the categories.*/

/* 5. Can you provide a ranking of in-store sales performance 
by each store in the sales territory, or a ranking of online 
sales performance by state within an online sales territory? */

SELECT sl.StoreLocation AS Store_City,
sl.StoreId AS Store_ID,
SUM(ss.Sale_Amount) AS Total_Revenue,
COUNT(*) AS Total_Transactions,
AVG(ss.Sale_Amount) AS Average_Transaction_Size
FROM Store_Sales ss
JOIN Store_Locations sl ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Florida'
GROUP BY sl.StoreLocation, sl.StoreId
ORDER BY total_revenue DESC;

/* LOGIC: Since Lana manages Florida, I filtered it again to only
include Florida stores. I started with the store_sales table
because it has the transaction data, like the value of each sale
and the store responsible for it. I summed the revenue to measure
performance. I then grouped them by store and sorted by total
revenue from highest to lowest to rank the store performance. */
