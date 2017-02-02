----------------------------------------------------------------------------------------------------------------------------------------------------
-- LOGOPERCAD
-- Script para buscar operações de cadastro para o pedido e/ou nota fiscal, pode ser visualizado em qual opçãoo e qual usuario fez a operação
-- quando a mesma exista
----------------------------------------------------------------------------------------------------------------------------------------------------
select	l.ARQUIVO,
		l.DATA,
		LEFT(UPPER(i.nome),15) as USUARIO,
		l.FILIAL,
		l.OPCAO,l.numord,l.NUMDOC,LEFT(l.REFERENCIA,50),l.SIST 
from LOGOPERCAD l 
		INNER JOIN ITEM i on l.USUARIO = i.oid
 where (l.NUMORD = 'NUMORD DA NOTA FISCAL'
		or l.numdoc = 'NUMERO DO PEDIDO')