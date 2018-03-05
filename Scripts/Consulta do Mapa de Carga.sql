
-- Select do Mapa de Carga
-----------------------------------------------------------------------------------------------------------
SELECT DISTINCT 
'UPDATE ITEMCLICAD SET SITFAT = 1, QUANTENT = ' + CONVERT(VARCHAR,INF.QUANT) + ', NUMORDFAT = ' + CONVERT(VARCHAR,INF.NUMORD) + ' WHERE ITEM = ' + CONVERT(VARCHAR,ICli.ITEM),
ICli.ITEM,IFat.OrdemEntrega, V.Nome as Vendedor, NF.NumNota, NF.DtEmis, NF.Filial, I.NOME AS Cliente, NF.ValContab, 
       PC.obs, PC.observ, PC.tipnota, IFat.NumeroLista, T.Nome as Transportadora, C.Placa, NF.NumPed, NF.CodClie, PC.CodEndEnt, 
       SPACE(200) Endereco, SPACE(254) Referencia, NF.condPag, PC.dtpripag, NF.Serie, PC.DtPrevEnt, NF.NumOrd, 
       NF.NumOrd, (SELECT SUM(C.PESOBRUTO) FROM CARVOLUFAT C WHERE C.NUMORD = NF.NUMORD) peso_bruto 
  FROM NfSaidaCad NF 
  JOIN ItemCliCad ICli ON NF.NumPed = ICli.NumPed 
  JOIN ItemFaturado IFat ON ICli.NumPed = IFat.Pedido AND ICli.Item = IFat.Item 
  JOIN ComplNfFat C ON NF.NumOrd = C.NumOrd 
  JOIN VendedoCad V ON NF.CodVend = V.CodVend  
  LEFT JOIN TabTranFat T ON NF.CodTran = T.CodTran 
  JOIN ITEM I ON NF.CodClie = I.Oid  
  JOIN HistEntCad H ON NF.NumOrd = H.NumOrd 
  JOIN ItnfSaicad INF ON NF.NumOrd = INF.NumOrd AND INF.ItemPedido = ICli.Item 
  JOIN PediCliCad PC ON NF.NumPed = PC.NumPed 
  JOIN FilialCad F ON F.Filial = NF.Filial 
 WHERE NF.FILIAL = '04'  AND IFat.NumeroLista = 205855 
  -- AND LEFT(NF.TPO,1) <> '9' 
	AND NF.Atualiz = 1 
	AND NF.DtCancel IS NULL 
	AND NF.Flagemit = 1 
	AND H.TipoHist <> '4' 
	--AND ICli.SitFat = '1' 
	AND IFat.Faturado IS NOT NULL 
	AND IFat.Cancelado IS NULL 
    AND NOT EXISTS(SELECT 1 FROM HISTENTCAD H1 WHERE H1.NUMORD=NF.NUMORD AND H1.TIPOHIST='4') 
 ORDER BY IFat.OrdemEntrega DESC,IFat.NumeroLista
 
-- Transferência --------------------------------------------------------------------------------------------------------------------
SELECT 
	DISTINCT
	'UPDATE ITEMCLICAD SET SITFAT = 1, QUANTENT = ' + CONVERT(VARCHAR,INF.QUANT) + ', NUMORDFAT = ' + CONVERT(VARCHAR,INF.NUMORD) + ' WHERE ITEM = ' + CONVERT(VARCHAR,ICli.ITEM)
FROM NfSaidaCad NF 
  LEFT JOIN TabTranFat T ON NF.CodTran = T.CodTran, 
       ItemCliCad ICli, ItemFaturado IFat, ComplNfFat C, VendedoCad V, FILIALCAD F, PESSOA_R I, ItnfSaicad INF, PediCliCad PC 
 WHERE NF.FILIAL = '04'  AND IFat.NumeroLista = 205855 
	AND LEFT(NF.TPO,1) = '9' 
 	AND NF.NumOrd = INF.NumOrd 
 	AND ICli.NumPed = IFat.Pedido AND ICli.Item = IFat.Item 
 	AND NF.Atualiz = 1 AND NF.DtCancel IS NULL AND NF.Flagemit = 1 
 	AND IFat.Cancelado IS NULL 
 	--AND ICli.SitFat = '1' 
 	AND IFat.Faturado IS NOT NULL 
 	AND NF.NumOrd = C.NumOrd 
 	AND NF.CodVend = V.CodVend 
 	AND PC.DESTINO = F.FILIAL 
	AND F.OID = I.OID 
 	AND NF.NumPed = ICli.NumPed 
	AND INF.ItemPedido = ICli.Item 
	AND NF.NumPed = PC.NumPed 
 ORDER BY IFat.OrdemEntrega DESC,IFat.NumeroLista
 
 -- Consulta a Reserva --------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT
	'UPDATE ITEMCLICAD SET SITFAT = 1, QUANTENT = ' + CONVERT(VARCHAR,INF.QUANT) + ', NUMORDFAT = ' + CONVERT(VARCHAR,INF.NUMORD) + ' WHERE ITEM = ' + CONVERT(VARCHAR,i.ITEM),
	ifa.Faturado,ifa.Cancelado,
	P.NUMPED, I.FILIAL, I.FILIALRETIRADA, I.FILIALTRANSFERENCIA, P.RAZAOCLI NOMECLIENTE, P.CODCLIE, 
	P.DTPEDIDO, I.DTPREVENT, V.CODVEND + ' - ' + V.NOME NOMEVENDEDOR, P.SITVEN, ((I.QUANT-I.QUANTENT)* 
CASE 
    WHEN I.UNID=PD.UNID1 THEN 1 
    WHEN I.UNID=PD.UNID2 THEN PD.FACONV 
    ELSE PD.FACONV3  
END) QUANTRESERVADA, SPACE(254) SITUACAOPEDIDO 
FROM PEDICLICAD P(NOLOCK) 
JOIN ITEMCLICAD I(NOLOCK) ON P.NUMPED = I.NUMPED 
JOIN ITNFSAICAD INF ON INF.ItemPEdido = I.ITEM
join ITEMFATURADO ifa on ifa.Item = i.item and ifa.Faturado is not null 
LEFT JOIN VENDEDOCAD V(NOLOCK) ON P.CODVEND = V.CODVEND 
JOIN PRODUTOCAD PD(NOLOCK) ON I.CODPRO = PD.CODPRO 
WHERE  
	I.RESERVA = 'S'   
	AND I.SITFAT =  0
	--AND Ifa.NumeroLista = 205855
	AND P.SITVEN NOT IN ('3','A') 
	AND  NOT EXISTS (SELECT 1 FROM ITEMFATURADO IFA(NOLOCK) WHERE IFA.NUMPEDTRANSFERENCIA = P.NUMPED)  
	AND(I.QUANT - I.QUANTENT) > 0 
	--AND  I.CODPRO = '08715' 
	AND  ((I.FILIAL = '04' AND I.FILIALRETIRADA = '  ') OR  
	(I.FILIALRETIRADA = '04' AND I.NUMORDRET = 0) OR  
	(I.FILIALTRANSFERENCIA = '04' AND I.FATURAMENTODIRETO=1  
	AND EXISTS(SELECT N.NUMORD FROM NFENTRACAD N(NOLOCK) WHERE N.NUMORD=I.NUMORDRET AND N.ATUALIZ=1))  
		OR (I.FILIALTRANSFERENCIA = '04' AND I.FATURAMENTODIRETO=0 AND I.NUMORDTRANSF = 0  
	AND EXISTS(SELECT NUMORD FROM NFENTRACAD N(NOLOCK) WHERE NUMORD=I.NUMORDRET AND N.ATUALIZ=1))  
		OR (I.FILIAL = '04' AND I.NUMORDTRANSF <> 0  
	AND EXISTS(SELECT NUMORD FROM NFENTRACAD N(NOLOCK) WHERE NUMORD=I.NUMORDTRANSF AND N.ATUALIZ=1))  
		OR (I.FILIAL = '04' AND I.FILIALTRANSFERENCIA='  ' AND I.FATURAMENTODIRETO=0  
	AND EXISTS(SELECT NUMORD FROM NFENTRACAD N(NOLOCK) WHERE NUMORD=I.NUMORDRET AND N.ATUALIZ=1))) 

