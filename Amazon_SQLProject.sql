CREATE DATABASE amazon_project;

USE amazon_project;

-- Preview first 5 rows to understand the structure
SELECT * FROM amazon_sales_dataset LIMIT 5;
SELECT * FROM amazon_sales_dataset ;

DESCRIBE amazon_sales_dataset;

-- ---------------------------------------------------
-- PHASE 2: BUSINESS PERFORMANCE QUERIES
-- ---------------------------------------------------


-- Business Question 1: What are the primary product categories and their distribution?
SELECT 
    category, 
    COUNT(*) AS total_products
FROM amazon_sales_dataset
GROUP BY category
ORDER BY total_products DESC;

-- Verify total row count in the dataset
SELECT COUNT(*) AS total_rows FROM amazon_sales_dataset;


SELECT * FROM amazon_sales_dataset LIMIT 2;


SHOW COLUMNS FROM amazon_sales_dataset;

-- ---------------------------------------------------
-- Business Question 2: What is the delivery success rate vs cancellation rate?
-- Objective: Understand overall order fulfillment and customer drop-off.
-- ---------------------------------------------------

SELECT 
    order_status,
    COUNT(*) AS total_orders,
    ROUND((COUNT(*) / 1000.0) * 100, 2) AS percentage
FROM amazon_sales_dataset
GROUP BY order_status
ORDER BY total_orders DESC;

-- Check exact column names for pricing, sales, and logistics
SELECT * FROM amazon_sales_dataset LIMIT 1;


-- ---------------------------------------------------
-- Business Question 2: Category & Sub-Category Sales Performance
-- Objective: Identify which sub-categories drive the highest revenue.
-- ---------------------------------------------------

SELECT 
    category,
    sub_category,
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(total_sales), 2) AS total_revenue,
    ROUND(AVG(total_sales), 2) AS avg_order_value
FROM amazon_sales_dataset
GROUP BY category, sub_category
ORDER BY total_revenue DESC;


-- ---------------------------------------------------
-- Business Question 3: Discount Impact on Revenue
-- Objective: Analyze if higher discounts lead to higher sales volume.
-- ---------------------------------------------------

SELECT 
    CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.15 THEN 'Low Discount (1-15%)'
        WHEN discount <= 0.30 THEN 'Medium Discount (16-30%)'
        ELSE 'High Discount (>30%)'
    END AS discount_bracket,
    COUNT(*) AS total_orders,
    ROUND(AVG(total_sales), 2) AS avg_sale_value,
    ROUND(SUM(total_sales), 2) AS total_bracket_revenue
FROM amazon_sales_dataset
GROUP BY discount_bracket
ORDER BY total_bracket_revenue DESC;


-- ---------------------------------------------------
-- Business Question 4: Payment Method Distribution
-- Objective: Understand customer preferred payment options and average ticket size.
-- ---------------------------------------------------

SELECT 
    payment_method,
    COUNT(*) AS transaction_count,
    ROUND(SUM(total_sales), 2) AS total_revenue,
    ROUND(AVG(total_sales), 2) AS avg_ticket_size
FROM amazon_sales_dataset
GROUP BY payment_method
ORDER BY total_revenue DESC;



-- ---------------------------------------------------
-- Business Question 5: Shipping & Delivery Lead Time Analysis
-- Objective: Calculate average delivery time (days) across states/regions.
-- ---------------------------------------------------

SELECT 
    state,
    COUNT(*) AS total_deliveries,
    ROUND(AVG(DATEDIFF(delivery_date, order_date)), 1) AS avg_delivery_days,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost
FROM amazon_sales_dataset
GROUP BY state
ORDER BY avg_delivery_days DESC
LIMIT 5;


-- ---------------------------------------------------
-- Business Question 6: Top 10 High-Value Customers (Customer Lifetime Value)
-- Objective: Identify VIP customers contributing the most revenue.
-- ---------------------------------------------------

SELECT 
    customer_id,
    customer_name,
    COUNT(order_id) AS total_orders_placed,
    SUM(quantity) AS total_items_bought,
    ROUND(SUM(total_sales), 2) AS total_spend
FROM amazon_sales_dataset
GROUP BY customer_id, customer_name
ORDER BY total_spend DESC
LIMIT 10;


-- ---------------------------------------------------
-- PHASE 3: ADVANCED ANALYTICS (WINDOW FUNCTIONS & CTE)
-- ---------------------------------------------------

-- Business Question 7: Top 3 Best-Selling Products in Each Category
-- Objective: Rank products within each category using DENSE_RANK().
-- ---------------------------------------------------

WITH RankedProducts AS (
    SELECT 
        category,
        sub_category,
        brand,
        ROUND(SUM(total_sales), 2) AS total_revenue,
        DENSE_RANK() OVER(PARTITION BY category ORDER BY SUM(total_sales) DESC) AS rank_in_category
    FROM amazon_sales_dataset
    GROUP BY category, sub_category, brand
)
SELECT 
    category,
    sub_category,
    brand,
    total_revenue,
    rank_in_category
FROM RankedProducts
WHERE rank_in_category <= 3;


-- ---------------------------------------------------
-- Business Question 8: Customer Segmentation using RFM Logic (Spending Tiers)
-- Objective: Classify customers into High, Medium, and Low value spenders.
-- ---------------------------------------------------

WITH CustomerAggregates AS (
    SELECT 
        customer_id,
        customer_name,
        COUNT(order_id) AS total_orders,
        ROUND(SUM(total_sales), 2) AS total_spent
    FROM amazon_sales_dataset
    GROUP BY customer_id, customer_name
)
SELECT 
    customer_id,
    customer_name,
    total_orders,
    total_spent,
    CASE 
        WHEN total_spent >= 100000 THEN 'Platinum Spender'
        WHEN total_spent >= 50000 THEN 'Gold Spender'
        ELSE 'Silver Spender'
    END AS customer_tier
FROM CustomerAggregates
ORDER BY total_spent DESC;




