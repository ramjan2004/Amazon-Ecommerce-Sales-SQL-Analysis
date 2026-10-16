# Amazon E-Commerce Sales & Logistics Analysis (SQL)

## 📌 Project Overview
This project performs an exploratory and analytical deep dive into 1,000+ transactional e-commerce records using MySQL Workbench. It focuses on identifying revenue drivers, evaluating discount effectiveness, analyzing logistics lead times, and segmenting high-value customers.

## 🛠️ Tech Stack & Key Concepts
- **Database Engine:** MySQL 8.0
- **SQL Skills Applied:**
  - Aggregations & Grouping (`SUM`, `AVG`, `COUNT`, `GROUP BY`)
  - Conditional Logic (`CASE WHEN` for discount & spending tiers)
  - Date & Logistics Calculations (`DATEDIFF` for delivery lead time)
  - Common Table Expressions (CTEs)
  - Window Functions (`DENSE_RANK() OVER(PARTITION BY ...)`)

## 📊 Business Questions Addressed
1. **Category & Sub-Category Performance:** Evaluated total revenue and unit volumes across product lines to identify core sales drivers.
2. **Discount Elasticity:** Segmented transactions into discount brackets to understand order volume response.
3. **Logistics & Delivery Turnaround:** Calculated average delivery turnaround days across destinations to detect fulfillment bottlenecks.
4. **Category Product Ranking:** Utilized `DENSE_RANK()` to isolate the top 3 revenue-generating brands in each product category.
5. **Customer Lifetime Value (CLV) Segmentation:** Categorized customers into Platinum, Gold, and Silver spending tiers using aggregate metrics and CTEs.

## 📁 Repository Structure
- `Amazon_SQLProject.sql` : Fully commented production SQL script with business questions and analytical queries.
