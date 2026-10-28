# Pipelines e contratos

Ver [diagrama de fluxo](diagrams/data_flow.mmd). Dados reais e sintéticos compartilham o fluxo abaixo, com adaptadores e metadados de fonte explícitos.

1. Validar licença/termos, baixar manualmente a fonte permitida e registrar origem, versão, data e hash; não versionar arquivos brutos.
2. Gerar conjunto sintético com seed/versão/parâmetros registrados.
3. Criar manifesto e `batch_id`; registrar arquivo, tamanho, hash, contagens e esquema.
4. Ingerir imutavelmente em staging source-specific; validar formato e contagens.
5. Aplicar testes de unicidade, domínio, nulos, relações, datas, duplicatas e target.
6. Quarentenar inválidos com motivo; nunca descartar silenciosamente.
7. Mapear para camada canônica sem perder origem, chave, semântica, proveniência ou indicador sintético.
8. Materializar marts/features somente com dados disponíveis no ponto de previsão.
9. Criar splits cronológicos compatíveis com target, maturação e embargo.
10. Treinar baselines/modelo; registrar código, dados, features, parâmetros e métricas.
11. Executar inferência offline e gravar scores/reason codes, sem decisão real.
12. Monitorar freshness e qualidade em cada lote; performance apenas quando rótulos estiverem maduros.

## Contratos

Idempotência por `batch_id` e chave natural; reprocessamento não duplica linhas. Toda tabela analítica preserva `source_name`, `source_version`, `dataset_version` e `is_synthetic`. Lote vazio ou incompleto nunca conta como sucesso. Falha de schema bloqueia promoção. A semântica de target é específica de fonte até que se prove equivalência. SQL e Python devem registrar timezone, corte temporal e versão de feature.
