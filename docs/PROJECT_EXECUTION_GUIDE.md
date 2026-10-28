# CreditPulse — guia de execução do início ao fim

Este é o roteiro operacional do projeto. Conclua as etapas em ordem; marque cada caixa e mantenha decisões e evidências no repositório. P0 entrega ingestão/SQL e previsão de inadimplência comparável. P1 acrescenta explicabilidade e monitoramento. A fonte real principal é Home Credit Default Risk, mas permanece **candidata até a validação de acesso, termos, arquivos e target**. Se a validação falhar, registre a causa e escolha uma alternativa pública adequada antes de modelar. Dados sintéticos percorrem os mesmos contratos e sequência, identificados separadamente.

## Mapa rápido

| Etapa | Resultado verificável | Bloqueia a próxima? |
|---|---|---|
| 0. Preparar ambiente e repositório | ferramentas e execução mínima registradas | sim |
| 1. Validar e obter a fonte real | ficha de fonte/termos/target | sim |
| 2. Inventariar e perfilar | dicionário empírico e relatório de qualidade | sim |
| 3. Definir contrato e gerar sintético | contrato canônico e gerador reprodutível | sim |
| 4. Ingerir e modelar com SQL | raw/staging/canonical/marts conciliados | sim |
| 5. Explorar e fechar target | análise e protocolo de rótulo/corte | sim |
| 6. Criar validação e baselines | split temporal e referências simples | sim |
| 7. Treinar e registrar P0 | pipeline comparável e artefato local | sim para P1 |
| 8. Explicar P1 | análise global/local com ressalvas | não |
| 9. Monitorar P1 | relatório offline por lote/período | não |
| 10. Consolidar entrega | execução reproduzível e documentação final | conclusão |

---

## Etapa 0 — Preparar ambiente e repositório

**Objetivo.** Tornar a execução repetível e separar dados brutos/segredos do código.

**Tarefas.** Confirmar Git, Python, Docker Desktop/Compose e PostgreSQL local; registrar versões. Criar estrutura para `src/`, `tests/`, `data/raw/`, `data/processed/`, `reports/` e `sql/`. Incluir ignorados para `.env`, `.venv/`, arquivos de dados, modelos e caches. Copiar `.env.example` para `.env` e verificar conexão local.

**Comandos de referência (PowerShell, na raiz do projeto):**

```powershell
git status --short
python --version
docker --version
docker compose version
Copy-Item .env.example .env
docker compose up -d postgres
docker compose ps
```

Se Git/Python/Docker não estiverem instalados, registrar a versão/instalador oficial escolhido antes de seguir. Não incluir credenciais reais no `.env.example` nem em logs.

**Entregáveis:** inventário de ferramentas; estrutura; `.gitignore`; `.env` local; PostgreSQL ativo.

**Saída:** `docker compose ps` mostra PostgreSQL saudável; `git status` não lista dados/segredos; comando de conexão responde. 

**Checklist:**
- [ ] versões anotadas em README ou `docs/DECISIONS.md`;
- [ ] dados e credenciais ignorados pelo Git;
- [ ] PostgreSQL local acessível.

**Armadilhas:** não confundir `docker compose up` com execução da pipeline; não commitar `.env`; não guardar dataset bruto na pasta de outputs/versionamento.

## Etapa 1 — Validar fonte pública real

**Objetivo.** Confirmar que Home Credit é acessível e serve ao problema pretendido antes de investir na modelagem.

**Tarefas.** Abrir página oficial da competição; confirmar login/acesso, termos vigentes e condições de uso/redistribuição. Baixar somente os arquivos permitidos. Guardar os arquivos localmente em `data/raw/home_credit/<versao>/` (ignorado pelo Git). Registrar URL, data de obtenção, nomes, tamanhos, hashes SHA-256 e termos consultados no manifesto. Listar tabela/arquivo, grão, chave, tamanho, colunas, target, significado documentado, período e chaves de relacionamento. Identificar limite prático de armazenamento/memória.

**Comandos úteis:**

```powershell
New-Item -ItemType Directory -Force data/raw/home_credit, data/processed, reports | Out-Null
Get-ChildItem data/raw/home_credit -File | Select-Object Name,Length
Get-FileHash data/raw/home_credit/<arquivo> -Algorithm SHA256
```

Não inclua `<arquivo>` literalmente: substitua pelo nome real. Download Kaggle CLI só depois de seguir os termos e configurar credenciais localmente; nunca cole tokens em documentação ou chat.

**Entregáveis:** `data/manifest.yaml` (ou JSON), inventário de arquivos e `docs/source_card_home_credit.md` com target/grão e limites.

**Saída:** responsável consegue responder, com referência à fonte, o que uma linha representa, o que target significa, quais arquivos são necessários e se o uso está permitido. Caso contrário, pare e avalie fonte alternativa; UCI é opcional, não substitui silenciosamente.

**Checklist:**
- [ ] acesso e termos confirmados na data;
- [ ] hashes e versão registrados;
- [ ] target, grão, chaves e relações descritos;
- [ ] arquivos grandes e dependências de memória avaliados.

**Armadilhas:** páginas de competição podem exigir aceitar regras; não redistribua dados; coluna `TARGET` não deve ser interpretada além da definição da fonte; dados de países/períodos distintos não representam automaticamente o Brasil.

## Etapa 2 — Inventariar e perfilar

**Objetivo.** Entender os dados realmente baixados e construir um dicionário empírico.

**Tarefas.** Implementar um perfilador Python/SQL por arquivo/tabela: linhas, colunas, tipos, nulos, valores distintos, duplicatas, chaves, min/max, frequências categóricas e target/prevalência. Conferir relacionamento entre tabelas e validar contagens contra documentação. Escolher primeiro um caminho pequeno reproduzível; só carregar tabelas relacionadas necessárias. Salvar relatório sem publicar dados linha a linha.

**Comandos a criar/usar quando scripts existirem:**

```powershell
python -m creditpulse.profile --source home_credit --manifest data/manifest.yaml
```

**Entregáveis:** dicionário preenchido, perfil CSV/Markdown, mapa de relações e relatório de qualidade.

**Saída:** chave e cardinalidade conhecidas; nulos/categorias anômalas identificados; target e desbalanceamento quantificados; tamanho que cabe no ambiente.

**Checklist:**
- [ ] unicidade e relações verificadas;
- [ ] nulos e categorias analisados;
- [ ] datas/ordem temporal inspecionadas;
- [ ] target e populações disponíveis contados.

**Armadilhas:** confundir uma tabela de eventos com uma tabela de solicitações; validar somente a tabela principal; carregar tudo na memória sem medir; usar identificador como feature.

## Etapa 3 — Fechar o contrato canônico e construir dados sintéticos

**Objetivo.** Permitir que real e sintético usem os mesmos estágios sem apagar diferenças semânticas.

**Tarefas.** A partir da ficha da fonte, escolher unidade de análise e campos semanticamente mapeáveis. Desenhar colunas canônicas com tipo, nullable, unidade, disponibilidade temporal, origem e regra de transformação. Preservar staging source-specific e acrescentar `source_name`, `source_version`, `dataset_version`, `batch_id`, `source_record_key`, `observation_date`, `is_synthetic`. Definir comportamento para colunas sem correspondência. Criar gerador determinístico com parâmetros e cenários (prevalência, sinal, nulos e shifts conhecidos), sem alegar fidelidade empírica.

**Comando de referência após implementação:**

```powershell
python -m creditpulse.generate --seed 42 --version v1 --output data/processed/synthetic
```

**Entregáveis:** contrato documentado, adaptador de cada fonte, gerador, manifesto sintético.

**Saída:** seed/versão iguais reproduzem mesmas contagens e conteúdo; todas as linhas carregam proveniência; métricas real e sintética podem ser separadas.

**Checklist:**
- [ ] target específico da fonte preservado;
- [ ] mapa de colunas com semântica registrada;
- [ ] sintético gera cenário base e cenário de shift;
- [ ] IDs sintéticos opacos, sem PII.

**Armadilhas:** forçar equivalência de targets; gerar um dataset sintético fácil demais; misturar real e sintético antes da avaliação; usar valores sintéticos para completar rótulos reais.

## Etapa 4 — Ingerir, validar e transformar com SQL

**Objetivo.** Entregar o núcleo de engenharia de dados P0 com reexecução segura.

**Tarefas.** Definir staging específico por origem, tabela de manifestos/lotes e camadas canônicas. Implementar ingestão idempotente. Criar verificações de schema, chaves, relações, domínio, target, datas e contagens. Quarentenar inválidos com motivo. Criar marts/features com SQL; documentar granularidade, cortes temporais e reconciliação. Indexar chaves usadas. Não colocar o payload bruto em logs.

**Comandos atuais de infraestrutura:**

```powershell
docker compose up -d postgres
psql "$env:DATABASE_URL" -f sql/001_schema.sql
```

O schema SQL presente é uma base inicial antiga centrada em faturas e precisa ser migrado ao contrato de risco antes de uso; consulte o guia atualizado. Com `psql` instalado e SQL novo pronto, executar os scripts SQL em ordem, por exemplo `psql "$env:DATABASE_URL" -f sql/001_schema.sql` e scripts seguintes documentados pelo projeto.

**Entregáveis:** DDL, comandos/script de carga, consultas SQL de marts, relatório de reconciliação e log de lote.

**Saída:** carga repetida não duplica; chave/linhas/target conciliam com origem; falha de qualidade impede promoção; dados sintéticos e reais identificáveis.

**Checklist:**
- [ ] carga incremental/idempotente;
- [ ] totais e PK/FK conciliados;
- [ ] inválidos em quarentena;
- [ ] nenhuma feature futura;
- [ ] query/versão e data de corte registradas.

**Armadilhas:** considerar comando com sucesso se lote veio vazio; `ON CONFLICT` esconder discrepâncias; tratar nulo como zero; esquecer timezone/data de disponibilidade.

## Etapa 5 — EDA e definição definitiva do problema

**Objetivo.** Confirmar que target e features sustentam uma pergunta de ML mensurável.

**Tarefas.** Fazer EDA de população, target/prevalência, nulos, distribuições, categorias e variação temporal/coortes. Registrar unidade, população elegível, target literal, horizonte, censoramento/maturação e instante de previsão. Definir features admissíveis com razão temporal. Separar análise real e sintética. Atualizar PRD, dicionário e decisões.

**Entregáveis:** notebook/relatório EDA (se solicitado/necessário), definição congelada de target e matriz de disponibilidade das features.

**Saída:** target reproduzível em regra executável; positivos e negativos auditáveis; limitações da fonte compreendidas.

**Checklist:**
- [ ] target definido por fonte e unidade;
- [ ] maturação/observabilidade conhecida;
- [ ] variáveis posteriores removidas;
- [ ] população e limitações relatadas.

**Armadilhas:** conclusão causal a partir de correlação; target derivado de coluna futura; prevalência contaminada por linhas duplicadas; tratar falta de rótulo como negativo.

## Etapa 6 — Protocolo de validação e baselines

**Objetivo.** Criar comparação honesta antes de otimizar modelos.

**Tarefas.** Reservar teste final; criar split cronológico quando datas permitirem. Garantir labels maduros no treino e embargo quando eventos/targets se sobrepõem. Se dependência por entidade importar, avaliar agrupamento. Definir baseline de prevalência e regra simples explicável. Fixar métricas, top-K apenas se fizer sentido didático e capacidade for explícita. Fixar seed e períodos.

**Entregáveis:** `docs/VALIDATION.md` específico da fonte, splits versionados e resultados baseline.

**Saída:** treino/validação/teste sem interseção/leakage proibida; baseline repetível; prevalência, positivos e cobertura reportados.

**Checklist:**
- [ ] teste final intocado;
- [ ] transformadores ajustados só no treino;
- [ ] split reflete tempo/entidade;
- [ ] PR-AUC, calibração e métricas complementares registradas.

**Armadilhas:** usar split aleatório por conveniência; calibrar no teste; comparar datasets com targets diferentes como ranking direto; reportar ROC-AUC sem prevalência/PR-AUC em target raro.

## Etapa 7 — Modelo de inadimplência P0

**Objetivo.** Comparar ao menos um modelo supervisionado simples às baselines.

**Tarefas.** Usar pipeline scikit-learn com imputação, encoding e regularização ajustados no treino. Registrar versão de dados/features/código, parâmetros, períodos e métricas. Fazer validação temporal e análise de erro. Comparar com baseline em mais de uma janela se houver tempo/dados. Congelar escolhas antes do teste final e avaliar uma vez.

**Comando de referência após implementar CLI:**

```powershell
python -m creditpulse.train --source home_credit --config configs/model.yaml
python -m creditpulse.evaluate --run-id <id-da-execucao>
```

**Entregáveis:** pipeline treinável, artefato local versionado, tabela de runs e relatório comparativo.

**Saída:** execução reproduzível; modelo avaliado sem leakage; diferenças de métrica têm explicação e incerteza/limitação.

**Checklist:**
- [ ] baseline e modelo no mesmo protocolo;
- [ ] artefato ligado a dataset/feature/code versions;
- [ ] análise de falsos positivos/negativos;
- [ ] resultados não são apresentados como performance de produção.

**Armadilhas:** otimizar no teste final; interpretar score como decisão; chamar benchmark público de representativo do Brasil; oversampling antes do split.

## Etapa 8 — Explicabilidade P1

**Objetivo.** Mostrar quais padrões afetam o modelo sem alegar causalidade.

**Tarefas.** Começar com coeficientes/permutation importance em validação; selecionar casos típicos e limites; se houver SHAP, verificar compatibilidade, baseline, amostragem e estabilidade. Analisar por período/coorte possível. Redactar reason summary com linguagem associativa.

**Entregáveis:** interpretação global e casos locais vinculados ao model run.

**Saída:** toda explicação indica população, versão e limites; conclusões não confundem importância com causa.

**Checklist:**
- [ ] explicação vinculada ao modelo/dataset;
- [ ] estabilidade e correlação de features consideradas;
- [ ] linguagem sem causalidade ou recomendação de crédito.

**Armadilhas:** explicar uma instância como motivo factual; usar importância global como explicação individual; ignorar features correlacionadas.

## Etapa 9 — Monitoramento P1

**Objetivo.** Construir operação demonstrativa de inspeção offline.

**Tarefas.** Produzir por lote/fonte freshness, volume, nulos, domínio, categorias novas, drift e target prevalence. Após maturação, reportar métricas em janela/coorte com volume mínimo. Definir limites de alerta após baseline e justificar. Não automatizar retreino nem decisão.

**Entregáveis:** relatório de monitoramento versionado, exemplo de lote estável e cenário sintético de drift.

**Saída:** drift sintético é detectado sem confundir com erro de ingestão; métricas de performance não aparecem sem labels maduros.

**Checklist:**
- [ ] métricas segmentadas por origem;
- [ ] freshness e qualidade monitoradas;
- [ ] labels maduros exigidos para desempenho;
- [ ] alertas apenas investigativos.

**Armadilhas:** thresholds universais; confundir drift com deterioração; retreino automático; misturar lotes sintéticos nos indicadores reais.

## Etapa 10 — Consolidar e demonstrar

**Objetivo.** Permitir que outra pessoa entenda limites e reproduza o fluxo.

**Tarefas.** Atualizar README com instalação, setup de dados, comandos realmente existentes e resultados reproduzíveis. Documentar limitações e proveniência. Gerar diagramas coerentes. Fazer revisão manual de links, caminhos, SQL, comandos e referências a faturas/cobrança que tenham sobrado. Confirmar que não há segredos nem dados brutos no Git.

**Entregáveis:** documentação de execução, arquitetura, esquema, relatório P0/P1 e checklist de aceite.

**Saída final:** outra pessoa consegue preparar ambiente, obter dados conforme regras, executar ingestão→SQL→treino→avaliação e identificar o que é real/sintético e o que não se deve concluir.

**Checklist final:**
- [ ] fonte e termos verificados;
- [ ] real e sintético usam fluxo comum com rastreabilidade;
- [ ] engenharia/SQL e predição P0 concluídos;
- [ ] validação temporal e prevenção de leakage documentadas;
- [ ] P1 documentado ou marcado como pendente;
- [ ] comandos executados conferem com o repositório;
- [ ] limitações e proibição de uso decisório visíveis;
- [ ] dados pessoais, brutos e segredos não publicados.

## Pendências reais no momento deste guia

- Validar condições de acesso e termos atuais da Home Credit no Kaggle.
- Obter os arquivos localmente e confirmar target/granularidade/tamanho.
- Confirmar versões disponíveis de Python, Docker, PostgreSQL e `psql`.
- Criar implementação Python, dependências/lock, `.gitignore`, adaptadores, gerador e scripts de perfilamento/carga.
- Implementar tabelas SQL tipadas e features depois de validar o contrato da fonte.
- Definir desenho temporal de validação conforme datas e semântica de target reais.

Até resolver as duas primeiras pendências, Home Credit deve permanecer candidata; as etapas seguintes não devem presumir seu esquema.

