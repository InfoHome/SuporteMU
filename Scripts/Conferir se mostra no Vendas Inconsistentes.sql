------------------------------------------------------------------------------------------------------------------------------
-- Verifica se aparece para fazer vendas inconsistentes no fechamento de caixa
------------------------------------------------------------------------------------------------------------------------------
SELECT N.Numnota, N.Serie, V.NumOrd, V.NumPed, V.DtVen, V.TotVen, V.Situacao, V.Filial, V.OIDDocdeOrigem, P.RFormadePagar 
FROM VendassCad V 
	LEFT JOIN PediCliCad P ON V.NumPed = P.NumPed 
	LEFT JOIN NFSaidaCad N ON V.NumOrd = N.NumOrd 
WHERE V.Situacao IN (3,4,5) 
	AND V.LocalPorta = 925331977 
	AND V.Filial = '05' 
	AND N.DtCancel Is Null 
	AND ISNULL(N.Serie,null) NOT IN ('NFC','SAT') 
	and n.numord in (8607870) 
ORDER BY N.Numnota, N.Serie 

select * from VENDASSCAD where numord in (8607870) 
select * from lancheccxa where  numord = 8607870
select * from lancheccxa where documen = 2231194 and  datalanc = '20171013' and filial = '05' and localporta = 925331977
select Situacao,* from VendassCad where numord in (8607870) 
select * from PediCliCad where numord in (8607870) 
select numped,* from NFSaidaCad where numord in (8607870) 
select * from DOCFCXACAD where caixa = 925331977 and datafcxa = '20171013' and descr like '%visa%'
select * from MOVFCXACAD where caixa = 925331977 and datafcxa = '20171013' 

select numord,3,filial,localporta,dtemis,usuven,numped,valcontab,oiddocdeorigem from NFSaidaCad where numord in (8607870)
