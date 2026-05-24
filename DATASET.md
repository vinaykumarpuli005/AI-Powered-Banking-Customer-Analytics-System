# Dataset Information

## Dataset Used

`Churn_Modelling.csv`

This dataset contains banking customer information used for churn prediction and customer analytics.

## Target Column

`Exited`

- `0` = Retained customer
- `1` = Churned customer

## Main Columns

| Column | Description |
|---|---|
| RowNumber | Row index |
| CustomerId | Unique customer identifier |
| Surname | Customer surname |
| CreditScore | Customer credit score |
| Geography | Customer country/region |
| Gender | Customer gender |
| Age | Customer age |
| Tenure | Number of years with the bank |
| Balance | Customer account balance |
| NumOfProducts | Number of bank products used |
| HasCrCard | Credit card ownership status |
| IsActiveMember | Active customer status |
| EstimatedSalary | Estimated annual salary |
| Exited | Churn status |

## Generated Data Files

The notebook generates additional CSV files for Power BI:

- `customers.csv`
- `transactions.csv`
- `customer_segments.csv`
- `churn_predictions.csv`
- `product_recommendations.csv`

## Dataset Usage

- `Churn_Modelling.csv` is used for Python ML/DL and SQL Server analysis.
- `powerbi_exports/*.csv` files are used for Power BI dashboards.
- Sample transaction data is generated in the notebook for transaction and fraud analysis.
