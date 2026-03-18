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
<img width="500" height="142" alt="image" src="https://github.com/user-attachments/assets/f6cab98e-40e8-413a-bfc8-158a2d15b1b4" />\

2. Which are the top 10 products by total revenue?
<img width="500" height="364" alt="image" src="https://github.com/user-attachments/assets/7fe0eece-d7c2-464b-8b52-cc583e49e2d4" />
<br>

3. Which product categories generate the most revenue?
<img width="500" height="79" alt="image" src="https://github.com/user-attachments/assets/30ae7727-faff-4f57-81ad-3b1efb949499" />

4. Who are the top 10 customers by lifetime value?
<img width="500" height="361" alt="image" src="https://github.com/user-attachments/assets/2cad7163-2e0c-4c69-be35-a940e6507bf1" />

5. Which country generates the most revenue?
<img width="500" height="76" alt="image" src="https://github.com/user-attachments/assets/e61654ef-9c97-4b13-bc3e-7434efe9cd04" />

6. What percentages of revenue comes from the top 20% of customers? (Pareto Analysis)
<img width="500" height="81" alt="image" src="https://github.com/user-attachments/assets/14c3755d-04d5-4ea5-8ca0-14c0b80d70f4" />

7. Which employees have processed the most orders?
<img width="500" height="79" alt="image" src="https://github.com/user-attachments/assets/7e83b415-f5c7-4735-a511-b2cd7a535c16" />

8. Which shipper has the best/worst average delivery time?
<img width="500" height="142" alt="image" src="https://github.com/user-attachments/assets/62191197-c447-424d-9418-5bf4e3e6ba12" />

9. Are there any orders that were delivered late?
<img width="855" height="582" alt="image" src="https://github.com/user-attachments/assets/c3b2b8d5-0ce4-4963-ad57-4477eb33b3f0" />
