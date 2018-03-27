-- Separa��o da venda A Vista / Cart�o / A Prazo
----------------------------------------------------------------
Declare @diaIni int, @diaFim int, @mes int, @filial char(2)
set @diaIni = 1
set @diaFim = 12
set @mes = 3
set @filial = '01'

drop table #tmp_DRE_Receita_Bruta

-- Apura��o Venda a Vista
-- Venda "A Vista" sem pedido, n�o considera administradora de cart�es
-------------------------------------------------------------------------------
select 
	
	'1 - Receita Bruta' as [Tipo], 
	'A Vista S/ Pedido' as [Operacao],
	'1.1 - Vendas a Vista' [Hierarquia],
	Lc.filial,
	sum(vallanc) as Valor into #tmp_DRE_Receita_Bruta
from nfsaidacad nf 
	join LANCHECCXA lc on nf.numord = lc.numord
	join item doc on doc.oid=lc.documen
	where nf.numped in(0,7) 
		and year(nf.dtemis)= 2018 
		and month(nf.dtemis)= @mes 
		and day(nf.dtemis) between @diaIni and @diaFim
		and nf.filial = @filial
		and left(nf.tpo,1)=2
		and nf.atualiz = 1
		and nf.flagemit = 1
		and nf.dtcancel is null
		and lc.documen not in (select oid from ADMINISTRADORA_R) -- N�o considerar a venda com cart�o
group by 
	Lc.filial

-- Venda "A Vista" Com pedido, n�o considera administradora de cart�es
-------------------------------------------------------------------------------
union  select 
	'1 - Receita Bruta' as [Tipo],
	'A Vista C/ Pedido' as [Operacao],
	'1.1 - Vendas a Vista' as [Hierarquia],
	pre.filial, 
	sum(pre.valprev) as Valor
from pediclicad ped 
		join prevclicad pre on ped.numped = pre.numped
		join item fp on ped.rformadepagar = fp.oid
		join item doc on doc.oid=pre.tipodoc
		join vendasscad ven on ven.numped = ped.numped
where sitven = '2'
		and year(ped.dtpedido)= 2018 
		and month(ped.dtpedido)= @mes 
		and day(ped.dtpedido) between @diaIni and @diaFim
		and pre.filial = @filial
		and pre.tipopar in (0,1) 
		and pre.tipodoc not in (17763)
group by 	
	pre.filial

-- Apura��o Venda a Prazo
-- Venda a Prazo
--------------------------------
union select
	'1 - Receita Bruta' as [Tipo],
	'A Prazo' as [Operacao],
	'1.2 - Vendas a Prazo' as [Hierarquia],
	pre.filial, 
	sum(pre.valprev) as Valor
from pediclicad ped 
		join prevclicad pre on ped.numped = pre.numped
		join item fp on ped.rformadepagar = fp.oid
		join item doc on doc.oid=pre.tipodoc
		join vendasscad ven on ven.numped = ped.numped
	where sitven = '2'
		and year(ped.dtpedido)= 2018 
		and month(ped.dtpedido)= @mes 
		and day(ped.dtpedido) between @diaIni and @diaFim
		and pre.filial = @filial
		and pre.tipopar = 2 and pre.tipodoc not in (17763)
group by 	
	pre.filial

-- Apura��o venda com cart�o
----------------------------------------------------------------------------------
union select
	'1 - Receita Bruta' as [Tipo],
	'Cart�o C/Pedido' as [Operacao],
	'1.3 - Vendas com Cart�o' as [Hierarquia],
	pre.filial,
	sum(pre.valprev) as Valor
from pediclicad ped 
		join prevclicad pre on ped.numped = pre.numped
		join item fp on ped.rformadepagar = fp.oid
		join item doc on doc.oid=pre.tipodoc
		join vendasscad ven on ven.numped = ped.numped
	where sitven = '2'
		and year(ped.dtpedido)= 2018 
		and month(ped.dtpedido)= @mes 
		and day(ped.dtpedido) between @diaIni and @diaFim
		and pre.filial = @filial
		and pre.tipodoc = 17763
group by 	
	pre.filial

-- Venda "A Vista" sem pedido, n�o considera administradora de cart�es
-------------------------------------------------------------------------------
union select 
	'1 - Receita Bruta' as [Tipo],
	'Cart�o S/Pedido' as [Operacao],
	'1.3 - Vendas com Cart�o' as [Hierarquia],
	Lc.filial,
	sum(vallanc) as Valor
from nfsaidacad nf 
	join LANCHECCXA lc on nf.numord = lc.numord
	join item doc on doc.oid=lc.documen
	where nf.numped in(0,7) 
		and year(nf.dtemis)= 2018 
		and month(nf.dtemis)= @mes 
		and day(nf.dtemis) between @diaIni and @diaFim
		and nf.filial = @filial 
		and left(nf.tpo,1)=2
		and nf.atualiz = 1
		and nf.flagemit = 1
		and lc.documen in (select oid from ADMINISTRADORA_R)
group by Lc.filial
ORDER BY 3

-- Listar 
------------------------------------------------------
select 	Tipo, Hierarquia, filial, sum(valor) as Valor
from #tmp_DRE_Receita_Bruta
group by 	Tipo, Hierarquia, filial