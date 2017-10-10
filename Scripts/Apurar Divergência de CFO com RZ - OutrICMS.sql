
---------------------------------------------------------------------------------------------------------------
-- LIMPAR TABELAS TEMPORÁRIAS
------------------------------------------------------------------
IF object_id('tempdb..#Temp_Dia_Z') IS NOT NULL DROP TABLE #Temp_Dia_Z
IF object_id('tempdb..#Temp_Dia_Cupom') IS NOT NULL DROP TABLE #Temp_Dia_Cupom
------------------------------------------------------------------
-- INSERIR OS DADOS DA VENDA
---------------------------------------------------------------
declare  @pAtualiz char(1), @pLif char(1), @pfilial char(2), @ano int, @mes int

set @pfilial = '03'				-- Insira a Filial da venda
set @ano = 2017					-- Insira a Data inicial da venda
set @mes = 8					-- Insira a Data Final da venda
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--Listar Reduções Zs do mês para CFOP 5405
------------------------------------------------------------------------------------------
select 	
	c.cfo,n.serieecf,n.dtemis,SUM(c.outricm) as outricm	into #Temp_Dia_Z
from CFOSAIDCAD c 
	join NFSAIDACAD n on c.numord = n.numord
where 
	n.lif = 1  and n.atualiz = 1 and n.dtcancel is null
	--	and c.cfo = '5405' 
	and n.filial = @pfilial
	and YEAR(n.dtemis)= @ano and MONTH(n.dtemis)=@mes
	and espdoc = 'cf'
	group by c.cfo,n.serieecf,n.dtemis
--Listar CFOs dos cupos no mês 
------------------------------------------------------------------------------------------
select 	
	c.cfo,n.serieecf,n.dtemis,SUM(c.outricm) as outricm	into #Temp_Dia_Cupom
from CFOSAIDCAD c join NFSAIDACAD n on c.numord = n.numord
where 
	n.lif = 0  and n.atualiz = 1 and n.dtcancel is null
	--and c.cfo = '5405' 
	and n.filial = @pfilial
	and YEAR(n.dtemis)= @ano and MONTH(n.dtemis)=@mes
	and espdoc = 'cf'
	group by c.cfo,n.serieecf,n.dtemis

--Identificar diferença em qual dia
-------------------------------------------------------------------------------------------
select *,rz.outricm-c.outricm as Diff 
from #Temp_Dia_Z rz join #Temp_Dia_Cupom c on rz.dtemis=c.dtemis
	and rz.SerieECF = c.SerieECF
	and rz.cfo = c.cfo
	and rz.outricm-c.outricm <> 0
order by rz.cfo





