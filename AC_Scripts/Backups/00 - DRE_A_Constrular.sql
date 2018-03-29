-- Separação da venda A Vista / Cartão / A Prazo
----------------------------------------------------------------

IF object_id('tempdb..#tmp_DRE_Contrular') IS NOT NULL 
DROP TABLE #tmp_DRE_Contrular

-- Apuração Venda a Vista
-- Venda "A Vista" sem pedido, não considera administradora de cartões
-- 1 - Receita Bruta
-------------------------------------------------------------------------------
select 
	nf.numord as [Codigo],
	nf.dtemis as [Data],
	'+' as [Sinal],
	'01 - Receita Bruta' as [Tipo], 
	'A Vista S/ Pedido' as [Operacao],
	'01.01 - Vendas a Vista' [Hierarquia],
	Lc.filial as [Filial],
	lc.vallanc as Valor 
into #tmp_DRE_Contrular
from nfsaidacad nf 
	join LANCHECCXA lc on nf.numord = lc.numord
	join item doc on doc.oid=lc.documen
	where nf.numped in(0,7) 
		and left(nf.tpo,1)=2
		and nf.atualiz = 1
		and nf.flagemit = 1
		and nf.dtcancel is null
		and lc.documen not in (select oid from ADMINISTRADORA_R) -- Não considerar a venda com cartão

-- Venda "A Vista" Com pedido, não considera administradora de cartões
-------------------------------------------------------------------------------
union  select 
	ped.numped as [Codigo],
	ven.dtven as [Data],
	'+' as [Sinal],
	'01 - Receita Bruta' as [Tipo],
	'A Vista C/ Pedido' as [Operacao],
	'01.01 - Vendas a Vista' as [Hierarquia],
	pre.filial as [Filial], 
	pre.valprev as Valor
from pediclicad ped 
		join prevclicad pre on ped.numped = pre.numped
		join item fp on ped.rformadepagar = fp.oid
		join item doc on doc.oid=pre.tipodoc
		join vendasscad ven on ven.numped = ped.numped
where sitven = '2'
		and pre.tipopar in (0,1) 
		and pre.tipodoc not in (17763)

-- Apuração Venda a Prazo
-- Venda a Prazo
--------------------------------
union select
	ped.numped as [Codigo],
	ven.dtven as [Data],
	'+' as [Sinal],
	'01 - Receita Bruta' as [Tipo],
	'A Prazo' as [Operacao],
	'01.02 - Vendas a Prazo' as [Hierarquia],
	pre.filial as [Filial], 
	pre.valprev as Valor
from pediclicad ped 
		join prevclicad pre on ped.numped = pre.numped
		join item fp on ped.rformadepagar = fp.oid
		join item doc on doc.oid=pre.tipodoc
		join vendasscad ven on ven.numped = ped.numped
	where sitven = '2'
		and pre.tipopar = 2 and pre.tipodoc not in (17763)


-- Apuração venda com cartão
----------------------------------------------------------------------------------
union select
	ped.numped as [Codigo],
	ven.dtven as [Data],
	'+' as [Sinal],
	'01 - Receita Bruta' as [Tipo],
	'Cartão C/Pedido' as [Operacao],
	'01.03 - Vendas com Cartão' as [Hierarquia],
	pre.filial as [Filial],
	pre.valprev as Valor
from pediclicad ped 
		join prevclicad pre on ped.numped = pre.numped
		join item fp on ped.rformadepagar = fp.oid
		join item doc on doc.oid=pre.tipodoc
		join vendasscad ven on ven.numped = ped.numped
	where sitven = '2'
		and pre.tipodoc = 17763


-- Venda "A Vista" sem pedido, não considera administradora de cartões
-------------------------------------------------------------------------------
union select 
	nf.numord as [Codigo],
	nf.dtemis as [Data],
	'+' as [Sinal],
	'01 - Receita Bruta' as [Tipo],
	'Cartão S/Pedido' as [Operacao],
	'01.03 - Vendas com Cartão' as [Hierarquia],
	Lc.filial as [Filial],
	lc.vallanc as Valor
from nfsaidacad nf 
	join LANCHECCXA lc on nf.numord = lc.numord
	join item doc on doc.oid=lc.documen
	where nf.numped in(0,7) 
		and left(nf.tpo,1)=2
		and nf.atualiz = 1
		and nf.flagemit = 1
		and lc.documen in (select oid from ADMINISTRADORA_R)


---------------------------------------------------------------------------------------------------------------------------
-- Apuração das Deduções de Vendas
-- Descontos Concedidos no recebimento 
-- Devoluções de vendas
-- 2 - Deduções de Vendas
---------------------------------------------------------------------------------------------------------------------------
Union All
SELECT 
	DISTINCT 
	PAGTO.OID as [Codigo],
	ATO.DATA as [Data],
	'-' as [Sinal],
	'02 - Deduções de Vendas' as [Tipo], 
	'Descontos' as [Operacao],
	'02.01 - Descontos Concedidos' [Hierarquia],
	FILIAL.CODIGO AS FILIAL,
	PAGTO.VALOR as [Valor]
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
UNION ALL
SELECT 
	DISTINCT 
	PAGTO.OID as [Codigo],
	ATO.DATA as [Data],
	'-' as [Sinal],
	'02 - Deduções de Vendas' as [Tipo], 
	'Descontos' as [Operacao],
	'02.01 - Descontos Concedidos' [Hierarquia],
	FILIAL.CODIGO AS FILIAL,
	PAGTO.VALOR as [Valor]
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

-- Devoluções:
-----------------------------------------------------------------------------------------------------
-- Devolução com vínculo com a nota de venda
-------------------------------------------------------------------------------
Union ALL select
	distinct 
	nfe.numord as [Codigo],
	nfe.dtcheg as [Data],
	'-' as [Sinal],
	'02 - Deduções de Vendas' as [Tipo], 
	'Devoluções' as [Operacao],
	'02.02 - Devoluções de Vendas' [Hierarquia],
	case 
		when nfs.numped is null or nfs.numped < 7 then nfs.filial  -- Se não tiver pedido na venda pega da prória nota de saida
		when ven.numped is null or nfs.numped <= 7 then nfs.filial -- Se tiver pedido na venda pega da prória nota de saida
	else ven.filial end as [Filial], -- Se tiver numped pega da venda
	nfe.valcontab as [Valor]
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
Union ALl select
	distinct 
	nfe.numord as [Codigo],
	nfe.dtcheg as [Data],
	'-' as [Sinal],
	'02 - Deduções de Vendas' as [Tipo], 
	'Devoluções' as [Operacao],
	'02.02 - Devoluções de Vendas' [Hierarquia],
	nfe.filial as [Filial],
	nfe.valcontab as [Valor]
	from 
	nfentracad nfe
	join itnfentcad ite on nfe.numord = ite.numord
where 
	left(nfe.tpo,1)= 6
	and nfe.atualiz = 1
	and nfe.dtcancel is null
	and ite.numorddev <= 7

---------------------------------------------------------------------------------------------------------------------------
-- Apuração dos Impostos
-- 4 - Impostos S/ Vendas
---------------------------------------------------------------------------------------------------------------------------
UNION ALL SELECT 
DISTINCT
	PG.OID as [Codigo],
	AT.DATA as [Data],
	'-' as [Sinal],
	'04 - Receitas Líquida' as [Tipo], 
	'Impostos S/ Vendas' as [Operacao],
	CASE 
		WHEN CONTA.RTPO = 2663712 THEN '04.01 - Simples Nacional'
		WHEN CONTA.RTPO = 2663795 THEN '04.02 - ICMS'
		WHEN CONTA.RTPO = 2673459 THEN '04.03 - IRPJ'
		WHEN CONTA.RTPO = 2673423 THEN '04.04 - CSSL'
		WHEN CONTA.RTPO = 2300534 THEN '04.05 - PIS'
		WHEN CONTA.RTPO = 2300537 THEN '04.06 - COFINS'
		WHEN CONTA.RTPO = 6021891 THEN '04.07 - ISSQN'
	ELSE 'Imposto Nivel 4 Indeterminado' + TPO_R.NOME
	end as [Hierarquia],
	FIL.CODIGO as [Filial],
	PG.VALOR as [Valor]
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

/*
-- Apuração Custo dos Produtos Vendidos
-- 5.9 - Custos Fixos
--------------------------------------------------------------------------------
UNION ALL SELECT 
	FATOFINANCEIRO_R.OID as [Codigo],
	FATOFINANCEIRO_R.DATA as [Data],
	'+' as [Sinal],
	'05 - Custo dos Produtos Vendidos' as [Tipo], 
	'Custos Fixos' as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 2714175 THEN '5.09.01 - ' + TPO_R.NOME
	ELSE 'Imposto Nivel 5.9 Indeterminado'  + TPO_R.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	FATOFINANCEIRO_R.VALOR*FATOFINANCEIRO_R.SINAL as [Valor]
FROM 
	FATOFINANCEIRO_R, 
	CAIXABANCARIA, 
	TPO_R,
	PESSOA_R FILIAL 
WHERE 
	FATOFINANCEIRO_R.RFONTEPAGADORA = CAIXABANCARIA.OID
	AND FILIAL.OID = CAIXABANCARIA.RITEM
	AND TPO_R.OID =  FATOFINANCEIRO_R.RTPO
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND NOT EXISTS ( SELECT 1 FROM UTILIZACAO U WHERE U.RITEM = FATOFINANCEIRO_R.OID )  
	AND CAIXABANCARIA.RITEM IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	and FATOFINANCEIRO_R.RTPO in (
			2714175  -- Mão de Obra
	)

-- 7 - Despesas Variáveis com Vendas
--------------------------------------------------------------------------------
UNION ALL SELECT 
	FATOFINANCEIRO_R.OID as [Codigo],
	FATOFINANCEIRO_R.DATA as [Data],
	'-' as [Sinal],
	'07 - Despesas Variáveis com Vendas' as [Tipo], 
	'Variáveis com Vendas' as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 2709379 THEN '7.01 - ' + TPO_R.NOME
		WHEN FATOFINANCEIRO_R.RTPO = 2300498 THEN '7.02 - ' + TPO_R.NOME
		WHEN FATOFINANCEIRO_R.RTPO = 2714265 THEN '7.06 - ' + TPO_R.NOME
	
	ELSE 'Imposto Nivel 7 Indeterminado'  + TPO_R.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	FATOFINANCEIRO_R.VALOR*FATOFINANCEIRO_R.SINAL as [Valor]

FROM 
	FATOFINANCEIRO_R, CAIXABANCARIA, TPO_R, PESSOA_R FILIAL 
WHERE 
	FATOFINANCEIRO_R.RFONTEPAGADORA = CAIXABANCARIA.OID
	AND FILIAL.OID = CAIXABANCARIA.RITEM
	AND TPO_R.OID =  FATOFINANCEIRO_R.RTPO
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND NOT EXISTS ( SELECT 1 FROM UTILIZACAO U WHERE U.RITEM = FATOFINANCEIRO_R.OID )  
	AND CAIXABANCARIA.RITEM IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	and FATOFINANCEIRO_R.RTPO in (
			2709379,  -- Comissões
			2300498, -- Comissões
			2714265 -- Comissão de Indicadores			
	)

UNION ALL SELECT 
	FATOFINANCEIRO_R.OID as [Codigo],
	FATOFINANCEIRO_R.DATA as [Data],
	'-' as [Sinal],
	'09 - Despesas Administrativas' as [Tipo], 
	'Administrativas' as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 2714240 THEN '09.01 - ' + TPO_R.NOME
		--WHEN FATOFINANCEIRO_R.RTPO = 2714271 THEN '09.02 - ' + TPO_R.NOME
		--WHEN FATOFINANCEIRO_R.RTPO = 2714246 THEN '09.03 - ' + TPO_R.NOME
		--WHEN FATOFINANCEIRO_R.RTPO = 2672734 THEN '09.04 - ' + TPO_R.NOME
		--WHEN FATOFINANCEIRO_R.RTPO = 2683982 THEN '09.05 - ' + TPO_R.NOME
		--WHEN FATOFINANCEIRO_R.RTPO = 2683987 THEN '09.06 - ' + TPO_R.NOME
		--WHEN FATOFINANCEIRO_R.RTPO = 2300495 THEN '09.07 - ' + TPO_R.NOME
		--WHEN FATOFINANCEIRO_R.RTPO = 2300486 THEN '09.08 - ' + TPO_R.NOME
		--WHEN FATOFINANCEIRO_R.RTPO = 2300489 THEN '09.09 - ' + TPO_R.NOME
		--WHEN FATOFINANCEIRO_R.RTPO = 2673406 THEN '09.10 - ' + TPO_R.NOME
		--WHEN FATOFINANCEIRO_R.RTPO = 2673408 THEN '09.11 - ' + TPO_R.NOME
		--WHEN FATOFINANCEIRO_R.RTPO = 324856885 THEN '09.12 - ' + TPO_R.NOME
	ELSE 'Nivel 9 Indeterminado - ' + TPO_R.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
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
			2300474 -- 09.01 - Água / Esgoto
			--2714240, -- Correios e SEDEX
			--2714271, -- Cartório
			--2714246, -- Despesas com Refeições
			--2672734, -- Material de Escritorio
			--2683982, -- Aluguel Projetado
			--2683987, -- Material de Cozinha e Limpeza Projetado
			--2300495, -- Salários
			--2300486, -- Cartório
			--2300489, -- Materiais de Cozinha e Limpeza
			--2673406, -- Correios e SEDEX
			--2673408, -- Despesas c/ Refeicoes
			--324856885 -- Material de Escritório Projetado
	)

*/
-- 11 - Despesas Financeiras
--------------------------------------------------------------------------------
UNION ALL SELECT 
	FATOFINANCEIRO_R.OID as [Codigo],
	FATOFINANCEIRO_R.DATA as [Data],
	'-' as [Sinal],
	'11 - Despesas Financeiras' as [Tipo], 
	'Financeiras' as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 7985517 THEN '11.01 - ' + TPO_R.NOME
		WHEN FATOFINANCEIRO_R.RTPO = 2300513 THEN '11.03 - ' + TPO_R.NOME
		WHEN FATOFINANCEIRO_R.RTPO = 2300516 THEN '11.05 - ' + TPO_R.NOME
		
	ELSE 'Nivel 11 Indeterminado - ' + TPO_R.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
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
			2300516 --IOF
	)

-- 12 - Receitas Financeiras
--------------------------------------------------------------------------------
UNION ALL SELECT 

	FATOFINANCEIRO_R.OID as [Codigo],
	FATOFINANCEIRO_R.DATA as [Data],
	'+' as [Sinal],
	'12 - Receitas Financeiras' as [Tipo], 
	'Financeiras' as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 173798490 THEN '12.01 - ' + TPO_R.NOME
	ELSE 'Nivel 12 Indeterminado - ' + TPO_R.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
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
			173798490 -- Juros Recebidos
	)

-- Apuração dos Encargos:
-- 12 - Receitas Financeiras
-----------------------------------------------------------------------------------------------------
UNION ALL SELECT 
	DISTINCT
	PAGTO.OID as [Codigo],
	ATO.DATA as [Data],
	'+' as [Sinal],
	'12 - Receitas Financeiras' as [Tipo], 
	'Encargos' as [Operacao],
	'12.02 - Encargos RECEBIMENTO' [Hierarquia],
	FILIAL.CODIGO as [Filial],
	PAGTO.VALOR as [Valor]
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

UNION ALL SELECT 
	DISTINCT
	PAGTO.OID as [Codigo],
	ATO.DATA as [Data],
	'+' as [Sinal],
	'12 - Receitas Financeiras' as [Tipo], 
	'Encargos' as [Operacao],
	'12.01 - Encargos' [Hierarquia],
	FILIAL.CODIGO as [Filial],
	PAGTO.VALOR as [Valor]
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
	
-- Listar 
------------------------------------------------------
select 
	--filial, 
	Tipo,Sinal, Hierarquia,  sum(valor) as Valor
from #tmp_DRE_Contrular
where 
	filial = '01' and 
	data between '20180201' and '20180228 23:59:59' 
group by 	
	Tipo, Hierarquia, Sinal
	--filial
order by Hierarquia

