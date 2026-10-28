# Plano de execução

| Etapa | Entrega | Evidência / saída |
|---|---|---|
| 0. Decisões e ambiente | repo, ferramentas, escopo e log de decisões | pré-requisitos e comandos registrados |
| 1. Validar fonte | manifesto Home Credit, termos, inventário, target/grão | ficha da fonte aprovada ou decisão de substituição |
| 2. Perfilamento | relatório de esquema, qualidade e cardinalidade | dicionário baseado nos arquivos reais |
| 3. Dados sintéticos | gerador com cenários, seed e versão | manifesto e resumo das distribuições |
| 4. Engenharia/SQL | staging, adaptadores, canonical e marts | reconciliação e execução idempotente |
| 5. EDA | análise de prevalência, faltantes, coortes e datas | relatório sem conclusões causais |
| 6. Target e validação | protocolo temporal, maturação e baselines | avaliação comparativa por período |
| 7. Modelo P0 | pipeline ML e registro de runs | artefato reproduzível e limitações |
| 8. P1 | explicações e monitoramento offline | relatório de interpretação, drift e desempenho maduro |
| 9. Entrega | README atualizado e demonstração reproduzível | checklist de aceite concluído |

O detalhamento, comandos e critérios de saída estão em [PROJECT_EXECUTION_GUIDE.md](PROJECT_EXECUTION_GUIDE.md). dbt, Airflow, API, MLflow, dashboard e UCI são extensões; só adicionar depois de concluir o fluxo básico.
