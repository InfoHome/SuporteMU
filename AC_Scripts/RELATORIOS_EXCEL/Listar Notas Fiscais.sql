----------------------------------------------------------------------------------------
-- Orienta��es
-- Este relat�rio alimenta a planilha: PLANILHA NF E NAF PREFEITURA (AJ).xlsx
-- Local: \\AC01FS01\Contabil\CONTABIL MICHELLE
----------------------------------------------------------------------------------------
ALTER VIEW AC_REL_NOTAS_FISCAIS
AS 
-- SAIDA --------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
SELECT 
	FIL.NOME AS EMITENTE,
	DN.XNOMED AS DESTINATARIO,
	'S' AS TIPO,
	N.NUMNOTA,
	N.SERIE,
	YEAR(N.DTEMIS) AS ANO,
	MONTH(N.DTEMIS) AS MES,
	N.DTCANCEL AS [DATA CANCELAMENTO],
	T.CODIGO + ' -' + T.NOME AS TPO,
	Case 
		when cpl.SITUACAONFE = 'A' then 'Envio - Falha de Comunica��o' 
		when cpl.SITUACAONFE = 'C' then 'Envio - Sem Retorno' 
		when cpl.SITUACAONFE = 'B' then 'Envio - Com rejei��o' 
		when cpl.SITUACAONFE = '1' then 'Envio - Aguardando Envio P/SEFAZ' 
		when cpl.SITUACAONFE = '6' then 'Envio - Aguardando Processamento Retaguarda' 
		when cpl.SITUACAONFE = '2' then 'Envio - Em Processamento na SEFAZ' 
		when cpl.SITUACAONFE = 'R' then 'Envio - Processado com Sucesso' 

		when cpl.SITUACAONFE = 'J' then 'Cancelamento - Falha de Comunica��o' 
		when cpl.SITUACAONFE = 'K' then 'Cancelamento - Sem Retorno' 
		when cpl.SITUACAONFE IN ('P','N') then 'Cancelamento - Com rejei��o' 
		when cpl.SITUACAONFE = '4' then 'Cancelamento - Aguardando Envio P/SEFAZ' 
		when cpl.SITUACAONFE = '8' then 'Cancelamento - Aguardando Processamento Retaguarda' 
		when cpl.SITUACAONFE = 'X' then 'Cancelamento - Em Processamento na SEFAZ' 
		when cpl.SITUACAONFE = 'S' then 'Cancelamento - Processado com Sucesso' 

		when cpl.SITUACAONFE = 'H' then 'Conting�ncia - Falha de Comunica��o' 
		when cpl.SITUACAONFE = 'E' then 'Conting�ncia - Sem Retorno' 
		when cpl.SITUACAONFE = 'G' then 'Conting�ncia - Com rejei��o' 
		when cpl.SITUACAONFE = '5' then 'Conting�ncia - Aguardando Envio P/SEFAZ' 
		when cpl.SITUACAONFE = '9' then 'Conting�ncia - Aguardando Processamento Retaguarda' 
		when cpl.SITUACAONFE = 'Z' then 'Conting�ncia - Em Processamento na SEFAZ' 
		when cpl.SITUACAONFE = 'V' then 'Conting�ncia - Processado com Sucesso' 

		when cpl.SITUACAONFE = 'L' then 'Inutiliza��o - Falha de Comunica��o' 
		when cpl.SITUACAONFE = 'M' then 'Inutiliza��o - Sem Retorno' 
		when cpl.SITUACAONFE = 'Q' then 'Inutiliza��o - Com rejei��o' 
		when cpl.SITUACAONFE = '3' then 'Inutiliza��o - Aguardando Envio P/SEFAZ' 
		when cpl.SITUACAONFE = '7' then 'Inutiliza��o - Aguardando Processamento Retaguarda' 
		when cpl.SITUACAONFE = 'Y' then 'Inutiliza��o - Em Processamento na SEFAZ' 
		when cpl.SITUACAONFE = 'T' then 'Inutiliza��o - Processado com Sucesso' 
		else 'Sem situacao NFE' 	end AS FATURAMENTO
FROM NFSAIDACAD N JOIN ITEM CLI ON N.CODCLIE = CLI.OID 
					--AND NOME LIKE '%PREFEITURA%'
	JOIN TPO_R T ON T.HIERARQUIANUMERO = N.TPO
	JOIN COMPLEMENTONFSAIDA CPL ON CPL.NUMORD = N.NUMORD
	JOIN DADOSNOTANFE DN ON DN.NUMORD = N.NUMORD
	JOIN FILIALCAD FIL ON DN.CNPJ = replace(replace(replace(fil.cgc,'/',''),'.',''),'-','')
WHERE 
	LIF = 1 
	AND N.modelonf = '55'
	

-- ENTRADA --------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
UNION SELECT 
	FIL.NOME AS EMITENTE,
	DN.XNOMED AS DESTINATARIO,
	'E' AS TIPO,
	N.NUMNOTA,
	N.SERIE,
	YEAR(N.DTCHEG) AS ANO,
	MONTH(N.DTCHEG) AS MES,
	N.DTCANCEL AS [DATA CANCELAMENTO],
	T.CODIGO + ' -' + T.NOME AS TPO,
	Case 
		when cpl.SITUACAONFE = 'A' then 'Envio - Falha de Comunica��o' 
		when cpl.SITUACAONFE = 'C' then 'Envio - Sem Retorno' 
		when cpl.SITUACAONFE = 'B' then 'Envio - Com rejei��o' 
		when cpl.SITUACAONFE = '1' then 'Envio - Aguardando Envio P/SEFAZ' 
		when cpl.SITUACAONFE = '6' then 'Envio - Aguardando Processamento Retaguarda' 
		when cpl.SITUACAONFE = '2' then 'Envio - Em Processamento na SEFAZ' 
		when cpl.SITUACAONFE = 'R' then 'Envio - Processado com Sucesso' 
		when cpl.SITUACAONFE = 'J' then 'Cancelamento - Falha de Comunica��o' 
		when cpl.SITUACAONFE = 'K' then 'Cancelamento - Sem Retorno' 
		when cpl.SITUACAONFE IN ('P','N') then 'Cancelamento - Com rejei��o' 
		when cpl.SITUACAONFE = '4' then 'Cancelamento - Aguardando Envio P/SEFAZ' 
		when cpl.SITUACAONFE = '8' then 'Cancelamento - Aguardando Processamento Retaguarda' 
		when cpl.SITUACAONFE = 'X' then 'Cancelamento - Em Processamento na SEFAZ' 
		when cpl.SITUACAONFE = 'S' then 'Cancelamento - Processado com Sucesso' 
		when cpl.SITUACAONFE = 'H' then 'Conting�ncia - Falha de Comunica��o' 
		when cpl.SITUACAONFE = 'E' then 'Conting�ncia - Sem Retorno' 
		when cpl.SITUACAONFE = 'G' then 'Conting�ncia - Com rejei��o' 
		when cpl.SITUACAONFE = '5' then 'Conting�ncia - Aguardando Envio P/SEFAZ' 
		when cpl.SITUACAONFE = '9' then 'Conting�ncia - Aguardando Processamento Retaguarda' 
		when cpl.SITUACAONFE = 'Z' then 'Conting�ncia - Em Processamento na SEFAZ' 
		when cpl.SITUACAONFE = 'V' then 'Conting�ncia - Processado com Sucesso' 
		when cpl.SITUACAONFE = 'L' then 'Inutiliza��o - Falha de Comunica��o' 
		when cpl.SITUACAONFE = 'M' then 'Inutiliza��o - Sem Retorno' 
		when cpl.SITUACAONFE = 'Q' then 'Inutiliza��o - Com rejei��o' 
		when cpl.SITUACAONFE = '3' then 'Inutiliza��o - Aguardando Envio P/SEFAZ' 
		when cpl.SITUACAONFE = '7' then 'Inutiliza��o - Aguardando Processamento Retaguarda' 
		when cpl.SITUACAONFE = 'Y' then 'Inutiliza��o - Em Processamento na SEFAZ' 
		when cpl.SITUACAONFE = 'T' then 'Inutiliza��o - Processado com Sucesso' 
		else 'Sem situacao NFE'	end AS FATURAMENTO
FROM NFENTRACAD N JOIN ITEM CLI ON N.CODFOR = CLI.OID 
					--AND NOME LIKE '%PREFEITURA%'
	JOIN TPO_R T ON T.HIERARQUIANUMERO = N.TPO
	JOIN COMPLEMENTONFENTRA CPL ON CPL.NUMORD = N.NUMORD
	JOIN DADOSNOTANFE DN ON DN.NUMORD = N.NUMORD
	JOIN FILIALCAD FIL ON DN.CNPJ = replace(replace(replace(fil.cgc,'/',''),'.',''),'-','')
WHERE 
	LIF = 1 
	AND N.modelonf = '55'
