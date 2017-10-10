--USE [WebSGS]
--GO

--/****** Object:  StoredProcedure [dbo].[uspEnviaRelatorioDeConexoesAtivas]    Script Date: 01/09/2017 11:51:37 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO




--ALTER PROCEDURE [dbo].[uspEnviaRelatorioDeConexoesAtivas]
--as
DECLARE @tableHTML  NVARCHAR(MAX) ;  

SET @tableHTML =  
	N'<head>
		<style>
		.alert{
			background-color: #cccccc;
			padding: 15px;
			color: #ffffff;
		}
		.table {
			 border-collapse: collapse !important;
		}
		.table td,
		.table th {
			background-color: #fff !important;
		}
		.table-bordered th,
		.table-bordered td {
			border: 1px solid #ddd !important;
		  }
			
		</style>
	</head>
	<h1 class="alert">Relatório de conexões ativas</h1>
    <table class="table able-bordered">
    <tr>
		<th>Cliente</th>
		<th>Login Extranet</th>
		<th>Senha Extranet</th>
		<th>Tipo Conexão</th>
		<th>Domínio</th>
		<th>Usuário</th>
		<th>Senha</th>
		<th>URL</th>
		<th>Observação</th>
	</tr>'+
    CAST ( ( SELECT top 5 td = cli.Nome,       '',  
                    td = case when cli.LoginExtranet = '' or cli.LoginExtranet is null then '' else cli.LoginExtranet end, '',  
                    td = case when cli.SenhaExtranet = '' or cli.SenhaExtranet is null then ';' else cli.SenhaExtranet end, '',  
                    td = case when con.tipo = '' or con.tipo is null then ';' else con.tipo end, '',  
                    td = case when con.Dominio = '' or con.Dominio is null then ';' else con.Dominio end, '',  
					td = case when con.Usuario = '' or con.Usuario is null then ';' else con.Usuario end, '',  
					td = case when con.Senha = '' or con.Senha is null then '' else con.Senha end, '',  
					td = case when con.StrConexao = '' or con.StrConexao  is null then '' else con.StrConexao end, '',  
                    td = case when con.Observacao = '' or con.Observacao is null then '' else  con.Observacao end
              from Conexao con 	
			  join cliente cli on con.ClienteId = cli.ClienteId 
				and con.ativo = 1
				order by cli.Nome
              FOR XML PATH('tr'), TYPE   
    ) AS NVARCHAR(MAX) ) +  
    N'</table>' ;  

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'Suporte Info',  
    @recipients = 'tobias@microuniverso.com.br',  
    @subject = 'Lista de Conexões Suporte Inteligente',  
	@body =  @tableHTML, 
	@body_format='HTML'; 




GO


