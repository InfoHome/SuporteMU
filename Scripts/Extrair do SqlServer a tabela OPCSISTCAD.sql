----------------------------------------------------------------------------------------------------------------------------------------------------
-- Script para extrair do SqlServer a tabela OPCSISTCAD
----------------------------------------------------------------------------------------------------------------------------------------------------
/*
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
 */
 --Testes
 ---------------------
 Select top 1 'IF NOT EXISTS (SELECT 1 FROM OPCSISTCAD WHERE CODSIS = '''+ RTrim(codsis)	+ ''' AND codopc = ''' + RTrim(codopc)+''')' + char(13)+char(10)
		+ 'GO' + char(13)+char(10)
		+ 'insert into opcsistcad(codsis, codopc, nomeopc, ativado, razdesativ, mensagem, numeroativ, mediauso, numdemeses, usoultmes)' +char(13)+char(10)
		+ 'values ('''+ RTrim(codsis) +''', '''+ RTrim(codopc) +''', ''' +RTrim(nomeopc)+ ''', ''' +RTrim(ativado) + ''', '+''''+ RTrim(razdesativ)+ '''' + ', ' +'''' + RTrim(mensagem) + ''''+', ' + RTrim(numeroativ)+ ', ' + RTrim(mediauso) + ', ''' + RTrim(numdemeses) + ''', ''' + RTrim(usoultmes) + ''')' 
from opcsistcad where codsis='sis'

