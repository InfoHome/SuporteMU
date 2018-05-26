DROP TABLE AC_DRE_DEMONSTRATIVO
DROP TABLE AC_DRE_GRUPO
DROP TABLE AC_DRE_ITENS
DROP TABLE AC_DRE_RESULT

DROP VIEW AC_DRE_CONSTRULAR_R
GO

USE BDENTER
GO
CREATE TABLE AC_DRE_DEMONSTRATIVO (
	ID INT NOT NULL IDENTITY,
	NOME VARCHAR(MAX) NOT NULL
)
INSERT INTO AC_DRE_DEMONSTRATIVO (NOME) VALUES 	('DRE A CONSTRULAR')

CREATE TABLE AC_DRE_GRUPO (
	ID INT NOT NULL IDENTITY,
	CODIGO CHAR(2) NOT NULL,
	NOME VARCHAR(MAX) NOT NULL,
	DEMONSTRATIVO INT NOT NULL
)
GO
INSERT INTO AC_DRE_GRUPO (CODIGO,NOME,DEMONSTRATIVO) VALUES 
	('01','(=) RECEITA OPERACIONAL BRUTA',1),
	('02','(=) DEDU��ES DA RECEITA BRUTA',1),
	('03','(=) RECEITA OPERACIONAL L�QUIDA (1-2)',1),
	('04','(=) CUSTO DAS VENDAS',1),
	('05','(=) RESULTADO OPERACIONAL BRUTO ( LUCRO BRUTO (3-(4-5)))',1),
	('06','(=) DESPESAS OPERACIONAIS',1),
	('07','(=) RESULTADO OPERACIONAL (6-(7+8+9))',1),
	('08','(=) DESPESAS FINANCEIRAS L�QUIDAS',1),
	('09','(=) OUTRAS RECEITAS E DESPESAS',1),
	('10','(=) RESULTADO ANTES DO IRPJ',1),
	('11','(=) RESULTADO L�QUIDO',1),
	('12','(=) ATIVIDADES DE INVESTIMENTO',1),
	('13','(=) ATIVIDADES DE FINANCIAMENTO',1),
	('14','(=) MOVIMENTA��O DOS S�CIOS',1),
	('15','(=) RESULTADO FINAL',1)

GO
CREATE TABLE AC_DRE_ITENS (
	ID INT NOT NULL IDENTITY,
	SINAL INT NOT NULL,
	HIERARQUIA VARCHAR(MAX) NOT NULL,
	VARIACAO VARCHAR(MAX) NULL,
	DESCRICAO VARCHAR(MAX) NOT NULL,
	DEMONSTRATIVO INT NOT NULL
)
GO
INSERT INTO AC_DRE_ITENS (SINAL,HIERARQUIA,VARIACAO,DESCRICAO,DEMONSTRATIVO) VALUES
( 1,'01.001'	,'01.001'		,'VENDAS � VISTA',1),
( 1,'01.002'	,'01.002'		,'VENDAS � PRAZO',1),
( 1,'01.003'	,'01.003'		,'VENDAS C/ CART�O',1),
( 1,'01.004'	,'01.004'		,'PRESTA��O DE SERVI�OS',1),
(-1,'02.001'	,'02.001'		,'ABATIMENTOS/DESCONTOS CONCEDIDOS',1),
(-1,'02.002'	,'02.002'		,'DEVOLU��ES DE VENDAS',1),
( 1,'04.001'	,'04.001'		,'CUSTO DOS PRODUTOS VENDIDOS (CMV)',1),
( 1,'04.002'	,'04.002'		,'CUSTOS VARI�VEIS',1),
( 0,'04.003'	,'04.003'		,'CUSTOS FIXOS',1),
( 1,'04.003.001','04.003.001'	,'M�O DE OBRA PR�PRIA',1),
( 1,'04.003.002','04.003.002'	,'PROVIS�O P/F�RIAS E 13o. SAL�RIO',1),
( 1,'04.003.003','04.003.003'	,'FGTS E MULTA RESCIS�RIA',1),
( 1,'04.003.004','04.003.004'	,'OUTROS GASTOS DE PRODU��O',1),
( 1,'04.004'	,'04.004'		,'ESTOQUE FINAL',1),
( 1,'04.005'	,'04.005'		,'CUSTO DAS DEVOLU��ES DE VENDAS (CMV)',1),
( 0,'04.006'	,'04.006'		,'IMPOSTOS E CONTRIBUI��ES INCIDENTES SOBRE VENDAS',1),
(-1,'04.006.001','04.006.001'	,'SIMPLES NACIONAL',1),
(-1,'04.006.002','04.006.002'	,'ICMS',1),
(-1,'04.006.003','04.006.003'	,'IRPJ',1),
(-1,'04.006.004','04.006.004'	,'CSLL',1),
(-1,'04.006.005','04.006.005'	,'PIS',1),
(-1,'04.006.006','04.006.006'	,'COFINS',1),
(-1,'04.006.007','04.006.007'	,'ISS',1),
( 0,'06.001'	,'06.001'		,'DESPESAS VARI�VEIS C/ VENDAS',1),
(-1,'06.001.001','06.001.001'	,'COMISS�ES SOBRE VENDAS',1),
(-1,'06.001.002','06.001.002'	,'PROVIS�O P/F�RIAS E 13o. SAL�RIO',1),
(-1,'06.001.003','06.001.003'	,'FGTS',1),
(-1,'06.001.004','06.001.004'	,'INSS',1),
(-1,'06.001.005','06.001.005'	,'MATERIAL DE EMBALAGEM',1),
(-1,'06.001.006','06.001.006'	,'DESPESAS COM ENTREGAS/VENDAS',1),
(-1,'06.001.007','06.001.007'	,'DESPESAS COM EVENTOS',1),
(-1,'06.001.008','06.001.008'	,'COMISS�O DE INDICADORES/MESTAS',1),
(-1,'06.001.009','06.001.009'	,'DESPESA COM BRINDES',1),
(-1,'06.001.010','06.001.010'	,'SAL�RIOS DE VENDAS',1),
(-1,'06.001.011','06.001.011'	,'MULTAS RECISS�RIAS',1),
(-1,'06.002.001','06.002.001'	,'SAL�RIOS DE VENDAS',1),
(-1,'06.002.002','06.002.002'	,'PROVIS�O P/F�RIAS E 13o. SAL�RIO',1),
(-1,'06.002.003','06.002.003'	,'FGTS',1),
(-1,'06.002.004','06.002.004'	,'INSS',1),
(-1,'06.002.005','06.002.005'	,'VALE TRANSPORTE',1),
(-1,'06.002.006','06.002.006'	,'OUTROS GASTOS COM PESSOAL',1),
(-1,'06.002.007','06.002.007'	,'PROPAGANDA',1),
(-1,'06.002.008','06.002.008'	,'DESPESAS COM TREINAMENTOS',1),
(-1,'06.003.001','06.001.010'	,'SAL�RIOS',1),
(-1,'06.003.002','06.001.002'	,'PROVIS�O P/F�RIAS E 13o. SAL�RIO',1),
(-1,'06.003.003','06.001.003'	,'FGTS',1),
(-1,'06.003.004','06.001.004'	,'INSS',1),
(-1,'06.003.005','06.003.005'	,'VALE TRANSPORTE',1),
(-1,'06.003.006','06.002.006'	,'OUTROS GASTOS COM PESSOAL',1),
(-1,'06.003.007','06.003.007'	,'LANCHES/REFEI��ES',1),
(-1,'06.003.008','06.003.008'	,'ALUGUEIS/IPTU/CONDOM�NIOS/ALVAR�/SUGURO PATRIMONIAL',1),
(-1,'06.003.009','06.003.009'	,'MATERIAL DE LIMPESA/COZINHA/HIGIENE',1),
(-1,'06.003.010','06.003.010'	,'CONSERVA��O DE BENS INSTALA��ES',1),
(-1,'06.003.011','06.003.011'	,'AGUA/LUZ',1),
(-1,'06.003.012','06.003.012'	,'MATERIAL DE ESCRITORIO/INFORMATICA',1),
(-1,'06.003.013','06.003.013'	,'MANUTEN��O DE SISTEMAS',1),
(-1,'06.003.014','06.003.014'	,'TELEFONE/INTERNET',1),
(-1,'06.003.015','06.003.015'	,'RETIRADAS ALEX',1),
(-1,'06.003.016','06.003.016'	,'HONOR�RIOS CONT�BEIS',1),
(-1,'06.003.017','06.003.017'	,'CONTRIBUI��O ASSOCIA��O CLASSE',1),
(-1,'06.003.018','06.003.018'	,'DESPESAS COM COBRAN�AS/BOLETO',1),
(-1,'06.003.019','06.003.019'	,'DESPESAS COM VE�CULOS',1),
(-1,'06.003.020','06.003.020'	,'IMPOSTOS E TAXAS',1),
(-1,'06.003.021','06.003.021'	,'CARTORIO/CORREIOS',1),
(-1,'06.003.022','06.003.022'	,'DESPESAS COM SEGURAN�A',1),
(-1,'06.003.023','06.003.023'	,'DESPESAS COM VIAGENS/FEIRAS',1),
(-1,'06.003.024','06.003.024'	,'DESPESAS RATEADAS CONTORNO',1),
(-1,'06.003.025','06.003.025'	,'DESPESAS COM PERDAS DE PRODUTOS',1),
(-1,'06.003.026','06.003.026'	,'OUTRAS DESPESAS',1),
(-1,'06.003.027','06.003.027'	,'DEPRECIA��ES/AMORTIZA��ES',1),
(-1,'06.003.028','06.003.028'	,'DESPESAS COM MARKETING',1),
(-1,'06.003.029','06.003.029'	,'DESPESAS COM CONSULTORIAS',1),
(-1,'06.003.030','06.003.030'	,'DESPESAS COM PRESTA��O DE SERVI�OS',1),
(-1,'06.003.031','06.001.011'	,'MULTAS RECISS�RIAS',1),
(-1,'06.003.032','06.003.032'	,'AQUISI��O DE SERVI�O ISSQN',1),
( 0,'08.001'    ,'08.001'		,'DESPESAS FINANCEIRAS',1),
(-1,'08.001.001','08.001.001'	,'TARIFAS/JUROS BANC�RIAS/ALUGUEL M�QUINAS DE CART�O',1),
(-1,'08.001.002','08.001.002'	,'DESPESAS DE FINANCIAMENTOS',1),
(-1,'08.001.003','08.001.003'	,'JUROS E DESCONTOS',1),
(-1,'08.001.004','08.001.004'	,'TAXA ADMINISTRATIVA/JUROS ANTECIPA��O DE CART�O/CHEQUES ',1),
(-1,'08.001.005','08.001.005'	,'IOF',1),
( 0,'08.002'    ,'08.002'		,'RECEITAS FINANCEIRAS',1),
( 1,'08.002.001','08.002.001'	,'JUROS RECEBIDOS ',1),
( 1,'08.002.002','08.002.002'	,'DESCONTOS RECEBIDOS',1),
( 1,'09.001'	,'09.001'		,'OUTRAS RECEITAS N�O OPERACIONAIS',1),
( 1,'09.002'	,'09.002'		,'ENCARGOS RECEBIMENTO',1),
(-1,'09.003'	,'09.003'		,'INDENIZA��ES JUDICIAIS',1),
(-1,'10.001'	,'10.001'		,'IMPOSTO DE RENDA',1),
(-1,'10.002'	,'10.002'		,'ADICIONAL IMPOSTO DE RENDA',1),
(-1,'10.003'	,'10.003'		,'CONTRIBUI��O SOCIAL',1),
(-1,'11.999'	,'11.999'		,'RESULTADO LIQUIDO',1),
(-1,'12.001'	,'12.001'		,'OBRAS E REFORMAS',1),
(-1,'12.002'	,'12.002'		,'M�QUINAS E EQUIPAMENTOS',1),
(-1,'12.003'	,'12.003'		,'VE�CULOS',1),
(-1,'12.004'	,'12.004'		,'ARMAZEM CENTRO MANHUMIRIM',1),
(-1,'12.005'	,'12.005'		,'OUTROS',1),
( 1,'13.001'	,'13.001'		,'CAPTA��O DE EMPRESTIMOS E FINANCIAMENTOS',1),
(-1,'13.002'	,'13.002'		,'AMORTIZA��O DE EMPRESTIMOS E FINANCIAMENTOS',1),
(-1,'13.003'	,'13.003'		,'AMORTIZA��O DE PASSIVOS DIVERSOS',1),
( 1,'14.001'	,'14.001'		,'APORTE DE CAPITAL',1),
(-1,'14.002'	,'14.002'		,'DISTRIBUI��O DE LUCROS',1)

GO

CREATE TABLE AC_DRE_RESULT (
	ID INT NOT NULL IDENTITY,
	FILIAL VARCHAR(MAX) NULL,
	MES VARCHAR(MAX) NOT NULL,
	ANO VARCHAR(MAX) NOT NULL,
	SINAL INT NOT NULL,
	TIPO VARCHAR(MAX) NOT NULL,
	HIERARQUIA VARCHAR(MAX) NOT NULL,
	VALOR DECIMAL(15,2) NOT NULL
)
GO

CREATE VIEW AC_DRE_CONSTRULAR_R(
	DEMONSTRATIVO,
	CODIGO,
	GRUPO,
	SINAL,
	HIERARQUIA,
	VARIACAO,
	DESCRICAO)
AS select 
	DEMONSTRATIVO.NOME,
	GRUPO.CODIGO,
	GRUPO.NOME,
	ITENS.SINAL,
	ITENS.HIERARQUIA,
	ITENS.VARIACAO,
	ITENS.DESCRICAO 
from AC_DRE_DEMONSTRATIVO DEMONSTRATIVO 
	JOIN AC_DRE_GRUPO GRUPO ON DEMONSTRATIVO.ID = GRUPO.DEMONSTRATIVO
	join AC_DRE_ITENS ITENS ON GRUPO.CODIGO = LEFT(ITENS.HIERARQUIA,2)
		AND DEMONSTRATIVO.ID = ITENS.DEMONSTRATIVO
GO


--SELECT * FROM AC_DRE_DEMONSTRATIVO
--SELECT * FROM AC_DRE_GRUPO
--SELECT * FROM AC_DRE_ITENS
--SELECT * FROM AC_DRE_CONSTRULAR_R WHERE CODIGO = '06'


---- EXIBI��O DO DRE CADASTRADOR
----------------------------------------------------------------
--SELECT 
--	--DRE.DEMONSTRATIVO, 
--	DRE.CODIGO + ' '+DRE.GRUPO AS GRUPO,
--	DRE.HIERARQUIA + ' - '+	DRE.DESCRICAO AS HIERARQUIA,
--	TPO.CODIGO +' - ' + TPO.NOME AS TPO
--FROM AC_DRE_CONSTRULAR_R DRE 
--	JOIN TPO_R TPO ON DRE.HIERARQUIA = TPO.OBSERVACAO
--ORDER BY GRUPO, HIERARQUIA



