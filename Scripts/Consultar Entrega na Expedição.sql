--------------------------------------------------------------------------------------------------------------------------------
-- Consultar Entrega na Expedição
-- Verificar Parâmetro:  "Enviar cupom fiscal para expedição?" deve estar com 'S' para o Cupom ir para Expedição
-- Para estar na expedição deve estar com HISTENTCAD.tipohist = 1 e EXPEDICCAD.tipohist = 1
-- Depois de confirmado insere um registro HISTENTCAD.tipohist = 4 e exclui EXPEDICCAD da nota.
--------------------------------------------------------------------------------------------------------------------------------

select numord,* from nfsaidacad where filial  = '02' and modelonf = '65' and serie not in ('###','NFC') order by numnota desc
select * from itnfsaicad where numord =294675

select sitven,sitmanut,* from pediclicad where numped = 251831
select * from vendasscad where numped = 251831
select item,tipoentr,* from itemclicad where numped = 251831 
select * from complnffat where numord = 296020

select * from EXPEDICCAD where nordnota = 296020
select * from HISTENTCAD where numord = 296020 and tipohist = 1

select 
	nfs.filial,nfs.numnota,nfs.serie,itc.tipoentr,nfs.numord,nfs.nordven,
	nfs.dtemis,NULL,'N',cpl.bairentr,cpl.cidentr,NULL,1,itc.numcarga,NULL 
from 
	nfsaidacad nfs 
	join complnffat cpl 
		on nfs.numord = cpl.numord 
		and nfs.modelonf = '65' 
		and nfs.serie not in ('NFC','###')
		and nfs.atualiz = 1 
		and nfs.dtcancel is null 
		and nfs.numord not in (select nordnota from expediccad)
		and nfs.numord not in (select numord from COMPLEMENTONFSAIDA where situacaonfe in ('T','D'))
	join itnfsaicad itn on itn.numord = nfs.numord
	join itemclicad itc on itc.numped = nfs.numped and itc.item = itn.itempedido and itc.tipoentr = 'E'

