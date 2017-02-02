--------------------------------------------------------------------------------------------------------
-- Script para ajustar nota para Denegada
	/*
	* As vezes o usuário vê a nota no gerencimento de exceções e clicar em solucionar ou em inutilizar
	* quando a nota está marcando que é para denegar, dessa forma é necessário ajustar o bando de dados
	*/
--------------------------------------------------------------------------------------------------------
-- Ajustar a complementonfsaida, a situacaonfe tem que ficar = 'B'
--------------------------------------------------------------------------
update complementonfsaida set 
	situacaonfe = 'B',
	chavedeacessonfe = '29160208010381000444550010001501241110128257', 
	numeroprotocolo = '129160010109924',
	dhprotocolo = '20160203 15:49:40'
where numord = '' -- Insere aqui o Numor da NFe

--------------------------------------------------------------------------
-- Inserir o histórico na tabela INCONSISTENCIANFE
-- Obs.: esse por ordem de data de processamento tem que ser o último
--------------------------------------------------------------------------
insert into INCONSISTENCIANFE (numord,codmensagem,descricao,dataprocessamento)
values (1698498,'302','Erro. Mensagem: Nota não confirmada pela SEFAZ. Uso Denegado: Irregularidade fiscal do destinatario', GETDATE()) 