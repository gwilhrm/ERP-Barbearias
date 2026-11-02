-- Script SQL Server: segunda carga, dependente da primeira
USE DB_estudioXXI;
GO

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- =========================================================================
    -- LOTE 1: EXPANSÃO DE UNIDADES, USUÁRIOS, SERVIÇOS E FORNECEDORES
    -- =========================================================================

    -- 1. dbo.BARBEARIA (Gera IDs 3, 4 e 5)
    INSERT INTO dbo.BARBEARIA (nm_barbearia, tipo_pessoa, documento, telefone, email, endereco, dt_cadastro, st_barbearia)
    VALUES
        (N'Estúdio XXI - Unidade Moema', 'PJ', '11222333000144', '11999990003', 'moema@estudioxxi.com.br', N'Av. Ibirapuera, 2100 - São Paulo/SP', '2026-03-01 09:00:00', 'ATIVA'),
        (N'Estúdio XXI - Unidade Pinheiros', 'PJ', '22333444000155', '11999990004', 'pinheiros@estudioxxi.com.br', N'Rua dos Pinheiros, 850 - São Paulo/SP', '2026-04-10 10:00:00', 'ATIVA'),
        (N'Estúdio XXI - Unidade Vila Olímpia', 'PJ', '33444555000166', '11999990005', 'vilaolimpia@estudioxxi.com.br', N'Rua Funchal, 400 - São Paulo/SP', '2026-05-20 08:30:00', 'ATIVA');

    -- 2. dbo.USUARIO (Gera IDs 5 a 8 = Funcionários | IDs 9 a 14 = Clientes)
    INSERT INTO dbo.USUARIO (nm_usuario, email_login, senha_hash, telefone, dt_cadastro, st_usuario)
    VALUES
        (N'André Silva', 'andre.silva@estudioxxi.com.br', 'HASH_SHA256_M3N4O5', '11988883333', '2026-03-01 09:30:00', 'ATIVO'),
        (N'Bruno Rocha', 'bruno.rocha@estudioxxi.com.br', 'HASH_SHA256_P6Q7R8', '11988884444', '2026-03-02 10:00:00', 'ATIVO'),
        (N'Diego Martins', 'diego.martins@estudioxxi.com.br', 'HASH_SHA256_S9T0U1', '11988885555', '2026-04-10 11:00:00', 'ATIVO'),
        (N'Felipe Almeida', 'felipe.almeida@estudioxxi.com.br', 'HASH_SHA256_V2W3X4', '11988886666', '2026-05-20 09:00:00', 'ATIVO'),
        (N'Gabriel Santos', 'gabriel.santos@email.com', 'HASH_SHA256_C1001', '11977775555', '2026-04-01 12:00:00', 'ATIVO'),
        (N'Henrique Lima', 'henrique.lima@email.com', 'HASH_SHA256_C1002', '11977776666', '2026-04-05 15:30:00', 'ATIVO'),
        (N'Igor Pereira', 'igor.pereira@email.com', 'HASH_SHA256_C1003', '11977777777', '2026-05-12 18:10:00', 'ATIVO'),
        (N'João Vitor Ferreira', 'joao.ferreira@email.com', 'HASH_SHA256_C1004', '11977778888', '2026-06-01 11:45:00', 'ATIVO'),
        (N'Leonardo Gomes', 'leonardo.gomes@email.com', 'HASH_SHA256_C1005', '11977779999', '2026-06-15 14:20:00', 'ATIVO'),
        (N'Matheus Ribeiro', 'matheus.ribeiro@email.com', 'HASH_SHA256_C1006', '11976661111', '2026-07-01 17:00:00', 'ATIVO');

    -- 3. dbo.SERVICO (Gera IDs 4 a 8)
    INSERT INTO dbo.SERVICO (nm_servico, categoria_servico)
    VALUES
        (N'Corte Degradê (Fade) na Navalha', 'CABELO'),
        (N'Pigmentação e Alinhamento de Barba', 'BARBA'),
        (N'Hidratação Capilar Profunda', 'CABELO'),
        (N'Camuflagem de Fios Brancos', 'CABELO'),
        (N'Raspar Cabeça na Máquina/Navalha', 'CABELO');

    -- 4. dbo.FORNECEDOR (Gera IDs 3 a 5)
    INSERT INTO dbo.FORNECEDOR (nm_fornecedor, telefone, email, cidade, st_fornecedor)
    VALUES
        (N'Império das Lâminas Importadora', '1133336666', 'comercial@imperiodaslaminas.com.br', N'Guarulhos', 'ATIVO'),
        (N'Química & Estilo Cosméticos Profissionais', '1133337777', 'pedidos@quimicaestilo.com.br', N'São Bernardo do Campo', 'ATIVO'),
        (N'Móveis & Equipamentos Royal Barber', '1133338888', 'sac@royalbarber.com.br', N'São Paulo', 'INATIVO');

    -- =========================================================================
    -- LOTE 2: PRODUTOS E ESPECIALIZAÇÕES DE PESSOAL
    -- =========================================================================

    -- 5. dbo.PRODUTO (Gera IDs 4 a 8)
    INSERT INTO dbo.PRODUTO (nm_produto, tipo_produto, unidade_medida, estoque_minimo_padrao, st_produto)
    VALUES
        (N'Shampoo Mentolado Anticaspa 300ml', N'Higiene Capilar', 'UN', 12, 'ATIVO'),
        (N'Balm Pós-Barba Calmante 100g', N'Finalizador de Barba', 'UN', 10, 'ATIVO'),
        (N'Cera Modeladora Efeito Brilho 90g', N'Finalizador Capilar', 'UN', 8, 'ATIVO'),
        (N'Toalha Descartável Higiênica (Pacote c/ 50)', N'Insumo de Uso Interno', 'PCT', 15, 'ATIVO'),
        (N'Loção Tônica Fortalecedora de Barba 60ml', N'Tratamento de Barba', 'UN', 6, 'ATIVO');

    -- 6. dbo.CLIENTE (Herda IDs 9 a 14 de USUARIO)
    INSERT INTO dbo.CLIENTE (id_usuario)
    VALUES (9), (10), (11), (12), (13), (14);

    -- 7. dbo.FUNCIONARIO (Herda IDs 5 a 8 de USUARIO)
    INSERT INTO dbo.FUNCIONARIO (id_usuario)
    VALUES (5), (6), (7), (8);

    -- 8. dbo.GESTAO_BARBEARIA (Gera IDs 3 a 6)
    INSERT INTO dbo.GESTAO_BARBEARIA (tipo_gestao, dt_inicio, dt_fim, st_gestao, id_usuario, id_barbearia)
    VALUES
        (N'Gerente de Unidade', '2026-03-01 09:30:00', NULL, 'ATIVA', 5, 3),
        (N'Gerente Regional', '2026-04-10 10:00:00', NULL, 'ATIVA', 5, 4),
        (N'Administrador Geral', '2026-05-20 08:30:00', NULL, 'ATIVA', 1, 5),
        (N'Subgerente Operacional', '2026-03-15 09:00:00', '2026-09-30 18:00:00', 'ENCERRADA', 6, 2);

    -- =========================================================================
    -- LOTE 3: ALOCAÇÃO, OFERTAS, PREÇOS ACORDADOS E COMBOS
    -- =========================================================================

    -- 9. dbo.ALOCACAO (Gera IDs 3 a 7)
    INSERT INTO dbo.ALOCACAO (funcao, dt_inicio, dt_fim, st_alocacao, id_barbearia, id_funcionario)
    VALUES
        (N'Barbeiro Master', '2026-02-15 09:00:00', NULL, 'ATIVA', 2, 5),
        (N'Barbeiro Sênior', '2026-03-02 10:00:00', NULL, 'ATIVA', 2, 6),
        (N'Especialista em Fade e Barba', '2026-04-10 11:00:00', NULL, 'ATIVA', 3, 7),
        (N'Barbeiro Pleno', '2026-05-20 09:00:00', NULL, 'ATIVA', 4, 8),
        (N'Barbeiro Sênior', '2026-06-01 09:00:00', NULL, 'ATIVA', 5, 2);

    -- 10. dbo.OFERTA_SERVICO (Gera IDs 4 a 10)
    INSERT INTO dbo.OFERTA_SERVICO (preco, duracao_minutos, st_oferta, id_barbearia, id_servico)
    VALUES
        (80.00, 50, 'ATIVA', 1, 4), -- ID 4: Degradê na Matriz
        (60.00, 35, 'ATIVA', 1, 5), -- ID 5: Pigmentação na Matriz
        (85.00, 45, 'ATIVA', 2, 1), -- ID 6: Corte Clássico nos Jardins
        (60.00, 30, 'ATIVA', 2, 2), -- ID 7: Barba Terapia nos Jardins
        (30.00, 15, 'ATIVA', 2, 3), -- ID 8: Sobrancelha nos Jardins
        (80.00, 45, 'ATIVA', 3, 4), -- ID 9: Degradê em Moema
        (65.00, 30, 'ATIVA', 3, 6); -- ID 10: Hidratação em Moema

    -- 11. dbo.PRECO_CLIENTE (Gera IDs 2 a 5)
    INSERT INTO dbo.PRECO_CLIENTE (valor_acordado, dt_inicio, dt_fim, criterio, referencia_reajuste, observacao, id_cliente, id_oferta)
    VALUES
        (68.00, '2026-04-01 00:00:00', '2026-12-31 23:59:59', N'Convénio empresa parceira', N'Acordo Comercial 2026', N'Aplicável na Matriz', 9, 4),
        (72.00, '2026-04-10 00:00:00', '2026-12-31 23:59:59', N'Cliente Clube Assinatura Jardins', N'IGP-M Anual', N'Prioridade de agenda', 10, 6),
        (50.00, '2026-05-15 00:00:00', '2026-11-30 23:59:59', N'Parceria influenciador local', N'Valor fixo semestral', N'Unidade Jardins', 11, 7),
        (70.00, '2026-06-01 00:00:00', NULL, N'Desconto vizinhança Moema', N'Sem reajuste previsto', N'Cliente recorrente quinzenal', 12, 9);

    -- 12. dbo.COMBO (Gera IDs 2 a 4)
    INSERT INTO dbo.COMBO (nm_combo, percentual_desconto, dt_inicio, dt_fim, st_combo, id_barbearia)
    VALUES
        (N'Combo VIP Matriz (Degradê + Barba + Sobrancelha)', 20.00, '2026-02-01 00:00:00', NULL, 'ATIVO', 1),
        (N'Combo Executivo Jardins (Corte + Barba)', 15.00, '2026-02-15 00:00:00', NULL, 'ATIVO', 2),
        (N'Combo Renovação Moema (Degradê + Hidratação)', 18.00, '2026-03-01 00:00:00', NULL, 'ATIVO', 3);

    -- =========================================================================
    -- LOTE 4: ITENS DE COMBO, REGRAS DE BENEFÍCIO E AGENDAMENTOS
    -- =========================================================================

    -- 13. dbo.ITEM_COMBO (Gera IDs 3 a 9 - Pares únicos id_combo + id_servico)
    INSERT INTO dbo.ITEM_COMBO (id_servico, id_combo)
    VALUES
        (4, 2), (2, 2), (3, 2), -- Serviços do Combo 2
        (1, 3), (2, 3),         -- Serviços do Combo 3
        (4, 4), (6, 4);         -- Serviços do Combo 4

    -- 14. dbo.REGRA_BENEFICIO (Gera IDs 2 a 4)
    INSERT INTO dbo.REGRA_BENEFICIO (nm_regra, tipo_regra, qtd_cortes_exigida, criterio_elegibilidade, dt_inicio, dt_fim, st_regra, id_barbearia)
    VALUES
        (N'Cortesia Mês de Aniversário', 'ANIVERSARIO', NULL, N'Cliente ativo com pelo menos 3 atendimentos anteriores ganha 1 serviço elegível no mês de aniversário.', '2026-01-10 00:00:00', NULL, 'ATIVA', 1),
        (N'Fidelidade 10 Cortes Jardins', 'FIDELIDADE_CORTES', 10, N'Acumulou 10 cortes pagos na unidade Jardins, ganha 1 corte grátis.', '2026-02-15 00:00:00', NULL, 'ATIVA', 2),
        (N'Campanha Indique um Amigo Moema', 'INDICACAO', NULL, N'Indicou novo cliente que concluiu o primeiro atendimento pago.', '2026-03-01 00:00:00', '2026-12-31 23:59:59', 'ATIVA', 3);

    -- 15. dbo.SERVICO_BENEFICIO (Gera IDs 3 a 9 - Pares únicos id_regra_beneficio + id_servico)
    INSERT INTO dbo.SERVICO_BENEFICIO (id_servico, id_regra_beneficio)
    VALUES
        (1, 2), (2, 2), (3, 2), -- Elegíveis na Regra 2
        (1, 3), (4, 3),         -- Elegíveis na Regra 3
        (4, 4), (6, 4);         -- Elegíveis na Regra 4

    -- 16. dbo.AGENDAMENTO (Gera IDs 3 a 9)
    INSERT INTO dbo.AGENDAMENTO (dt_hora_inicio, st_agendamento, id_cliente, id_alocacao)
    VALUES
        ('2026-10-27 09:00:00', 'CONCLUIDO', 9, 1),  -- ID 3
        ('2026-10-27 11:00:00', 'CONCLUIDO', 10, 3), -- ID 4
        ('2026-10-28 14:00:00', 'CONCLUIDO', 11, 4), -- ID 5
        ('2026-10-29 16:30:00', 'CONCLUIDO', 12, 5), -- ID 6
        ('2026-10-30 18:00:00', 'CONCLUIDO', 13, 2), -- ID 7
        ('2026-11-05 10:00:00', 'AGENDADO', 14, 6),  -- ID 8 (Futuro)
        ('2026-10-31 17:00:00', 'CANCELADO', 9, 1);  -- ID 9 (Cancelado)

    -- =========================================================================
    -- LOTE 5: ITENS DE AGENDAMENTO, ATENDIMENTOS E CORTESIAS
    -- =========================================================================

    -- 17. dbo.ITEM_AGENDAMENTO (Gera IDs 4 a 13 - Pares únicos id_agendamento + id_oferta)
    INSERT INTO dbo.ITEM_AGENDAMENTO (ordem_execucao, preco_aplicado, duracao_aplicada_min, percentual_desconto_aplicado, id_combo, id_preco_cliente, id_oferta, id_agendamento)
    VALUES
        (1, 68.00, 50, 15.00, NULL, 2, 4, 3),     -- ID 4 (Ag 3): Degradê com Preço Acordado #2
        (2, 60.00, 35, 0.00, NULL, NULL, 5, 3),   -- ID 5 (Ag 3): Pigmentação Barba avulsa
        (1, 72.25, 45, 15.00, 3, NULL, 6, 4),     -- ID 6 (Ag 4): Corte Jardins via Combo #3
        (2, 51.00, 30, 15.00, 3, NULL, 7, 4),     -- ID 7 (Ag 4): Barba Jardins via Combo #3
        (1, 0.00, 15, 100.00, NULL, NULL, 8, 5),  -- ID 8 (Ag 5): Sobrancelha Jardins (100% Cortesia #2)
        (2, 50.00, 30, 16.67, NULL, 4, 7, 5),     -- ID 9 (Ag 5): Barba Jardins com Preço Acordado #4
        (1, 65.60, 45, 18.00, 4, NULL, 9, 6),     -- ID 10 (Ag 6): Degradê Moema via Combo #4
        (2, 53.30, 30, 18.00, 4, NULL, 10, 6),    -- ID 11 (Ag 6): Hidratação Moema via Combo #4
        (1, 0.00, 45, 100.00, NULL, NULL, 1, 7),  -- ID 12 (Ag 7): Corte Matriz (100% Cortesia #3)
        (1, 80.00, 50, 0.00, NULL, NULL, 4, 8);   -- ID 13 (Ag 8): Degradê agendado para o futuro

    -- 18. dbo.ATENDIMENTO (Gera IDs 3 a 7 - id_agendamento UNIQUE)
    INSERT INTO dbo.ATENDIMENTO (dt_atendimento, valor_total_cobrado, observacao, id_agendamento, id_alocacao)
    VALUES
        ('2026-10-27 10:25:00', 128.00, N'Degradê com preço especial de convénio + Pigmentação de barba.', 3, 1),
        ('2026-10-27 12:15:00', 123.25, N'Combo Executivo Jardins realizado sem intercorrências.', 4, 3),
        ('2026-10-28 14:45:00', 50.00, N'Sobrancelha gratuita por cortesia + Barba preço acordado.', 5, 4),
        ('2026-10-29 17:45:00', 118.90, N'Combo Renovação Moema concluído.', 6, 5),
        ('2026-10-30 18:45:00', 0.00, N'Atendimento de aniversário 100% isento via cortesia.', 7, 2);

    -- 19. dbo.CORTESIA (Gera IDs 2 a 5)
    INSERT INTO dbo.CORTESIA (dt_concessao, motivo, st_cortesia, observacao, id_cliente, id_regra_beneficio, id_atendimento)
    VALUES
        ('2026-10-25 09:00:00', N'Benefício do mês de aniversário', 'RESGATADA', N'Utilizada na sobrancelha do Agendamento #5', 11, 2, NULL),
        ('2026-10-28 10:00:00', N'Benefício do mês de aniversário', 'RESGATADA', N'Utilizada no corte do Agendamento #7', 13, 2, 3),
        ('2026-10-27 12:20:00', N'Atingiu 10 cortes acumulados na unidade Jardins', 'DISPONIVEL', N'Aguardando agendamento futuro para resgate', 10, 3, 4),
        ('2026-10-29 18:00:00', N'Indicação confirmada de novo cliente em Moema', 'DISPONIVEL', N'Crédito de serviço disponível para próximo mês', 12, 4, 6);

    -- 20. dbo.RESGATA_CORTESIA (PK Composta + UNIQUE individual em cada coluna)
    INSERT INTO dbo.RESGATA_CORTESIA (id_cortesia, id_item_agendamento)
    VALUES
        (2, 8),  -- Cortesia #2 resgatada no Item de Agendamento #8
        (3, 12); -- Cortesia #3 resgatada no Item de Agendamento #12

    -- =========================================================================
    -- LOTE 6: COMPRAS DE INSUMOS E CONTAS A PAGAR
    -- =========================================================================

    -- 21. dbo.COMPRA (Gera IDs 2 a 5)
    INSERT INTO dbo.COMPRA (dt_compra, st_compra, observacao, id_barbearia, id_fornecedor)
    VALUES
        ('2026-10-10 11:00:00', 'RECEBIDA', N'Abastecimento trimestral de cosméticos - Unidade Jardins', 2, 2),
        ('2026-10-12 15:30:00', 'RECEBIDA', N'Compra de descartáveis e lâminas - Matriz', 1, 3),
        ('2026-10-18 09:45:00', 'RECEBIDA', N'Lote de loções tônicas para Unidade Moema', 3, 4),
        ('2026-10-22 16:00:00', 'RECEBIDA', N'Compra emergencial direta sem fornecedor cadastrado', 4, NULL);

    -- 22. dbo.ITEM_COMPRA (Gera IDs 3 a 9 - Pares únicos id_compra + id_produto)
    INSERT INTO dbo.ITEM_COMPRA (quantidade, valor_unitario, id_produto, id_compra)
    VALUES
        (30.000, 22.00, 4, 2), -- ID 3: 30 Shampoos (R$ 660)
        (25.000, 20.00, 5, 2), -- ID 4: 25 Balms (R$ 500)
        (20.000, 24.00, 6, 2), -- ID 5: 20 Ceras (R$ 480)
        (15.000, 35.00, 3, 3), -- ID 6: 15 Cx Lâminas (R$ 525)
        (40.000, 18.00, 7, 3), -- ID 7: 40 Pct Toalhas (R$ 720)
        (20.000, 28.00, 8, 4), -- ID 8: 20 Loções Tónicas (R$ 560)
        (10.000, 26.00, 1, 5); -- ID 9: 10 Pomadas Matte (R$ 260)

    -- 23. dbo.CONTA_PAGAR (Gera IDs 3 a 8)
    INSERT INTO dbo.CONTA_PAGAR (descricao, categoria, nr_parcela, valor_devido, dt_vencimento, st_conta, id_barbearia, id_compra)
    VALUES
        (N'Fatura MenCare Cosméticos - Parcela 1/2', N'Estoque e Insumos', 1, 820.00, '2026-10-25 23:59:59', 'PAGA', 2, 2),
        (N'Fatura MenCare Cosméticos - Parcela 2/2', N'Estoque e Insumos', 2, 820.00, '2026-11-25 23:59:59', 'ABERTA', 2, 2),
        (N'Fatura Império das Lâminas - Parcela Única', N'Estoque e Insumos', 1, 1245.00, '2026-10-22 23:59:59', 'PAGA', 1, 3),
        (N'Fatura Química & Estilo - Parcela Única', N'Estoque e Insumos', 1, 560.00, '2026-10-28 23:59:59', 'PAGA', 3, 4),
        (N'Aluguer de Imóvel Comercial - Matriz Outubro/2026', N'Despesa Fixa Predial', 1, 4500.00, '2026-10-10 23:59:59', 'PAGA', 1, NULL),
        (N'Link Dedicado de Internet Fibra - Jardins', N'Telecomunicações', 1, 220.00, '2026-10-15 23:59:59', 'PAGA', 2, NULL);

    -- 24. dbo.PAGAMENTO (Gera IDs 3 a 7)
    INSERT INTO dbo.PAGAMENTO (dt_pagamento, valor_pago, forma_pagamento, referencia_transacao, st_pagamento, id_conta_pagar)
    VALUES
        ('2026-10-24 10:15:00', 820.00, N'PIX', 'PIX-PAG-20261024-003', 'CONFIRMADO', 3),
        ('2026-10-21 15:40:00', 1245.00, N'Transferência TED', 'TED-PAG-20261021-004', 'CONFIRMADO', 5),
        ('2026-10-28 11:05:00', 560.00, N'Boleto Bancário', 'BOL-PAG-20261028-005', 'CONFIRMADO', 6),
        ('2026-10-09 09:30:00', 4500.00, N'Transferência PIX', 'PIX-ALUGUEL-20261009', 'CONFIRMADO', 7),
        ('2026-10-14 17:20:00', 220.00, N'Débito Automático', 'DEB-NET-20261014', 'CONFIRMADO', 8);

    -- =========================================================================
    -- LOTE 7: VENDAS DE PRODUTOS, MOVIMENTAÇÃO DE STOCK E CONTAS A RECEBER
    -- =========================================================================

    -- 25. dbo.VENDA (Gera IDs 2 a 5 - Inclui venda avulsa com id_cliente NULL)
    INSERT INTO dbo.VENDA (dt_venda, st_venda, observacao, id_barbearia, id_cliente)
    VALUES
        ('2026-10-27 10:30:00', 'CONCLUIDA', N'Kit pós-barba vendido após atendimento #3', 1, 9),
        ('2026-10-27 12:20:00', 'CONCLUIDA', N'Produtos capilares vendidos na receção Jardins', 2, 10),
        ('2026-10-29 17:50:00', 'CONCLUIDA', N'Venda de loção fortalecedora em Moema', 3, 12),
        ('2026-10-30 14:10:00', 'CONCLUIDA', N'Venda de balcão para cliente passante não identificado', 1, NULL);

    -- 26. dbo.ITEM_VENDA (Gera IDs 3 a 8 - Pares únicos id_venda + id_produto)
    INSERT INTO dbo.ITEM_VENDA (quantidade, preco_unitario_aplicado, id_produto, id_venda)
    VALUES
        (1.000, 48.00, 5, 2), -- ID 3 (Venda 2): 1 Balm Pós-Barba
        (1.000, 40.00, 2, 2), -- ID 4 (Venda 2): 1 Óleo para Barba
        (2.000, 45.00, 4, 3), -- ID 5 (Venda 3): 2 Shampoos Mentolados
        (1.000, 52.00, 6, 3), -- ID 6 (Venda 3): 1 Cera Efeito Brilho
        (1.000, 62.00, 8, 4), -- ID 7 (Venda 4): 1 Loção Tónica
        (2.000, 55.00, 1, 5); -- ID 8 (Venda 5): 2 Pomadas Matte

    -- 27. dbo.MOVIMENTACAO_ESTOQUE (Gera IDs 5 a 14 - Respeita CHECK de no máximo 1 origem comercial)
    INSERT INTO dbo.MOVIMENTACAO_ESTOQUE (dt_movimentacao, tipo_movimentacao, quantidade, custo_unitario_aplicado, motivo, observacao, id_produto, id_alocacao, id_item_compra, id_item_venda)
    VALUES
        ('2026-10-10 11:30:00', 'ENTRADA_COMPRA', 30.000, 22.00, N'Entrada NF Compra #2', N'Almoxarifado Jardins', 4, 3, 3, NULL),
        ('2026-10-10 11:32:00', 'ENTRADA_COMPRA', 25.000, 20.00, N'Entrada NF Compra #2', N'Almoxarifado Jardins', 5, 3, 4, NULL),
        ('2026-10-10 11:35:00', 'ENTRADA_COMPRA', 20.000, 24.00, N'Entrada NF Compra #2', N'Almoxarifado Jardins', 6, 3, 5, NULL),
        ('2026-10-12 16:00:00', 'ENTRADA_COMPRA', 15.000, 35.00, N'Entrada NF Compra #3', N'Almoxarifado Matriz', 3, 1, 6, NULL),
        ('2026-10-18 10:15:00', 'ENTRADA_COMPRA', 20.000, 28.00, N'Entrada NF Compra #4', N'Almoxarifado Moema', 8, 5, 8, NULL),
        ('2026-10-27 10:31:00', 'SAIDA_VENDA', 1.000, 20.00, N'Baixa por Venda #2', N'Entregue na receção Matriz', 5, 1, NULL, 3),
        ('2026-10-27 12:21:00', 'SAIDA_VENDA', 2.000, 22.00, N'Baixa por Venda #3', N'Entregue na receção Jardins', 4, 3, NULL, 5),
        ('2026-10-29 17:52:00', 'SAIDA_VENDA', 1.000, 28.00, N'Baixa por Venda #4', N'Entregue na receção Moema', 8, 5, NULL, 7),
        ('2026-10-30 14:12:00', 'SAIDA_VENDA', 2.000, 25.00, N'Baixa por Venda #5', N'Venda avulsa balcão', 1, 1, NULL, 8),
        ('2026-10-31 08:00:00', 'CONSUMO_INTERNO', 2.000, 35.00, N'Abastecimento de bancadas de trabalho', N'Movimentação interna sem vínculo de compra/venda', 3, 1, NULL, NULL);

    -- 28. dbo.CONTA_RECEBER (Gera IDs 3 a 10 - Respeita CHECK XOR id_atendimento / id_venda)
    INSERT INTO dbo.CONTA_RECEBER (descricao, nr_parcela, valor_devido, dt_vencimento, st_conta, id_atendimento, id_venda)
    VALUES
        (N'Recebimento Atendimento #3 (Degradê + Pigmentação)', 1, 128.00, '2026-10-27 23:59:59', 'QUITADA', 3, NULL),
        (N'Recebimento Atendimento #4 (Combo Executivo Jardins)', 1, 123.25, '2026-10-27 23:59:59', 'QUITADA', 4, NULL),
        (N'Recebimento Atendimento #5 (Barba VIP)', 1, 50.00, '2026-10-28 23:59:59', 'QUITADA', 5, NULL),
        (N'Recebimento Atendimento #6 (Combo Renovação Moema)', 1, 118.90, '2026-10-29 23:59:59', 'QUITADA', 6, NULL),
        (N'Recebimento Venda #2 (Kit Pós-Barba)', 1, 88.00, '2026-10-27 23:59:59', 'QUITADA', NULL, 2),
        (N'Recebimento Venda #3 (Shampoos + Cera)', 1, 142.00, '2026-10-27 23:59:59', 'QUITADA', NULL, 3),
        (N'Recebimento Venda #4 (Loção Tónica)', 1, 62.00, '2026-10-29 23:59:59', 'QUITADA', NULL, 4),
        (N'Recebimento Venda #5 (Pomadas Balcão)', 1, 110.00, '2026-10-30 23:59:59', 'QUITADA', NULL, 5);

    -- =========================================================================
    -- LOTE 8: RECEBIMENTOS, DEVOLUÇÕES E CRÉDITOS DO CLIENTE
    -- =========================================================================

    -- 29. dbo.RECEBIMENTO (Gera IDs 4 a 13)
    INSERT INTO dbo.RECEBIMENTO (dt_recebimento, valor_recebido, forma_pagamento, referencia_transacao, st_recebimento, valor_taxa, tipo_recebimento, id_conta_receber)
    VALUES
        ('2026-10-27 10:26:00', 128.00, N'Cartão de Débito', 'NSU-900201', 'CONFIRMADO', 1.92, 'QUITACAO', 3),
        ('2026-10-27 12:16:00', 123.25, N'Cartão de Crédito', 'NSU-900202', 'CONFIRMADO', 3.70, 'QUITACAO', 4),
        ('2026-10-28 14:46:00', 50.00, N'PIX', 'PIX-REC-900203', 'CONFIRMADO', 0.00, 'QUITACAO', 5),
        ('2026-10-28 14:47:00', 50.00, N'Cartão de Débito', 'NSU-ERRO-900204', 'ESTORNADO', 0.75, 'COBRANCA_INDEVIDA', 5),
        ('2026-10-29 17:46:00', 118.90, N'PIX', 'PIX-REC-900205', 'CONFIRMADO', 0.00, 'QUITACAO', 6),
        ('2026-10-27 10:32:00', 68.00, N'PIX', 'PIX-REC-900206', 'CONFIRMADO', 0.00, 'QUITACAO', 7),
        ('2026-10-27 12:22:00', 142.00, N'Cartão de Crédito', 'NSU-900207', 'CONFIRMADO', 4.26, 'QUITACAO', 8),
        ('2026-10-27 12:23:00', 15.00, N'Dinheiro', 'CAIXA-ERR-900208', 'ESTORNADO', 0.00, 'COBRANCA_INDEVIDA', 8),
        ('2026-10-29 17:55:00', 32.00, N'Cartão de Débito', 'NSU-900209', 'CONFIRMADO', 0.48, 'QUITACAO', 9),
        ('2026-10-30 14:15:00', 110.00, N'Dinheiro', 'CAIXA-BALCAO-900210', 'CONFIRMADO', 0.00, 'QUITACAO', 10);

    -- 30. dbo.DEVOLUCAO_RECEBIMENTO (Gera IDs 2 e 3)
    INSERT INTO dbo.DEVOLUCAO_RECEBIMENTO (dt_devolucao, valor_devolvido, forma_devolucao, motivo, referencia_transacao, st_devolucao, id_recebimento)
    VALUES
        ('2026-10-28 14:55:00', 50.00, N'PIX', N'Estorno de cobrança duplicada na máquina de cartão', 'PIX-DEV-900204', 'CONCLUIDA', 7),
        ('2026-10-27 12:25:00', 15.00, N'Dinheiro', N'Devolução de troco cobrado a maior na receção', 'CAIXA-DEV-900208', 'CONCLUIDA', 11);

    -- 31. dbo.CREDITO_CLIENTE (Gera IDs 2 a 4)
    INSERT INTO dbo.CREDITO_CLIENTE (dt_concessao, valor_concedido, motivo, st_credito, id_atendimento, id_cliente)
    VALUES
        ('2026-10-27 10:27:00', 20.00, N'Voucher promocional na compra do pacote Degradê + Pigmentação', 'UTILIZADO', 3, 9),
        ('2026-10-29 17:48:00', 30.00, N'Crédito de cortesia comercial por atraso de 15 min na agenda', 'UTILIZADO', 6, 12),
        ('2026-10-27 12:18:00', 25.00, N'Bónus fidelidade para futura compra de produtos nos Jardins', 'DISPONIVEL', 4, 10);

    -- 32. dbo.UTILIZACAO_CREDITO (Gera IDs 2 e 3)
    INSERT INTO dbo.UTILIZACAO_CREDITO (dt_utilizacao, valor_utilizado, st_utilizacao, id_credito, id_conta_receber)
    VALUES
        ('2026-10-27 10:31:00', 20.00, 'CONFIRMADA', 2, 7), -- Abateu R$ 20 da Conta a Receber #7 (R$ 88 -> pagou R$ 68)
        ('2026-10-29 17:54:00', 30.00, 'CONFIRMADA', 3, 9); -- Abateu R$ 30 da Conta a Receber #9 (R$ 62 -> pagou R$ 32)

    COMMIT TRANSACTION;
    PRINT 'SUCESSO: 2.º Lote de Expansão de Dados inserido nas 32 tabelas!';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'ERRO AO INSERIR LOTE ADICIONAL: ' + ERROR_MESSAGE();
END CATCH;
GO
