--use 

if exists (select 1 from SERIALECF where serialimpressora = '001/BE10EMULADOR00000000')
	Delete from SERIALECF where SERIALIMPRESSORA like '%BE10EMULADOR00000000%'
Go

if not exists (select 1 from SERIALECF where serialimpressora = '001/BE10EMULADOR00000000')
	INSERT INTO [serialecf] (OIDIMPRESSORA,SERIALIMPRESSORA,CODIMP,MODELO,MARCA,VERSAODLL,TIPO,CNIECF,MFADICIONAL,DATAGRAVASB,VERSAOSB,MaxCol)
	VALUES(26674,'001/BE10EMULADOR00000000',26674,'MP-6100 TH FI','BEMATECH','01.01.23','ECF-IF','031801',NULL,'20110101 12:00:00:000','01.01.02',NULL)

Go

update forcffisfat 
	set  string =	REPLACE (STRING ,	--onde vai ser feito a troca
			SUBSTRING(string,8,2) ,	--em que ponto vai ser feito a troca
			'03' )			-- o valor que que eu quero informar 
where codimp = 26674 
	and codigo = '095' 
	and ordem = 1
GO

update TABELAIBPT set VIGENCIAFIM = '21001231'
