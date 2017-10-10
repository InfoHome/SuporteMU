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
		table {
			border-collapse: collapse;
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
		.table {
  width: 100%;
  max-width: 100%;
  margin-bottom: 1rem;
  background-color: transparent;
}

.table th,
.table td {
  padding: 0.75rem;
  vertical-align: top;
  border-top: 1px solid #e9ecef;
}

.table thead th {
  vertical-align: bottom;
  border-bottom: 2px solid #e9ecef;
}

.table tbody + tbody {
  border-top: 2px solid #e9ecef;
}

.table .table {
  background-color: #fff;
}

.table-sm th,
.table-sm td {
  padding: 0.3rem;
}

.table-bordered {
  border: 1px solid #e9ecef;
}

.table-bordered th,
.table-bordered td {
  border: 1px solid #e9ecef;
}

.table-bordered thead th,
.table-bordered thead td {
  border-bottom-width: 2px;
}

.table-striped tbody tr:nth-of-type(odd) {
  background-color: rgba(0, 0, 0, 0.05);
}

.table-hover tbody tr:hover {
  background-color: rgba(0, 0, 0, 0.075);
}

.table-primary,
.table-primary > th,
.table-primary > td {
  background-color: #b8daff;
}

.table-hover .table-primary:hover {
  background-color: #9fcdff;
}

.table-hover .table-primary:hover > td,
.table-hover .table-primary:hover > th {
  background-color: #9fcdff;
}

.table-secondary,
.table-secondary > th,
.table-secondary > td {
  background-color: #dddfe2;
}

.table-hover .table-secondary:hover {
  background-color: #cfd2d6;
}

.table-hover .table-secondary:hover > td,
.table-hover .table-secondary:hover > th {
  background-color: #cfd2d6;
}

.table-success,
.table-success > th,
.table-success > td {
  background-color: #c3e6cb;
}

.table-hover .table-success:hover {
  background-color: #b1dfbb;
}

.table-hover .table-success:hover > td,
.table-hover .table-success:hover > th {
  background-color: #b1dfbb;
}

.table-info,
.table-info > th,
.table-info > td {
  background-color: #bee5eb;
}

.table-hover .table-info:hover {
  background-color: #abdde5;
}

.table-hover .table-info:hover > td,
.table-hover .table-info:hover > th {
  background-color: #abdde5;
}

.table-warning,
.table-warning > th,
.table-warning > td {
  background-color: #ffeeba;
}

.table-hover .table-warning:hover {
  background-color: #ffe8a1;
}

.table-hover .table-warning:hover > td,
.table-hover .table-warning:hover > th {
  background-color: #ffe8a1;
}

.table-danger,
.table-danger > th,
.table-danger > td {
  background-color: #f5c6cb;
}

.table-hover .table-danger:hover {
  background-color: #f1b0b7;
}

.table-hover .table-danger:hover > td,
.table-hover .table-danger:hover > th {
  background-color: #f1b0b7;
}

.table-light,
.table-light > th,
.table-light > td {
  background-color: #fdfdfe;
}

.table-hover .table-light:hover {
  background-color: #ececf6;
}

.table-hover .table-light:hover > td,
.table-hover .table-light:hover > th {
  background-color: #ececf6;
}

.table-dark,
.table-dark > th,
.table-dark > td {
  background-color: #c6c8ca;
}

.table-hover .table-dark:hover {
  background-color: #b9bbbe;
}

.table-hover .table-dark:hover > td,
.table-hover .table-dark:hover > th {
  background-color: #b9bbbe;
}

.table-active,
.table-active > th,
.table-active > td {
  background-color: rgba(0, 0, 0, 0.075);
}

.table-hover .table-active:hover {
  background-color: rgba(0, 0, 0, 0.075);
}

.table-hover .table-active:hover > td,
.table-hover .table-active:hover > th {
  background-color: rgba(0, 0, 0, 0.075);
}

.thead-inverse th {
  color: #fff;
  background-color: #212529;
}

.thead-default th {
  color: #495057;
  background-color: #e9ecef;
}

.table-inverse {
  color: #fff;
  background-color: #212529;
}

.table-inverse th,
.table-inverse td,
.table-inverse thead th {
  border-color: #32383e;
}

.table-inverse.table-bordered {
  border: 0;
}

.table-inverse.table-striped tbody tr:nth-of-type(odd) {
  background-color: rgba(255, 255, 255, 0.05);
}

.table-inverse.table-hover tbody tr:hover {
  background-color: rgba(255, 255, 255, 0.075);
}

@media (max-width: 991px) {
  .table-responsive {
    display: block;
    width: 100%;
    overflow-x: auto;
    -ms-overflow-style: -ms-autohiding-scrollbar;
  }
  .table-responsive.table-bordered {
    border: 0;
  }
}

		</style>
	</head>
	<h1 class="alert">Relatório de conexões ativas</h1>
    <table class="table able-bordered table-striped table-hover">
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


