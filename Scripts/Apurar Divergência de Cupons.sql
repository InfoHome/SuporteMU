---------------------------------------------------------------------------------------------------------------
/***********************************************************************************************/
-- LIMPAR TABELAS TEMPORÁRIAS
------------------------------------------------------------------
IF object_id('tempdb..#items') IS NOT NULL DROP TABLE #items
IF object_id('tempdb..#cfos') IS NOT NULL DROP TABLE #cfos
IF object_id('tempdb..#precupom') IS NOT NULL DROP TABLE #precupom
------------------------------------------------------------------
-- INSERIR OS DADOS DA VENDA
---------------------------------------------------------------
declare @filial char(2), @dtInicial datetime, @dtFinal datetime

declare @serieecf char(20)				-- Mudar para char(15) se form Impressora Daruma

set @serieecf = 'BE091410100011345758'		-- Insira a Série do ECF
set @dtInicial = '20170616'				-- Insira a Data inicial da venda
set @dtFinal = '20170616'				-- Insira a Data Final da venda
--------------------------------------------------------------------------------------------------------------
-- Dados do Banco de Dados	
--------------------------------------------------------------------------------------------------------------
-- Alimentar a tabela temporária (#items)
-------------------------------------------
Select @filial = filial, @serieecf = serieecf  from nfsaidacad where serieecf = @serieecf
select 
	n.serieecf, n.numnota,n.serie,n.filial, n.numord, i.cfo, 
	sum(i.quant * i.preco + i.valsubstri + i.quant * i.preco  * (n.OUTRASDESPESASINCLUSAS + n.valfrete  - desconto)/(n.valcontab - n.valsubstri - n.valfrete -n.OUTRASDESPESASINCLUSAS + n.desconto) ) valor 
into #items from itnfsaicad i, nfsaidacad n 
where n.dtemis between @dtInicial and @dtFinal 
	and n.numord = i.numord 
	and n.atualiz = 1 
	and n.lif = 0
	and n.dtcancel is null
	and n.filial = @filial
	and @serieecf = serieecf
group by n.serieecf,n.numnota,n.serie,n.filial, n.numord, i.cfo

-- Alimentar a tabela temporária (#cfos)
-------------------------------------------
select 
	numnota, numord, cfo,baseicm + baseicm2 + baseicm3 + baseicm4 + baseicm5 + outricm + valsemicm  valor 
into #cfos from cfosaidcad 
where  numord in ( select numord from nfsaidacad 
					where dtemis between @dtInicial and @dtFinal 
						and atualiz = 1
						and lif = 0
						and dtcancel is null 
						and filial = @filial
						and @serieecf = serieecf)

-- Alimentar a tabela temporária (#precupom)
-------------------------------------------
Select Coo, serialecf,Data ,sum(ValorTotal+Acrescimo-DESCONTO) as ValorTotal
into #precupom from precupom
where serialecf = @serieecf
	and data between @dtInicial and @dtFinal
	and filial = @filial
group by  Coo,serialecf,Data


/**********************************************************************************************************************************************************************/
-- ****** C O N S U L T A S *******
/**********************************************************************************************************************************************************************/
-- Banco
-- Lista divergência de valores entre o valor do cupom e o valor dos itens
------------------------------------------------------------------------------------
select a.numord, a.cfo, a.valor , b.valor, a.valor - b.valor
from #items a,  #cfos b
where a.numord = b.numord and a.cfo = b.cfo and ((a.valor - b.valor) < -1 or  (a.valor - b.valor) > 1)

select * from #cfos where numord not in (select numord from #items)	-- verifica se tem cfops sem itens
select * from #items where numord not in (select numord from #cfos) -- verifica se tem itens sem cfops

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Banco
-- Lista divergência de valores entre o valor do cupom e o valor da precupom
------------------------------------------------------------------------------------
select 
	a.filial, p.data,a.serie, p.serialecf, a.numord, a.numnota, 
	sum(a.valor) as valItens , p.valortotal as valPrecupom, sum(a.valor) - p.valortotal as Diff
from #items a,  #precupom p
where a.numnota = p.coo 
group by a.filial,a.serie, p.data,p.serialecf,a.numord,a.numnota,p.valortotal
having ((sum(a.valor)- p.valortotal) < -1 or (sum(a.valor) - p.valortotal) > 1)


select * from #precupom where coo not in (select numnota from #items)		-- verifica se tem cupons na precupom sem itens
select * from #items where numnota not in (select coo from #precupom)		-- verifica se tem itens sem está na precupom

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Banco
-- Lista divergência de valores entre o valor da logecf e o valor dos itens
------------------------------------------------------------------------------------
select l.oidoperacao,l.coo,l.valor as val_Logecf,i.numnota, sum(i.valor) as val_Item
from logecf l, #items i 
where l.oidoperacao = i.numord
	and l.numeroecf = '001/BE091410100011345758'
	and l.rtipooperacao not in (26749)
group by  l.oidoperacao, l.coo,l.valor,i.numnota
having  sum(i.valor) <> l.valor

-- Valores campo oidoperacao
--------------------------------------------------------------
-- 26749	Venda com recebimento antecipado
-- 26750	Venda 
-- 26753	Entrega de venda recebida anteriormente
-- 26754	Entrega de venda corrente


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Consultas Gerais
---------------------------------
Select numord,lif,atualiz,dtcancel,flagemit,OUTRASDESPESASINCLUSAS,valfrete,* from nfsaidacad where numord = 'Numord'
Select * from cfosaidcad where numord = 'Numord'
Select item,* from itnfsaicad where numord = 'Numord'
Select item,ValorDespIncl,ValorFrete,* from ITNFSAICOMPLEMENTO where numord = 'Numord'
Select SUM(quant*preco) from itnfsaicad where numord = 'Numord'

select * from precupom 
	where 
		serialecf = 'informe o serieal do ecf' 
		and coo = 'informe o COO ou numnota' 
		and data = 'informe a data do faturamento'
