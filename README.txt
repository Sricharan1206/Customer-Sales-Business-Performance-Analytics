# Customer Sales & Business Performance Analytics

## 📊 Project Overview

This project analyzes customer sales and business performance using **Python, Pandas, PostgreSQL, SQL, and Excel**.

The project follows an end-to-end data analytics workflow:

**Raw Data → Data Cleaning & Validation → Data Transformation → SQL Data Modeling → Business Analysis → KPI Analysis → Excel Dashboard**

The objective is to transform raw transactional data into meaningful business insights related to **sales, revenue, profit, customers, products, categories, regions, and monthly performance**.

---

## 🎯 Project Objectives

* Clean and validate raw business data using Python/Pandas
* Handle missing values and duplicate records
* Standardize inconsistent text values
* Validate numerical and business rules
* Build a relational data model using SQL
* Combine customer, order, product, and order-item information
* Calculate revenue, cost, profit, and profit margin
* Analyze overall business KPIs
* Analyze monthly sales and profit performance
* Identify high-performing products
* Analyze customer performance
* Compare category and regional performance
* Prepare data for business reporting and dashboarding

---

## 🛠️ Technologies Used

| Technology          | Purpose                                                  |
| ------------------- | -------------------------------------------------------- |
| **Python**          | Data preprocessing and validation                        |
| **Pandas**          | Data cleaning, transformation and analysis               |
| **PostgreSQL**      | Relational database and SQL analysis                     |
| **SQL**             | Data modeling, joins, aggregations and business analysis |
| **Microsoft Excel** | KPI reporting and dashboard development                  |
| **Git/GitHub**      | Version control and project documentation                |

---

## 📁 Dataset

The project uses four related datasets:

| Dataset           | Records | Description                     |
| ----------------- | ------: | ------------------------------- |
| `customers.csv`   |   5,010 | Customer information            |
| `products.csv`    |     200 | Product and pricing information |
| `orders.csv`      |  20,000 | Order-level information         |
| `order_items.csv` |  40,000 | Individual items within orders  |

The dataset covers approximately **January 1, 2024 to June 30, 2026**.

---

## 🔗 Data Relationships

The datasets are connected using primary and foreign key relationships:

```text
Customers
    │
    │ Customer_ID
    ▼
Orders
    │
    │ Order_ID
    ▼
Order_Items
    │
    │ Product_ID
    ▼
Products
```

Relationships:

```text
customers.Customer_ID
        ↓
orders.Customer_ID

orders.Order_ID
        ↓
order_items.Order_ID

products.Product_ID
        ↓
order_items.Product_ID
```

These relationships are implemented in the SQL data model using primary keys and foreign keys.

---

# 🔄 Project Workflow

## Step 1 — Data Preprocessing with Python/Pandas

The raw CSV datasets are loaded into Pandas for inspection, cleaning, validation, and transformation.

### Data Inspection

The preprocessing workflow checks:

* Dataset dimensions
* Column names
* Data types
* Missing values
* Duplicate records
* Numerical distributions
* Invalid values
* Categorical consistency

The project converts date columns such as `Order_Date` and `Registration_Date` to appropriate datetime formats.

### Data Quality Issues

The original dataset intentionally contains several data-quality issues:

* Duplicate customer records
* Missing city values
* Missing payment-method values
* Missing discount values
* Inconsistent capitalization and whitespace in region/category values

These issues are addressed during preprocessing.

### Cleaning Operations

Examples of preprocessing performed:

```python
# Handle missing city
customers = customers.fillna({
    "City": "Unknown"
})

# Handle missing payment method
orders["Payment_Method"] = orders["Payment_Method"].fillna("Unknown")

# Handle missing discount
order_items["Discount"] = order_items["Discount"].fillna(0)

# Remove duplicate customers
customers = customers.drop_duplicates()

# Standardize region values
customers["Region"] = (
    customers["Region"]
    .str.strip()
    .str.title()
)
```

### Data Validation

The project also checks:

* Product pricing statistics
* Quantity distributions
* Discount ranges
* Quantity values less than or equal to zero
* Discount values outside the expected range
* Relationships between order items and products

---

# 🧮 Business Metrics

The project uses the following business calculations:

### Revenue

```text
Revenue = Quantity × Unit Price × (1 − Discount)
```

### Cost

```text
Cost = Quantity × Cost Price
```

### Profit

```text
Profit = Revenue − Cost
```

### Profit Margin

```text
Profit Margin = Profit / Revenue
```

These calculations are part of the project's defined business metrics.

---

# 🗄️ Step 2 — SQL Data Modeling

The cleaned datasets are modeled as relational tables:

```text
customers
products
orders
order_items
```

The SQL schema defines primary keys and foreign keys to maintain relationships between the tables.

### Main Tables

#### Customers

Contains:

* Customer ID
* Customer Name
* Gender
* Age
* City
* State
* Region
* Customer Segment
* Registration Date

#### Products

Contains:

* Product ID
* Product Name
* Category
* Sub Category
* Unit Price
* Cost Price

#### Orders

Contains:

* Order ID
* Order Date
* Customer ID
* Payment Method
* Order Status
* Shipping Mode

#### Order Items

Contains:

* Order Item ID
* Order ID
* Product ID
* Quantity
* Discount
* Unit Price
* Cost Price
* Revenue
* Cost
* Profit
* Profit Margin

---

# 🔗 SQL Business Analysis View

A consolidated `sales_analysis` view is created by joining:

```text
Orders
   ↓
Customers
   ↓
Order_Items
   ↓
Products
```

The view combines customer, order, product, sales, profitability, payment, order-status, and shipping information into a single analytical dataset.

This makes it easier to perform business analysis without repeatedly writing the same joins.

---

# 📈 Business Analysis

The SQL analysis covers multiple business dimensions.

## 1. Overall Business KPIs

The project calculates:

* Total Orders
* Total Customers
* Total Products
* Total Units Sold
* Total Revenue
* Total Cost
* Total Profit
* Profit Margin

A dedicated `kpi_summary` view is created for these metrics. _
