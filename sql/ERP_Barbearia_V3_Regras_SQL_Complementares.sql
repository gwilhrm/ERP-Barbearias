-- ERP Barbearia - Complementos de integridade para a futura etapa fisica (SQL Server)
-- Referencia: DER_Barbearia_Logico_V3_Corrigido.brM3, 31/10/2026
-- NAO EXECUTADO. Execute SOMENTE depois de revisar o DDL gerado, a nomenclatura
-- real e as restricoes que ja existirem para evitar duplicacoes.
-- Estes comandos NAO substituem triggers e controles transacionais.

-- A conta a receber tem exatamente uma origem (ATENDIMENTO ou VENDA).
ALTER TABLE dbo.CONTA_RECEBER ADD CONSTRAINT CK_CONTA_RECEBER_ORIGEM_XOR CHECK (
    (id_atendimento IS NOT NULL AND id_venda IS NULL)
 OR (id_atendimento IS NULL AND id_venda IS NOT NULL)
);

-- Movimentacao de estoque: no maximo UMA origem comercial; ajuste e abertura
-- podem permanecer sem item de compra/venda.
ALTER TABLE dbo.MOVIMENTACAO_ESTOQUE ADD CONSTRAINT CK_MOVIMENTACAO_ORIGEM CHECK (
    id_item_compra IS NULL OR id_item_venda IS NULL
);
ALTER TABLE dbo.MOVIMENTACAO_ESTOQUE ADD CONSTRAINT CK_MOVIMENTACAO_QTD_POSITIVA CHECK (quantidade > 0);

-- Unicidade composta de itens e elegibilidade. Nao criar UNIQUE isolado em
-- nenhuma coluna destes pares: isso proibiria repeticoes legitimas.
CREATE UNIQUE INDEX UX_ITEM_COMBO_COMBO_SERVICO ON dbo.ITEM_COMBO (id_combo, id_servico);
CREATE UNIQUE INDEX UX_ITEM_COMPRA_COMPRA_PRODUTO ON dbo.ITEM_COMPRA (id_compra, id_produto);
CREATE UNIQUE INDEX UX_ITEM_VENDA_VENDA_PRODUTO ON dbo.ITEM_VENDA (id_venda, id_produto);
CREATE UNIQUE INDEX UX_ITEM_AGENDAMENTO_AG_OFERTA ON dbo.ITEM_AGENDAMENTO (id_agendamento, id_oferta);
CREATE UNIQUE INDEX UX_SERVICO_BENEFICIO_REGRA_SERVICO ON dbo.SERVICO_BENEFICIO (id_regra_beneficio, id_servico);

-- UNICO para RESGATA_CORTESIA: alem da PK composta configurada no brModelo,
-- cada direito de cortesia e cada item nao podem aparecer em mais de um resgate.
-- Antes de executar, conferir se o gerador ja criou estes UNIQUE pelos flags
-- de campo, evitando indexes duplicados.
-- CREATE UNIQUE INDEX UX_RESGATA_CORTESIA_CORTESIA ON dbo.RESGATA_CORTESIA(id_cortesia);
-- CREATE UNIQUE INDEX UX_RESGATA_CORTESIA_ITEM ON dbo.RESGATA_CORTESIA(id_item_agendamento);

-- CHECKs locais: valores nao negativos e desconto percentual entre 0 e 100.
ALTER TABLE dbo.CONTA_RECEBER ADD CONSTRAINT CK_CONTA_RECEBER_VALOR CHECK (valor_devido >= 0);
ALTER TABLE dbo.CONTA_PAGAR ADD CONSTRAINT CK_CONTA_PAGAR_VALOR CHECK (valor_devido >= 0);
ALTER TABLE dbo.RECEBIMENTO ADD CONSTRAINT CK_RECEBIMENTO_VALOR CHECK (valor_recebido > 0);
ALTER TABLE dbo.PAGAMENTO ADD CONSTRAINT CK_PAGAMENTO_VALOR CHECK (valor_pago > 0);
ALTER TABLE dbo.ITEM_AGENDAMENTO ADD CONSTRAINT CK_ITEM_AG_DESCONTO CHECK (percentual_desconto_aplicado BETWEEN 0 AND 100);
ALTER TABLE dbo.COMBO ADD CONSTRAINT CK_COMBO_DESCONTO CHECK (percentual_desconto BETWEEN 0 AND 100);

-- A DEFINIR NA IMPLEMENTACAO (requer decisao/regra e/ou transacao, nao CHECK simples):
-- * OFERTA_SERVICO: UNIQUE (id_barbearia, id_servico) somente para oferta ativa;
--   vocabulario de st_oferta ainda nao confirmado (nao inventar filtro).
-- * PRECO_CLIENTE: impedir vigencias sobrepostas para o mesmo cliente/oferta.
-- * COMBO: no minimo dois servicos distintos; um combo por agendamento;
--   beneficio cabelo+barba 15% sobre os dois itens elegiveis.
-- * AGENDAMENTO: impedir intervalos sobrepostos para o mesmo profissional,
--   inclusive entre barbearias; ignorar cancelados.
-- * ATENDIMENTO/ALOCACAO/AGENDAMENTO: validar a mesma barbearia.
-- * MOVIMENTACAO_ESTOQUE: validar produto e empresa do item de origem,
--   saldo disponivel e soma das entradas <= quantidade comprada.
-- * RECEBIMENTO/PAGAMENTO/UTILIZACAO_CREDITO/DEVOLUCAO_RECEBIMENTO:
--   conferir somas, status confirmados e bloqueios de concorrencia.
-- * CORTESIA/REGRA_BENEFICIO: validar mesma barbearia, cliente e elegibilidade.
-- * REPASSE: gorjeta externa nao integra o ERP nesta versao.
