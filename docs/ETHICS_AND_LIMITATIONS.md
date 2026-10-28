# Ética, riscos e limitações

CreditPulse é um projeto educacional e offline. Não deve aprovar/recusar crédito, determinar limites/juros, orientar cobrança real ou afetar pessoas. Dados públicos continuam sujeitos aos termos da fonte; disponibilidade pública não elimina restrições de uso.

| Risco | Salvaguarda |
|---|---|
| Semântica/representatividade inadequada | documentar população, país, período, target e limites; não alegar transferência entre datasets |
| Sintético confundido com evidência | marcar em cada camada, publicar seed/parâmetros e separar métricas |
| Leakage | mapa de disponibilidade, cortes temporais, validação e revisão de features |
| Proxies/grupos sensíveis | minimizar campos, excluir do MVP salvo necessidade didática explícita, auditar limitações |
| Explicação entendida como causa | explicar associação do modelo, não causalidade; registrar versão e contexto |
| Target incompleto | modelar maturação/censoramento; não avaliar antes de rótulos observáveis |
| Reidentificação/privacidade | não inserir dados pessoais próprios; usar apenas arquivos permitidos, controle local e não publicar dados brutos |

Home Credit exige respeito aos termos da competição e às condições de acesso/redistribuição. UCI tem população e target específicos e fica isolado. Dados BCB agregados servem apenas como contexto; não usar SCR individual. LGPD: https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709compilado.htm. Este texto não é parecer jurídico. Qualquer uso real exige análise jurídica, privacidade, segurança, governança e validação por especialistas.
