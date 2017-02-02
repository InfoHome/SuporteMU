		-----------------------------------------------------------------------------------------------------------------
-- ENTENDIMENTO E SCRIPTS
-----------------------------------------------------------------------------------------------------------------
/*
ASSUNTO..................................: 	SCRIPT PARA AJUSTAR DISPONIBILIDADE DO PRODUTO 
MOTIVO DE CRIAÇÃO DESTE SCRIPT...........: 	ATENDIMENTO 259514
AUTOR....................................:  JOSÉ TOBIAS DE OLIVEIRA ALMEIDA
DATA CRIACAÇÃO...........................:	26/04/2014
ORIGEM DO PROBLEMA.......................: 	(SISTEMA DE USUÁRIO / MOVIMENTOS / ATUALIZAÇÃO DE PRODUTO / 
														DEFINIÇÃO DE DISPONIBILIDADE DE PRODUTOS PARA VENDA)
VERSÃO DO SISTEMA IDENTIFICADA O ERRO....:
PROBLEMA.................................: 	O CLIENTE UTILIZOU A FERRAMENTA ACIMA E ALEGOU QUE O SISTEMA ESTAVA 
											ALTERANDO A DISPONIBILIDADE DE TODOS OS 
											PRODUTOS MESMO SELECIONANDO UM ÚNICO PRODUTO PARA A DETERMINADA AREA DE VENDAS.
PROBLEMA FOI SIMULAÇÃO...................:  SIM( X ) | NÃO (  )
OCORREU O PROBLEMA?......................:	SIM( X ) | NÃO (  )
SE SIMULOU, QUEM FOI?....................:	
*/
-----------------------------------------------------------------------------------------------------------------
SCRIPT

BEGIN TRANSACTION

UPDATE PRODUTOCAD SET Disponibilidade = '21073' -- ALTERA PARA DISPONIBILIDADE DE LINHA
	WHERE codpro IN (SELECT L.CODPRO
		FROM LOGOPERCAD L 
			INNER JOIN PRODUTOCAD P ON L.CODPRO = P.CODPRO
		WHERE L.ARQUIVO = 'AREAPRECAD'
			AND L.DATA BETWEEN '20140626' 	-- INFORMAR DATA DO DIA INICIAL DA ALTERAÇÃO
			AND '20140626 23:59:38.000') 	-- INFORMAR DATA DO DIA FINAL DA ALTERAÇÃO
-- ROLLBACK 
-- COMMIT	
-----------------------------------------------------------------------------------------------------------------