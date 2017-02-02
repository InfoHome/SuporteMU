----------------------------------------------------------------------------------------------------------------------------------------------------
-- OCORRENCIASISTEMA
-- Script para buscar ocorrencias de erros assim identificá-lo em qual sistema, versão, estação e etc
----------------------------------------------------------------------------------------------------------------------------------------------------
Select * from OCORRENCIASISTEMA
where year(datahora) = 2016								-- Informe aqui somente o ano
	and month(datahora) = 10							-- Informe aqui somente o mês de 1 a 12
	and day(datahora) = 20 								-- Informe aqui somente o dia, de 1 a 31 quando for o caso
	and datepart(hour,datahora) = 09					-- Informe aqui você informa somente a hora, de 1 a 24.
	and datepart(minute,datahora) between '10' and '15' -- Informe aqui intervalo de minutos que deseja analisar, entre 1 a 60.
	and texto not like 'fch%'
	--and sistema like '%ecf%'
	--and texto not like 'Sessão Aplicativo%'
	--and texto not like 'Sessão de Uso%'
	and usuario = 'JESSICA'

	
--------------------------------------------------------------------------------------
-- Observações:
-- Se pegar o OID da Sessão Aplicativo da para saber o inicio e termino
--------------------------------------------------------------------------------------
-- Exemplo:
----------------
-- Sessão Aplicativo criada. 88595837 Inicio 20/10/16 09:14:11
-- Sessão Aplicativo encerrada. 88595837 Termino 20/10/16 11:13:09
select top 15 * from OcorrenciaSistema where (texto like '%88595837%') -- oid da sessão aplicativo 	

--Tabém da pra saber a verssão utilizada pelo usuário
--------------------------------------------------------------------------------------
select * from SessaoAplicativo_r where oid = 88595837	-- oid da sessão aplicativo 
