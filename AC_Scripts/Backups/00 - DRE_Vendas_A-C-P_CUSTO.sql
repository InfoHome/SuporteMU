USE BD01_DESENV
GO
IF object_id('tempdb..#tmp_DRE_Contrular') IS NOT NULL DROP TABLE #tmp_DRE_Contrular
IF object_id('tempdb..#tmp_DRE_Contrular_itens') IS NOT NULL DROP TABLE #tmp_DRE_Contrular_itens
-------------------------------------------------------------------------------
-- Apura��o Venda a Vista
-- Venda "A Vista" Com pedido, N�O considera Administradora de Cart�es
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
-- Apura��o Venda a Prazo
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
-- Apura��o venda com cart�o
-------------------------------------------------------------------------------
union select
	'PD'						as [Origem],
	pre.item					as [Codigo],
	ped.numped					as [Referencia],
	ven.dtven					as [Data],
	'+'							as [Sinal],
	'01 - Receita Bruta'		as [Tipo],
	'Cart�o C/Pedido'			as [Operacao],
	'01.03 - Vendas com Cart�o' as [Hierarquia],
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
-- Venda "A Vista" SEM pedido, N�O considera Administradora de Cart�es
-------------------------------------------------------------------------------
union select 
	'NF'						as [Origem],
	lc.IDLANCHEC				as [Codigo],
	nf.numord					as [Referencia],
	nf.dtemis					as [Data],
	'+'							as [Sinal],
	'01 - Receita Bruta'		as [Tipo],
	'Cart�o S/Pedido'			as [Operacao],
	'01.03 - Vendas com Cart�o' as [Hierarquia],
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


-- Venda "A Vista" sem pedido, n�o considera administradora de cart�es
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
		and lc.documen not in (select oid from ADMINISTRADORA_R) -- N�o considerar a venda com cart�o

-- CUSTO DOS ITENS ------------------------------------------------------------
-- Venda com Pedido
-------------------------------------------------------------------------------
select
	'CMCP'						as [Origem], -- [C]usto das [M]ercadorias [C]om [P]edido
	'0'							as [Codigo],
	PED.NUMPED					as [Referencia],
	ven.dtven					as [Data],
	'-'							as [Sinal],
	'05 - Custo Mercadoria'		as [Tipo],
	'Custo Mercadoria Vendida'	as [Operacao],
	'05.01 - CMV'				as [Hierarquia],
	ped.filial					as [Filial], 
    SUM(PROD.PRECOCOMP*ITPD.QUANT) as Valor
	into #tmp_DRE_Contrular_itens
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
	
-------------------------------------------------------------------------------
-- Venda sem Pedido
-------------------------------------------------------------------------------
union select 
	'CMSP'						as [Origem], -- [C]usto das [M]ercadorias [S]em [P]edido
	'0'							as [Codigo],
	NF.NUMORD					as [Referencia],
	nf.dtemis					as [Data],
	'-'							as [Sinal],
	'05 - Custo Mercadoria'		as [Tipo],
	'Custo Mercadoria Vendida'	as [Operacao],
	'05.01 - CMV'				as [Hierarquia],
	nf.filial					as [Filial],
    SUM(ITNF.QUANT*PROD.PRECOCOMP) as Valor
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


-- Listar Vendas --------------------------------------------------------------
-------------------------------------------------------------------------------
select 
	--filial, 
	Tipo,Sinal, Hierarquia,  cast(sum(valor) as decimal(15,4)) as Valor
from #tmp_DRE_Contrular where 
	filial = '01' and 
	data between '20180201' and '20180228 23:59:59' 
group by Tipo, Hierarquia, Sinal
	--filial
order by Hierarquia

-- Listar Custo das Vendas ----------------------------------------------------
-------------------------------------------------------------------------------
select 
	--filial, 
	Tipo,Sinal, Hierarquia,  cast(sum(valor) as decimal(15,4)) as Valor
from #tmp_DRE_Contrular_itens where 
	filial = '01' and 
	data between '20180201' and '20180228 23:59:59' 
group by Tipo, Hierarquia, Sinal
	--,filial
order by Hierarquia
-------------------------------------------------------------------------------
 



