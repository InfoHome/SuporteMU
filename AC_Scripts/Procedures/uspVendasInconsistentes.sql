
--ALTER PROCEDURE [dbo].[uspEnviaDREAConstrular]
--as
IF object_id('tempdb..#TEMP_VendasInconsistentes') IS NOT NULL DROP TABLE #TEMP_VendasInconsistentes

-- Vendas Inconsistentes
----------------------------------------------------------------
-- Vendasscad duplicada pelo número do pedido
----------------------------------------------------------------
select
	'Vendas Numped duplicado'		as Referencia,
	filial							as Filial, 
	'0'							    as [Codigo1],
	convert(varchar,numped)			as [Codigo2],
	COUNT(*)						as [TotalRegistros]
	
	INTO #TEMP_VendasInconsistentes
	
	from VENDASSCAD where numped >= 7
group by filial, numped 
having count(numped) >1

-- Vendasscad duplicada pelo numord
----------------------------------------------------------------
union select
	'Vendas Numord duplicado'		as Referencia,
	filial							as Filial, 
	convert(varchar,numord)			as [Codigo1],
	'0'								as [Codigo2],
	COUNT(*)						as [TotalRegistros]
	from VENDASSCAD where numped <= 7
group by filial, numord 
having count(numord) >1

 
 -- Vendasscad duplicada pelo numord
----------------------------------------------------------------
union select
	'Vendas inconsistente, Não completou a venda!'		as Referencia,
	filial												as Filial, 
	convert(varchar,numord)								as [Codigo1],
	convert(varchar,numped)								as [Codigo2],
	COUNT(*)											as [TotalRegistros]
	from VENDASSCAD where situacao <> 5
group by filial, numord , Numped


 -- Contas as receber Inconsistente
 ----------------------------------------------------------------
union select 
	'Conta a Receber: ' +CLI.NOME		as Referencia,
	FIL.FILIAL							as Filial,
	CR.CODIGO							as [Codigo1],
	CR.OID								as [Codigo2],
	COUNT(*)							as [TotalRegistros]

	from CONTAARECEBER_R CR 
		JOIN PESSOA_R CLI ON CR.RDESTINATARIO = CLI.OID
		JOIN FILIALCAD FIL ON FIL.OID = CR.REMITENTE
where CR.SITUACAOPREVISAO <= 0

GROUP BY CLI.NOME, 	CR.OID,	FIL.FILIAL,	CR.CODIGO

 -- Contas as receber Inconsistente
 ----------------------------------------------------------------
union select 
	'Conta a Pagar: ' +CLI.NOME			as Referencia,
	FIL.FILIAL							as Filial,
	CR.CODIGO							as [Codigo1],
	CR.OID								as [Codigo2],
	COUNT(*)							as [TotalRegistros]

	from CONTAAPAGAR_R CR 
		JOIN PESSOA_R CLI ON CR.RDESTINATARIO = CLI.OID
		JOIN FILIALCAD FIL ON FIL.OID = CR.REMITENTE
where CR.SITUACAOPREVISAO <= 0

GROUP BY CLI.NOME, 	CR.OID,	FIL.FILIAL,	CR.CODIGO
ORDER BY 2,1,3 asc

-------------------------------------------------------------------------------------------------------------
-- Processamento do dadps
DECLARE @tableHTML  NVARCHAR(MAX), @subjectMSG NVARCHAR(MAX),@dataFim VARCHAR(MAX) 
set @dataFim = (select convert (varchar,GETDATE()-1,103)) + ' 23:59:59'
SET @subjectMSG = 'Vendas e faturamento inconsistentes até: '
set @subjectMSG = @subjectMSG +  @dataFim

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
			Vendas e faturamentos inconsistentes
			 <br> Data de Emissão: ' +  convert(varchar,GETDATE(),104) +
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
				 td = Referencia, '',
				 td = Filial, '',
				 td = Codigo1,'',
				 td = Codigo2, '',	
				 td = TotalRegistros, ''
			from #TEMP_VendasInconsistentes 
			

              FOR XML PATH('tr'), TYPE   
    ) AS NVARCHAR(MAX) ) +  
    N'
	</table> 
	</tbody> ' ;   

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'DBEmail Tobias',  
    @recipients = 'tobiasitin@gmail.com',  
	@copy_recipients = 'infoaconstrular@gmail.com',
    @subject = @subjectMSG,  
	@body =  @tableHTML, 
	@body_format='HTML'; 
	
GO
-- Limpar o cache
------------------------------------------------------------------------
DROP TABLE #TEMP_VendasInconsistentes