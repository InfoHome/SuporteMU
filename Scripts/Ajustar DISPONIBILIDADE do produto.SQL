		-----------------------------------------------------------------------------------------------------------------
-- ENTENDIMENTO E SCRIPTS
-----------------------------------------------------------------------------------------------------------------
/*
ASSUNTO..................................: 	SCRIPT PARA AJUSTAR DISPONIBILIDADE DO PRODUTO 
MOTIVO DE CRIA��O DESTE SCRIPT...........: 	ATENDIMENTO 259514
AUTOR....................................:  JOS� TOBIAS DE OLIVEIRA ALMEIDA
DATA CRIACA��O...........................:	26/04/2014
ORIGEM DO PROBLEMA.......................: 	(SISTEMA DE USU�RIO / MOVIMENTOS / ATUALIZA��O DE PRODUTO / 
														DEFINI��O DE DISPONIBILIDADE DE PRODUTOS PARA VENDA)
VERS�O DO SISTEMA IDENTIFICADA O ERRO....:
PROBLEMA.................................: 	O CLIENTE UTILIZOU A FERRAMENTA ACIMA E ALEGOU QUE O SISTEMA ESTAVA 
											ALTERANDO A DISPONIBILIDADE DE TODOS OS 
											PRODUTOS MESMO SELECIONANDO UM �NICO PRODUTO PARA A DETERMINADA AREA DE VENDAS.
PROBLEMA FOI SIMULA��O...................:  SIM( X ) | N�O (  )
OCORREU O PROBLEMA?......................:	SIM( X ) | N�O (  )
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
			AND L.DATA BETWEEN '20140626' 	-- INFORMAR DATA DO DIA INICIAL DA ALTERA��O
			AND '20140626 23:59:38.000') 	-- INFORMAR DATA DO DIA FINAL DA ALTERA��O
-- ROLLBACK 
-- COMMIT	
-----------------------------------------------------------------------------------------------------------------