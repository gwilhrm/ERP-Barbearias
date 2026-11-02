-- Script SQL Server: contagem de tabelas, colunas, PKs, FKs, UNIQUE e CHECK
USE DB_estudioXXI;
GO

SELECT
    Metrica = 'Tabelas Ativas',
    Esperado = 32,
    Encontrado = (SELECT COUNT(*) FROM sys.tables WHERE is_ms_shipped = 0),
    Status = CASE WHEN (SELECT COUNT(*) FROM sys.tables WHERE is_ms_shipped = 0) = 32 THEN 'CORRETO' ELSE 'DIVERGENTE' END
UNION ALL
SELECT
    'Total de Colunas (Campos)',
    201,
    (SELECT COUNT(*) FROM sys.columns c JOIN sys.tables t ON c.object_id = t.object_id WHERE t.is_ms_shipped = 0),
    CASE WHEN (SELECT COUNT(*) FROM sys.columns c JOIN sys.tables t ON c.object_id = t.object_id WHERE t.is_ms_shipped = 0) = 201 THEN 'CORRETO' ELSE 'DIVERGENTE' END
UNION ALL
SELECT
    'Campos NOT NULL',
    71,
    (SELECT COUNT(*) FROM sys.columns c JOIN sys.tables t ON c.object_id = t.object_id WHERE t.is_ms_shipped = 0 AND c.is_nullable = 0),
    CASE WHEN (SELECT COUNT(*) FROM sys.columns c JOIN sys.tables t ON c.object_id = t.object_id WHERE t.is_ms_shipped = 0 AND c.is_nullable = 0) = 71 THEN 'CORRETO' ELSE 'DIVERGENTE' END
UNION ALL
SELECT
    'Chaves Primárias (PK)',
    32,
    (SELECT COUNT(*) FROM sys.key_constraints WHERE type = 'PK'),
    CASE WHEN (SELECT COUNT(*) FROM sys.key_constraints WHERE type = 'PK') = 32 THEN 'CORRETO' ELSE 'DIVERGENTE' END
UNION ALL
SELECT
    'Chaves Estrangeiras (FK Totais)',
    52,
    (SELECT COUNT(*) FROM sys.foreign_keys),
    CASE WHEN (SELECT COUNT(*) FROM sys.foreign_keys) = 52 THEN 'CORRETO' ELSE 'DIVERGENTE' END
UNION ALL
SELECT
    'FKs ON DELETE NO ACTION',
    50,
    (SELECT COUNT(*) FROM sys.foreign_keys WHERE delete_referential_action_desc = 'NO_ACTION'),
    CASE WHEN (SELECT COUNT(*) FROM sys.foreign_keys WHERE delete_referential_action_desc = 'NO_ACTION') = 50 THEN 'CORRETO' ELSE 'DIVERGENTE' END
UNION ALL
SELECT
    'FKs ON DELETE SET NULL',
    2,
    (SELECT COUNT(*) FROM sys.foreign_keys WHERE delete_referential_action_desc = 'SET_NULL'),
    CASE WHEN (SELECT COUNT(*) FROM sys.foreign_keys WHERE delete_referential_action_desc = 'SET_NULL') = 2 THEN 'CORRETO' ELSE 'DIVERGENTE' END
UNION ALL
SELECT
    'FKs ON DELETE CASCADE',
    0,
    (SELECT COUNT(*) FROM sys.foreign_keys WHERE delete_referential_action_desc = 'CASCADE'),
    CASE WHEN (SELECT COUNT(*) FROM sys.foreign_keys WHERE delete_referential_action_desc = 'CASCADE') = 0 THEN 'CORRETO' ELSE 'DIVERGENTE' END
UNION ALL
SELECT
    'Constraints UNIQUE Individuais',
    4,
    (SELECT COUNT(*) FROM sys.key_constraints WHERE type = 'UQ'),
    CASE WHEN (SELECT COUNT(*) FROM sys.key_constraints WHERE type = 'UQ') = 4 THEN 'CORRETO' ELSE 'DIVERGENTE' END
UNION ALL
SELECT
    'Constraints CHECK',
    9,
    (SELECT COUNT(*) FROM sys.check_constraints),
    CASE WHEN (SELECT COUNT(*) FROM sys.check_constraints) = 9 THEN 'CORRETO' ELSE 'DIVERGENTE' END;
GO
