select
	pre.numped,
	pre.filial, 
	pre.tipopar,
	fp.nome as [Forma de Pagar],
	doc.nome as [Documento],
	sum(pre.valprev)
	from pediclicad ped 
		join prevclicad pre on ped.numped = pre.numped
		join item fp on ped.rformadepagar = fp.oid
		join item doc on doc.oid=pre.tipodoc
		--join vendasscad ven on ven.numped = ped.numped
	where sitven = '2'
		and year(dtpedido)= 2018 
		and month(dtpedido)= 3 
		and day(dtpedido) = 2
		and pre.filial = '01'
		--and pre.tipopar = 0 and pre.tipodoc not in (17763)
		--and codvend = '00175'
		--and pre.tipopar = 1
		--and pre.numped = 1559421
		--and doc.nome = 'Dinheiro'
group by
pre.numped,
	pre.filial, 
	pre.tipopar,
	fp.nome,
	doc.nome




