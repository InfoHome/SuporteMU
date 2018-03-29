--USE [WebSGS]
--GO

--/****** Object:  StoredProcedure [dbo].[uspEnviaRelatorioDeConexoesAtivas]    Script Date: 01/09/2017 11:51:37 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO




--ALTER PROCEDURE [dbo].[uspEnviaRelatorioDeConexoesAtivas]
--as
IF object_id('tempdb..#tmp_DRE_Contrular') IS NOT NULL DROP TABLE #tmp_DRE_Contrular
IF object_id('tempdb..#tmp_DRE_Contrular_itens') IS NOT NULL DROP TABLE #tmp_DRE_Contrular_itens
IF object_id('tempdb..#tmp_DRE_Contrular_Email') IS NOT NULL DROP TABLE #tmp_DRE_Contrular_Email

-------------------------------------------------------------------------------
-- Apuração Venda a Vista
-- Venda "A Vista" Com pedido, NÃO considera Administradora de Cartões
-------------------------------------------------------------------------------
select 
	'PD'						as [Origem],
	pre.item					as [Codigo],
	ped.numped					as [Referencia],
	ven.dtven					as [Data],
	'+'							as [Sinal],
	'01 - Receita Bruta'		as [Tipo],
	'A Vista C/ Pedido'			as [Operacao],
	'01.01 - Vendas a Vista'	as [Hierarquia],
	pre.filial					as [Filial], 
	pre.valprev					as [Valor]
into #tmp_DRE_Contrular
from pediclicad ped 
		join prevclicad pre on ped.numped = pre.numped
		join item fp on ped.rformadepagar = fp.oid
		join item doc on doc.oid=pre.tipodoc
		join vendasscad ven on ven.numped = ped.numped
where sitven = '2'
		and pre.tipopar in (0,1) 
		and pre.tipodoc not in (17763)
-------------------------------------------------------------------------------
-- Apuração Venda a Prazo
-- Venda a Prazo
-------------------------------------------------------------------------------
union select
	'PD'						as [Origem],
	pre.item					as [Codigo],
	ped.numped					as [Referencia],
	ven.dtven					as [Data],
	'+'							as [Sinal],
	'01 - Receita Bruta'		as [Tipo],
	'A Prazo'					as [Operacao],
	'01.02 - Vendas a Prazo'	as [Hierarquia],
	pre.filial					as [Filial], 
	pre.valprev					as [Valor]
from pediclicad ped 
		join prevclicad pre on ped.numped = pre.numped
		join item fp on ped.rformadepagar = fp.oid
		join item doc on doc.oid=pre.tipodoc
		join vendasscad ven on ven.numped = ped.numped
	where sitven = '2'
		and pre.tipopar = 2 
		and pre.tipodoc not in (17763)

-------------------------------------------------------------------------------
-- Apuração venda com cartão
-------------------------------------------------------------------------------
union select
	'PD'						as [Origem],
	pre.item					as [Codigo],
	ped.numped					as [Referencia],
	ven.dtven					as [Data],
	'+'							as [Sinal],
	'01 - Receita Bruta'		as [Tipo],
	'Cartão C/Pedido'			as [Operacao],
	'01.03 - Vendas com Cartão' as [Hierarquia],
	pre.filial					as [Filial],
	pre.valprev					as [Valor]
from pediclicad ped 
		join prevclicad pre on ped.numped = pre.numped
		join item fp on ped.rformadepagar = fp.oid
		join item doc on doc.oid=pre.tipodoc
		join vendasscad ven on ven.numped = ped.numped
	where sitven = '2'
		and pre.tipodoc = 17763

-------------------------------------------------------------------------------
-- Venda "A Vista" SEM pedido, NÃO considera Administradora de Cartões
-------------------------------------------------------------------------------
union select 
	'NF'						as [Origem],
	lc.IDLANCHEC				as [Codigo],
	nf.numord					as [Referencia],
	nf.dtemis					as [Data],
	'+'							as [Sinal],
	'01 - Receita Bruta'		as [Tipo],
	'Cartão S/Pedido'			as [Operacao],
	'01.03 - Vendas com Cartão' as [Hierarquia],
	Lc.filial					as [Filial],
	lc.vallanc					as [Valor]
from nfsaidacad nf 
	join LANCHECCXA lc on nf.numord = lc.numord
	join item doc on doc.oid=lc.documen
	where 
		nf.numped in(0,7) 
		and left(nf.tpo,1)=2
		and nf.atualiz = 1
		and nf.flagemit = 1
		and lc.documen in (select oid from ADMINISTRADORA_R)


-- Venda "A Vista" sem pedido, não considera administradora de cartões
-- 1 - Receita Bruta
-------------------------------------------------------------------------------
union select 
	'NF'						as [Origem],
	lc.IDLANCHEC				as [Codigo],
	nf.numord					as [Referencia],
	nf.dtemis					as [Data],
	'+'							as [Sinal],
	'01 - Receita Bruta'		as [Tipo], 
	'A Vista S/ Pedido'			as [Operacao],
	'01.01 - Vendas a Vista'	as [Hierarquia],
	Lc.filial					as [Filial],
	lc.vallanc					as [Valor]

from nfsaidacad nf 
	join LANCHECCXA lc on nf.numord = lc.numord
	join item doc on doc.oid=lc.documen
	where 
		nf.numped in(0,7) 
		and left(nf.tpo,1)=2
		and nf.atualiz = 1
		and nf.flagemit = 1
		and nf.dtcancel is null
		and lc.documen not in (select oid from ADMINISTRADORA_R) -- Não considerar a venda com cartão

-- CUSTO DOS ITENS ------------------------------------------------------------
-- Venda com Pedido
-------------------------------------------------------------------------------
select
	'CMCP'						as [Origem], -- [C]usto das [M]ercadorias [C]om [P]edido
	'0'							as [Codigo],
	PED.NUMPED					as [Referencia],
	ven.dtven					as [Data],
	'-'							as [Sinal],
	'05 - Custo Mercadoria'		as [Tipo],
	'Custo Mercadoria Vendida'	as [Operacao],
	'05.01 - CMV'				as [Hierarquia],
	ped.filial					as [Filial], 
    SUM(PROD.PRECOCOMP*ITPD.QUANT) as Valor
	into #tmp_DRE_Contrular_itens
from 
	pediclicad ped 
	join vendasscad ven on ven.numped = ped.numped
	join itemclicad itpd on itpd.numped = ped.numped
	join produtocad prod on itpd.codpro = prod.codpro
where
	ped.numped = (select distinct tmpVenda.Referencia 
						from #tmp_DRE_Contrular tmpVenda
						where tmpVenda.Origem = 'PD' 
							and tmpVenda.Referencia = ped.numped)
GROUP BY 
	PED.NUMPED,	ven.dtven,	ped.filial	
	
-------------------------------------------------------------------------------
-- Venda sem Pedido
-------------------------------------------------------------------------------
union select 
	'CMSP'						as [Origem], -- [C]usto das [M]ercadorias [S]em [P]edido
	'0'							as [Codigo],
	NF.NUMORD					as [Referencia],
	nf.dtemis					as [Data],
	'-'							as [Sinal],
	'05 - Custo Mercadoria'		as [Tipo],
	'Custo Mercadoria Vendida'	as [Operacao],
	'05.01 - CMV'				as [Hierarquia],
	nf.filial					as [Filial],
    SUM(ITNF.QUANT*PROD.PRECOCOMP) as Valor
from 
	nfsaidacad nf 
	join itnfsaicad itnf on itnf.numord = nf.numord
	join produtocad prod on itnf.codpro = prod.codpro
where
	nf.numord = (select distinct tmpVenda.Referencia 
						from #tmp_DRE_Contrular tmpVenda
						where tmpVenda.Origem = 'NF' 
							and tmpVenda.Referencia = nf.numord)
GROUP BY 
	NF.NUMORD, nf.dtemis, nf.filial

--------------------------------------------------------------------------------------------
-- Conversão para tabela
--------------------------------------------------------------------------------------------
select * into #tmp_DRE_Contrular_Email
	from #tmp_DRE_Contrular
union
select * 
	from #tmp_DRE_Contrular_itens


--------------------------------------------------------------------------------------------
DECLARE @tableHTML  NVARCHAR(MAX), @subjectMSG NVARCHAR(MAX), @dataInicial VARCHAR(MAX),@dataFim VARCHAR(MAX) 

SET @dataInicial = (select convert (varchar,GETDATE()- 31,103))
set @dataFim = (select convert (varchar,GETDATE()- 1,103)) + ' 23:59:59'
SET @subjectMSG = 'DRE referente período: '
set @subjectMSG = @subjectMSG +  + @dataInicial +' até ' + @dataFim

SET @tableHTML =
		N'<head>
		<style type="text/css">
			.alert{
				background-color: #b9c9fe;
				padding: 15px;
				color: #039;
			}
			#box-table
			{
			font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
			font-size: 12px;
			text-align: left;
			border-collapse: collapse;
			border-top: 7px solid #9baff1;
			border-bottom: 7px solid #9baff1;
			}
			#box-table th
			{
			font-size: 13px;
			font-weight: normal;
			background: #b9c9fe;
			border-right: 2px solid #9baff1;
			border-left: 2px solid #9baff1;
			border-bottom: 2px solid #9baff1;
			color: #039;
			}
			#box-table td
			{
			border-right: 1px solid #aabcfe;
			border-left: 1px solid #aabcfe;
			border-bottom: 1px solid #aabcfe;
			padding: 4px;
			color: #039;
			}

			table > tbody > td:last-child {
				text-align: center;
			}

			#box-table >tr:nth-child(odd) { background-color:black; }
			#box-table >tr:nth-child(even) { background-color:red; } 
		</style>
	</head>
	
    <table  id="box-table">
	 <thead>
	 <tr>
		 <th colspan="6" class="alert">
			Demonstrativo de Resultado Empresa Aconstrular
			 <br> Perído: '	+ @dataInicial + ' até ' + @dataFim +' <br> Data de Emissão: ' +  convert(varchar,GETDATE(),104) +
	 + N'</th>
	 </tr>
		<tr>
			<th>Filial</th>
			<th>Tipo</th>
			<th>Sinal</th>
			<th>Hierarquia</th>
			<th>Valor</th>
		</tr>
	 </thead>
	 <tbody>' +
    CAST ( ( 
			select 
				-- td = convert(varchar,data,103), '',
				 td = Filial, '',
				 td = Tipo,'',
				 td = Sinal, '',	
				 td = Hierarquia, '', 
				 td = cast(sum(valor) as decimal(15,2))
			from #tmp_DRE_Contrular_Email 
			where 
				data between @dataInicial and @dataFim
			group by 
				--convert(varchar,data,103), 
				Tipo, Hierarquia, Sinal, filial
			order by filial, Hierarquia

              FOR XML PATH('tr'), TYPE   
    ) AS NVARCHAR(MAX) ) +  
    N'
	</table> 
	</tbody> ' ;   

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'DBEmail Tobias',  
    @recipients = 'tobiasitin@gmail.com',  
	--@copy_recipients = 'infoaconstrular@gmail.com',
	--@copy_recipients = 'alexaconstrular@gmail.com',
    @subject = @subjectMSG,  
	@body =  @tableHTML, 
	@body_format='HTML'; 
	
GO


-- Limpar o cache
----------------------------------------------------------------------
DROP TABLE #tmp_DRE_Contrular
DROP TABLE #tmp_DRE_Contrular_itens
DROP TABLE #tmp_DRE_Contrular_Email

GO


