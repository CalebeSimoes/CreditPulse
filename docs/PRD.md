# PRD — CreditPulse

## Objetivo

Construir uma demonstração integrada que recebe dados observados de risco de crédito, transforma-os em tabelas analíticas reproduzíveis com SQL e estima a probabilidade de inadimplência. O sistema deve operar tanto sobre uma fonte pública real quanto sobre dados sintéticos, usando contratos e etapas compartilhados.

## Problema e decisão crítica

**Problema P0:** classificação de inadimplência/default associado a uma operação ou cliente de crédito, condicionada à granularidade e à definição de target disponíveis na fonte selecionada. O problema é útil para demonstrar engenharia de dados e ML supervisionado e possui datasets públicos com outcomes observados. Antes de fixar a unidade (cliente, solicitação ou operação), target e horizonte, validar os arquivos Home Credit e documentar seu dicionário e semântica. Não inferir que um rótulo do dataset represente inadimplência regulatória ou brasileira.

**Complemento P1:** explicabilidade global e local, análise de erro e monitoramento de qualidade, drift de features e desempenho quando os rótulos amadurecerem.

**Fontes:** Home Credit Default Risk é a candidata principal; seu acesso/disponibilidade e termos precisam ser confirmados. UCI Default of Credit Card Clients é opcional e isolado. Um gerador sintético reproduz o contrato canônico e cenários controlados, mas não simula fielmente a população real sem evidência.

## Usuários e entregas

Analista/engenheiro de dados: ingestão, qualidade, SQL e rastreabilidade. Cientista de dados: definição de target, baselines, validação temporal e interpretação. Revisor: consegue reproduzir resultados e ver limites e proveniência.

## Dentro do escopo

- ingestão versionada de arquivos públicos e dados sintéticos;
- staging específico por fonte e camada canônica compartilhada;
- PostgreSQL/SQL para perfilamento, transformação e marts;
- baseline simples e modelos de classificação;
- validação temporal, métricas adequadas a classes raras e análise por coorte;
- registro de dataset, código, features, parâmetros e resultados;
- P1: explicabilidade, drift e monitoramento de desempenho após maturação.

## Fora do escopo

Decisão automatizada de crédito, aprovação/recusa, precificação, contato de cobrança, alegações de ROI, uso de dados pessoais reais do usuário, serviço de produção e conclusão de equidade regulatória.

## Target e unidade de análise

Será fixada somente após inspeção da fonte. Registrar unidade, definição literal do rótulo, janela/horizonte, população elegível, censoramento, momento em que features ficam disponíveis e classes positivas/negativas. Não misturar targets de bases diferentes. Separar tabelas específicas de origem e manter uma convenção canônica que não distorça semânticas.

## Critérios de aceite P0

1. A origem real escolhida tem termos/acesso, esquema e target documentados.
2. O gerador produz dados reproduzíveis com seed, versão e parâmetros registrados.
3. Ambos os caminhos chegam a um contrato canônico através de adaptadores identificáveis e testes de qualidade.
4. SQL materializa tabelas analíticas e os totais/chaves são conciliados.
5. Features não contêm informação indisponível no instante da previsão; split respeita tempo e maturação.
6. Baselines e modelo são comparados em períodos/coortes e resultados trazem prevalência, cobertura e limitações.
7. Execução reproduzível documenta comandos e versões.

## Critérios P1

Explicações documentam limitações e dependem de modelo/dados versionados; monitoramento reporta freshness, qualidade, drift e métricas somente em labels maduros. Gatilhos são investigativos, nunca retreino automático.

## Hipótese de negócio

Um modelo pode discriminar melhor o risco que uma regra simples em um dataset e período específicos. Isso é uma hipótese de benchmark, não demonstração de benefício causal, adequação para decisões reais ou generalização para outra população.
