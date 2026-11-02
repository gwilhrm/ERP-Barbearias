-- ERP Barbearias - Estudio XXI | Grupo 8
-- Arquivo: 07_consultas_auditoria.sql
-- Consultas de auditoria A01 a A17: procuram situacoes que merecem verificacao.
-- Linhas retornadas = ocorrencia a investigar. Zero linhas tambem e resultado valido.
-- Procedencia: A01-A14 descritas no documento do grupo; A15-A17 incluidas na consolidacao.
-- SQL redigido com apoio de IA (Claude); testado em banco de teste (SQLite, adaptado).
-- EXECUCAO EM SQL SERVER: executado em 02/11/2026, em banco vazio, na cadeia 01-08, sem erros de execucao (prints em evidencias/).
USE DB_estudioXXI;
GO

-- [A01] Compra RECEBIDA com item sem entrada de estoque (RN20).
SELECT c.id_compra, ic.id_item_compra, ic.id_produto, ic.quantidade
FROM dbo.ITEM_COMPRA AS ic
JOIN dbo.COMPRA AS c ON c.id_compra = ic.id_compra
WHERE c.st_compra = 'RECEBIDA'
  AND NOT EXISTS (SELECT 1 FROM dbo.MOVIMENTACAO_ESTOQUE AS m WHERE m.id_item_compra = ic.id_item_compra);
GO

-- [A02] Item de venda sem baixa de estoque (RN27).
SELECT v.id_venda, iv.id_item_venda, iv.id_produto, iv.quantidade
FROM dbo.ITEM_VENDA AS iv
JOIN dbo.VENDA AS v ON v.id_venda = iv.id_venda
WHERE NOT EXISTS (SELECT 1 FROM dbo.MOVIMENTACAO_ESTOQUE AS m WHERE m.id_item_venda = iv.id_item_venda);
GO

-- [A03] Compra sem nenhuma conta a pagar (RN23).
SELECT c.id_compra, c.dt_compra, c.st_compra, c.id_barbearia
FROM dbo.COMPRA AS c
WHERE NOT EXISTS (SELECT 1 FROM dbo.CONTA_PAGAR AS cp WHERE cp.id_compra = c.id_compra);
GO

-- [A04] Cortesia resgatada em barbearia diferente da barbearia da regra (RN30).
SELECT c.id_cortesia, rb.id_barbearia AS barbearia_da_regra, al.id_barbearia AS barbearia_do_resgate
FROM dbo.RESGATA_CORTESIA AS rc
JOIN dbo.CORTESIA         AS c  ON c.id_cortesia          = rc.id_cortesia
JOIN dbo.REGRA_BENEFICIO  AS rb ON rb.id_regra_beneficio  = c.id_regra_beneficio
JOIN dbo.ITEM_AGENDAMENTO AS ia ON ia.id_item_agendamento = rc.id_item_agendamento
JOIN dbo.AGENDAMENTO      AS ag ON ag.id_agendamento      = ia.id_agendamento
JOIN dbo.ALOCACAO         AS al ON al.id_alocacao         = ag.id_alocacao
WHERE rb.id_barbearia <> al.id_barbearia;
GO

-- [A05] Saldo de estoque negativo por produto e barbearia (RN20).
SELECT al.id_barbearia, m.id_produto,
       SUM(CASE WHEN m.tipo_movimentacao LIKE 'ENTRADA%' THEN m.quantidade ELSE -m.quantidade END) AS saldo
FROM dbo.MOVIMENTACAO_ESTOQUE AS m
JOIN dbo.ALOCACAO AS al ON al.id_alocacao = m.id_alocacao
GROUP BY al.id_barbearia, m.id_produto
HAVING SUM(CASE WHEN m.tipo_movimentacao LIKE 'ENTRADA%' THEN m.quantidade ELSE -m.quantidade END) < 0;
GO

-- [A06] Mais de uma movimentacao para o mesmo item de compra ou de venda (duplicidade).
SELECT 'ITEM_COMPRA' AS origem, id_item_compra AS id_origem, COUNT(*) AS qtd_movimentacoes
FROM dbo.MOVIMENTACAO_ESTOQUE WHERE id_item_compra IS NOT NULL
GROUP BY id_item_compra HAVING COUNT(*) > 1
UNION ALL
SELECT 'ITEM_VENDA', id_item_venda, COUNT(*)
FROM dbo.MOVIMENTACAO_ESTOQUE WHERE id_item_venda IS NOT NULL
GROUP BY id_item_venda HAVING COUNT(*) > 1;
GO

-- [A07] Produto da movimentacao diferente do produto do item de origem (RN20).
SELECT m.id_movimentacao, m.id_produto AS produto_movimentado,
       COALESCE(ic.id_produto, iv.id_produto) AS produto_do_item
FROM dbo.MOVIMENTACAO_ESTOQUE AS m
LEFT JOIN dbo.ITEM_COMPRA AS ic ON ic.id_item_compra = m.id_item_compra
LEFT JOIN dbo.ITEM_VENDA  AS iv ON iv.id_item_venda  = m.id_item_venda
WHERE (m.id_item_compra IS NOT NULL OR m.id_item_venda IS NOT NULL)
  AND m.id_produto <> COALESCE(ic.id_produto, iv.id_produto);
GO

-- [A08] Entradas de estoque maiores que a quantidade comprada.
SELECT ic.id_item_compra, ic.quantidade AS comprado, SUM(m.quantidade) AS entradas
FROM dbo.ITEM_COMPRA AS ic
JOIN dbo.MOVIMENTACAO_ESTOQUE AS m ON m.id_item_compra = ic.id_item_compra
GROUP BY ic.id_item_compra, ic.quantidade
HAVING SUM(m.quantidade) > ic.quantidade;
GO

-- [A09] Pagamentos confirmados acima do valor devido da conta a pagar (RN25).
SELECT cp.id_conta_pagar, cp.valor_devido, SUM(p.valor_pago) AS total_pago
FROM dbo.CONTA_PAGAR AS cp
JOIN dbo.PAGAMENTO AS p ON p.id_conta_pagar = cp.id_conta_pagar
WHERE p.st_pagamento = 'CONFIRMADO'
GROUP BY cp.id_conta_pagar, cp.valor_devido
HAVING SUM(p.valor_pago) > cp.valor_devido;
GO

-- [A10] Recebimentos confirmados + credito utilizado acima do valor devido (RN25, RN26).
SELECT cr.id_conta_receber, cr.valor_devido,
       ISNULL(rec.recebido, 0) + ISNULL(cre.credito, 0) AS total_abatido
FROM dbo.CONTA_RECEBER AS cr
LEFT JOIN (SELECT id_conta_receber, SUM(valor_recebido) AS recebido
           FROM dbo.RECEBIMENTO WHERE st_recebimento = 'CONFIRMADO'
           GROUP BY id_conta_receber) AS rec ON rec.id_conta_receber = cr.id_conta_receber
LEFT JOIN (SELECT id_conta_receber, SUM(valor_utilizado) AS credito
           FROM dbo.UTILIZACAO_CREDITO WHERE st_utilizacao = 'CONFIRMADA'
           GROUP BY id_conta_receber) AS cre ON cre.id_conta_receber = cr.id_conta_receber
WHERE ISNULL(rec.recebido, 0) + ISNULL(cre.credito, 0) > cr.valor_devido;
GO

-- [A11] Utilizacao de credito acima do valor concedido (RN26).
SELECT cc.id_credito, cc.valor_concedido, SUM(uc.valor_utilizado) AS total_utilizado
FROM dbo.CREDITO_CLIENTE AS cc
JOIN dbo.UTILIZACAO_CREDITO AS uc ON uc.id_credito = cc.id_credito
WHERE uc.st_utilizacao = 'CONFIRMADA'
GROUP BY cc.id_credito, cc.valor_concedido
HAVING SUM(uc.valor_utilizado) > cc.valor_concedido;
GO

-- [A12] Agendamento sem nenhum item de servico (RN05).
SELECT a.id_agendamento, a.dt_hora_inicio, a.st_agendamento
FROM dbo.AGENDAMENTO AS a
WHERE NOT EXISTS (SELECT 1 FROM dbo.ITEM_AGENDAMENTO AS ia WHERE ia.id_agendamento = a.id_agendamento);
GO

-- [A13] Agendamento CONCLUIDO sem atendimento registrado (RN14).
SELECT a.id_agendamento, a.dt_hora_inicio
FROM dbo.AGENDAMENTO AS a
WHERE a.st_agendamento = 'CONCLUIDO'
  AND NOT EXISTS (SELECT 1 FROM dbo.ATENDIMENTO AS atd WHERE atd.id_agendamento = a.id_agendamento);
GO

-- [A14] Alocacao que executou o atendimento diferente da alocacao agendada (RN14).
SELECT atd.id_atendimento, atd.id_alocacao AS alocacao_atendimento, a.id_alocacao AS alocacao_agendada
FROM dbo.ATENDIMENTO AS atd
JOIN dbo.AGENDAMENTO AS a ON a.id_agendamento = atd.id_agendamento
WHERE atd.id_alocacao <> a.id_alocacao;
GO

-- [A15] Cortesia vinculada a atendimento de outro cliente (RN30).
SELECT c.id_cortesia, c.id_cliente AS cliente_da_cortesia,
       ag.id_cliente AS cliente_do_atendimento, c.id_atendimento
FROM dbo.CORTESIA AS c
JOIN dbo.ATENDIMENTO AS atd ON atd.id_atendimento = c.id_atendimento
JOIN dbo.AGENDAMENTO AS ag  ON ag.id_agendamento  = atd.id_agendamento
WHERE c.id_cliente <> ag.id_cliente;
GO

-- [A16] Agendamentos nao cancelados que se sobrepoem para a mesma alocacao (RN06, RN08).
WITH ag AS (
    SELECT a.id_agendamento, a.id_alocacao, a.dt_hora_inicio AS inicio,
           DATEADD(MINUTE, SUM(ia.duracao_aplicada_min), a.dt_hora_inicio) AS fim
    FROM dbo.AGENDAMENTO AS a
    JOIN dbo.ITEM_AGENDAMENTO AS ia ON ia.id_agendamento = a.id_agendamento
    WHERE a.st_agendamento <> 'CANCELADO'
    GROUP BY a.id_agendamento, a.id_alocacao, a.dt_hora_inicio
)
SELECT x.id_alocacao, x.id_agendamento AS agendamento_1, y.id_agendamento AS agendamento_2
FROM ag AS x
JOIN ag AS y ON y.id_alocacao = x.id_alocacao
            AND y.id_agendamento > x.id_agendamento
            AND x.inicio < y.fim AND y.inicio < x.fim;
GO

-- [A17] Valor cobrado no atendimento diferente da soma dos itens do agendamento.
SELECT atd.id_atendimento, atd.valor_total_cobrado, SUM(ia.preco_aplicado) AS soma_itens
FROM dbo.ATENDIMENTO AS atd
JOIN dbo.ITEM_AGENDAMENTO AS ia ON ia.id_agendamento = atd.id_agendamento
GROUP BY atd.id_atendimento, atd.valor_total_cobrado
HAVING ROUND(atd.valor_total_cobrado, 2) <> ROUND(SUM(ia.preco_aplicado), 2);
GO
