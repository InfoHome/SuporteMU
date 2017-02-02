----------------------------------------------------------------------------------------------------------------------------------------------------
-- Extrair o formatador FORCFFISFAT (Oracle)
-- Script para extrair do Oracle o FORMATADOR DE CUPOM FISCAL (FORCFFISFAT)
----------------------------------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT
	'INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (' ||
	RTRIM(CAST(CodImp AS CHAR(5))) || ', ' ||
	'''' || Codigo || ''', ' ||
	RTRIM(CAST(Ordem AS CHAR(2))) || ', '||
	'''' || RTRIM(REPLACE(REPLACE(String, '''', ''''''),CHR(9),'')) || ''', ' ||
	RTRIM(CAST(Somar AS CHAR(1))) || ');' Comando
FROM ForCFfisFat
ORDER BY Comando

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

