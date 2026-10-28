# Validação temporal e métricas

## Antes do modelo

Definir, a partir da documentação da fonte, unidade de análise, população, target, horizonte, rótulos desconhecidos e instante em que cada coluna fica disponível. Confirmar se há data suficiente para split temporal. Se não houver datas adequadas, explicitar a limitação e não alegar backtest temporal.

## Prevenção de leakage

Excluir identificadores e colunas derivadas do outcome ou indisponíveis no instante da previsão. Fazer imputação, encoding, seleção e calibração dentro do pipeline e sem ajustar no teste. Em dados relacionais, agregar históricos com corte estrito e revisar as-of. Agrupar/embargar observações correlacionadas quando unidade/tempo exigirem.

## Protocolo

Preferir rolling-origin ou holdout cronológico, com treino, validação e teste final intocado. Labels do treino precisam estar observáveis na data de corte. Fixar seeds e registrar períodos. Nunca usar split aleatório como evidência principal quando há ordem temporal ou dependência por cliente.

## Baselines e métricas

Começar por prevalência e uma regra simples disponível na fonte; comparar regressão logística regularizada e, depois, boosting se houver justificativa. Reportar prevalência, número de positivos, cobertura, PR-AUC, ROC-AUC complementar, Brier/log loss e calibração. Se houver operação de top-K, precision@K/recall@K são análises offline ilustrativas, sem política de concessão.

Relatar resultados por período e coorte pertinente, intervalos de incerteza e classes omitidas. Métricas de fontes diferentes não devem ser comparadas sem explicar população, target e protocolo. Teste final só uma vez após decisões fechadas.

## Interpretação

Desempenho preditivo não prova causalidade, justiça, estabilidade ou utilidade de decisão. Resultados não autorizam concessão/negação de crédito nem generalizam automaticamente para clientes brasileiros ou produção.
