-- ERP Barbearias - Estudio XXI | Grupo 8
-- Arquivo: 08_demonstracao_restricoes_dml.sql
-- Demonstra (T1-T7) que o banco impede inconsistencias e (D1-D3) UPDATE, DELETE e a regra do combo.
-- Todos os blocos usam transacao com ROLLBACK: a massa de dados original nao e alterada.
-- Procedencia: redigido com apoio de IA (Claude) na consolidacao; D2 vem do Apendice F do
-- documento do integrante. Logica testada em banco de teste (SQLite); NAO executado em SQL Server.
-- EXECUCAO EM SQL SERVER: executado em 02/11/2026, em banco vazio, na cadeia 01-08, sem erros de execucao (prints em evidencias/).
USE DB_estudioXXI;
GO
SET NOCOUNT ON;
GO

-- [T1] CHECK: desconto de combo acima de 100% (CK_COMBO_DESCONTO).
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO dbo.COMBO (nm_combo, percentual_desconto, dt_inicio, st_combo, id_barbearia)
    VALUES (N'Combo invalido', 150, '2026-11-01', 'ATIVO', 1);
    PRINT 'T1: NAO BLOQUEOU - verificar CK_COMBO_DESCONTO';
END TRY
BEGIN CATCH
    PRINT 'T1 bloqueado pelo banco: ' + ERROR_MESSAGE();
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
GO

-- [T2] CHECK: conta a receber sem origem (CK_CONTA_RECEBER_ORIGEM_XOR, RN24).
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO dbo.CONTA_RECEBER (descricao, nr_parcela, valor_devido, dt_vencimento, st_conta, id_atendimento, id_venda)
    VALUES (N'Conta sem origem', 1, 50, '2026-11-30', 'ABERTA', NULL, NULL);
    PRINT 'T2: NAO BLOQUEOU - verificar CK_CONTA_RECEBER_ORIGEM_XOR';
END TRY
BEGIN CATCH
    PRINT 'T2 bloqueado pelo banco: ' + ERROR_MESSAGE();
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
GO

-- [T3] CHECK: conta a receber com duas origens (atendimento e venda ao mesmo tempo).
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO dbo.CONTA_RECEBER (descricao, nr_parcela, valor_devido, dt_vencimento, st_conta, id_atendimento, id_venda)
    VALUES (N'Conta com duas origens', 1, 50, '2026-11-30', 'ABERTA', 1, 1);
    PRINT 'T3: NAO BLOQUEOU - verificar CK_CONTA_RECEBER_ORIGEM_XOR';
END TRY
BEGIN CATCH
    PRINT 'T3 bloqueado pelo banco: ' + ERROR_MESSAGE();
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
GO

-- [T4] CHECK: recebimento com valor negativo (CK_RECEBIMENTO_VALOR, RN25).
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO dbo.RECEBIMENTO (dt_recebimento, valor_recebido, forma_pagamento, st_recebimento, tipo_recebimento, id_conta_receber)
    VALUES ('2026-11-01 10:00:00', -10, 'PIX', 'CONFIRMADO', 'QUITACAO', 1);
    PRINT 'T4: NAO BLOQUEOU - verificar CK_RECEBIMENTO_VALOR';
END TRY
BEGIN CATCH
    PRINT 'T4 bloqueado pelo banco: ' + ERROR_MESSAGE();
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
GO

-- [T5] UNIQUE composto: mesmo produto duas vezes na mesma compra (UX_ITEM_COMPRA_COMPRA_PRODUTO, RN18).
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO dbo.ITEM_COMPRA (quantidade, valor_unitario, id_produto, id_compra)
    VALUES (5, 25, 1, 1);
    PRINT 'T5: NAO BLOQUEOU - verificar UX_ITEM_COMPRA_COMPRA_PRODUTO';
END TRY
BEGIN CATCH
    PRINT 'T5 bloqueado pelo banco: ' + ERROR_MESSAGE();
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
GO

-- [T6] UNIQUE: e-mail de login repetido (UQ_USUARIO_email_login).
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO dbo.USUARIO (nm_usuario, email_login, senha_hash, st_usuario)
    VALUES (N'Usuario duplicado', 'carlos.mendes@estudioxxi.com.br', 'HASH_TESTE', 'ATIVO');
    PRINT 'T6: NAO BLOQUEOU - verificar UQ_USUARIO_email_login';
END TRY
BEGIN CATCH
    PRINT 'T6 bloqueado pelo banco: ' + ERROR_MESSAGE();
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
GO

-- [T7] FOREIGN KEY: excluir barbearia que possui historico (ON DELETE NO ACTION, RNF05).
BEGIN TRANSACTION;
BEGIN TRY
    DELETE FROM dbo.BARBEARIA WHERE id_barbearia = 1;
    PRINT 'T7: NAO BLOQUEOU - verificar as chaves estrangeiras para BARBEARIA';
END TRY
BEGIN CATCH
    PRINT 'T7 bloqueado pelo banco: ' + ERROR_MESSAGE();
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
GO

-- [D1] UPDATE: reajustar o preco da oferta nao altera o preco ja aplicado (RN28).
BEGIN TRANSACTION;
SELECT ia.id_item_agendamento, ia.preco_aplicado, os.preco AS preco_atual_da_oferta
FROM dbo.ITEM_AGENDAMENTO AS ia
JOIN dbo.OFERTA_SERVICO AS os ON os.id_oferta = ia.id_oferta
WHERE ia.id_item_agendamento = 1;

UPDATE dbo.OFERTA_SERVICO SET preco = preco * 1.10 WHERE id_oferta = 1;

SELECT ia.id_item_agendamento, ia.preco_aplicado, os.preco AS preco_atual_da_oferta
FROM dbo.ITEM_AGENDAMENTO AS ia
JOIN dbo.OFERTA_SERVICO AS os ON os.id_oferta = ia.id_oferta
WHERE ia.id_item_agendamento = 1;
ROLLBACK TRANSACTION;
GO

-- [D2] INSERT, UPDATE e DELETE de um registro de teste, sem deixar alteracoes na base.
BEGIN TRANSACTION;
DECLARE @id_servico_teste INT;
INSERT INTO dbo.SERVICO (nm_servico, categoria_servico)
VALUES (N'Servico temporario de teste', 'TESTE');
SET @id_servico_teste = CONVERT(INT, SCOPE_IDENTITY());
UPDATE dbo.SERVICO
SET nm_servico = N'Servico temporario alterado'
WHERE id_servico = @id_servico_teste;
DELETE FROM dbo.SERVICO
WHERE id_servico = @id_servico_teste;
ROLLBACK TRANSACTION;
GO

-- [D3] Regra do combo (devolutiva 7, RN22): itens com combo e sem preco negociado devem
-- registrar preco_aplicado = preco da oferta x (1 - desconto/100).
SELECT ia.id_item_agendamento, c.nm_combo, os.preco AS preco_da_oferta,
       ia.percentual_desconto_aplicado AS desconto_aplicado,
       ia.preco_aplicado,
       CAST(os.preco * (1 - ia.percentual_desconto_aplicado / 100.0) AS DECIMAL(14,2)) AS preco_esperado
FROM dbo.ITEM_AGENDAMENTO AS ia
JOIN dbo.COMBO AS c ON c.id_combo = ia.id_combo
JOIN dbo.OFERTA_SERVICO AS os ON os.id_oferta = ia.id_oferta
WHERE ia.id_preco_cliente IS NULL
ORDER BY ia.id_item_agendamento;
GO
