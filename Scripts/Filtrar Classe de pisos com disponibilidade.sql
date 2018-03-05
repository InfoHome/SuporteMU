-- RELATÓRIO DE PISOS ACIMA DE 100 METROS DISPONIVEL
---------------------------------------------------------------------------------------
Select 
	i.codpro as Produto, 
	p.descr as Descricao, 
	SUM(i.quant-i.qtdereserv) as [Est. Disponilvel],
	forn.NOME as Fornecedor
from ITEMFILEST i
	join PRODUTOCAD p on i.codpro = p.codpro
	join CLASSIFCAD c on p.clasprod = c.clasprod
		and LEFT(P.clasprod,4)='0501' -- Somente classe de Pisos
		and LEFT(P.clasprod,6) not in ('050190')
	join ITEM forn on p.codfor = forn.oid
group by  p.clasprod,i.codpro, p.descr,forn.nome
having  SUM(i.quant-I.qtdereserv) >= 100 -- filtra Quantidade Disponível >= 100
order by p.descr


-- RELATÓRIO DE PISOS 
---------------------------------------------------------------------------------------
Select 
	i.codpro as Produto, 
	p.descr as Descricao, 
	Disp.nome as Disponibilidade ,
	SUM(i.quant-I.qtdereserv) as [Saldo Disponivel],
	P.dtultcomp as [Data Ult. Compra],
	p.precoven as Custo,
	i.qtultcomp as [Qtde Ult. Compra]
from ITEMFILEST i
	join PRODUTOCAD p on i.codpro = p.codpro
		and p.Disponibilidade = 21073
	join CLASSIFCAD c on p.clasprod = c.clasprod
		and LEFT(P.clasprod,4)='0501' -- Somente classe de Pisos
		and LEFT(P.clasprod,6) not in ('050190')
	Join ITEM disp on disp.OID = p.Disponibilidade
group by  p.clasprod,i.codpro, p.descr,Disp.nome,P.dtultcomp,p.precoven,i.qtultcomp
order by p.descr


