-----------------------------------------------------------------------------------------------------------------
-- ENTENDIMENTO E SCRIPTS
-----------------------------------------------------------------------------------------------------------------
/*
ASSUNTO..................................: 	ATD-299325 SCRIPT PARA RENUMERAR O CODCOMPONENTE.SQL
MOTIVO DE CRIA��O DESTE SCRIPT...........: 	ATENDIMENTO 299325
AUTOR....................................:  JOS� TOBIAS DE OLIVEIRA ALMEIDA
DATA CRIACA��O...........................:	23/06/2016
ORIGEM DO PROBLEMA.......................: 	Desconhecido.
VERS�O DO SISTEMA IDENTIFICADA O ERRO....:
PROBLEMA.................................: 	Na tabela COMPONENTEFORMULA alterou o Identity no campo CodComponente
PROBLEMA FOI SIMULA��O...................:  SIM( X ) | N�O (  )
OCORREU O PROBLEMA?......................:	SIM(  ) | N�O ( X )
SE SIMULOU, QUEM FOI?....................:	JOS� TOBIAS DE OLIVEIRA ALMEIDA
*/
-----------------------------------------------------------------------------------------------------------------

Solu��o:

1 - Efetuar o procedimento abaixo para renumera o CodComponente das Tabelas Relacionadas:

--------------------------------------------------------------------------
USE BDENTER
GO
--------------------------------------------------------------------------

1 /* CRIAR UMA COLUNA identity NA TABELA COMPONENTEFORMULA */
-- Alter table COMPONENTEFORMULA add CodComp int identity(1,1) not null

2 /* CRIAR UMA TABELA TEMPOR�RIA COM O CODIGO NOVO E CODIGO ANTIGO */
 -- select  CodComp, CODCOMPONENTE into CompFormula_Temp from CompFormula

3 /* DEFINIR QUAIS TABELAS DEVEM FAZER O "DE >> PARA" */ 

4 /*AJUSTAR O CURSOR CurRenumeraCodComponente para atualizar as tabelas necess�rias*/

declare @CodigoNovo INT , @CodigoAntigo int, @sql varchar(500)
declare CurRenumeraCodComponente cursor for 
			
			select 
				tp.Codcomp, tp.codcomponente
			from 
				COMPONENTEFORMULA cP, CompFormula_Temp tp 
			where 
				cP.CODCOMPONENTE = tp.CODCOMPONENTE 
				
open CurRenumeraCodComponente
fetch CurRenumeraCodComponente into  @CodigoNovo, @CodigoAntigo
while @@fetch_status <> -1
begin
    select @sql = 'UPDATE COMPLEMENTOPRODUTO SET CODCOMPONENTE = ''' + cast(@CodigoNovo  as varchar) + ''' where CODCOMPONENTE = ' + cast(@CodigoAntigo as varchar)
	------------------------------------------------------------------------------------------------------------------
    --Ponto de Consulta e Ajuste
    ------------------------------------------------------------------------------------------------------------------
    print @sql		-- Descomente o in�cio dessa linha e comente o in�cio da linha DEBAIXO para s� CONSULTAR
    --execute(@sql)		-- Descomente o in�cio dessa linha e comente a o in�cio da linha ACIMA para AJUSTAR
    ------------------------------------------------------------------------------------------------------------------
    fetch CurRenumeraCodComponente into  @CodigoNovo, @CodigoAntigo
end
close CurRenumeraCodComponente
deallocate CurRenumeraCodComponente


5 /* EXCLUIR A COLUNA ANTIGA da COMPONENTEFORMULA */ 
-- ALTER TABLE dbo.COMPONENTEFORMULA DROP COLUMN CODCOMPONENTE ;  

6 /* ALTERAR O NOME DA COLUNA na COMPONENTEFORMULA */
-- EXEC SP_RENAME 'COMPONENTEFORMULA.Codcomp', 'CODCOMPONENTE', 'COLUMN'








