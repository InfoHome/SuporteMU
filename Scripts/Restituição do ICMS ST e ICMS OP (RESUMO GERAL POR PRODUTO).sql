-- Restituição do ICMS ST e ICMS OP (RESUMO GERAL POR PRODUTO)
-- RESUMO GERAL POR PRODUTO
-------------------------------------------------------------------------------------------------------------------------------

Declare @DataInicial datetime, @DataFinal datetime, @filial char(02)
set @DataInicial	= '20170401'		
set @DataFinal		= '20170430'
set @filial			= '01'
--SAIDA
-------------------------------------------------------------
SELECT
	DI.CPROD,
	DI.NCM,
	DI.XPROD,
	DI.UTRIB,
	SUM(DI.QTRIB) AS QTRIB,
	0 AS [ICMS ST a Restituir],
	0 AS [ICMS OP a Creditar]
FROM DADOSNOTANFE DN 
	JOIN NFSAIDACAD NF ON DN.NUMORD = NF.numord 
	JOIN DADOSITEMNFE DI ON DI.NUMORD = NF.numord 
	JOIN CFOSAIDCAD CF ON CF.numord = NF.NUMORD
	JOIN FILIALCAD F ON NF.FILIAL = F.FILIAL 
WHERE NF.ATUALIZ = 1 
	AND NF.DTCANCEL IS NULL 
	AND DN.vICMSUFDest > 0 
	AND NF.FILIAL = @filial
	AND NF.dtemis >= @DataInicial
	AND NF.DTEMIS <= @DataFinal
GROUP BY DI.CPROD, DI.NCM, DI.XPROD, DI.UTRIB 
--UNION ALL 
--ENTRADA
-------------------------------------------------------------
--SELECT 'E',
--	DI.CPROD,
--	DI.NCM,
--	DI.XPROD,
--	DI.UTRIB,
--	SUM(DI.QTRIB) AS QTRIB,
--	0 AS [ICMS ST a Restituir],
--	0 AS [ICMS OP a Creditar]
--FROM DADOSNOTANFE DN 
--	JOIN NFENTRACAD NF ON DN.NUMORD = NF.numord 
--	JOIN DADOSITEMNFE DI ON DI.NUMORD = NF.numord 
--	JOIN CFOENTRCAD CF ON CF.numord = NF.NUMORD
--	JOIN FILIALCAD F ON NF.FILIAL = F.FILIAL 
--WHERE NF.ATUALIZ = 1 
--	AND NF.DTCANCEL IS NULL 
--	AND DN.vICMSUFDest > 0 
--	AND NF.FILIAL = @filial
--	AND NF.dtemis >= @DataInicial
--	AND NF.DTEMIS <= @DataFinal
--GROUP BY 	DI.CPROD,	DI.NCM,	DI.XPROD,	DI.UTRIB
ORDER BY 1, DI.XPROD


	

   
