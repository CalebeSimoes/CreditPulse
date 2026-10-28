# CreditPulse — risco de inadimplência de crédito

Projeto integrado e reproduzível de engenharia de dados, SQL e machine learning para estimar inadimplência em empréstimos usando um dataset público e uma versão sintética processados por uma pipeline compartilhada.

> Demonstração educacional. Não concede/nega crédito, não decide elegibilidade e não deve orientar decisões financeiras reais.

## Escopo

- **P0:** ingestão, validação, modelagem analítica/SQL e classificação de inadimplência com avaliação temporal e baselines.
- **P1:** explicabilidade, monitoramento de qualidade, drift e desempenho após maturação dos rótulos.
- **Fonte real primária candidata:** Home Credit Default Risk (Kaggle), sujeita a validar acesso, termos/licença, disponibilidade dos arquivos e adequação de target/grão antes de confirmar.
- **Fonte secundária opcional:** UCI Default of Credit Card Clients, benchmark isolado, com domínio e população diferentes.
- **Dados sintéticos:** gerados com seed, parâmetros e versão registrados; mesma camada canônica e pipeline do dataset real.

As duas fontes não são equivalentes e não devem ser combinadas como se representassem a mesma população. Comparações entre elas são testes de robustez didáticos, não evidência de generalização.

## Início local

Pré-requisitos: Git, Python 3.11+ (validar versão disponível), Docker Desktop com Compose e acesso aos arquivos do dataset público. Configure `.env` a partir de `.env.example` e mantenha arquivos de dados fora do Git.

```powershell
docker compose up -d postgres
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
```

O repositório ainda precisa receber `requirements.txt`, código de ingestão/geração e configuração de execução descritos no [guia de execução](docs/PROJECT_EXECUTION_GUIDE.md). O SQL disponível contém apenas o registro de proveniência e staging inicial; esquema tipado e features dependem da validação da fonte.

## Documentação

- [Guia de execução ponta a ponta](docs/PROJECT_EXECUTION_GUIDE.md)
- [PRD e definição de escopo](docs/PRD.md)
- [Arquitetura](docs/ARCHITECTURE.md)
- [Dicionário e proveniência](docs/DATA_DICTIONARY.md)
- [Pipelines e contratos](docs/PIPELINES.md)
- [Validação](docs/VALIDATION.md)
- [Monitoramento](docs/MONITORING.md)
- [Ética e limitações](docs/ETHICS_AND_LIMITATIONS.md)
- [Plano por etapas](docs/SPRINTS.md)

## Fontes e limites

Home Credit: https://www.kaggle.com/competitions/home-credit-default-risk/data

UCI (Yeh, 2009; DOI 10.24432/C55S3H; CC BY 4.0 conforme catálogo UCI): https://archive.ics.uci.edu/dataset/350/default%2Bcredit%2Bcard%2Bclients

Dados agregados do BCB podem oferecer contexto macro, mas não substituem observações individuais rotuladas. Não usar SCR individual. Respeitar termos de uso e licenças de cada fonte; registrar a validação no manifesto antes de ingestão.

