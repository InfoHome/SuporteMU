----------------------------------------------------------------------------------------------------------------------------------------------------
-- Script para Insereir registro de pedido que não gerou Vendasscad
-- Descomente o insert para inserir o vendasscad
--------------------------------------------------------------------------------------------------------------------------------------------------
declare @pnUsuario varchar(8), @pnSessao int, @pnData datetime, @pnLocalpor int, @pnNumord int, @pnNumped int

set @pnSessao = 7			-- Pegar no Log LinkTime o oid da Sessao Aplicativo criada para o usuário
set @pnNumord = 7			-- Pegar no Log LinkTime o nordven gerado para o pedido
set @pnNumped = 7 			-- Informar o Número do pedido

-- Pegar o usuario
select @pnUsuario= usu.nome , @pnData = sessao.termino 
from sessaoaplicativo_r sessao join item usu on sessao.rusuario = usu.oid where sessao.oid = @pnSessao
-- Pegar o localporta
select distinct @pnLocalpor = localporta 
from vendasscad where usuven=@pnUsuario and year(dtven)= year(@pnData) and month(dtven)= month(@pnData) and day(dtven)= day(@pnData)

--Para Inserir o Vendasscad descomentar a próxima Linha
-- Insert into vendasscad (numord,filial,localporta,dtven,usuven,numped,totven,freteorc,numfrete,OIDDocdeOrigem,receber,situacao,taxanf,OutrasDespesasInclusas,CondPagPosterior)
select Distinct
		case when nf.numord > 7 then min(nf.numord)	else @pnNumord end as numord ,
		p.filial,
		case when @pnLocalpor >= 7	then @pnLocalpor
			 when nf.localporta >= 7 then nf.localporta
			 when l.localporta >= 7	then l.localporta
				else 7 	end as localporta,
		case when @pnSessao <= 7 then hp.data 
			 when @pnSessao >7 then @pnData else Null end as Dtven,
		case when @pnSessao > 7 then @pnUsuario 
			 when @pnSessao <= 7  then (select left(nome,8) from item where oid = hp.Usuario)
				else 'Indeterminado' end as usuven,
		p.numped, p.valped,	p.freteorc,	p.numfrete,	7 as OIDDocdeOrigem, p.receber,	'5' as situacao,
		p.taxanf, p.OUTRASDESPESASINCLUSAS,	p.CondPagPosterior
FROM	PEDICLICAD p LEFT JOIN PREVCLICAD pr ON pr.numped = p.numped
		LEFT JOIN historicopedido hp ON hp.numped = p.numped and hp.SitVen = '2' 
			and hp.data = (select min(h.data) from historicopedido h WHERE h.sitven = '2' and h.historico like 'Orçamento faturado%' and h.numped = p.numped)
		LEFT JOIN NFSAIDACAD nf ON nf.numped = p.numped and left(nf.tpo,1)= 2 
		LEFT JOIN VENDASSCAD v ON v.numped = p.numped
		LEFT JOIN ITEM i3 ON i3.oid = v.localporta
		LEFT JOIN LANCHECCXA l ON p.numped = l.numped
		LEFT JOIN CONTAARECEBER_R cr ON v.oiddocdeorigem = cr.RDOCDEORIGEM
		LEFT JOIN ITEM i5 on i5.oid = cr.rsituacao
WHERE	p.numped = @pnNumped -- Informar o número do pedido
GROUP BY p.filial, l.localporta, nf.localporta, hp.Usuario, hp.data,	p.numped, p.valped,	p.freteorc,
	p.numfrete,	p.taxanf, p.OUTRASDESPESASINCLUSAS, nf.numord, nf.nordven,p.receber,	p.CondPagPosterior
	
	
------------------------------------------------------------------------------------------------------------------------------------------------------------
select numord,lif,atualiz,dtcancel,flagemit,numped,codvend,localporta,* from nfsaidacad where numped = 2008112 
select sitven,sitmanut,* from pediclicad where numped = 2008112
select * from historicopedido where numped = 2008112 order by data desc
select * from vendasscad where numped = 2008112 
select * from GERANFECF where numped = 2008112
select * from prevclicad where numped = 2008112
select * from itemclicad where numped = 2008112
select * from item where oid = 629639865  --VILMAMACEDO012
select * from vendasscad where localporta = 629639869


-- Depois que insere entrar no Fechmanento de caixa e fazer o processo de Vendas Inconsistentes 
	


<pre>
-- Relatório
-------------------------------------------------------------
1. Gerou Vendasscad:	( ) SIM - (X) NAO
2. Gerou Lancheccxa:	(X) SIM - ( ) NAO => (X)Fechou com valor total do pedido
3. Gerou Contaareceber:	( ) SIM - (N) NAO => ( )Fechou com valor total do pedido
4. Gerou prevclicad:	(X) SIM - ( ) NAO => (X)Fechou com valor total do pedido
5. Foi Liberado a Situação do Pedido:	(X) SIM - ( ) NAO
6. A soma dos itens 2 + 3 Fechou com valor total do pedido:	(X) SIM - ( ) NAO
7. Teve nota Emitida:	(X) SIM - ( ) NAO 
	(X) Sem erro de integração 
	( ) Com erro de integração
	( ) Entrega Futura/Expedição
--------------
8. Resuma: 
--------------
	(X) As parcelas e/ou lançamentos a vista foram gerados e fecham com o valor do pedido
	( ) Os lançamentos estão inconsistentes e não fecham com o pedido
	(x) Outras: Não Gerou o Vendasscad
</pre>

