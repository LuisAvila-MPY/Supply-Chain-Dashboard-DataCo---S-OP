<h1 align="center">
  S&OP Executive Dashboard — End-to-End Data Pipeline & Supply Chain Analytics
</h1>

<p align="center">
  <b>Engenharia de Dados, Modelagem Estelar SQL e Business Intelligence Aplicados ao Ciclo de Sales and Operations Planning</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black" alt="Power BI">
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python">
  <img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite">
  <img src="https://img.shields.io/badge/DBeaver-372923?style=for-the-badge&logo=dbeaver&logoColor=white" alt="DBeaver">
  <img src="https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white" alt="Pandas">
</p>

<p align="center">
  <a href="#visao-geral-do-projeto">Visao Geral</a> •
  <a href="#indicadores-globais--diagnostico-de-negocio">KPIs Globais</a> •
  <a href="#painel-executivo-power-bi">Painel Executivo</a> •
  <a href="#principais-descobertas-operacionais">Descobertas Operacionais</a> •
  <a href="#arquitetura-da-solucao--pipeline-de-dados">Arquitetura</a> •
  <a href="#detalhamento-passo-a-passo">Passo a Passo</a> •
  <a href="#medidas-dax-implementadas">Medidas DAX</a> •
  <a href="#estrutura-do-repositorio">Estrutura</a> •
  <a href="#como-replicar-este-projeto">Como Replicar</a> •
  <a href="#autor">Autor</a>
</p>

---

## Visao Geral do Projeto

Este projeto consiste no desenvolvimento de uma solucao end-to-end de engenharia de dados, modelagem relacional e business intelligence aplicada ao ciclo de Sales and Operations Planning (S&OP), utilizando o dataset publico DataCo Supply Chain (93 MB).

O objetivo principal foi construir uma pipeline automatizada para tratar restricoes de encoding, estruturar um modelo estelar (Star Schema) em banco de dados SQLite e entregar um dashboard executivo no Power BI. O painel e voltado para o diagnostico de nivel de servico logistico (OTIF / SLA), eficiencia de transporte versus armazem e exposicao de receita a riscos operacionais.

---

## Indicadores Globais & Diagnostico de Negocio

<table align="center">
  <tr>
    <td align="center" width="25%">
      <b>Faturamento Total</b><br>
      <sub>Receita Consolidada</sub><br>
      <h2>$33,05 Mi</h2>
      <sub>Operacao global</sub>
    </td>
    <td align="center" width="25%">
      <b>Faturamento em Risco</b><br>
      <sub>Exposicao a Atrasos</sub><br>
      <h2>$18,08 Mi</h2>
      <sub>54,7% do total</sub>
    </td>
    <td align="center" width="25%">
      <b>Taxa In-Full %</b><br>
      <sub>Eficiencia Armazem</sub><br>
      <h2>95,66%</h2>
      <sub>Acuracia de separacao</sub>
    </td>
    <td align="center" width="25%">
      <b>Nivel OTIF % / On-Time %</b><br>
      <sub>Servico Perfeito</sub><br>
      <h2>40,83%</h2>
      <sub>Gargalo de transporte</sub>
    </td>
  </tr>
</table>

| Indicador | Valor Obtido | Diagnostico Operacional |
| :--- | :---: | :--- |
| **Faturamento Total** | **$33,05 Mi** | Receita bruta consolidada da operacao global. |
| **Faturamento em Risco** | **$18,08 Mi** | 54,7% da receita total exposta a falhas/atrasos no cumprimento de SLA. |
| **In-Full %** | **95,66%** | Alta eficiencia do armazem e separacao de estoque. |
| **On-Time %** | **40,83%** | Gargalo severo na etapa de transporte e expedicao. |
| **OTIF %** | **40,83%** | A eficiencia final ao cliente e limitada diretamente pelos atrasos de frete. |

---

## Painel Executivo (Power BI)

### 1. Visao Geral Consolidada
Painel em pagina unica projetado para suporte a tomada de decisao executiva em reunioes de S&OP, integrando metricas de receita, nivel de servico OTIF e distribuicao geografica/comercial.

<p align="center">
  <img src="https://github.com/user-attachments/assets/995b902f-1bff-4793-a1cb-10c36cfa6d79" alt="Dashboard Executivo S&OP Completo" width="95%">
  <br>
  <em>Figura 1: Visao Geral do Dashboard Executivo S&OP no Power BI.</em>
</p>

---

### 2. Analises Especificas & Drill-down Operational

#### Analise de Nivel de Servico OTIF por Modalidade Expressa (First Class)
Identificacao de descumprimento critico de SLA na modalidade de frete expresso.

<p align="center">
  <img src="https://github.com/user-attachments/assets/5f728791-9820-4f5c-aabf-1d17e44c5639" alt="Visualizacao de OTIF no First Class" width="90%">
  <br>
  <em>Figura 2: Diagnostico de OTIF no modal First Class atingindo 0,00% de pontualidade.</em>
</p>

---

#### Concentracao de Faturamento por Categoria de Produto
Mapeamento das principais categorias geradoras de receita no portfólio.

<p align="center">
  <img src="https://github.com/user-attachments/assets/f4980c6f-e2b4-4941-8285-874e8a37b54b" alt="Faturamento Total por Categoria" width="90%">
  <br>
  <em>Figura 3: Distribuicao de receita bruta entre as principais categorias comerciais.</em>
</p>

---

#### Relacao entre Faturamento Total e Faturamento em Risco
Exposicao financeira acumulada devido a atrasos de entrega na malha logistica.

<p align="center">
  <img src="https://github.com/user-attachments/assets/f7e425b4-44fe-4b02-8021-dc962d55d831" alt="Faturamento Total x Faturamento em Risco" width="90%">
  <br>
  <em>Figura 4: Proporcao de receita exposta a falhas de cumprimento de prazo de entrega.</em>
</p>

---

#### Distribuicao de Vendas por Segmento de Cliente
Decomposicao da receita entre os canais Consumer, Corporate e Home Office.

<p align="center">
  <img src="https://github.com/user-attachments/assets/61cbd09c-93b9-435c-9f3f-865e9444df63" alt="Distribuicao por Segmento de Cliente" width="90%">
  <br>
  <em>Figura 5: Volume financeiro distribuido por perfil de segmento comercial.</em>
</p>

---

## Principais Descobertas Operacionais

* **Gargalo Concentrado no Transporte (Armazem vs. Frota)**: A taxa de separacao em armazem e de 95,66% (In-Full), comprovando acuracia no picking e packaging. No entanto, a pontualidade da frota e de apenas 40,83% (On-Time), reduzindo o nivel de servico final para 40,83% OTIF.
* **Gargalo Critico na Modalidade Expressa (First Class)**: O modal First Class registrou 0,00% de pontualidade, evidenciando descumprimento sistematico dos acordos de SLA por parte das transportadoras contratadas para o servico expresso.
* **Exposicao Financeira por Regiao**: As regioes Europe ($9,8 Mi faturamento / $5,4 Mi em risco) e LATAM ($9,3 Mi faturamento / $5,0 Mi em risco) somam juntas mais de $10,4 Mi em receita vulneravel a atrasos.
* **Distribuicao por Segmento Comercial**: O segmento Consumer (B2C) representa $17,16 Mi (51,93%) do faturamento, seguido pelo segmento Corporate (B2B) com $10,03 Mi (30,35%).
* **Top Categorias em Receita**: Os produtos da categoria Fishing lideram com $6,2 Mi, seguidos por Cleats ($4,0 Mi) e Camping & Hiking ($3,7 Mi).

---

## Arquitetura da Solucao & Pipeline de Dados

```text
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
[ Dashboard Executivo S&OP ]
```
- Detalhamento Passo a Passo
  * 1. Ingestao & Tratamento de Encoding (Python / 01_ingestao.py)Para contornar divergencias de caracteres (ISO-8859-1) em uma base volumosa de 93 MB:Leitura do arquivo CSV bruto via pandas tratando a codificacao original.Conexao com o banco sqlite3 e carga na tabela de staging stg_dataco_raw.
  * 2. Modelagem Dimensional & Regras de Negocio (SQL / DBeaver)No DBeaver, os dados brutos da tabela staging foram normalizados em um modelo Star Schema (Esquema Estrela):Tabelas Dimensao: dim_products, dim_customers e dim_locations.Tabela Fato: fact_orders (dados de vendas, datas de pedido/envio, dias reais/agendados e metricas financeiras).View Analitica S&OP (vw_sop_otif_metrics): Parametrizou as regras de negocio para as flags de On-Time (entregas no prazo/antecipadas), In-Full (pedidos completos/nao cancelados) e OTIF (intersecao perfeita).
  * 3. Validacao Programatica & Exportacao Otimizada (Python / 02_exportacao_powerbi.py)Auditoria de Integridade: Script executa consultas SQL em tempo de execucao via Python para auditar as taxas globais de OTIF antes da exportacao.Exportacao UTF-8: Converte e salva cada tabela do modelo dimensional e a VIEW analitica em arquivos .csv padrao UTF-8 dentro da pasta data_powerbi/.
  * 4. Modelagem de Dados & Power BIModelagem Relacional: Conexao estelar $1:*$ da fact_orders com as dimensoes (dim_products, dim_customers, dim_locations) atraves de chaves primarias/estrangeiras. A tabela vw_sop_otif_metrics permaneceu desacoplada como suporte analitico para as medidas de SLA.Power Query: Importacao direta sem necessidade de etapas adicionais de tratamento, devido ao processamento previo na esteira Python/SQL.Medidas

 - DAX Implementadas
// 1. Faturamento Total Consolidado
Faturamento Total = 
SUM(fact_orders[sales_amount])

// 2. Faturamento Exposto a Atrasos Logisticos
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

// 6. Nivel de Servico Perfeito (% On-Time In-Full)
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
.

## Estrutura do Repositorio

```text
Supply-Chain-Dashboard-DataCo---S-OP/
├── 01_dados_brutos/
│   └── DataCoSupplyChainDataset.csv
├── 02_scripts_sql/
│   ├── supply_chain.db
│   └── star_schema_views.sql
├── 03_scripts_python/
│   ├── 01_ingestao.py
│   └── 02_exportacao_powerbi.py
└── 04_powerbi_dashboards/
    ├── sop_dashboard.pbix
    └── data_powerbi/

```
- Como Replicar este Projeto
1. Clonar o Repositorio
git clone [https://github.com/LuisAvila-MPY/Supply-Chain-Dashboard-DataCo---S-OP.git](https://github.com/LuisAvila-MPY/Supply-Chain-Dashboard-DataCo---S-OP.git)
cd Supply-Chain-Dashboard-DataCo---S-OP

2. Executar a Esteira Python (Ingestao)
Posicione o arquivo bruto baixado em 01_dados_brutos/DataCoSupplyChainDataset.csv.

Execute o script de carga inicial:
python 03_scripts_python/01_ingestao.py

3. Executar os Scripts SQL
Abra o banco criado em 02_scripts_sql/supply_chain.db no DBeaver e execute as consultas para estruturar o Star Schema e a View vw_sop_otif_metrics.

4. Exportar Dados e Abrir no Power BI
Execute o script de exportacao e verificacao de integridade:
python 03_scripts_python/02_exportacao_powerbi.py

Abra o arquivo 04_powerbi_dashboards/sop_dashboard.pbix no Power BI Desktop.


 Autor
  - Luis Gustavo Ávila da Silva

[Linkedin] https://www.linkedin.com/in/luis-%C3%A1vila-25687134b/ | [Github] LuisAvila-MPY
 | [Currículo Lattes](https://lattes.cnpq.br/9470197971678821)
