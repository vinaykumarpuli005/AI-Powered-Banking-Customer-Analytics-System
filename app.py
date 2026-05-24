import joblib
import pandas as pd
import streamlit as st
from pathlib import Path

st.set_page_config(
    page_title="Banking Customer Analytics",
    layout="wide"
)

MODEL_PATH = Path(__file__).resolve().parent / "models" / "churn_model.pkl"

if not MODEL_PATH.exists():
    st.error("Model file not found. Please run the notebook first to create models/churn_model.pkl.")
    st.stop()

st.title("AI-Powered Banking Customer Analytics System")

st.sidebar.header("Customer Input")

credit_score = st.sidebar.number_input("Credit Score", 300, 900, 650)
geography = st.sidebar.selectbox("Geography", ["France", "Germany", "Spain"])
gender = st.sidebar.selectbox("Gender", ["Male", "Female"])
age = st.sidebar.number_input("Age", 18, 100, 35)
tenure = st.sidebar.number_input("Tenure", 0, 10, 3)
balance = st.sidebar.number_input("Balance", 0.0, 300000.0, 50000.0)
num_of_products = st.sidebar.number_input("Number of Products", 1, 4, 1)
has_cr_card = st.sidebar.selectbox("Has Credit Card", [1, 0])
is_active_member = st.sidebar.selectbox("Is Active Member", [1, 0])
estimated_salary = st.sidebar.number_input("Estimated Salary", 0.0, 300000.0, 75000.0)

col1, col2, col3, col4 = st.columns(4)

col1.metric("Credit Score", credit_score)
col2.metric("Age", age)
col3.metric("Balance", f"{balance:,.2f}")
col4.metric("Estimated Salary", f"{estimated_salary:,.2f}")

if st.button("Predict Churn Risk"):
    model_bundle = joblib.load(MODEL_PATH)

    input_data = pd.DataFrame([{
        "CreditScore": credit_score,
        "Geography": geography,
        "Gender": gender,
        "Age": age,
        "Tenure": tenure,
        "Balance": balance,
        "NumOfProducts": num_of_products,
        "HasCrCard": has_cr_card,
        "IsActiveMember": is_active_member,
        "EstimatedSalary": estimated_salary
    }])

    for column, encoder in model_bundle["encoders"].items():
        if column in input_data.columns:
            input_data[column] = encoder.transform(input_data[column])

    input_data = input_data[model_bundle["features"]]
    input_scaled = model_bundle["scaler"].transform(input_data)

    prediction = model_bundle["model"].predict(input_scaled)[0]
    probability = model_bundle["model"].predict_proba(input_scaled)[0][1]

    st.subheader("Prediction Result")

    if prediction == 1:
        st.error(f"High Churn Risk - Probability: {probability:.2%}")
    else:
        st.success(f"Low Churn Risk - Probability: {probability:.2%}")
    st.progress(float(probability))

st.subheader("Product Recommendations")

recommendations = []

if balance > 100000:
    recommendations.append("Premium Savings Account")

if credit_score > 700 and estimated_salary > 50000:
    recommendations.append("Credit Card Upgrade")

if age > 30 and tenure > 3:
    recommendations.append("Home Loan Offer")

if balance < 10000:
    recommendations.append("Financial Planning Assistance")

if not recommendations:
    recommendations.append("Standard Savings Account")

for product in recommendations:
    st.info(product)