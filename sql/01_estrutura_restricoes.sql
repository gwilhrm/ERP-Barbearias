-- Script SQL Server: criação do banco, 32 tabelas e restrições
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'DB_estudioXXI')
BEGIN
    CREATE DATABASE DB_estudioXXI;
END
GO

USE DB_estudioXXI;
GO

-- 1. TABELA: dbo.BARBEARIA (9 campos)
IF OBJECT_ID(N'dbo.BARBEARIA', N'U') IS NULL
CREATE TABLE dbo.BARBEARIA (
    id_barbearia INT IDENTITY(1,1) NOT NULL,
    nm_barbearia NVARCHAR(120) NULL,
    tipo_pessoa VARCHAR(30) NULL,
    documento VARCHAR(20) NULL,
    telefone VARCHAR(20) NULL,
    email VARCHAR(254) NULL,
    endereco NVARCHAR(255) NULL,
    dt_cadastro DATETIME2(0) NULL,
    st_barbearia VARCHAR(30) NULL,
    CONSTRAINT PK_BARBEARIA PRIMARY KEY (id_barbearia)
);
GO

-- 2. TABELA: dbo.USUARIO (7 campos)
IF OBJECT_ID(N'dbo.USUARIO', N'U') IS NULL
CREATE TABLE dbo.USUARIO (
    id_usuario INT IDENTITY(1,1) NOT NULL,
    nm_usuario NVARCHAR(120) NULL,
    email_login VARCHAR(254) NULL,
    senha_hash VARCHAR(255) NULL,
    telefone VARCHAR(20) NULL,
    dt_cadastro DATETIME2(0) NULL,
    st_usuario VARCHAR(30) NULL,
    CONSTRAINT PK_USUARIO PRIMARY KEY (id_usuario),
    CONSTRAINT UQ_USUARIO_email_login UNIQUE (email_login)
);
GO

-- 3. TABELA: dbo.SERVICO (3 campos)
IF OBJECT_ID(N'dbo.SERVICO', N'U') IS NULL
CREATE TABLE dbo.SERVICO (
    id_servico INT IDENTITY(1,1) NOT NULL,
    nm_servico NVARCHAR(120) NULL,
    categoria_servico VARCHAR(30) NULL,
    CONSTRAINT PK_SERVICO PRIMARY KEY (id_servico)
);
GO

-- 4. TABELA: dbo.FORNECEDOR (6 campos)
IF OBJECT_ID(N'dbo.FORNECEDOR', N'U') IS NULL
CREATE TABLE dbo.FORNECEDOR (
    id_fornecedor INT IDENTITY(1,1) NOT NULL,
    nm_fornecedor NVARCHAR(120) NULL,
    telefone VARCHAR(20) NULL,
    email VARCHAR(254) NULL,
    cidade NVARCHAR(160) NULL,
    st_fornecedor VARCHAR(30) NULL,
    CONSTRAINT PK_FORNECEDOR PRIMARY KEY (id_fornecedor)
);
GO
USE DB_estudioXXI;
GO

-- 5. TABELA: dbo.PRODUTO (6 campos)
IF OBJECT_ID(N'dbo.PRODUTO', N'U') IS NULL
CREATE TABLE dbo.PRODUTO (
    id_produto INT IDENTITY(1,1) NOT NULL,
    nm_produto NVARCHAR(120) NULL,
    tipo_produto NVARCHAR(160) NULL,
    unidade_medida VARCHAR(30) NULL,
    estoque_minimo_padrao INT NULL,
    st_produto VARCHAR(30) NULL,
    CONSTRAINT PK_PRODUTO PRIMARY KEY (id_produto)
);
GO

-- 6. TABELA: dbo.CLIENTE (1 campo - PK/FK herdada sem IDENTITY)
IF OBJECT_ID(N'dbo.CLIENTE', N'U') IS NULL
CREATE TABLE dbo.CLIENTE (
    id_usuario INT NOT NULL,
    CONSTRAINT PK_CLIENTE PRIMARY KEY (id_usuario),
    CONSTRAINT FK_CLIENTE_USUARIO FOREIGN KEY (id_usuario)
        REFERENCES dbo.USUARIO (id_usuario)
        ON DELETE NO ACTION
);
GO

-- 7. TABELA: dbo.FUNCIONARIO (1 campo - PK/FK herdada sem IDENTITY)
IF OBJECT_ID(N'dbo.FUNCIONARIO', N'U') IS NULL
CREATE TABLE dbo.FUNCIONARIO (
    id_usuario INT NOT NULL,
    CONSTRAINT PK_FUNCIONARIO PRIMARY KEY (id_usuario),
    CONSTRAINT FK_FUNCIONARIO_USUARIO FOREIGN KEY (id_usuario)
        REFERENCES dbo.USUARIO (id_usuario)
        ON DELETE NO ACTION
);
GO

-- 8. TABELA: dbo.GESTAO_BARBEARIA (7 campos)
IF OBJECT_ID(N'dbo.GESTAO_BARBEARIA', N'U') IS NULL
CREATE TABLE dbo.GESTAO_BARBEARIA (
    id_gestao INT IDENTITY(1,1) NOT NULL,
    tipo_gestao NVARCHAR(160) NULL,
    dt_inicio DATETIME2(0) NULL,
    dt_fim DATETIME2(0) NULL,
    st_gestao VARCHAR(30) NULL,
    id_usuario INT NOT NULL,
    id_barbearia INT NOT NULL,
    CONSTRAINT PK_GESTAO_BARBEARIA PRIMARY KEY (id_gestao),
    CONSTRAINT FK_GESTAO_BARBEARIA_USUARIO FOREIGN KEY (id_usuario)
        REFERENCES dbo.USUARIO (id_usuario)
        ON DELETE NO ACTION,
    CONSTRAINT FK_GESTAO_BARBEARIA_BARBEARIA FOREIGN KEY (id_barbearia)
        REFERENCES dbo.BARBEARIA (id_barbearia)
        ON DELETE NO ACTION
);
GO
-- --------------------------------------------------
USE DB_estudioXXI;
GO

-- 9. TABELA: dbo.ALOCACAO (7 campos)
IF OBJECT_ID(N'dbo.ALOCACAO', N'U') IS NULL
CREATE TABLE dbo.ALOCACAO (
    id_alocacao INT IDENTITY(1,1) NOT NULL,
    funcao NVARCHAR(120) NULL,
    dt_inicio DATETIME2(0) NULL,
    dt_fim DATETIME2(0) NULL,
    st_alocacao VARCHAR(30) NULL,
    id_barbearia INT NOT NULL,
    id_funcionario INT NOT NULL,
    CONSTRAINT PK_ALOCACAO PRIMARY KEY (id_alocacao),
    CONSTRAINT FK_ALOCACAO_BARBEARIA FOREIGN KEY (id_barbearia)
        REFERENCES dbo.BARBEARIA (id_barbearia)
        ON DELETE NO ACTION,
    CONSTRAINT FK_ALOCACAO_FUNCIONARIO FOREIGN KEY (id_funcionario)
        REFERENCES dbo.FUNCIONARIO (id_usuario)
        ON DELETE NO ACTION
);
GO

-- 10. TABELA: dbo.OFERTA_SERVICO (6 campos)
IF OBJECT_ID(N'dbo.OFERTA_SERVICO', N'U') IS NULL
CREATE TABLE dbo.OFERTA_SERVICO (
    id_oferta INT IDENTITY(1,1) NOT NULL,
    preco DECIMAL(14,2) NULL,
    duracao_minutos INT NULL,
    st_oferta VARCHAR(30) NULL,
    id_barbearia INT NOT NULL,
    id_servico INT NOT NULL,
    CONSTRAINT PK_OFERTA_SERVICO PRIMARY KEY (id_oferta),
    CONSTRAINT FK_OFERTA_SERVICO_BARBEARIA FOREIGN KEY (id_barbearia)
        REFERENCES dbo.BARBEARIA (id_barbearia)
        ON DELETE NO ACTION,
    CONSTRAINT FK_OFERTA_SERVICO_SERVICO FOREIGN KEY (id_servico)
        REFERENCES dbo.SERVICO (id_servico)
        ON DELETE NO ACTION
);
GO

-- 11. TABELA: dbo.PRECO_CLIENTE (9 campos)
IF OBJECT_ID(N'dbo.PRECO_CLIENTE', N'U') IS NULL
CREATE TABLE dbo.PRECO_CLIENTE (
    id_preco_cliente INT IDENTITY(1,1) NOT NULL,
    valor_acordado DECIMAL(14,2) NULL,
    dt_inicio DATETIME2(0) NULL,
    dt_fim DATETIME2(0) NULL,
    criterio NVARCHAR(500) NULL,
    referencia_reajuste NVARCHAR(500) NULL,
    observacao NVARCHAR(500) NULL,
    id_cliente INT NOT NULL,
    id_oferta INT NOT NULL,
    CONSTRAINT PK_PRECO_CLIENTE PRIMARY KEY (id_preco_cliente),
    CONSTRAINT FK_PRECO_CLIENTE_CLIENTE FOREIGN KEY (id_cliente)
        REFERENCES dbo.CLIENTE (id_usuario)
        ON DELETE NO ACTION,
    CONSTRAINT FK_PRECO_CLIENTE_OFERTA_SERVICO FOREIGN KEY (id_oferta)
        REFERENCES dbo.OFERTA_SERVICO (id_oferta)
        ON DELETE NO ACTION
);
GO

-- 12. TABELA: dbo.COMBO (7 campos)
IF OBJECT_ID(N'dbo.COMBO', N'U') IS NULL
CREATE TABLE dbo.COMBO (
    id_combo INT IDENTITY(1,1) NOT NULL,
    nm_combo NVARCHAR(120) NULL,
    percentual_desconto DECIMAL(5,2) NULL,
    dt_inicio DATETIME2(0) NULL,
    dt_fim DATETIME2(0) NULL,
    st_combo VARCHAR(30) NULL,
    id_barbearia INT NOT NULL,
    CONSTRAINT PK_COMBO PRIMARY KEY (id_combo),
    CONSTRAINT FK_COMBO_BARBEARIA FOREIGN KEY (id_barbearia)
        REFERENCES dbo.BARBEARIA (id_barbearia)
        ON DELETE NO ACTION
);
GO
-- --------------------------------------------------

USE DB_estudioXXI;
GO

-- 13. TABELA: dbo.ITEM_COMBO (3 campos)
IF OBJECT_ID(N'dbo.ITEM_COMBO', N'U') IS NULL
CREATE TABLE dbo.ITEM_COMBO (
    id_item_combo INT IDENTITY(1,1) NOT NULL,
    id_servico INT NOT NULL,
    id_combo INT NOT NULL,
    CONSTRAINT PK_ITEM_COMBO PRIMARY KEY (id_item_combo),
    CONSTRAINT FK_ITEM_COMBO_SERVICO FOREIGN KEY (id_servico)
        REFERENCES dbo.SERVICO (id_servico)
        ON DELETE NO ACTION,
    CONSTRAINT FK_ITEM_COMBO_COMBO FOREIGN KEY (id_combo)
        REFERENCES dbo.COMBO (id_combo)
        ON DELETE NO ACTION
);
GO

-- 14. TABELA: dbo.REGRA_BENEFICIO (9 campos)
IF OBJECT_ID(N'dbo.REGRA_BENEFICIO', N'U') IS NULL
CREATE TABLE dbo.REGRA_BENEFICIO (
    id_regra_beneficio INT IDENTITY(1,1) NOT NULL,
    nm_regra NVARCHAR(120) NULL,
    tipo_regra VARCHAR(30) NULL,
    qtd_cortes_exigida INT NULL,
    criterio_elegibilidade NVARCHAR(500) NULL,
    dt_inicio DATETIME2(0) NULL,
    dt_fim DATETIME2(0) NULL,
    st_regra VARCHAR(30) NULL,
    id_barbearia INT NOT NULL,
    CONSTRAINT PK_REGRA_BENEFICIO PRIMARY KEY (id_regra_beneficio),
    CONSTRAINT FK_REGRA_BENEFICIO_BARBEARIA FOREIGN KEY (id_barbearia)
        REFERENCES dbo.BARBEARIA (id_barbearia)
        ON DELETE NO ACTION
);
GO

-- 15. TABELA: dbo.SERVICO_BENEFICIO (3 campos)
IF OBJECT_ID(N'dbo.SERVICO_BENEFICIO', N'U') IS NULL
CREATE TABLE dbo.SERVICO_BENEFICIO (
    id_servico_beneficio INT IDENTITY(1,1) NOT NULL,
    id_servico INT NOT NULL,
    id_regra_beneficio INT NOT NULL,
    CONSTRAINT PK_SERVICO_BENEFICIO PRIMARY KEY (id_servico_beneficio),
    CONSTRAINT FK_SERVICO_BENEFICIO_SERVICO FOREIGN KEY (id_servico)
        REFERENCES dbo.SERVICO (id_servico)
        ON DELETE NO ACTION,
    CONSTRAINT FK_SERVICO_BENEFICIO_REGRA_BENEFICIO FOREIGN KEY (id_regra_beneficio)
        REFERENCES dbo.REGRA_BENEFICIO (id_regra_beneficio)
        ON DELETE NO ACTION
);
GO

-- 16. TABELA: dbo.AGENDAMENTO (5 campos)
IF OBJECT_ID(N'dbo.AGENDAMENTO', N'U') IS NULL
CREATE TABLE dbo.AGENDAMENTO (
    id_agendamento INT IDENTITY(1,1) NOT NULL,
    dt_hora_inicio DATETIME2(0) NULL,
    st_agendamento VARCHAR(30) NULL,
    id_cliente INT NOT NULL,
    id_alocacao INT NOT NULL,
    CONSTRAINT PK_AGENDAMENTO PRIMARY KEY (id_agendamento),
    CONSTRAINT FK_AGENDAMENTO_CLIENTE FOREIGN KEY (id_cliente)
        REFERENCES dbo.CLIENTE (id_usuario)
        ON DELETE NO ACTION,
    CONSTRAINT FK_AGENDAMENTO_ALOCACAO FOREIGN KEY (id_alocacao)
        REFERENCES dbo.ALOCACAO (id_alocacao)
        ON DELETE NO ACTION
);
GO
USE DB_estudioXXI;
GO

-- 17. TABELA: dbo.ITEM_AGENDAMENTO (9 campos)
IF OBJECT_ID(N'dbo.ITEM_AGENDAMENTO', N'U') IS NULL
CREATE TABLE dbo.ITEM_AGENDAMENTO (
    id_item_agendamento INT IDENTITY(1,1) NOT NULL,
    ordem_execucao INT NULL,
    preco_aplicado DECIMAL(14,2) NULL,
    duracao_aplicada_min INT NULL,
    percentual_desconto_aplicado DECIMAL(5,2) NULL,
    id_combo INT NULL,
    id_preco_cliente INT NULL,
    id_oferta INT NOT NULL,
    id_agendamento INT NOT NULL,
    CONSTRAINT PK_ITEM_AGENDAMENTO PRIMARY KEY (id_item_agendamento),
    CONSTRAINT FK_ITEM_AGENDAMENTO_COMBO FOREIGN KEY (id_combo)
        REFERENCES dbo.COMBO (id_combo)
        ON DELETE NO ACTION,
    CONSTRAINT FK_ITEM_AGENDAMENTO_PRECO_CLIENTE FOREIGN KEY (id_preco_cliente)
        REFERENCES dbo.PRECO_CLIENTE (id_preco_cliente)
        ON DELETE NO ACTION,
    CONSTRAINT FK_ITEM_AGENDAMENTO_OFERTA_SERVICO FOREIGN KEY (id_oferta)
        REFERENCES dbo.OFERTA_SERVICO (id_oferta)
        ON DELETE NO ACTION,
    CONSTRAINT FK_ITEM_AGENDAMENTO_AGENDAMENTO FOREIGN KEY (id_agendamento)
        REFERENCES dbo.AGENDAMENTO (id_agendamento)
        ON DELETE NO ACTION
);
GO

-- 18. TABELA: dbo.ATENDIMENTO (6 campos)
IF OBJECT_ID(N'dbo.ATENDIMENTO', N'U') IS NULL
CREATE TABLE dbo.ATENDIMENTO (
    id_atendimento INT IDENTITY(1,1) NOT NULL,
    dt_atendimento DATETIME2(0) NULL,
    valor_total_cobrado DECIMAL(14,2) NULL,
    observacao NVARCHAR(500) NULL,
    id_agendamento INT NOT NULL,
    id_alocacao INT NOT NULL,
    CONSTRAINT PK_ATENDIMENTO PRIMARY KEY (id_atendimento),
    CONSTRAINT UQ_ATENDIMENTO_id_agendamento UNIQUE (id_agendamento),
    CONSTRAINT FK_ATENDIMENTO_AGENDAMENTO FOREIGN KEY (id_agendamento)
        REFERENCES dbo.AGENDAMENTO (id_agendamento)
        ON DELETE NO ACTION,
    CONSTRAINT FK_ATENDIMENTO_ALOCACAO FOREIGN KEY (id_alocacao)
        REFERENCES dbo.ALOCACAO (id_alocacao)
        ON DELETE NO ACTION
);
GO

-- 19. TABELA: dbo.CORTESIA (8 campos)
IF OBJECT_ID(N'dbo.CORTESIA', N'U') IS NULL
CREATE TABLE dbo.CORTESIA (
    id_cortesia INT IDENTITY(1,1) NOT NULL,
    dt_concessao DATETIME2(0) NULL,
    motivo NVARCHAR(500) NULL,
    st_cortesia VARCHAR(30) NULL,
    observacao NVARCHAR(500) NULL,
    id_cliente INT NOT NULL,
    id_regra_beneficio INT NOT NULL,
    id_atendimento INT NULL,
    CONSTRAINT PK_CORTESIA PRIMARY KEY (id_cortesia),
    CONSTRAINT FK_CORTESIA_CLIENTE FOREIGN KEY (id_cliente)
        REFERENCES dbo.CLIENTE (id_usuario)
        ON DELETE NO ACTION,
    CONSTRAINT FK_CORTESIA_REGRA_BENEFICIO FOREIGN KEY (id_regra_beneficio)
        REFERENCES dbo.REGRA_BENEFICIO (id_regra_beneficio)
        ON DELETE NO ACTION,
    CONSTRAINT FK_CORTESIA_ATENDIMENTO FOREIGN KEY (id_atendimento)
        REFERENCES dbo.ATENDIMENTO (id_atendimento)
        ON DELETE NO ACTION
);
GO

-- 20. TABELA: dbo.RESGATA_CORTESIA (2 campos - PK Composta sem IDENTITY)
IF OBJECT_ID(N'dbo.RESGATA_CORTESIA', N'U') IS NULL
CREATE TABLE dbo.RESGATA_CORTESIA (
    id_cortesia INT NOT NULL,
    id_item_agendamento INT NOT NULL,
    CONSTRAINT PK_RESGATA_CORTESIA PRIMARY KEY (id_cortesia, id_item_agendamento),
    CONSTRAINT UQ_RESGATA_CORTESIA_id_cortesia UNIQUE (id_cortesia),
    CONSTRAINT UQ_RESGATA_CORTESIA_id_item_agendamento UNIQUE (id_item_agendamento),
    CONSTRAINT FK_RESGATA_CORTESIA_CORTESIA FOREIGN KEY (id_cortesia)
        REFERENCES dbo.CORTESIA (id_cortesia)
        ON DELETE NO ACTION,
    CONSTRAINT FK_RESGATA_CORTESIA_ITEM_AGENDAMENTO FOREIGN KEY (id_item_agendamento)
        REFERENCES dbo.ITEM_AGENDAMENTO (id_item_agendamento)
        ON DELETE NO ACTION
);
GO
USE DB_estudioXXI;
GO

-- 21. TABELA: dbo.COMPRA (6 campos)
IF OBJECT_ID(N'dbo.COMPRA', N'U') IS NULL
CREATE TABLE dbo.COMPRA (
    id_compra INT IDENTITY(1,1) NOT NULL,
    dt_compra DATETIME2(0) NULL,
    st_compra VARCHAR(30) NULL,
    observacao NVARCHAR(500) NULL,
    id_barbearia INT NOT NULL,
    id_fornecedor INT NULL,
    CONSTRAINT PK_COMPRA PRIMARY KEY (id_compra),
    CONSTRAINT FK_COMPRA_BARBEARIA FOREIGN KEY (id_barbearia)
        REFERENCES dbo.BARBEARIA (id_barbearia)
        ON DELETE NO ACTION,
    CONSTRAINT FK_COMPRA_FORNECEDOR FOREIGN KEY (id_fornecedor)
        REFERENCES dbo.FORNECEDOR (id_fornecedor)
        ON DELETE SET NULL
);
GO

-- 22. TABELA: dbo.ITEM_COMPRA (5 campos)
IF OBJECT_ID(N'dbo.ITEM_COMPRA', N'U') IS NULL
CREATE TABLE dbo.ITEM_COMPRA (
    id_item_compra INT IDENTITY(1,1) NOT NULL,
    quantidade DECIMAL(14,3) NULL,
    valor_unitario DECIMAL(14,2) NULL,
    id_produto INT NOT NULL,
    id_compra INT NOT NULL,
    CONSTRAINT PK_ITEM_COMPRA PRIMARY KEY (id_item_compra),
    CONSTRAINT FK_ITEM_COMPRA_PRODUTO FOREIGN KEY (id_produto)
        REFERENCES dbo.PRODUTO (id_produto)
        ON DELETE NO ACTION,
    CONSTRAINT FK_ITEM_COMPRA_COMPRA FOREIGN KEY (id_compra)
        REFERENCES dbo.COMPRA (id_compra)
        ON DELETE NO ACTION
);
GO

-- 23. TABELA: dbo.CONTA_PAGAR (9 campos)
IF OBJECT_ID(N'dbo.CONTA_PAGAR', N'U') IS NULL
CREATE TABLE dbo.CONTA_PAGAR (
    id_conta_pagar INT IDENTITY(1,1) NOT NULL,
    descricao NVARCHAR(500) NULL,
    categoria NVARCHAR(120) NULL,
    nr_parcela INT NULL,
    valor_devido DECIMAL(14,2) NULL,
    dt_vencimento DATETIME2(0) NULL,
    st_conta VARCHAR(30) NULL,
    id_barbearia INT NOT NULL,
    id_compra INT NULL,
    CONSTRAINT PK_CONTA_PAGAR PRIMARY KEY (id_conta_pagar),
    CONSTRAINT FK_CONTA_PAGAR_BARBEARIA FOREIGN KEY (id_barbearia)
        REFERENCES dbo.BARBEARIA (id_barbearia)
        ON DELETE NO ACTION,
    CONSTRAINT FK_CONTA_PAGAR_COMPRA FOREIGN KEY (id_compra)
        REFERENCES dbo.COMPRA (id_compra)
        ON DELETE NO ACTION
);
GO

-- 24. TABELA: dbo.PAGAMENTO (7 campos)
IF OBJECT_ID(N'dbo.PAGAMENTO', N'U') IS NULL
CREATE TABLE dbo.PAGAMENTO (
    id_pagamento INT IDENTITY(1,1) NOT NULL,
    dt_pagamento DATETIME2(0) NULL,
    valor_pago DECIMAL(14,2) NULL,
    forma_pagamento NVARCHAR(120) NULL,
    referencia_transacao VARCHAR(120) NULL,
    st_pagamento VARCHAR(30) NULL,
    id_conta_pagar INT NOT NULL,
    CONSTRAINT PK_PAGAMENTO PRIMARY KEY (id_pagamento),
    CONSTRAINT FK_PAGAMENTO_CONTA_PAGAR FOREIGN KEY (id_conta_pagar)
        REFERENCES dbo.CONTA_PAGAR (id_conta_pagar)
        ON DELETE NO ACTION
);
GO
USE DB_estudioXXI;
GO

-- 25. TABELA: dbo.VENDA (6 campos)
IF OBJECT_ID(N'dbo.VENDA', N'U') IS NULL
CREATE TABLE dbo.VENDA (
    id_venda INT IDENTITY(1,1) NOT NULL,
    dt_venda DATETIME2(0) NULL,
    st_venda VARCHAR(30) NULL,
    observacao NVARCHAR(500) NULL,
    id_barbearia INT NOT NULL,
    id_cliente INT NULL,
    CONSTRAINT PK_VENDA PRIMARY KEY (id_venda),
    CONSTRAINT FK_VENDA_BARBEARIA FOREIGN KEY (id_barbearia)
        REFERENCES dbo.BARBEARIA (id_barbearia)
        ON DELETE NO ACTION,
    CONSTRAINT FK_VENDA_CLIENTE FOREIGN KEY (id_cliente)
        REFERENCES dbo.CLIENTE (id_usuario)
        ON DELETE SET NULL
);
GO

-- 26. TABELA: dbo.ITEM_VENDA (5 campos)
IF OBJECT_ID(N'dbo.ITEM_VENDA', N'U') IS NULL
CREATE TABLE dbo.ITEM_VENDA (
    id_item_venda INT IDENTITY(1,1) NOT NULL,
    quantidade DECIMAL(14,3) NULL,
    preco_unitario_aplicado DECIMAL(14,2) NULL,
    id_produto INT NOT NULL,
    id_venda INT NOT NULL,
    CONSTRAINT PK_ITEM_VENDA PRIMARY KEY (id_item_venda),
    CONSTRAINT FK_ITEM_VENDA_PRODUTO FOREIGN KEY (id_produto)
        REFERENCES dbo.PRODUTO (id_produto)
        ON DELETE NO ACTION,
    CONSTRAINT FK_ITEM_VENDA_VENDA FOREIGN KEY (id_venda)
        REFERENCES dbo.VENDA (id_venda)
        ON DELETE NO ACTION
);
GO

-- 27. TABELA: dbo.MOVIMENTACAO_ESTOQUE (11 campos)
IF OBJECT_ID(N'dbo.MOVIMENTACAO_ESTOQUE', N'U') IS NULL
CREATE TABLE dbo.MOVIMENTACAO_ESTOQUE (
    id_movimentacao INT IDENTITY(1,1) NOT NULL,
    dt_movimentacao DATETIME2(0) NULL,
    tipo_movimentacao VARCHAR(30) NULL,
    quantidade DECIMAL(14,3) NULL,
    custo_unitario_aplicado DECIMAL(14,2) NULL,
    motivo NVARCHAR(500) NULL,
    observacao NVARCHAR(500) NULL,
    id_produto INT NOT NULL,
    id_alocacao INT NOT NULL,
    id_item_compra INT NULL,
    id_item_venda INT NULL,
    CONSTRAINT PK_MOVIMENTACAO_ESTOQUE PRIMARY KEY (id_movimentacao),
    CONSTRAINT FK_MOVIMENTACAO_ESTOQUE_PRODUTO FOREIGN KEY (id_produto)
        REFERENCES dbo.PRODUTO (id_produto)
        ON DELETE NO ACTION,
    CONSTRAINT FK_MOVIMENTACAO_ESTOQUE_ALOCACAO FOREIGN KEY (id_alocacao)
        REFERENCES dbo.ALOCACAO (id_alocacao)
        ON DELETE NO ACTION,
    CONSTRAINT FK_MOVIMENTACAO_ESTOQUE_ITEM_COMPRA FOREIGN KEY (id_item_compra)
        REFERENCES dbo.ITEM_COMPRA (id_item_compra)
        ON DELETE NO ACTION,
    CONSTRAINT FK_MOVIMENTACAO_ESTOQUE_ITEM_VENDA FOREIGN KEY (id_item_venda)
        REFERENCES dbo.ITEM_VENDA (id_item_venda)
        ON DELETE NO ACTION
);
GO

-- 28. TABELA: dbo.CONTA_RECEBER (8 campos)
IF OBJECT_ID(N'dbo.CONTA_RECEBER', N'U') IS NULL
CREATE TABLE dbo.CONTA_RECEBER (
    id_conta_receber INT IDENTITY(1,1) NOT NULL,
    descricao NVARCHAR(500) NULL,
    nr_parcela INT NULL,
    valor_devido DECIMAL(14,2) NULL,
    dt_vencimento DATETIME2(0) NULL,
    st_conta VARCHAR(30) NULL,
    id_atendimento INT NULL,
    id_venda INT NULL,
    CONSTRAINT PK_CONTA_RECEBER PRIMARY KEY (id_conta_receber),
    CONSTRAINT FK_CONTA_RECEBER_ATENDIMENTO FOREIGN KEY (id_atendimento)
        REFERENCES dbo.ATENDIMENTO (id_atendimento)
        ON DELETE NO ACTION,
    CONSTRAINT FK_CONTA_RECEBER_VENDA FOREIGN KEY (id_venda)
        REFERENCES dbo.VENDA (id_venda)
        ON DELETE NO ACTION
);
GO
USE DB_estudioXXI;
GO

-- 29. TABELA: dbo.RECEBIMENTO (9 campos)
IF OBJECT_ID(N'dbo.RECEBIMENTO', N'U') IS NULL
CREATE TABLE dbo.RECEBIMENTO (
    id_recebimento INT IDENTITY(1,1) NOT NULL,
    dt_recebimento DATETIME2(0) NULL,
    valor_recebido DECIMAL(14,2) NULL,
    forma_pagamento NVARCHAR(120) NULL,
    referencia_transacao VARCHAR(120) NULL,
    st_recebimento VARCHAR(30) NULL,
    valor_taxa DECIMAL(14,2) NULL,
    tipo_recebimento VARCHAR(30) NULL,
    id_conta_receber INT NOT NULL,
    CONSTRAINT PK_RECEBIMENTO PRIMARY KEY (id_recebimento),
    CONSTRAINT FK_RECEBIMENTO_CONTA_RECEBER FOREIGN KEY (id_conta_receber)
        REFERENCES dbo.CONTA_RECEBER (id_conta_receber)
        ON DELETE NO ACTION
);
GO

-- 30. TABELA: dbo.DEVOLUCAO_RECEBIMENTO (8 campos)
IF OBJECT_ID(N'dbo.DEVOLUCAO_RECEBIMENTO', N'U') IS NULL
CREATE TABLE dbo.DEVOLUCAO_RECEBIMENTO (
    id_devolucao INT IDENTITY(1,1) NOT NULL,
    dt_devolucao DATETIME2(0) NULL,
    valor_devolvido DECIMAL(14,2) NULL,
    forma_devolucao NVARCHAR(120) NULL,
    motivo NVARCHAR(500) NULL,
    referencia_transacao VARCHAR(120) NULL,
    st_devolucao VARCHAR(30) NULL,
    id_recebimento INT NOT NULL,
    CONSTRAINT PK_DEVOLUCAO_RECEBIMENTO PRIMARY KEY (id_devolucao),
    CONSTRAINT FK_DEVOLUCAO_RECEBIMENTO_RECEBIMENTO FOREIGN KEY (id_recebimento)
        REFERENCES dbo.RECEBIMENTO (id_recebimento)
        ON DELETE NO ACTION
);
GO

-- 31. TABELA: dbo.CREDITO_CLIENTE (7 campos)
IF OBJECT_ID(N'dbo.CREDITO_CLIENTE', N'U') IS NULL
CREATE TABLE dbo.CREDITO_CLIENTE (
    id_credito INT IDENTITY(1,1) NOT NULL,
    dt_concessao DATETIME2(0) NULL,
    valor_concedido DECIMAL(14,2) NULL,
    motivo NVARCHAR(500) NULL,
    st_credito VARCHAR(30) NULL,
    id_atendimento INT NOT NULL,
    id_cliente INT NOT NULL,
    CONSTRAINT PK_CREDITO_CLIENTE PRIMARY KEY (id_credito),
    CONSTRAINT FK_CREDITO_CLIENTE_ATENDIMENTO FOREIGN KEY (id_atendimento)
        REFERENCES dbo.ATENDIMENTO (id_atendimento)
        ON DELETE NO ACTION,
    CONSTRAINT FK_CREDITO_CLIENTE_CLIENTE FOREIGN KEY (id_cliente)
        REFERENCES dbo.CLIENTE (id_usuario)
        ON DELETE NO ACTION
);
GO

-- 32. TABELA: dbo.UTILIZACAO_CREDITO (6 campos)
IF OBJECT_ID(N'dbo.UTILIZACAO_CREDITO', N'U') IS NULL
CREATE TABLE dbo.UTILIZACAO_CREDITO (
    id_utilizacao_credito INT IDENTITY(1,1) NOT NULL,
    dt_utilizacao DATETIME2(0) NULL,
    valor_utilizado DECIMAL(14,2) NULL,
    st_utilizacao VARCHAR(30) NULL,
    id_credito INT NOT NULL,
    id_conta_receber INT NOT NULL,
    CONSTRAINT PK_UTILIZACAO_CREDITO PRIMARY KEY (id_utilizacao_credito),
    CONSTRAINT FK_UTILIZACAO_CREDITO_CREDITO_CLIENTE FOREIGN KEY (id_credito)
        REFERENCES dbo.CREDITO_CLIENTE (id_credito)
        ON DELETE NO ACTION,
    CONSTRAINT FK_UTILIZACAO_CREDITO_CONTA_RECEBER FOREIGN KEY (id_conta_receber)
        REFERENCES dbo.CONTA_RECEBER (id_conta_receber)
        ON DELETE NO ACTION
);
GO
USE DB_estudioXXI;
GO

-- 1. Restrições CHECK de origem e quantidade
ALTER TABLE dbo.CONTA_RECEBER ADD CONSTRAINT CK_CONTA_RECEBER_ORIGEM_XOR CHECK (
    (id_atendimento IS NOT NULL AND id_venda IS NULL)
 OR (id_atendimento IS NULL AND id_venda IS NOT NULL)
);

ALTER TABLE dbo.MOVIMENTACAO_ESTOQUE ADD CONSTRAINT CK_MOVIMENTACAO_ORIGEM CHECK (
    id_item_compra IS NULL OR id_item_venda IS NULL
);
ALTER TABLE dbo.MOVIMENTACAO_ESTOQUE ADD CONSTRAINT CK_MOVIMENTACAO_QTD_POSITIVA CHECK (quantidade > 0);

-- 2. Índices Únicos Compostos (5 índices)
CREATE UNIQUE INDEX UX_ITEM_COMBO_COMBO_SERVICO ON dbo.ITEM_COMBO (id_combo, id_servico);
CREATE UNIQUE INDEX UX_ITEM_COMPRA_COMPRA_PRODUTO ON dbo.ITEM_COMPRA (id_compra, id_produto);
CREATE UNIQUE INDEX UX_ITEM_VENDA_VENDA_PRODUTO ON dbo.ITEM_VENDA (id_venda, id_produto);
CREATE UNIQUE INDEX UX_ITEM_AGENDAMENTO_AG_OFERTA ON dbo.ITEM_AGENDAMENTO (id_agendamento, id_oferta);
CREATE UNIQUE INDEX UX_SERVICO_BENEFICIO_REGRA_SERVICO ON dbo.SERVICO_BENEFICIO (id_regra_beneficio, id_servico);

-- 3. Restrições CHECK de valores e descontos (6 checks)
ALTER TABLE dbo.CONTA_RECEBER ADD CONSTRAINT CK_CONTA_RECEBER_VALOR CHECK (valor_devido >= 0);
ALTER TABLE dbo.CONTA_PAGAR ADD CONSTRAINT CK_CONTA_PAGAR_VALOR CHECK (valor_devido >= 0);
ALTER TABLE dbo.RECEBIMENTO ADD CONSTRAINT CK_RECEBIMENTO_VALOR CHECK (valor_recebido > 0);
ALTER TABLE dbo.PAGAMENTO ADD CONSTRAINT CK_PAGAMENTO_VALOR CHECK (valor_pago > 0);
ALTER TABLE dbo.ITEM_AGENDAMENTO ADD CONSTRAINT CK_ITEM_AG_DESCONTO CHECK (percentual_desconto_aplicado BETWEEN 0 AND 100);
ALTER TABLE dbo.COMBO ADD CONSTRAINT CK_COMBO_DESCONTO CHECK (percentual_desconto BETWEEN 0 AND 100);
GO

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

USE DB_estudioXXI;
GO

SELECT
    (SELECT COUNT(*) FROM sys.tables WHERE is_ms_shipped = 0) AS [Tabelas (Meta: 32)],
    (SELECT COUNT(*) FROM sys.columns c JOIN sys.tables t ON c.object_id = t.object_id WHERE t.is_ms_shipped = 0) AS [Colunas (Meta: 201)],
    (SELECT COUNT(*) FROM sys.columns c JOIN sys.tables t ON c.object_id = t.object_id WHERE t.is_ms_shipped = 0 AND c.is_nullable = 0) AS [NOT NULL (Meta: 71)],
    (SELECT COUNT(*) FROM sys.key_constraints WHERE type = 'PK') AS [PKs (Meta: 32)],
    (SELECT COUNT(*) FROM sys.foreign_keys) AS [FKs Totais (Meta: 52)],
    (SELECT COUNT(*) FROM sys.foreign_keys WHERE delete_referential_action_desc = 'NO_ACTION') AS [FKs NO ACTION (Meta: 50)],
    (SELECT COUNT(*) FROM sys.foreign_keys WHERE delete_referential_action_desc = 'SET_NULL') AS [FKs SET NULL (Meta: 2)],
    (SELECT COUNT(*) FROM sys.foreign_keys WHERE delete_referential_action_desc = 'CASCADE') AS [FKs CASCADE (Meta: 0)],
    (SELECT COUNT(*) FROM sys.key_constraints WHERE type = 'UQ') AS [UNIQUE Simples (Meta: 4)],
    (SELECT COUNT(*) FROM sys.check_constraints) AS [CHECK Constraints (Meta: 9)];
GO
