------------------------------------------------------------------------------------------------------
-- Consultar tintas
------------------------------------------------------------------------------------------------------
select 
       itc.codprotinta as PROD_Final,
       cpl.descricaolonga,
       cpl.tipocomponente,
       it.* 
from pediclicad ped 
       join itemclicad it on ped.numped = it.numped
       join itemclicomplemento itc on ped.numped =  itc.numped and it.item = itc.ritem
       join vendasscad ven on ped.numped = ven.numped 
            and  itc.idtinta > 0 and ped.sitven = '2'
       join complementoproduto cpl on cpl.codpro = it.codpro 
		
	    and cpl.sistematintometrico = '31782'
	    /*
		Códigos dos sistemas Tintométricos
		------------------------------------------------
		31780	Sistema Tintométrico - Coral
		32265	Sistema Tintométrico - Dacar
		31781	Sistema Tintométrico - Lukscolor
		31782	Sistema Tintométrico - Sherwin Williams
		31983	Sistema Tintométrico - Suvinil
		37005	Sistema Tintométrico – Iquine
		37220	Sistema Tintométrico – Renner
	    */
--where ped.numped = 1455886
order by ven.numped desc
