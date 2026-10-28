# Monitoramento (P1)

O MVP implementa relatórios offline reproduzíveis; não há serviço de produção. Monitorar por fonte e versão para que a mistura de dados sintéticos e reais não esconda diferenças.

| Camada | Sinais | Resposta inicial |
|---|---|---|
| Ingestão | freshness, volume, hashes, esquema, batch falho | bloquear lote e investigar origem |
| Qualidade | nulos, duplicatas, domínios, relações, target/prevalência | quarentena e correção no adaptador |
| Features | distribuição, nulos, categorias novas, versão | revisar fonte/transformação |
| Drift | PSI ou distância apropriada, por variável e coorte | investigar período, sazonalidade e pipeline |
| Desempenho | PR-AUC, calibração, erro, cobertura após maturação | revisar e suspender avaliação se target estiver incompleto |

Limites como PSI > 0,20 ou queda relativa de métrica podem ser gatilhos iniciais de investigação, nunca padrões universais nem comandos automáticos de retreino. Fixar limites após baseline e registrar justificativa, janela e volume mínimo. Não usar métricas sem labels maduros. Guardar hash/código/dados/features/períodos/parâmetros, métricas e decisão. Permitir rollback do artefato de demonstração e declarar claramente qualquer resultado sintético.
