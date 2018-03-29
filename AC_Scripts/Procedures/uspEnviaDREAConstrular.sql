
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
union select
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
union select
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
union select 
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
union select 
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
UNION SELECT 
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
UNION 
SELECT 
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
Union select
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
Union select
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



---------------------------------------------------------------------------------------------------------------------------
-- Apuração dos Impostos
-- 4 - Impostos S/ Vendas
---------------------------------------------------------------------------------------------------------------------------
UNION SELECT 
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
-- 11 - Despesas Financeiras
--------------------------------------------------------------------------------
union SELECT 
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
union select 
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
UNION select 
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

--------------------------------------------------------------------------------
-- 12 - Receitas Financeiras
-- Juros Recebidos
--------------------------------------------------------------------------------
UNION SELECT 
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
UNION SELECT 
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

UNION SELECT 
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
--------------------------------------------------------------------------------------------
-- Conversão para tabela
--------------------------------------------------------------------------------------------
select * into #tmp_DRE_Contrular_Email
	from #tmp_DRE_Contrular
union
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
				filial = '01'
				and data between @dataInicial and @dataFim
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


