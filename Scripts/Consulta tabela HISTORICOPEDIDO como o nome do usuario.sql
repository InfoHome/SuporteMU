----------------------------------------------------------------------------------------------------------------------------------------------------
-- HISTORICOPEDIDO
-- O script traz o histrico do pedido por data decrescente e usuario
----------------------------------------------------------------------------------------------------------------------------------------------------
Select upper(i.nome) as usuario, h.* 
from  HISTORICOPEDIDO h left join item i on h.usuario = i.oid 
where h.numped = 1008994 
--AND H.Historico LIKE '%02709%'
order by h.data desc