----------------------------------------------------------------------------------------------------------------------------------------------------
-- VERSOES DO FATURAMENTO
-- Script traz as verses utilizadas pelo usuario conforme data do historico
----------------------------------------------------------------------------------------------------------------------------------------------------
select	
		convert(varchar,s.INICIO,103) as DataSessaoAplicativo,
		'EXECUTAVEL: ' + s.executavel as Executavel,
		'USUARIO: ' + i.nome as Usuario,
		'ESTACAO: ' + s.estacao as Estacao
from sessaoaplicativo s, item i
where S.rusuario = i.oid
	and s.rusuario in (select h.usuario 
						from historicopedido h 
							where h.numped = 1964520	-- NUMERO DO PEDIDO'  
								--AND H.USUARIO in (2456839,202436226)	-- 'OID DO USUARIO DA COLUNA HISTORICOPEDIDO.USUARIO'
								and h.Usuario = s.RUSUARIO
								and year(S.inicio) = year(h.Data)	-- Ano do Faturamento
								and month(S.inicio) = month(h.Data)	-- Mês do Faturamento
								and day(S.inicio) = day(h.Data)		-- Dia do Faturamento
							group by h.usuario)
group by convert(varchar,s.INICIO,103),	'EXECUTAVEL: ' + s.executavel, 'USUARIO: ' + i.nome, 'ESTACAO: ' + s.estacao