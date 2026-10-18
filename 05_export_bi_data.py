import sqlite3
import pandas as pd
import os

# 1. Conexão com o banco SQLite
db_path = "supply_chain.db"
output_dir = "data_powerbi"

# Criar pasta de saída se não existir
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

conn = sqlite3.connect(db_path)

print("--- INICIANDO PIPELINE DE EXPORTAÇÃO PARA POWER BI ---")

# 2. Validação da VIEW OTIF via Python
query_otif = """
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
"""

df_otif_check = pd.read_sql_query(query_otif, conn)
print("\n[VALIDAÇÃO DE DADOS - OTIF CHECK]:")
print(df_otif_check)

# 3. Mapeamento das tabelas e VIEWs para exportação
tables_to_export = {
    "dim_products": "SELECT * FROM dim_products;",
    "dim_customers": "SELECT * FROM dim_customers;",
    "dim_locations": "SELECT * FROM dim_locations;",
    "fact_orders": "SELECT * FROM fact_orders;",
    "vw_sop_otif_metrics": "SELECT * FROM vw_sop_otif_metrics;"
}

# 4. Loop de exportação automatizada
print("\n[EXPORTANDO TABELAS PARA CSV]:")
for table_name, sql_query in tables_to_export.items():
    df = pd.read_sql_query(sql_query, conn)
    file_path = os.path.join(output_dir, f"{table_name}.csv")
    df.to_csv(file_path, index=False, encoding="utf-8")
    print(f"✔ {table_name}.csv exportado com sucesso! ({len(df)} linhas)")

conn.close()
print("\n--- PROCESSO CONCLUÍDO COM SUCESSO! DADOS PRONTOS PARA O POWER BI ---")