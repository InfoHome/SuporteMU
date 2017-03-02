-------------------------------------------------------------------------------------------------------------------------------------------------
-- Ajustar o Custven da Entrada
-------------------------------------------------------------------------------------------------------------------------------------------------
SELECT   
	NE.numord, NE.numnota,	NE.tpo,	NE.serie, NE.DTCHEG, NE.FILIAL, NE.tpo,    
	ITNE.quant,	ITNE.CODPRO, ITNE.PRECO, ITNE.PRECOTOTAL, ITNE.VALORIPI, ITNE.VALSUBSTRI, ITCOM.VALTRIBANTECIPADA,
	NE.VALFRETE, NE.DESPINCL, ITNE.custven, PROD.PRECOCOMP,
	SUM((ITNE.PRECO+ITNE.VALORIPI/ITNE.QUANT+ITNE.VALSUBSTRI/ITNE.QUANT+ITCOM.VALTRIBANTECIPADA)+ ( ( (ITNE.PRECO+ITNE.VALORIPI/ITNE.QUANT+ITNE.VALSUBSTRI/ITNE.QUANT)/(NE.VALCONTAB-NE.VALFRETE-NE.DESPINCL) )* (NE.VALFRETE+NE.DESPINCL+NE.DESPNINCL)))AS [Calculo Custo]
	
	-- PEGAR O RESULTADO DA COLUNA AJUSTE PARA ACERTAR A BASE
	-------------------------------------------------------------------------------------------------------------------------------------------------
	,'UPDATE ITNFENTCAD SET CUSTVEN= '+ CONVERT(VARCHAR,SUM((ITNE.PRECO+ITNE.VALORIPI/ITNE.QUANT+ITNE.VALSUBSTRI/ITNE.QUANT+ITCOM.VALTRIBANTECIPADA)
		+ ( ( (ITNE.PRECO+ITNE.VALORIPI/ITNE.QUANT+ITNE.VALSUBSTRI/ITNE.QUANT)/(NE.VALCONTAB-NE.VALFRETE-NE.DESPINCL) )
		* (NE.VALFRETE+NE.DESPINCL+NE.DESPNINCL))))	
		+ ' WHERE NUMORD = ' + CONVERT(VARCHAR,NE.NUMORD) 	
		+ ' AND CODPRO = ''' + CONVERT(VARCHAR,ITNE.CODPRO)+'''' 
		+ ' AND ITEM = ''' + CONVERT(VARCHAR,ITNE.ITEM)+''''
		AS AJUSTE
	-------------------------------------------------------------------------------------------------------------------------------------------------
FROM NFENTRACAD NE
	join ITNFENTCAD ITNE on NE.NUMORD = ITNE.NUMORD AND NE.ATUALIZ = 1 AND NE.TPO LIKE '1%' AND NE.EST='1' 
	join PRODUTOCAD PROD on ITNE.CODPRO = PROD.CODPRO 
	left join ITNFENTCOMPLEMENTO ITCOM on (ITNE.NUMORD = ITCOM.NUMORD AND ITNE.ITEM=ITCOM.ITEM)

WHERE   (NE.VALCONTAB - (NE.DESPINCL+NE.VALFRETE + NE.VALSUBSTRI)) > 0 
		AND itne.custven <= 0
GROUP BY 	
	NE.numord, NE.serie, NE.numnota, NE.DTCHEG, NE.FILIAL,
    NE.tpo, PROD.PRECOCOMP, ITNE.quant, ITNE.CODPRO, ITNE.PRECO, ITNE.PRECOTOTAL, ITNE.VALORIPI,
    ITNE.VALSUBSTRI, NE.VALFRETE, NE.DESPINCL, ITCOM.VALTRIBANTECIPADA, ITNE.custven, ITNE.iTEM
ORDER BY NE.DTCHEG DESC




