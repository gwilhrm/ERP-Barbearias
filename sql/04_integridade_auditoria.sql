-- Script SQL Server: DBCC e verificações de integridade referencial
USE DB_estudioXXI;
GO

PRINT '============================================================';
PRINT '1. INICIANDO VERIFICAÇÃO FÍSICA E LÓGICA DO BANCO (DBCC CHECKDB)';
PRINT '============================================================';
-- O DBCC CHECKDB verifica a integridade estrutural, alocação de páginas,
-- consistência de índices e relações internas de toda a base de dados.
DBCC CHECKDB ('DB_estudioXXI') WITH NO_INFOMSGS, ALL_ERRORMSGS;
GO

PRINT '============================================================';
PRINT '2. VERIFICAÇÃO DE INTEGRIDADE REFERENCIAL (CHAVES ÓRFÃS)';
PRINT '============================================================';

-- Verifica se existem clientes cujos IDs não existem na tabela base USUARIO
SELECT
    'CLIENTES ÓRFÃOS (Sem correspondência em USUARIO)' AS Tipo_Erro,
    COUNT(*) AS Total_Inconsistencias
FROM dbo.CLIENTE c
LEFT JOIN dbo.USUARIO u ON c.id_usuario = u.id_usuario
WHERE u.id_usuario IS NULL;

-- Verifica se existem funcionários cujos IDs não existem na tabela base USUARIO
SELECT
    'FUNCIONÁRIOS ÓRFÃOS (Sem correspondência em USUARIO)' AS Tipo_Erro,
    COUNT(*) AS Total_Inconsistencias
FROM dbo.FUNCIONARIO f
LEFT JOIN dbo.USUARIO u ON f.id_usuario = u.id_usuario
WHERE u.id_usuario IS NULL;

-- Verifica itens de agendamento órfãos sem agendamento válido
SELECT
    'ITENS DE AGENDAMENTO ÓRFÃOS' AS Tipo_Erro,
    COUNT(*) AS Total_Inconsistencias
FROM dbo.ITEM_AGENDAMENTO ia
LEFT JOIN dbo.AGENDAMENTO a ON ia.id_agendamento = a.id_agendamento
WHERE a.id_agendamento IS NULL;

-- Verifica contas a receber órfãs sem atendimento ou venda válida (reforçando o XOR)
SELECT
    'CONTAS A RECEBER SEM ORIGEM VÁLIDA' AS Tipo_Erro,
    COUNT(*) AS Total_Inconsistencias
FROM dbo.CONTA_RECEBER cr
WHERE (cr.id_atendimento IS NULL AND cr.id_venda IS NULL)
   OR (cr.id_atendimento IS NOT NULL AND cr.id_venda IS NOT NULL);
GO

PRINT '============================================================';
PRINT '3. AUDITORIA DE VOLUMETRIA (CONTAGEM POR TABELA)';
PRINT '============================================================';
-- Lista todas as tabelas e o número atual de registos para conferência
SELECT
    t.name AS Nome_Tabela,
    ISNULL(p.rows, 0) AS Total_Registros
FROM sys.tables t
LEFT JOIN sys.partitions p ON t.object_id = p.object_id AND p.index_id IN (0, 1)
WHERE t.is_ms_shipped = 0
ORDER BY Total_Registros DESC, t.name ASC;
GO
