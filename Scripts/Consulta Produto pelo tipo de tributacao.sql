/*-- Tabela -----------------------------------------------------------------------------------
TIPO	DESCRICAO
----------------------------------------------
A		Tributa��o Anterior
S		Substitui��o Tribut�ria
I		Isentos
N		N�o Tributados
P		Tributa��o Suspensa
D		Tributa��o Diferida
B		Base Reduzida
O		Outros n�o Tributados
M		Imune
T		Tributado
---------------------------------------------------------------------------------------------*/
-- Para filtrar os produtos pelo tipo da tributacao
-----------------------------------------------------
select 
	trib.cm,trib.discrmens,prod.codpro,prod.descr,tptrib.DESCRICAO as Tipo, trib.usomens
from PRODUTOCAD prod 
	join TABMENSCAD trib on prod.cm = trib.cm 
	join TIPOTRIBUTACAO tptrib on trib.usomens = tptrib.tipo
where tptrib.tipo = 'B' -- Altere aqui para filtrar um tributacao especifica
order by prod.descr asc



-- Para filtrar todos os produtos
-----------------------------------------------------
select 
	trib.cm,trib.discrmens,prod.codpro,prod.descr,tptrib.DESCRICAO as Tipo, trib.usomens
from PRODUTOCAD prod 
	join TABMENSCAD trib on prod.cm = trib.cm 
	join TIPOTRIBUTACAO tptrib on trib.usomens = tptrib.tipo
order by prod.cm,prod.descr asc