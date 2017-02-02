----------------------------------------------------------------------------------------------------------------------------------------------------
-- Extrair o formatador FORCFNFFAT (Oracle)
-- Script para extrair do Oracle o FORCFNFFAT DE CUPOM FISCAL (FORCFNFFAT)
----------------------------------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT 'INSERT INTO FORCFNFFAT (Codimp, Codigo, Comando, Variavel, Posicao, Tamanho, Ordem) VALUES (' ||
	RTRIM(CAST(CodImp AS CHAR(5))) || ', ' ||
	'''' || Codigo || ''', ' ||
	'''' || RTRIM(REPLACE(REPLACE(Comando, '''', ''''''),CHR(9),'')) || ''', ' ||
	'''' || RTRIM(Variavel) || ''', ' ||
	RTRIM(CAST(Posicao AS CHAR(3))) || ', '||
	RTRIM(CAST(Tamanho AS CHAR(3))) || ', '||
	RTRIM(CAST(Ordem AS CHAR(3))) || ');' Comando
FROM FORCFNFFAT
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

