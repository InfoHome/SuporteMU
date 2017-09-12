-- Ajustes DadosNotaNfe.InfCPL quando tem caracteres especiais não permitidos:
-------------------------------------------------------------------------------------
UPDATE DADOSNOTANFE SET INFCPL = REPLACE(INFCPL,'',' ') WHERE INFCPL LIKE '%%'
UPDATE TEXLIVRFAT SET texto = REPLACE(texto,'',' ') WHERE texto LIKE '%%'