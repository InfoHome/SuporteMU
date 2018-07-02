USE [WEB_DESENV]
GO

/****** Object:  StoredProcedure [dbo].[CARGA_BI_CATEGORIA_REDE]    Script Date: 28/05/2018 15:30:36 ******/
-- ATUALIZAR CARGA
-- EXEC CARGA_BI_CATEGORIA_REDE
/***------------------------------------------------------------***/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CARGA_BI_CATEGORIA_REDE]            
            
AS            
BEGIN            
            
BEGIN TRANSACTION     
TRUNCATE TABLE NIVEL7_AC_REDE            
TRUNCATE TABLE NIVEL6_AC_REDE            
TRUNCATE TABLE NIVEL5_AC_REDE            
TRUNCATE TABLE NIVEL4_AC_REDE            
TRUNCATE TABLE NIVEL3_AC_REDE            
TRUNCATE TABLE NIVEL2_AC_REDE            
TRUNCATE TABLE NIVEL1_AC_REDE            
TRUNCATE TABLE TAB_NIVEL7_AC_REDE            
TRUNCATE TABLE TAB_NIVEL6_AC_REDE            
TRUNCATE TABLE TAB_NIVEL5_AC_REDE            
TRUNCATE TABLE TAB_NIVEL4_AC_REDE            
TRUNCATE TABLE TAB_NIVEL3_AC_REDE            
TRUNCATE TABLE TAB_NIVEL2_AC_REDE            
TRUNCATE TABLE TAB_NIVEL1_AC_REDE            
COMMIT            
             
            
BEGIN TRANSACTION            
/* --- VENDAS COM PEDIDO */            
INSERT INTO NIVEL7_AC_REDE            
SELECT   RIGHT('00000' + LTRIM(RTRIM( ITPD.CODPRO )),5),            
         SUBSTRING(CONVERT(VARCHAR,VEN.DTVEN,103) ,7,4) + SUBSTRING(CONVERT(VARCHAR,VEN.DTVEN,103),4,2) + SUBSTRING(CONVERT(VARCHAR,VEN.DTVEN,103) ,1,2),            
         PED.FILIAL,            
         RIGHT('00000' + LTRIM(RTRIM( PED.CODVEND )),5),            
         RIGHT('0000000000' + LTRIM(RTRIM( PROD.CODFOR )),10),            
         RIGHT('0000000000' + LTRIM(RTRIM( PED.CODCLIE )),10),            
         SUBSTRING(PROD.CLASPROD,1,12),
         CONVERT(DATETIME,convert(char,VEN.DTVEN,103),103) ,'1',            
         SUM(ITPD.QUANT),            
         SUM(ITPD.PRECO*ITPD.QUANT*( 1 + (PED.OUTRASDESPESASINCLUSAS+PED.FRETEORC - PED.DESCONTO)/(PED.VALPED + PED.DESCONTO-PED.FRETEORC-PED.OUTRASDESPESASINCLUSAS))),  
         SUM(ITPD.PRECOUNITORIG*ITPD.QUANT*( 1 + (PED.OUTRASDESPESASINCLUSAS+PED.FRETEORC)/(PED.VALPED -PED.FRETEORC-PED.OUTRASDESPESASINCLUSAS))),            
         SUM(ITPD.PRECOCOMP*ITPD.QUANT),            
         SUM(PROD.PRECOCOMP*ITPD.QUANT),            
         0,0,0            
FROM   BDENTER.DBO.VENDASSCAD VEN,            
       BDENTER.DBO.PEDICLICAD PED,    
       BDENTER.DBO.ITEMCLICAD ITPD,             
       BDENTER.DBO.PRODUTOCAD PROD         
WHERE  VEN.DTVEN >= '20140101'   
  AND VEN.NUMPED > 7   
  AND VEN.NUMPED = PED.NUMPED   
  AND PED.NUMPED = ITPD.NUMPED   
  AND ITPD.NUMPEDFILIAL = 0   
  AND ITPD.PRECO > 0   
  AND PED.VALPED > 0   
  AND PROD.CODPRO = ITPD.CODPRO    
  AND (PED.VALPED + PED.DESCONTO) > 0   
  AND itpd.sitfat in (0,1)   
  AND PED.TPO LIKE '2%'            
 GROUP BY RIGHT('00000' + LTRIM(RTRIM( ITPD.CODPRO )),5),            
         SUBSTRING(CONVERT(VARCHAR,VEN.DTVEN,103) ,7,4) + SUBSTRING(CONVERT(VARCHAR,VEN.DTVEN,103),4,2) + SUBSTRING(CONVERT(VARCHAR,VEN.DTVEN,103) ,1,2),            
         PED.FILIAL,            
         RIGHT('00000' + LTRIM(RTRIM( PED.CODVEND )),5),            
         RIGHT('0000000000' + LTRIM(RTRIM( PROD.CODFOR )),10),             
         RIGHT('0000000000' + LTRIM(RTRIM( PED.CODCLIE )),10),            
         SUBSTRING(PROD.CLASPROD,1,12),        
   CONVERT(DATETIME,convert(char,VEN.DTVEN,103),103)             
COMMIT            
            
BEGIN TRANSACTION            
/* ----- VENDAS SEM PEDIDOS COM CIDADE---- */            
INSERT INTO NIVEL7_AC_REDE            
SELECT   RIGHT('00000' + LTRIM(RTRIM( ITNF.CODPRO )),5),            
         SUBSTRING(CONVERT(VARCHAR,VEN.DTVEN,103) ,7,4) + SUBSTRING(CONVERT(VARCHAR,VEN.DTVEN,103),4,2) + SUBSTRING(CONVERT(VARCHAR,VEN.DTVEN,103) ,1,2),            
         NF.FILIAL,            
         RIGHT('00000' + LTRIM(RTRIM( NF.CODVEND )),5),            
         RIGHT('0000000000' + LTRIM(RTRIM( PROD.CODFOR )),10),             
         RIGHT('0000000000' + LTRIM(RTRIM( NF.CODCLIE )),10),            
         SUBSTRING(PROD.CLASPROD,1,12),        
         CONVERT(DATETIME,convert(char,VEN.DTVEN,103),103),'2',            
         SUM( ITNF.QUANT),           
         SUM(ITNF.QUANT*ITNF.PRECO* ( 1 + (NF.VALFRETE - NF.DESCONTO)/(NF.VALCONTAB + NF.DESCONTO - NF.VALFRETE))),  
         SUM(ITNF.QUANT*ITNF.PRECOTAB* ( 1 + (NF.VALFRETE )/(NF.VALCONTAB  - NF.VALFRETE))),         
         SUM(ITNF.QUANT*ITNF.CUSTVEN),            
         SUM(ITNF.QUANT*PROD.PRECOCOMP),            
         0,0,0            
FROM    BDENTER.DBO.VENDASSCAD VEN,            
        BDENTER.DBO.NFSAIDACAD NF,     
        BDENTER.DBO.ITNFSAICAD ITNF,             
        BDENTER.DBO.PRODUTOCAD PROD         
WHERE  VEN.DTVEN >= '20140101' AND VEN.NUMPED <= 7 AND VEN.NUMORD = NF.NORDVEN   
    AND NF.ATUALIZ = 1 AND NF.EST IN (2,3)            
       AND LEFT(NF.TPO,1) = '2' AND NF.NUMORD = ITNF.NUMORD    
       AND  ITNF.CODPRO= PROD.CODPRO AND NF.DTCANCEL IS NULL             
       AND NF.VALCONTAB > 0           
GROUP BY RIGHT('00000' + LTRIM(RTRIM( ITNF.CODPRO )),5),            
         SUBSTRING(CONVERT(VARCHAR,VEN.DTVEN,103) ,7,4) + SUBSTRING(CONVERT(VARCHAR,VEN.DTVEN,103),4,2) + SUBSTRING(CONVERT(VARCHAR,VEN.DTVEN,103) ,1,2),            
         NF.FILIAL,            
         RIGHT('00000' + LTRIM(RTRIM( NF.CODVEND )),5),            
         RIGHT('0000000000' + LTRIM(RTRIM( PROD.CODFOR )),10),             
         RIGHT('0000000000' + LTRIM(RTRIM( NF.CODCLIE )),10),            
         SUBSTRING(PROD.CLASPROD,1,12),        
         CONVERT(DATETIME,convert(char,VEN.DTVEN,103),103)            
COMMIT            
            
BEGIN TRANSACTION            
/* ----- Devoluo vinculada a nota de venda COM COMPLNFFAT */            
INSERT INTO NIVEL7_AC_REDE            
SELECT   RIGHT('00000' + LTRIM(RTRIM( ITNE.CODPRO )),5),            
         SUBSTRING(CONVERT(VARCHAR,NE.DTCHEG,103) ,7,4) + SUBSTRING(CONVERT(VARCHAR,NE.DTCHEG,103),4,2) + SUBSTRING(CONVERT(VARCHAR,NE.DTCHEG,103) ,1,2),            
         CASE WHEN VEN.FILIAL IS NULL THEN NF.FILIAL ELSE VEN.FILIAL END,            
         RIGHT('00000' + LTRIM(RTRIM( NF.CODVEND )),5),            
         RIGHT('0000000000' + LTRIM(RTRIM( PROD.CODFOR )),10),             
         RIGHT('0000000000' + LTRIM(RTRIM( NE.CODFOR )),10),            
		 SUBSTRING(PROD.CLASPROD,1,12),        
         CONVERT(DATETIME,convert(char,NE.DTCHEG,103),103) ,'4',            
         0,0,0,0,0,            
         SUM(CONVERT(FLOAT, ITNE.QUANT)),            
         SUM(CONVERT(FLOAT, ((ITNE.QUANT*ITNE.PRECO+ITNE.VALORIPI)-ITNE.VALDESC) * ( 1 - NE.DESCONTO/(NE.VALCONTAB + NE.DESCONTO)))),            
         SUM(CONVERT(FLOAT, ITNE.QUANT*ITNE.CUSTVEN))            
      FROM  BDENTER.DBO.NFENTRACAD NE, BDENTER.DBO.ITNFENTCAD ITNE, BDENTER.DBO.NFSAIDACAD NF,            
      BDENTER.DBO.PRODUTOCAD PROD, BDENTER.DBO.VENDEDOCAD VEN    
WHERE NE.DTCHEG >= '20140101' AND NE.ATUALIZ = 1 AND ITNE.CODVEND = VEN.CODVEND AND    
      NE.NUMORD = ITNE.NUMORD AND ITNE.NUMORDDEV = NF.NUMORD    
      AND NE.EST IN (1,2,3) AND ITNE.CODPRO = PROD.CODPRO AND NE.TPO LIKE '6%'   
      AND NE.VALCONTAB > 0           
GROUP BY RIGHT('00000' + LTRIM(RTRIM( ITNE.CODPRO )),5),            
         SUBSTRING(CONVERT(VARCHAR,NE.DTCHEG,103) ,7,4) + SUBSTRING(CONVERT(VARCHAR,NE.DTCHEG,103),4,2) + SUBSTRING(CONVERT(VARCHAR,NE.DTCHEG,103) ,1,2),            
         CASE WHEN VEN.FILIAL IS NULL THEN NF.FILIAL ELSE VEN.FILIAL END,                  
         RIGHT('00000' + LTRIM(RTRIM( NF.CODVEND )),5),            
         RIGHT('0000000000' + LTRIM(RTRIM( PROD.CODFOR )),10),             
         RIGHT('0000000000' + LTRIM(RTRIM( NE.CODFOR )),10),            
		 SUBSTRING(PROD.CLASPROD,1,12),       
         CONVERT(DATETIME,convert(char,NE.DTCHEG,103),103)            
COMMIT            
          
BEGIN TRANSACTION            
---- devuluo no vinculada  nota de venda  com registro em complnffat            
INSERT INTO NIVEL7_AC_REDE            
SELECT   RIGHT('00000' + LTRIM(RTRIM( ITNE.CODPRO )),5),            
         SUBSTRING(CONVERT(VARCHAR,NE.DTCHEG,103) ,7,4) + SUBSTRING(CONVERT(VARCHAR,NE.DTCHEG,103),4,2) + SUBSTRING(CONVERT(VARCHAR,NE.DTCHEG,103) ,1,2),            
         CASE WHEN VEN.FILIAL IS NULL THEN NE.FILIAL ELSE VEN.FILIAL END,            
         RIGHT('00000' + LTRIM(RTRIM( ITNE.CODVEND )),5),            
         RIGHT('0000000000' + LTRIM(RTRIM( PROD.CODFOR )),10),            
         RIGHT('0000000000' + LTRIM(RTRIM( NE.CODFOR )),10),            
		 SUBSTRING(PROD.CLASPROD,1,12),        
         CONVERT(DATETIME,convert(char,NE.DTCHEG,103),103) ,'6',            
         0,0,0,0,0,            
         SUM(CONVERT(FLOAT, ITNE.QUANT)),            
         SUM(CONVERT(FLOAT, ((ITNE.QUANT*ITNE.PRECO+ITNE.VALORIPI)-ITNE.VALDESC) * ( 1 - NE.DESCONTO/(NE.VALCONTAB + NE.DESCONTO)))),            
         SUM(CONVERT(FLOAT, ITNE.QUANT*ITNE.CUSTVEN))    
FROM  BDENTER.DBO.NFENTRACAD NE, BDENTER.DBO.ITNFENTCAD ITNE,    
      BDENTER.DBO.PRODUTOCAD PROD, BDENTER.DBO.VENDEDOCAD VEN    
WHERE NE.DTCHEG >= '20140101' AND NE.ATUALIZ = 1 AND ITNE.CODVEND = VEN.CODVEND            
      AND NE.NUMORD = ITNE.NUMORD    
      AND ITNE.NUMORDDEV = 0 AND NE.EST IN (2,3)   
      AND ITNE.CODPRO = PROD.CODPRO AND NE.TPO LIKE '6%'  
      AND NE.VALCONTAB > 0  
GROUP BY RIGHT('00000' + LTRIM(RTRIM( ITNE.CODPRO )),5),            
         SUBSTRING(CONVERT(VARCHAR,NE.DTCHEG,103) ,7,4) + SUBSTRING(CONVERT(VARCHAR,NE.DTCHEG,103),4,2) + SUBSTRING(CONVERT(VARCHAR,NE.DTCHEG,103) ,1,2),            
         CASE WHEN VEN.FILIAL IS NULL THEN NE.FILIAL ELSE VEN.FILIAL END,            
         RIGHT('00000' + LTRIM(RTRIM( ITNE.CODVEND )),5),            
         RIGHT('0000000000' + LTRIM(RTRIM( PROD.CODFOR )),10),            
         RIGHT('0000000000' + LTRIM(RTRIM( NE.CODFOR )),10),            
		 SUBSTRING(PROD.CLASPROD,1,12),        
         CONVERT(DATETIME,convert(char,NE.DTCHEG,103),103)             
COMMIT         


--=======================================================================================================  
BEGIN TRANSACTION            
INSERT INTO nivel6_AC_REDE SELECT NIVEL6, NIVEL1, NIVEL2, NIVEL3,NIVEL4,NIVEL5,DATA , SUM( ATR1 ),            
                          SUM( ATR2 ), SUM( ATR3 ), SUM( ATR4 ), SUM( ATR5 ), SUM( ATR6 ), SUM( ATR7 ), SUM( ATR8 )            
                      FROM NIVEL7_AC_REDE            
                      GROUP BY NIVEL6, NIVEL1, NIVEL2, NIVEL3, NIVEL4, NIVEL5,DATA ;            
COMMIT            
            
BEGIN TRANSACTION            
INSERT INTO nivel5_AC_REDE SELECT NIVEL5, NIVEL1, NIVEL2, NIVEL3,NIVEL4,DATA , SUM( ATR1 ),            
                          SUM( ATR2 ), SUM( ATR3 ), SUM( ATR4 ), SUM( ATR5 ), SUM( ATR6 ), SUM( ATR7 ), SUM( ATR8 )            
                      FROM nivel6_AC_REDE            
                      GROUP BY NIVEL5, NIVEL1, NIVEL2, NIVEL3, NIVEL4, DATA ;            
COMMIT            
            
BEGIN TRANSACTION            
INSERT INTO nivel4_AC_REDE SELECT NIVEL4, NIVEL1, NIVEL2, NIVEL3,DATA , SUM( ATR1 ),            
                          SUM( ATR2 ), SUM( ATR3 ), SUM( ATR4 ), SUM( ATR5 ), SUM( ATR6 ), SUM( ATR7 ), SUM( ATR8 )            
                      FROM nivel5_AC_REDE            
                      GROUP BY NIVEL4, NIVEL1, NIVEL2, NIVEL3, DATA ;            
COMMIT            
            
BEGIN TRANSACTION            
INSERT INTO nivel3_AC_REDE SELECT NIVEL3, NIVEL1, NIVEL2, DATA , SUM( ATR1 ),            
                          SUM( ATR2 ), SUM( ATR3 ), SUM( ATR4 ), SUM( ATR5 ), SUM( ATR6 ), SUM( ATR7 ), SUM( ATR8 )            
                      FROM nivel4_AC_REDE            
                      GROUP BY NIVEL3, NIVEL1, NIVEL2, DATA ;            
COMMIT            
            
BEGIN TRANSACTION            
INSERT INTO nivel2_AC_REDE SELECT NIVEL2, NIVEL1, DATA , SUM( ATR1 ),            
                          SUM( ATR2 ), SUM( ATR3 ), SUM( ATR4 ), SUM( ATR5 ), SUM( ATR6 ), SUM( ATR7 ), SUM( ATR8 )            
                      FROM nivel3_AC_REDE            
                      GROUP BY NIVEL2, NIVEL1, DATA ;            
COMMIT            
            
BEGIN TRANSACTION            
INSERT INTO nivel1_AC_REDE SELECT NIVEL1, DATA , SUM( ATR1 ),            
                          SUM( ATR2 ), SUM( ATR3 ), SUM( ATR4 ), SUM( ATR5 ), SUM( ATR6 ), SUM( ATR7 ), SUM( ATR8 )            
                      FROM nivel2_AC_REDE            
                      GROUP BY NIVEL1, DATA ;            
COMMIT            
--==========================================================================================================================            
BEGIN TRANSACTION            
INSERT INTO tab_nivel1_AC_REDE (NIVEL1, DESCRICAO) SELECT DISTINCT NIVEL1, SUBSTRING(NIVEL1,7,2)+'/'+SUBSTRING(NIVEL1,5,2)+'/'+SUBSTRING(NIVEL1,1,4)            
                          FROM nivel1_AC_REDE            
                          WHERE NOT EXISTS (SELECT NIVEL1 FROM TAB_NIVEL1_AC_REDE WHERE            
                          TAB_NIVEL1_AC_REDE.NIVEL1=NIVEL1_AC_REDE.NIVEL1)            
COMMIT            
            
BEGIN TRANSACTION            
INSERT INTO tab_nivel2_AC_REDE (NIVEL2, DESCRICAO) SELECT DISTINCT NIVEL2, 'FILIAL ' + NIVEL2            
                          FROM nivel2_AC_REDE            
                          WHERE NOT EXISTS (SELECT NIVEL2 FROM TAB_NIVEL2_AC_REDE WHERE            
                          TAB_NIVEL2_AC_REDE.NIVEL2=NIVEL2_AC_REDE.NIVEL2)            
COMMIT            
            
BEGIN TRANSACTION            
INSERT INTO tab_nivel3_AC_REDE (NIVEL3, DESCRICAO) SELECT DISTINCT NIVEL3, 'VENDEDOR ' + NIVEL3            
                          FROM nivel3_AC_REDE            
                          WHERE NOT EXISTS (SELECT NIVEL3 FROM TAB_NIVEL3_AC_REDE WHERE            
                          TAB_NIVEL3_AC_REDE.NIVEL3=NIVEL3_AC_REDE.NIVEL3)            
COMMIT            
            
BEGIN TRANSACTION            
INSERT INTO tab_nivel4_AC_REDE (NIVEL4, DESCRICAO) SELECT DISTINCT NIVEL4, 'FORNECEDOR ' + NIVEL4            
                          FROM nivel4_AC_REDE            
                          WHERE NOT EXISTS (SELECT NIVEL4 FROM TAB_NIVEL4_AC_REDE WHERE            
                          TAB_NIVEL4_AC_REDE.NIVEL4=NIVEL4_AC_REDE.NIVEL4)            
COMMIT            
            
BEGIN TRANSACTION            
INSERT INTO tab_nivel5_AC_REDE (NIVEL5, DESCRICAO) SELECT DISTINCT NIVEL5, 'CLIENTE ' + NIVEL5            
                          FROM nivel5_AC_REDE            
                          WHERE NOT EXISTS (SELECT NIVEL5 FROM TAB_NIVEL5_AC_REDE WHERE            
                          TAB_NIVEL5_AC_REDE.NIVEL5=NIVEL5_AC_REDE.NIVEL5)            
COMMIT            
            
BEGIN TRANSACTION            
INSERT INTO tab_NIVEL6_AC_REDE (NIVEL6, DESCRICAO) SELECT DISTINCT NIVEL6, 'CATEGORIA ' + NIVEL6            
                          FROM NIVEL6_AC_REDE            
                          WHERE NOT EXISTS (SELECT NIVEL6 FROM TAB_NIVEL6_AC_REDE WHERE            
                          TAB_NIVEL6_AC_REDE.NIVEL6=NIVEL6_AC_REDE.NIVEL6)            
COMMIT            
            
BEGIN TRANSACTION            
INSERT INTO TAB_NIVEL7_AC_REDE (NIVEL7, DESCRICAO) SELECT DISTINCT NIVEL7, 'PRODUTO ' + NIVEL7            
                          FROM NIVEL7_AC_REDE            
                          WHERE NOT EXISTS (SELECT NIVEL7 FROM TAB_NIVEL7_AC_REDE WHERE            
 TAB_NIVEL7_AC_REDE.NIVEL7=NIVEL7_AC_REDE.NIVEL7)            
COMMIT   


--================================================================================================================            
BEGIN TRANSACTION            
UPDATE TAB_NIVEL1_AC_REDE SET MES      = SUBSTRING ( NIVEL1,5,2) + '/' + LEFT(NIVEL1,4),            
        BIMESTRE = CASE SUBSTRING (NIVEL1, 5,2)             
                      WHEN '01' THEN '01' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '02' THEN '01' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '03' THEN '02' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '04' THEN '02' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '05' THEN '03' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '06' THEN '03' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '07' THEN '04' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '08' THEN '04' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '09' THEN '05' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '10' THEN '05' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '11' THEN '06' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '12' THEN '06' +  '/' + LEFT(NIVEL1,4)            
   END,            
        TRIMESTRE = CASE SUBSTRING (NIVEL1, 5,2)             
                      WHEN '01' THEN '01' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '02' THEN '01' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '03' THEN '01' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '04' THEN '02' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '05' THEN '02' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '06' THEN '02' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '07' THEN '03' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '08' THEN '03' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '09' THEN '03' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '10' THEN '04' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '11' THEN '04' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '12' THEN '04' +  '/' + LEFT(NIVEL1,4)            
   END,            
        QUADRIMESTRE  = CASE SUBSTRING (NIVEL1, 5,2)             
                      WHEN '01' THEN '01' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '02' THEN '01' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '03' THEN '01' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '04' THEN '01' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '05' THEN '02' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '06' THEN '02' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '07' THEN '02' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '08' THEN '02' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '09' THEN '03' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '10' THEN '03' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '11' THEN '03' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '12' THEN '03' +  '/' + LEFT(NIVEL1,4)            
   END,            
        SEMESTRE  = CASE SUBSTRING (NIVEL1, 5,2)             
                      WHEN '01' THEN '01' +  '/' + LEFT(NIVEL1,4)                              WHEN '02' THEN '01' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '03' THEN '01' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '04' THEN '01' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '05' THEN '01' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '06' THEN '01' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '07' THEN '02' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '08' THEN '02' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '09' THEN '02' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '10' THEN '02' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '11' THEN '02' +  '/' + LEFT(NIVEL1,4)            
                      WHEN '12' THEN '02' +  '/' + LEFT(NIVEL1,4)   END,            
   ANO = LEFT(NIVEL1,4),            
        DIAUTIL  = CASE DATEPART(DW,CONVERT(DATETIME,NIVEL1))             
                      WHEN '1' THEN 'N'            
                      WHEN '2' THEN 'S'             
                      WHEN '3' THEN 'S'             
                      WHEN '4' THEN 'S'             
                      WHEN '5' THEN 'S'             
                      WHEN '6' THEN 'S'             
                      WHEN '7' THEN 'N'             
   END            
COMMIT            
            
BEGIN TRANSACTION            
UPDATE TAB_NIVEL2_AC_REDE SET DESCRICAO =  upper(F.NOME)            
           FROM TAB_NIVEL2_AC_REDE, BDENTER.DBO.FILIALCAD F            
           WHERE NIVEL2 = F.FILIAL            
COMMIT            
            
BEGIN TRANSACTION            
UPDATE TAB_NIVEL3_AC_REDE SET DESCRICAO =  upper(V.NOME),             
             GERENTE = V.CODGER            
           FROM TAB_NIVEL3_AC_REDE, BDENTER.DBO.VENDEDOCAD V            
           WHERE NIVEL3 = RIGHT('00000' + LTRIM(RTRIM( V.CODVEND )),5)            
COMMIT            
            
BEGIN TRANSACTION            
UPDATE TAB_NIVEL3_AC_REDE SET GERENTE = V.nome            
           FROM TAB_NIVEL3_AC_REDE, BDENTER.DBO.VENDEDOCAD V            
           WHERE gerente =  V.CODVEND            
COMMIT            
    
BEGIN TRANSACTION            
UPDATE TAB_NIVEL4_AC_REDE SET DESCRICAO =  LEFT(upper(C.NOME),100)            
           FROM TAB_NIVEL4_AC_REDE, BDENTER.DBO.ITEM C            
           WHERE CAST(NIVEL4 AS INT) = C.OID            
COMMIT            
  
BEGIN TRANSACTION            
UPDATE TAB_NIVEL5_AC_REDE SET DESCRICAO =  LEFT(upper(C.NOME),100)            
           FROM TAB_NIVEL5_AC_REDE, BDENTER.DBO.ITEM C            
           WHERE CAST(NIVEL5 AS INT) = C.OID            
COMMIT            

BEGIN TRANSACTION            
UPDATE TAB_NIVEL6_AC_REDE SET DESCRICAO = LEFT(upper(DESCR),100)  
           FROM TAB_NIVEL6_AC_REDE, BDENTER.DBO.AC_GC_EXT_CLASPROD    -- CATEGORIA        
           WHERE NIVEL6 = LEFT (CLASPROD, 12)            
      AND LEN(CLASPROD)= 12                 
COMMIT  

--=====================================================================            
BEGIN TRANSACTION            
UPDATE TAB_NIVEL7_AC_REDE SET  
							DESCRICAO = upper(P.DESCR),            
							COMPRADOR = P.COMPRADOR            
           FROM TAB_NIVEL7_AC_REDE, BDENTER.DBO.PRODUTOCAD P            
           WHERE NIVEL7 = RIGHT('00000' + LTRIM(RTRIM( P.CODPRO )),5)            
COMMIT            
            
BEGIN TRANSACTION            
UPDATE TAB_NIVEL7_AC_REDE SET COMPRADOR = upper(NOME)            
           FROM TAB_NIVEL7_AC_REDE, BDENTER.DBO.COMPRADCAD            
           WHERE COMPRADOR = CODCOMP            
COMMIT            
            
BEGIN TRANSACTION            
UPDATE TAB_PARAMETROS_AC_REDE SET ATUALIZADOEM = GETDATE()            
COMMIT            
            
END  

GO

