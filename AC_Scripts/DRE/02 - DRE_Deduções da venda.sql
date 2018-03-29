-- Separação da venda A Vista / Cartão / A Prazo
----------------------------------------------------------------

IF object_id('tempdb..#tmp_DRE_Contrular') IS NOT NULL 
DROP TABLE #tmp_DRE_Contrular
---------------------------------------------------------------------------------------------------------------------------
-- Apuração das Deduções de Vendas
-- Descontos Concedidos no recebimento 
-- Devoluções de vendas
-- 2 - Deduções de Vendas
---------------------------------------------------------------------------------------------------------------------------
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
	into #tmp_DRE_Contrular
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
-----------------------------------------------------------------------------------------------------
-- Devoluções:
-- Devolução com vínculo com a nota de venda
-----------------------------------------------------------------------------------------------------
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

	
-- Listar 
------------------------------------------------------
select 
	--filial, 
	Tipo,Sinal, Hierarquia,  sum(valor) as Valor
from #tmp_DRE_Contrular
where 
	filial = '01' and 
	data between '20180226' and '20180328 23:59:59' 
group by 	
	Tipo, Hierarquia, Sinal
	--filial
order by Hierarquia

