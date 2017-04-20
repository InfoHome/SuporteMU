---------------------------------------------------------------------------------------------------------------
-- LIMPAR TABELAS TEMPORÁRIAS
------------------------------------------------------------------
IF object_id('tempdb..#Temp_CFO') IS NOT NULL DROP TABLE #Temp_CFO
IF object_id('tempdb..#Temp_items') IS NOT NULL DROP TABLE #Temp_items
IF object_id('tempdb..#Temp_items_Cupons') IS NOT NULL DROP TABLE #Temp_items_Cupons
------------------------------------------------------------------
-- INSERIR OS DADOS DA VENDA
---------------------------------------------------------------
declare  @pAtualiz char(1), @pLif char(1), @pfilial char(2), @pdtInicial datetime, @pdtFinal datetime

set @pfilial = '01'				-- Insira a Filial da venda
set @pdtInicial = '20170301'	-- Insira a Data inicial da venda
set @pdtFinal = '20170331'		-- Insira a Data Final da venda
set @pAtualiz = '1'				-- 1 = Nota Atualizada, 0 = Nota Não Atualizada
set @pLif = '1'					-- 1 = No Livro Fiscal, 0 = Fora Livro Fiscal

-- Apurar CFO das notas de saida
------------------------------------------------------------------------------------------------------------------------------------------------------------
select 
	n.numord,n.dtemis,n.modelonf, n.serie,n.lif,c.cfo, c.alqicm, sum(c.valicm) as valicm, sum(c.outricm) as outricm,	sum(c.valsemicm) as valsemicm
	Into #Temp_CFO
from cfosaidcad c join nfsaidacad n on c.numord = n.numord 	where n.dtemis >= @pdtInicial and n.dtemis <= @pdtFinal	
	and n.atualiz = @pAtualiz 
	and n.filial = @pfilial and len(c.cfo)=4 and n.dtcancel is null	
	group by n.numord,n.dtemis,n.modelonf,n.serie,n.lif,n.modelonf, c.cfo ,c.alqicm 
union 
select n.numord,n.dtemis,n.modelonf,n.serie,n.lif, c.cfo, c.alqicm2, sum(c.valicm2) as valicm, sum(c.outricm) as outricm, sum(c.valsemicm) as valsemicm
from cfosaidcad c join nfsaidacad n on c.numord = n.numord 	where n.dtemis >= @pdtInicial and n.dtemis <= @pdtFinal
	and n.atualiz = @pAtualiz 
	and n.filial = @pfilial and len(c.cfo)=4 and n.dtcancel is null	
	group by n.numord,n.dtemis,n.modelonf,n.serie,n.lif,c.cfo ,c.alqicm2
union 
select n.numord,n.dtemis,n.modelonf,n.serie,n.lif, c.cfo, c.alqicm3, sum(c.valicm3) as valicm, sum(c.outricm) as outricm, sum(c.valsemicm) as valsemicm
from cfosaidcad c join nfsaidacad n on c.numord = n.numord where n.dtemis >= @pdtInicial and n.dtemis <= @pdtFinal
	and n.atualiz = @pAtualiz 
	and n.filial = @pfilial and len(c.cfo)=4 and n.dtcancel is null	
	group by n.numord,n.dtemis,n.modelonf,n.serie,n.lif,c.cfo ,c.alqicm3 
union 
select n.numord,n.dtemis,n.modelonf,n.serie,n.lif, c.cfo, c.alqicm4, sum(c.valicm4) as valicm, sum(c.outricm) as outricm, sum(c.valsemicm) as valsemicm
from cfosaidcad c join nfsaidacad n on c.numord = n.numord where n.dtemis >= @pdtInicial and n.dtemis <= @pdtFinal
	and n.atualiz = @pAtualiz 
	and n.filial = @pfilial and len(c.cfo)=4 and n.dtcancel is null	
	group by n.numord,n.dtemis,n.modelonf,n.serie,n.lif,c.cfo ,c.alqicm4 
union 
select n.numord,n.dtemis,n.modelonf,n.serie,n.lif, c.cfo, c.alqicm5, sum(c.valicm5) as valicm, sum(c.outricm) as outricm, sum(c.valsemicm) as valsemicm
from cfosaidcad c join nfsaidacad n on c.numord = n.numord 	where n.dtemis >= @pdtInicial and n.dtemis <= @pdtFinal
	and n.atualiz = @pAtualiz 
	and n.filial = @pfilial and len(c.cfo)=4 and n.dtcancel is null	
	group by n.numord,n.dtemis,n.modelonf,n.serie,n.lif, c.cfo ,c.alqicm5 

-- Apurar itens das notas de saida
------------------------------------------------------------------------------------------------------------------------------------------------------------
select 
	i.numord,n.dtemis,n.modelonf, i.serie, n.lif,i.cfo,i.aliqicms,
	sum(((((i.quant * i.preco + i.valsubstri + i.quant * i.preco * (n.valfrete - desconto)/(n.valcontab - n.valsubstri - n.valfrete + n.desconto))* baseicms)/100)*aliqicms)/100) as ValicmItem
	into #Temp_items 
from itnfsaicad i, nfsaidacad n where n.dtemis >= @pdtInicial and n.dtemis <= @pdtFinal 
	and n.numord = i.numord 
	and n.atualiz = @pAtualiz 
	and n.filial = @pfilial 
group by i.numord,n.dtemis,i.cfo,n.modelonf,i.aliqicms, i.serie,n.lif



-- Consultas
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Consulta Sintética dos CFOPs
----------------------------------------
--NF
-----------
select 	
	cfo, sum(valicm) as valicm, 
	sum(outricm) as outricm, 
	sum(valsemicm) as valsemicm 
from #Temp_CFO where lif = 1 group by cfo

-- Cupom
-----------
select 	
	cfo, sum(valicm) as valicm, 
	sum(outricm) as outricm, 
	sum(valsemicm) as valsemicm 
from #Temp_CFO where lif = 0 group by cfo
---------------------------------------------------------------------
-- Consulta Analítica dos CFOPs
----------------------------------------
--NF
-----------
select 	
	cfo,	alqicm, 	sum(valicm) as valicm, 	sum(outricm) as outricm, 	sum(valsemicm) as valsemicm 
from #Temp_CFO 
where lif = 1 
and cfo = '5102'
group by cfo,alqicm order by CFO

-- Cupom
-----------
select 	
	cfo,	alqicm, 	sum(valicm) as valicm, 	sum(outricm) as outricm, 	sum(valsemicm) as valsemicm 
from #Temp_CFO 
where lif = 0 
and cfo = '5102'
group by cfo,alqicm order by CFO


-- Divergencia NF Itens com Totalizadores da Redução Z
---------------------------------------------------------------------------------------------------------
select
	c.numord, 
	c.cfo, c.alqicm,	sum(c.valicm) as valicm, 
	i.cfo as CFO_Item, i.aliqicms as AliqICMS_Item, sum(i.ValicmItem) as ValIcms_Item
	,sum(c.valicm)- sum(i.ValicmItem)
from #Temp_items i 
	join #Temp_CFO c on i.numord = c.numord and c.alqicm = i.aliqicms and c.cfo =i.cfo and  c.lif = i.lif
	--and i.cfo='5102' and alqicm = '18'
	and c.lif = 1
group by c.cfo,	c.alqicm,i.cfo,	i.aliqicms,c.numord --,i.ValicmItem	
having sum(c.valicm)- sum(i.ValicmItem) < -0.01 or  sum(c.valicm)- sum(i.ValicmItem) > 0.01


-- Divergencia Cupom Itens com Totalizadores da Redução Z
---------------------------------------------------------------------------------------------------------
select 
	c.numord,ic.cfo,ic.aliqicms,c.serie,ic.dtemis,ic.valicmitem,c.valicm,ic.valicmitem-c.valicm
from #Temp_items ic 
	join #Temp_CFO c on ic.dtemis = c.dtemis 
		and ic.cfo = c.cfo and c.alqicm = ic.aliqicms and c.serie = ic.serie and c.lif = ic.lif
		and ic.numord = c.numord
where --ic.aliqicms = '18' and ic.cfo = '5102' and 
	c.lif = 0 and (ic.valicmitem - c.valicm < -0.01 or ic.valicmitem - c.valicm > 0.01)
group by ic.cfo,ic.aliqicms,ic.dtemis,ic.valicmitem,c.valicm,c.serie,c.numord
order by c.serie


-----------------------------------------------------------------------------------------------------------------------------------------------------------------
select 	
	c.numnota, c.serie,n.dtemis, tc.cfo,	tc.alqicm, 	
	sum(tc.valicm) as valicm, 	sum(tc.outricm) as outricm, 	sum(tc.valsemicm) as valsemicm 
from #Temp_CFO tc join CFOSAIDCAD c on tc.numord = c.numord
	join NFSAIDACAD n on tc.numord = n.numord
where tc.lif = 1 
and tc.cfo = '5102' and tc.alqicm = 18
group by  c.numnota, c.serie,n.dtemis,  tc.cfo,tc.alqicm order by n.dtemis


-- Verificar se tem venda para orgão publico