-- AI-Powered Banking Customer Analytics System
-- SQL Server / SSMS script
-- Database: BankingAnalyticsDB

-- =====================================================
-- 1. Create and select database
-- =====================================================

IF DB_ID('BankingAnalyticsDB') IS NULL
BEGIN
    CREATE DATABASE BankingAnalyticsDB;
END;
GO

USE BankingAnalyticsDB;
GO

-- =====================================================
-- 2. Import dataset before running analysis queries
-- =====================================================
-- Import Churn_Modelling.csv using:
-- SSMS Object Explorer > Right-click BankingAnalyticsDB > Tasks > Import Flat File
-- Table name: customers
--
-- Expected customer columns:
-- RowNumber, CustomerId, Surname, CreditScore, Geography, Gender, Age, Tenure,
-- Balance, NumOfProducts, HasCrCard, IsActiveMember, EstimatedSalary, Exited

-- =====================================================
-- 3. Create additional project tables
-- =====================================================

IF OBJECT_ID('dbo.transactions', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.transactions (
        transaction_id INT PRIMARY KEY,
        customer_id INT,
        transaction_date DATETIME,
        transaction_type VARCHAR(50),
        amount FLOAT,
        transaction_frequency INT,
        average_transaction_amount FLOAT,
        account_age_days INT,
        merchant_category VARCHAR(100),
        location VARCHAR(100),
        fraud_status VARCHAR(50)
    );
END;
GO

IF OBJECT_ID('dbo.churn_predictions', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.churn_predictions (
        prediction_id INT IDENTITY(1,1) PRIMARY KEY,
        customer_id INT,
        churn_risk VARCHAR(50),
        churn_probability FLOAT,
        prediction_date DATETIME
    );
END;
GO

IF OBJECT_ID('dbo.customer_segments', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.customer_segments (
        segment_id INT IDENTITY(1,1) PRIMARY KEY,
        customer_id INT,
        segment_number INT,
        segment_name VARCHAR(100),
        created_date DATETIME
    );
END;
GO

IF OBJECT_ID('dbo.fraud_alerts', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.fraud_alerts (
        alert_id INT IDENTITY(1,1) PRIMARY KEY,
        transaction_id INT,
        customer_id INT,
        fraud_score FLOAT,
        fraud_status VARCHAR(50),
        alert_date DATETIME
    );
END;
GO

IF OBJECT_ID('dbo.product_recommendations', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.product_recommendations (
        recommendation_id INT IDENTITY(1,1) PRIMARY KEY,
        customer_id INT,
        recommended_product VARCHAR(100),
        recommendation_date DATETIME
    );
END;
GO

-- =====================================================
-- 4. Validation queries
-- Run these only after importing Churn_Modelling.csv as dbo.customers
-- =====================================================

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

SELECT TOP 10 *
FROM dbo.customers;

SELECT COUNT(*) AS total_customers
FROM dbo.customers;

-- =====================================================
-- 5. Customer churn analysis
-- =====================================================

SELECT 
    ROUND(AVG(TRY_CAST(Exited AS FLOAT)) * 100, 2) AS churn_rate_percentage
FROM dbo.customers;

SELECT 
    Geography,
    COUNT(*) AS total_customers,
    ROUND(AVG(TRY_CAST(Balance AS FLOAT)), 2) AS average_balance
FROM dbo.customers
GROUP BY Geography
ORDER BY total_customers DESC;

SELECT 
    Gender,
    COUNT(*) AS total_customers,
    SUM(TRY_CAST(Exited AS INT)) AS churned_customers,
    ROUND(AVG(TRY_CAST(Exited AS FLOAT)) * 100, 2) AS churn_rate_percentage
FROM dbo.customers
GROUP BY Gender
ORDER BY churn_rate_percentage DESC;

SELECT 
    Geography,
    COUNT(*) AS total_customers,
    SUM(TRY_CAST(Exited AS INT)) AS churned_customers,
    ROUND(AVG(TRY_CAST(Exited AS FLOAT)) * 100, 2) AS churn_rate_percentage
FROM dbo.customers
GROUP BY Geography
ORDER BY churn_rate_percentage DESC;

SELECT
    CASE
        WHEN TRY_CAST(Age AS INT) < 25 THEN 'Below 25'
        WHEN TRY_CAST(Age AS INT) BETWEEN 25 AND 35 THEN '25-35'
        WHEN TRY_CAST(Age AS INT) BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Above 50'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(TRY_CAST(Exited AS INT)) AS churned_customers,
    ROUND(AVG(TRY_CAST(Exited AS FLOAT)) * 100, 2) AS churn_rate_percentage
FROM dbo.customers
GROUP BY
    CASE
        WHEN TRY_CAST(Age AS INT) < 25 THEN 'Below 25'
        WHEN TRY_CAST(Age AS INT) BETWEEN 25 AND 35 THEN '25-35'
        WHEN TRY_CAST(Age AS INT) BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Above 50'
    END
ORDER BY churn_rate_percentage DESC;

SELECT 
    TRY_CAST(NumOfProducts AS INT) AS num_of_products,
    COUNT(*) AS total_customers,
    SUM(TRY_CAST(Exited AS INT)) AS churned_customers,
    ROUND(AVG(TRY_CAST(Exited AS FLOAT)) * 100, 2) AS churn_rate_percentage
FROM dbo.customers
GROUP BY TRY_CAST(NumOfProducts AS INT)
ORDER BY num_of_products;

-- =====================================================
-- 6. Risk and high-value customer queries
-- =====================================================

SELECT 
    CustomerId,
    CreditScore,
    Geography,
    Gender,
    Age,
    Balance,
    NumOfProducts,
    IsActiveMember,
    Exited
FROM dbo.customers
WHERE TRY_CAST(IsActiveMember AS INT) = 0
   OR TRY_CAST(CreditScore AS INT) < 500
   OR TRY_CAST(Age AS INT) > 50
ORDER BY TRY_CAST(Age AS INT) DESC;

SELECT 
    CustomerId,
    CreditScore,
    Geography,
    Gender,
    Age,
    Balance,
    EstimatedSalary
FROM dbo.customers
WHERE TRY_CAST(Balance AS FLOAT) > 100000
ORDER BY TRY_CAST(Balance AS FLOAT) DESC;

SELECT 
    CustomerId,
    CreditScore,
    Geography,
    Gender,
    Age,
    Tenure,
    Balance,
    NumOfProducts,
    HasCrCard,
    IsActiveMember,
    EstimatedSalary
FROM dbo.customers;

-- =====================================================
-- 7. Reusable SQL Server views
-- =====================================================

CREATE OR ALTER VIEW dbo.vw_churn_by_geography AS
SELECT 
    Geography,
    COUNT(*) AS total_customers,
    SUM(TRY_CAST(Exited AS INT)) AS churned_customers,
    ROUND(AVG(TRY_CAST(Exited AS FLOAT)) * 100, 2) AS churn_rate_percentage
FROM dbo.customers
GROUP BY Geography;
GO

CREATE OR ALTER VIEW dbo.vw_churn_by_age_group AS
SELECT
    CASE
        WHEN TRY_CAST(Age AS INT) < 25 THEN 'Below 25'
        WHEN TRY_CAST(Age AS INT) BETWEEN 25 AND 35 THEN '25-35'
        WHEN TRY_CAST(Age AS INT) BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Above 50'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(TRY_CAST(Exited AS INT)) AS churned_customers,
    ROUND(AVG(TRY_CAST(Exited AS FLOAT)) * 100, 2) AS churn_rate_percentage
FROM dbo.customers
GROUP BY
    CASE
        WHEN TRY_CAST(Age AS INT) < 25 THEN 'Below 25'
        WHEN TRY_CAST(Age AS INT) BETWEEN 25 AND 35 THEN '25-35'
        WHEN TRY_CAST(Age AS INT) BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Above 50'
    END;
GO

CREATE OR ALTER VIEW dbo.vw_high_risk_customers AS
SELECT 
    CustomerId,
    CreditScore,
    Geography,
    Gender,
    Age,
    Balance,
    NumOfProducts,
    IsActiveMember,
    Exited
FROM dbo.customers
WHERE TRY_CAST(IsActiveMember AS INT) = 0
   OR TRY_CAST(CreditScore AS INT) < 500
   OR TRY_CAST(Age AS INT) > 50;
GO

-- View checks
SELECT * FROM dbo.vw_churn_by_geography;
SELECT * FROM dbo.vw_churn_by_age_group;
SELECT TOP 20 * FROM dbo.vw_high_risk_customers;
