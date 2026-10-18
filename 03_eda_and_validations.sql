-- =====================================================================
-- PROJETO S&OP DATACO - STEP 3: CONSULTAS DE AUDITORIA E ANÁLISE EXPLORATÓRIA (EDA)
-- =====================================================================

-- 1. Validação de volumetria na Staging
SELECT 
    COUNT(*) AS total_registros,
    COUNT(DISTINCT "Order Id") AS total_pedidos_unicos
FROM stg_dataco_raw;

-- 2. Validação de volumetria nas Tabelas Dimensão
SELECT 'dim_products' AS tabela, COUNT(*) AS total_linhas FROM dim_products
UNION ALL
SELECT 'dim_customers', COUNT(*) FROM dim_customers
UNION ALL
SELECT 'dim_locations', COUNT(*) FROM dim_locations;

-- 3. Validação de volumetria na Tabela Fato
SELECT COUNT(*) AS total_fatos FROM fact_orders;

-- 4. Diagnóstico de Nível de Serviço Logístico Global (OTIF %)
WITH order_level AS (
    SELECT 
        order_id,
        MAX(is_ontime) AS is_ontime,
        MAX(is_infull) AS is_infull,
        MAX(is_otif) AS is_otif
    FROM vw_sop_otif_metrics
    GROUP BY order_id
)
SELECT 
    COUNT(*) AS total_pedidos,
    ROUND(100.0 * AVG(is_ontime), 2) AS taxa_ontime_pct,
    ROUND(100.0 * AVG(is_infull), 2) AS taxa_infull_pct,
    ROUND(100.0 * AVG(is_otif), 2) AS taxa_otif_pct
FROM order_level;

-- 5. Análise de Faturamento e Prazos por Status de Entrega
SELECT 
    delivery_status AS status_entrega,
    COUNT(DISTINCT order_id) AS total_pedidos,
    ROUND(SUM(sales_amount), 2) AS faturamento_total,
    ROUND(AVG(days_shipping_real), 2) AS media_dias_reais,
    ROUND(AVG(days_shipping_scheduled), 2) AS media_dias_programados
FROM fact_orders
GROUP BY delivery_status
ORDER BY total_pedidos DESC;

-- 6. Performance e Desempenho por Modalidade de Frete
SELECT 
    raw."Shipping Mode" AS modalidade_frete,
    COUNT(DISTINCT f.order_id) AS total_pedidos,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN f.delivery_status = 'Late delivery' THEN f.order_id END) / COUNT(DISTINCT f.order_id), 
        2
    ) AS taxa_atraso_pct,
    ROUND(AVG(f.days_shipping_real), 2) AS media_dias_reais,
    ROUND(AVG(f.days_shipping_scheduled), 2) AS media_dias_programados,
    ROUND(SUM(f.sales_amount), 2) AS faturamento_total
FROM fact_orders f
JOIN stg_dataco_raw raw ON f.order_item_id = raw."Order Item Id"
GROUP BY raw."Shipping Mode"
ORDER BY taxa_atraso_pct DESC;

-- 7. Análise de Impacto Financeiro e Risco por Mercado
SELECT 
    l.market AS mercado,
    COUNT(DISTINCT f.order_id) AS total_pedidos,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN f.delivery_status = 'Late delivery' THEN f.order_id END) / COUNT(DISTINCT f.order_id), 
        2
    ) AS taxa_atraso_pct,
    ROUND(SUM(f.sales_amount), 2) AS faturamento_total,
    ROUND(AVG(f.days_shipping_real), 2) AS media_dias_reais
FROM fact_orders f
JOIN dim_locations l ON f.order_city = l.order_city 
                    AND f.order_state = l.order_state 
                    AND f.order_country = l.order_country
GROUP BY l.market
ORDER BY taxa_atraso_pct DESC;

-- 8. Análise por Segmento de Cliente
SELECT 
    c.customer_segment AS segmento_cliente,
    COUNT(DISTINCT f.order_id) AS total_pedidos,
    ROUND(SUM(f.sales_amount), 2) AS faturamento_total,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN f.delivery_status = 'Late delivery' THEN f.order_id END) / COUNT(DISTINCT f.order_id), 
        2
    ) AS taxa_atraso_pct,
    ROUND(AVG(f.days_shipping_real), 2) AS media_dias_reais,
    ROUND(AVG(f.days_shipping_scheduled), 2) AS media_dias_programados
FROM fact_orders f
JOIN dim_customers c ON f.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY total_pedidos DESC;

-- 9. Top 10 Categorias por Faturamento e Margem
SELECT 
    p.category_name AS categoria,
    COUNT(DISTINCT f.order_id) AS total_pedidos,
    ROUND(SUM(f.sales_amount), 2) AS faturamento,
    ROUND(SUM(f.freight_cost), 2) AS custo_total_frete,
    ROUND(AVG(f.profit_ratio) * 100, 2) AS margem_lucro_media_pct,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN f.delivery_status = 'Late delivery' THEN f.order_id END) / COUNT(DISTINCT f.order_id), 
        2
    ) AS taxa_atraso_pct
FROM fact_orders f
JOIN dim_products p ON f.product_id = p.product_id
GROUP BY p.category_name
ORDER BY faturamento DESC
LIMIT 10;