-- =====================================================================
-- PROJETO S&OP DATACO - STEP 2: VIEW ANALÍTICA DE S&OP E METRICAS OTIF
-- =====================================================================

CREATE VIEW IF NOT EXISTS vw_sop_otif_metrics AS
SELECT 
    f.order_id,
    f.order_date,
    f.delivery_status,
    raw."Shipping Mode" AS shipping_mode,
    l.market,
    f.sales_amount,
    
    -- Flag On-Time: 1 se entregue no prazo ou adiantado, 0 se atrasado
    CASE 
        WHEN f.delivery_status IN ('Shipping on time', 'Advance shipping') THEN 1 
        ELSE 0 
    END AS is_ontime,
    
    -- Flag In-Full: 1 se pedido não foi cancelado, 0 se cancelado
    CASE 
        WHEN f.delivery_status != 'Shipping canceled' THEN 1 
        ELSE 0 
    END AS is_infull,
    
    -- Flag OTIF Perfeito: 1 se for no prazo E não cancelado
    CASE 
        WHEN f.delivery_status IN ('Shipping on time', 'Advance shipping') 
         AND f.delivery_status != 'Shipping canceled' THEN 1 
        ELSE 0 
    END AS is_otif
FROM fact_orders f
JOIN stg_dataco_raw raw ON f.order_item_id = raw."Order Item Id"
JOIN dim_locations l ON f.order_city = l.order_city 
                    AND f.order_state = l.order_state 
                    AND f.order_country = l.order_country;