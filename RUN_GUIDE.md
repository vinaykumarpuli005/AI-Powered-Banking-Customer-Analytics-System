# Run Guide

## 1. Install Dependencies

```bash
pip install -r requirements.txt
```

## 2. Run Notebook

Open and run:

```text
banking_analytics_system.ipynb
```

This generates:

- trained ML models in `models/`
- Power BI export files in `powerbi_exports/`

## 3. SQL Server / SSMS

1. Create database `BankingAnalyticsDB`.
2. Import `Churn_Modelling.csv` as table `customers`.
3. Run `banking_customer_analytics_sql_server.sql`.

## 4. Streamlit App

Run:

```bash
streamlit run app.py
```

Open:

```text
http://localhost:8501
```

## 5. Power BI

Open:

```text
AI_Powered_Banking_Customer_Analytics_Dashboard.pbix
```

Refresh data if needed.
