-- Ajuste de Base de dados após restauração
----------------------------------------------------------------------------------------------
USE BD01_DESENV
GO
UPDATE ITEM SET NOME = 'AC - BASE DE DESENVOLVIMENTO' WHERE OID = 129056
UPDATE PESSOA SET RAZAOSOCIAL = 'AC - BASE DE DESENVOLVIMENTO' WHERE OID = 129056
UPDATE usuario_r SET senha = 'HSBFRMUEDJ' where oid = 1 
DELETE FROM CLASSIFICACAO WHERE RCATEGORIA =  2123 AND RITEM <> 129056
UPDATE vendedocad SET senhaven = '1' WHERE codvend = '00038'
GO

----------------------------------------------------------------------------------------------
USE BDTREINA
GO
UPDATE ITEM SET NOME = 'AC - BASE DE TREINAMENTO' WHERE OID = 129056
UPDATE PESSOA SET RAZAOSOCIAL = 'AC -BASE DE TREINAMENTO' WHERE OID = 129056
UPDATE usuario_r SET senha = 'HSBFRMUEDJ' where oid = 1 
UPDATE vendedocad SET senhaven = '1' WHERE codvend = '00038'

GO
----------------------------------------------------------------------------------------------
