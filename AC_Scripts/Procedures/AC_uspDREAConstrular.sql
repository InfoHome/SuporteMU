USE BDENTER
GO
CREATE PROCEDURE [dbo].[AC_uspDREAConstrular]
as

IF object_id('tempdb..#tmpDRE_Vendas') IS NOT NULL DROP TABLE #tmpDRE_Vendas
IF object_id('tempdb..#tmpDRE_Vendas_itens') IS NOT NULL DROP TABLE #tmpDRE_Vendas_itens
if OBJECT_ID('tempdb..#tmpDRE_Despesas') IS NOT NULL drop table #tmpDRE_Despesas
IF object_id('tempdb..#tmpDRE_Constrular_Email') IS NOT NULL DROP TABLE #tmpDRE_Constrular_Email
IF object_id('tempdb..#tempRateio') IS NOT NULL DROP TABLE #tempRateio

GO
-- VENDAS ---------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Apuração Venda a Vista
-- Venda "A Vista" Com pedido, NÃO considera Administradora de Cartões
-------------------------------------------------------------------------------
select 
	'PD'									as [Origem],
	pre.item								as [Codigo],
	ped.numped								as [Referencia],
	ven.dtven								as [Data],
	'1'										as [Sinal],
	'01 - (=) RECEITA OPERACIONAL BRUTA'	as [Tipo],
	'A Vista C/ Pedido'						as [Operacao],
	'01.001 - VENDAS À VISTA'				as [Hierarquia],
	pre.filial								as [Filial],
	pre.valprev								as [Valor]
into #tmpDRE_Vendas
from pediclicad ped 
		join prevclicad pre on ped.numped = pre.numped
		join item fp on ped.rformadepagar = fp.oid
		join item doc on doc.oid=pre.tipodoc
		join vendasscad ven on ven.numped = ped.numped
where sitven = '2'
		and pre.tipopar in (0,1) 
		and pre.tipodoc not in (17763)
-------------------------------------------------------------------------------
-- Apuração Venda a Prazo
-- Venda a Prazo
-------------------------------------------------------------------------------
UNION ALL SELECT
	'PD'									as [Origem],
	pre.item								as [Codigo],
	ped.numped								as [Referencia],
	ven.dtven								as [Data],
	'1'										as [Sinal],
	'01 - (=) RECEITA OPERACIONAL BRUTA'	as [Tipo],
	'A Prazo'								as [Operacao],
	'01.002 - VENDAS À PRAZO'				as [Hierarquia],
	pre.filial								as [Filial], 
	pre.valprev								as [Valor]
from pediclicad ped 
		join prevclicad pre on ped.numped = pre.numped
		join item fp on ped.rformadepagar = fp.oid
		join item doc on doc.oid=pre.tipodoc
		join vendasscad ven on ven.numped = ped.numped
	where sitven = '2'
		and pre.tipopar = 2 
		and pre.tipodoc not in (17763)

-------------------------------------------------------------------------------
-- Apuração venda com cartão
-------------------------------------------------------------------------------
UNION ALL SELECT
	'PD'									as [Origem],
	pre.item								as [Codigo],
	ped.numped								as [Referencia],
	ven.dtven								as [Data],
	'1'										as [Sinal],
	'01 - (=) RECEITA OPERACIONAL BRUTA'	as [Tipo],
	'Cartão C/Pedido'						as [Operacao],
	'01.003 - VENDAS C/ CARTÃO'				as [Hierarquia],
	pre.filial								as [Filial],
	pre.valprev								as [Valor]
from pediclicad ped 
		join prevclicad pre on ped.numped = pre.numped
		join item fp on ped.rformadepagar = fp.oid
		join item doc on doc.oid=pre.tipodoc
		join vendasscad ven on ven.numped = ped.numped
	where sitven = '2'
		and pre.tipodoc = 17763

-------------------------------------------------------------------------------
-- Venda "A Vista" SEM pedido, NÃO considera Administradora de Cartões
-------------------------------------------------------------------------------
UNION ALL SELECT
	'NF'									as [Origem],
	lc.IDLANCHEC							as [Codigo],
	nf.numord								as [Referencia],
	nf.dtemis								as [Data],
	'1'										as [Sinal],
	'01 - (=) RECEITA OPERACIONAL BRUTA'	as [Tipo],
	'Cartão S/Pedido'						as [Operacao],
	'01.003 - VENDAS C/ CARTÃO'				as [Hierarquia],
	Lc.filial								as [Filial],
	lc.vallanc								as [Valor]
from nfsaidacad nf 
	join LANCHECCXA lc on nf.numord = lc.numord
	join item doc on doc.oid=lc.documen
	where 
		nf.numped in(0,7) 
		and left(nf.tpo,1)=2
		and nf.atualiz = 1
		and nf.flagemit = 1
		and lc.documen in (select oid from ADMINISTRADORA_R)


-- Venda "A Vista" sem pedido, não considera administradora de cartões
-- 1 - Receita Bruta
-------------------------------------------------------------------------------
UNION ALL SELECT
	'NF'									as [Origem],
	lc.IDLANCHEC							as [Codigo],
	nf.numord								as [Referencia],
	nf.dtemis								as [Data],
	'1'										as [Sinal],
	'01 - (=) RECEITA OPERACIONAL BRUTA'	as [Tipo], 
	'A Vista S/ Pedido'						as [Operacao],
	'01.001 - VENDAS À VISTA'				as [Hierarquia],
	Lc.filial								as [Filial],
	lc.vallanc								as [Valor]
from nfsaidacad nf 
	join LANCHECCXA lc on nf.numord = lc.numord
	join item doc on doc.oid=lc.documen
	where 
		nf.numped in(0,7) 
		and left(nf.tpo,1)=2
		and nf.atualiz = 1
		and nf.flagemit = 1
		and nf.dtcancel is null
		and lc.documen not in (select oid from ADMINISTRADORA_R) -- Não considerar a venda com cartão

---------------------------------------------------------------------------------------------------------------------------
-- Apuração das Deduções de Vendas
-- Descontos Concedidos no recebimento 
-- Devoluções de vendas
-- 2 - Deduções de Vendas
---------------------------------------------------------------------------------------------------------------------------
UNION ALL SELECT
	DISTINCT 
	'DESC'											as [Origem], -- [D]esconto concedidos no recebimento
	PAGTO.OID										as [Codigo],
	PAGTO.OID										as [Referencia],
	ATO.DATA										as [Data],
	'-1'											as [Sinal],
	'02 - (=) DEDUÇÕES DA RECEITA BRUTA'			as [Tipo], 
	'Descontos'										as [Operacao],
	'02.001 - ABATIMENTOS/DESCONTOS CONCEDIDOS'		as [Hierarquia],
	FILIAL.CODIGO									as FILIAL,
	PAGTO.VALOR										as [Valor]
FROM ATOFINANCEIRO_R ATO 
	 JOIN ACAOFINANCEIRA ACAO ON ATO.OID = ACAO.RATOFINANCEIRO 
	 JOIN PAGAMENTO PAGTO ON ACAO.OID = PAGTO.RACAOFINANCEIRA 
	 JOIN CONTAARECEBER_R CONTA ON ACAO.RCONTA = CONTA.OID 
	 JOIN PESSOA_R CLIENTE ON CONTA.RDESTINATARIO = CLIENTE.OID 
	 JOIN PESSOA_R FILIAL ON CONTA.REMITENTE = FILIAL.OID 
	 JOIN CATEGORIA ON PAGTO.RTIPO = CATEGORIA.OID 
	 JOIN ITEM DO ON CONTA.RDOCDEORIGEM = DO.OID 
	 LEFT JOIN FATOFINANCEIRO_R FATO ON ATO.OID = FATO.RATOFINANCEIRO 
	 LEFT JOIN ADITIVO ON CONTA.OID = ADITIVO.RITEM
WHERE 
	CONTA.OID > 7 
	AND CATEGORIA.RSUPER = 2337
	AND ATO.RTIPO IN ( 2718 ) 
	AND ATO.RESTORNO = 7 
	AND PAGTO.RMOEDA = 113702  

-- 02.01 - Descontos Concedidos
---------------------------------------------------------------------------------------------
UNION ALL SELECT
	DISTINCT 
	'DESC'									as [Origem], -- [D]esconto concedidos no recebimento
	PAGTO.OID								as [Codigo],
	PAGTO.OID								as [Referencia],
	ATO.DATA								as [Data],
	'-1'									as [Sinal],
	'02 - (=) DEDUÇÕES DA RECEITA BRUTA'	as [Tipo], 
	'Descontos'								as [Operacao],
	'02.001 - Descontos Concedidos'			as [Hierarquia],
	FILIAL.CODIGO							as FILIAL,
	PAGTO.VALOR								as [Valor]
FROM ATOFINANCEIRO_R ATO 
	 JOIN ACAOFINANCEIRA ACAO ON ATO.OID = ACAO.RATOFINANCEIRO 
	 JOIN PAGAMENTO PAGTO ON ACAO.OID = PAGTO.RACAOFINANCEIRA 
	 JOIN CONTAARECEBER_R CONTA ON ACAO.RCONTA = CONTA.OID 
	 JOIN PESSOA_R CLIENTE ON CONTA.RDESTINATARIO = CLIENTE.OID 
	 JOIN PESSOA_R FILIAL ON CONTA.REMITENTE = FILIAL.OID 
	 JOIN CATEGORIA ON PAGTO.RTIPO = CATEGORIA.OID 
	 JOIN ITEM DO ON CONTA.RDOCDEORIGEM = DO.OID 
	 JOIN AGRUPAMENTO AG ON ATO.OID = AG.RGRUPO AND AG.RPAPEL = 33978 
	 JOIN FATOFINANCEIRO_R FATO ON AG.RITEM = FATO.RATOFINANCEIRO 
	 LEFT JOIN ADITIVO ON CONTA.OID = ADITIVO.RITEM
WHERE CONTA.OID > 7 
	AND CATEGORIA.RSUPER = 2337
	AND ATO.RTIPO = 23744 
	AND ATO.RESTORNO = 7 
	AND PAGTO.RMOEDA = 113702  
	AND CONTA.RTIPO != 23669 

-----------------------------------------------------------------------------------------------------
-- Devoluções:
-- Devolução com vínculo com a nota de venda
-----------------------------------------------------------------------------------------------------
UNION ALL SELECT
	distinct 
	'DEV'								as [Origem], -- [D]evoluções
	nfe.oiddocdeorigem					as [Codigo],
	nfe.numord							as [Referencia],
	nfe.dtcheg							as [Data],
	'-1'								as [Sinal],
	'02 - (=) DEDUÇÕES DA RECEITA BRUTA'as [Tipo], 
	'Devoluções'						as [Operacao],
	'02.002 - DEVOLUÇÕES DE VENDAS'		as [Hierarquia],
	case 
		when nfs.numped is null or nfs.numped < 7 then nfs.filial  -- Se não tiver pedido na venda pega da prória nota de saida
		when ven.numped is null or nfs.numped <= 7 then nfs.filial -- Se tiver pedido na venda pega da prória nota de saida
	else ven.filial end					as [Filial], -- Se tiver numped pega da venda
	nfe.valcontab						as [Valor]
	from 
	nfentracad nfe
	join itnfentcad ite on nfe.numord = ite.numord
	join nfsaidacad nfs on nfs.numord = ite.numorddev
	join itnfsaicad its on nfs.numord = its.numord  and ite.itemdev = its.item
	left join vendasscad ven on ven.numped = nfs.numped
where 
	left(nfe.tpo,1)= 6
	and nfe.atualiz = 1
	and nfe.dtcancel is null
	and ite.numorddev > 7

-- Devolução sem vínculo com a nota de venda
-------------------------------------------------------------------------------	
UNION ALL SELECT
	distinct 
	'DEV'								as [Origem], -- [D]evoluções
	nfe.oiddocdeorigem					as [Codigo],
	nfe.numord							as [Referencia],
	nfe.dtcheg							as [Data],
	'-1'								as [Sinal],
	'02 - (=) DEDUÇÕES DA RECEITA BRUTA'as [Tipo], 
	'Devoluções'						as [Operacao],
	'02.002 - DEVOLUÇÕES DE VENDAS'		as [Hierarquia],
	nfe.filial							as [Filial],
	nfe.valcontab						as [Valor]
	from nfentracad nfe	join itnfentcad ite on nfe.numord = ite.numord
where 
	left(nfe.tpo,1)= 6
	and nfe.atualiz = 1
	and nfe.dtcancel is null
	and ite.numorddev <= 7

-- Apuração dos Encargos:
-----------------------------------------------------------------------------------------------------
UNION ALL SELECT
	DISTINCT
	'ENC'								as [Origem], -- [E]ncargos
	PAGTO.OID							as [Codigo],
	conta.RDOCDEORIGEM					as [Referencia],
	ATO.DATA							as [Data],
	'1'									as [Sinal],
	'08 - (=) RECEITAS FINANCEIRAS'		as [Tipo], 
	'ENCARGOS'							as [Operacao],
	'09.002 - ENCARGOS RECEBIMENTO'		as [Hierarquia],
	FILIAL.CODIGO						as [Filial],
	PAGTO.VALOR							as [Valor]
FROM ATOFINANCEIRO_R ATO 
	 JOIN ACAOFINANCEIRA ACAO ON ATO.OID = ACAO.RATOFINANCEIRO 
	 JOIN PAGAMENTO PAGTO ON ACAO.OID = PAGTO.RACAOFINANCEIRA 
	 JOIN CONTAARECEBER_R CONTA ON ACAO.RCONTA = CONTA.OID 
	 JOIN PESSOA_R CLIENTE ON CONTA.RDESTINATARIO = CLIENTE.OID 
	 JOIN PESSOA_R FILIAL ON CONTA.REMITENTE = FILIAL.OID 
	 JOIN CATEGORIA ON PAGTO.RTIPO = CATEGORIA.OID 
	 JOIN ITEM DO ON CONTA.RDOCDEORIGEM = DO.OID 
	 LEFT JOIN FATOFINANCEIRO_R FATO ON ATO.OID = FATO.RATOFINANCEIRO 
	 LEFT JOIN ADITIVO ON CONTA.OID = ADITIVO.RITEM
WHERE 
	CONTA.OID > 7 
	AND CATEGORIA.RSUPER = 2330
	AND ATO.RTIPO IN ( 2718 ) 
	AND ATO.RESTORNO = 7 
	AND PAGTO.RMOEDA = 113702  
-- Encargos ---------------------------------------
UNION ALL SELECT
	'ENC'								as [Origem], -- [E]ncargos
	PAGTO.OID							as [Codigo],
	conta.RDOCDEORIGEM					as [Referencia],
	ATO.DATA							as [Data],
	'1'									as [Sinal],
	'08 - (=) RECEITAS FINANCEIRAS'		as [Tipo], 
	'ENCARGOS'							as [Operacao],
	'08.004 - ENCARGOS'					as [Hierarquia],
	FILIAL.CODIGO						as [Filial],
	PAGTO.VALOR							as [Valor]
FROM ATOFINANCEIRO_R ATO 
	 JOIN ACAOFINANCEIRA ACAO ON ATO.OID = ACAO.RATOFINANCEIRO 
	 JOIN PAGAMENTO PAGTO ON ACAO.OID = PAGTO.RACAOFINANCEIRA 
	 JOIN CONTAARECEBER_R CONTA ON ACAO.RCONTA = CONTA.OID 
	 JOIN PESSOA_R CLIENTE ON CONTA.RDESTINATARIO = CLIENTE.OID 
	 JOIN PESSOA_R FILIAL ON CONTA.REMITENTE = FILIAL.OID 
	 JOIN CATEGORIA ON PAGTO.RTIPO = CATEGORIA.OID 
	 JOIN ITEM DO ON CONTA.RDOCDEORIGEM = DO.OID 
	 JOIN AGRUPAMENTO AG ON ATO.OID = AG.RGRUPO AND AG.RPAPEL = 33978 
	 JOIN FATOFINANCEIRO_R FATO ON AG.RITEM = FATO.RATOFINANCEIRO 
	 LEFT JOIN ADITIVO ON CONTA.OID = ADITIVO.RITEM
WHERE CONTA.OID > 7 
	AND CATEGORIA.RSUPER = 2330
	AND ATO.RTIPO = 23744 
	AND ATO.RESTORNO = 7 
	AND PAGTO.RMOEDA = 113702  
	AND CONTA.RTIPO != 23669 


-------------------------------------------------------------------------------
-- CUSTO DOS ITENS ------------------------------------------------------------
-- Venda com Pedido
-------------------------------------------------------------------------------
select
	'CMCP'											as [Origem], -- [C]usto das [M]ercadorias [C]om [P]edido
	'0'												as [Codigo],
	PED.NUMPED										as [Referencia],
	ven.dtven										as [Data],
	'-1'											as [Sinal],
	'04 - (=) CUSTO DAS VENDAS'						as [Tipo],
	'Custo Mercadoria Vendida'						as [Operacao],
	'04.001 - CUSTO DOS PRODUTOS VENDIDOS (CMV)'	as [Hierarquia],
	ped.filial										as [Filial], 
    SUM(PROD.PRECOCOMP*ITPD.QUANT)					as Valor
	into #tmpDRE_Vendas_itens
from 
	pediclicad ped 
	join vendasscad ven on ven.numped = ped.numped
	join itemclicad itpd on itpd.numped = ped.numped
	join produtocad prod on itpd.codpro = prod.codpro
where
	ped.numped = (select distinct tmpVenda.Referencia 
						from #tmpDRE_Vendas tmpVenda
						where tmpVenda.Origem = 'PD' 
							and tmpVenda.Referencia = ped.numped)
GROUP BY 
	PED.NUMPED,	ven.dtven,	ped.filial	

-- Venda sem Pedido
-------------------------------------------------------------------------------
UNION ALL SELECT 
	'CMSP'											as [Origem], -- [C]usto das [M]ercadorias [S]em [P]edido
	'0'												as [Codigo],
	NF.NUMORD										as [Referencia],
	nf.dtemis										as [Data],
	'-1'											AS [Sinal],
	'04 - (=) CUSTO DAS VENDAS'						as [Tipo],
	'Custo Mercadoria Vendida'						as [Operacao],
	'04.001 - CUSTO DOS PRODUTOS VENDIDOS (CMV)'	as [Hierarquia],
	nf.filial										as [Filial],
    SUM(ITNF.QUANT*PROD.PRECOCOMP)					as Valor
from 
	nfsaidacad nf 
	join itnfsaicad itnf on itnf.numord = nf.numord
	join produtocad prod on itnf.codpro = prod.codpro
where
	nf.numord = (select distinct tmpVenda.Referencia 
						from #tmpDRE_Vendas tmpVenda
						where tmpVenda.Origem = 'NF' 
							and tmpVenda.Referencia = nf.numord)
GROUP BY 
	NF.NUMORD, nf.dtemis, nf.filial

	-- Devolução de venda
-------------------------------------------------------------------------------
UNION ALL SELECT
	'CDV'											as [Origem], -- [C]usto das [D]evolução de [V]enda
	'0'												as [Codigo],
	NF.NUMORD										as [Referencia],
	nf.dtcheg										as [Data],
	'1'												as [Sinal],
	'04 - (=) CUSTO DAS VENDAS'						as [Tipo],
	'Custo DEVOLUÇÕES DE VENDAS'					as [Operacao],
	'04.005 - CUSTO DAS DEVOLUÇÕES DE VENDAS (CMV)'	as [Hierarquia],
	nf.filial										as [Filial],
    SUM(ITNF.QUANT*PROD.PRECOCOMP)					as Valor
from 
	NFENTRACAD NF 
	join ITNFENTCAD itnf on itnf.numord = nf.numord
	join produtocad prod on itnf.codpro = prod.codpro
where
	nf.numord = (select distinct tmpDev.Referencia
						from #tmpDRE_Vendas tmpDev
						where tmpDev.Origem = 'DEV' 
							and tmpDev.Referencia = nf.numord)
GROUP BY 
	NF.NUMORD, nf.dtcheg, nf.filial
-- // FIM VENDAS ---------------------------------------------------------------------------

-- // DESPESAS -----------------------------------------------------------------------------
-- SQL: 1 
--------------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT	
	'SQL1'														as [Origem],
	FATOFINANCEIRO_R.OID										as [Codigo],
	FATOFINANCEIRO_R.RATOFINANCEIRO 							as [Referencia],
	FATOFINANCEIRO_R.DATA										as [Data],
	DRE.SINAL													as [Sinal],
	DRE.CODIGO + ' - ' + DRE.GRUPO								as [Tipo], 
	DRE.HIERARQUIA + ' - ' + DRE.DESCRICAO						as [Hierarquia],
	FILIAL.CODIGO												as [Filial],
	T.HIERARQUIANUMERO + ' - ' + T.NOME							as [TPO],
	FATOFINANCEIRO_R.VALOR										as [VALOR]
INTO #tmpDRE_Despesas
FROM 
	FATOFINANCEIRO_R, 	CAIXABANCARIA,	TPO_R T, PESSOA_R FILIAL, AC_DRE_CONSTRULAR_R DRE
WHERE FATOFINANCEIRO_R.RFONTEPAGADORA = CAIXABANCARIA.OID
	AND FATOFINANCEIRO_R.OID NOT IN (SELECT MOV.RORIGEM FROM MOVIMENTOGERENCIAL MOV)
	AND DRE.HIERARQUIA = T.OBSERVACAO 
	AND T.OID =  FATOFINANCEIRO_R.RTPO
	AND FILIAL.OID = CAIXABANCARIA.RITEM
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND NOT EXISTS ( SELECT 1 FROM UTILIZACAO U WHERE U.RITEM = FATOFINANCEIRO_R.OID )  
	AND CAIXABANCARIA.RITEM IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 

UNION ALL SELECT DISTINCT	
	'SQL1.R'													as [Origem],
	FATOFINANCEIRO_R.OID										as [Codigo],
	FG.OID							 							as [Referencia],
	FATOFINANCEIRO_R.DATA										as [Data],
	DRE.SINAL													as [Sinal],
	DRE.CODIGO + ' - ' + DRE.GRUPO								as [Tipo], 

	CASE WHEN SUBSTRING(CC.OBSERVACAO,3,2) = 'DV' THEN DRE.VARIACAO  + ' - ' + DRE.DESCRICAO
	ELSE DRE.HIERARQUIA   + ' - ' + DRE.DESCRICAO 	END			as [Hierarquia],

	CASE WHEN SUBSTRING(CC.OBSERVACAO,1,2) = '' THEN FILIAL.CODIGO 
	ELSE SUBSTRING(CC.OBSERVACAO,1,2) END					    as [Filial],

	T.HIERARQUIANUMERO + ' - ' + T.NOME							as [TPO],
	CASE WHEN FG.VALOR < 0 THEN FG.VALOR *-1 ELSE FG.VALOR END	as [VALOR]
	
FROM 
	FATOFINANCEIRO_R, 	CAIXABANCARIA,	TPO_R T, PESSOA_R FILIAL, AC_DRE_CONSTRULAR_R DRE,
	MOVIMENTOGERENCIAL MOV, CONTACONTABIL_R CC, FATOGERENCIAL FG, FILTRODERATEIO FR
WHERE FATOFINANCEIRO_R.RFONTEPAGADORA = CAIXABANCARIA.OID
	AND FATOFINANCEIRO_R.OID = MOV.RORIGEM
	AND FR.RFATOGERENCIAL = FG.OID
	AND FR.RCONTACONTABIL = CC.OID
	AND MOV.OID = FG.RMOVIMENTOGERENCIAL
	AND FR.RFILTROPAI > 7
	AND DRE.HIERARQUIA = T.OBSERVACAO 
	AND T.OID =  FATOFINANCEIRO_R.RTPO
	AND FILIAL.OID = CAIXABANCARIA.RITEM
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND NOT EXISTS ( SELECT 1 FROM UTILIZACAO U WHERE U.RITEM = FATOFINANCEIRO_R.OID )  
	AND CAIXABANCARIA.RITEM IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
--SQL: 2 
--------------------------------------------------------------------------------------------------------------------------------
UNION ALL SELECT DISTINCT	
	'SQL2'														as [Origem],
	PG.OID														as [Codigo],
	CONTA.OID													as [Referencia],
	AT.DATA														as [Data],
	DRE.SINAL													as [Sinal],
	DRE.CODIGO + ' - ' + DRE.GRUPO								as [Tipo], 
	DRE.HIERARQUIA + ' - ' + DRE.DESCRICAO						as [Hierarquia],
	FILIAL.CODIGO												as [Filial],
	T.HIERARQUIANUMERO + ' - ' + T.NOME							as [TPO],
	CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END  as [Valor]

FROM  
	PAGAMENTO PG, 	CONTAAPAGAR_R CONTA, 	ACAOFINANCEIRA AF, 	ATOFINANCEIRO AT, 	CATEGORIA CAT,	
	TPO_R T, PESSOA_R FILIAL, AC_DRE_CONSTRULAR_R DRE
WHERE CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.OID NOT IN (SELECT MOV.RORIGEM FROM MOVIMENTOGERENCIAL MOV)
	AND DRE.HIERARQUIA = T.OBSERVACAO 
	AND T.OID = CONTA.RTPO
	AND FILIAL.OID = CONTA.RDESTINATARIO
	AND CONTA.OID = AF.RCONTA 
	AND AF.OID = PG.RACAOFINANCEIRA
	AND AF.RATOFINANCEIRO = AT.OID 
	AND AT.RTIPO IN  ( 2372, 23709, 23724 ) 
	AND NOT ( AT.RTIPO = 23724 	AND CONTA.RTIPO = 23669 )
	AND AT.RESTORNO = 7 
	AND PG.RTIPO = CAT.OID   
	AND CONTA.RMOEDA1 = 113702 
	AND CONTA.RDESTINATARIO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	
UNION ALL SELECT DISTINCT	
	'SQL2.R'													as [Origem],
	PG.OID														as [Codigo],
	FG.OID													    as [Referencia],
	AT.DATA														as [Data],
	DRE.SINAL													as [Sinal],
	DRE.CODIGO + ' - ' + DRE.GRUPO								as [Tipo], 

	CASE WHEN SUBSTRING(CC.OBSERVACAO,3,2) = 'DV' THEN DRE.VARIACAO  + ' - ' + DRE.DESCRICAO
	ELSE DRE.HIERARQUIA   + ' - ' + DRE.DESCRICAO 	END			as [Hierarquia],

	CASE WHEN SUBSTRING(CC.OBSERVACAO,1,2) = '' THEN FILIAL.CODIGO 
	ELSE SUBSTRING(CC.OBSERVACAO,1,2) END					    as [Filial],

	T.HIERARQUIANUMERO + ' - ' + T.NOME							as [TPO],
--	CASE WHEN FG.VALOR < 0 THEN FG.VALOR *-1 ELSE FG.VALOR END  as [Valor]
/*
	Solução temporária para Despesas com refeição, pois os valores da fato gerencial 
	são diferentes do pagamento
*/
	CASE WHEN T.CODIGO IN ('167','260','175','227') THEN
		CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END
	ELSE 
		CASE WHEN FG.VALOR < 0 THEN FG.VALOR *-1 ELSE FG.VALOR END  
	END as [Valor]

FROM  
	PAGAMENTO PG, CONTAAPAGAR_R CONTA, ACAOFINANCEIRA AF, ATOFINANCEIRO AT, CATEGORIA CAT,	
	TPO_R T, PESSOA_R FILIAL, AC_DRE_CONSTRULAR_R DRE,
	MOVIMENTOGERENCIAL MOV, CONTACONTABIL_R CC, FATOGERENCIAL FG, FILTRODERATEIO FR
WHERE CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.OID = MOV.RORIGEM
	AND FR.RFATOGERENCIAL = FG.OID
	AND FR.RCONTACONTABIL = CC.OID
	AND MOV.OID = FG.RMOVIMENTOGERENCIAL
		AND (FR.RFILTROPAI > 7
			-- Medida para ajustar 06.003.015 - RETIRADAS ALEX
			or fr.RFILTROPAI = 7  AND CONTA.RTPO IN ( 8159, 2300468, 2679694, 4360902 ) )
	AND DRE.HIERARQUIA = T.OBSERVACAO
	AND T.OID = CONTA.RTPO
	AND FILIAL.OID = CONTA.RDESTINATARIO
	AND CONTA.OID = AF.RCONTA 
	AND AF.OID = PG.RACAOFINANCEIRA
	AND AF.RATOFINANCEIRO = AT.OID 
	AND AT.RTIPO IN  ( 2372, 23709, 23724 ) 
	AND NOT ( AT.RTIPO = 23724	AND CONTA.RTIPO = 23669 )
	AND AT.RESTORNO = 7 
	AND PG.RTIPO = CAT.OID   
	AND CONTA.RMOEDA1 = 113702 
	AND CONTA.RDESTINATARIO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 

--SQL: 3 
--------------------------------------------------------------------------------------------------------------------------------
UNION ALL SELECT DISTINCT
	'SQL3'														as [Origem],
	PG.OID														as [Codigo],
	PG.OID														as [Referencia],
	AT.DATA														as [Data],
	DRE.SINAL													as [Sinal],
	DRE.CODIGO + ' - ' + DRE.GRUPO								as [Tipo], 
	DRE.HIERARQUIA + ' - ' + DRE.DESCRICAO						as [Hierarquia],
	FILIAL.CODIGO												as [Filial],
	T.HIERARQUIANUMERO + ' - ' + T.NOME							as [TPO],
	CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END  as [Valor]
	
FROM  PAGAMENTO PG, CONTAARECEBER_R CONTA, ACAOFINANCEIRA AF,ATOFINANCEIRO AT, CATEGORIA CAT,
	TPO_R T, PESSOA_R FILIAL, AC_DRE_CONSTRULAR_R DRE
WHERE CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.OID NOT IN (SELECT RORIGEM FROM MOVIMENTOGERENCIAL_R)
	AND DRE.HIERARQUIA = T.OBSERVACAO 
	AND T.OID = CONTA.RTPO
	AND FILIAL.OID = CONTA.REMITENTE
	AND CONTA.OID = AF.RCONTA 
	AND AF.OID = PG.RACAOFINANCEIRA
	AND AF.RATOFINANCEIRO = AT.OID 
	AND AT.RTIPO IN ( 2718, 23739, 23744 )  
	AND NOT ( AT.RTIPO = 23744 AND CONTA.RTIPO = 23669 )
	AND AT.RESTORNO = 7 
	AND PG.RTIPO = CAT.OID   
	AND CONTA.RMOEDA1 = 113702 
	AND CONTA.REMITENTE IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	
UNION ALL SELECT DISTINCT
	'SQL3.R'													as [Origem],
	PG.OID														as [Codigo],
	FG.OID														as [Referencia],
	AT.DATA														as [Data],
	DRE.SINAL													as [Sinal],
	DRE.CODIGO + ' - ' + DRE.GRUPO								as [Tipo], 

	CASE WHEN SUBSTRING(CC.OBSERVACAO,3,2) = 'DV' THEN DRE.VARIACAO  + ' - ' + DRE.DESCRICAO
	ELSE DRE.HIERARQUIA   + ' - ' + DRE.DESCRICAO 	END			as [Hierarquia],

	CASE WHEN SUBSTRING(CC.OBSERVACAO,1,2) = '' THEN FILIAL.CODIGO 
	ELSE SUBSTRING(CC.OBSERVACAO,1,2) END					    as [Filial],

	T.HIERARQUIANUMERO + ' - ' + T.NOME							as [TPO],
	CASE WHEN FG.VALOR < 0 THEN FG.VALOR *-1 ELSE FG.VALOR END  as [Valor]

FROM  
	PAGAMENTO PG, CONTAARECEBER_R CONTA, ACAOFINANCEIRA AF,ATOFINANCEIRO AT, CATEGORIA CAT,
	TPO_R T, PESSOA_R FILIAL, AC_DRE_CONSTRULAR_R DRE,
	MOVIMENTOGERENCIAL MOV, CONTACONTABIL_R CC, FATOGERENCIAL FG, FILTRODERATEIO FR
WHERE CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.OID = MOV.RORIGEM
	AND FR.RFATOGERENCIAL = FG.OID
	AND FR.RCONTACONTABIL = CC.OID
	AND MOV.OID = FG.RMOVIMENTOGERENCIAL
	AND FR.RFILTROPAI > 7
	AND DRE.HIERARQUIA = T.OBSERVACAO 
	AND T.OID = CONTA.RTPO
	AND FILIAL.OID = CONTA.REMITENTE
	AND CONTA.OID = AF.RCONTA 
	AND AF.OID = PG.RACAOFINANCEIRA
	AND AF.RATOFINANCEIRO = AT.OID 
	AND AT.RTIPO IN ( 2718, 23739, 23744 )  
	AND NOT ( AT.RTIPO = 23744 AND CONTA.RTIPO = 23669 )
	AND AT.RESTORNO = 7 
	AND PG.RTIPO = CAT.OID   
	AND CONTA.RMOEDA1 = 113702 
	AND CONTA.REMITENTE IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
--SQL: 4
--------------------------------------------------------------------------------------------------------------------------------
UNION ALL SELECT DISTINCT
	'SQL4'														as [Origem],
	FATOFINANCEIRO_R.OID										as [Codigo],
	FATOFINANCEIRO_R.RATOFINANCEIRO 							as [Referencia],
	FATOFINANCEIRO_R.DATA										as [Data],
	DRE.SINAL													as [Sinal], 
	DRE.CODIGO + ' - ' + DRE.GRUPO								as [Tipo], 
	DRE.HIERARQUIA + ' - ' + DRE.DESCRICAO						as [Hierarquia],
	FILIAL.CODIGO												as [Filial],
	T.HIERARQUIANUMERO + ' - ' + T.NOME							as [TPO],
	FATOFINANCEIRO_R.VALOR										as [VALOR]

FROM FATOFINANCEIRO_R, UTILIZACAO U, TPO_R T, PESSOA_R FILIAL, AC_DRE_CONSTRULAR_R DRE
WHERE FATOFINANCEIRO_R.OID = U.RITEM
	AND FATOFINANCEIRO_R.OID NOT IN (SELECT MOV.RORIGEM FROM MOVIMENTOGERENCIAL MOV)
	AND DRE.HIERARQUIA = T.OBSERVACAO 
	AND T.OID =  FATOFINANCEIRO_R.RTPO
	AND FILIAL.OID = U.RUTILIZADO
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND U.RUTILIZADO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	
UNION ALL SELECT DISTINCT
	'SQL4.R'													as [Origem],
	FATOFINANCEIRO_R.OID										as [Codigo],
	FG.OID							 							as [Referencia],
	FATOFINANCEIRO_R.DATA										as [Data],
	DRE.SINAL													as [Sinal], --SELECT * FROM AC_DRE_CONSTRULAR_R
	DRE.CODIGO + ' - ' + DRE.GRUPO								as [Tipo], 

	CASE WHEN SUBSTRING(CC.OBSERVACAO,3,2) = 'DV' THEN DRE.VARIACAO  + ' - ' + DRE.DESCRICAO
	ELSE DRE.HIERARQUIA   + ' - ' + DRE.DESCRICAO 	END			as [Hierarquia],

	CASE WHEN SUBSTRING(CC.OBSERVACAO,1,2) = '' THEN FILIAL.CODIGO 
	ELSE SUBSTRING(CC.OBSERVACAO,1,2) END					    as [Filial],

	T.HIERARQUIANUMERO + ' - ' + T.NOME							as [TPO],
	FG.VALOR													as [VALOR]

FROM FATOFINANCEIRO_R, UTILIZACAO U, TPO_R T, PESSOA_R FILIAL, AC_DRE_CONSTRULAR_R DRE,
	MOVIMENTOGERENCIAL MOV, CONTACONTABIL_R CC, FATOGERENCIAL FG, FILTRODERATEIO FR
WHERE FATOFINANCEIRO_R.OID = U.RITEM
	AND FATOFINANCEIRO_R.OID = MOV.RORIGEM
	AND FR.RFATOGERENCIAL = FG.OID
	AND FR.RCONTACONTABIL = CC.OID
	AND MOV.OID = FG.RMOVIMENTOGERENCIAL
	AND FR.RFILTROPAI > 7
	AND DRE.HIERARQUIA = T.OBSERVACAO 
	AND T.OID =  FATOFINANCEIRO_R.RTPO
	AND FILIAL.OID = U.RUTILIZADO
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND U.RUTILIZADO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 

--SQL: 5
--------------------------------------------------------------------------------------------------------------------------------
UNION ALL SELECT DISTINCT
	'SQL5'														as [Origem],
	FATOFINANCEIRO_R.OID										as [Codigo],
	FATOFINANCEIRO_R.RATOFINANCEIRO 							as [Referencia],
	FATOFINANCEIRO_R.DATA										as [Data],
	DRE.SINAL													as [Sinal], --SELECT * FROM AC_DRE_CONSTRULAR_R
	DRE.CODIGO + ' - ' + DRE.GRUPO								as [Tipo], 
	DRE.HIERARQUIA + ' - ' + DRE.DESCRICAO						as [Hierarquia],
	FILIAL.CODIGO												as [Filial],
	T.HIERARQUIANUMERO + ' - ' + T.NOME							as [TPO],
	FATOFINANCEIRO_R.VALOR										as [VALOR]
FROM 
	FATOFINANCEIRO_R, CAIXABANCARIA, ATOFINANCEIRO ATO, TPO_R T, PESSOA_R FILIAL, AC_DRE_CONSTRULAR_R DRE
WHERE FATOFINANCEIRO_R.RFONTEPAGADORA = CAIXABANCARIA.OID
	AND FATOFINANCEIRO_R.OID NOT IN (SELECT MOV.RORIGEM FROM MOVIMENTOGERENCIAL MOV)
	AND DRE.HIERARQUIA = T.OBSERVACAO 
	AND T.OID =  FATOFINANCEIRO_R.RTPO
	AND FILIAL.OID = CAIXABANCARIA.RITEM
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO > 7
	AND FATOFINANCEIRO_R.RATOFINANCEIRO = ATO.OID 
	AND ATO.RTIPO IN ( 29852, 23724, 23744, 38032 ) 
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND CAIXABANCARIA.RITEM IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 

UNION ALL SELECT DISTINCT
	'SQL5.R'													as [Origem],
	FATOFINANCEIRO_R.OID										as [Codigo],
	FG.OID							 							as [Referencia],
	FATOFINANCEIRO_R.DATA										as [Data],
	DRE.SINAL													as [Sinal], 
	DRE.CODIGO + ' - ' + DRE.GRUPO								as [Tipo], 

	CASE WHEN SUBSTRING(CC.OBSERVACAO,3,2) = 'DV' THEN DRE.VARIACAO  + ' - ' + DRE.DESCRICAO
	ELSE DRE.HIERARQUIA   + ' - ' + DRE.DESCRICAO 	END			as [Hierarquia],

	CASE WHEN SUBSTRING(CC.OBSERVACAO,1,2) = '' THEN FILIAL.CODIGO 
	ELSE SUBSTRING(CC.OBSERVACAO,1,2) END					    as [Filial],

	T.HIERARQUIANUMERO + ' - ' + T.NOME							as [TPO],
	FG.VALOR													as [VALOR]
FROM 
	FATOFINANCEIRO_R, CAIXABANCARIA, ATOFINANCEIRO ATO, TPO_R T, PESSOA_R FILIAL, AC_DRE_CONSTRULAR_R DRE,
	MOVIMENTOGERENCIAL MOV, CONTACONTABIL_R CC, FATOGERENCIAL FG, FILTRODERATEIO FR
WHERE FATOFINANCEIRO_R.RFONTEPAGADORA = CAIXABANCARIA.OID
	AND FATOFINANCEIRO_R.OID = MOV.RORIGEM
	AND FR.RFATOGERENCIAL = FG.OID
	AND FR.RCONTACONTABIL = CC.OID
	AND MOV.OID = FG.RMOVIMENTOGERENCIAL
	AND FR.RFILTROPAI > 7
	AND DRE.HIERARQUIA = T.OBSERVACAO 
	AND T.OID =  FATOFINANCEIRO_R.RTPO
	AND FILIAL.OID = CAIXABANCARIA.RITEM
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO > 7
	AND FATOFINANCEIRO_R.RATOFINANCEIRO = ATO.OID 
	AND ATO.RTIPO IN ( 29852, 23724, 23744, 38032 ) 
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND CAIXABANCARIA.RITEM IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 

-- SQL: 6
--------------------------------------------------------------------------------------------------------------------------------
UNION ALL SELECT DISTINCT
	'SQL6'														as [Origem],
	DO.OID														as [Codigo],
	DO.OID														as [Referencia],
	DO.EMISSAO													as [Data],
	DRE.SINAL													as [Sinal], 
	DRE.CODIGO + ' - ' + DRE.GRUPO								as [Tipo], 
	DRE.HIERARQUIA + ' - ' + DRE.DESCRICAO						as [Hierarquia],
	F.FILIAL													as [Filial],
	T.HIERARQUIANUMERO + ' - ' + T.NOME							as [TPO],
	DO.VALORNAMOEDA1											as [VALOR]
FROM 
	DOCDEORIGEM_R DO, NFSAIDACAD NFS, NFENTRACAD NFE, FILIALCAD F,
	TPO_R T, AC_DRE_CONSTRULAR_R DRE
WHERE DO.OID = NFS.OIDDOCDEORIGEM 
	AND DO.OID NOT IN (SELECT MOV.RORIGEM FROM MOVIMENTOGERENCIAL MOV)
	AND DRE.HIERARQUIA = T.OBSERVACAO 
	AND DO.OID = NFE.OIDDOCDEORIGEM 
	AND NFS.TPO = T.HIERARQUIANUMERO 
	AND NFS.FILIAL = F.FILIAL 
	AND T.HIERARQUIAMASCARA LIKE '9%'  
	AND DO.RMOEDA1 = 113702 
	AND F.OID IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 )

UNION ALL SELECT DISTINCT
	'SQL6.R'													as [Origem],
	DO.OID														as [Codigo],
	FG.OID														as [Referencia],
	DO.EMISSAO													as [Data],
	DRE.SINAL													as [Sinal], 
	DRE.CODIGO + ' - ' + DRE.GRUPO								as [Tipo], 

	CASE WHEN SUBSTRING(CC.OBSERVACAO,3,2) = 'DV' THEN DRE.VARIACAO  + ' - ' + DRE.DESCRICAO
	ELSE DRE.HIERARQUIA   + ' - ' + DRE.DESCRICAO 	END			as [Hierarquia],

	CASE WHEN SUBSTRING(CC.OBSERVACAO,1,2) = '' THEN F.FILIAL 
	ELSE SUBSTRING(CC.OBSERVACAO,1,2) END					    as [Filial],

	T.HIERARQUIANUMERO + ' - ' + T.NOME							as [TPO],
	FG.VALOR													as [VALOR]
FROM 
	DOCDEORIGEM_R DO, NFSAIDACAD NFS, NFENTRACAD NFE, FILIALCAD F,
	TPO_R T, AC_DRE_CONSTRULAR_R DRE,
	MOVIMENTOGERENCIAL MOV, CONTACONTABIL_R CC, FATOGERENCIAL FG, FILTRODERATEIO FR
WHERE DO.OID = NFS.OIDDOCDEORIGEM 
	AND DO.OID = MOV.RORIGEM
	AND FR.RFATOGERENCIAL = FG.OID
	AND FR.RCONTACONTABIL = CC.OID
	AND MOV.OID = FG.RMOVIMENTOGERENCIAL
	AND FR.RFILTROPAI > 7
	AND DRE.HIERARQUIA = T.OBSERVACAO 
	AND DO.OID = NFE.OIDDOCDEORIGEM 
	AND NFS.TPO = T.HIERARQUIANUMERO 
	AND NFS.FILIAL = F.FILIAL 
	AND T.HIERARQUIAMASCARA LIKE '9%'  
	AND DO.RMOEDA1 = 113702 
	AND F.OID IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 )

UNION ALL SELECT DISTINCT
	'SQL7'														as [Origem],
	DO.OID														as [Codigo],
	DO.OID														as [Referencia],
	DO.EMISSAO													as [Data],
	DRE.SINAL													as [Sinal], 
	DRE.CODIGO + ' - ' + DRE.GRUPO								as [Tipo], 
	DRE.HIERARQUIA + ' - ' + DRE.DESCRICAO						as [Hierarquia],
	F.FILIAL													as [Filial],
	T.HIERARQUIANUMERO + ' - ' + T.NOME							as [TPO],
	DO.VALORNAMOEDA1											as [VALOR]
FROM DOCDEORIGEM_R DO, NFSAIDACAD NFS, NFENTRACAD NFE, FILIALCAD F,
	TPO_R T, AC_DRE_CONSTRULAR_R DRE
WHERE DO.OID = NFS.OIDDOCDEORIGEM 
	AND DO.OID NOT IN (SELECT MOV.RORIGEM FROM MOVIMENTOGERENCIAL MOV)
	AND DRE.HIERARQUIA = T.OBSERVACAO 
	AND DO.OID = NFE.OIDDOCDEORIGEM 
	AND NFE.TPO = T.HIERARQUIANUMERO 
	AND NFE.FILIAL = F.FILIAL 
	AND T.HIERARQUIAMASCARA LIKE '9%'  
	AND DO.RMOEDA1 = 113702 
	AND F.OID IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND NFE.TPO != NFS.TPO 

UNION ALL SELECT DISTINCT
	'SQL7.R'														as [Origem],
	DO.OID														as [Codigo],
	FG.OID														as [Referencia],
	DO.EMISSAO													as [Data],
	DRE.SINAL													as [Sinal], 
	DRE.CODIGO + ' - ' + DRE.GRUPO								as [Tipo], 

	CASE WHEN SUBSTRING(CC.OBSERVACAO,3,2) = 'DV' THEN DRE.VARIACAO  + ' - ' + DRE.DESCRICAO
	ELSE DRE.HIERARQUIA   + ' - ' + DRE.DESCRICAO 	END			as [Hierarquia],

	CASE WHEN SUBSTRING(CC.OBSERVACAO,1,2) = '' THEN F.FILIAL 
	ELSE SUBSTRING(CC.OBSERVACAO,1,2) END					    as [Filial],

	T.HIERARQUIANUMERO + ' - ' + T.NOME							as [TPO],
	FG.VALOR													as [VALOR]
FROM DOCDEORIGEM_R DO, NFSAIDACAD NFS, NFENTRACAD NFE, FILIALCAD F,
	TPO_R T, AC_DRE_CONSTRULAR_R DRE,
	MOVIMENTOGERENCIAL MOV, CONTACONTABIL_R CC, FATOGERENCIAL FG, FILTRODERATEIO FR
WHERE DO.OID = NFS.OIDDOCDEORIGEM 
	AND DO.OID = MOV.RORIGEM
	AND FR.RFATOGERENCIAL = FG.OID
	AND FR.RCONTACONTABIL = CC.OID
	AND MOV.OID = FG.RMOVIMENTOGERENCIAL
	AND FR.RFILTROPAI > 7
	AND DRE.HIERARQUIA = T.OBSERVACAO 
	AND DO.OID = NFE.OIDDOCDEORIGEM 
	AND NFE.TPO = T.HIERARQUIANUMERO 
	AND NFE.FILIAL = F.FILIAL 
	AND T.HIERARQUIAMASCARA LIKE '9%'  
	AND DO.RMOEDA1 = 113702 
	AND F.OID IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND NFE.TPO != NFS.TPO 

-- // FIM DESPESAS -------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- Conversão para tabela
--------------------------------------------------------------------------------------------
select 
	ORIGEM, CODIGO, Referencia, DATA, SINAL, TIPO, Hierarquia,FILIAL, '7' as TPO, VALOR 
	into #tmpDRE_Constrular_Email
	from #tmpDRE_Vendas
UNION ALL select 	
	ORIGEM, CODIGO, Referencia, DATA, SINAL, TIPO, Hierarquia,FILIAL, '7' as TPO, VALOR 
	from #tmpDRE_Vendas_itens
UNION ALL select 
	ORIGEM, CODIGO, Referencia, DATA, SINAL, TIPO, Hierarquia, FILIAL, TPO, VALOR 
	from #tmpDRE_Despesas

GO

-- Rateio das Despesas do Depósito ---------------------------------------------------------
--------------------------------------------------------------------------------------------
select 
	Filial,
	MES,
	ANO, 
	'-1' AS SINAL,
	'V' as Tipo,  
	'06.003.024 - DESPESAS RATEADAS CONTORNO' as Hierarquia, 
	sum(valor * SINAL) as Valor, 
	'' as Rateio
into #tempRateio
from AC_DRE_RESULT 
where 
	LEFT(Hierarquia,2) = '01' 
	group by filial,MES,ANO

union ALL select 
	Filial,
	MES,
	ANO, 
	'-1' AS SINAL,
	'D' as Tipo, 
	'06.003.024 - TOTAL DESPESAS CONTORNO' as Hierarquia, 
	sum(valor * SINAL) as Valor, 
	'' as Rateio
from AC_DRE_RESULT 
where 
	LEFT(Hierarquia,2) = '06' -- Para não filtrar o faturamento mensal, Filtra somente o grupo de despesas
	AND  LEFT(Hierarquia,2) not in ('07') -- Para não filtrar a si própprio
	AND HIERARQUIA NOT IN ('06.003.024 - DESPESAS RATEADAS CONTORNO') -- Para não incluir sua própria despesa rateada.
	and filial = '04'
	--and sinal = -1            -- Sinal de despesas
group by filial,MES,ANO

Go
-- Inserir ao DRE
-------------------------------------------------------------------------------
TRUNCATE TABLE AC_DRE_RESULT
GO

INSERT INTO AC_DRE_RESULT 
select
	a.filial,
	MONTH(a.data) AS MES,
	YEAR(a.data) AS ANO,
	a.Sinal,
	a.Tipo,
	a.Hierarquia,	
	sum(a.valor*sinal) 
from #tmpDRE_Constrular_Email a
group by a.filial,MONTH(data),YEAR(data),a.Sinal,Tipo,Hierarquia

Union select 
	a.filial,
	a.MES,
	a.ANO,
	a.SINAL,
	'06 - (=) DESPESAS OPERACIONAIS' as Tipo,
	a.HIERARQUIA,
	a.valor * sinal * (d.despesa /(
				select sum(valor) from #tempRateio 
				where tipo = 'V' 
					and a.ano=ano 
					and a.MES = mes 
					)) as Valor
from #tempRateio a, 
	(select r.filial, r.ano, r.mes,sum(r.valor) as despesa 
		from #tempRateio r where r.tipo = 'D' and r.ano =2018 and r.mes = 2 
		group by r.MES,	r.ANO,r.filial) as D
where 
	a.ANO = d.ano
	and a.MES = d.MES
	and a.Tipo = 'V'
GO

-- TOTALIZADORES DO DRE
-- 03.001 - RECEITA OPERACIONAL LÍQUIDA (1-2) ----------------------------------------------------------------------------------------
INSERT INTO AC_DRE_RESULT 
select
	Filial,
	MES,
	ANO,
	'0' as Sinal,
	'03 - ==========================================================' AS TIPO,
	'03.999 - RECEITA OPERACIONAL LÍQUIDA (1-2)' AS HIERARQUIA,	 	
	sum(valor) AS Valor
from AC_DRE_RESULT
where left (HIERARQUIA,6) in (
								'01.001',	-- VENDAS À VISTA
								'01.002',	-- VENDAS À PRAZO
								'01.003',	-- VENDAS C/ CARTÃO
								'02.001',	-- ABATIMENTOS/DESCONTOS CONCEDIDOS
								'02.002'	-- DEVOLUÇÕES DE VENDAS
								)
group by filial, MES, ANO
order by filial, 6

GO

-- 05.001 - LUCRO BRUTO (3-(4-5)) ----------------------------------------------------------------------------------------
INSERT INTO AC_DRE_RESULT 
select
	Filial,
	MES,
	ANO,
	'0' as Sinal,
	'05 - ==========================================================' AS TIPO,
	'05.999 - LUCRO BRUTO (3-(4-5))' AS HIERARQUIA,	 	
	sum(valor) AS Valor
from AC_DRE_RESULT
where left (HIERARQUIA,6) in (
								'03.999',	-- RECEITA OPERACIONAL LÍQUIDA (1-2)
								'04.001',	-- CUSTO DOS PRODUTOS VENDIDOS (CMV)
								'04.005',	-- CUSTO DAS DEVOLUÇÕES DE VENDAS (CMV)
								'04.006'	-- IMPOSTOS

								)
group by filial, MES, ANO
order by filial, 6

GO
-- 07.001  (=) RESULTADO OPERACIONAL (6-(7+8+9)) ----------------------------------------------------------------------------------------
INSERT INTO AC_DRE_RESULT 
select
	Filial,
	MES,
	ANO,
	'0' as Sinal,
	'07 - ==========================================================' AS TIPO,
	'07.999.999 - RESULTADO OPERACIONAL (6-(7+8+9))' AS HIERARQUIA,	 	
	sum(valor) AS Valor
from AC_DRE_RESULT
where left (HIERARQUIA,6) in (
								'05.999',	-- LUCRO BRUTO (3-(4-5))
								'06.001',	-- DESPESAS VARIÁVEIS COM VENDAS
								'06.002',	-- DESPESAS VARIÁVEIS FIXAS VENDAS
								'06.003'	-- DESPESAS ADMINISTRATICAS
								)
								AND ANO = 2018 AND MES = 2
group by filial, MES, ANO
order by filial, 6
GO
-- 	'08.001.999 - DESPESAS FINANCEIRAS' ----------------------------------------------------------------------------------------
INSERT INTO AC_DRE_RESULT 
select
	Filial,
	MES,
	ANO,
	'0' as Sinal,
	'08 - ==========================================================' AS TIPO,
	'08.001.999 - DESPESAS FINANCEIRAS' AS HIERARQUIA,	 	
	sum(valor) AS Valor
from AC_DRE_RESULT
where left (HIERARQUIA,6) in (
								'08.001'	-- DESPESAS FINANCEIRAS
								)
group by filial, MES, ANO
order by filial, 6
GO
-- 	'08.002.999 - DESPESAS FINANCEIRAS' ----------------------------------------------------------------------------------------
INSERT INTO AC_DRE_RESULT 
select
	Filial,
	MES,
	ANO,
	'0' as Sinal,
	'08 - ==========================================================' AS TIPO,
	'08.002.999 - RECEITAS FINANCEIRAS' AS HIERARQUIA,	 	
	sum(valor) AS Valor
from AC_DRE_RESULT
where LEFT(HIERARQUIA,6) in (
								'08.002'	-- DESPESAS FINANCEIRAS
								)
group by filial, MES, ANO
order by filial, 6
GO
-- 	'09.999 - OUTRAS RECEITAS E DESPESAS' ----------------------------------------------------------------------------------------
INSERT INTO AC_DRE_RESULT 
select
	Filial,
	MES,
	ANO,
	'0' as Sinal,
	'09 - ==========================================================' AS TIPO,
	'09.999.999 - OUTRAS RECEITAS E DESPESAS' AS HIERARQUIA,	 	
	sum(valor) AS Valor
from AC_DRE_RESULT
where LEFT(HIERARQUIA,2) in (
								'09'	-- OUTRAS RECEITAS E DESPESAS
								)
group by filial, MES, ANO
order by filial, 6
GO

-- 	'10.999 - RESULTADO ANTES DO IRPJ' ----------------------------------------------------------------------------------------
INSERT INTO AC_DRE_RESULT 
select
	Filial,
	MES,
	ANO,
	'0' as Sinal,
	'10 - ==========================================================' AS TIPO,
	'10.999 - RESULTADO ANTES DO IRPJ' AS HIERARQUIA,	 	
	sum(valor) AS Valor
from AC_DRE_RESULT
where LEFT(HIERARQUIA,10) in (
								'07.999.999', -- RESULTADO OPERACIONAL (6-(7+8+9))
								'08.001.999', -- DESPESAS FINANCEIRAS
								'08.002.999', -- RECEITAS FINANCEIRAS
								'09.999.999'  -- OUTRAS RECEITAS E DESPESAS
								)
group by filial, MES, ANO
order by filial, 6
GO
-- 	'11.999 - RESULTADO LIQUIDO' ----------------------------------------------------------------------------------------
INSERT INTO AC_DRE_RESULT 
select
	Filial,
	MES,
	ANO,
	'0' as Sinal,
	'11 - ==========================================================' AS TIPO,
	'11.999 - RESULTADO LIQUIDO' AS HIERARQUIA,	 	
	sum(valor) AS Valor
from AC_DRE_RESULT
where LEFT(HIERARQUIA,2) in (
								'10' -- RESULTADO ANTES DO IRPJ E SUBGRUPO
								)
group by filial, MES, ANO
order by filial, 6
GO
-- 	'12.999 - ATIVIDADES DE INVESTIMENTO' ----------------------------------------------------------------------------------------
INSERT INTO AC_DRE_RESULT 
select
	Filial,
	MES,
	ANO,
	'0' as Sinal,
	'12 - ==========================================================' AS TIPO,
	'12.999 - ATIVIDADES DE INVESTIMENTO' AS HIERARQUIA,	 	
	sum(valor) AS Valor
from AC_DRE_RESULT
where LEFT(HIERARQUIA,2) in (
								'12' -- ATIVIDADES DE INVESTIMENTO
							)

group by filial, MES, ANO
order by filial, 6

GO

-- 	'13.999 - ATIVIDADES DE FINANCIAMENTO' ----------------------------------------------------------------------------------------
INSERT INTO AC_DRE_RESULT 
select
	Filial,
	MES,
	ANO,
	'0' as Sinal,
	'13 - ==========================================================' AS TIPO,
	'13.999 - ATIVIDADES DE FINANCIAMENTO' AS HIERARQUIA,	 	
	sum(valor) AS Valor
from AC_DRE_RESULT
where LEFT(HIERARQUIA,2) in (
								'13' -- ATIVIDADES DE INVESTIMENTO
							)

group by filial, MES, ANO
order by filial, 6

GO

-- 	'14.999 - MOVIMENTAÇÃO DOS SÓCIOS' ----------------------------------------------------------------------------------------
INSERT INTO AC_DRE_RESULT 
select
	Filial,
	MES,
	ANO,
	'0' as Sinal,
	'14 - ==========================================================' AS TIPO,
	'14.999 - MOVIMENTAÇÃO DOS SÓCIOS' AS HIERARQUIA,	 	
	sum(valor) AS Valor
from AC_DRE_RESULT
where LEFT(HIERARQUIA,2) in (
								'14' -- ATIVIDADES DE INVESTIMENTO
							)

group by filial, MES, ANO
order by filial, 6
GO

-- 	'15.999 - RESULTADO FINAL' ----------------------------------------------------------------------------------------
INSERT INTO AC_DRE_RESULT 
select
	Filial,
	MES,
	ANO,
	'0' as Sinal,
	'15 - ==========================================================' AS TIPO,
	'15.999 - RESULTADO FINAL' AS HIERARQUIA,	 	
	sum(valor) AS Valor
from AC_DRE_RESULT
where LEFT(HIERARQUIA,6) in (
								'11.999', -- RESULTADO LIQUIDO
								'12.999', -- ATIVIDADES DE INVESTIMENTO
								'13.999', -- ATIVIDADES DE FINANCIAMENTO
								'14.999'  -- MOVIMENTAÇÃO DOS SÓCIOS
							)

group by filial, MES, ANO
order by filial, 6


------ Limpar o cache
----------------------------------------------------------------------------
GO
DROP TABLE #tmpDRE_Vendas
DROP TABLE #tmpDRE_Vendas_itens
DROP TABLE #tmpDRE_Constrular_Email
DROP TABLE #tempRateio
GO



