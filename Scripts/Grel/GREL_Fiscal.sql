/*
AUTOR: ELMO M. DE SOUZA J�NIOR
DATA: 25/03/2014
FINALIDADE: RELAT�RIO PARA CONFER�NCIA DAS NOTAS DE ENTRADAS E OUTRAS ENTRADAS

*********************************************************************
FORNECEDOR.........................: FORNECEDOR.
FILIAL.............................: FILIAL DE ENTRADA DA NF.
DTCHEG.............................: DATA DE CHEGADA DA NF.
NF.................................: NO. DA NOTA FISCAL.
VALCONTAB..........................: PRE�O DE NOTA FISCAL X QTDE.
TPO................................: TIPO DE OPERA��O DE ENTRADA.

*/

GO
DROP VIEW GREL_FISCAL
GO

CREATE VIEW GREL_FISCAL AS
SELECT
	FORN.NOME AS FORNECEDOR,
	NF.FILIAL AS FILIAL,
	NF.DTCHEG AS DTCHEG,	
	NF.NUMNOTA AS NF, 
	CAST(NF.VALCONTAB AS NUMERIC(18,2)) AS VALCONTAB,
	TPO.NOME AS TPO
FROM 
	NFENTRACAD NF, 
	FORNECEDOR_R FORN,
	TPO_R TPO
WHERE 
	NF.codfor = FORN.OID
	AND	NF.TPO = TPO.HIERARQUIANUMERO
	AND NF.ATUALIZ = 1
	AND NF.INTEGRADO = 1     
	AND (NF.TPO LIKE '1%' OR NF.TPO LIKE '7%')
	AND TPO.OID IN
	(SELECT RTPO FROM TPOINTERFERENCIA_R WHERE RTPOINTEGRACAO IN (15890,16593,30308,30309)
	AND VALOR NOT IN ('1152','1408','2152','2408') AND (VALOR LIKE '1%' OR VALOR LIKE '2%'))
	
GO

DELETE FROM GREL_PADRAO_DETALHE WHERE GREL_PADRAO_DETALHE.COD_PADRAO IN 
(SELECT COD_PADRAO FROM GREL_PADRAO WHERE GREL_PADRAO.DSC_PADRAO='GREL_FISCAL')

GO
DELETE FROM GREL_MODELO WHERE GREL_MODELO.COD_PADRAO IN 
(SELECT COD_PADRAO FROM GREL_PADRAO WHERE GREL_PADRAO.DSC_PADRAO='GREL_FISCAL')

GO
DELETE FROM GREL_PADRAO WHERE DSC_PADRAO = 'GREL_FISCAL'
GO

IF NOT EXISTS(SELECT DSC_PADRAO FROM GREL_PADRAO WHERE DSC_PADRAO = 'GREL_FISCAL')
BEGIN

   INSERT INTO GREL_PADRAO (DSC_PADRAO) VALUES ('GREL_FISCAL')

   INSERT INTO GREL_PADRAO_DETALHE(COD_PADRAO,NOM_CAMPO_REAL,NOM_CAMPO_EXIBICAO,NOM_TABELA,FLG_TABELA_TIPO,NOM_CAMPO_RELACIONAMENTO,
   NOM_TABELA_RELACIONAMENTO,NUM_CAMPO_LARGURA_EXIBIR,FLG_CAMPO_EXIBIR,FLG_CAMPO_TIPO)
   SELECT COD_PADRAO,'A.FORNECEDOR','FORNECEDOR','GREL_FISCAL A',1,'','','',1,2
   FROM GREL_PADRAO WHERE DSC_PADRAO = 'GREL_FISCAL'
   
   INSERT INTO GREL_PADRAO_DETALHE(COD_PADRAO,NOM_CAMPO_REAL,NOM_CAMPO_EXIBICAO,NOM_TABELA,FLG_TABELA_TIPO,NOM_CAMPO_RELACIONAMENTO,
   NOM_TABELA_RELACIONAMENTO,NUM_CAMPO_LARGURA_EXIBIR,FLG_CAMPO_EXIBIR,FLG_CAMPO_TIPO)
   SELECT COD_PADRAO,'A.FILIAL','FILIAL','GREL_FISCAL A',1,'','','',1,2
   FROM GREL_PADRAO WHERE DSC_PADRAO = 'GREL_FISCAL'

   INSERT INTO GREL_PADRAO_DETALHE(COD_PADRAO,NOM_CAMPO_REAL,NOM_CAMPO_EXIBICAO,NOM_TABELA,FLG_TABELA_TIPO,NOM_CAMPO_RELACIONAMENTO,
   NOM_TABELA_RELACIONAMENTO,NUM_CAMPO_LARGURA_EXIBIR,FLG_CAMPO_EXIBIR,FLG_CAMPO_TIPO)
   SELECT COD_PADRAO,'A.DTCHEG','DATA_CHEGADA','GREL_FISCAL A',1,'','','',1,3
   FROM GREL_PADRAO WHERE DSC_PADRAO = 'GREL_FISCAL'

   INSERT INTO GREL_PADRAO_DETALHE(COD_PADRAO,NOM_CAMPO_REAL,NOM_CAMPO_EXIBICAO,NOM_TABELA,FLG_TABELA_TIPO,NOM_CAMPO_RELACIONAMENTO,
   NOM_TABELA_RELACIONAMENTO,NUM_CAMPO_LARGURA_EXIBIR,FLG_CAMPO_EXIBIR,FLG_CAMPO_TIPO)
   SELECT COD_PADRAO,'A.NF','NOTA_FISCAL','GREL_FISCAL A',1,'','','',1,2
   FROM GREL_PADRAO WHERE DSC_PADRAO = 'GREL_FISCAL'
          
   INSERT INTO GREL_PADRAO_DETALHE(COD_PADRAO,NOM_CAMPO_REAL,NOM_CAMPO_EXIBICAO,NOM_TABELA,FLG_TABELA_TIPO,NOM_CAMPO_RELACIONAMENTO,
   NOM_TABELA_RELACIONAMENTO,NUM_CAMPO_LARGURA_EXIBIR,FLG_CAMPO_EXIBIR,FLG_CAMPO_TIPO)
   SELECT COD_PADRAO,'A.VALCONTAB','VALOR_CONTABIL','GREL_FISCAL A',1,'','','',1,4
   FROM GREL_PADRAO WHERE DSC_PADRAO = 'GREL_FISCAL'
   
   INSERT INTO GREL_PADRAO_DETALHE(COD_PADRAO,NOM_CAMPO_REAL,NOM_CAMPO_EXIBICAO,NOM_TABELA,FLG_TABELA_TIPO,NOM_CAMPO_RELACIONAMENTO,
   NOM_TABELA_RELACIONAMENTO,NUM_CAMPO_LARGURA_EXIBIR,FLG_CAMPO_EXIBIR,FLG_CAMPO_TIPO)
   SELECT COD_PADRAO,'A.TPO','TPO','GREL_FISCAL A',1,'','','',1,2
   FROM GREL_PADRAO WHERE DSC_PADRAO = 'GREL_FISCAL'

END
