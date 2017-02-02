----------------------------------------------------------------------------------------------------------------------------------------------------
-- ITEMCLICAD + ITEMCLICOMPLEMENTO + ITNFSAICAD + ITEMFATURADO + ITEMCLIEMPENHO + ENTRCLICAD
-- Script para ACOMPANHAR lado a lado o faturamento das tabelas acima
-- A tabela ENTRCLIEMPENHO s  povoada quando se trabalha com oramento de empenho
----------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 'ITEMCLICAD',		i.codpro,pc.descr,i.quant,i.preco,(i.quant*i.preco) as soma,i.quantent,i.tipoentr,
							i.reserva,i.numcarga,i.filialretirada,i.numordfat,i.sitfat,i.item,
       'ITEMCLICOMPLEMENTO',icc.sitconf,icc.idtinta,
	   'ITNFSAICAD',        itn.numnota,itn.serie,itn.codpro,itn.quant,itn.preco,valsubstri,itn.atuaitem,
       'ITEMFATURADO',		ift.Usuario,ift.Estacao,ift.Quant,ift.Reservado,ift.Faturado,ift.Cancelado,ift.NUMEROLISTA,
       'ITEMCLIEMPENHO',	ice.quantnf,ice.precounitnf,
       'ENTRCLICAD',		etr.endentr,etr.bairentr,etr.cidentr,etr.estentr,etr.cepentr,etr.numentr,etr.cnpjend,
							etr.inscrend,etr.COMPLENTR,etr.TIPOENDERECO,etr.SELECIONADO,etr.item,etr.RBAIRRO,
							etr.REFERENCIAENDERECO
 
FROM	PEDICLICAD p
		LEFT JOIN ITEMCLICAD i on i.numped = p.numped
		LEFT JOIN ITEMCLICOMPLEMENTO icc on p.numped = icc.numped 
		LEFT JOIN ITNFSAICAD itn on itn.itempedido = i.item
		LEFT JOIN ITEMFATURADO ift on ift.Pedido = p.numped
		LEFT JOIN ITEMCLIEMPENHO ice on p.numped = ice.numped
		LEFT JOIN ENTRCLICAD etr on etr.numped = p.numped
		LEFT JOIN PRODUTOCAD PC on i.codpro = PC.codpro

WHERE	p.numped = 1008994
		 
GROUP BY /*'ITEMCLICAD'*/			i.codpro,pc.descr,i.quant,i.preco,(i.quant*i.preco),i.quantent,i.tipoentr,
									i.reserva,i.numcarga,i.filialretirada,i.numordfat,i.sitfat,i.item,
         /*'ITEMCLICOMPLEMENTO'*/	icc.sitconf,icc.idtinta,
		 /*'ITNFSAICAD'*/           itn.numnota,itn.serie,itn.codpro,itn.quant,itn.preco,valsubstri,itn.atuaitem,
         /*'ITEMFATURADO'*/			ift.Usuario,ift.Estacao,ift.Quant,ift.Reservado,ift.Faturado,ift.Cancelado,ift.NUMEROLISTA,
         /*'ITEMCLIEMPENHO'*/		ice.quantnf,ice.precounitnf,
         /*'ENTRCLICAD'*/			etr.endentr,etr.bairentr,etr.cidentr,etr.estentr,etr.cepentr,etr.numentr,etr.cnpjend,
									etr.inscrend,etr.COMPLENTR,etr.TIPOENDERECO,etr.SELECIONADO,etr.item,etr.RBAIRRO,
									etr.REFERENCIAENDERECO
									
									
