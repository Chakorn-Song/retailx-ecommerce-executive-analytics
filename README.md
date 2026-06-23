# RetailX Executive Analytics Platform

Welcome to the **RetailX Executive Analytics Platform** portfolio project. This repository contains an end-to-end data analytics and business intelligence solution designed to mimic a real-world analytics environment in a large-scale e-commerce organization.

The platform utilizes the **Brazilian E-Commerce Public Dataset by Olist** and integrates multiple external sources (weather, demographics, macroeconomics, holidays) to build a relational star schema that powers modular Jupyter notebooks and an interactive **Streamlit dashboard**.

---

## Business Overview & Goals

RetailX connects local Brazilian sellers with online buyers. C-level executives face challenges in customer retention, high logistics costs, low cross-selling, and inventory management.

This platform provides:
1.  **Executive Dashboard**: A single source of truth for high-level business indicators (GMV, AOV, Orders) combined with macroeconomic conditions.
2.  **Customer Analytics**: Advanced segmentation (RFM Clustering) and Predictive Customer Lifetime Value (CLV).
3.  **Product & Cross-Selling Insights**: Market Basket Analysis (Association Rules) to increase average ticket sizes.
4.  **Operational Logistics Control**: Delivery latency modeling, seller SLA tracking, and shipping cost optimization.
5.  **Forward-Looking Sales Forecasting**: Time-series models (Prophet/SARIMAX) integrating external drivers like paydays, holidays, and weather.

---

## Technology Stack & Architecture

*   **Database**: PostgreSQL (Structured in a Kimball Star Schema)
*   **Analytics & Machine Learning**: Python (Pandas, Scikit-Learn, Statsmodels, Lifetimes, Prophet, Apyori)
*   **Web Dashboard**: Streamlit (Multi-page interactive application)
*   **Knowledge Base**: Obsidian (Vault located in `top1_project/`) including:
    *   [RetailX Executive BI Platform (TH)](file:///c:/Users/White/OneDrive/Desktop/git/olist-ecommerce-analytics/top1_project/03.%20Business%20Strategy/RetailX%20Executive%20BI%20Platform%20%28TH%29.md) — Business overview and decision-making scenarios.
    *   [Power BI Sales Dashboard Guide (TH)](file:///c:/Users/White/OneDrive/Desktop/git/olist-ecommerce-analytics/top1_project/03.%20Business%20Strategy/Power%20BI%20Sales%20Dashboard%20Guide%20%28TH%29.md) — Step-by-step developer tutorial.

### Data Model & Schema

The platform contains documentation for both the original transactional database and the analytical Kimball Star Schema:
*   **Original Transactional Schema**: Documented in [[Source Data Model (Raw)]] / [Source Data Model (Raw)](file:///c:/Users/White/OneDrive/Desktop/git/olist-ecommerce-analytics/top1_project/01.%20Data%20Architecture/Source%20Data%20Model%20%28Raw%29.md) representing Olist's 9 raw source tables.
*   **Kimball Star Schema**: Detailed in [Data Model (Star Schema)](file:///c:/Users/White/OneDrive/Desktop/git/olist-ecommerce-analytics/top1_project/01.%20Data%20Architecture/Data%20Model%20%28Star%20Schema%29.md) connecting transactional records with contextual data tables:
    *   **Fact Table**: `fact_sales` (Sales, prices, freight values, order timestamps)
    *   **Dimension Tables**:
        *   `dim_customer` / `dim_seller`: Customer and seller geographic attributes.
        *   `dim_product`: Product dimensions, weights, and categories.
        *   `dim_date`: Unified calendar with holiday tags and payday flags.
        *   `dim_demographics`: Brazilian state-level population, GDP, and HDI.
        *   `dim_weather`: Daily average temperature and precipitation in key metropolitan regions.
        *   `dim_macroeconomics`: Monthly Selic interest rates and inflation (IPCA).

---

## Project Structure

The repository is organized as follows:

```
olist-ecommerce-analytics/
│
├── .agents/                    # Workspace agent guidelines & rules
│   └── AGENTS.md
│
├── sql/                        # SQL scripts for data marts & schema
│   ├── add_key.sql             # Script to define primary and foreign keys
│   ├── dim_customer.sql        # Dimension table for customers
│   ├── dim_product.sql         # Dimension table for products
│   ├── dim_seller.sql          # Dimension table for sellers
│   ├── fact_sales.sql          # Core fact table for transaction lines
│   ├── fact_sale_star.sql      # Star schema assembly script
│   └── marts/                  # Performance-optimized views and materialized views
│       ├── mv_sales_customer_daily.sql
│       ├── mv_sales_daily.sql
│       ├── mv_sales_geo_daily.sql
│       ├── mv_sales_product_daily.sql
│       ├── mv_sales_seller_daily.sql
│       └── vw_mart_opetations_logistics.sql
│
├── notebooks/                  # Modular Python analysis & ML pipelines
│   ├── 01_customer_segmentation_rfm.ipynb
│   ├── 02_cohort_retention_clv.ipynb
│   ├── 03_market_basket_analysis.ipynb
│   ├── 04_logistics_operations.ipynb
│   ├── 05_sales_forecasting.ipynb
│   └── 06_recommendation_engine.ipynb
│
├── dashboard/                  # Streamlit Interactive Dashboard
│   ├── app.py                  # Streamlit entry point
│   └── pages/                  # Interactive pages
│       ├── 1_Executive_Overview.py
│       ├── 2_Customer_Insights.py
│       ├── 3_Product_Performance.py
│       ├── 4_Logistics_Operations.py
│       └── 5_Forecasting_Recommendations.py
│
├── top1_project/               # Obsidian Vault for Executive Documentation
│   ├── 00. Project Overview/   # Project briefs and KPI frameworks
│   ├── 01. Data Architecture/  # Data dictionaries, raw schemas, and star schemas
│   ├── 02. Analysis Modules/   # Deep-dive reports on algorithms
│   └── 03. Business Strategy/  # Executive strategic recommendations
│
├── pass.env                    # PostgreSQL database credentials (git-ignored locally)
└── README.md                   # Project cover page (this file)
```

---

## Setup & Installation

### 1. Database Connection
Create a `pass.env` file in the root directory with your PostgreSQL connection parameters:
```env
DB_TYPE=postgresql
DB_USER=your_username
DB_PASS=your_password
DB_HOST=localhost
DB_PORT=5432
DB_NAME=ecommerce_olist
```

### 2. Install Dependencies
Install Python libraries required for data extraction, machine learning, and visualization:
```bash
pip install pandas numpy sqlalchemy psycopg2 python-dotenv meteostat holidays yfinance requests streamlit matplotlib seaborn scikit-learn prophet lifetimes apyori
```

### 3. Run Notebooks
Extract data pipelines and run analytics notebooks in order inside the `notebooks/` directory.

### 4. Start the Interactive Dashboard
Launch the Streamlit dashboard app:
```bash
streamlit run dashboard/app.py
```
