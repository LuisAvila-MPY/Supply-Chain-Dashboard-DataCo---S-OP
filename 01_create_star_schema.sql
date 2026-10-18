-- =====================================================================
-- PROJETO S&OP DATACO - STEP 1: CRIAÇÃO DO STAR SCHEMA (DDL)
-- Banco de Dados: SQLite (supply_chain.db)
-- =====================================================================

-- 1. Tabela Dimensão: Produtos
CREATE TABLE IF NOT EXISTS dim_products AS
SELECT DISTINCT
    "Product Card Id" AS product_id,
    "Product Name" AS product_name,
    "Category Id" AS category_id,
    "Category Name" AS category_name,
    "Department Id" AS department_id,
    "Department Name" AS department_name
FROM stg_dataco_raw;

-- 2. Tabela Dimensão: Clientes
CREATE TABLE IF NOT EXISTS dim_customers AS
SELECT DISTINCT
    "Customer Id" AS customer_id,
    "Customer Fname" || ' ' || "Customer Lname" AS customer_name,
    "Customer Segment" AS customer_segment,
    "Customer City" AS customer_city,
    "Customer State" AS customer_state,
    "Customer Country" AS customer_country
FROM stg_dataco_raw;

-- 3. Tabela Dimensão: Localidades
CREATE TABLE IF NOT EXISTS dim_locations AS
SELECT DISTINCT
    "Order City" AS order_city,
    "Order State" AS order_state,
    "Order Country" AS order_country,
    "Order Region" AS order_region,
    "Market" AS market
FROM stg_dataco_raw;

-- 4. Tabela Fato: Pedidos
CREATE TABLE IF NOT EXISTS fact_orders AS
SELECT
    "Order Item Id" AS order_item_id,
    "Order Id" AS order_id,
    "Product Card Id" AS product_id,
    "Customer Id" AS customer_id,
    "Order City" AS order_city,
    "Order State" AS order_state,
    "Order Country" AS order_country,
    
    -- Datas de Pedido e Envio
    "order date (DateOrders)" AS order_date,
    "shipping date (DateOrders)" AS shipping_date,
    
    -- Métricas Logísticas e S&OP
    "Days for shipping (real)" AS days_shipping_real,
    "Days for shipment (scheduled)" AS days_shipping_scheduled,
    "Late_risk" AS late_risk,
    "Delivery Status" AS delivery_status,
    
    -- Métricas Financeiras
    "Sales per customer" AS sales_amount,
    "Order Item Total" AS order_item_total,
    "Order Item Profit Ratio" AS profit_ratio,
    "Order Profit Per Order" AS profit_per_order,
    "Order Item Freight Closeout" AS freight_cost,
    "Order Item Quantity" AS quantity
FROM stg_dataco_raw;