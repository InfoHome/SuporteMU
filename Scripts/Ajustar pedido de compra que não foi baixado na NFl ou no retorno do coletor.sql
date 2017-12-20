-------------------------------------------------------------------------------------------------------------------------
-- Ajustar pedido de compra que não foi baixado na entrada da Nota Fiscal ou no retorno do coletor
-------------------------------------------------------------------------------------------------------------------------

SELECT 
	'UPDATE ITEMFORCAD set quantrec = quantrec + ' + convert(varchar,apc.QUANTIDADENOTA)
		+ ' where numped = ''' + convert(varchar,itf.numped) 
		+ ''' and codpro =  ''' + convert(varchar,itf.codpro)
		+ ''' and item = '''+ convert(varchar,apc.ITEMPEDIDO)+'''',
	'UPDATE itnfentcad set atuaitem = 1 where numord = ' + convert(varchar,i.numord) 
		+ ' and item = '''+ convert(varchar,i.ITEM)+'''',
	nf.numped,itf.numped , apc.numeropedido,
	apc.numeropedido,apc.ITEMPEDIDO,i.numord, i.quant, i.filial, i.codpro,i.atuaitem, l.LoteInterno, i.ITEM, l.Lote, itf.numped pedcompra ,
	apc.QUANTIDADENOTA,apc.QUANTIDADEPEDIDO,
	itf.numped,itf.numord, itf.item,itf.quant,itf.quantrec
FROM ITNFENTCAD i 
	JOIN NFEntraCad NF ON NF.NumOrd = i.NumOrd 
	LEFT JOIN atendepedidocompra apc ON apc.NUMERONOTA = i.numord 
		AND i.codpro = apc.codpro AND I.item = apc.ITEMNOTA 
	JOIN itemforcad itf ON (itf.numped = apc.numeropedido AND itf.codpro = apc.codpro AND itf.item = apc.itempedido) 
		OR (NF.numped > 0 AND ISNULL(i.numped,0) <= 0 AND itf.numped = apc.numeropedido /*nf.numped*/ AND itf.codpro = i.codpro) 
		OR (ISNULL(i.numped,0) > 0 AND itf.numped = i.numped AND itf.codpro = i.codpro) 
	LEFT JOIN LOTE l ON l.codpro = i.codpro AND l.Filial = i.filial AND l.NumOrd = i.numord 
WHERE 
	NF.numord in (8699217,8699223,8699203,8699135,8704442,8704413)
	--and i.CODPRO = '38332' 
	and itf.quantrec <= 0
	--and  i.atuaitem = 0
	AND ISNULL(itf.numped, 0) > 0 
ORDER BY  i.codpro 
