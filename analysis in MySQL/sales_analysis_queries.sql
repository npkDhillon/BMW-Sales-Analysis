-- We have 5 tables in our database
USE BMW_sales;


-- ==============================================================================================================================================================================
-- 														Section 1: Financial Performance & Market Value
-- ==============================================================================================================================================================================


-- Question: What are the absolute highest and lowest price points in the BMW portfolio?
(SELECT Model, Launch_Year, Engine_Size_L, Mileage_KM, Price_USD
FROM cars_info
ORDER BY Price_USD
LIMIT 1)
UNION ALL
(SELECT Model, Launch_Year, Engine_Size_L, Mileage_KM, Price_USD
FROM cars_info
ORDER BY Price_USD DESC
LIMIT 1);
-- Result: 
-- Cheapest car is Model i8 launched in 2013 worth 30,000.00 USD
-- Most expensive car is also Model i8 launched in 2010 worth 119,998.00 USD 


-- Question: Which 10 specific vehicles represent the "Flagship" (highest price) models in the current BMW inventory?
SELECT Model, Launch_Year, Price_USD, Mileage_KM FROM cars_info
ORDER BY Price_USD DESC
LIMIT 10;
-- Result: The flagship tier of the BMW inventory is exceptionally consistent, with the top 10 models all priced at the $120,000 threshold (specifically $119,986–$119,998).
-- Interestingly, models like the i8 and X6 appear multiple times across different launch years (2010–2024), suggesting these specific models consistently hold the highest value in the portfolio regardless of age.


-- Question: Which specific models are priced above the global average?
-- Essential for identifying the "Premium" segment within the already luxury BMW brand.
SELECT Model, Launch_year, Engine_size_L
FROM Cars_info
WHERE Price_USD > (SELECT AVG(Price_USD) FROM cars_info);

-- Count of models that are priced above the global average 
SELECT COUNT(Model)
FROM Cars_info
WHERE Price_USD > (SELECT AVG(Price_USD) FROM cars_info);
-- Result: Found 24,989 cars priced above the average.


-- Question: Which geographic regions does BMW operate in for car sales?
SELECT DISTINCT Region FROM sales;
-- Result: BMW sells cars in 6 major regions worldwide: Asia, North America, South America, Europe, Middle East, Africa.


-- Question: How is total revenue distributed across these regions, and is there geographic balance in performance?
SELECT s.Region, SUM(s.sales_volume * c.Price_USD) AS Revenue
FROM sales s 
JOIN cars_info c ON s.car_id = c.car_id
GROUP BY REGION
ORDER BY Revenue DESC;
-- Result: Total revenue is almost the same across all regions (near-equal contribution from each).


-- Question: What is each region's percentage contribution to BMW's total company revenue, and how evenly is revenue distributed geographically?
WITH region_revenue AS (
SELECT s.Region,
-- Calculating region-wise revenue
SUM(c.Price_USD * s.Sales_Volume) AS revenue
FROM cars_info c
JOIN sales s ON c.car_id = s.car_id
GROUP BY s.Region
)
SELECT Region,
-- Calculating the percentage of contribution of each region in revenue
revenue / (SUM(revenue) OVER()) * 100 AS revenue_contri_prcnt
FROM region_revenue
ORDER BY revenue_contri_prcnt;
-- Result: Total revenue is almost equally distributed across all 6 regions (each approximately 16%).


-- Question: Which global region generates the highest revenue per unit sold?
SELECT s.Region, 
ROUND((SUM(c.price_USD * s.sales_volume) / SUM(s.sales_volume)), 2)  AS revenue_per_vehicle
FROM sales s
JOIN cars_info c ON s.car_id = c.car_id
GROUP BY s.Region
ORDER BY revenue_per_vehicle DESC;
-- Result: Asia leads in revenue per vehicle, though the margin between all regions is remarkably slim.


/*
Insights from this section:
This analysis reveals that BMW maintains a highly balanced global revenue stream, with no single region dominating the income. 
By identifying the "Price Ceiling" (Flagship models capped at approximately $120,000), we can see that BMW has a very disciplined pricing strategy. 
The consistency in "Revenue per Vehicle" across all regions proves that BMW is successfully positioned as a premium luxury brand worldwide, maintaining high profit margins regardless of the local currency or market size.
*/



-- ==============================================================================================================================================================================
-- 														Section 2: Product Engineering & Specification Analysis
-- ==============================================================================================================================================================================


-- Question: Does the transmission type (Automatic vs. Manual) significantly impact the average sales price?
SELECT t.Transmission, ROUND(AVG(c.Price_USD), 2) AS avg_price
FROM cars_info c 
JOIN Transmission_info t ON c.Transmission_id = t.transmission_id
GROUP BY t.transmission;
-- Result: Pricing is remarkably stable (near $75k) regardless of transmission.


-- Question: How can we classify the fleet into "Small," "Standard," and "Large" engine categories for easier reporting?
SELECT Model, Engine_size_L,
CASE 
WHEN Engine_size_L < 2.0 THEN 'Small'
WHEN Engine_size_L BETWEEN 2.0 AND 4.0 THEN 'Standard'
WHEN Engine_size_L > 4.0 THEN 'Large'
END AS Engine_Class
FROM cars_info;


-- Question: What is the average engine size (in liters) for high-volume BMW models, segmented by fuel type?
-- Specifically, we focus only on models/cars that have achieved strong sales performance (sales volume > 5,000 units) to understand engine characteristics of popular vehicles.
SELECT ROUND(AVG(c.Engine_size_L), 2) AS Avg_engine_size, f.Fuel_type
FROM cars_info c 
JOIN fuel_types_info f ON c.fuel_type_id = f.fuel_type_id
JOIN sales s ON c.car_id = s.car_id
WHERE s.sales_volume > 5000
GROUP BY f.fuel_type;
-- Result: The average engine size remains virtually identical at approximately 3.20 liters across all fuel types.


-- Question: Which fuel type commands the highest average selling price?
SELECT f.Fuel_type, ROUND(AVG(c.Price_USD), 2) AS avg_price_USD
FROM cars_info c 
JOIN fuel_types_info f ON c.Fuel_type_id = f.Fuel_type_id
GROUP BY f.Fuel_type
ORDER BY avg_price_USD
LIMIT 1;
-- Result: Hybrid fuel type generates highest average selling price - 74,797.55 USD


-- Question: What were the core technical specifications (Model, Fuel Type, and Engine Size) for the vehicles launched in the 2022 year?
SELECT c.model, f.fuel_type, c.Engine_size_L
FROM cars_info c
JOIN fuel_types_info f ON c.Fuel_type_id = f.Fuel_type_id
WHERE c.Launch_Year = 2022;
-- Result: A detailed list showing that 2022 featured a diverse mix of engine sizes and fuel technologies across the BMW model range.


-- Question: What is the age of each vehicle model in the current inventory, and how is the fleet distributed from oldest to newest?
SELECT Model, Launch_year, 
(EXTRACT(YEAR FROM CURRENT_DATE()) - Launch_year) AS Age_in_years
FROM cars_info
ORDER BY Age_in_years DESC;

-- Minimum and Maximum age of car
SELECT 
    MIN(EXTRACT(YEAR FROM CURRENT_DATE()) - Launch_year) AS min_age,
    MAX(EXTRACT(YEAR FROM CURRENT_DATE()) - Launch_year) AS max_age
FROM cars_info;

-- Result: The BMW fleet shows a healthy diversity in age, with models ranging from 2 to 16 years old. 


/*
Insights from this section:
The data highlights a "Standardized Engineering" philosophy. Despite offering a wide range of models, the average engine size remains remarkably stable at 3.2L, even when switching between fuel types like Petrol and Hybrid. This suggests that BMW prioritizes a consistent "performance feel" across its entire lineup. The data also shows that Hybrid cars are the most expensive, costing about $74,798 on average. Interestingly, whether a car has a Manual or Automatic transmission doesn't change the price; both types cost around $75,000. Additionally, the 16-year age spread of the fleet shows a healthy balance between "Legacy" models that maintain brand heritage and "Modern" entries that introduce new technologies.
*/



-- ==============================================================================================================================================================================
-- 															Section 3: Sales Volume & Consumer Behavior
-- ==============================================================================================================================================================================


-- Question: What is the volume split between "High" and "Low" sales classifications?
SELECT Sales_classification, COUNT(sales_classification) AS total_cars
FROM sales
GROUP BY Sales_classification;
-- Result: Low-sale models (34.7k) significantly outnumber High-sale models (15.2k).


-- Question: Which BMW models are the true volume drivers (total sales > 10,000 units)?
SELECT c.Model, SUM(s.sales_volume) AS total_sales
FROM cars_info c 
JOIN sales s ON c.Car_id = s.Car_id
GROUP BY c.Model
HAVING SUM(s.sales_volume) > 10000;
-- Result: 11 models exceed 10,000 units in total sales volume. These models likely represent BMW's core lineup.


-- Question: How dominant are Petrol-powered vehicles in overall sales volume?
SELECT SUM(s.Sales_Volume) AS Petrol_engine_sales
FROM sales s
JOIN cars_info c ON s.car_id = c.car_id
JOIN fuel_types_info f ON c.Fuel_type_id = f.Fuel_type_id
WHERE f.Fuel_type = 'Petrol';
-- Result: Total sales volume for Petrol-powered vehicles: 63,324,154


-- Question: What is the total sales volume for each BMW model, and which model drives the highest volume?
SELECT c.Model, SUM(s.sales_volume) AS total_sales
FROM cars_info c 
JOIN sales s ON c.car_id = s.car_id
GROUP BY c.Model
ORDER BY total_sales DESC;
-- Result: The 7 Series has the highest total sales volume in the dataset - 23,786,466 USD


-- Question: Which fuel type is the market leader in each global sales region?
WITH region_fuel_ranking AS(
SELECT s.Region,f.fuel_type,
COUNT(c.car_id) AS fuel_type_count, 
ROW_NUMBER() OVER (PARTITION BY s.Region ORDER BY COUNT(c.car_id) DESC) AS serial_number 
FROM fuel_types_info f 
JOIN cars_info c ON f.Fuel_type_id = c.Fuel_type_id
JOIN sales s ON c.car_id = s.car_id
GROUP BY s.Region,f.fuel_type
)
SELECT region, fuel_type, fuel_type_count
FROM region_fuel_ranking
WHERE serial_number = 1;
-- Result: Hybrid technology is the dominant market leader in four out of six global regions. The only exceptions are Middle East and 'South America', where Petrol remains the preferred fuel type.


-- Question: Which specific BMW models are available with a Diesel powerplant within the Asia sales region?
SELECT DISTINCT c.model 
FROM cars_info c
JOIN sales s ON c.car_id = s.car_id
JOIN fuel_types_info f ON c.Fuel_type_id = f.Fuel_type_id
WHERE s.region = 'Asia' AND f.Fuel_type = 'Diesel';
-- Result: There are 11 unique BMW models currently sold in Asia that utilize Diesel fuel.


-- Question: Which global sales region records the highest average mileage (KM) across its BMW fleet?
SELECT s.Region, ROUND(AVG(c.Mileage_KM), 2) AS avg_mileage_km
FROM cars_info c 
JOIN sales s ON c.Car_id= s.Car_id
GROUP BY s.Region
ORDER BY avg_mileage_km DESC
LIMIT 1;
-- Result: North America leads the world with the highest average mileage (100879.17 km) per vehicle.


-- Question: When comparing Electric and Diesel technologies specifically, which regions show a stronger preference for the "Green" alternative?
WITH region_fuel_ranking AS
(
SELECT s.Region,f.fuel_type,
COUNT(c.car_id) AS fuel_type_count, 
ROW_NUMBER() OVER (PARTITION BY s.Region ORDER BY COUNT(c.car_id) DESC) AS serial_number 
FROM fuel_types_info f 
JOIN cars_info c ON f.Fuel_type_id = c.Fuel_type_id
JOIN sales s ON c.car_id = s.car_id
WHERE fuel_type IN ('Electric', 'Diesel')
GROUP BY s.Region, f.fuel_type
)
SELECT Region, fuel_type, fuel_type_count
FROM region_fuel_ranking
WHERE serial_number = 1;
-- Result: The majority of global regions now show a higher volume of Electric vehicles compared to Diesel.
-- The regions that prefer Electric vehicles are: Africa, Europe, North America and South America.


-- Question: What is the revenue market share of each transmission type (Automatic vs. Manual) within each global sales region?
WITH region_revenue AS (
SELECT s.Region, t.transmission,
SUM(c.price_USD * s.sales_volume)  AS region_transmission_revenue
FROM sales s
JOIN cars_info c ON s.car_id = c.car_id
JOIN transmission_info t ON c.transmission_id = t.transmission_id
GROUP BY Region, transmission
)
SELECT Region, transmission,
(region_transmission_revenue / SUM(region_transmission_revenue) OVER(PARTITION BY region)) * 100 AS market_share_prct 
FROM region_revenue;
-- Result: The market share is incredibly balanced, with each transmission type capturing approximately 50% of the revenue in every single region.
-- It suggests that BMW's global customer base is perfectly divided between those who prefer the convenience of an Automatic and those who prefer the engagement of a Manual.


/*
Insights  from this section:
The world is moving away from Diesel and toward Electric and Hybrid power. Electric cars now outsell Diesel in most parts of the world, including Europe and North America. Hybrids are the overall leaders in 4 out of 6 global regions. While most models in the data sell in smaller numbers, there are 11 "hero" models like the expensive 7 Series, X3 mdoel and others that make up the core of BMW’s business. Finally, BMW drivers are perfectly split down the middle: 50% of revenue comes from people who want an Automatic, and the other 50% comes from those who prefer a Manual.
*/


-- ==============================================================================================================================================================================
-- 														Section 4: Database Engineering & Reporting Automation
-- ==============================================================================================================================================================================


-- Question: How can we create a centralized "Quick-Look" tool to verify table structures and data samples before performing complex analytical queries?
DELIMITER && 
CREATE PROCEDURE all_info()
BEGIN
SELECT * FROM Fuel_types_info LIMIT 50;
SELECT * FROM Transmission_info LIMIT 50;
SELECT * FROM Colors LIMIT 50;
SELECT * FROM Sales LIMIT 50;
SELECT * FROM Cars_info LIMIT 50;
END &&
DELIMITER ;
/*
This query builds a Stored Procedure named all_info(). 
The primary objective is to improve Developer Productivity. By using a custom DELIMITER, we package five separate audit queries into a single executable command.
This allows the user to instantly verify column names, data types, and sample values across the entire BMW database schema without opening multiple tabs or writing repetitive SELECT statements.

Result: A reusable internal tool that, when called via CALL all_info();, provides an immediate 50-row snapshot of every key table (Fuel, Transmission, Colors, Sales, and Cars).
*/


-- Question: How do models rank by price within their specific sales classification?
SELECT DISTINCT c.Model, c.Price_USD, s.sales_classification,
RANK() OVER (PARTITION BY s.sales_classification ORDER BY c.Price_USD) AS Price_Rank
FROM cars_info c 
JOIN sales s ON c.car_id = s.car_id
ORDER BY Price_rank;


-- Question: How can we simplify access to high-performing car data for recurring business reports?
CREATE OR REPLACE VIEW high_sales_cars AS
SELECT c.model, s.region, s.sales_volume 
FROM cars_info c
JOIN sales s ON c.car_id = s.car_id
WHERE s.sales_classification = 'High';

SELECT * FROM high_sales_cars;

-- To view total sales volume for each region from high_sales_cars views
SELECT SUM(sales_volume) AS total_sales, Region
FROM high_sales_cars
GROUP BY Region;

-- Result: A streamlined reporting layer called high_sales_cars is now available, allowing for instant regional sales volume aggregation without re-calculating raw table joins.

/*
Insights  from this section:
This section focuses on making data work faster. By building Stored Procedures and Database Views, I transformed complex manual tasks into one-click automated processes. 
This reduces human error, ensures a "Single Source of Truth" for the team, and allows the business to spend less time on "gathering data" and more time for "making decisions."
*/