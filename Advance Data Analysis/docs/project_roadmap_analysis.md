# Data Analytics Project Roadmap and Work Evidence

## 1. Project purpose

This project builds a SQL Server data-analytics workflow for a sales data warehouse. The work moves from raw warehouse setup and structural exploration to business analysis and reusable reporting views.

The central objective is to transform sales, customer, and product data into answers that support:

- Understanding the available data and its quality boundaries.
- Measuring overall business performance.
- Explaining who the customers are and what they buy.
- Identifying high- and low-performing products and categories.
- Tracking sales trends, growth, and cumulative performance.
- Segmenting customers and products for targeted decision-making.
- Producing reusable customer and product reports.

The supplied roadmap shows this progression as:

**Data Analytics → Exploratory Data Analysis → Advanced Analytics → Reporting**

The project contains scripts numbered `00` through `13`. The roadmap’s 13 analytical stages are scripts `01`–`13`; script `00` is the database and data-loading foundation required before those stages can run.

## 2. Roadmap execution summary

| Stage | Script | Roadmap area | Completed work | Why it was analyzed |
|---:|---|---|---|---|
| Foundation | [`00_init_database.sql`](../scripts/00_init_database.sql) | Warehouse setup | Recreated the `DataWarehouseAnalytics` database, created the `gold` schema, created customer, product, and sales tables, and loaded the CSV files with `BULK INSERT`. | To establish a consistent relational model and a repeatable starting point for all analysis. |
| 1 | [`01_database_exploration_01.sql`](../scripts/01_database_exploration_01.sql) | Database exploration | Queried `INFORMATION_SCHEMA.TABLES` and `INFORMATION_SCHEMA.COLUMNS` to inspect tables, schemas, column names, data types, nullability, and character lengths. | To understand the database structure before writing analytical queries and to confirm which fields are available. |
| 2 | [`02_explore_dimension.sql`](../scripts/02_explore_dimension.sql) | Dimension exploration | Listed distinct customer countries and distinct product category, subcategory, and product-name combinations. | To discover the business dimensions and the categorical values available for grouping and filtering. |
| 3 | [`03_date_exploration.sql`](../scripts/03_date_exploration.sql) | Date exploration | Found the first and last order dates, the approximate order range in years and months, and the oldest and youngest customer birthdates with age calculations. | To establish the time coverage of sales and the customer-age boundaries before performing trend and cohort-style analysis. |
| 4 | [`04_measures_exploration.sql`](../scripts/04_measures_exploration.sql) | Measures exploration | Calculated total sales, total quantity, average price, total orders, total products, total customers, and customers who placed orders. Combined the key figures into one metrics result with `UNION ALL`. | To create a baseline KPI set and quantify the scale, activity, and engagement of the business. |
| 5 | [`05_magnitude.sql`](../scripts/05_magnitude.sql) | Magnitude analysis | Measured customers by country and gender, products by category, average category cost, revenue by category, revenue by customer, and sold items by country. | To compare the size and financial contribution of important business groups and identify where volume and revenue are concentrated. |
| 6 | [`06_ranking.sql`](../scripts/06_ranking.sql) | Ranking analysis | Ranked the five highest- and five lowest-performing product subcategories by revenue using both `TOP` queries and window functions (`ROW_NUMBER()` and `RANK()`). | To identify leaders and underperformers that may require investment, promotion, investigation, or corrective action. |
| 7 | [`07_change_over_time_analysis.sql`](../scripts/07_change_over_time_analysis.sql) | Change-over-time analysis | Aggregated sales, distinct customers, and quantity by year/month using `YEAR()` and `MONTH()`, `DATETRUNC(month, ...)`, and `FORMAT()`. | To reveal trends, changes in demand, and possible seasonal patterns over the sales period. |
| 8 | [`08_cumulative_analysis.sql`](../scripts/08_cumulative_analysis.sql) | Cumulative analysis | Produced monthly sales with a yearly-reset running total, and yearly sales with an overall running total and moving average price using window functions. | To understand accumulated progress, long-term growth, and the direction of average pricing over time. |
| 9 | [`09_performance_analysis.sql`](../scripts/09_performance_analysis.sql) | Performance analysis | Compared yearly product sales with each product’s average and previous-year sales. Calculated differences and labeled results as above/below average and increase/decrease/no change. | To benchmark product performance and make year-over-year movement easier to interpret. |
| 10 | [`10_part_to_whole_analysis.sql`](../scripts/10_part_to_whole_analysis.sql) | Part-to-whole analysis | Calculated category sales, total company sales, and each category’s percentage contribution using `SUM() OVER()`. | To show how much each category contributes to the total business and identify revenue concentration. |
| 11 | [`11_data_segmentation.sql`](../scripts/11_data_segmentation.sql) | Data segmentation | Grouped products into cost bands and customers into `VIP`, `Regular`, and `New` segments based on customer lifespan and total spending. | To turn continuous measures into actionable groups for pricing, marketing, retention, and customer-value decisions. |
| 12 | [`12_report_customers.sql`](../scripts/12_report_customers.sql) | Customer reporting | Created the `gold.report_customers` view with customer identity, age group, segment, recency, orders, sales, quantity, products, lifespan, average order value, and average monthly spend. | To provide a reusable customer-level analytical dataset instead of repeating complex joins and calculations. |
| 13 | [`13_report_products.sql`](../scripts/13_report_products.sql) | Product reporting | Created the `gold.report_products` view with product attributes, recency, product segment, lifespan, orders, sales, quantity, customers, average selling price, average order revenue, and average monthly revenue. | To provide a reusable product-performance dataset for reporting, prioritization, and product portfolio decisions. |

## 3. Detailed evidence of completed work

### 3.1 Database and warehouse foundation

In [`00_init_database.sql`](../scripts/00_init_database.sql), the project:

1. Checks whether `DataWarehouseAnalytics` already exists.
2. Switches an existing database to single-user mode and drops it before recreation.
3. Creates the `DataWarehouseAnalytics` database.
4. Creates the `gold` schema.
5. Creates three tables:
   - `gold.dim_customers`
   - `gold.dim_products`
   - `gold.fact_sales`
6. Defines customer, product, and transaction attributes with SQL Server data types.
7. Clears the target tables with `TRUNCATE TABLE`.
8. Loads `dim_customers.csv`, `dim_products.csv`, and `fact_sales.csv` with `BULK INSERT`.

This creates a simple star-schema-style model:

- `fact_sales` stores transactional measures such as sales amount, quantity, price, and order dates.
- `dim_customers` stores customer attributes.
- `dim_products` stores product attributes.
- `customer_key` and `product_key` connect the fact table to the dimensions.

### 3.2 Structural and dimension exploration

The first exploratory scripts establish what the data contains before business interpretation begins:

- [`01_database_exploration_01.sql`](../scripts/01_database_exploration_01.sql) checks the schema metadata.
- [`02_explore_dimension.sql`](../scripts/02_explore_dimension.sql) discovers customer countries and the product hierarchy.
- [`03_date_exploration.sql`](../scripts/03_date_exploration.sql) establishes sales date coverage and customer age boundaries.

This is important because later calculations depend on knowing the grain of the data, the available dimensions, the valid dates, and the expected null behavior.

### 3.3 Baseline business measures

[`04_measures_exploration.sql`](../scripts/04_measures_exploration.sql) creates the first business snapshot:

- Total sales.
- Total quantity sold.
- Average selling price.
- Number of distinct orders.
- Number of distinct products.
- Number of distinct customers.
- Number of customers represented in the sales fact table.
- A combined key-metrics output for quick consumption.

These are the baseline measures used to describe business size and to provide context for later breakdowns.

### 3.4 Distribution, magnitude, and ranking

[`05_magnitude.sql`](../scripts/05_magnitude.sql) breaks the baseline into meaningful groups:

- Customer distribution by country and gender.
- Product count and average cost by category.
- Revenue by product category.
- Revenue by customer.
- Quantity sold by country.

[`06_ranking.sql`](../scripts/06_ranking.sql) then turns those measurements into priorities by ranking product subcategories:

- Top five by revenue.
- Bottom five by revenue.
- A `ROW_NUMBER()` implementation for descending rank.
- A `RANK()` implementation for ascending low-performance rank.

The two scripts together answer both “where is the business large?” and “which entities should be prioritized?”

### 3.5 Time-series and advanced analytics

The project then progresses from static summaries to temporal analysis:

- [`07_change_over_time_analysis.sql`](../scripts/07_change_over_time_analysis.sql) tracks monthly sales, customers, and quantity.
- [`08_cumulative_analysis.sql`](../scripts/08_cumulative_analysis.sql) adds running totals and a moving average price.
- [`09_performance_analysis.sql`](../scripts/09_performance_analysis.sql) compares yearly product sales with historical product averages and prior-year sales.
- [`10_part_to_whole_analysis.sql`](../scripts/10_part_to_whole_analysis.sql) calculates each category’s contribution to total sales.

The SQL techniques demonstrated include:

- Date extraction with `YEAR()` and `MONTH()`.
- Date bucketing with `DATETRUNC()`.
- Date display formatting with `FORMAT()`.
- Common table expressions (`WITH`).
- Windowed aggregation with `SUM() OVER()` and `AVG() OVER()`.
- Previous-row comparison with `LAG()`.
- Conditional classification with `CASE`.
- Percentage-of-total calculations.

### 3.6 Segmentation and reporting

[`11_data_segmentation.sql`](../scripts/11_data_segmentation.sql) converts raw values into decision-oriented groups:

- Product cost ranges: `Below 100`, `100-500`, `500-1000`, and `Above 1000`.
- Customer segments:
  - `VIP`: at least 12 months of history and more than 5,000 in spending.
  - `Regular`: at least 12 months of history and spending up to 5,000.
  - `New`: less than 12 months of history.

[`12_report_customers.sql`](../scripts/12_report_customers.sql) turns customer analysis into the reusable `gold.report_customers` view. It uses a base query and a customer aggregation CTE before adding age groups, customer segments, recency, AOV, and monthly-spend KPIs.

[`13_report_products.sql`](../scripts/13_report_products.sql) creates the reusable `gold.report_products` view. It aggregates each product and adds recency, revenue-based performance segments, lifespan, average selling price, average order revenue, and average monthly revenue.

These reports are the project’s final analytical products: they package the preceding exploration and calculations into outputs that can feed dashboards, reports, or further SQL analysis.

## 4. What has been achieved

The completed work demonstrates an end-to-end SQL analytics process:

1. **Built the analytical database** from the supplied flat files.
2. **Defined a dimensional model** around customers, products, and sales.
3. **Inspected the database metadata** before analysis.
4. **Explored categorical and date dimensions** to understand the data domain.
5. **Established core KPIs** for sales, orders, customers, products, quantity, and price.
6. **Compared business groups** by geography, gender, category, customer, and country.
7. **Ranked product subcategories** to expose top and bottom performers.
8. **Analyzed trends over time** at monthly and yearly levels.
9. **Calculated cumulative performance and moving averages**.
10. **Performed product year-over-year benchmarking**.
11. **Measured category contribution to total sales**.
12. **Created product and customer segments** using business rules.
13. **Built reusable customer and product reporting views** with operational KPIs.

## 5. Why the analysis was performed

The analysis was not only a collection of SQL exercises. Each stage answers a different business question:

| Business question | Analysis used | Resulting value |
|---|---|---|
| What data exists and how is it structured? | Database and dimension exploration | Prevents incorrect assumptions about tables, fields, and dimensions. |
| How large and active is the business? | Measures exploration | Establishes a common KPI baseline. |
| Where are customers, products, and revenue concentrated? | Magnitude analysis | Supports market, category, and customer prioritization. |
| Which products are strongest or weakest? | Ranking analysis | Supports product investment and corrective action. |
| Is performance changing over time? | Change-over-time analysis | Supports trend and seasonality monitoring. |
| How much progress has accumulated? | Cumulative analysis | Shows growth trajectory and pricing direction. |
| Are products improving or declining? | Performance analysis | Supports year-over-year benchmarking. |
| Which categories drive the business? | Part-to-whole analysis | Shows revenue concentration and portfolio dependence. |
| Which customers and products deserve different treatment? | Segmentation | Enables targeted retention, marketing, and product actions. |
| How can the analysis be reused? | Customer and product reports | Creates consistent outputs for reporting and downstream analysis. |

## 6. Main outputs

The project produces the following reusable database objects:

- `gold.dim_customers`
- `gold.dim_products`
- `gold.fact_sales`
- `gold.report_customers`
- `gold.report_products`

The final report views expose these customer-level and product-level metrics.

### Customer report output

- Customer key and number.
- Customer name and age.
- Age group.
- Customer segment.
- Last order date and recency.
- Total orders.
- Total sales.
- Total quantity.
- Total products purchased.
- Customer lifespan.
- Average order value.
- Average monthly spend.

### Product report output

- Product key and name.
- Category and subcategory.
- Cost.
- Last sale date and recency.
- Product segment.
- Product lifespan.
- Total orders.
- Total sales.
- Total quantity.
- Total customers.
- Average selling price.
- Average order revenue.
- Average monthly revenue.

## 7. Technical skills demonstrated

This project provides evidence of practical SQL Server analytics skills:

- Database and schema creation.
- Table design for dimensions and facts.
- CSV ingestion with `BULK INSERT`.
- Metadata inspection with `INFORMATION_SCHEMA`.
- Joins between fact and dimension tables.
- `LEFT JOIN` and `FULL JOIN` usage.
- Aggregation with `SUM`, `COUNT`, `AVG`, `MIN`, and `MAX`.
- `COUNT(DISTINCT ...)` for business entities.
- Null handling with `ISNULL`, `COALESCE`, and `NULLIF`.
- Common table expressions.
- Window functions: `ROW_NUMBER`, `RANK`, `LAG`, `SUM() OVER`, and `AVG() OVER`.
- Date functions including `DATEDIFF`, `YEAR`, `MONTH`, and `DATETRUNC`.
- Conditional business rules with `CASE`.
- Reusable SQL views.
- Multi-stage analytical query design.

## 8. Important implementation notes

These notes describe the current scripts accurately and should be considered when presenting or extending the project:

1. **Database recreation is destructive.** Running [`00_init_database.sql`](../scripts/00_init_database.sql) drops and recreates `DataWarehouseAnalytics`. It should only be run when a reset is intended and backups are not needed.
2. **The bulk-load paths are environment-specific.** The initialization script currently references the original local CSV path. That path may need to be updated for another computer or SQL Server service account.
3. **`FORMAT()` ordering requires care.** In [`07_change_over_time_analysis.sql`](../scripts/07_change_over_time_analysis.sql), the formatted date is text. The script itself notes that ordering by the formatted value can sort month labels lexically rather than chronologically. The `YEAR()`/`MONTH()` and `DATETRUNC()` versions preserve a clearer chronological basis.
4. **Age and recency use the execution date.** The report views use `GETDATE()`, so age, recency, and age-related outputs change as time passes.
5. **Customer segmentation is based on observed sales history.** Customers without a matching sales record are not included in the spending-based segmentation CTE.
6. **The project contains 14 numbered files, but 13 analytical scripts.** Script `00` is the setup/loading foundation; scripts `01`–`13` are the 13 roadmap analysis stages.

## 9. Completion statement

I completed a full SQL Server data-analytics project from warehouse initialization through reusable reporting. I explored the data structure and business dimensions, established core KPIs, analyzed distributions and rankings, evaluated time-based and cumulative performance, measured category contribution, segmented customers and products, and created final customer and product report views.

This document is the consolidated working proof of the tasks completed across the project roadmap and the purpose behind each analysis.

