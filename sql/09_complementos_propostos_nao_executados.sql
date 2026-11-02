-- ERP Barbearias - Estudio XXI | Grupo 8
-- Arquivo: 09_complementos_propostos_nao_executados.sql
-- SITUACAO: PROPOSTA DOCUMENTADA. Decisao do grupo: este script NAO sera aplicado nesta entrega.
-- Nao faz parte da cadeia 01-08 e NAO deve ser executado. Fica como registro de evolucao futura.
-- O banco entregue, o dicionario e o script 05 refletem a estrutura SEM estes complementos.
-- Origem: Quadro 27 da secao 7.8 (restricoes previstas, ainda ausentes do DDL).
-- A massa atual foi conferida por consulta e nao viola nenhuma destas regras (secao 7.8).
USE DB_estudioXXI;
GO

-- Unicidade de dados naturais
ALTER TABLE dbo.BARBEARIA ADD CONSTRAINT UQ_BARBEARIA_documento UNIQUE (documento);
ALTER TABLE dbo.SERVICO   ADD CONSTRAINT UQ_SERVICO_nm_servico  UNIQUE (nm_servico);
GO

-- Valores validos
ALTER TABLE dbo.ITEM_COMPRA ADD CONSTRAINT CK_ITEM_COMPRA_VALORES CHECK (quantidade > 0 AND valor_unitario >= 0);
ALTER TABLE dbo.ITEM_VENDA  ADD CONSTRAINT CK_ITEM_VENDA_VALORES  CHECK (quantidade > 0 AND preco_unitario_aplicado >= 0);
ALTER TABLE dbo.OFERTA_SERVICO ADD CONSTRAINT CK_OFERTA_VALORES   CHECK (preco >= 0 AND duracao_minutos > 0);
ALTER TABLE dbo.PRODUTO ADD CONSTRAINT CK_PRODUTO_ESTOQUE_MIN     CHECK (estoque_minimo_padrao >= 0);
GO

-- Valores padrao (campos preenchidos pelo sistema)
ALTER TABLE dbo.BARBEARIA ADD CONSTRAINT DF_BARBEARIA_dt_cadastro DEFAULT SYSDATETIME() FOR dt_cadastro;
ALTER TABLE dbo.USUARIO   ADD CONSTRAINT DF_USUARIO_dt_cadastro   DEFAULT SYSDATETIME() FOR dt_cadastro;
ALTER TABLE dbo.MOVIMENTACAO_ESTOQUE ADD CONSTRAINT DF_MOVIMENTACAO_dt DEFAULT SYSDATETIME() FOR dt_movimentacao;
GO

-- Obrigatoriedade de atributos indispensaveis (falha se existir NULL na base)
ALTER TABLE dbo.OFERTA_SERVICO ALTER COLUMN preco DECIMAL(14,2) NOT NULL;
ALTER TABLE dbo.OFERTA_SERVICO ALTER COLUMN duracao_minutos INT NOT NULL;
ALTER TABLE dbo.CONTA_RECEBER  ALTER COLUMN valor_devido DECIMAL(14,2) NOT NULL;
ALTER TABLE dbo.CONTA_PAGAR    ALTER COLUMN valor_devido DECIMAL(14,2) NOT NULL;
ALTER TABLE dbo.CONTA_RECEBER  ALTER COLUMN dt_vencimento DATETIME2(0) NOT NULL;
ALTER TABLE dbo.CONTA_PAGAR    ALTER COLUMN dt_vencimento DATETIME2(0) NOT NULL;
ALTER TABLE dbo.AGENDAMENTO    ALTER COLUMN dt_hora_inicio DATETIME2(0) NOT NULL;
ALTER TABLE dbo.ITEM_COMPRA    ALTER COLUMN quantidade DECIMAL(14,3) NOT NULL;
ALTER TABLE dbo.ITEM_VENDA     ALTER COLUMN quantidade DECIMAL(14,3) NOT NULL;
GO
