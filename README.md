- S&OP Executive Dashboard — End-to-End Data Pipeline & Supply Chain Analytics

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![DBeaver](https://img.shields.io/badge/DBeaver-372923?style=for-the-badge&logo=dbeaver&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)


 - Visão Geral do Projeto

Este projeto consiste no desenvolvimento de uma solução end-to-end de engenharia de dados, modelagem relacional e business intelligence aplicada ao ciclo de S&OP (Sales and Operations Planning), utilizando o dataset público *DataCo Supply Chain* (93 MB).

O objetivo foi construir uma pipeline automatizada para tratar restrições de encoding, estruturar um modelo estelar (*Star Schema*) no banco de dados e entregar um dashboard executivo em página única no Power BI. O painel é voltado para o diagnóstico de nível de serviço logístico (OTIF / SLA), eficiência de transporte vs. armazém e exposição de receita a riscos operacionais.


 - Arquitetura da Solução & Pipeline de Dados

[ CSV Bruto (ISO-8859-1) ]
│
▼ (Python / Pandas / sqlite3)
[ Banco SQLite: stg_dataco_raw ]
│
▼ (DBeaver / SQL Star Schema & View)
[ Modelagem Estelar (fact_orders + dims) + vw_sop_otif_metrics ]
│
▼ (Python / Automated Export & Data Integrity Check)
[ Arquivos CSV Otimizados (UTF-8) ]
│
▼ (Power BI Data Model & DAX)
[ Dashboard Executivo S&OP (01_Visao_Geral_SOP) ]

 - Estrutura do Repositório
├── 01_dados_brutos/          # Dataset original (DataCoSupplyChainDataset.csv) [ISO-8859-1]
├── 02_scripts_sql/           # Banco SQLite (supply_chain.db) e Scripts DBeaver (Star Schema / Views)
├── 03_scripts_python/        # Scripts Python (Ingestão no SQLite, Validação e Exportação UTF-8)
└── 04_powerbi_dashboards/    # Arquivo .pbix e diretório de CSVs exportados (data_powerbi/)

  - Detalhamento Passo a Passo
    * 1. Ingestão & Tratamento de Encoding (Python / 01_ingestao.py)Para contornar divergências de caracteres (ISO-8859-1) em uma base volumosa de 93 MB:Leitura do arquivo CSV bruto via pandas.Conexão com o banco sqlite3 e carga na tabela de staging stg_dataco_raw.
    * 2. Modelagem Dimensional & Regras de Negócio (SQL / DBeaver)No DBeaver, os dados brutos da tabela staging foram normalizados em um modelo Star Schema (Esquema Estrela):Tabelas Dimensão: dim_products, dim_customers e dim_locations.Tabela Fato: fact_orders (dados de vendas, datas de pedido/envio, dias reais/agendados e métricas financeiras).View Analítica S&OP (vw_sop_otif_metrics): Parametrizou as regras de negócio para as flags de On-Time (entregas no prazo/antecipadas), In-Full (pedidos completos/não cancelados) e OTIF (interseção perfeita).
    * 3. Validação Programática & Exportação Otimizada (Python / 02_exportacao_powerbi.py)Auditoria de Integridade: Script executa consultas SQL em tempo de execução via Python para auditar as taxas globais de OTIF antes da exportação.Exportação UTF-8: Converte e salva cada tabela do modelo dimensional e a VIEW analítica em arquivos .csv padrão UTF-8 dentro da pasta data_powerbi/.
     * 4. Modelagem de Dados & Power BIModelagem: Conexão estelar $1:*$ da fact_orders com as dimensões (dim_products, dim_customers, dim_locations) através de chaves primárias/estrangeiras. A tabela vw_sop_otif_metrics permaneceu desacoplada como suporte analítico para as medidas de SLA.Power Query: Importação direta sem necessidade de etapas adicionais de tratamento, devido ao processamento prévio na esteira Python/SQL.


  - Medidas DAX Implementadas
// 1. Faturamento Total Consolidado
Faturamento Total = 
SUM(fact_orders[sales_amount])

// 2. Faturamento Exposto a Atrasos Logísticos
Faturamento Em Risco = 
CALCULATE(
    SUM(fact_orders[sales_amount]),
    fact_orders[delivery_status] = "Late delivery"
)

// 3. Volumetria Total de Pedidos
Total Pedidos = 
DISTINCTCOUNT(fact_orders[order_id])

// 4. Taxa de Pontualidade de Entrega (% On-Time)
On-Time % = 
VAR TotalPedidos = DISTINCTCOUNT(vw_sop_otif_metrics[order_id])
VAR PedidosOnTime = 
    CALCULATE(
        DISTINCTCOUNT(vw_sop_otif_metrics[order_id]),
        vw_sop_otif_metrics[is_ontime] = 1
    )
RETURN 
    DIVIDE(PedidosOnTime, TotalPedidos, 0)

// 5. Taxa de Pedidos Atendidos sem Cancelamento (% In-Full)
In-Full % = 
VAR TotalPedidos = DISTINCTCOUNT(vw_sop_otif_metrics[order_id])
VAR PedidosInFull = 
    CALCULATE(
        DISTINCTCOUNT(vw_sop_otif_metrics[order_id]),
        vw_sop_otif_metrics[is_infull] = 1
    )
RETURN 
    DIVIDE(PedidosInFull, TotalPedidos, 0)

// 6. Nível de Serviço Perfeito (% On-Time In-Full)
OTIF % = 
VAR TotalPedidos = DISTINCTCOUNT(vw_sop_otif_metrics[order_id])
VAR PedidosOTIF = 
    CALCULATE(
        DISTINCTCOUNT(vw_sop_otif_metrics[order_id]),
        vw_sop_otif_metrics[is_ontime] = 1,
        vw_sop_otif_metrics[is_infull] = 1
    )
RETURN 
    DIVIDE(PedidosOTIF, TotalPedidos, 0)

- Indicadores Globais & Diagnóstico de Negócio (S&OP Insights)
  
    Indicador            //           Valor Obtido        //            Diagnóstico Operacional
  
Faturamento Total       //            $33,05 Mi          // Receita bruta consolidada da operação global.
Faturamento em Risco    //            $18,08 Mi         //54,7% da receita total exposta a falhas/atrasos no cumprimento de SLA.
In-Full %               //             95,66%           // Alta eficiência do armazém e separação de estoque.
On-Time %               //             40,83%          //Gargalo severo na etapa de transporte e expedição.
OTIF %                  //              40,83%         //A eficiência final ao cliente é limitada diretamente pelos atrasos de frete.

 - Principais Descobertas Operacionais
 * Gargalo Concentrado no Transporte (Armazém vs. Frota): A taxa de separação em armazém é de 95,66% (In-Full), comprovando acurácia no picking e packaging. No entanto, a pontualidade da frota é de apenas 40,83% (On-Time), reduzindo o nível de serviço final para 40,83% OTIF.

 * Gargalo Crítico na Modalidade Expressa (First Class): O modal First Class registrou 0,00% de pontualidade, evidenciando descumprimento sistemático dos acordos de SLA por parte das transportadoras contratadas para o serviço expresso.

 * Exposição Financeira por Região: As regiões Europe ($9,8 Mi faturamento / $5,4 Mi em risco) e LATAM ($9,3 Mi faturamento / $5,0 Mi em risco) somam juntas mais de $10,4 Mi em receita vulnerável a atrasos.

 * Distribuição por Segmento Comercial: O segmento Consumer (B2C) representa $17,16 Mi (51,93%) do faturamento, seguido pelo segmento Corporate (B2B) com $10,03 Mi (30,35%).

 * Top Categorias em Receita: Os produtos da categoria Fishing lideram com $6,2 Mi, seguidos por Cleats ($4,0 Mi) e Camping & Hiking ($3,7 Mi).

 - Painel Executivo (Power BI)
Visualizando OTIF de "First Class"
<img width="1327" height="737" alt="otif_first_class" src="https://github.com/user-attachments/assets/5f728791-9820-4f5c-aabf-1d17e44c5639" />

Visualizando o faturamento total por cada categoria
<img width="1326" height="740" alt="faturamento_x_categoria" src="https://github.com/user-attachments/assets/f4980c6f-e2b4-4941-8285-874e8a37b54b" />

Visualizando o faturamento total pelo faturamento em risco
<img width="1321" height="738" alt="faturamento_total_x_em_risco" src="https://github.com/user-attachments/assets/f7e425b4-44fe-4b02-8021-dc962d55d831" />

Visualizando a distribuição por segmento de cliente
<img width="1322" height="741" alt="distribuicao_por_segmento" src="https://github.com/user-attachments/assets/61cbd09c-93b9-435c-9f3f-865e9444df63" />

Visualizando o dashboard completo na tela do PowerBI
<img width="1865" height="787" alt="dashboard_sop" src="https://github.com/user-attachments/assets/995b902f-1bff-4793-a1cb-10c36cfa6d79" />


 - Como Replicar este Projeto
1. Clone o repositório:
   
git clone [https://github.com/LuisAvila-MPY/Supply-Chain-Dashboard-DataCo---S-OP.git](https://github.com/LuisAvila-MPY/Supply-Chain-Dashboard-DataCo---S-OP.git)

2. Execute a esteira Python:

Coloque o arquivo bruto em 01_dados_brutos/DataCoSupplyChainDataset.csv.

Execute python 03_scripts_python/01_ingestao.py para criar o banco SQLite 02_scripts_sql/supply_chain.db.

 3. Execute os scripts SQL:

Abra o banco no DBeaver e rode as consultas da pasta 02_scripts_sql/ para estruturar o Star Schema e a View vw_sop_otif_metrics.

 4. Exporte e Abra no Power BI:

Execute python 03_scripts_python/02_exportacao_powerbi.py para gerar os CSVs em 04_powerbi_dashboards/data_powerbi/.

Abra o arquivo 04_powerbi_dashboards/sop_dashboard.pbix no Power BI Desktop.

 Autor
  - Luis Gustavo Ávila da Silva

[Linkedin] https://www.linkedin.com/in/luis-%C3%A1vila-25687134b/ | [Github] LuisAvila-MPY
 | [Currículo Lattes](https://lattes.cnpq.br/9470197971678821)
