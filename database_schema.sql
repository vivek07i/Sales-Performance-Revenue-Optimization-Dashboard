-- 1. Products Dimension
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50) -- e.g., Electronics, Clothing
);

-- 2. Regions Dimension
CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(50) -- e.g., North, East, West, South
);

-- 3. Sales Fact Table (The 1M+ records table)
CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    product_id INT,
    region_id INT,
    sale_date DATE,
    revenue DECIMAL(12, 2),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);


-- Query
-- Query 1: Month-over-Month (MoM) Revenue Growth

WITH Monthly_Sales AS (
    SELECT 
        region_id,
        DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
        SUM(revenue) AS total_revenue
    FROM sales_data
    GROUP BY region_id, DATE_FORMAT(sale_date, '%Y-%m')
)
SELECT 
    region_id,
    sale_month,
    total_revenue,
    -- Get previous month's revenue
    LAG(total_revenue, 1) OVER (PARTITION BY region_id ORDER BY sale_month) AS prev_month_revenue,
    -- Calculate Growth %
    ((total_revenue - LAG(total_revenue, 1) OVER (PARTITION BY region_id ORDER BY sale_month)) 
      / LAG(total_revenue, 1) OVER (PARTITION BY region_id ORDER BY sale_month)) * 100 AS mom_growth_pct
FROM Monthly_Sales;

--Query 2: Product Contribution Ranking

SELECT 
    p.product_name,
    SUM(s.revenue) AS product_revenue,
    -- Rank products by revenue (1, 2, 3...)
    RANK() OVER (ORDER BY SUM(s.revenue) DESC) AS revenue_rank,
    -- Dense Rank handles ties without skipping numbers
    DENSE_RANK() OVER (ORDER BY SUM(s.revenue) DESC) AS dense_revenue_rank,
    -- Calculate contribution % to total revenue
    SUM(s.revenue) * 100.0 / SUM(SUM(s.revenue)) OVER () AS contribution_pct
FROM sales_data s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
LIMIT 10; -- Identifying the Top 10

--Phase 3: Automation & Optimization

-- Creating a View for the BI Tool (Power BI/Excel) to read directly
CREATE VIEW v_regional_performance_summary AS
SELECT 
    r.region_name,
    p.category,
    YEAR(s.sale_date) AS sales_year,
    MONTH(s.sale_date) AS sales_month,
    SUM(s.revenue) AS total_revenue,
    COUNT(s.sale_id) AS total_transactions
FROM sales_data s
JOIN regions r ON s.region_id = r.region_id
JOIN products p ON s.product_id = p.product_id
GROUP BY r.region_name, p.category, YEAR(s.sale_date), MONTH(s.sale_date);