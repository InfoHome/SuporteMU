---------------------------------------------------------------------------------------------------------------
-- Borderô, Cobrança Escritura
-- Consulta se ocorreu o retorno com a ocorrencia "Entrada Confirmada" para determinado arquivo de envio
---------------------------------------------------------------------------------------------------------------

 Select	
	cli.NOME,							-- Nome do Cliente
	cr.VALORNAMOEDA1,					-- Valor Total do CR
	cr.CREDITOACUMULADO,				-- Valor Parcial CR
	cr.CODIGO,							-- Código do Documento
	cr.SITUACAOPREVISAO,				-- Situação de previsão do CR
	sit.NOME,							-- Situação do CR
	rem.DATA as Data_Envio,				-- Data de geração do arquivo de Envido(Remessa)
	rem.ARQUIVO,						-- Caminho do arquivo gerado de Remessa
	rem.DESCRICAO as Descr_Envio,       -- Linha do arquivo de Remessa
	ent.DATA as Data_Retorno,			-- Data de geração do arquivo de Envido(Remessa)
	ent.ARQUIVO,						-- Caminho do arquivo gerado de Remessa
	ent.DESCRICAO as Descr_Retorno		-- Linha do arquivo de Remessa
 from 
	AGENDAMENTO_R rem join AGENDAMENTO_R ent on rem.RITEM = ent.RITEM	-- oid do CR no envio e retorno
		and rem.ROCORRENCIA = 4881183	--Remessa
		and ent.ROCORRENCIA = 4881185	--Entrada Confirmada
	join contaareceber_r cr on cr.OID = rem.RITEM and cr.OID = ent.RITEM	-- buscar os dados do CR
	join item cli on cr.RCLIENTE = cli.oid			-- buscar cliente
	join item sit on cr.RSITUACAO = sit.oid			-- buscar a situação do pedido
where 
	rem.arquivo like '%CB001470%'					-- Filtrar pelo arquivo de Envio
	--ent.arquivo like '%CN18057A%'			-- Filtrar pelo arquivo de Retorno
order by rem.DATA desc
 
 
 -- Filtro somente arquivo de envio (Remessa)
 ----------------------------------------------------------------
select 
	a.RITEM, c.CODIGO, c.valornamoeda1, cli.nome,a.arquivo,a.data
from 
	AGENDAMENTO_R a join contaareceber_r c on a.ritem = c.oid  and a.ROCORRENCIA = 4881183 --Remessa
	join item cli on c.RCLIENTE = cli.oid
--where  c.CODIGO like '%007201%'
order by a.arquivo desc
 
 -- Filtro somente arquivo de retorno (Entrada Confirmada)
 ----------------------------------------------------------------
select 
	a.RITEM, c.CODIGO, c.valornamoeda1, cli.nome,a.arquivo,a.data
from 
	AGENDAMENTO_R a join contaareceber_r c on a.ritem = c.oid  and a.ROCORRENCIA = 4881185 --Entrada Confirmada
	join item cli on c.RCLIENTE = cli.oid
--where  c.CODIGO like '%007201%'
order by a.arquivo desc
