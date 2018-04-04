
--ALTER PROCEDURE [dbo].[uspEnviaDREAConstrular]
--as
IF object_id('tempdb..#tmp_DRE_Contrular') IS NOT NULL DROP TABLE #tmp_DRE_Contrular
IF object_id('tempdb..#tmp_DRE_Contrular_itens') IS NOT NULL DROP TABLE #tmp_DRE_Contrular_itens
IF object_id('tempdb..#tmp_DRE_Contrular_Email') IS NOT NULL DROP TABLE #tmp_DRE_Contrular_Email

-------------------------------------------------------------------------------
-- Apuração Venda a Vista
-- Venda "A Vista" Com pedido, NÃO considera Administradora de Cartões
-------------------------------------------------------------------------------
select 
	'PD'						as [Origem],
	pre.item					as [Codigo],
	ped.numped					as [Referencia],
	ven.dtven					as [Data],
	'+'							as [Sinal],
	'01 - Receita Bruta'		as [Tipo],
	'A Vista C/ Pedido'			as [Operacao],
	'01.01 - Vendas a Vista'	as [Hierarquia],
	pre.filial					as [Filial], 
	pre.valprev					as [Valor]
into #tmp_DRE_Contrular
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
	'PD'						as [Origem],
	pre.item					as [Codigo],
	ped.numped					as [Referencia],
	ven.dtven					as [Data],
	'+'							as [Sinal],
	'01 - Receita Bruta'		as [Tipo],
	'A Prazo'					as [Operacao],
	'01.02 - Vendas a Prazo'	as [Hierarquia],
	pre.filial					as [Filial], 
	pre.valprev					as [Valor]
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
	'PD'						as [Origem],
	pre.item					as [Codigo],
	ped.numped					as [Referencia],
	ven.dtven					as [Data],
	'+'							as [Sinal],
	'01 - Receita Bruta'		as [Tipo],
	'Cartão C/Pedido'			as [Operacao],
	'01.03 - Vendas com Cartão' as [Hierarquia],
	pre.filial					as [Filial],
	pre.valprev					as [Valor]
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
	'NF'						as [Origem],
	lc.IDLANCHEC				as [Codigo],
	nf.numord					as [Referencia],
	nf.dtemis					as [Data],
	'+'							as [Sinal],
	'01 - Receita Bruta'		as [Tipo],
	'Cartão S/Pedido'			as [Operacao],
	'01.03 - Vendas com Cartão' as [Hierarquia],
	Lc.filial					as [Filial],
	lc.vallanc					as [Valor]
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
	'NF'						as [Origem],
	lc.IDLANCHEC				as [Codigo],
	nf.numord					as [Referencia],
	nf.dtemis					as [Data],
	'+'							as [Sinal],
	'01 - Receita Bruta'		as [Tipo], 
	'A Vista S/ Pedido'			as [Operacao],
	'01.01 - Vendas a Vista'	as [Hierarquia],
	Lc.filial					as [Filial],
	lc.vallanc					as [Valor]
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
	'DESC'								as [Origem], -- [D]esconto concedidos no recebimento
	PAGTO.OID							as [Codigo],
	PAGTO.OID							as [Referencia],
	ATO.DATA							as [Data],
	'-'									as [Sinal],
	'02 - Deduções de Vendas'			as [Tipo], 
	'Descontos'							as [Operacao],
	'02.01 - Descontos Concedidos'		as [Hierarquia],
	FILIAL.CODIGO						as FILIAL,
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
	AND CATEGORIA.RSUPER = 2337
	AND ATO.RTIPO IN ( 2718 ) 
	AND ATO.RESTORNO = 7 
	AND PAGTO.RMOEDA = 113702  

-- 02.01 - Descontos Concedidos
UNION ALL SELECT
	DISTINCT 
	'DESC'								as [Origem], -- [D]esconto concedidos no recebimento
	PAGTO.OID							as [Codigo],
	PAGTO.OID							as [Referencia],
	ATO.DATA							as [Data],
	'-'									as [Sinal],
	'02 - Deduções de Vendas'			as [Tipo], 
	'Descontos'							as [Operacao],
	'02.01 - Descontos Concedidos'		as [Hierarquia],
	FILIAL.CODIGO						as FILIAL,
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
	'-'									as [Sinal],
	'02 - Deduções de Vendas'			as [Tipo], 
	'Devoluções'						as [Operacao],
	'02.02 - Devoluções de Vendas'		as [Hierarquia],
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
	'-'									as [Sinal],
	'02 - Deduções de Vendas'			as [Tipo], 
	'Devoluções'						as [Operacao],
	'02.02 - Devoluções de Vendas'		as [Hierarquia],
	nfe.filial							as [Filial],
	nfe.valcontab						as [Valor]
	from nfentracad nfe	join itnfentcad ite on nfe.numord = ite.numord
where 
	left(nfe.tpo,1)= 6
	and nfe.atualiz = 1
	and nfe.dtcancel is null
	and ite.numorddev <= 7

-- 2 - Deduções da Venda
--------------------------------------------------------------------------------
UNION ALL SELECT --	'2' AS ORIGEM,
	'DDV'							as [Origem], -- [D]eduções [D]a [V]enda
	PG.OID							as [Codigo],
	PG.OID							as [Referencia],
	AT.DATA							as [Data],
	'-'								as [Sinal],
	'02 - Deduções da Venda'		as [Tipo], 
	'Deduções da Venda'				as [Operacao],
	CASE 
		WHEN CONTA.RTPO = 6021891 THEN '02.03 - ' + T.NOME --2.3
		WHEN CONTA.RTPO = 25384195 THEN '02.03 - ' + T.NOME --2.3

	ELSE 'Nivel 2 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END as [Valor]
FROM  
	PAGAMENTO PG, 
	CONTAAPAGAR_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT,
	TPO_R T,
	PESSOA_R FILIAL
WHERE 
	CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.RTPO = T.OID
	AND FILIAL.OID = CONTA.RDESTINATARIO
	AND CONTA.OID = AF.RCONTA 
	AND AF.OID = PG.RACAOFINANCEIRA
	AND AF.RATOFINANCEIRO = AT.OID 
	AND AT.RTIPO IN  ( 2372, 23709, 23724 ) 
	AND NOT ( AT.RTIPO = 23724 
	AND CONTA.RTIPO = 23669 )
	AND AT.RESTORNO = 7 
	AND PG.RTIPO = CAT.OID  
	AND CONTA.RMOEDA1 = 113702 
	AND CONTA.RDESTINATARIO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND CONTA.RTPO in (

		6021891, -- 02.03 - Aquisição de Serviço Tributado ISSQN
		25384195 -- 02.03 - Aquisição de Serviço Tributado ISSQN (Aproveita Crédito Pis e Cofins)

		)

UNION ALL SELECT --	'3' AS ORIGEM,
	'DESC'								as [Origem], -- [D]esconto concedidos
	PG.OID							as [Codigo],
	PG.OID							as [Referencia],
	AT.DATA							as [Data],
	'-'								as [Sinal],
	'02 - Deduções da Venda'		as [Tipo], 
	'Deduções da Venda'				as [Operacao],
	CASE 
		WHEN CONTA.RTPO = 29846882 THEN '02.01 - ' + T.NOME --7.7
	ELSE 'Nivel 2 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END as [Valor]
FROM  
	PAGAMENTO PG, 
	CONTAARECEBER_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT,
	TPO_R T,
	PESSOA_R filial
WHERE CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.RTPO = T.OID
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
	AND CONTA.RTPO in (

		29846882	-- 02.01 - Desconto Concedido

	)

---------------------------------------------------------------------------------------------------------------------------
-- Apuração dos Impostos
-- 4 - Impostos S/ Vendas
---------------------------------------------------------------------------------------------------------------------------
UNION ALL SELECT
	DISTINCT
	'IMP'								as [Origem], -- [I]mpostos
	PG.OID								as [Codigo],
	conta.RDOCDEORIGEM					as [Referencia],
	AT.DATA								as [Data],
	'-'									as [Sinal],
	'04 - Receitas Líquida'				as [Tipo], 
	'Impostos S/ Vendas'				as [Operacao],
	CASE 
		WHEN CONTA.RTPO = 2663712 THEN '04.01 - Simples Nacional'
		WHEN CONTA.RTPO = 2663795 THEN '04.02 - ICMS'
		WHEN CONTA.RTPO = 2673459 THEN '04.03 - IRPJ'
		WHEN CONTA.RTPO = 2673423 THEN '04.04 - CSSL'
		WHEN CONTA.RTPO = 2300534 THEN '04.05 - PIS'
		WHEN CONTA.RTPO = 2300537 THEN '04.06 - COFINS'
		WHEN CONTA.RTPO = 6021891 THEN '04.07 - ISSQN'
	ELSE 'Imposto Nivel 4 Indeterminado' + TPO_R.NOME
	end									as [Hierarquia],
	FIL.CODIGO							as [Filial],
	PG.VALOR							as [Valor]
FROM  
	PAGAMENTO PG, 
	CONTAAPAGAR_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT, 
	TPO_R,
	PESSOA_R FIL
WHERE 
	CONTA.RSITUACAO IN ( 2346, 2347 )
	AND FIL.OID = CONTA.RDESTINATARIO
	AND CONTA.RTPO = TPO_R.OID
	AND CONTA.OID = AF.RCONTA 
	AND AF.OID = PG.RACAOFINANCEIRA
	AND AF.RATOFINANCEIRO = AT.OID 
	AND AT.RTIPO IN  ( 2372, 23709, 23724 ) 
	AND NOT ( AT.RTIPO = 23724	AND CONTA.RTIPO = 23669 )
	AND AT.RESTORNO = 7 
	AND PG.RTIPO = CAT.OID   
	AND CONTA.RMOEDA1 = 113702 
	AND CONTA.RDESTINATARIO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND CONTA.RTPO IN (
						2663712, --Simples Nacional
						2663795, --ICMS
						2673459, --IRPJ
						2673423, --CSSL
						2300534, --PIS
						2300537, --COFINS
						85202590 --ISSQN
						)

-- 5 - Custos Fixos
--------------------------------------------------------------------------------
UNION ALL SELECT --	'1' AS ORIGEM,
	'CUF'								as [Origem], -- [C]usto [F]Fixo
	FATOFINANCEIRO_R.OID				as [Codigo],
	FATOFINANCEIRO_R.RATOFINANCEIRO 	as [Referencia],
	FATOFINANCEIRO_R.DATA				as [Data],
	'+'									as [Sinal],
	'05 - Custos'						as [Tipo], 
	'05.09 - Custos Fixos'				as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 2673443 THEN '05.09.03 - ' + T.NOME	--05.9.3

	ELSE 'Nivel 5 Indeterminado - ' + T.NOME
	end									as [Hierarquia],
	FILIAL.CODIGO						as [Filial],
	FATOFINANCEIRO_R.VALOR/**FATOFINANCEIRO_R.SINAL*/ AS VALOR
FROM 
	FATOFINANCEIRO_R, 
	CAIXABANCARIA,
	TPO_R T,
	PESSOA_R FILIAL
	
WHERE FATOFINANCEIRO_R.RFONTEPAGADORA = CAIXABANCARIA.OID
	AND T.OID =  FATOFINANCEIRO_R.RTPO
	AND FILIAL.OID = CAIXABANCARIA.RITEM
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND NOT EXISTS ( SELECT 1 FROM UTILIZACAO U WHERE U.RITEM = FATOFINANCEIRO_R.OID )  
	AND CAIXABANCARIA.RITEM IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND FATOFINANCEIRO_R.RTPO in (
	
		2673443				-- 05.09.03 - Recisão e Indenizacao Trabalhista

	)

UNION ALL SELECT --	'2' AS ORIGEM,
	'CUF'								as [Origem], -- [C]usto [F]Fixo
	PG.OID								as [Codigo],
	PG.OID								as [Referencia],
	AT.DATA				as [Data],
	'+'									as [Sinal],
	'05 - Custos'						as [Tipo], 
	'05.09 - Custos Fixos'				as [Operacao],
	CASE 

		WHEN CONTA.RTPO = 2694938 THEN '05.09.01 - ' + T.NOME	--05.9.1
		WHEN CONTA.RTPO = 2673449 THEN '05.09.03 - ' + T.NOME	--05.9.3
		WHEN CONTA.RTPO = 2673443 THEN '05.09.03 - ' + T.NOME	--05.9.3

	ELSE 'Nivel 5 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END as [Valor]
	

FROM  
	PAGAMENTO PG, 
	CONTAAPAGAR_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT,
	TPO_R T,
	PESSOA_R FILIAL
WHERE 
	CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.RTPO = T.OID
	AND FILIAL.OID = CONTA.RDESTINATARIO
	AND CONTA.OID = AF.RCONTA 
	AND AF.OID = PG.RACAOFINANCEIRA
	AND AF.RATOFINANCEIRO = AT.OID 
	AND AT.RTIPO IN  ( 2372, 23709, 23724 ) 
	AND NOT ( AT.RTIPO = 23724 
	AND CONTA.RTIPO = 23669 )
	AND AT.RESTORNO = 7 
	AND PG.RTIPO = CAT.OID  
	AND CONTA.RMOEDA1 = 113702 
	AND CONTA.RDESTINATARIO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND CONTA.RTPO in (

		2694938, --05.09.01 - Mão de Obra
		2673449, -- 05.09.03 - Multas Recisorias
		2673443 -- 05.09.03 - Recisão e Indenizacao Trabalhista.
		)

-- 7 - Despesas Variáveis com Vendas
--------------------------------------------------------------------------------
UNION ALL SELECT -- '1' AS ORIGEM,
	'DVV'							as [Origem], -- [D]espesas [V]ariáveis com [V]endas
	FATOFINANCEIRO_R.OID			as [Codigo],
	FATOFINANCEIRO_R.RATOFINANCEIRO as [Referencia],
	FATOFINANCEIRO_R.DATA			as [Data],
	'-'								as [Sinal],
	'07 - Despesas Variáveis com Vendas' as [Tipo], 
	'Despesas Variáveis com Vendas'		as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 2300498 THEN '07.08 - ' + T.NOME --7.1
		WHEN FATOFINANCEIRO_R.RTPO = 2709379 THEN '07.08 - ' + T.NOME --7.1
		WHEN FATOFINANCEIRO_R.RTPO = 2714265 THEN '07.06 - ' + T.NOME --7.6
		WHEN FATOFINANCEIRO_R.RTPO = 2670454 THEN '07.09 - ' + T.NOME	--07.09
		WHEN FATOFINANCEIRO_R.RTPO = 2714246 THEN '07.10 - ' + T.NOME	--09.20
		WHEN FATOFINANCEIRO_R.RTPO = 2673408 THEN '07.10 - ' + T.NOME	--07.10
	
	ELSE 'Nivel 7 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	FATOFINANCEIRO_R.VALOR/**FATOFINANCEIRO_R.SINAL*/ AS VALOR
------------------------------------
FROM 
	FATOFINANCEIRO_R, 
	CAIXABANCARIA,
	TPO_R T,
	PESSOA_R FILIAL
	
WHERE FATOFINANCEIRO_R.RFONTEPAGADORA = CAIXABANCARIA.OID
	AND T.OID =  FATOFINANCEIRO_R.RTPO
	AND FILIAL.OID = CAIXABANCARIA.RITEM
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND NOT EXISTS ( SELECT 1 FROM UTILIZACAO U WHERE U.RITEM = FATOFINANCEIRO_R.OID )  
	AND CAIXABANCARIA.RITEM IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND FATOFINANCEIRO_R.RTPO in (
		2300498,				-- 07.08 - Comissões
		2709379,				-- 07.08 - Comissões
		2714265,				-- 07.06 - Comissões de Indicadores
		2670454,				-- 07.09 - DESPESA COM BOLETO
		2714246, 2673408		-- 07.09 - Despesas c/ Refeicoes
	)

UNION ALL SELECT --'2' AS ORIGEM,
	'DVV'							as [Origem], -- [D]espesas [V]ariáveis com [V]endas
	PG.OID							as [Codigo],
	PG.OID							as [Referencia],
	AT.DATA							as [Data],
	'-'								as [Sinal],
	'07 - Despesas Variáveis com Vendas' as [Tipo], 
	'Despesas Variáveis com Vendas'		as [Operacao],
	CASE 
		WHEN CONTA.RTPO = 2300498 THEN '07.08 - ' + T.NOME --7.1
		WHEN CONTA.RTPO = 2670454 THEN '07.09 - ' + T.NOME	--07.09
		WHEN CONTA.RTPO = 2673408 THEN '07.10 - ' + T.NOME	--07.10
	ELSE 'Nivel 7 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END as [Valor]
	

FROM  
	PAGAMENTO PG, 
	CONTAAPAGAR_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT,
	TPO_R T,
	PESSOA_R FILIAL
WHERE 
	CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.RTPO = T.OID
	AND FILIAL.OID = CONTA.RDESTINATARIO
	AND CONTA.OID = AF.RCONTA 
	AND AF.OID = PG.RACAOFINANCEIRA
	AND AF.RATOFINANCEIRO = AT.OID 
	AND AT.RTIPO IN  ( 2372, 23709, 23724 ) 
	AND NOT ( AT.RTIPO = 23724 
	AND CONTA.RTIPO = 23669 )
	AND AT.RESTORNO = 7 
	AND PG.RTIPO = CAT.OID  
	AND CONTA.RMOEDA1 = 113702 
	AND CONTA.RDESTINATARIO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND CONTA.RTPO in (
		2300498, --	07.08 - Comissões
		2670454, -- 07.09 - DESPESA COM BOLETO
		2673408 -- 07.10 - Despesas c/ Refeicoes
		)
UNION ALL SELECT --	'3' AS ORIGEM,
	'DVV'							as [Origem], -- [D]espesas [V]ariáveis com [V]endas
	PG.OID							as [Codigo],
	PG.OID							as [Referencia],
	AT.DATA							as [Data],
	'-'								as [Sinal],
	'07 - Despesas Variáveis com Vendas' as [Tipo], 
	'Despesas Variáveis com Vendas'		as [Operacao],
	CASE 
		WHEN CONTA.RTPO = 9397590 THEN '07.07 - ' + T.NOME --7.7
	ELSE 'Nivel 7 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END as [Valor]
FROM  
	PAGAMENTO PG, 
	CONTAARECEBER_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT,
	TPO_R T,
	PESSOA_R filial
WHERE CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.RTPO = T.OID
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
	AND CONTA.RTPO in (

		9397590	-- 07.07 - Brindes para Indicadores
	)


-- 9 - Despesas Administrativas
--------------------------------------------------------------------------------
UNION ALL SELECT --'1' AS ORIGEM,
	'DEA'							as [Origem], -- [D]espesas [A]dministrativas
	FATOFINANCEIRO_R.OID			as [Codigo],
	FATOFINANCEIRO_R.RATOFINANCEIRO as [Referencia],
	FATOFINANCEIRO_R.DATA			as [Data],
	'-'								as [Sinal],
	'09 - Despesas Administrativas' as [Tipo], 
	'Despesas Administrativas'		as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 4360902 THEN '09.03 - ' + T.NOME --9.14
		WHEN FATOFINANCEIRO_R.RTPO = 2683982 THEN '09.04 - ' + T.NOME --9.07
		WHEN FATOFINANCEIRO_R.RTPO = 2300486 THEN '09.06 - ' + T.NOME --9.20
		WHEN FATOFINANCEIRO_R.RTPO = 2714271 THEN '09.06 - ' + T.NOME --9.20
		WHEN FATOFINANCEIRO_R.RTPO = 2300495 THEN '09.08 - ' + T.NOME	--09.1
		WHEN FATOFINANCEIRO_R.RTPO = 2714240 THEN '09.11 - ' + T.NOME	--09.20
		WHEN FATOFINANCEIRO_R.RTPO = 2673406 THEN '09.11 - ' + T.NOME	--09.20
		WHEN FATOFINANCEIRO_R.RTPO = 2357841 THEN '09.12 - ' + T.NOME	--09.22
		WHEN FATOFINANCEIRO_R.RTPO = 2300489 THEN '09.19 - ' + T.NOME	--09.8
		WHEN FATOFINANCEIRO_R.RTPO = 2683987 THEN '09.19 - ' + T.NOME	--09.8
		WHEN FATOFINANCEIRO_R.RTPO = 324856885 THEN '09.20 - ' + T.NOME	--09.11
		WHEN FATOFINANCEIRO_R.RTPO = 2672734 THEN '09.20 - ' + T.NOME	--09.11
		WHEN FATOFINANCEIRO_R.RTPO = 2670460 THEN '09.22 - ' + T.NOME	--13.01
		WHEN FATOFINANCEIRO_R.RTPO = 2713130 THEN '09.23 - ' + T.NOME	--09.18
	ELSE 'Nivel 9 Indeterminado - ' + T.NOME
	end													as [Hierarquia],
	FILIAL.CODIGO										as [Filial],
	FATOFINANCEIRO_R.VALOR/**FATOFINANCEIRO_R.SINAL*/	as [Valor]
------------------------------------
FROM 
	FATOFINANCEIRO_R, 
	CAIXABANCARIA,
	TPO_R T,
	PESSOA_R FILIAL
	
WHERE FATOFINANCEIRO_R.RFONTEPAGADORA = CAIXABANCARIA.OID
	AND T.OID =  FATOFINANCEIRO_R.RTPO
	AND FILIAL.OID = CAIXABANCARIA.RITEM
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND NOT EXISTS ( SELECT 1 FROM UTILIZACAO U WHERE U.RITEM = FATOFINANCEIRO_R.OID )  
	AND CAIXABANCARIA.RITEM IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND FATOFINANCEIRO_R.RTPO in (
		4360902,				-- 09.03 - Alex
		2683982,				-- 09.04 - Aluguel Projetado
		2300486, 2714271,		-- 09.06 - Cartório
		2300495,				-- 09.08 - Salários
		2714240, 2673406,		-- 09.11 - Correios e SEDEX
		2357841,				-- 09.12 - Despesas de Viagem/Serviço
		2300489,2683987,		-- 09.19 - Materiais de Cozinha e Limpeza
		324856885,2672734,		-- 09.20 - Material de Escritorio
		2670460,				-- 09.22 - Patrocínio
		2713130					-- 09.23 - Peças
	)

UNION ALL SELECT --'2' AS ORIGEM,
	'DEA'							as [Origem], -- [D]espesas [A]dministrativas
	PG.OID							as [Codigo],
	PG.OID							as [Referencia],
	AT.DATA							as [Data],
	'-'								as [Sinal],
	'09 - Despesas Administrativas' as [Tipo], 
	'Despesas Administrativas'		as [Operacao],
	CASE 
		WHEN CONTA.RTPO = 2300474 THEN '09.01 - ' + T.NOME --9.10
		WHEN CONTA.RTPO = 2727274 THEN '09.02 - ' + T.NOME --9.07
		WHEN CONTA.RTPO = 4360902 THEN '09.03 - ' + T.NOME --9.14
		WHEN CONTA.RTPO = 6021891 THEN '02.03 - ' + T.NOME --2.3
		WHEN CONTA.RTPO = 25384195 THEN '02.03 - ' + T.NOME --2.3
		WHEN CONTA.RTPO = 2673414 THEN '09.05 - ' + T.NOME --9.16
		WHEN CONTA.RTPO = 5289599 THEN '09.07 - ' + T.NOME -- 9.18
		WHEN CONTA.RTPO = 2676721 THEN '09.09 - ' + T.NOME -- 9.11
		WHEN CONTA.RTPO = 2672745 THEN '09.10 - ' + T.NOME -- 9.18
		WHEN CONTA.RTPO = 5403690 THEN '09.13 - ' + T.NOME	--09.24
		WHEN CONTA.RTPO = 2300477 THEN '09.14 - ' + T.NOME	--09.10
		WHEN CONTA.RTPO = 2300501 THEN '09.15 - ' + T.NOME	--09.10
		WHEN CONTA.RTPO = 2672782 THEN '09.16 - ' + T.NOME	--09.10
		WHEN CONTA.RTPO = 2300459 THEN '09.17 - (Retiradas Alex) ' + T.NOME	--09.14
		WHEN CONTA.RTPO = 49530894 THEN '09.18 - ' + T.NOME	--09.12
		WHEN CONTA.RTPO = 4390595 THEN '09.18 - ' + T.NOME	--09.12
		WHEN CONTA.RTPO = 2300489 THEN '09.19 - ' + T.NOME	--09.8
		WHEN CONTA.RTPO = 148309741 THEN '09.20 - ' + T.NOME	--09.11
		WHEN CONTA.RTPO = 2672762 THEN '09.21 - ' + T.NOME	--09.18
		WHEN CONTA.RTPO = 2670460 THEN '09.22 - ' + T.NOME	--13.01
		WHEN CONTA.RTPO = 2672764 THEN '09.10 - ' + T.NOME	--09.18
		WHEN CONTA.RTPO = 2300483 THEN '09.24 - ' + T.NOME	--09.13
		WHEN CONTA.RTPO = 2300480 THEN '09.24 - ' + T.NOME	--09.13
		WHEN CONTA.RTPO = 2300453 THEN '09.10 - ' + T.NOME	--09.18
		WHEN CONTA.RTPO = 2713984 THEN '09.25 - ' + T.NOME	--09.18
		

	ELSE 'Nivel 9 Indeterminado - ' + T.NOME
	end															as [Hierarquia],
	FILIAL.CODIGO												as [Filial],
	CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END	as [Valor]

FROM  
	PAGAMENTO PG, 
	CONTAAPAGAR_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT,
	TPO_R T,
	PESSOA_R FILIAL
WHERE 
	CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.RTPO = T.OID
	AND FILIAL.OID = CONTA.RDESTINATARIO
	AND CONTA.OID = AF.RCONTA 
	AND AF.OID = PG.RACAOFINANCEIRA
	AND AF.RATOFINANCEIRO = AT.OID 
	AND AT.RTIPO IN  ( 2372, 23709, 23724 ) 
	AND NOT ( AT.RTIPO = 23724 
	AND CONTA.RTIPO = 23669 )
	AND AT.RESTORNO = 7 
	AND PG.RTIPO = CAT.OID  
	AND CONTA.RMOEDA1 = 113702 
	AND CONTA.RDESTINATARIO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND CONTA.RTPO in (
		2300474, -- 09.01 - Água / Esgoto
		2727274, -- 09.02 - Aluguel
		4360902, -- 09.03 - Alex
		2673414, -- 09.05 - Associacoes Diversas
		5289599, -- 09.07 - Compra de Combustiveís
		2676721, -- 09.09 - COMPRA DE MATERIAL P/ USO CONSUMO
		2672745, -- 09.10 - Compra de Peças p/ Veiculos
		5403690, --	09.13 - Despesas Diversos e Atestados Médicos
		2300477, -- 09.14 - Energia Elétrica
		2300501, -- 09.15 - Férias
		2672782, -- 09.16 - Honorarios Contabeis
		2300459, -- 09.17 - Imóveis (Retiradas
		49530894, 4390595, -- 09.18 - Manutenção de Informática (Hardware)
		2300489, -- 09.19 - Materiais de Cozinha e Limpeza
		148309741, -- 09.20 - Material de Escritorio
		2672762, -- 09.21 - Multas de Transito
		2670460, -- 09.22 - Patrocínio
		2672764, -- 09.10 - Seguro de Veiculos
		2300483, 2300480, -- 09.24 - Telefone Celular, 09.24 - Telefone Fixo
		2300453, -- 09.10 - Veículos
		2713984	-- 09.10 - IPVA
		)

UNION ALL SELECT --'3' AS ORIGEM,
	'DEA'							as [Origem], -- [D]espesas [A]dministrativas
	PG.OID							as [Codigo],
	PG.OID							as [Referencia],
	AT.DATA							as [Data],
	'-'								as [Sinal],
	'09 - Despesas Administrativas' as [Tipo], 
	'Despesas Administrativas'		as [Operacao],
	CASE 
		WHEN CONTA.RTPO = 5403690 THEN '09.13 - ' + T.NOME	--09.24
	ELSE 'Nivel 9 Indeterminado - ' + T.NOME
	end															as [Hierarquia],
	FILIAL.CODIGO												as [Filial],
	CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END	as [Valor]
FROM  
	PAGAMENTO PG, 
	CONTAARECEBER_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT,
	TPO_R T,
	PESSOA_R filial
WHERE CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.RTPO = T.OID
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
	AND CONTA.RTPO in (

		5403690	-- 09.13 - Despesas Diversos e Atestados Médicos
	)

UNION ALL SELECT --'4' AS ORIGEM,
	'DEA'							as [Origem], -- [D]espesas [A]dministrativas
	FATOFINANCEIRO_R.OID			as [Codigo],
	FATOFINANCEIRO_R.RATOFINANCEIRO as [Referencia],
	FATOFINANCEIRO_R.DATA			as [Data],
	'-'								as [Sinal],
	'09 - Despesas Administrativas' as [Tipo], 
	'Despesas Administrativas'		as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 2300495	THEN '09.08 - ' + T.NOME	--09.1
	ELSE 'Nivel 4 Indeterminado - ' + T.NOME
	end													as [Hierarquia],
	FILIAL.CODIGO										as [Filial],
	FATOFINANCEIRO_R.VALOR/**FATOFINANCEIRO_R.SINAL*/	AS [Valor]
FROM 
	FATOFINANCEIRO_R, UTILIZACAO U, TPO_R T, PESSOA_R FILIAL
WHERE FATOFINANCEIRO_R.OID = U.RITEM
	AND FILIAL.OID =  U.RUTILIZADO
	AND FATOFINANCEIRO_R.RTPO = T.OID
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND U.RUTILIZADO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND FATOFINANCEIRO_R.RTPO IN (
		2300495		-- 09.08 - Salários
	)
--------------------------------------------------------------------------------
-- 11 - Despesas Financeiras
--------------------------------------------------------------------------------
UNION ALL SELECT -- '1' AS ORIGEM,
	'DEF'							as [Origem], -- [D]espesas [F]inanceiras
	FATOFINANCEIRO_R.OID			as [Codigo],
	FATOFINANCEIRO_R.RATOFINANCEIRO as [Referencia],
	FATOFINANCEIRO_R.DATA			as [Data],
	'-'								as [Sinal],
	'11 - Despesas Financeiras' as [Tipo], 
	'Despesas Financeiras'		as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 2670451 THEN '11.07 - ' + T.NOME	--11.01
	ELSE 'Nivel 9 Indeterminado - ' + T.NOME
	end													as [Hierarquia],
	FILIAL.CODIGO										as [Filial],
	FATOFINANCEIRO_R.VALOR/**FATOFINANCEIRO_R.SINAL*/	AS VALOR
------------------------------------
FROM 
	FATOFINANCEIRO_R, 
	CAIXABANCARIA,
	TPO_R T,
	PESSOA_R FILIAL
	
WHERE FATOFINANCEIRO_R.RFONTEPAGADORA = CAIXABANCARIA.OID
	AND T.OID =  FATOFINANCEIRO_R.RTPO
	AND FILIAL.OID = CAIXABANCARIA.RITEM
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND NOT EXISTS ( SELECT 1 FROM UTILIZACAO U WHERE U.RITEM = FATOFINANCEIRO_R.OID )  
	AND CAIXABANCARIA.RITEM IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND FATOFINANCEIRO_R.RTPO in (
		2670451				-- 11.07 - MANUTENÇÃO CONTA
		
	)

UNION ALL SELECT --'4', 
	'DEF'							as [Origem], -- [D]espesas [F]inanceiras
	FATOFINANCEIRO_R.OID			as [Codigo],
	FATOFINANCEIRO_R.RATOFINANCEIRO as [Referencia],
	FATOFINANCEIRO_R.DATA			as [Data],
	'-'								as [Sinal],
	'11 - Despesas Financeiras' as [Tipo], 
	'Despesas Financeiras'		as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 154201517	THEN '11.01 - ' + T.NOME --11.6
		WHEN FATOFINANCEIRO_R.RTPO = 252479014	THEN '11.02 - ' + T.NOME --11.6
		WHEN FATOFINANCEIRO_R.RTPO = 154260629	THEN '11.03 - ' + T.NOME --11.6
		WHEN FATOFINANCEIRO_R.RTPO = 259379944	THEN '11.04 - ' + T.NOME --11.6
		WHEN FATOFINANCEIRO_R.RTPO = 2318047	THEN '11.05 - ' + T.NOME	--11.6
		WHEN FATOFINANCEIRO_R.RTPO = 2318050	THEN '11.06 - ' + T.NOME	--11.6
		WHEN FATOFINANCEIRO_R.RTPO = 2318536	THEN '11.07 - ' + T.NOME --11.6
		WHEN FATOFINANCEIRO_R.RTPO = 4191965	THEN '11.08 - ' + T.NOME --11.6
		WHEN FATOFINANCEIRO_R.RTPO = 154260645	THEN '11.09 - ' + T.NOME	--11.6
		WHEN FATOFINANCEIRO_R.RTPO = 164202804	THEN '11.10 - ' + T.NOME	--11.6
	ELSE 'Nivel 4 Indeterminado - ' + T.NOME
	end										as [Hierarquia],
	FILIAL.CODIGO							as [Filial],
	FATOFINANCEIRO_R.VALOR/**FATOFINANCEIRO_R.SINAL*/ AS VALOR
FROM 
	FATOFINANCEIRO_R, UTILIZACAO U, TPO_R T, PESSOA_R FILIAL
WHERE FATOFINANCEIRO_R.OID = U.RITEM
	AND FILIAL.OID =  U.RUTILIZADO
	AND FATOFINANCEIRO_R.RTPO = T.OID
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND U.RUTILIZADO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND FATOFINANCEIRO_R.RTPO IN (
		154201517,	-- Comissão Amex
		252479014,	-- Comissão BIGCARD
		154260629,	-- Comissão Cabal
		259379944,	-- COMISSÃO GMINAS
		2318047,	-- Comissão Mastercard
		2318050,	-- Comissão Visa
		2318536,	-- Comissão CDC Banco do Brasil
		4191965,	-- Comissão Construcard
		154260645,	-- Comissão BNDS
		164202804 	-- Comissão Cresol
	)

UNION ALL SELECT
	'DEF'							as [Origem], -- [D]espesas [F]inanceiras
	FATOFINANCEIRO_R.OID			as [Codigo],
	FATOFINANCEIRO_R.RATOFINANCEIRO as [Referencia],
	FATOFINANCEIRO_R.DATA			as [Data],
	'-'								as [Sinal],
	'11 - Despesas Financeiras'		as [Tipo], 
	'Financeiras'					as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 7985517 THEN '11.01 - ' + TPO_R.NOME
		WHEN FATOFINANCEIRO_R.RTPO = 2300513 THEN '11.03 - ' + TPO_R.NOME
		WHEN FATOFINANCEIRO_R.RTPO = 2300516 THEN '11.05 - ' + TPO_R.NOME
		
	ELSE 'Nivel 11 Indeterminado - ' + TPO_R.NOME
	end as [Hierarquia],
	FILIAL.CODIGO					as [Filial],
	FATOFINANCEIRO_R.VALOR*FATOFINANCEIRO_R.SINAL as [Valor]

FROM 
	FATOFINANCEIRO_R, CAIXABANCARIA, TPO_R, PESSOA_R FILIAL
WHERE 
	FILIAL.OID = CAIXABANCARIA.RITEM
	AND FATOFINANCEIRO_R.RFONTEPAGADORA = CAIXABANCARIA.OID
	AND TPO_R.OID =  FATOFINANCEIRO_R.RTPO
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND NOT EXISTS ( SELECT 1 FROM UTILIZACAO U WHERE U.RITEM = FATOFINANCEIRO_R.OID )  
	AND CAIXABANCARIA.RITEM IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	and FATOFINANCEIRO_R.RTPO in (
			7985517, -- Tarifas Bancárias
			2300513, -- Juros Bancários
			2300516  -- IOF
	)

--------------------------------------------------------------------------------
-- 12 - Receitas Financeiras
-- Juros Recebidos
--------------------------------------------------------------------------------
UNION ALL SELECT
	'REF'							as [Origem], -- [R]eceitas [F]inanceiras
	FATOFINANCEIRO_R.OID			as [Codigo],
	FATOFINANCEIRO_R.RATOFINANCEIRO as [Referencia],
	FATOFINANCEIRO_R.DATA			as [Data],
	'+'								as [Sinal],
	'12 - Receitas Financeiras'		as [Tipo], 
	'Financeiras'					as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 173798490 THEN '12.01 - ' + TPO_R.NOME
	ELSE 'Nivel 12 Indeterminado - ' + TPO_R.NOME
	end as [Hierarquia],
	FILIAL.CODIGO					as [Filial],
	FATOFINANCEIRO_R.VALOR*FATOFINANCEIRO_R.SINAL	as [Valor]

FROM 
	FATOFINANCEIRO_R, CAIXABANCARIA, TPO_R, PESSOA_R FILIAL
WHERE 
	FILIAL.OID = CAIXABANCARIA.RITEM
	AND FATOFINANCEIRO_R.RFONTEPAGADORA = CAIXABANCARIA.OID
	AND TPO_R.OID =  FATOFINANCEIRO_R.RTPO
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND NOT EXISTS ( SELECT 1 FROM UTILIZACAO U WHERE U.RITEM = FATOFINANCEIRO_R.OID )  
	AND CAIXABANCARIA.RITEM IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	and FATOFINANCEIRO_R.RTPO in (
			173798490 -- Juros Recebidos
	)

-- Apuração dos Encargos:
-----------------------------------------------------------------------------------------------------
UNION ALL SELECT
	DISTINCT
	'ENC'								as [Origem], -- [E]ncargos
	PAGTO.OID							as [Codigo],
	conta.RDOCDEORIGEM					as [Referencia],
	ATO.DATA							as [Data],
	'+'									as [Sinal],
	'12 - Receitas Financeiras'			as [Tipo], 
	'Encargos'							as [Operacao],
	'12.01 - Encargos RECEBIMENTO'		as [Hierarquia],
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
	'+'									as [Sinal],
	'12 - Receitas Financeiras'			as [Tipo], 
	'Encargos'							as [Operacao],
	'12.01 - Encargos'					as [Hierarquia],
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
-- Aplicações-------------------------------------------------------
UNION ALL SELECT -- '1' AS ORIGEM,
	'APC'								as [Origem], -- [A]plicações
	FATOFINANCEIRO_R.OID				as [Codigo],
	FATOFINANCEIRO_R.RATOFINANCEIRO 	as [Referencia],
	FATOFINANCEIRO_R.DATA				as [Data],
	'+' 								as [Sinal],
	'12 - Receitas Financeiras' 		as [Tipo], 
	'Aplicações' 						as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 9093199 THEN '12.04 - ' + T.NOME --12.4

	ELSE 'Nivel 12 Indeterminado - ' + T.NOME
	end									as [Hierarquia],
	FILIAL.CODIGO						as [Filial],
	FATOFINANCEIRO_R.VALOR/**FATOFINANCEIRO_R.SINAL*/ AS VALOR
------------------------------------
FROM 
	FATOFINANCEIRO_R, 
	CAIXABANCARIA,
	TPO_R T,
	PESSOA_R FILIAL
	
WHERE FATOFINANCEIRO_R.RFONTEPAGADORA = CAIXABANCARIA.OID
	AND T.OID =  FATOFINANCEIRO_R.RTPO
	AND FILIAL.OID = CAIXABANCARIA.RITEM
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND NOT EXISTS ( SELECT 1 FROM UTILIZACAO U WHERE U.RITEM = FATOFINANCEIRO_R.OID )  
	AND CAIXABANCARIA.RITEM IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND FATOFINANCEIRO_R.RTPO in (
		9093199				-- 12.04 - Aplicações Financeiras
	)

UNION ALL SELECT --	'2' AS ORIGEM,
	'APC'								as [Origem], -- [A]plicações
	PG.OID								as [Codigo],
	PG.OID 								as [Referencia],
	AT.DATA								as [Data],
	'+' 								as [Sinal],
	'12 - Receitas Financeiras' 		as [Tipo], 
	'Aplicações' 						as [Operacao],
	CASE 
		WHEN CONTA.RTPO = 2679697 THEN '12.04 - ' + T.NOME --12.3

	ELSE 'Nivel 12 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END as [Valor]
	

FROM  
	PAGAMENTO PG, 
	CONTAAPAGAR_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT,
	TPO_R T,
	PESSOA_R FILIAL
WHERE 
	CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.RTPO = T.OID
	AND FILIAL.OID = CONTA.RDESTINATARIO
	AND CONTA.OID = AF.RCONTA 
	AND AF.OID = PG.RACAOFINANCEIRA
	AND AF.RATOFINANCEIRO = AT.OID 
	AND AT.RTIPO IN  ( 2372, 23709, 23724 ) 
	AND NOT ( AT.RTIPO = 23724 
	AND CONTA.RTIPO = 23669 )
	AND AT.RESTORNO = 7 
	AND PG.RTIPO = CAT.OID  
	AND CONTA.RMOEDA1 = 113702 
	AND CONTA.RDESTINATARIO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND CONTA.RTPO in (
		2679697 -- 12.03 - Aplicações
		
		)
-- Adiantamento-------------------------------------------------------
UNION ALL SELECT --	'3' AS ORIGEM,
	'ADC'								as [Origem], -- [A]diantamento [C]Cliente
	PG.OID								as [Codigo],
	PG.OID 								as [Referencia],
	AT.DATA								as [Data],
	'+' 								as [Sinal],
	'12 - Receitas Financeiras' 		as [Tipo], 
	'Receitas Financeiras' 				as [Operacao],
	CASE 
		WHEN CONTA.RTPO = 4945191 THEN '12.03 - ' + T.NOME --12.03
	
	ELSE 'Nivel 9 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END as [Valor]
FROM  
	PAGAMENTO PG, 
	CONTAARECEBER_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT,
	TPO_R T,
	PESSOA_R filial
WHERE CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.RTPO = T.OID
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
	AND CONTA.RTPO in (

		4945191	-- 12.03 - Adiantamento Cliente

	)


-- 13 - Outras Receitas e Despesas
--------------------------------------------------------------------------------
UNION ALL SELECT --	'1' AS ORIGEM,
	'ORNO'								as [Origem], -- [O]utras [R]eceitas [N]ão [O]Operacionais
	FATOFINANCEIRO_R.OID				as [Codigo],
	FATOFINANCEIRO_R.RATOFINANCEIRO 	as [Referencia],
	FATOFINANCEIRO_R.DATA				as [Data],
	'+' 								as [Sinal],
	'13 - Outras Receitas e Despesas' 	as [Tipo], 
	'Receitas não operacionais' 		as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 29844075 THEN '13.03 - ' + T.NOME	--13.01

	ELSE 'Nivel 13 Indeterminado - ' + T.NOME
	end									as [Hierarquia],
	FILIAL.CODIGO						as [Filial],
	FATOFINANCEIRO_R.VALOR/**FATOFINANCEIRO_R.SINAL*/ AS VALOR

------------------------------------
FROM 
	FATOFINANCEIRO_R, 
	CAIXABANCARIA,
	TPO_R T,
	PESSOA_R FILIAL
	
WHERE FATOFINANCEIRO_R.RFONTEPAGADORA = CAIXABANCARIA.OID
	AND T.OID =  FATOFINANCEIRO_R.RTPO
	AND FILIAL.OID = CAIXABANCARIA.RITEM
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND NOT EXISTS ( SELECT 1 FROM UTILIZACAO U WHERE U.RITEM = FATOFINANCEIRO_R.OID )  
	AND CAIXABANCARIA.RITEM IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND FATOFINANCEIRO_R.RTPO in (
		29844075				-- 13.03 - Outras Receitas não Operacionais
	)

UNION ALL SELECT --	'3' AS ORIGEM,
	'ORNO'								as [Origem], -- [O]utras [R]eceitas [N]ão [O]Operacionais
	PG.OID								as [Codigo],
	PG.OID								as [Referencia],
	AT.DATA								as [Data],
	'+' 								as [Sinal],
	'13 - Outras Receitas e Despesas' 	as [Tipo], 
	'Receitas não operacionais' 		as [Operacao],
	CASE 
		WHEN CONTA.RTPO = 142402891 THEN '13.01 - ' + T.NOME --13.01
		WHEN CONTA.RTPO = 2356845 THEN '13.02 - ' + T.NOME --13.02
		WHEN CONTA.RTPO = 29844075 THEN '13.03 - ' + T.NOME	--13.01

	ELSE 'Nivel 13 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END as [Valor]
FROM  
	PAGAMENTO PG, 
	CONTAARECEBER_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT,
	TPO_R T,
	PESSOA_R filial
WHERE CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.RTPO = T.OID
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
	AND CONTA.RTPO in (
		142402891,	-- 13.01 - Aluguéis Recebidos
		2356845,	-- 13.02 - Cheque Devolvido Receita
		29844075   -- 13.03 - Outras Receitas não Operacionais

	)

-- 16 - Atividade de Investimento
--------------------------------------------------------------------------------
UNION ALL SELECT 	-- '2' AS ORIGEM,
	'ATI'								as [Origem], -- [A]tividade de [I]nvestimento
	PG.OID								as [Codigo],
	PG.OID								as [Referencia],
	AT.DATA								as [Data],
	'-'									as [Sinal],
	'16 - Atividade de Investimento'	as [Tipo], 
	'Investimento'						as [Operacao],	
	CASE 
		WHEN CONTA.RTPO = 4427400 THEN '16.01 - ' + T.NOME --16.1

	ELSE 'Nivel 16 Indeterminado - ' + T.NOME
	end									as [Hierarquia],
	FILIAL.CODIGO						as [Filial],
	CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END as [Valor]
FROM  
	PAGAMENTO PG, 
	CONTAAPAGAR_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT,
	TPO_R T,
	PESSOA_R FILIAL
WHERE 
	CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.RTPO = T.OID
	AND FILIAL.OID = CONTA.RDESTINATARIO
	AND CONTA.OID = AF.RCONTA 
	AND AF.OID = PG.RACAOFINANCEIRA
	AND AF.RATOFINANCEIRO = AT.OID 
	AND AT.RTIPO IN  ( 2372, 23709, 23724 ) 
	AND NOT ( AT.RTIPO = 23724 
	AND CONTA.RTIPO = 23669 )
	AND AT.RESTORNO = 7 
	AND PG.RTIPO = CAT.OID  
	AND CONTA.RMOEDA1 = 113702 
	AND CONTA.RDESTINATARIO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND CONTA.RTPO in (

		4427400 -- 16.01 - Armazém Centro Manhumirim
		)

-------------------------------------------------------------------------------
-- CUSTO DOS ITENS ------------------------------------------------------------
-- Venda com Pedido
-------------------------------------------------------------------------------
select
	'CMCP'							as [Origem], -- [C]usto das [M]ercadorias [C]om [P]edido
	'0'								as [Codigo],
	PED.NUMPED						as [Referencia],
	ven.dtven						as [Data],
	'-'								as [Sinal],
	'05 - Custo Mercadoria'			as [Tipo],
	'Custo Mercadoria Vendida'		as [Operacao],
	'05.01 - CMV Produtos Vendidos'					as [Hierarquia],
	ped.filial						as [Filial], 
    SUM(PROD.PRECOCOMP*ITPD.QUANT)	as Valor
	into #tmp_DRE_Contrular_itens	-- Povoa o custo dos itens 
from 
	pediclicad ped 
	join vendasscad ven on ven.numped = ped.numped
	join itemclicad itpd on itpd.numped = ped.numped
	join produtocad prod on itpd.codpro = prod.codpro
where
	ped.numped = (select distinct tmpVenda.Referencia 
						from #tmp_DRE_Contrular tmpVenda
						where tmpVenda.Origem = 'PD' 
							and tmpVenda.Referencia = ped.numped)
GROUP BY 
	PED.NUMPED,	ven.dtven,	ped.filial	

-- Venda sem Pedido
-------------------------------------------------------------------------------
UNION ALL SELECT 
	'CMSP'								as [Origem], -- [C]usto das [M]ercadorias [S]em [P]edido
	'0'									as [Codigo],
	NF.NUMORD							as [Referencia],
	nf.dtemis							as [Data],
	'-'									as [Sinal],
	'05 - Custo Mercadoria'				as [Tipo],
	'Custo Mercadoria Vendida'			as [Operacao],
	'05.01 - CMV Produtos Vendidos'	as [Hierarquia],
	nf.filial							as [Filial],
    SUM(ITNF.QUANT*PROD.PRECOCOMP)		as Valor
from 
	nfsaidacad nf 
	join itnfsaicad itnf on itnf.numord = nf.numord
	join produtocad prod on itnf.codpro = prod.codpro
where
	nf.numord = (select distinct tmpVenda.Referencia 
						from #tmp_DRE_Contrular tmpVenda
						where tmpVenda.Origem = 'NF' 
							and tmpVenda.Referencia = nf.numord)
GROUP BY 
	NF.NUMORD, nf.dtemis, nf.filial

	-- Devolução de venda
-------------------------------------------------------------------------------
UNION ALL SELECT
	'CDV'								as [Origem], -- [C]usto das [D]evolução de [V]enda
	'0'									as [Codigo],
	NF.NUMORD							as [Referencia],
	nf.dtcheg							as [Data],
	'-'									as [Sinal],
	'05 - Custo Mercadoria'				as [Tipo],
	'Custo das Devoluções de Vendas'	as [Operacao],
	'05.02 - CMV Devoluções Vendas'	as [Hierarquia],
	nf.filial							as [Filial],
    SUM(ITNF.QUANT*PROD.PRECOCOMP)		as Valor
from 
	NFENTRACAD NF 
	join ITNFENTCAD itnf on itnf.numord = nf.numord
	join produtocad prod on itnf.codpro = prod.codpro
where
	nf.numord = (select distinct tmpDev.Referencia
						from #tmp_DRE_Contrular tmpDev
						where tmpDev.Origem = 'DEV' 
							and tmpDev.Referencia = nf.numord)
GROUP BY 
	NF.NUMORD, nf.dtcheg, nf.filial
--------------------------------------------------------------------------------------------
-- Conversão para tabela
--------------------------------------------------------------------------------------------
select * into #tmp_DRE_Contrular_Email
	from #tmp_DRE_Contrular
UNION ALL 
select * 
	from #tmp_DRE_Contrular_itens


--------------------------------------------------------------------------------------------
DECLARE @tableHTML  NVARCHAR(MAX), @subjectMSG NVARCHAR(MAX), @dataInicial VARCHAR(MAX),@dataFim VARCHAR(MAX) 

SET @dataInicial = (select convert (varchar,GETDATE()- 31,103))
set @dataFim = (select convert (varchar,GETDATE()- 1,103)) + ' 23:59:59'
SET @subjectMSG = 'DRE referente período: '
set @subjectMSG = @subjectMSG +  + @dataInicial +' até ' + @dataFim

SET @tableHTML =
		N'<head>
		<style type="text/css">
			.alert{
				background-color: #b9c9fe;
				padding: 15px;
				color: #039;
			}
			#box-table
			{
			font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
			font-size: 12px;
			text-align: left;
			border-collapse: collapse;
			border-top: 7px solid #9baff1;
			border-bottom: 7px solid #9baff1;
			}
			#box-table th
			{
			font-size: 13px;
			font-weight: normal;
			background: #b9c9fe;
			border-right: 2px solid #9baff1;
			border-left: 2px solid #9baff1;
			border-bottom: 2px solid #9baff1;
			color: #039;
			}
			#box-table td
			{
			border-right: 1px solid #aabcfe;
			border-left: 1px solid #aabcfe;
			border-bottom: 1px solid #aabcfe;
			padding: 4px;
			color: #039;
			}

			table > tbody > td:last-child {
				text-align: center;
			}

			#box-table >tr:nth-child(odd) { background-color:black; }
			#box-table >tr:nth-child(even) { background-color:red; } 
		</style>
	</head>
	
    <table  id="box-table">
	 <thead>
	 <tr>
		 <th colspan="6" class="alert">
			Demonstrativo de Resultado Empresa Aconstrular
			 <br> Perído: '	+ @dataInicial + ' até ' + @dataFim +' <br> Data de Emissão: ' +  convert(varchar,GETDATE(),104) +
	 + N'</th>
	 </tr>
		<tr>
			<th>Filial</th>
			<th>Tipo</th>
			<th>Sinal</th>
			<th>Hierarquia</th>
			<th>Valor</th>
		</tr>
	 </thead>
	 <tbody>' +
    CAST ( ( 
			select 
				 td = Filial, '',
				 td = Tipo,'',
				 td = Sinal, '',	
				 td = Hierarquia, '', 
				 td = cast(sum(valor) as decimal(15,2))
			from #tmp_DRE_Contrular_Email 
			where 
				filial = '01' and 
				data between @dataInicial and @dataFim
			group by 
				Tipo, Hierarquia, Sinal, filial
			order by filial, Hierarquia

              FOR XML PATH('tr'), TYPE   
    ) AS NVARCHAR(MAX) ) +  
    N'
	</table> 
	</tbody> ' ;   

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'DBEmail Tobias',  
    @recipients = 'tobiasitin@gmail.com',  
	--@copy_recipients = 'infoaconstrular@gmail.com',
	--@copy_recipients = 'alexaconstrular@gmail.com',
    @subject = @subjectMSG,  
	@body =  @tableHTML, 
	@body_format='HTML'; 
	
GO


-- Limpar o cache
------------------------------------------------------------------------
DROP TABLE #tmp_DRE_Contrular
DROP TABLE #tmp_DRE_Contrular_itens
DROP TABLE #tmp_DRE_Contrular_Email

GO


