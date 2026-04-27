-- Creating and using the database 
CREATE DATABASE BMW_sales;

USE BMW_sales;


-- Creating a table in which data will be loaded
DROP TABLE IF EXISTS original_sales_data;

CREATE TABLE original_sales_data (
Model VARCHAR(255),
    Year YEAR,
    Region VARCHAR(100),
    Color VARCHAR(50),
    Fuel_Type VARCHAR(50),
    Transmission VARCHAR(50),
    Engine_Size_L DECIMAL(3,1), -- Handles values like 2.0, 3.5, etc.
    Mileage_KM INT,
    Price_USD DECIMAL(12,2),    -- Handles large car prices with precision
    Sales_Volume INT,
    Sales_Classification VARCHAR(100)
);


-- Loading the data
-- -- REPLACE THE PATH BELOW WITH YOUR LOCAL FILE LOCATION
LOAD DATA INFILE 'C:/PATH/TO/YOUR/FILE/BMW_sales_data.csv'
INTO TABLE original_sales_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Skips the header row

SELECT * FROM original_sales_data;


-- NORMALISATION PROCESS

-- Creating a table for storing fuels information
CREATE TABLE Fuel_types_info (
Fuel_type_id INT AUTO_INCREMENT PRIMARY KEY,
Fuel_type VARCHAR(255)
)auto_increment = 10;

-- Creating a table for storing transmission information
CREATE TABLE Transmission_info (
Transmission_id INT AUTO_INCREMENT PRIMARY KEY,
Transmission VARCHAR(255)
) auto_increment = 20;

-- Creating a table for storing colors information
CREATE TABLE Colors (
Color_id INT AUTO_INCREMENT PRIMARY KEY,
Color VARCHAR(255)
) auto_increment = 100;

-- Creating a table for storing cars information
CREATE TABLE Cars_info (
Car_id INT AUTO_INCREMENT PRIMARY KEY,
Model VARCHAR(255),
Color_id INT,
Launch_Year YEAR,
Engine_Size_L DECIMAL(3,1),
Price_USD DECIMAL(10,2),
Fuel_type_id INT,
Transmission_id INT,
Mileage_KM INT,
FOREIGN KEY (Fuel_type_id) REFERENCES Fuel_types_info(Fuel_type_id),
FOREIGN KEY (Transmission_id) REFERENCES Transmission_info(Transmission_id),
FOREIGN KEY (Color_id) REFERENCES Colors(Color_id)
) auto_increment = 1000;


-- Creating a table for storing sales information
CREATE TABLE sales (
Sale_id INT AUTO_INCREMENT PRIMARY KEY,
Car_id INT,
Region VARCHAR(255),
Sales_Volume INT,
Sales_classification VARCHAR(255),
FOREIGN KEY (Car_id) REFERENCES Cars_info(Car_id)
) auto_increment = 1;

SHOW TABLES;

DESC cars_info;
DESC colors;
DESC fuel_types_info;
DESC sales;
DESC transmission_info;


-- Inserting values in the tables

INSERT INTO Fuel_types_info (Fuel_type)
SELECT DISTINCT Fuel_type
FROM original_sales_data;

INSERT INTO Transmission_info (Transmission)
SELECT DISTINCT Transmission
FROM original_sales_data;

INSERT INTO Colors (Color)
SELECT DISTINCT Color
FROM original_sales_data;

SELECT * FROM Fuel_types_info
LIMIT 50;
SELECT * FROM Transmission_info LIMIT 50;
SELECT * FROM Colors LIMIT 50;
SELECT * FROM Sales LIMIT 50;
SELECT * FROM Cars_info LIMIT 50;

DESC Cars_info;

INSERT INTO Cars_info 
(Model, Launch_Year, Engine_Size_L, Price_USD, Fuel_type_id, Transmission_id, Mileage_KM, Color_id)
SELECT
o.model, o.year, o.engine_size_l, o.price_usd,
f.fuel_type_id, t.transmission_id, o.mileage_km, c.color_id
FROM original_sales_data AS o
JOIN Fuel_types_info AS f ON o.Fuel_type = f.Fuel_type
JOIN Transmission_info AS t ON o.Transmission = t.Transmission
JOIN Colors AS c ON o.color = c.color;

INSERT INTO Sales (Car_id, Region, Sales_Volume, Sales_Classification)
SELECT 
    c_info.car_id, 
    o.Region, 
    o.Sales_Volume, 
    o.Sales_classification
FROM original_sales_data AS o
JOIN Fuel_types_info AS f ON o.Fuel_type = f.Fuel_type
JOIN Transmission_info AS t ON o.Transmission = t.Transmission
JOIN Colors AS c ON o.color = c.color
JOIN Cars_info AS c_info 
  ON o.model = c_info.model 
  AND o.Year = c_info.Launch_Year 
  AND o.Engine_Size_L = c_info.Engine_Size_L
  AND o.Price_USD = c_info.Price_USD
  AND f.fuel_type_id = c_info.Fuel_type_id
  AND t.transmission_id = c_info.Transmission_id
  AND c.color_id = c_info.Color_id;
  
SELECT * FROM colors;
SELECT * FROM fuel_types_info;  
SELECT * FROM transmission_info;
SELECT * FROM cars_info;
SELECT * FROM sales;


-- Checking the data 
SELECT COUNT(*) FROM sales;
SELECT COUNT(*) FROM original_sales_data;

-- Dropping the original dataset as it is not required anymore for my analysis
DROP TABLE original_sales_data;

SHOW TABLES;

-- Cleaning the data
-- Removing the carriage returns and newlines in the sales_classification column
SET SQL_SAFE_UPDATES = 0;

UPDATE sales 
SET sales_classification = REPLACE(REPLACE(sales_classification, '\r', ''), '\n', '');

SET SQL_SAFE_UPDATES = 1;