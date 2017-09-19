update LISTADEOBJETOS_R 
set especificacao = '=FDisableButtons(oToolPrinc)<BR>Set Procedure To Win1Proc<BR>oAgMenuDinamico.DOFORM ("cadwsenv") <BR>=fEnableButtons(oToolPrinc)<BR>'
where OID = 35076
go
update LISTADEOBJETOS_R 
set especificacao = '=FDisableButtons(oToolPrinc)<BR>SET PROCEDURE TO win1proc<BR>oAgMenuDinamico.DOFORM ("cadwPlanoPagamento")<BR>=fEnableButtons(oToolPrinc)<BR>'
where OID = 35084
go