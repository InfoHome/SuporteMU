/********************************************************************************************************************
 A T E N Ç Ã O
 Esse Script efuteua a seguintes alterações no banco de dados para utilizar o Emulador:
 
 1 - Cadastra o modelo do ECF: MP-4200 TH FI II
 2 - Cadastra no cadastro de impressoras os emuladores: 001/BE10EMULADOR00000000 e 001/BE11EMULADOR00000000
 3 - Altera a data de vidência da tabela IBPT
 4 - ****** Ajusta o código ECF dos documentos e administradores cadastrados no sistema, na tabela "NUMERADOR"
 5 - Ajusta o código do RECEBIMENTO para '03' no formatador da BEMATECH codimp 26674
 6 - Ajusta a ForCfFisfat codimp = 26674 a codigo = 260 com as alíquotas padrões definidas para o EMULADOR
**********************************************************************************************************************/

-- Cadastra o modelo do ECF
-----------------------------------------------------------------------------
PRINT 'Cadastra o modelo do ECF'
if not exists (select 1 from TABELACNIECF where CNIECF = 032203)
insert into TABELACNIECF values ('BEMATECH','MP-4200 TH FI II','ECF-IF-MFB','01.00.02',032303)
GO

-- Cadastra as impressoras
-----------------------------------------------------------------------------
PRINT 'Cadastra as impressoras'
if exists (select 1 from SERIALECF where serialimpressora = '001/BE10EMULADOR00000000')
	Delete from SERIALECF where SERIALIMPRESSORA like '%BE10EMULADOR00000000%'
GO
if not exists (select * from SERIALECF where serialimpressora = '001/BE10EMULADOR00000000')
	INSERT INTO [serialecf] (OIDIMPRESSORA,SERIALIMPRESSORA,CODIMP,MODELO,MARCA,VERSAODLL,TIPO,CNIECF,MFADICIONAL,DATAGRAVASB,VERSAOSB,MaxCol)
	VALUES(26674,'001/BE10EMULADOR00000000',26674,'MP-4200 TH FI II','BEMATECH','7.0.3.8','ECF-IF','032303',NULL,'20110101 12:00:00:000','01.01.02',NULL)
GO
if exists (select 1 from SERIALECF where serialimpressora = '001/BE11EMULADOR00000000')
	Delete from SERIALECF where SERIALIMPRESSORA like '%BE11EMULADOR00000000%'
GO
if not exists (select 1 from SERIALECF where serialimpressora = '001/BE11EMULADOR00000000')
	INSERT INTO [serialecf] (OIDIMPRESSORA,SERIALIMPRESSORA,CODIMP,MODELO,MARCA,VERSAODLL,TIPO,CNIECF,MFADICIONAL,DATAGRAVASB,VERSAOSB,MaxCol)
	VALUES(26674,'001/BE11EMULADOR00000000',26674,'MP-4200 TH FI II','BEMATECH','7.0.3.8','ECF-IF','032303',NULL,'20110101 12:00:00:000','01.01.02',NULL)
GO

-- Altera a data de vidência da tabela IBPT
-----------------------------------------------------------------------------
PRINT  'Altera a data de vidência da tabela IBPT'
Update TABELAIBPT set VIGENCIAFIM = '21001231'
GO

-- Ajusta o código do RECEBIMENTO
-----------------------------------------------------------------------------
PRINT 'Ajusta o código do RECEBIMENTO'
update forcffisfat 
	set  string =	REPLACE (STRING ,	--onde vai ser feito a troca
	SUBSTRING(string,8,2) ,	--em que ponto vai ser feito a troca
	'03' )	-- o valor que que eu quero informar 
where codimp = 26674 
	and codigo = '095' 
	and ordem = 1
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
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 6, '05.14 - {05}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 7, '05.60 - {06}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 8, '07.00 - {07}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 9, '08.80 - {08}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 6, '10.50 - {09}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 7, '12.00 - {10}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 8, '13.20 - {11}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 9, '14.40 - {12}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 6, '17.00 - {13}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 7, '18.00 - {14}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 7, '19.00 - {15}', 0)
INSERT INTO FORCFFISFAT (Codimp, Codigo, Ordem, String, Somar) VALUES (26674, '260', 8, '25.00 - {16}', 0)
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
SELECT * from numerador where rcategoria = 26674
