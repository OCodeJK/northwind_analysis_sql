# Northwind Sales Analytics

## Overview
Trying my hands on SQL by myself (aiming to become a data analyst) so I ask myself which business related enquires would be asked:
- What is the total revenue per year and per quarter? Is the business growing?
- Which are the top 10 products by total revenue?
- Which product categories generate the most revenue?
- Who are the top 10 customers by lifetime value?
- Which country generates the most revenue?
- What percentages of revenue comes from the top 20% of customers? (Pareto Analysis)
- Which employees have processed the most orders?
- Which shipper has the best/worst average delivery time?
- Are there any orders that were delivered late?

Abit more advanced SQL:
- Write a month-over-month revenue growth query using windows function
- Cohort analysis - group customers by their first order month and track how many reorder in subsequent months
- Calculate customer churn

## Tools Used
PostgreSQL, DBeaver

## Key Findings
- The top 20% of customers drove 60.6% of total revenue
- Shipper United Package had the longest delivery date on average of 9.2
- Month-over-month revenue peaked in December at $71,398

## SQL Concepts Demonstrated
CTEs, Window Functions (LAG, NTILE, ROW_NUMBER),
Cohort Analysis, CASE WHEN, Date Functions, JOINs

## How to Run
1. Clone this repo
2. Load northwind.sql into PostgreSQL
3. Run queries in the /queries folder in order

## Demostrations
1. What is the total revenue per year and per quarter? Is the business growing?

3. Which are the top 10 products by total revenue?
4. Which product categories generate the most revenue?
5. Who are the top 10 customers by lifetime value?
6. Which country generates the most revenue?
7. What percentages of revenue comes from the top 20% of customers? (Pareto Analysis)
8. Which employees have processed the most orders?
9. Which shipper has the best/worst average delivery time?
10. Are there any orders that were delivered late?
