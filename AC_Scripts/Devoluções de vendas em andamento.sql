-- Devoluções:
-----------------------------------------------------------------------------------------------------
-- Devolução com vínculo com a nota de venda
-------------------------------------------------------------------------------
drop table #tmp_DRE_Deducoes_de_Vendas
select
	distinct 
	nfe.numord as [Codigo],
	nfe.dtcheg as [Data],
	'2 - Deduções de Vendas' as [Tipo], 
	'Devoluções' as [Operacao],
	'2.2 - Devoluções de Vendas' [Hierarquia],
	case 
		when nfs.numped is null or nfs.numped < 7 then nfs.filial  -- Se não tiver pedido na venda pega da prória nota de saida
		when ven.numped is null or nfs.numped <= 7 then nfs.filial -- Se tiver pedido na venda pega da prória nota de saida
	else ven.filial end as [Filial], -- Se tiver numped pega da venda
	nfe.valcontab as [Valor]
	into #tmp_DRE_Deducoes_de_Vendas
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
	'2 - Deduções de Vendas' as [Tipo], 
	'Devoluções' as [Operacao],
	'2.2 - Devoluções de Vendas' [Hierarquia],
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
	and nfe.dtcheg between '20180201' and '20180228'

-- Listar DRE
------------------------------------------------------
select Tipo, Hierarquia, filial, sum(valor) as Valor
from #tmp_DRE_Deducoes_de_Vendas
where data between '20180201' and '20180228' --and filial = '01'
group by Tipo, Hierarquia, filial
order by Filial
