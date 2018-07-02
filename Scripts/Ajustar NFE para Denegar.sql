--------------------------------------------------------------------------------------------------------
-- Script para ajustar nota para Denegada
	/*
	* As vezes o usuário vê a nota no gerencimento de exceções e clicar em solucionar ou em inutilizar
	* quando a nota está marcando que é para denegar, dessa forma é necessário ajustar o bando de dados
	*/

--------------------------------------------------------------------------------------------------------
-- Ajustar a complementonfsaida, a situacaonfe tem que ficar = 'B'
--------------------------------------------------------------------------
select numord,lif,atualiz,dtcancel,flagemit,* from NFSAIDACAD where numnota = '060485'
select situacaonfe,chavedeacessonfe,numeroprotocolo,dhprotocolo,* from complementonfsaida where numord = 1333198

update complementonfsaida set 
	situacaonfe = 'B',
	chavedeacessonfe = '31180542958249000316550010000604851645600106', 
	numeroprotocolo = '131182943506456',
	dhprotocolo = '20180530 06:23:14'
where numord = 1333198

--------------------------------------------------------------------------
-- Inserir o histórico na tabela INCONSISTENCIANFE
-- Obs.: esse por ordem de data de processamento tem que ser o último
--------------------------------------------------------------------------
insert into INCONSISTENCIANFE (numord,codmensagem,descricao,dataprocessamento)
values (1333198,'302','Erro. Mensagem: Nota não confirmada pela SEFAZ. Uso Denegado: Irregularidade fiscal do destinatario', GETDATE()) 