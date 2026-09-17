CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    gender VARCHAR(20),
    age INT,
    city VARCHAR(100),
    state VARCHAR(100),
    region VARCHAR(50),
    customer_segment VARCHAR(50),
    registration_date DATE
);

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(150),
    category VARCHAR(100),
    sub_category VARCHAR(100),
    unit_price NUMERIC(12,2),
    cost_price NUMERIC(12,2)
);

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE,
    customer_id VARCHAR(20),
    payment_method VARCHAR(50),
    order_status VARCHAR(30),
    shipping_mode VARCHAR(30),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20),
    product_id VARCHAR(20),
    quantity INT,
    discount NUMERIC(5,2),
    unit_price NUMERIC(12,2),
    cost_price NUMERIC(12,2),
    revenue NUMERIC(14,2),
    cost NUMERIC(14,2),
    profit NUMERIC(14,2),
    profit_margin NUMERIC(8,4),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);



SELECT * FROM customers LIMIT 10;

SELECT * FROM products LIMIT 10;

SELECT * FROM orders LIMIT 10;

SELECT * FROM order_items LIMIT 10;



SELECT 'customers' AS table_name, COUNT(*) AS records FROM customers UNION ALL SELECT 'products', COUNT(*) FROM products UNION ALL SELECT 'orders', COUNT(*) FROM orders UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;

SELECT SUM(quantity) AS total_quantity FROM order_items;

SELECT ROUND(SUM(revenue), 2) AS total_revenue FROM order_items;

SELECT ROUND(SUM(cost), 2) AS total_cost FROM order_items;

SELECT ROUND(SUM(profit), 2) AS total_profit FROM order_items;

SELECT ROUND(SUM(profit) / NULLIF(SUM(revenue), 0) * 100, 2)AS profit_margin_percentage FROM order_items;




CREATE VIEW sales_analysis AS
SELECT
    o.order_id,
    o.order_date,
    c.customer_id,
    c.customer_name,
    c.gender,
    c.age,
    c.city,
    c.state,
    c.region,
    c.customer_segment,
    oi.order_item_id,
    oi.product_id,
    oi.quantity,
    oi.discount,
    oi.unit_price,
    oi.revenue,
    oi.cost,
    oi.profit,
    oi.profit_margin,
    p.product_name,
    p.category,
    p.sub_category,
    o.payment_method,
    o.order_status,
    o.shipping_mode
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

SELECT * FROM sales_analysis LIMIT 10;

SELECT COUNT(*) AS total_records FROM sales_analysis;

SELECT SUM(Revenue) AS total_revenue, SUM(Cost) AS total_cost, SUM(Profit) AS total_profit FROM sales_analysis;




SELECT SUM(Revenue) AS total_revenue, SUM(Cost) AS total_cost, SUM(Profit) AS total_profit, ROUND(SUM(Profit) / NULLIF(SUM(Revenue), 0) * 100, 2) AS profit_margin FROM sales_analysis;

SELECT DATE_TRUNC('month', Order_Date) AS month, SUM(Revenue) AS revenue, SUM(Profit) AS profit FROM sales_analysis 
GROUP BY DATE_TRUNC('month', Order_Date) ORDER BY month;

SELECT Product_ID, Product_Name, SUM(Quantity) AS units_sold, SUM(Revenue) AS revenue, SUM(Profit) AS profit FROM sales_analysis
GROUP BY Product_ID, Product_Name
ORDER BY revenue DESC
LIMIT 10;

SELECT Category, SUM(Quantity) AS units_sold, SUM(Revenue) AS revenue, SUM(Profit) AS profit FROM sales_analysis
GROUP BY Category
ORDER BY revenue DESC;

SELECT Customer_ID, Customer_Name, Customer_Segment, COUNT(DISTINCT Order_ID) AS orders, SUM(Revenue) AS revenue, SUM(Profit) AS profit FROM sales_analysis
GROUP BY Customer_ID, Customer_Name, Customer_Segment
ORDER BY revenue DESC
LIMIT 10;

SELECT Region, COUNT(DISTINCT Order_ID) AS orders, SUM(Revenue) AS revenue, SUM(Profit) AS profit FROM sales_analysis
GROUP BY Region
ORDER BY revenue DESC;



CREATE VIEW kpi_summary AS
SELECT
    COUNT(DISTINCT Order_ID) AS total_orders,
    COUNT(DISTINCT Customer_ID) AS total_customers,
    COUNT(DISTINCT Product_ID) AS total_products,
    SUM(Quantity) AS total_units_sold,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    ROUND(SUM(Cost), 2) AS total_cost,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Revenue), 0) * 100, 2) AS profit_margin
FROM sales_analysis;

SELECT * FROM kpi_summary;

CREATE VIEW monthly_performance AS
SELECT
    DATE_TRUNC('month', Order_Date)::date AS month,
    COUNT(DISTINCT Order_ID) AS orders,
    SUM(Quantity) AS units_sold,
    ROUND(SUM(Revenue), 2) AS revenue,
    ROUND(SUM(Profit), 2) AS profit
FROM sales_analysis
GROUP BY DATE_TRUNC('month', Order_Date)
ORDER BY month;

SELECT * FROM monthly_performance;

CREATE VIEW product_performance AS
SELECT 
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    SUM(Quantity) AS units_sold,
    ROUND(SUM(Revenue), 2) AS revenue,
    ROUND(SUM(Profit), 2) AS profit
FROM sales_analysis
GROUP BY Product_ID, Product_Name, Category, Sub_Category
ORDER BY revenue DESC;

SELECT * FROM product_performance;