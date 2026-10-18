import pandas as pd
import sqlite3
import os

# Caminhos dos arquivos
csv_path = os.path.join("..", "01_dados_brutos", "DataCoSupplyChainDataset.csv")
db_path = os.path.join("..", "02_scripts_sql", "supply_chain.db")

print("1/3 - Lendo o arquivo CSV de 93 MB (pode levar alguns segundos)...")
df = pd.read_csv(csv_path, encoding="ISO-8859-1")
print(f"CSV carregado com sucesso! Total de linhas: {len(df)}")

print("2/3 - Conectando ao banco SQLite...")
conn = sqlite3.connect(db_path)

print("3/3 - Salvando os dados no banco SQLite...")
df.to_sql("stg_dataco_raw", conn, if_exists="replace", index=False)

conn.close()
print("\n>>> Sucesso! Banco 'supply_chain.db' criado e carregado na pasta 02_scripts_sql. <<<")