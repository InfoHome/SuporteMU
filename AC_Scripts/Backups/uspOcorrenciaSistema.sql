--CREATE PROCEDURE [dbo].[uspEnviaOcorrenciaSistema]
--as
--------------------------------------------------------------------------------------------
USE BDENTER

DECLARE @tableHTML  NVARCHAR(MAX), @data VARCHAR(MAX), @subjectMSG  NVARCHAR(MAX)

SET @subjectMSG = 'Ocorrencia de erros do dia '
SET @data = (select  convert (varchar,GETDATE()-1,103))

set @subjectMSG = @subjectMSG + @data

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
			text-align: center;
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
			color: #039;
			}
			tr:nth-child(odd) { background-color:black; }
			tr:nth-child(even) { background-color:red; } 
		</style>
	</head>
	
    <table  id="box-table">
	 <thead>
	 <tr>
		 <th colspan="6" class="alert">
			Erros registrados na Ocorrencia Sistema
		 </th>
	 </tr>
		<tr>
			<th>Estação</th>
			<th>Sistema</th>
			<th>Usuário</th>
			<th>Mensagem</th>
			<th>Data</th>
			<th>Sessao de Uso</th>
		</tr>
	 </thead>
	 <tbody>' +
    CAST ( ( 
			Select  
				td = CASE WHEN SAP.ESTACAO /*+ ' - '+ OCOR.ESTACAO*/ IS NULL THEN 'INDETERMINADO' ELSE SAP.ESTACAO /*+ ' - '+ OCOR.ESTACAO */ END,'',
				td = '['+OCOR.SISTEMA+']' + ' - VERSÃO: ' + OCOR.VERSAO,'',
				td = OCOR.USUARIO,'',
				td = OCOR.TEXTO,'',
				td = OCOR.DATAHORA,'',
				td = CASE WHEN SAP.RSESSAODEUSO IS NULL THEN 0 ELSE SAP.RSESSAODEUSO  END,''
			from OCORRENCIASISTEMA OCOR
				LEFT JOIN SESSAOAPLICATIVO SAP ON OCOR.RSESSAOAPLICATIVO = SAP.OID
			where 
				OCOR.datahora >= convert (date,DATEADD(DAY, -1, GETDATE()))
				and (
				OCOR.texto like '%dead%'
					or OCOR.texto like '%Insert into%'
						or OCOR.texto like '%Update%set%'
							or OCOR.texto like '%Delete%from%'
								or OCOR.texto like '%Nome%objeto%'
									or OCOR.texto like '%coluna%'
										or OCOR.texto like '%object%'
											 or OCOR.texto like '%column%')
			Order by OCOR.ESTACAO,OCOR.USUARIO,OCOR.DATAHORA

              FOR XML PATH('tr'), TYPE   
    ) AS NVARCHAR(MAX) ) +  
    N'
	</table> 
	</tbody> ' ;  

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'DBEmail Tobias',  
    @recipients = 'tobiasitin@gmail.com',  
	@copy_recipients = 'infoaconstrular@gmail.com',
    @subject =  @subjectMSG,  
	@body =  @tableHTML, 
	@body_format='HTML'; 
	
GO
