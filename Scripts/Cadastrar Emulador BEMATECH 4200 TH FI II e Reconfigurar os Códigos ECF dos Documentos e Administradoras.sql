/********************************************************************************************************************
 A T E N Ç Ã O
 Esse Script efetua as seguintes alterações no banco de dados para utilizar o Emulador:
 
 1 - Cadastra o modelo do ECF: MP-4200 TH FI II
 2 - Cadastra no cadastro de impressoras os emuladores: 001/BE10EMULADOR00000000 e 001/BE11EMULADOR00000000
 3 - Altera a data de vigência da tabela IBPT
 4 - ****** Ajusta o código ECF dos documentos e administradores cadastrados no sistema, na tabela "NUMERADOR"
 5 - Ajusta o código do RECEBIMENTO para '03' no formatador da BEMATECH codimp 26674
 6 - Ajusta a ForCfFisfat codimp = 26674 a codigo = 260 com as alíquotas padrões definidas para o EMULADOR
 7 - Ajusta a ForCfFisfat codimp = 26674 a codigo in('095','096','180') para usar a classe "TrataPagto"
**********************************************************************************************************************/

-- Cadastra o modelo do ECF
-----------------------------------------------------------------------------
PRINT 'Cadastra o modelo do ECF'
if not exists (select 1 from TABELACNIECF where CNIECF = '032203')
insert into TABELACNIECF values ('BEMATECH','MP-4200 TH FI II','ECF-IF','01.00.02','032303')
GO

-- Cadastra as impressoras
-----------------------------------------------------------------------------
PRINT 'Cadastra as impressoras'
if exists (select 1 from SERIALECF where serialimpressora = '001/BE10EMULADOR00000000')
	Delete from SERIALECF where SERIALIMPRESSORA like '%BE10EMULADOR00000000%'
GO
if not exists (select * from SERIALECF where serialimpressora = '001/BE10EMULADOR00000000')
	INSERT INTO [serialecf] (OIDIMPRESSORA,SERIALIMPRESSORA,CODIMP,MODELO,MARCA,VERSAODLL,TIPO,CNIECF,MFADICIONAL,DATAGRAVASB,VERSAOSB)
	VALUES(26674,'001/BE10EMULADOR00000000',26674,'MP-4200 TH FI II','BEMATECH','7.0.3.8','ECF-IF','032303',NULL,'20110101 12:00:00:000','01.01.02')
GO
if exists (select 1 from SERIALECF where serialimpressora = '001/BE11EMULADOR00000000')
	Delete from SERIALECF where SERIALIMPRESSORA like '%BE11EMULADOR00000000%'
GO
if not exists (select 1 from SERIALECF where serialimpressora = '001/BE11EMULADOR00000000')
	INSERT INTO [serialecf] (OIDIMPRESSORA,SERIALIMPRESSORA,CODIMP,MODELO,MARCA,VERSAODLL,TIPO,CNIECF,MFADICIONAL,DATAGRAVASB,VERSAOSB)
	VALUES(26674,'001/BE11EMULADOR00000000',26674,'MP-4200 TH FI II','BEMATECH','7.0.3.8','ECF-IF','032303',NULL,'20110101 12:00:00:000','01.01.02')
GO

-- Altera a data de vidência da tabela IBPT
-----------------------------------------------------------------------------
PRINT  'Altera a data de vigência da tabela IBPT'
if exists (select 1 from sys.columns where OBJECT_ID = 1183095751 and name = 'VIGENCIAFIM')
Update TABELAIBPT set VIGENCIAFIM = '20201231'
GO

-- Ajusta o código do RECEBIMENTO
-----------------------------------------------------------------------------
/*PRINT 'Ajusta o código do RECEBIMENTO'
update forcffisfat 
	set  string =	REPLACE (STRING ,	--onde vai ser feito a troca
	SUBSTRING(string,8,2) ,	--em que ponto vai ser feito a troca
	'03' )	-- o valor que que eu quero informar 
where codimp = 26674 
	and codigo = '095' 
	and ordem = 1
GO
*/

-- Ajusta Tratar Forma de Pagamento
-----------------------------------------------------------------------------
PRINT 'Ajustando para classe TrataPagto'
Delete from FORCFFISFAT where codimp = '26674' and codigo in ('095','096','180')
GO
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '095', 1, '''"'' + ''03'' + ''"'' + "," + ''"'' + TRANSFORM(INT(nValorOP*100)) + ''"'' + '',''', 1)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '095', 2, '''"'' + Left(TrataPagto(cDoc,.t.),16) + ''"''', 1)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '095', 3, 'ImpCmd(''Bematech_FI_RecebimentoNaoFiscal(&cCmdAux)'')', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '096', 1, '''"'' + TrataPagtoEstorno(pnOIDDocumento,.F.) + ''"'' + "," + ''"'' + StrZero(pnValParc*100,14) + ''"'' + '','' + ''"Estorno"''', 1)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '096', 2, 'ImpCmd(''Bematech_FI_RecebimentoNaoFiscal(&cCmdAux)'')', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '180', 1, '''"'' + Left(TrataPagto(Documen.Oid,.t.),16) + ''"'' + '','' + ''"'' + StrZero(Left(Str(nValParc,15,2),12) + Right(Str(nValParc,15,2),2),14) + ''"''', 1)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '180', 2, 'ImpCmd(''Bematech_FI_EfetuaFormaPagamento(&cCmdAux)'')', 0)
GO
-- Ajusta as Alíquotas
-----------------------------------------------------------------------------
PRINT 'Ajusta as Alíquotas FORCFFISFAT'
Delete from FORCFFISFAT where codimp = 26674 and codigo = '260'
GO
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 1, '''I'' - {II}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 2, '''S'' - {FF}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 3, '''N'' - {NN}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 4, '''O'' - {NN}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 5, '''A'' - {FF}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 6, '01.80 - {01}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 7, '04.00 - {02}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 8, '04.10 - {03}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 9, '05.00 - {04}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 10, '05.14 - {05}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 11, '05.60 - {06}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 12, '07.00 - {07}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 13, '08.80 - {08}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 14, '10.50 - {09}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 15, '12.00 - {10}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 16, '13.20 - {11}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 17, '14.40 - {12}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 18, '17.00 - {13}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 19, '18.00 - {14}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 20, '19.00 - {15}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 21, '25.00 - {16}', 0)
GO


PRINT 'Ajustar documento de recebimento padrão do usuário'
if exists (select 1 from ADITIVO_R where RDEFINICAO = 31266 and ritem = 1)
update ADITIVO_R set svalor = 'Recebimento' where RDEFINICAO = 31266 and ritem = 1
else
Insert ADITIVO_R (dtvalor,LSVALOR,SVALOR,NVALOR,RITEM,RDEFINICAO)
values(NULL,'','Recebimento',NULL,1,31266)
GO

PRINT 'Ajustar porta COM do usuário para COM2'
if exists (select 1 from ADITIVO_R where RDEFINICAO = 23750 and ritem = 1)
update ADITIVO_R set svalor = 'COM2' where RDEFINICAO = 23750 and ritem = 1
else
Insert ADITIVO_R (dtvalor,LSVALOR,SVALOR,NVALOR,RITEM,RDEFINICAO)
values(NULL,'','COM2',NULL,1,23750)
GO

PRINT 'Ajustar modelo da Impressora usuário para 26674'
if exists (select 1 from ADITIVO_R where RDEFINICAO = 21330 and ritem = 1)
update ADITIVO_R set svalor = 26674 where RDEFINICAO = 21330 and ritem = 1
else
Insert ADITIVO_R (dtvalor,LSVALOR,SVALOR,NVALOR,RITEM,RDEFINICAO)
values(NULL,'',26674,NULL,1,21330)
GO

-- Ajuste dos códigos ECF
-------------------------------------------------------------------------
PRINT 'Ajuste dos códigos ECF dos Documentos e Administradoras'
UPDATE NUMERADOR SET 
	SUFIXO = 'Estorno',
	PREFIXO = CASE 
				WHEN UPPER(Prefixo) LIKE '%CART%O%'		THEN 'Cartões C/D' 
				WHEN UPPER(Prefixo) LIKE '%FINANCEIRA%'	THEN 'Financeira' 
				WHEN UPPER(Prefixo) LIKE 'DINHEIRO%'	THEN 'Dinheiro' 
				WHEN UPPER(Prefixo) LIKE 'CHEQUE'		THEN 'Cheque' 
				WHEN UPPER(Prefixo) LIKE 'CHEQUE%P%'	THEN 'Cheque Pré' 
				WHEN UPPER(Prefixo) LIKE 'BOLETO%'		THEN 'Boleto' 
				WHEN UPPER(Prefixo) LIKE 'DUPLICATA%'	THEN 'Duplicata' 
				WHEN UPPER(Prefixo) LIKE 'RECEBIMENTO%'	THEN 'Recebimento' 
				WHEN UPPER(Prefixo) LIKE 'ELO%'			THEN 'Cartões C/D' 
				WHEN UPPER(Prefixo) LIKE 'CIELO%'		THEN 'Cartões C/D' 
				WHEN UPPER(Prefixo) LIKE 'MASTERCAR%'	THEN 'Cartões C/D' 
				WHEN UPPER(Prefixo) LIKE 'HIPER%'		THEN 'Cartões C/D' 
				WHEN UPPER(Prefixo) LIKE 'AMERICA%'		THEN 'Cartões C/D' 
				WHEN UPPER(Prefixo) LIKE 'AMEX%'		THEN 'Cartões C/D' 
				WHEN ISNUMERIC(Prefixo)=1 THEN (select 
													CASE 
														WHEN UPPER(NOME) LIKE '%CART%O%'		THEN 'Cartões C/D' 
														WHEN UPPER(NOME) LIKE '%FINANCEIRA%'	THEN 'Financeira' 
														WHEN UPPER(NOME) LIKE 'DINHEIRO%'		THEN 'Dinheiro' 
														WHEN UPPER(NOME) LIKE 'CHEQUE'			THEN 'Cheque' 
														WHEN UPPER(NOME) LIKE 'CHEQUE%P%'		THEN 'Cheque Pré' 
														WHEN UPPER(NOME) LIKE 'BOLETO%'			THEN 'Boleto' 
														WHEN UPPER(NOME) LIKE 'DUPLICATA%'		THEN 'Duplicata' 
														WHEN UPPER(NOME) LIKE 'RECEBIMENTO%'	THEN 'Recebimento' 
														WHEN UPPER(NOME) LIKE 'ELO%'			THEN 'Cartões C/D' 
														WHEN UPPER(NOME) LIKE 'CIELO%'			THEN 'Cartões C/D' 
														WHEN UPPER(NOME) LIKE 'MASTERCAR%'		THEN 'Cartões C/D' 
														WHEN UPPER(NOME) LIKE 'HIPER%'			THEN 'Cartões C/D' 
														WHEN UPPER(NOME) LIKE 'AMERICA%'		THEN 'Cartões C/D' 
														WHEN UPPER(NOME) LIKE 'AMEX%'			THEN 'Cartões C/D' 
														ELSE NOME
													END
				from item where oid = RITEM)
		else Prefixo 
		end 
