# ERP para Barbearias – Estúdio XXI (Grupo 8)

Projeto Integrador de Modelagem de Dados – Engenharia de Software – UNICID – Prof. Clóvis.
Entrega final: do modelo conceitual ao banco de dados implementado.
Documento completo: `documentacao/ERP_Estudio_XXI_Entrega_Final.docx` (e PDF). As seções abaixo resumem cada parte e indicam onde encontrá-la.

## 1. Identificação do projeto
| Item | Informação |
|---|---|
| Projeto | Sistema ERP multiempresa para barbearias |
| Empresa parceira de referência | Barbearia Estúdio XXI (São Paulo/SP) |
| SGBD | Microsoft SQL Server – banco `DB_estudioXXI` |
| Modelagem | brModelo (DER conceitual V4 e modelo lógico) |

## 2. Integrantes
Andressa Fischer Ruksenas Pires · Bruno dos Santos Sanches · Felipe Tavares da Costa · Guilherme Pinheiro Paulino · Gustavo Alexander Mamani Almoguera · Lucas Castro da Silva · Pedro Kimbembi Luzayadio · Rodrigo de Melo Vieira · Victor Vincenzo Frederico · Vitória Cristina Martins Costa.
Contribuições individuais: Quadro 2 do documento **[a preencher pelo grupo conforme o histórico de commits]**.
-Andressa Fischer Ruksenas Pires — Contribuição no levantamento de requisitos e estruturação arquitetural do ERP, definição das regras de negócio de agendamentos e finanças, modelagem dos scripts de validação de dados e idealização conceitual da integração de inteligência artificial no sistema.
-Bruno dos Santos Sanches - Atuei na Engenharia e Arquitetura de dados do projeto, contribuindo com a estruturação de 32 tabelas,  201 campos e 52 chaves estrangeiras, definiçao de entidades, atributos e coletei evidências do banco de dados por meio Microsft Server
- Felipe Tavares da costa - Atuação no levantamento de requisitos e no refinamento do DER conceitual, colaborando na definição de entidades, papéis de entidades, atributos, cardinalidades e na estruturação de tabelas associativas para o mapeamento dos relacionamentos do sistema
- Pedro Kimbembi Luzayadio — Contribuição na análise e revisão do DER conceitual, com participação na definição e validação das chaves primárias e estrangeiras, bem como na análise dos relacionamentos e no tratamento dos relacionamentos N:N por meio de tabelas associativas.
- Lucas Castro da Silva - Atuei na construção e levantamento de dados do DER conceitual e construção do fluxograma, ideias para criação das Regras de Negócio, analise dos relacionamentos e cardinalidades. Por ultimo criação de um protótipo de Dashboard para com a IA, na tentativa de alocar os indicadores aqui citados.

## 3. Empresa e problema
A Estúdio XXI funciona desde 2016, atende com horário marcado (telefone/WhatsApp), oferece cabelo, barba e sobrancelha, tem combo cabelo + barba com 15% de desconto e também vende produtos. O controle era manual e disperso: agenda sem controle de duração e sujeita a conflitos, histórico financeiro perdido, consolidação mensal manual e estoque sem registro de entradas e saídas. (Documento, seção 2.)

## 4. Solução proposta
Banco relacional para uma plataforma ERP **multiempresa**: cada barbearia tem equipe, serviços com preço e duração próprios, agendamento de vários serviços bloqueando o horário do profissional, atendimentos, contas a receber e a pagar, compras, vendas e estoque com histórico de movimentações.
**Números do banco:** 32 tabelas · 201 colunas · 71 NOT NULL · 32 PK · 52 FK · 4 UNIQUE individuais · 9 CHECK.

## 5. Requisitos e regras de negócio
Requisitos funcionais ajustados e regras de negócio atualizadas após a devolutiva da primeira entrega (nota 7,0): profissional no agendamento, múltiplos serviços por agendamento, separação entre obrigação financeira e recebimento, compras parceladas, rastreabilidade do estoque, desconto de combos, venda de produtos e fechamento financeiro. (Documento, seção 3; alterações de modelagem no Quadro 5.)

## 6. DER atualizado
`diagramas/DER_Conceitual_V4.png` e arquivo brModelo `diagramas/DER_Barbearia_Logico_V4_Reparado_Teste.brM3`. (Documento, seção 4.)

## 7. Modelo lógico
`diagramas/Modelo_Logico_gerado_do_DDL.png`. Conversão de entidades, relacionamentos e cardinalidades; relações N:N resolvidas por tabelas associativas (ex.: ITEM_AGENDAMENTO, ALOCACAO, OFERTA_SERVICO, ITEM_COMPRA, ITEM_VENDA). (Documento, seção 5.)

## 8. Normalização
Análise 1FN → 2FN → 3FN com dependências funcionais e decomposições (ex.: saldo de estoque deixou de ser armazenado e passou a ser calculado pelas movimentações). Redundâncias controladas para preservar preços praticados. (Documento, seção 6.)

## 9. Dicionário de dados
`dicionario/Dicionario_de_Dados_ERP_Barbearia.xlsx` – 201 atributos com tabela, descrição, tipo, PK, FK, nulidade, unicidade e regra. Conferido contra o script 01: nomes, tipos e nulidade coincidem nas 32 tabelas.

## 10. Implementação SQL
Pasta `sql/`. Executar **em um banco vazio, nesta ordem**:

| Ordem | Script | Conteúdo |
|---|---|---|
| 1 | `01_estrutura_restricoes.sql` | CREATE DATABASE, 32 tabelas, PK, FK, UNIQUE, CHECK |
| 2 | `02_insercao_inicial.sql` | Primeira carga de dados |
| 3 | `03_insercao_adicional.sql` | Segunda carga de dados |
| 4 | `04_integridade_auditoria.sql` | DBCC CHECKDB e verificação de registros órfãos |
| 5 | `05_contagem_metas.sql` | Confere a estrutura (esperado × encontrado) |
| 6 | `06_consultas_gerenciais.sql` | Consultas G01 a G10 |
| 7 | `07_consultas_auditoria.sql` | Consultas A01 a A17 |
| 8 | `08_demonstracao_restricoes_dml.sql` | Testes T1–T7 (restrições bloqueando erros) e D1–D3 (UPDATE/DELETE), com ROLLBACK |

Arquivos que **não** entram na execução:
- `09_complementos_propostos_nao_executados.sql` – **proposta documentada**. Por decisão do grupo, não é aplicada nesta entrega; registra restrições para evolução futura (seção 7.8). O banco entregue, o dicionário e o script 05 refletem a estrutura sem ela.
- `ERP_Barbearia_V3_Regras_SQL_Complementares.sql` – já incorporado ao script 01; não reexecutar.

## 11. Massa de dados
234 registros em 32 tabelas, cinco unidades, usuários com papéis distintos, agendamentos com vários itens, compras, vendas, estoque e financeiro. São dados de teste, não histórico real da empresa. (Documento, seção 10.) Prompts de IA usados: `documentacao/Prompts_IA_massa_de_dados.md`.

## 12. Consultas gerenciais
Cada consulta responde a uma pergunta do gestor: recebido por mês e forma de pagamento, fechamento diário, serviços mais realizados, produtividade por profissional, produtos mais vendidos, saldo e estoque mínimo, despesas, situação das contas a receber e comparação entre unidades. (Script 06; documento, seção 11.1.)

## 13. Consultas de auditoria
17 verificações ligadas às regras de negócio, por exemplo: conflito de horário do mesmo profissional (A16), valor recebido acima do devido (A10), estoque negativo (A05), compra recebida sem entrada no estoque (A01). Zero linhas = nenhuma ocorrência. (Script 07; documento, seção 11.2.)

## 14. Potencial para BI e IA
Indicadores (faturamento, ticket médio, ocupação, giro de estoque, inadimplência), painéis por unidade e período, e possibilidades futuras de IA como previsão de demanda e sugestão de reposição. (Documento, seção 12.)

## 15. Histórico e evolução do projeto
Primeira entrega (DER conceitual) → devolutiva (nota 7,0) → revisão do DER (V4) → modelo lógico → normalização → SQL Server. Evidências de execução: pasta `evidencias/`. Em 02/11/2026 os scripts 01 a 08 foram executados no SQL Server, em banco vazio, na ordem, sem erros de execução. Registro do uso de IA: documento, seção 14.

## 16. Conclusão
O projeto evoluiu do levantamento do negócio para um banco relacional de 32 tabelas, normalizado até a 3FN, com integridade garantida por chaves e restrições e com consultas que transformam dados em informação para decisão.
