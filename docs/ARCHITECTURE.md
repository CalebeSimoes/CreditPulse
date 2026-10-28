# Arquitetura

| Camada | P0 | Evolução |
|---|---|---|
| Fontes | Home Credit candidato validado + gerador sintético | UCI como benchmark separado; BCB agregado como contexto |
| Ingestão | arquivos imutáveis, manifesto e Python | orquestração Airflow |
| Staging | tabelas/arquivos preservando esquema de origem | object storage |
| Canonical | adaptadores para contrato comum, origem/versionamento preservados | dbt |
| Persistência | PostgreSQL | warehouse gerenciado |
| Transformação | SQL para perfilamento, marts e features | dbt |
| ML | scikit-learn em batch | MLflow |
| Explicabilidade | análise de coeficientes/importância e explicação local adequada | SHAP após validação da metodologia |
| Monitoramento | relatórios versionados de qualidade, drift e métricas maduras | Evidently/Metabase |

Ver [fluxo](diagrams/data_flow.mmd), [modelo relacional](diagrams/relational_model.mmd) e [sistema](diagrams/system.mmd).

## Princípios

Dados reais e sintéticos percorrem a mesma sequência lógica, mas mantêm `source_name`, `source_version`, `dataset_version` e `is_synthetic`. Adaptadores específicos evitam fingir que colunas e rótulos distintos são idênticos. A unidade e o target canônicos são escolhidos após inspeção da candidata real. Guardar snapshots e datas de disponibilidade para evitar leakage. Separar ingestão, transformação, treino e scoring para reexecução idempotente. Não gerar PII. Dados de benchmark não são dados de produção.

## Decisões pendentes de validação

Home Credit requer confirmar acesso e condições da competição, inventariar arquivos, revisar target e cardinalidades, escolher subconjunto útil e dimensionar armazenamento. Python, PostgreSQL, Docker e dependências serão registrados no lock/manifesto quando a implementação começar. Sem isso, nenhuma versão de stack é considerada verificada.
