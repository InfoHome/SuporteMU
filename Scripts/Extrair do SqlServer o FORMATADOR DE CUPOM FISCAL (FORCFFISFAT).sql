----------------------------------------------------------------------------------------------------------------------------------------------------
-- Extrair o formatador FORCFFISFAT (SqlServer)
-- Script para extrair do SqlServer o FORMATADOR DE CUPOM FISCAL (FORCFFISFAT)
----------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 'INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES ('+
	RTRIM(CONVERT(CHAR(5),CodImp)) + ', ' +
	'''' + Codigo + ''', ' +
	RTRIM(CONVERT(CHAR(2),Ordem)) + ', '+
	'''' + RTRIM(REPLACE(REPLACE(String, '''', ''''''),CHAR(9),'')) + ''', ' +
	RTRIM(CONVERT(CHAR(1),Somar)) + ')'
FROM ForCFfisFat
where 
	codimp = 31413 -- informar o CodImp da impressora fiscal
	--AND CODIGO='333'
ORDER BY CodImp,Codigo, Ordem


-- Códigos das Impressoras
--------------------------------------------------
-- 26673 - BEMA20 FI32
-- 26674 - BEMA40 FI32
-- 21308 - BEMATECH MP 20
-- 25798 - BEMATECH MP 40
-- 29196 - DARUMA FS 345
-- 21312 - DATAREGIS
-- 21284 - ITAUTEC
-- 27913 - ITUATEC ZPM
-- 21316 - SID
-- 21300 - SWEDA
-- 27572 - Sweda 9000
-- 21304 - URANO
-- 21320 - YANCO
-- 26672 - YANCO FOR WINDOWS
-- 21288 - ZANTHUS_1
-- 21292 - ZANTHUS_2
-- 27023 - ZANTHUS ZAPIF
-- 31413 - DARUMA FS 600
-- 37778 - TECNOSPED



