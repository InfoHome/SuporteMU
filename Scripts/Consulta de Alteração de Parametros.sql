-- Histórico de alterações de Parâmetros
-------------------------------------------------------------

select 
	c.Nome Parametro, p.*
from parametroslog p , CATEGORIA_R c, DADOADICIONAL d
where p.RDEFINICAO = d.OID and
	d.RTIPO = c.OID
	--and c.nome like '%%'