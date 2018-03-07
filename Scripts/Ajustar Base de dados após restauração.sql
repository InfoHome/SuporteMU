-- Ajuste de Base de dados após restauração
----------------------------------------------------------------------------------------------
USE BD01_DESENV
GO
UPDATE ITEM SET NOME = 'AC - BASE DE DESENVOLVIMENTO' WHERE OID = 129056
UPDATE PESSOA SET RAZAOSOCIAL = 'AC - BASE DE DESENVOLVIMENTO' WHERE OID = 129056
update usuario_r set senha = 'HSBFRMUEDJ' where oid = 1 
DELETE FROM CLASSIFICACAO WHERE RCATEGORIA =  2123 AND RITEM <> 129056
GO

----------------------------------------------------------------------------------------------
USE BDTREINA
GO
UPDATE ITEM SET NOME = 'AC - BASE DE TREINAMENTO' WHERE OID = 129056
UPDATE PESSOA SET RAZAOSOCIAL = 'AC -BASE DE TREINAMENTO' WHERE OID = 129056

GO
----------------------------------------------------------------------------------------------
