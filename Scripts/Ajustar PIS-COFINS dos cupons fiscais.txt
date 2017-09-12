--------------------------------------------------
-- LIMPAR TABELAS TEMPORÁRIAS
------------------------------------------------------------------
IF object_id('tempdb..#TMP_CALC_PIS_COFINS_CUPOM') IS NOT NULL DROP TABLE #TMP_CALC_PIS_COFINS_CUPOM
----------------------------------------------------------------------------------------------------------------------------------
-- Popular registros
--------------------------------------------------
Declare @cstPis char(2),@cstCofins char(2),@aPis varchar(max),@aCofins varchar(max), @ano int, @mes int

set @cstPis = '01'
set @cstCofins = '01'
set @aPis = '1.65'
set @aCofins = '7.60'
set @ano = 2017
set @mes = 8

select 'UPDATE ITNFSAICOMPLEMENTO set PIS = '+@aPis
		+', COFINS = '+@aCofins
		+', CST_PIS='''+@cstPis
		+''',CST_COFINS='''+@cstCofins
		+''', BASECAL_PIS = '+ convert(varchar,(it.quant*it.preco))
		+', BASECAL_COFINS= ' + convert(varchar,(it.quant*it.preco))
		+' WHERE NUMORD = ' +convert(varchar,cp.numord) +' AND ITEM = '+''''+convert(varchar,it.ITEM)+'''' as comando,
	cp.NUMORD INTO #TMP_CALC_PIS_COFINS_CUPOM
	from ITNFSAICOMPLEMENTO cp
	join nfsaidacad nf on cp.numord = nf.numord  
	join ITNFSAICAD it on it.numord = cp.NUMORD and it.item = cp.item
where YEAR(nf.dtemis)=@ano and MONTH(nf.dtemis)=@mes
	and nf.espdoc = 'CF' and lif = 0 and atualiz = 1 and flagemit=1 and dtcancel is null
	and cp.PIS=0 and cp.COFINS = 0
	
----------------------------------------------------------------------------------------------------------------------------------
-- Obter o ajuste das bases e cst de Pis e cofins
--------------------------------------------------

select * from #TMP_CALC_PIS_COFINS_CUPOM

----------------------------------------------------------------------------------------------------------------------------------
-- Gerar os valores de Pis e cofins
--------------------------------------------------
--update ITNFSAICOMPLEMENTO set VALOR_PIS = (basecal_pis*(PIS/100)), VALOR_COFINS = (basecal_cofins*(cofins/100)) where NUMORD in (select numord from #TMP_CALC_PIS_COFINS_CUPOM)
