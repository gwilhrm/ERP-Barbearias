-- Script SQL Server: primeira carga de demonstração
USE DB_estudioXXI;
GO

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- =========================================================================
    -- LOTE 1: TABELAS INDEPENDENTES (1 A 4)
    -- =========================================================================

    -- 1. dbo.BARBEARIA
    INSERT INTO dbo.BARBEARIA (nm_barbearia, tipo_pessoa, documento, telefone, email, endereco, dt_cadastro, st_barbearia)
    VALUES
        (N'Estúdio XXI - Matriz Centro', 'PJ', '12345678000190', '11999990001', 'matriz@estudioxxi.com.br', N'Av. Paulista, 1000 - São Paulo/SP', '2026-01-10 08:00:00', 'ATIVA'),
        (N'Estúdio XXI - Unidade Jardins', 'PJ', '98765432000110', '11999990002', 'jardins@estudioxxi.com.br', N'Rua Oscar Freire, 500 - São Paulo/SP', '2026-02-15 09:00:00', 'ATIVA');

    -- 2. dbo.USUARIO (id_usuario 1 e 2 = Gestores/Funcionários | 3 e 4 = Clientes)
    INSERT INTO dbo.USUARIO (nm_usuario, email_login, senha_hash, telefone, dt_cadastro, st_usuario)
    VALUES
        (N'Carlos Mendes', 'carlos.mendes@estudioxxi.com.br', 'HASH_SHA256_A1B2C3', '11988881111', '2026-01-10 08:30:00', 'ATIVO'),
        (N'Rafael Costa', 'rafael.costa@estudioxxi.com.br', 'HASH_SHA256_D4E5F6', '11988882222', '2026-01-12 09:00:00', 'ATIVO'),
        (N'Lucas Oliveira', 'lucas.oliveira@email.com', 'HASH_SHA256_G7H8I9', '11977773333', '2026-03-01 14:00:00', 'ATIVO'),
        (N'Marcos Souza', 'marcos.souza@email.com', 'HASH_SHA256_J0K1L2', '11977774444', '2026-03-05 16:20:00', 'ATIVO');

    -- 3. dbo.SERVICO
    INSERT INTO dbo.SERVICO (nm_servico, categoria_servico)
    VALUES
        (N'Corte Masculino Clássico', 'CABELO'),
        (N'Barba Terapia com Toalha Quente', 'BARBA'),
        (N'Design de Sobrancelha na Navalha', 'SOBRANCELHA');

    -- 4. dbo.FORNECEDOR
    INSERT INTO dbo.FORNECEDOR (nm_fornecedor, telefone, email, cidade, st_fornecedor)
    VALUES
        (N'Distribuidora BarberPro Brasil', '1133334444', 'vendas@barberpro.com.br', N'São Paulo', 'ATIVO'),
        (N'Cosméticos MenCare Ltda', '1133335555', 'contato@mencare.com.br', N'Campinas', 'ATIVO');

    -- =========================================================================
    -- LOTE 2: PRODUTOS E ESPECIALIZAÇÕES DE PESSOAL (5 A 8)
    -- =========================================================================

    -- 5. dbo.PRODUTO
    INSERT INTO dbo.PRODUTO (nm_produto, tipo_produto, unidade_medida, estoque_minimo_padrao, st_produto)
    VALUES
        (N'Pomada Modeladora Efeito Matte 120g', N'Finalizador Capilar', 'UN', 10, 'ATIVO'),
        (N'Óleo Hidratante para Barba 30ml', N'Hidratação de Barba', 'UN', 8, 'ATIVO'),
        (N'Lâmina Descartável Inox (Caixa c/ 100)', N'Insumo de Uso Interno', 'CX', 5, 'ATIVO');

    -- 6. dbo.CLIENTE (Herda id_usuario 3 e 4)
    INSERT INTO dbo.CLIENTE (id_usuario)
    VALUES
        (3),
        (4);

    -- 7. dbo.FUNCIONARIO (Herda id_usuario 1 e 2)
    INSERT INTO dbo.FUNCIONARIO (id_usuario)
    VALUES
        (1),
        (2);

    -- 8. dbo.GESTAO_BARBEARIA
    INSERT INTO dbo.GESTAO_BARBEARIA (tipo_gestao, dt_inicio, dt_fim, st_gestao, id_usuario, id_barbearia)
    VALUES
        (N'Administrador Geral', '2026-01-10 08:30:00', NULL, 'ATIVA', 1, 1),
        (N'Gerente de Unidade', '2026-02-15 09:00:00', NULL, 'ATIVA', 1, 2);

    -- =========================================================================
    -- LOTE 3: ALOCAÇÃO, OFERTAS, PREÇOS ACORDADOS E COMBOS (9 A 12)
    -- =========================================================================

    -- 9. dbo.ALOCACAO
    INSERT INTO dbo.ALOCACAO (funcao, dt_inicio, dt_fim, st_alocacao, id_barbearia, id_funcionario)
    VALUES
        (N'Barbeiro Master', '2026-01-10 08:30:00', NULL, 'ATIVA', 1, 1),
        (N'Barbeiro Sênior', '2026-01-12 09:00:00', NULL, 'ATIVA', 1, 2);

    -- 10. dbo.OFERTA_SERVICO
    INSERT INTO dbo.OFERTA_SERVICO (preco, duracao_minutos, st_oferta, id_barbearia, id_servico)
    VALUES
        (70.00, 45, 'ATIVA', 1, 1), -- Oferta 1: Corte (R$ 70)
        (50.00, 30, 'ATIVA', 1, 2), -- Oferta 2: Barba (R$ 50)
        (25.00, 15, 'ATIVA', 1, 3); -- Oferta 3: Sobrancelha (R$ 25)

    -- 11. dbo.PRECO_CLIENTE
    INSERT INTO dbo.PRECO_CLIENTE (valor_acordado, dt_inicio, dt_fim, criterio, referencia_reajuste, observacao, id_cliente, id_oferta)
    VALUES
        (60.00, '2026-03-01 00:00:00', '2026-12-31 23:59:59', N'Cliente fundador mensalista', N'Tabela congelada 2026', N'Desconto fixo no corte', 3, 1);

    -- 12. dbo.COMBO (Desconto de 15% para Cabelo + Barba)
    INSERT INTO dbo.COMBO (nm_combo, percentual_desconto, dt_inicio, dt_fim, st_combo, id_barbearia)
    VALUES
        (N'Combo Cabelo + Barba (15% OFF)', 15.00, '2026-01-10 00:00:00', NULL, 'ATIVO', 1);

    -- =========================================================================
    -- LOTE 4: ITENS DE COMBO, REGRAS DE BENEFÍCIO E AGENDAMENTO (13 A 16)
    -- =========================================================================

    -- 13. dbo.ITEM_COMBO
    INSERT INTO dbo.ITEM_COMBO (id_servico, id_combo)
    VALUES
        (1, 1), -- Corte no Combo 1
        (2, 1); -- Barba no Combo 1

    -- 14. dbo.REGRA_BENEFICIO
    INSERT INTO dbo.REGRA_BENEFICIO (nm_regra, tipo_regra, qtd_cortes_exigida, criterio_elegibilidade, dt_inicio, dt_fim, st_regra, id_barbearia)
    VALUES
        (N'Fidelidade 10 Cortes', 'FIDELIDADE_CORTES', 10, N'A cada 10 cortes pagos, ganha 1 cortesia de corte ou barba.', '2026-01-10 00:00:00', NULL, 'ATIVA', 1);

    -- 15. dbo.SERVICO_BENEFICIO
    INSERT INTO dbo.SERVICO_BENEFICIO (id_servico, id_regra_beneficio)
    VALUES
        (1, 1),
        (2, 1);

    -- 16. dbo.AGENDAMENTO
    INSERT INTO dbo.AGENDAMENTO (dt_hora_inicio, st_agendamento, id_cliente, id_alocacao)
    VALUES
        ('2026-10-25 10:00:00', 'CONCLUIDO', 3, 1),
        ('2026-10-26 15:00:00', 'CONCLUIDO', 4, 2);

    -- =========================================================================
    -- LOTE 5: ITENS DE AGENDAMENTO, ATENDIMENTO E CORTESIAS (17 A 20)
    -- =========================================================================

    -- 17. dbo.ITEM_AGENDAMENTO
    INSERT INTO dbo.ITEM_AGENDAMENTO (ordem_execucao, preco_aplicado, duracao_aplicada_min, percentual_desconto_aplicado, id_combo, id_preco_cliente, id_oferta, id_agendamento)
    VALUES
        (1, 59.50, 45, 15.00, 1, NULL, 1, 1), -- Item 1 (Agendamento 1): Corte pelo Combo 1
        (2, 42.50, 30, 15.00, 1, NULL, 2, 1), -- Item 2 (Agendamento 1): Barba pelo Combo 1
        (1, 0.00, 45, 100.00, NULL, NULL, 1, 2); -- Item 3 (Agendamento 2): Corte resgatado por Cortesia

    -- 18. dbo.ATENDIMENTO
    INSERT INTO dbo.ATENDIMENTO (dt_atendimento, valor_total_cobrado, observacao, id_agendamento, id_alocacao)
    VALUES
        ('2026-10-25 11:15:00', 102.00, N'Atendimento Combo Cabelo + Barba finalizado.', 1, 1),
        ('2026-10-26 15:45:00', 0.00, N'Atendimento pago integralmente via resgate de cortesia.', 2, 2);

    -- 19. dbo.CORTESIA
    INSERT INTO dbo.CORTESIA (dt_concessao, motivo, st_cortesia, observacao, id_cliente, id_regra_beneficio, id_atendimento)
    VALUES
        ('2026-10-20 18:00:00', N'Completou 10 cortes no programa de fidelidade', 'RESGATADA', N'Utilizada no agendamento 2', 4, 1, 1);

    -- 20. dbo.RESGATA_CORTESIA
    INSERT INTO dbo.RESGATA_CORTESIA (id_cortesia, id_item_agendamento)
    VALUES
        (1, 3);

    -- =========================================================================
    -- LOTE 6: COMPRAS DE INSUMOS E CONTAS A PAGAR (21 A 24)
    -- =========================================================================

    -- 21. dbo.COMPRA
    INSERT INTO dbo.COMPRA (dt_compra, st_compra, observacao, id_barbearia, id_fornecedor)
    VALUES
        ('2026-10-05 10:00:00', 'RECEBIDA', N'Reposição mensal de pomadas e óleos', 1, 1);

    -- 22. dbo.ITEM_COMPRA
    INSERT INTO dbo.ITEM_COMPRA (quantidade, valor_unitario, id_produto, id_compra)
    VALUES
        (20.000, 25.00, 1, 1), -- 20 Pomadas a R$ 25,00
        (15.000, 18.00, 2, 1); -- 15 Óleos a R$ 18,00

    -- 23. dbo.CONTA_PAGAR
    INSERT INTO dbo.CONTA_PAGAR (descricao, categoria, nr_parcela, valor_devido, dt_vencimento, st_conta, id_barbearia, id_compra)
    VALUES
        (N'Fatura Fornecedor BarberPro - Parcela Única', N'Estoque e Insumos', 1, 770.00, '2026-10-15 23:59:59', 'PAGA', 1, 1),
        (N'Conta de Energia Elétrica - Outubro/2026', N'Despesa Fixa', 1, 450.00, '2026-10-20 23:59:59', 'PAGA', 1, NULL);

    -- 24. dbo.PAGAMENTO
    INSERT INTO dbo.PAGAMENTO (dt_pagamento, valor_pago, forma_pagamento, referencia_transacao, st_pagamento, id_conta_pagar)
    VALUES
        ('2026-10-14 14:10:00', 770.00, N'PIX', 'PIX-PAG-20261014-001', 'CONFIRMADO', 1),
        ('2026-10-19 16:00:00', 450.00, N'Boleto Bancário', 'BOL-PAG-20261019-002', 'CONFIRMADO', 2);

    -- =========================================================================
    -- LOTE 7: VENDAS DE PRODUTOS, ESTOQUE E CONTAS A RECEBER (25 A 28)
    -- =========================================================================

    -- 25. dbo.VENDA
    INSERT INTO dbo.VENDA (dt_venda, st_venda, observacao, id_barbearia, id_cliente)
    VALUES
        ('2026-10-25 11:20:00', 'CONCLUIDA', N'Venda no balcão após atendimento', 1, 3);

    -- 26. dbo.ITEM_VENDA
    INSERT INTO dbo.ITEM_VENDA (quantidade, preco_unitario_aplicado, id_produto, id_venda)
    VALUES
        (1.000, 55.00, 1, 1), -- 1 Pomada vendida a R$ 55,00
        (1.000, 40.00, 2, 1); -- 1 Óleo vendido a R$ 40,00

    -- 27. dbo.MOVIMENTACAO_ESTOQUE (Respeita CHECK XOR de origem comercial e quantidade > 0)
    INSERT INTO dbo.MOVIMENTACAO_ESTOQUE (dt_movimentacao, tipo_movimentacao, quantidade, custo_unitario_aplicado, motivo, observacao, id_produto, id_alocacao, id_item_compra, id_item_venda)
    VALUES
        ('2026-10-05 10:30:00', 'ENTRADA_COMPRA', 20.000, 25.00, N'Entrada NF Compra 1', N'Conferido no recebimento', 1, 1, 1, NULL),
        ('2026-10-05 10:35:00', 'ENTRADA_COMPRA', 15.000, 18.00, N'Entrada NF Compra 1', N'Conferido no recebimento', 2, 1, 2, NULL),
        ('2026-10-25 11:21:00', 'SAIDA_VENDA', 1.000, 25.00, N'Baixa por Venda 1', N'Entregue ao cliente', 1, 1, NULL, 1),
        ('2026-10-25 11:21:00', 'SAIDA_VENDA', 1.000, 18.00, N'Baixa por Venda 1', N'Entregue ao cliente', 2, 1, NULL, 2);

    -- 28. dbo.CONTA_RECEBER (Respeita CHECK XOR: ou id_atendimento ou id_venda)
    INSERT INTO dbo.CONTA_RECEBER (descricao, nr_parcela, valor_devido, dt_vencimento, st_conta, id_atendimento, id_venda)
    VALUES
        (N'Recebimento Atendimento #1 (Combo)', 1, 102.00, '2026-10-25 23:59:59', 'QUITADA', 1, NULL),
        (N'Recebimento Venda Produtos #1', 1, 95.00, '2026-10-25 23:59:59', 'QUITADA', NULL, 1);

    -- =========================================================================
    -- LOTE 8: RECEBIMENTOS, DEVOLUÇÕES E CRÉDITOS DO CLIENTE (29 A 32)
    -- =========================================================================

    -- 29. dbo.RECEBIMENTO
    INSERT INTO dbo.RECEBIMENTO (dt_recebimento, valor_recebido, forma_pagamento, referencia_transacao, st_recebimento, valor_taxa, tipo_recebimento, id_conta_receber)
    VALUES
        ('2026-10-25 11:22:00', 102.00, N'Cartão de Crédito', 'NSU-900112', 'CONFIRMADO', 2.04, 'QUITACAO', 1),
        ('2026-10-25 11:23:00', 20.00, N'PIX', 'PIX-DUPLICADO-999', 'ESTORNADO', 0.00, 'COBRANCA_INDEVIDA', 1),
        ('2026-10-25 11:25:00', 80.00, N'PIX', 'PIX-REC-900115', 'CONFIRMADO', 0.00, 'QUITACAO', 2);

    -- 30. dbo.DEVOLUCAO_RECEBIMENTO
    INSERT INTO dbo.DEVOLUCAO_RECEBIMENTO (dt_devolucao, valor_devolvido, forma_devolucao, motivo, referencia_transacao, st_devolucao, id_recebimento)
    VALUES
        ('2026-10-25 11:30:00', 20.00, N'PIX', N'Devolução de cobrança em duplicidade', 'PIX-DEV-999', 'CONCLUIDA', 2);

    -- 31. dbo.CREDITO_CLIENTE
    INSERT INTO dbo.CREDITO_CLIENTE (dt_concessao, valor_concedido, motivo, st_credito, id_atendimento, id_cliente)
    VALUES
        ('2026-10-25 11:18:00', 15.00, N'Bónus de campanha promocional de aniversário', 'UTILIZADO', 1, 3);

    -- 32. dbo.UTILIZACAO_CREDITO
    INSERT INTO dbo.UTILIZACAO_CREDITO (dt_utilizacao, valor_utilizado, st_utilizacao, id_credito, id_conta_receber)
    VALUES
        ('2026-10-25 11:24:00', 15.00, 'CONFIRMADA', 1, 2);

    COMMIT TRANSACTION;
    PRINT 'SUCESSO: Carga de dados concluída nas 32 tabelas sem erros!';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'ERRO AO INSERIR DADOS: ' + ERROR_MESSAGE();
END CATCH;
GO
