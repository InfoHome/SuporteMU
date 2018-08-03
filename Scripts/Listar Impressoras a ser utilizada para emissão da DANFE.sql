-- Impressora a ser utilizada para emissão da DANFE
---------------------------------------------------------------------------
select 
	distinct u.nome,a.svalor
from historiconfe h 
	join USUARIO_R u on h.USUARIO = u.OID 
	left join ADITIVO a on u.oid = a.RITEM and a.RDEFINICAO = 33324
	where h.dataprocessamento > ='20180101'
	and a.SVALOR is not null


	----------------------------------------------
	select 
	distinct USUARIO, u.nome,a.svalor
from historiconfe h 
	join USUARIO_R u on h.USUARIO = u.OID 
	left join ADITIVO a on u.oid = a.RITEM and a.RDEFINICAO = 33324
	where h.dataprocessamento > ='20180701'
	and a.SVALOR is null