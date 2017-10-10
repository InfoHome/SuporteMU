-----------------------------------------------------------------------------------------------------------------
-- ENTENDIMENTO E SCRIPTS
-----------------------------------------------------------------------------------------------------------------
/*
ASSUNTO..................................: 	SCRIPT PARA APURAR DIVERGÊNCIAS ENTRE ITEM-CFOP-PRECUPOM DOS CUPONS FISCAIS
MOTIVO DE CRIAÇÃO DESTE SCRIPT...........: 	ATENDIMENTO 
AUTOR....................................:  JOSÉ TOBIAS DE OLIVEIRA ALMEIDA
DATA CRIACAÇÃO...........................:	26/04/2014
ORIGEM DO PROBLEMA.......................: 	
VERSÃO DO SISTEMA IDENTIFICADA O ERRO....:
PROBLEMA.................................: 	
PROBLEMA FOI SIMULAÇÃO...................:  SIM( X ) | NÃO (  )
OCORREU O PROBLEMA?......................:	SIM( X ) | NÃO (  )
SE SIMULOU, QUEM FOI?....................:	
*/
-----------------------------------------------------------------------------------------------------------------

declare @filial char(2), @dtInicial datetime, @dtFinal datetime
declare @serieecf char(15) -- Mudara para char(15) se form Impressora Daruma

-- Informe aqui os dados do dia da venda
---------------------------------------------------------------
set @serieecf = '000000000440232'	-- Série do ECF
set @dtInicial = '20170822'				-- Data inicial da venda
set @dtFinal = '20170822'				-- Data Final da venda
---------------------------------------------------------------
-- Lipar Registros
------------------
IF object_id('tempdb..#items') IS NOT NULL 	DROP TABLE #items
IF object_id('tempdb..#cfos') IS NOT NULL 	DROP TABLE #cfos
IF object_id('tempdb..#precupom') IS NOT NULL 	DROP TABLE #precupom
----------------------------------------------
--#items
Select @filial = filial, @serieecf = serieecf  from nfsaidacad where serieecf = @serieecf
select 
	n.numnota,n.serie,n.filial, n.numord, i.cfo, 
	sum(i.quant * i.preco + i.valsubstri + i.quant * i.preco  * (n.valfrete  - desconto)/(n.valcontab - n.valsubstri - n.valfrete  + n.desconto) ) valor 
into #items from itnfsaicad i, nfsaidacad n 
where n.dtemis between @dtInicial and @dtFinal 
	and n.numord = i.numord 
	and n.atualiz = 1 
	and n.lif = 0
	and n.dtcancel is null
	and n.filial = @filial
	and @serieecf = serieecf
group by n.numnota,n.serie,n.filial, n.numord, i.cfo

--#cfos
select 
	numnota, numord, cfo,baseicm + baseicm2 + baseicm3 + baseicm4 + baseicm5 + outricm + valsemicm + valtribdif valor 
into #cfos from cfosaidcad 
where  numord in ( select numord from nfsaidacad 
					where dtemis between @dtInicial and @dtFinal 
						and atualiz = 1
						and lif = 0
						and dtcancel is null 
						and filial = @filial
						and @serieecf = serieecf)
--#precupom
Select Coo, serialecf,Data ,sum(ValorTotal) as ValorTotal
into #precupom from precupom
where serialecf = @serieecf
	and data between @dtInicial and @dtFinal
	and filial = @filial
group by  Coo,serialecf,Data

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Consultas
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Lista divergência de valores entre o valor do cupom e o valor dos itens
------------------------------------------------------------------------------------
select '0', 
a.numord, a.cfo, a.valor , b.valor, a.valor - b.valor
from #items a,  #cfos b
where a.numord = b.numord and a.cfo = b.cfo and ((a.valor - b.valor) < -1 or  (a.valor - b.valor) > 1)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Lista divergência de valores entre o valor do cupom e o valor da precupom
------------------------------------------------------------------------------------
select '1',
	a.filial, p.data,a.serie, p.serialecf, a.numord, a.numnota, 
	sum(a.valor) as valItens , p.valortotal as valPrecupom, sum(a.valor) - p.valortotal as Diff
from #items a,  #precupom p
where a.numnota = p.coo 
group by a.filial,a.serie, p.data,p.serialecf,a.numord,a.numnota,p.valortotal
having ((sum(a.valor)- p.valortotal) < -1 or (sum(a.valor) - p.valortotal) > 1)


select '2',* from #cfos where numord not in (select numord from #items)	-- verifica se tem cfops sem itens
select '3',* from #items where numord not in (select numord from #cfos) -- verifica se tem itens sem cfops
select '4',* from #precupom where coo not in (select numnota from #items)		-- verifica se tem cfops sem itens
select '5',* from #items where numnota not in (select coo from #precupom)		-- verifica se tem itens sem cfops


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Consultas Gerais
---------------------------------
--select * from nfsaidacad where serieecf = 'BE091510100011285054' and dtemis = '20161007' and lif = 1 and atualiz = 1
--Select numord,lif,atualiz,dtcancel,flagemit,* from nfsaidacad where  numord = 8406617
--Select * from cfosaidcad where numord = 8406617
--Select sum(quant*preco) from itnfsaicad where numord = 8406617
--select sum(valortotal) from precupom where serialecf = '000000000440232' and coo = '166188' and data = '20170822'
--select * from precupom where serialecf = '000000000440232' and coo = '166188' and data = '20170822'



