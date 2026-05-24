# Power BI Dashboard Guide

## Power BI File

`AI_Powered_Banking_Customer_Analytics_Dashboard.pbix`

## Data Files Used

Power BI uses files from `powerbi_exports/`:

- `customers.csv`
- `transactions.csv`
- `customer_segments.csv`
- `churn_predictions.csv`
- `product_recommendations.csv`

## Data Model Relationships

Create or verify these relationships:

- `customers[CustomerId]` to `transactions[customer_id]`
- `customers[CustomerId]` to `customer_segments[customer_id]`
- `customers[CustomerId]` to `churn_predictions[customer_id]`
- `customers[CustomerId]` to `product_recommendations[customer_id]`

Main relationship:

`customers[CustomerId] 1 -> * transactions[customer_id]`

## Dashboard Pages

### 1. Executive Summary

Shows overall KPIs, churn distribution, customers by geography, and churn rate by geography.

Recommended KPIs:

- Total Customers
- Churned Customers
- Churn Rate
- Average Balance
- Average Credit Score

### 2. Churn Analysis

Shows churn trends by gender, age group, number of products, geography, and activity status.

Recommended visuals:

- Churn Rate by Age Group
- Churn Rate by NumOfProducts
- Churn Rate by Gender
- Customer details table

### 3. Customer Profile

Shows customer demographic and account behavior patterns.

Recommended visuals:

- Customers by Age Group
- Customers by Activity Status
- Customers by Credit Card Status
- Credit Score vs Balance scatter chart

### 4. Risk Analysis

Shows high-risk, medium-risk, and low-risk customer groups.

Recommended visuals:

- High Risk Customers by Geography
- Customers by Risk Category
- Risk distribution by Credit Score and Age
- High-risk customer table

### 5. Transactions & Fraud Analysis

Shows transaction behavior and suspicious transaction insights.

Recommended KPIs:

- Total Transactions
- Total Transaction Amount
- Average Transaction Amount
- Suspicious Transactions
- Suspicious Transaction Rate

Recommended slicers:

- fraud_status
- transaction_type
- merchant_category
- location
- Transaction Month
- Transaction Weekday

Recommended charts:

- Transaction Amount Over Time
- Fraud Status Distribution
- Transaction Amount by Type
- Suspicious Transactions by Month
- Transaction Amount by Merchant Category

### 6. Segmentation Insights

Shows customer segment behavior.

Recommended visuals:

- Customers by Segment
- Churn Rate by Segment
- Average Balance by Segment
- Segment customer table

## Important Formatting Tips

- Format churn/risk/fraud rates as percentages.
- Use dropdown slicers to save space.
- Keep KPI cards aligned in one row.
- Avoid thick black borders.
- Use consistent fonts and colors.
