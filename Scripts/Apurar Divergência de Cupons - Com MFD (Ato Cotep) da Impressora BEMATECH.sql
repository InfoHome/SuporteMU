-- INFORMA��ES GERAIS ----------------------------------------------------------------------------------------
-- Importa��o dos Registros E14 e E15 ATO COTEPE/ICMS N� 08/07, DE 28 DE JUNHO DE 2007
-- Layout: http://www1.fazenda.gov.br/confaz/confaz/atos/atos_cotepe/2004/..%5C2007%5CAC008_07.htm
-- Espec�fico para impressora *** D A R U M A ***
--------------------------------------------------------------------------------------------------------------
-- Inserir os dados para importa��o:
---------------------------------------------------------------
Declare @filial char(2), @dtInicial datetime, @dtFinal datetime, @pathFileName varchar(100),@sql_Statemanet varchar(1000),@serieecf varchar(max)
-- Insira o caminho do arquivo Cotep e os dados da venda
--------------------------------------------------------------------------------------------
set @pathFileName = 'C:\TEMP2\ATOCOTEPE_DATA.TXT'	-- Insira o caminho do arquivo Cotep
set @serieecf =  ''								-- Insira a S�rie do ECF
set @dtInicial = ''								-- Insira a Data inicial da venda
set @dtFinal =   ''								-- Insira a Data Final da venda

--------------------------------------------------------------------------------------------
IF object_id('ImportacaoAto_Cotep') IS NOT NULL Drop table ImportacaoAto_Cotep
create table ImportacaoAto_Cotep(registro varchar(1000))
set @sql_Statemanet = 'BULK INSERT ImportacaoAto_Cotep FROM '''+@pathFileName+''''
execute(@sql_Statemanet)

------------------------------------------------------------------
-- LIMPAR TABELAS TEMPOR�RIAS
------------------------------------------------------------------
IF object_id('tempdb..#TempE14') IS NOT NULL DROP TABLE #TempE14
IF object_id('tempdb..#TempE15') IS NOT NULL DROP TABLE #TempE15
IF object_id('tempdb..#items') IS NOT NULL DROP TABLE #items
IF object_id('tempdb..#cfos') IS NOT NULL DROP TABLE #cfos
IF object_id('tempdb..#precupom') IS NOT NULL DROP TABLE #precupom
--------------------------------------------------------------------------------------------------------------
-- Cupom (Capa)
-- Alimentar os registros E14 na tabela tempor�ria (#TempE14)
--------------------------------------------------------------------------------------------------------------
select 
	substring(registro,1,3) as Registro,			-- Tipo
	substring(registro,4,20) as SerieECF,			-- N�mero de fabrica��o do ECF
	substring(registro,24,1) as MF_Adicional,		-- Letra indicativa de MF adicional
	substring(registro,25,20) as Modelo_ECF,		-- Modelo do ECF
	substring(registro,45,2) as Num_Usuario ,		-- N� de ordem do usu�rio do ECF
	substring(registro,47,6) as CCF,				-- N� do contador do respectivo documento emitido ccf
	substring(registro,53,6) as COO,				-- coo
	substring(registro,59,8) as Data_Cupom,			-- Data de in�cio da emiss�o do documento
	cast(substring(registro,67,12)+'.'+substring(registro,79,2)  as decimal(15,2)) as Valor_CupomSemDesconto,	-- Valor total do documento, com duas casas decimais.
	cast(substring(registro,81,11)+'.'+substring(registro,92,2) as decimal(15,2)) as Desconto,					-- Valor do desconto ou percentual aplicado sobre o valor do subtotal do documento, com duas casas decimais.
	substring(registro,94,1) as Tipo_Valor_Desc,																-- Informar �V� para valor monet�rio ou �P� para percentual
	cast(substring(registro,95,13) as decimal(15,2)) as Acrescimo,												-- Valor do acr�scimo ou percentual aplicado sobre o valor do subtotal do documento, com duas casas decimais.
	substring(registro,108,1) as Tipo_Valor_Acr,																-- Informar �V� para valor monet�rio ou �P� para percentual
	cast(substring(registro,109,12)+'.'+substring(registro,121,2) as decimal(15,2)) as Total_Liquido,			-- Valor total do Cupom Fiscal ap�s desconto/acr�scimo, com duas casas decimais.
	substring(registro,123,1) as Cancelado,																		-- Informar "S" ou "N", conforme tenha ocorrido ou n�o, o cancelamento do documento.
	cast(substring(registro,124,13) as decimal(15,2)) as Val_Cancelamento,										-- Valor do cancelamento de acr�scimo no subtotal
	substring(registro,137,1) as Indicador,									-- Indicador de ordem de aplica��o de desconto e acr�scimo em subtotal, sendo �D� ou �A� conforme tenha ocorrido primeiro desconto ou acr�scimo, respectivamente
	substring(registro,138,40) as Cliente,									-- Nome do adquirente das mercadorias ou servi�os (consumidor)
	substring(registro,178,14) as CPF_CNPJ									-- CPF ou CNPJ do adquirente das mercadorias ou servi�os (consumidor) (somente n�meros)
Into #TempE14 from ImportacaoAto_Cotep 
where 
	left(registro,3) = 'E14' -- Registro tipo E14 � Cupom Fiscal, Nota Fiscal de Venda a Consumidor ou Bilhete de Passagem;
--------------------------------------------------------------------------------------------------------------
-- Detalhe do Cupom (Itens)
-- Alimentar os registros E15 na tabela tempor�ria (#TempE15)
--------------------------------------------------------------------------------------------------------------
select 
	substring(registro,1,3) as Registro,			-- Tipo
	substring(registro,4,20) as SerieECF,			-- N�mero de fabrica��o do ECF
	substring(registro,24,1) as MF_Adicional,		-- Letra indicativa de MF adicional
	substring(registro,25,20) as Modelo_ECF,		-- Modelo do ECF
	substring(registro,45,2) as Num_Usuario ,		-- N�mero do usu�rio
	substring(registro,47,6) as COO,				-- COO
	substring(registro,53,6) as CCF,				-- N�mero do contador CCF
	substring(registro,59,3) as Item_Cupom,			-- N�mero do item registrado no documento
	substring(registro,62,14) as Codigo,			-- C�digo do produto ou servi�o registrado no documento.
	substring(registro,76,100) as Descricao,		-- Descri��o do produto ou servi�o constante no Cupom Fiscal
	cast(substring(registro,176,4) +'.'+substring(registro,180,3) as numeric(15,3)) as Quantidade, -- Quantidade comercializada, sem a separa��o das casas decimais.
	substring(registro,183,3) as Unidade,																	-- Unidade de medida
	cast(substring(registro,186,6) +'.'+substring(registro,192,2) as decimal(15,2)) as Val_Unitario,		-- Valor unit�rio do produto ou servi�o, sem a separa��o das casas decimais.
	cast(substring(registro,194,8) as decimal(15,2)) as Des_Unitario,										-- 	Valor do desconto incidente sobre o valor do item, com duas casas decimais.
	cast(substring(registro,202,8) as decimal(15,2)) as Acr_Unitario,										-- Valor do acr�scimo incidente sobre o valor do item, com duas casas decimais.
	cast(substring(registro,210,12) +'.'+substring(registro,212,2) as decimal(15,2)) as Tot_Liq_Unitario,	-- Valor total l�quido do item, com duas casas decimais.
	substring(registro,224,7) as Totalizador,																-- C�digo do totalizador relativo ao produto ou servi�o conforme tabela abaixo.
	substring(registro,231,1) as Tipo_Cancelamento,															-- Informar "S" ou "N", conforme tenha ocorrido ou n�o, o cancelamento total do item no documento. Informar "P" quando ocorrer o cancelamento parcial do item.
	cast(substring(registro,232,7)  as numeric(15,3)) as Quant_Cancelada,		-- Quantidade cancelada, no caso de cancelamento parcial de item, sem a separa��o das casas decimais.
	cast(substring(registro,239,13) as decimal(15,2)) as Val_Cancelado,			-- Valor cancelado, no caso de cancelamento parcial de item.
	cast(substring(registro,252,13) as decimal(15,2)) as Val_Can_Acr_Item,		-- Valor do cancelamento de acr�scimo no item
	substring(registro,265,1) as Arr_Trunc,										-- Indicador de Arredondamento ou Truncamento relativo � regra de c�lculo do valor total l�quido do item, sendo�T� para truncamento ou �A� para arredondamento.
	substring(registro,266,1) as Casas_Quantidade,								-- Par�metro de n�mero de casas decimais da quantidade
	substring(registro,267,1) as Casa_Val_Unitario								-- Par�metro de n�mero de casas decimais de valor unit�rio
into #TempE15 from ImportacaoAto_Cotep 
where 
	left(registro,3) = 'E15' -- Registro tipo E15 � Detalhe do Cupom Fiscal, da Nota Fiscal de Venda a Consumidor ou do Bilhete de Passagem;
--------------------------------------------------------------------------------------------------------------
-- Dados do Banco de Dados	
--------------------------------------------------------------------------------------------------------------
-- Alimentar a tabela tempor�ria (#items)
-------------------------------------------
Select @filial = filial, @serieecf = serieecf  from nfsaidacad where serieecf = @serieecf
select n.serieecf, n.numnota,n.serie,n.filial, n.numord, i.cfo, n.lif, n.atualiz, n.dtcancel,
	sum(i.quant * i.preco + i.valsubstri + i.quant * i.preco  * (n.valfrete  - desconto)/(n.valcontab - n.valsubstri - n.valfrete  + n.desconto) ) valor 
	into #items from itnfsaicad i, nfsaidacad n 
where n.dtemis between @dtInicial and @dtFinal 
	and n.numord = i.numord 
	and n.filial = @filial
	and @serieecf = n.serieecf
group by n.serieecf,n.numnota,n.serie,n.filial, n.numord, i.cfo ,n.lif, n.atualiz, n.dtcancel

-- Alimentar a tabela tempor�ria (#cfos)
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
select * from #TempE14 where coo = ''
select * from #TempE15 where coo = ''
/**********************************************************************************************************************************************************************/
-- Externo X Banco
-- Lista diverg�ncia de valor entre valor do ARQUIVO ATOCOTEP/REGISRO E14 com o valor do cupom
--------------------------------------------------------------------------------------------------
select 
	a.numord, sum(a.valor) , b.Total_Liquido, sum(a.valor) - b.Total_Liquido
from #items a,  #TempE14 b
where a.numnota = b.COO and a.SerieECF = b.SerieECF
group by a.numord, b.Total_Liquido
having sum(a.valor) - b.Total_Liquido < - 0.000001 or sum(a.valor) - b.Total_Liquido > 0.000001


/**************************************************************************************************************************************************************/
-- Verifica registros faltantes
-------------------------------------------------------
-- verifica CUPONS da MFD(#TempE14) que n�o est� no Banco de dados(#itens)
select * from #TempE14 where COO not in (select numnota from #items)		

-- verifica CUPONS do Banco de dados(#itens) que n�o est� na MFD(#TempE14)
select * from #items where numnota not in (select COO from #TempE14)		


/**************************************************************************************************************************************************************/
-- Externo X Banco
-- Lista os cupons do Arquivo MFD e do Banco de dados e fala a situa��o "Faturado e Cancelado"
-- Voc� pode comparar a situa��o de um registro com o outro na mesma linha
-- Voc� pode descomentar a clausula "WHERE" para filtrar por um determinado Cupom Fiscal(COO)
-- Voc� pode descomentar a clausula "HAVING" para ver qual cupom do Banco de Dados est� com valor diferente da MFD
---------------------------------------------------------------------------------------------------------------------
SELECT 
	Imp.COO,imp.Total_Liquido as [Valor da MFD] ,	case when imp.cancelado = 'S' then 'Cupom Cancelado na Impressora' else 'Cupom Faturado na MFD' end as Situacao_da_MFD,
	bd.numord, 	bd.numnota,sum(bd.valor) as [Valor do Sistema],	case when bd.dtcancel is not null then 'Cupom Cancelado no Banco de Dados' else 'Cupom Faturado no Sistema' end as Situacao_do_Banco,
	case when imp.cancelado = 'S' then imp.Total_Liquido else imp.Total_Liquido - sum(bd.valor) end  as Compracao
FROM #TempE14 AS IMP 
	JOIN #items BD on imp.COO = bd.numnota and imp.SerieECF = bd.SerieECF
--WHERE bd.numnota = '000640'
GROUP BY Imp.COO,bd.numnota,bd.numord,bd.dtcancel, imp.cancelado,imp.Total_Liquido
--HAVING imp.Total_Liquido - sum(bd.valor) <> 0	

/**************************************************************************************************************************************************************/
-- Externo X Banco
-- Lista os cupons do Arquivo MFD Cancelados e compara com os cupons do Banco de dados e fala a situa��o "Faturado e Cancelado"
----------------------------------------------------------------------------------------------------------------------------------------------
select 
	imp.COO,imp.Totalizador,sum(imp.Val_Unitario),nfs.dtemis,nfs.dtcancel,nfs.lif,nfs.atualiz,nfs.flagemit
from #TempE15 imp 
	left join nfsaidacad nfs on imp.coo = nfs.numnota and imp.SerieECF = nfs.serieecf  
where imp.Tipo_Cancelamento = 'S' 
group by imp.COO,imp.Totalizador,nfs.dtemis,nfs.dtcancel,nfs.lif,nfs.atualiz,nfs.flagemit order by imp.coo,imp.Totalizador
/**************************************************************************************************************************************************************/

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