-----------------------------------------------------------------------------------------------------
-- Sped Contribuições
-- Tabela: MU_SPED_EFDPCBLOCOC_IT
-- Apurar Itens Duplicados Sped Contribuições
-- Atendimento Exemplo: 326566
-----------------------------------------------------------------------------------------------------
SELECT 
	TN.NUMORDNF, TN.OIDDOCDEORIGEM, TN.ENTSAI, IT.ITEM
FROM MU_SPED_EFDPCBLOCOC_NF TN 
    JOIN NFSAIDACAD NF ON TN.NUMORDNF = NF.NUMORD 
    JOIN ITNFSAICAD IT ON TN.NUMORDNF = IT.NUMORD 
    LEFT JOIN ITNFSAICOMPLEMENTO ITC ON IT.NUMORD = ITC.NUMORD AND IT.ITEM = ITC.ITEM 
WHERE TN.ENTSAI = 'S' AND TN.NFTRADE = 1 AND TN.VENDAECF = 0 
GROUP BY TN.NUMORDNF, TN.OIDDOCDEORIGEM, TN.ENTSAI, IT.ITEM
HAVING 
	COUNT(TN.NUMORDNF) > 1  
	AND COUNT(TN.OIDDOCDEORIGEM) > 1 
	AND COUNT(TN.ENTSAI) > 1 
	AND COUNT(IT.ITEM) > 1 


