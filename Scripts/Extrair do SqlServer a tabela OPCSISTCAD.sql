----------------------------------------------------------------------------------------------------------------------------------------------------
-- Script para extrair do SqlServer a tabela OPCSISTCAD
----------------------------------------------------------------------------------------------------------------------------------------------------
Select 
	'insert into opcsistcad(codsis, codopc, nomeopc, ativado, razdesativ, mensagem, ' 
	+ 'numeroativ, mediauso, numdemeses, usoultmes) values (''' + RTrim(codsis) + ''', ''' 
	+ RTrim(codopc)  
	+ ''', ''' + RTrim(nomeopc) + ''', ''' + RTrim(ativado) + ''', '+''''+ 
	+ RTrim(razdesativ)+ ''''+ ', ' +''''+ RTrim(mensagem) + ''''+', '
	+ RTrim(numeroativ)+ ', ' + RTrim(mediauso) 
	+ ', ''' + RTrim(numdemeses) + ''', ''' + RTrim(usoultmes) + ''')'
+ CHAR (13) 
 from opcsistcad where codsis='sis'
