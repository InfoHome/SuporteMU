-- Consulta pedidos sem itens
-------------------------------------------------------------------------------------
--update  PEDICLICAD set sitven = 3 where numped IN (
select 
	i.numped,p.dtpedido,p.numped, p.filial, v.nome 
from PEDICLICAD p
	left join ITEMclicad i on p.numped = i.numped 
	join VENDEDOCAD v on p.codvend = v.codvend
where-- p.numped = '1561972'and
	ISNULL(i.numped,'')=''  and YEAR(p.dtpedido) = 2018
 --)
Order by p.filial,p.dtpedido
              