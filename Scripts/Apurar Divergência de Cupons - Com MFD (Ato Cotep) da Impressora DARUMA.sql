-- INFORMAÇÕES GERAIS ----------------------------------------------------------------------------------------
-- Importação dos Registros E14 e E15 ATO COTEPE/ICMS N° 08/07, DE 28 DE JUNHO DE 2007
-- Layout: http://www1.fazenda.gov.br/confaz/confaz/atos/atos_cotepe/2004/..%5C2007%5CAC008_07.htm
-- Específico para impressora *** D A R U M A ***
--------------------------------------------------------------------------------------------------------------
-- Inserir os dados para importação:
---------------------------------------------------------------
Declare @filial char(2), @dtInicial datetime, @dtFinal datetime, @pathFileName varchar(100),@sql_Statemanet varchar(1000),@serieecf varchar(max)
-- Insira o caminho do arquivo Cotep e os dados da venda
--------------------------------------------------------------------------------------------
set @pathFileName = 'C:\TEMP2\ATOCOTEPE_DATA.TXT'	-- Insira o caminho do arquivo Cotep
set @serieecf =  '000000000415326'					-- Insira a Série do ECF
set @dtInicial = '20170803'								-- Insira a Data inicial da venda
set @dtFinal =   '20170803'								-- Insira a Data Final da venda

--------------------------------------------------------------------------------------------
IF object_id('ImportacaoAto_Cotep') IS NOT NULL Drop table ImportacaoAto_Cotep
create table ImportacaoAto_Cotep(registro varchar(1000))
set @sql_Statemanet = 'BULK INSERT ImportacaoAto_Cotep FROM '''+@pathFileName+''''

execute(@sql_Statemanet)


------------------------------------------------------------------
-- LIMPAR TABELAS TEMPORÁRIAS
------------------------------------------------------------------
IF object_id('tempdb..#TempE14') IS NOT NULL DROP TABLE #TempE14
IF object_id('tempdb..#TempE15') IS NOT NULL DROP TABLE #TempE15
IF object_id('tempdb..#items') IS NOT NULL DROP TABLE #items
IF object_id('tempdb..#cfos') IS NOT NULL DROP TABLE #cfos
IF object_id('tempdb..#precupom') IS NOT NULL DROP TABLE #precupom
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
-- Dados do Banco de Dados	
--------------------------------------------------------------------------------------------------------------
-- Alimentar a tabela temporária (#items)
-------------------------------------------
Select @filial = filial, @serieecf = serieecf  from nfsaidacad where serieecf = @serieecf
select n.serieecf, n.numnota,n.serie,n.filial, n.numord, i.cfo, n.lif, n.atualiz, n.dtcancel,
	sum(i.quant * i.preco + i.valsubstri + i.quant * i.preco  * (n.valfrete  - desconto)/(n.valcontab - n.valsubstri - n.valfrete  + n.desconto) ) valor 
	into #items from itnfsaicad i, nfsaidacad n 
where n.dtemis between @dtInicial and @dtFinal 
	and n.numord = i.numord 
	and n.filial = @filial
	and @serieecf = serieecf
group by n.serieecf,n.numnota,n.serie,n.filial, n.numord, i.cfo ,n.lif, n.atualiz, n.dtcancel

-- Alimentar a tabela temporária (#cfos)
-------------------------------------------
select numnota, numord, cfo,baseicm + baseicm2 + baseicm3 + baseicm4 + baseicm5 + outricm + valsemicm  valor 
into #cfos from cfosaidcad 
where  numord in ( select numord from nfsaidacad 
					where dtemis between @dtInicial and @dtFinal 
						and filial = @filial
						and @serieecf = serieecf)



/**********************************************************************************************************************************************************************/
-- ****** C O N S U L T A S *******
--------------------------------------------------------------------------------------------------------------
select * from ImportacaoAto_Cotep
select '000'+substring(SerieECF,9,12) from #TempE14
select * from #TempE15 where coo = '091949'
/**********************************************************************************************************************************************************************/
-- Externo X Banco
-- Lista divergência de valor entre valor do ARQUIVO ATOCOTEP/REGISRO E14 com o valor do cupom
--------------------------------------------------------------------------------------------------
select 
	a.numord, sum(a.valor) , b.Total_Liquido, sum(a.valor) - b.Total_Liquido
from #items a,  #TempE14 b
where a.numnota = b.COO and a.SerieECF = '000'+substring(b.SerieECF,9,12)
group by a.numord, b.Total_Liquido
having sum(a.valor) - b.Total_Liquido < - 0.000001 or sum(a.valor) - b.Total_Liquido > 0.000001

/**************************************************************************************************************************************************************/
-- Verifica registros faltantes
-------------------------------------------------------
-- verifica CUPONS da MFD(#TempE14) que não está no Banco de dados(#itens)
select * from #TempE14 where COO not in (select numnota from #items)		

-- verifica CUPONS do Banco de dados(#itens) que não está na MFD(#TempE14)
select * from #items where numnota not in (select COO from #TempE14)		


/**************************************************************************************************************************************************************/
-- Externo X Banco
-- Lista os cupons do Arquivo MFD e do Banco de dados e fala a situação "Faturado e Cancelado"
-- Você pode comparar a situação de um registro com o outro na mesma linha
-- Você pode descomentar a clausula "WHERE" para filtrar por um determinado Cupom Fiscal(COO)
-- Você pode descomentar a clausula "HAVING" para ver qual cupom do Banco de Dados está com valor diferente da MFD
---------------------------------------------------------------------------------------------------------------------
SELECT 
	Imp.COO,imp.Total_Liquido as [Valor da MFD] ,	case when imp.cancelado = 'S' then 'Cupom Cancelado na Impressora' else 'Cupom Faturado na MFD' end as Situacao_da_MFD,
	bd.numord, 	bd.numnota,sum(bd.valor) as [Valor do Sistema],	case when bd.dtcancel is not null then 'Cupom Cancelado no Banco de Dados' else 'Cupom Faturado no Sistema' end as Situacao_do_Banco,
	case when imp.cancelado = 'S' then imp.Total_Liquido else imp.Total_Liquido - sum(bd.valor) end  as Compracao
FROM #TempE14 AS IMP 
	JOIN #items BD on imp.COO = bd.numnota and '000'+substring(imp.SerieECF,9,12) = bd.SerieECF
--WHERE bd.numnota = '000640'
GROUP BY Imp.COO,bd.numnota,bd.numord,bd.dtcancel, imp.cancelado,imp.Total_Liquido
--HAVING imp.Total_Liquido - sum(bd.valor) <> 0	

/**************************************************************************************************************************************************************/
-- Externo X Banco
-- Lista os cupons do Arquivo MFD Cancelados e compara com os cupons do Banco de dados e fala a situação "Faturado e Cancelado"
----------------------------------------------------------------------------------------------------------------------------------------------
select imp.COO,imp.Totalizador,sum(imp.Val_Unitario),nfs.dtemis,nfs.dtcancel,nfs.lif,nfs.atualiz,nfs.flagemit
from #TempE15 imp left join nfsaidacad nfs on imp.coo = nfs.numnota
	and '000'+substring(imp.SerieECF,9,12) = nfs.serieecf
 where imp.Tipo_Cancelamento = 'S' 
group by imp.COO,imp.Totalizador,nfs.dtemis,nfs.dtcancel,nfs.lif,nfs.atualiz,nfs.flagemit order by imp.coo,imp.Totalizador
/**************************************************************************************************************************************************************/
--Consultas Gerais
---------------------------------
Select numord,lif,atualiz,dtcancel,flagemit,* from nfsaidacad where numord = 1561154
Select * from cfosaidcad where numord = 1561154
Select item,* from itnfsaicad where numord = 1561154
Select SUM(quant*preco) from itnfsaicad where numord = 1561154
Select item,* from ITNFSAICOMPLEMENTO where numord = 1561154
Select * from TEXLIVRFAT where numord = 1561154
Select * from COMPLNFFAT where numord = 1561154
Select * from logopercad where numord = 1561154

select * from precupom 
	where 
		serialecf = 'informe o serieal do ecf' 
		and coo = 'informe o COO ou numnota' 
		and data = 'informe a data do faturamento'


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