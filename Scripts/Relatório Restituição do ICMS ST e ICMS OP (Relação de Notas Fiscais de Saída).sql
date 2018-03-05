-- Restituição do ICMS ST e ICMS OP
-- Relação de Notas Fiscais de Saída
-------------------------------------------------------------------------------------------------------------------------------

Declare @DataInicial datetime, @DataFinal datetime, @filial char(02)
set @DataInicial	= '20170401'
set @DataFinal		= '20170430'
set @filial			= '01'

--SAIDA
-------------------------------------------------------------
SELECT
	NF.NUMNOTA,
	convert(varchar,NF.DTEMIS,103) AS [DATA EMISSAO],
	CF.CFO,
	DN.XNOMED,
	DN.UFD,
	CASE WHEN AD.SVALOR IS NULL THEN '' ELSE AD.SVALOR END AS [INSCRIÇÃO ESTADUAL],
	CASE WHEN PE.IDENTIFICADOR IS NULL THEN '' ELSE PE.IDENTIFICADOR END AS [CPF/CNPJ]
FROM DADOSNOTANFE DN 
	JOIN NFSAIDACAD NF ON DN.NUMORD = NF.numord 
	JOIN CFOSAIDCAD CF ON CF.numord = NF.NUMORD
	JOIN FILIALCAD F ON NF.FILIAL = F.FILIAL 
	LEFT JOIN ADITIVO_R AD ON AD.RITEM = nf.codclie AND AD.RDEFINICAO = 3009
	LEFT JOIN PESSOA_R PE on nf.codclie = PE.oid
	LEFT JOIN ESTADOSCAD UF ON DN.UFD = UF.sigla 
WHERE NF.ATUALIZ = 1 
	AND NF.DTCANCEL IS NULL 
	AND DN.vICMSUFDest > 0 
	AND NF.FILIAL = @filial	
	AND NF.dtemis >= @DataInicial
	AND NF.DTEMIS <= @DataFinal
		
--UNION ALL 
--ENTRADA
-------------------------------------------------------------
--SELECT
--	NF.filial,
--	NF.NUMNOTA,
--	convert(varchar,NF.DTEMIS,103) AS [DATA EMISSAO],
--	CF.CFO,
--	DN.XNOMED,
--	DN.UFD,
--	CASE WHEN AD.SVALOR IS NULL THEN '' ELSE AD.SVALOR END AS [INSCRIÇÃO ESTADUAL],
--	CASE WHEN PE.IDENTIFICADOR IS NULL THEN '' ELSE PE.IDENTIFICADOR END AS [CPF/CNPJ]
--FROM DADOSNOTANFE DN 
--	JOIN NFENTRACAD NF ON DN.NUMORD = NF.numord 
--	JOIN CFOENTRCAD CF ON CF.numord = NF.NUMORD
--	JOIN FILIALCAD F ON NF.FILIAL = F.FILIAL 
--	LEFT JOIN ADITIVO_R AD ON AD.RITEM = nf.codfor AND AD.RDEFINICAO = 3009
--	LEFT JOIN PESSOA_R PE on nf.codfor = PE.oid
--	LEFT JOIN ESTADOSCAD UF ON DN.UFD = UF.sigla 
--WHERE NF.ATUALIZ = 1 
--	AND NF.DTCANCEL IS NULL 
--	AND DN.vICMSUFDest > 0 
--	AND NF.FILIAL = @filial
--	AND NF.dtemis >= @DataInicial
--	AND NF.DTEMIS <= @DataFinal
ORDER BY NF.filial,convert(varchar,NF.DTEMIS,103),NF.NUMNOTA
   