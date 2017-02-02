---------------------------------------------------------------------------------------------------------------
-- Importação dos Registros E14 e E15 ATO COTEPE/ICMS N° 08/07, DE 28 DE JUNHO DE 2007
-- Layout: http://www1.fazenda.gov.br/confaz/confaz/atos/atos_cotepe/2004/..%5C2007%5CAC008_07.htm
/***********************************************************************************************
	-- Limpar registros para fechar o atendimento
	-------------------------------------------------
	IF object_id('ImportacaoAto_Cotep') IS NOT NULL Drop table ImportacaoAto_Cotep
	IF object_id('tempdb..#TempE14') IS NOT NULL DROP TABLE #TempE14
	IF object_id('tempdb..#TempE15') IS NOT NULL DROP TABLE #TempE15
	IF object_id('tempdb..#items') IS NOT NULL DROP TABLE #items
	IF object_id('tempdb..#cfos') IS NOT NULL DROP TABLE #cfos
	IF object_id('tempdb..#precupom') IS NOT NULL DROP TABLE #precupom
***********************************************************************************************/
--------------------------------------------------------------------------------------------------------------
-- IMPORTAÇÃO DOS REGISTROS DO ATO COTEPE/ICMS N° 08/07
------------------------------------------------------------------
IF object_id('ImportacaoAto_Cotep') IS NOT NULL Drop table ImportacaoAto_Cotep
go
create table ImportacaoAto_Cotep(registro varchar(1000))
go
BULK INSERT ImportacaoAto_Cotep 
	FROM 'D:\Temp\atocotepe_mfd_data.txt' -- Informe o caminho completo do arquivo
go

------------------------------------------------------------------
-- LIMPAR TABELAS TEMPORÁRIAS
------------------------------------------------------------------
IF object_id('tempdb..#TempE14') IS NOT NULL DROP TABLE #TempE14
IF object_id('tempdb..#TempE15') IS NOT NULL DROP TABLE #TempE15
IF object_id('tempdb..#items') IS NOT NULL DROP TABLE #items
IF object_id('tempdb..#cfos') IS NOT NULL DROP TABLE #cfos
IF object_id('tempdb..#precupom') IS NOT NULL DROP TABLE #precupom

------------------------------------------------------------------
-- INSERIR OS DADOS DA VENDA
---------------------------------------------------------------
declare @filial char(2), @dtInicial datetime, @dtFinal datetime

declare @serieecf char(20)				-- Mudar para char(15) se form Impressora Daruma

set @serieecf = '000000000217431'		-- Insira a Série do ECF
set @dtInicial = '20161103'				-- Insira a Data inicial da venda
set @dtFinal = '20161103'				-- Insira a Data Final da venda

--------------------------------------------------------------------------------------------------------------
-- Cupom (Capa)
-- Alimentar os registros E14 na tabela temporária (#TempE14)
--------------------------------------------------------------------------------------------------------------
select 
	substring(registro,1,3) as Registro,			-- Tipo
	substring(registro,4,20) as SerieECF,			-- Número de fabricação do ECF
	substring(registro,24,1) as MF_Adicional,		-- Letra indicativa de MF adicional
	substring(registro,25,20) as Modelo_ECF,		-- Modelo do ECF
	substring(registro,45,2) as Num_Usuario ,		-- Nº de ordem do usuário do ECF
	substring(registro,47,6) as CCF,				-- Nº do contador do respectivo documento emitido ccf
	substring(registro,53,6) as COO,				-- coo
	substring(registro,59,8) as Data_Cupom,			-- Data de início da emissão do documento
	cast(substring(registro,67,12)+'.'+substring(registro,79,2)  as decimal(15,2)) as Valor_CupomSemDesconto,	-- Valor total do documento, com duas casas decimais.
	cast(substring(registro,81,11)+'.'+substring(registro,92,2) as decimal(15,2)) as Desconto,					-- Valor do desconto ou percentual aplicado sobre o valor do subtotal do documento, com duas casas decimais.
	substring(registro,94,1) as Tipo_Valor_Desc,																-- Informar “V” para valor monetário ou “P” para percentual
	cast(substring(registro,95,13) as decimal(15,2)) as Acrescimo,												-- Valor do acréscimo ou percentual aplicado sobre o valor do subtotal do documento, com duas casas decimais.
	substring(registro,108,1) as Tipo_Valor_Acr,																-- Informar “V” para valor monetário ou “P” para percentual
	cast(substring(registro,109,12)+'.'+substring(registro,121,2) as decimal(15,2)) as Total_Liquido,			-- Valor total do Cupom Fiscal após desconto/acréscimo, com duas casas decimais.
	substring(registro,123,1) as Cancelado,																		-- Informar "S" ou "N", conforme tenha ocorrido ou não, o cancelamento do documento.
	cast(substring(registro,124,13) as decimal(15,2)) as Val_Cancelamento,										-- Valor do cancelamento de acréscimo no subtotal
	substring(registro,137,1) as Indicador,									-- Indicador de ordem de aplicação de desconto e acréscimo em subtotal, sendo ‘D’ ou ‘A’ conforme tenha ocorrido primeiro desconto ou acréscimo, respectivamente
	substring(registro,138,40) as Cliente,									-- Nome do adquirente das mercadorias ou serviços (consumidor)
	substring(registro,178,14) as CPF_CNPJ									-- CPF ou CNPJ do adquirente das mercadorias ou serviços (consumidor) (somente números)
Into #TempE14 from ImportacaoAto_Cotep 
where 
	left(registro,3) = 'E14' -- Registro tipo E14 – Cupom Fiscal, Nota Fiscal de Venda a Consumidor ou Bilhete de Passagem;
--------------------------------------------------------------------------------------------------------------
-- Detalhe do Cupom (Itens)
-- Alimentar os registros E15 na tabela temporária (#TempE15)
--------------------------------------------------------------------------------------------------------------
select 
	substring(registro,1,3) as Registro,			-- Tipo
	substring(registro,4,20) as SerieECF,			-- Número de fabricação do ECF
	substring(registro,24,1) as MF_Adicional,		-- Letra indicativa de MF adicional
	substring(registro,25,20) as Modelo_ECF,		-- Modelo do ECF
	substring(registro,45,2) as Num_Usuario ,		-- Número do usuário
	substring(registro,47,6) as COO,				-- COO
	substring(registro,53,6) as CCF,				-- Número do contador CCF
	substring(registro,59,3) as Item_Cupom,			-- Número do item registrado no documento
	substring(registro,62,14) as Codigo,			-- Código do produto ou serviço registrado no documento.
	substring(registro,76,100) as Descricao,		-- Descrição do produto ou serviço constante no Cupom Fiscal
	cast(substring(registro,176,4) +'.'+substring(registro,180,3) as numeric(15,3)) as Quantidade, -- Quantidade comercializada, sem a separação das casas decimais.
	substring(registro,183,3) as Unidade,																	-- Unidade de medida
	cast(substring(registro,186,6) +'.'+substring(registro,192,2) as decimal(15,2)) as Val_Unitario,		-- Valor unitário do produto ou serviço, sem a separação das casas decimais.
	cast(substring(registro,194,8) as decimal(15,2)) as Des_Unitario,										-- 	Valor do desconto incidente sobre o valor do item, com duas casas decimais.
	cast(substring(registro,202,8) as decimal(15,2)) as Acr_Unitario,										-- Valor do acréscimo incidente sobre o valor do item, com duas casas decimais.
	cast(substring(registro,210,12) +'.'+substring(registro,212,2) as decimal(15,2)) as Tot_Liq_Unitario,	-- Valor total líquido do item, com duas casas decimais.
	substring(registro,224,7) as Totalizador,																-- Código do totalizador relativo ao produto ou serviço conforme tabela abaixo.
	substring(registro,231,1) as Tipo_Cancelamento,															-- Informar "S" ou "N", conforme tenha ocorrido ou não, o cancelamento total do item no documento. Informar "P" quando ocorrer o cancelamento parcial do item.
	cast(substring(registro,232,7)  as numeric(15,3)) as Quant_Cancelada,		-- Quantidade cancelada, no caso de cancelamento parcial de item, sem a separação das casas decimais.
	cast(substring(registro,239,13) as decimal(15,2)) as Val_Cancelado,			-- Valor cancelado, no caso de cancelamento parcial de item.
	cast(substring(registro,252,13) as decimal(15,2)) as Val_Can_Acr_Item,		-- Valor do cancelamento de acréscimo no item
	substring(registro,265,1) as Arr_Trunc,										-- Indicador de Arredondamento ou Truncamento relativo à regra de cálculo do valor total líquido do item, sendo‘T’ para truncamento ou ‘A’ para arredondamento.
	substring(registro,266,1) as Casas_Quantidade,								-- Parâmetro de número de casas decimais da quantidade
	substring(registro,267,1) as Casa_Val_Unitario								-- Parâmetro de número de casas decimais de valor unitário
into #TempE15 from ImportacaoAto_Cotep 
where 
	left(registro,3) = 'E15' -- Registro tipo E15 – Detalhe do Cupom Fiscal, da Nota Fiscal de Venda a Consumidor ou do Bilhete de Passagem;

--------------------------------------------------------------------------------------------------------------
-- select * from ImportacaoAto_Cotep
-- select * from #TempE14
-- select * from #TempE15 where coo = '023207'
--------------------------------------------------------------------------------------------------------------
-- Dados do Banco de Dados	
--------------------------------------------------------------------------------------------------------------
-- Alimentar a tabela temporária (#items)
-------------------------------------------
Select @filial = filial, @serieecf = serieecf  from nfsaidacad where serieecf = @serieecf
select 
	n.serieecf, n.numnota,n.serie,n.filial, n.numord, i.cfo, 
	sum(i.quant * i.preco + i.valsubstri + i.quant * i.preco  * (n.valfrete  - desconto)/(n.valcontab - n.valsubstri - n.valfrete  + n.desconto) ) valor 
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
-- Externo X Banco
-- Lista divergência de valor entre valor do ARQUIVO ATOCOTEP/REGISRO E14 com o valor do cupom
--------------------------------------------------------------------------------------------------
select 
	a.numord, sum(a.valor) , b.Total_Liquido, sum(a.valor) - b.Total_Liquido
from #items a,  #TempE14 b
where a.numnota = b.COO and a.SerieECF = b.SerieECF 
group by a.numord, b.Total_Liquido
having sum(a.valor) - b.Total_Liquido < - 0.000001 or sum(a.valor) - b.Total_Liquido > 0.000001

select * from #TempE14 where COO not in (select numnota from #items)	-- verifica CUPONS EM #TempE14 que não está no Banco de dados (#itens)
select * from #items where numnota not in (select COO from #TempE14)	-- verifica CUPONS EM #itens(no banco) que não está em #TempE14 (No arquivo Ato Cotep)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
	and l.numeroecf = '001/BE091510100011285054'
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
Select numord,lif,atualiz,dtcancel,flagemit,* from nfsaidacad where numord = 'Informar o numord da nota'
Select * from cfosaidcad where numord = 'Informar o numord da nota'
Select item,* from itnfsaicad where numord = 'Informar o numord da nota'
Select item,* from ITNFSAICOMPLEMENTO where numord = 'Informar o numord da nota'
Select SUM(quant*preco) from itnfsaicad where numord = 'Informar o numord da nota'

select * from precupom 
	where 
		serialecf = 'informe o serieal do ecf' 
		and coo = 'informe o COO ou numnota' 
		and data = 'informe a data do faturamento'
