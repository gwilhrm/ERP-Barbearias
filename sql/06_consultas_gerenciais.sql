-- ERP Barbearias - Estudio XXI | Grupo 8
-- Arquivo: 06_consultas_gerenciais.sql
-- Consultas gerenciais G01 a G10: cada uma responde a uma pergunta do gestor.
-- Procedencia: nomes G01-G10 definidos no documento do grupo; SQL redigido com apoio de IA
-- (Claude) na consolidacao da entrega final e testado em banco de teste (SQLite, adaptado).
-- EXECUCAO EM SQL SERVER: executado em 02/11/2026, em banco vazio, na cadeia 01-08, sem erros de execucao (prints em evidencias/).
USE DB_estudioXXI;
GO

-- [G01] Quanto foi efetivamente recebido por mes e por forma de pagamento?
SELECT YEAR(r.dt_recebimento)  AS ano,
       MONTH(r.dt_recebimento) AS mes,
       r.forma_pagamento,
       COUNT(*)                AS qtd_recebimentos,
       SUM(r.valor_recebido)   AS total_recebido
FROM dbo.RECEBIMENTO AS r
WHERE r.st_recebimento = 'CONFIRMADO'
GROUP BY YEAR(r.dt_recebimento), MONTH(r.dt_recebimento), r.forma_pagamento
ORDER BY ano, mes, total_recebido DESC;
GO

-- [G02] Qual foi o fechamento financeiro de cada dia?
-- Regra adotada: entram so recebimentos CONFIRMADOS; a devolucao CONCLUIDA so e abatida
-- quando o recebimento original continua CONFIRMADO (evita abater duas vezes um recebimento
-- ja marcado como ESTORNADO). Decisao a confirmar pelo grupo.
WITH mov AS (
    SELECT CAST(r.dt_recebimento AS DATE) AS dia,
           r.valor_recebido AS recebido, CAST(0 AS DECIMAL(14,2)) AS devolvido,
           ISNULL(r.valor_taxa, 0) AS taxa, CAST(0 AS DECIMAL(14,2)) AS pago
    FROM dbo.RECEBIMENTO AS r
    WHERE r.st_recebimento = 'CONFIRMADO'
    UNION ALL
    SELECT CAST(d.dt_devolucao AS DATE), 0, d.valor_devolvido, 0, 0
    FROM dbo.DEVOLUCAO_RECEBIMENTO AS d
    JOIN dbo.RECEBIMENTO AS r ON r.id_recebimento = d.id_recebimento
    WHERE d.st_devolucao = 'CONCLUIDA' AND r.st_recebimento = 'CONFIRMADO'
    UNION ALL
    SELECT CAST(p.dt_pagamento AS DATE), 0, 0, 0, p.valor_pago
    FROM dbo.PAGAMENTO AS p
    WHERE p.st_pagamento = 'CONFIRMADO'
)
SELECT dia,
       SUM(recebido)  AS recebido,
       SUM(devolvido) AS devolvido,
       SUM(taxa)      AS taxas,
       SUM(pago)      AS pago,
       SUM(recebido) - SUM(devolvido) - SUM(taxa) - SUM(pago) AS saldo_do_dia
FROM mov
GROUP BY dia
ORDER BY dia;
GO

-- [G03] Quais servicos sao mais realizados e quanto geram?
SELECT s.nm_servico,
       COUNT(*)               AS qtd_itens,
       SUM(ia.preco_aplicado) AS receita_registrada
FROM dbo.ITEM_AGENDAMENTO AS ia
JOIN dbo.AGENDAMENTO    AS a  ON a.id_agendamento = ia.id_agendamento
JOIN dbo.OFERTA_SERVICO AS os ON os.id_oferta     = ia.id_oferta
JOIN dbo.SERVICO        AS s  ON s.id_servico     = os.id_servico
WHERE a.st_agendamento = 'CONCLUIDO'
GROUP BY s.nm_servico
ORDER BY qtd_itens DESC, receita_registrada DESC;
GO

-- [G04] Qual a produtividade de cada profissional (alocacao)?
-- LEFT JOIN: alocacao sem atendimento aparece com zero (cardinalidade (0,n) corrigida).
SELECT b.nm_barbearia,
       u.nm_usuario AS profissional,
       al.funcao,
       COUNT(atd.id_atendimento)              AS qtd_atendimentos,
       ISNULL(SUM(atd.valor_total_cobrado), 0) AS valor_cobrado
FROM dbo.ALOCACAO AS al
JOIN dbo.BARBEARIA   AS b ON b.id_barbearia = al.id_barbearia
JOIN dbo.FUNCIONARIO AS f ON f.id_usuario   = al.id_funcionario
JOIN dbo.USUARIO     AS u ON u.id_usuario   = f.id_usuario
LEFT JOIN dbo.ATENDIMENTO AS atd ON atd.id_alocacao = al.id_alocacao
GROUP BY b.nm_barbearia, u.nm_usuario, al.funcao, al.id_alocacao
ORDER BY valor_cobrado DESC, qtd_atendimentos DESC;
GO

-- [G05] Quais produtos mais vendem?
SELECT p.nm_produto,
       SUM(iv.quantidade)                              AS qtd_vendida,
       SUM(iv.quantidade * iv.preco_unitario_aplicado) AS receita_bruta
FROM dbo.ITEM_VENDA AS iv
JOIN dbo.VENDA   AS v ON v.id_venda   = iv.id_venda
JOIN dbo.PRODUTO AS p ON p.id_produto = iv.id_produto
WHERE v.st_venda = 'CONCLUIDA'
GROUP BY p.nm_produto
ORDER BY qtd_vendida DESC, receita_bruta DESC;
GO

-- [G06] Qual o saldo de estoque de cada produto em cada barbearia?
-- Saldo = entradas - saidas, calculado pelas movimentacoes (o saldo nao e gravado em PRODUTO).
-- Vocabulario de tipo_movimentacao observado na massa: ENTRADA_COMPRA, SAIDA_VENDA, CONSUMO_INTERNO.
SELECT b.nm_barbearia, p.nm_produto,
       SUM(CASE WHEN m.tipo_movimentacao LIKE 'ENTRADA%' THEN m.quantidade
                ELSE -m.quantidade END) AS saldo
FROM dbo.MOVIMENTACAO_ESTOQUE AS m
JOIN dbo.ALOCACAO  AS al ON al.id_alocacao = m.id_alocacao
JOIN dbo.BARBEARIA AS b  ON b.id_barbearia = al.id_barbearia
JOIN dbo.PRODUTO   AS p  ON p.id_produto   = m.id_produto
GROUP BY b.nm_barbearia, p.nm_produto
ORDER BY b.nm_barbearia, p.nm_produto;
GO

-- [G07] Quais produtos estao abaixo do estoque minimo?
WITH saldo AS (
    SELECT al.id_barbearia, m.id_produto,
           SUM(CASE WHEN m.tipo_movimentacao LIKE 'ENTRADA%' THEN m.quantidade
                    ELSE -m.quantidade END) AS saldo
    FROM dbo.MOVIMENTACAO_ESTOQUE AS m
    JOIN dbo.ALOCACAO AS al ON al.id_alocacao = m.id_alocacao
    GROUP BY al.id_barbearia, m.id_produto
)
SELECT b.nm_barbearia, p.nm_produto, s.saldo, p.estoque_minimo_padrao
FROM saldo AS s
JOIN dbo.BARBEARIA AS b ON b.id_barbearia = s.id_barbearia
JOIN dbo.PRODUTO   AS p ON p.id_produto   = s.id_produto
WHERE s.saldo < p.estoque_minimo_padrao
ORDER BY (p.estoque_minimo_padrao - s.saldo) DESC;
GO

-- [G08] Quanto as despesas somam por categoria e situacao?
SELECT cp.categoria, cp.st_conta,
       COUNT(*)             AS qtd_contas,
       SUM(cp.valor_devido) AS total_devido
FROM dbo.CONTA_PAGAR AS cp
GROUP BY cp.categoria, cp.st_conta
ORDER BY total_devido DESC;
GO

-- [G09] Qual a situacao de cada conta a receber (devido, recebido, credito, saldo)?
-- Saldo > 0 indica valor ainda em aberto. Recebimentos ESTORNADOS nao entram.
SELECT cr.id_conta_receber, cr.descricao, cr.valor_devido,
       ISNULL(rec.recebido, 0) AS recebido,
       ISNULL(cre.credito, 0)  AS credito_utilizado,
       cr.valor_devido - ISNULL(rec.recebido, 0) - ISNULL(cre.credito, 0) AS saldo
FROM dbo.CONTA_RECEBER AS cr
LEFT JOIN (SELECT id_conta_receber, SUM(valor_recebido) AS recebido
           FROM dbo.RECEBIMENTO WHERE st_recebimento = 'CONFIRMADO'
           GROUP BY id_conta_receber) AS rec ON rec.id_conta_receber = cr.id_conta_receber
LEFT JOIN (SELECT id_conta_receber, SUM(valor_utilizado) AS credito
           FROM dbo.UTILIZACAO_CREDITO WHERE st_utilizacao = 'CONFIRMADA'
           GROUP BY id_conta_receber) AS cre ON cre.id_conta_receber = cr.id_conta_receber
ORDER BY saldo DESC, cr.id_conta_receber;
GO

-- [G10] Como as barbearias se comparam em receita de servicos e de produtos?
WITH conta_unidade AS (
    SELECT cr.id_conta_receber,
           COALESCE(al.id_barbearia, v.id_barbearia) AS id_barbearia,
           CASE WHEN cr.id_atendimento IS NOT NULL THEN 'SERVICOS' ELSE 'PRODUTOS' END AS origem
    FROM dbo.CONTA_RECEBER AS cr
    LEFT JOIN dbo.ATENDIMENTO AS atd ON atd.id_atendimento = cr.id_atendimento
    LEFT JOIN dbo.ALOCACAO    AS al  ON al.id_alocacao     = atd.id_alocacao
    LEFT JOIN dbo.VENDA       AS v   ON v.id_venda         = cr.id_venda
)
SELECT b.nm_barbearia,
       SUM(CASE WHEN cu.origem = 'SERVICOS' THEN r.valor_recebido ELSE 0 END) AS receita_servicos,
       SUM(CASE WHEN cu.origem = 'PRODUTOS' THEN r.valor_recebido ELSE 0 END) AS receita_produtos,
       SUM(r.valor_recebido) AS receita_total
FROM dbo.RECEBIMENTO AS r
JOIN conta_unidade   AS cu ON cu.id_conta_receber = r.id_conta_receber
JOIN dbo.BARBEARIA   AS b  ON b.id_barbearia      = cu.id_barbearia
WHERE r.st_recebimento = 'CONFIRMADO'
GROUP BY b.nm_barbearia
ORDER BY receita_total DESC;
GO
