-- uspEnviaOcorrenciaSistema
---------------------------------------------------------------------------------------------
USE BDENTER
GO
IF object_id('tempdb..#TEMP_OcorrenciaSistema') IS NOT NULL DROP TABLE #TEMP_OcorrenciaSistema
--PROCESSAMENTO -------------------------------------------------------------------------------------------
Select  
	CASE 
		WHEN SAP.ESTACAO /*+ ' - '+ OCOR.ESTACAO*/ IS NULL THEN 'INDETERMINADO' 
		ELSE SAP.ESTACAO /*+ ' - '+ OCOR.ESTACAO */ 
		END AS Estacao,
	'['+OCOR.SISTEMA+']' + ' - VERSÃO: ' + OCOR.VERSAO as Versao,
	OCOR.USUARIO,
	OCOR.TEXTO,
	OCOR.DATAHORA,
	CASE WHEN SAP.RSESSAODEUSO IS NULL THEN 0 ELSE SAP.RSESSAODEUSO  END as RSessaoDeUso
INTO #TEMP_OcorrenciaSistema
from OCORRENCIASISTEMA OCOR
	LEFT JOIN SESSAOAPLICATIVO SAP ON OCOR.RSESSAOAPLICATIVO = SAP.OID
where 
	OCOR.datahora >= CONVERT (DATE,DATEADD(DAY, -1, GETDATE()))
	and (
	OCOR.texto like '%dead%'
		or OCOR.texto like '%Insert into%'
			or OCOR.texto like '%Update%set%'
				or OCOR.texto like '%Delete%from%'
					or OCOR.texto like '%Nome%objeto%'
						or OCOR.texto like '%coluna%'
							or OCOR.texto like '%object%'
								 or OCOR.texto like '%column%')
---------------------------------------------------------------------------------------------
DECLARE @tableHTML  NVARCHAR(MAX), @data VARCHAR(MAX), @subjectMSG  NVARCHAR(MAX)
DECLARE @dataFim VARCHAR(MAX), @diaSemana VARCHAR(MAX)
DECLARE @count int 
SET @diaSemana				= (select case 
									when (select datepart(dw, getdate())) = 1 then 'Domingo' 
									when (select datepart(dw, getdate())) = 2 then 'Segunda' 
									when (select datepart(dw, getdate())) = 3 then 'Terça' 
									when (select datepart(dw, getdate())) = 4 then 'Quarta' 
									when (select datepart(dw, getdate())) = 5 then 'Quinta' 
									when (select datepart(dw, getdate())) = 6 then 'Sexta' 
								else 'Sábado'
								end)
SET @subjectMSG = 'Ocorrencia de erros do dia '
SET @data = (select  convert (varchar,GETDATE()-1,103))
SET @count = (select count(*) from #TEMP_OcorrenciaSistema)
set @subjectMSG = @subjectMSG + @data 


if @count > 0	-- Se não existir nehum registro informará: "Nenhum registro encontrado..."		

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
				text-align: justify;
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
				<br> Data de Emissão: ' + @diaSemana + ', ' +  @data +
			+N'</th>
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
					td = CASE WHEN ESTACAO /*+ ' - '+ OCOR.ESTACAO*/ IS NULL THEN 'INDETERMINADO' ELSE ESTACAO /*+ ' - '+ OCOR.ESTACAO */ END,'',
					td = VERSAO,'',
					td = USUARIO,'',
					td = TEXTO,'',
					td = DATAHORA,'',
					td = CASE WHEN RSESSAODEUSO IS NULL THEN 0 ELSE RSESSAODEUSO  END,''
				from #TEMP_OcorrenciaSistema
				Order by ESTACAO,USUARIO,DATAHORA

				  FOR XML PATH('tr'), TYPE   
		) AS NVARCHAR(MAX) ) +  
		N'
		</table> 
		</tbody> ' 

else 
	SET @tableHTML = 'Nenhum registro encontrado em: ' + @diaSemana + ', '	+ convert(varchar, getdate(),103);

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'DBEmail Tobias',  
    @recipients = 'tobiasitin@gmail.com',  
	@copy_recipients = 'infoaconstrular@gmail.com',
    @subject =  @subjectMSG,  
	@body =  @tableHTML, 
	@body_format='HTML'; 
	
GO

-- Limpar Cache ---------------------------------------------------------------------------
DROP TABLE #TEMP_OcorrenciaSistema

