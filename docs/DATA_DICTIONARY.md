# Dicionário de dados e proveniência

O esquema definitivo depende da inspeção da fonte Home Credit. Não renomear campos para um significado mais forte que o original. Manter tabelas source-specific no staging e mapear apenas campos semanticamente compatíveis para o modelo canônico.

## Campos de rastreabilidade obrigatórios

| Campo | Definição |
|---|---|
| source_name | nome estável da fonte (`home_credit`, `synthetic`, `uci_credit_card`) |
| source_version | versão/edição ou data de obtenção identificada |
| dataset_version | hash/versão do conjunto processado |
| batch_id | identificador único da ingestão |
| record_key | chave da entidade na origem; preservar regra de anonimização quando necessário |
| observation_date | data do corte ou observação, quando aplicável |
| target | rótulo conforme definição literal da fonte; nullable até estar observável |
| is_synthetic | separa registros gerados de observados |
| loaded_at | timestamp UTC da ingestão |

## Modelo canônico provisório

O contrato pode incluir entidade/solicitação/operação, variáveis numéricas e categóricas, histórico disponível no corte e target binário. Tipo, unidade, nulos, categorias e significado serão documentados na etapa de perfilamento. Não pressupor que a chave única seja cliente ou que uma linha corresponda a uma pessoa.

## Fontes e proveniência

**Primária candidata:** Home Credit Default Risk, arquivos relacionais de risco de crédito na competição Kaggle. Confirmar termos de uso e acesso, identificar versão, target e granularidades antes do uso. https://www.kaggle.com/competitions/home-credit-default-risk/data

**Opcional:** UCI Default of Credit Card Clients: dados de 30 mil clientes de cartão em Taiwan, target de default no mês seguinte conforme descrição do catálogo; benchmark isolado e não equivalente ao Home Credit. Yeh (2009), DOI 10.24432/C55S3H; licença exibida pela UCI: CC BY 4.0. https://archive.ics.uci.edu/dataset/350/default%2Bcredit%2Bcard%2Bclients

**Sintético:** publicar seed, parâmetros, versão do gerador e mecanismos de geração. Não apresentar resultados sintéticos como estimativa de desempenho real.

**Contexto opcional:** BCB agregado pode contextualizar séries, sem granularidade para predição individual. Não usar SCR individual. https://dadosabertos.bcb.gov.br/
