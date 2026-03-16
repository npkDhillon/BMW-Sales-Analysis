# BMW Global Sales Analysis (2010–2024)
End-to-End Data Engineering & Business Intelligence Project

## Project Overview
This project showcases a full data pipeline: from loading and normalizing a raw Kaggle dataset of 50,000+ BMW sales records to building an interactive analytical dashboard. By transforming a flat CSV into a **Snowflake Schema** in MySQL, I extracted key insights regarding global market trends, engine specifications, and the rise of sustainable fuel technologies.

## Tech Stack
* Database: MySQL 8.0
* Visualization: Tableau Desktop
* Environment: Windows 11 / MySQL Workbench
* Techniques: Data Normalization, Bulk Data Loading (LOAD DATA INFILE), Referential Integrity (FKs), SQL Views, and Trend Analysis.

## Project Structure
**database_setup_and_normalization.sql**: Contains the full DDL and DML for creating the 5-table schema, assigning Primary/Foreign keys, and populating the tables.

**sales_analysis_queries.sql**: The final set of complex analytical queries and views used to generate business insights.

## Database Architecture: Why Normalize?
I transitioned the original flat-file dataset into a normalized Snowflake Schema to achieve several professional-grade database standards:

- **Reduced Redundancy**: Eliminated repetitive strings (like "Automatic" or "Petrol") by storing them in dedicated dimension tables.

- **Storage Efficiency**: Drastically reduced file size by using integer-based Foreign Keys instead of long text fields.

- **Data Integrity**: Used constraints to ensure that every sale is linked to a valid car model, color, and fuel type, preventing "orphan" data.

- **Faster Updates**: Changes to a specific attribute (e.g., correcting a color name) only need to be made in one place rather than across 50,000 rows.

## Tableau Analysis & Connection
For the visualization phase, I utilized a Tableau Extract connection of the original dataset to ensure high-performance interactivity.

- Selective Analysis: While I explored numerous data relationships, I specifically curated the dashboard to display the most impactful plots for executive decision-making.

- Interactive Filtering: The dashboard features a dynamic Year Filter, allowing users to select specific timeframes (2010–2024) to observe evolving market trends in real-time.

- Visual Storytelling: I focused on the relationship between Engine Size and Pricing, as well as the regional shifts in Fuel Technology.

- KPI Tracking: Real-time tracking of Total Revenue and Sales Volume ranked by model.

## Key Insights
1. **Product Engineering & Pricing**: <br><br>The analysis reveals that BMW maintains a highly consistent pricing strategy. Even as engine sizes vary, the Average Price peaks at 3.5L (approx. $75,500) and remains relatively inelastic across the fleet. This suggests that BMW’s value proposition is driven more by brand and technology than purely by engine displacement.

2. **Global Fuel Evolution**:<br><br> A major shift is visible in the Fuel Type Distribution. While Petrol remains a strong foundation, Hybrid and Electric vehicles also account for a massive share of sales volume across all six global regions. The data confirms that BMW’s transition to sustainable power is a global movement rather than a regional trend.

3. **Sales Performance & Trends**:
  - Top Performers: The 7 Series leads the fleet in sales volume, followed closely by the i8 and X1 models.
  - Regional Stability: Total revenue reached a staggering $4.01B, with sales volumes remaining broadly stable from 2010 to 2024 across Asia, Europe, and North America.
