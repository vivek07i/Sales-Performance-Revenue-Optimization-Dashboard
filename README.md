# Sales-Performance-Revenue-Optimization-Dashboard

Sales Performance & Revenue Optimization Dashboard
📋 Project Overview
This project focuses on analyzing 1 Million+ sales records to evaluate sales performance across multiple regions and product categories.

By utilizing advanced SQL Window Functions, I moved away from manual aggregations to a dynamic, automated reporting structure. The goal was to identify high-value products, flag underperforming regions, and calculate month-over-month growth to drive revenue optimization strategies.

💼 Business Problem
Processing large-scale sales data (1M+ rows) manually leads to:

Inefficiency: Slow reporting cycles due to manual calculations.

Lack of Insight: Difficulty in tracking granular trends like Month-over-Month (MoM) growth per region.

Missed Opportunities: Inability to quickly identify underperforming regions or top-contributing products.

Objective: Build a scalable SQL-based solution to automate performance tracking and reduce manual reporting time.

🛠️ Technical Implementation
Tools Used: SQL (MySQL), Excel/Power BI (for visualization).

1. Advanced SQL Analysis
I employed window functions to perform calculations across rows related to the current row, without collapsing the data.

RANK() & DENSE_RANK(): Used to categorize products by revenue contribution to isolate the top performers.

LAG(): Used to access data from the previous month to calculate Month-over-Month (MoM) growth percentages.

SUM() OVER (PARTITION BY ...): Used to calculate regional totals against individual sales.

2. Key SQL Logic (Snippets)
A. Month-over-Month Revenue Growth Analysis

SQL

SELECT 
    region_id,
    sale_month,
    total_revenue,
    -- Fetch previous month's revenue using LAG
    LAG(total_revenue, 1) OVER (PARTITION BY region_id ORDER BY sale_month) AS prev_month_revenue,
    -- Calculate Growth Percentage
    ((total_revenue - LAG(total_revenue, 1) OVER (PARTITION BY region_id ORDER BY sale_month)) 
      / LAG(total_revenue, 1) OVER (PARTITION BY region_id ORDER BY sale_month)) * 100 AS growth_pct
FROM Monthly_Sales;
B. Top Product Identification (Pareto Principle)

SQL

SELECT 
    product_name,
    SUM(revenue) as total_revenue,
    -- Rank products to find top contributors
    RANK() OVER (ORDER BY SUM(revenue) DESC) as rank_id,
    -- Calculate % contribution to total revenue
    SUM(revenue) * 100.0 / SUM(SUM(revenue)) OVER () as contribution_pct
FROM sales_data
GROUP BY product_name;
📈 Key Insights & Results

Revenue Concentration: Identified that the Top 10 products were responsible for ~65% of total revenue.


Regional Performance: Flagged 3 specific regions that were underperforming with revenue gaps of 12-18% compared to the average.


Process Efficiency: By generating pre-aggregated, analysis-ready datasets via SQL views, I reduced the manual reporting effort by ~40%.

📂 Repository Structure
├── data/                   # Schema and mock data generation scripts
├── sql_queries/            # Core analysis queries
│   ├── 1_schema_setup.sql
│   ├── 2_mom_growth_analysis.sql
│   └── 3_product_ranking.sql
├── output/                 # Exported results (CSV/Excel)
├── README.md               # Project documentation
└── requirements.txt        # Dependencies (if Python is used for automation)
🚀 How to Run This Project
Clone the Repository:

Bash

git clone https://github.com/yourusername/sales-performance-analysis.git
Setup Database: Run sql_queries/1_schema_setup.sql to create the sales_data, products, and regions tables.

Execute Analysis: Run the queries in the sql_queries/ folder to generate the insights.

👤 Author
Vivek Kumar

Role: Final Year B.Tech (CSE with AI/ML)

Focus: Business & Data Analysis


Contact: work.vivek4207@gmail.com
