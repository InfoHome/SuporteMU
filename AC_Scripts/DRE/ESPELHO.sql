-------------------------------------------
-- DRE A Constrular
--------------------------------------------------------------------------
-- 01 (=) RECEITA OPERACIONAL BRUTA
--------------------------------------------------------------------------
	01.001 (+) VENDAS � VISTA
	01.002 (+) VENDAS � PRAZO
	01.003 (+) VENDAS C/ CART�O
	01.003 (+) PRESTA��O DE SERVI�OS
--------------------------------------------------------------------------
-- 02 (=) DEDU��ES DA RECEITA BRUTA
--------------------------------------------------------------------------
	02.001 (-) ABATIMENTOS/DESCONTOS CONCEDIDOS
	02.002 (-) DEVOLU��ES DE VENDAS
	02.003 (-) IMPOSTOS E CONTRIBUI��ES INCIDENTES SOBRE VENDAS
		02.003.001 (-) SIMPLES NACIONAL
		02.003.002 (-) ICMS
		02.003.003 (-) IRPJ
		02.003.004 (-) CSLL
		02.003.005 (-) PIS
		02.003.006 (-) COFINS
		02.003.007 (-) ISS
--------------------------------------------------------------------------
-- 03 (=) RECEITA OPERACIONAL L�QUIDA
--------------------------------------------------------------------------


--------------------------------------------------------------------------
-- 04 (=) CUSTO DAS VENDAS
--------------------------------------------------------------------------
	04.001 (+) CUSTO DOS PRODUTOS VENDIDOS (CMV)
	04.002 (+) CUSTOS VARI�VEIS
	04.003 (+) CUSTOS FIXOS
		04.003.001 (+) M�O DE OBRA PR�PRIA
		04.003.002 (+) PROVIS�O P/F�RIAS E 13o. SAL�RIO
		04.003.003 (+) FGTS E MULTA RESCIS�RIA
		04.003.004 (+) OUTROS GASTOS DE PRODU��O
	04.004 (+) ESTOQUE FINAL

--------------------------------------------------------------------------
-- 05 (=) RESULTADO OPERACIONAL BRUTO ( LUCRO BRUTO (3-(4-5)))
--------------------------------------------------------------------------	


--------------------------------------------------------------------------
-- 06 (=) DESPESAS OPERACIONAIS
--------------------------------------------------------------------------
06.001 (=) DESPESAS VARI�VEIS C/ VENDAS
--------------------------------------------
	06.001.001 (-) COMISS�ES SOBRE VENDAS
	06.001.002 (-) PROVIS�O P/F�RIAS E 13o. SAL�RIO
	06.001.003 (-) FGTS
	06.001.004 (-) INSS
	06.001.005 (-) MATERIAL DE EMBALAGEM
	06.001.006 (-) DESPESAS COM ENTREGAS/VENDAS
	06.001.007 (-) DESPESAS COM EVENTOS
	06.001.008 (-) COMISS�O DE INDICADORES/MESTAS
	06.001.009 (-) DESPESA COM BRINDES

06.0002 (=) DESPESAS FIXAS C/ VENDAS
--------------------------------------------
	06.002.001 (-) SAL�RIOS DE VENDAS
	06.002.002 (-) PROVIS�O P/F�RIAS E 13o. SAL�RIO
	06.002.003 (-) FGTS/INSS
	06.002.004 (-) VALE TRANSPORTE
	06.002.005 (-) OUTROS GASTOS COM PESSOAL
	06.002.006 (-) PROPAGANDA
	06.002.007 (-) DESPESAS COM TREINAMENTOS

06.0003 (=) DESPESAS ADMINISTRATIVAS
--------------------------------------------
	06.003.001 (-) SAL�RIOS
	06.003.002 (-) PROVIS�O P/F�RIAS E 13o. SAL�RIO
	06.003.003 (-) FGTS
	06.003.004 (-) INSS
	06.003.005 (-) VALE TRANSPORTE
	06.003.006 (-) OUTROS GASTOS COM PESSOAL
	06.003.007 (-) LANCHES/REFEI��ES
	06.003.008 (-) ALUGUEIS/IPTU/CONDOM�NIOS/ALVAR�
	06.003.009 (-) MATERIAL DE LIMPESA/COZINHA
	06.003.010 (-) CONSERVA��O DE BENS INSTALA��ES
	06.003.011 (-) AGUA/LUZ
	06.003.012 (-) MATERIAL DE ESCRITORIO/INFORMATICA
	06.003.013 (-) MANUTEN��O DE SISTEMAS
	06.003.014 (-) TELEFONE/INTERNET
	06.003.015 (-) RETIRADAS ALEX
	06.003.016 (-) HONOR�RIOS CONT�BEIS
	06.003.017 (-) CONTRIBUI��O ASSOCIA��O CLASSE
	06.003.018 (-) DESPESAS COM COBRAN�AS
	06.003.019 (-) DESPESAS COM VE�CULOS
	06.003.020 (-) IMPOSTOS E TAXAS
	06.003.021 (-) CARTORIO/CORREIOS
	06.003.022 (-) DESPESAS COM SEGURAN�A
	06.003.023 (-) DESPESAS COM VIAGENS/FEIRAS
	06.003.024 (-) DESPESAS RATEADAS CONTORNO
	06.003.025 (-) DESPESAS COM PERCAS DE PRODUTOS
	06.003.026 (-) OUTRAS DESPESAS
	06.003.027 (-) DEPRECIA��ES/AMORTIZA��ES

--------------------------------------------------------------------------
-- 07 (=) DESPESAS FINANCEIRAS
--------------------------------------------------------------------------
07 (=) DESPESAS FINANCEIRAS
	07.001 (-) TARIFAS BANC�RIAS/ALUGUEL M�QUINAS DE CART�O
	07.002 (-) DESPESAS DE FINANCIAMENTOS
	07.003 (-) JUROS E DESCONTOS
	07.004 (-) TAXA ADMINISTRATIVA/JUROS ANTECIPA��O DE CART�O 
	07.005 (-) IOF

--------------------------------------------------------------------------
-- 08 (=) RECEITAS FINANCEIRAS
--------------------------------------------------------------------------	
08 (=) RECEITAS FINANCEIRAS
	08.001 (+) JUROS RECEBIDOS 
	08.002 (+)  DESCONTOS RECEBIDOS

--------------------------------------------------------------------------
-- 08 (=) OUTRAS RECEITAS E DESPESAS
--------------------------------------------------------------------------	


--------------------------------------------------------------------------
-- 09 (=) RESULTADO OPERACIONAL ANTES DO IRPJ E CSLL
--------------------------------------------------------------------------	
	09.001 (-) IMPOSTO DE RENDA
	09.002 (-) ADICIONAL IMPOSTO DE RENDA
	09.003 (-) COPNTRIBUI��O SOCIAL


--------------------------------------------------------------------------
-- 10 (=) PROVIS�O PARA IRPJ E CSLL
--------------------------------------------------------------------------	


--------------------------------------------------------------------------
-- 11 (=) LUCRO L�QUIDO ANTES DAS PARTICIPA��ES
--------------------------------------------------------------------------	
	11.001 (-) PR�-LABORE

--------------------------------------------------------------------------
-- 12 (=) ATIVIDADES DE INVESTIMENTO
--------------------------------------------------------------------------	
	12.001 () OBRAS E REFORMAS
	12.002 () M�QUINAS E EQUIPAMENTOS
	12.003 () VE�CULOS
	12.004 () ARMAZEM CENTRO MANHUMIRIM
	12.005 () OUTROS

--------------------------------------------------------------------------
-- 13 (=) ATIVIDADES DE FINANCIAMENTO
--------------------------------------------------------------------------	
	13.0001 (+) CAPTA��O DE EMPRESTIMOS E FINANCIAMENTOS
	13.0002 (-) AMORTIZA��O DE EMPRESTIMOS E FINANCIAMENTOS
	13.0003 (-) AMORTIZA��O DE PASSIVOS DIVERSOS

--------------------------------------------------------------------------
-- 14 (=) MOVIMENTA��O DOS S�CIOS
--------------------------------------------------------------------------	
	14.0001 (+) APORTE DE CAPITAL
	14.0002 (-) DISTRIBUI��O DE LUCROS

--------------------------------------------------------------------------
-- 15 (=) RESULTADO FINAL
--------------------------------------------------------------------------	




