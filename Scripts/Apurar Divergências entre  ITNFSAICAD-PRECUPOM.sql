drop table #Itensnotassaida
drop table #Itensnotasprecupom
GO
Declare @serie char(3), @filial char(2), @dtemisIni datetime, @dtemisFim datetime, @serieecf varchar(20)
set @serie = '004'					-- Informar a Série do ECF
set @filial = '01'					-- Informar a Filial de faturamento
set @dtemisIni = '20160108'				-- Infomrar a Data Inicial de faturamento
set @dtemisFim = '20160108 23:59:59'		-- Informar a Data Final de faturamento
set @serieecf = 'BE091010100011220466'			-- Inofmar o número de série do ECF

select b.numnota,b.numord,b.dtemis, sum(a.quant*a.preco) as valitem, b.valfrete,
(select sum(c.Valordespincl) from itnfsaicomplemento c where c.numord = b.numord) as Valordespincl
into #Itensnotassaida 
from itnfsaicad a,  nfsaidacad b
where a.numord = b.numord and b.serie = @serie and b.filial = @filial  and b.dtemis >= @dtemisIni and b.dtemis <= @dtemisFim
and b.serieecf = @serieecf and b.atualiz = 1  and b.espdoc='CF' and b.lif=0
group by b.valfrete,b.numnota,b.numord,b.dtemis order by b.numnota

select coo, sum (ValorTotal + Acrescimo) as ValorPC
into #Itensnotasprecupom from precupom where data >= @dtemisIni and data <= @dtemisFim  
and serialecf = @serieecf and Filial = @filial
group by COO order by coo

-- Lista os cupons divergentes
--------------------------------
select a.Dtemis,a.Numord,a.Numnota, a.Valitem+a.valfrete+a.Valordespincl as Valitem, 
b.ValorPC, ((a.Valitem + a.Valfrete +a.Valordespincl - b.ValorPC)) as result 
from #Itensnotassaida a, #Itensnotasprecupom b where a.numnota = b.coo
and ((a.Valitem + Valfrete +a.Valordespincl)- (b.valorPC) > 0.04 
	or (a.Valitem + Valfrete +a.Valordespincl)- (b.valorPC) <  - 0.04)

-- Lista os cupons inexistentes pelos itens
--------------------------------------------
select * from #Itensnotassaida where numnota not in (select coo from #Itensnotasprecupom)

-- Lista os cupons inexistentes pela precupom
----------------------------------------------
select * from #Itensnotasprecupom where coo not in (select numnota from #Itensnotassaida)
