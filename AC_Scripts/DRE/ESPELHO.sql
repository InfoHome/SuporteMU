-------------------------------------------
-- DRE A Constrular
--------------------------------------------------------------------------
-- 01 (=) RECEITA OPERACIONAL BRUTA
--------------------------------------------------------------------------
	01.001 (+) VENDAS À VISTA
	01.002 (+) VENDAS À PRAZO
	01.003 (+) VENDAS C/ CARTÃO
	01.003 (+) PRESTAÇÃO DE SERVIÇOS
--------------------------------------------------------------------------
-- 02 (=) DEDUÇÕES DA RECEITA BRUTA
--------------------------------------------------------------------------
	02.001 (-) ABATIMENTOS/DESCONTOS CONCEDIDOS
	02.002 (-) DEVOLUÇÕES DE VENDAS
	02.003 (-) IMPOSTOS E CONTRIBUIÇÕES INCIDENTES SOBRE VENDAS
		02.003.001 (-) SIMPLES NACIONAL
		02.003.002 (-) ICMS
		02.003.003 (-) IRPJ
		02.003.004 (-) CSLL
		02.003.005 (-) PIS
		02.003.006 (-) COFINS
		02.003.007 (-) ISS
--------------------------------------------------------------------------
-- 03 (=) RECEITA OPERACIONAL LÍQUIDA
--------------------------------------------------------------------------


--------------------------------------------------------------------------
-- 04 (=) CUSTO DAS VENDAS
--------------------------------------------------------------------------
	04.001 (+) CUSTO DOS PRODUTOS VENDIDOS (CMV)
	04.002 (+) CUSTOS VARIÁVEIS
	04.003 (+) CUSTOS FIXOS
		04.003.001 (+) MÃO DE OBRA PRÓPRIA
		04.003.002 (+) PROVISÃO P/FÉRIAS E 13o. SALÁRIO
		04.003.003 (+) FGTS E MULTA RESCISÓRIA
		04.003.004 (+) OUTROS GASTOS DE PRODUÇÃO
	04.004 (+) ESTOQUE FINAL

--------------------------------------------------------------------------
-- 05 (=) RESULTADO OPERACIONAL BRUTO ( LUCRO BRUTO (3-(4-5)))
--------------------------------------------------------------------------	


--------------------------------------------------------------------------
-- 06 (=) DESPESAS OPERACIONAIS
--------------------------------------------------------------------------
06.001 (=) DESPESAS VARIÁVEIS C/ VENDAS
--------------------------------------------
	06.001.001 (-) COMISSÕES SOBRE VENDAS
	06.001.002 (-) PROVISÃO P/FÉRIAS E 13o. SALÁRIO
	06.001.003 (-) FGTS
	06.001.004 (-) INSS
	06.001.005 (-) MATERIAL DE EMBALAGEM
	06.001.006 (-) DESPESAS COM ENTREGAS/VENDAS
	06.001.007 (-) DESPESAS COM EVENTOS
	06.001.008 (-) COMISSÃO DE INDICADORES/MESTAS
	06.001.009 (-) DESPESA COM BRINDES

06.0002 (=) DESPESAS FIXAS C/ VENDAS
--------------------------------------------
	06.002.001 (-) SALÁRIOS DE VENDAS
	06.002.002 (-) PROVISÃO P/FÉRIAS E 13o. SALÁRIO
	06.002.003 (-) FGTS/INSS
	06.002.004 (-) VALE TRANSPORTE
	06.002.005 (-) OUTROS GASTOS COM PESSOAL
	06.002.006 (-) PROPAGANDA
	06.002.007 (-) DESPESAS COM TREINAMENTOS

06.0003 (=) DESPESAS ADMINISTRATIVAS
--------------------------------------------
	06.003.001 (-) SALÁRIOS
	06.003.002 (-) PROVISÃO P/FÉRIAS E 13o. SALÁRIO
	06.003.003 (-) FGTS
	06.003.004 (-) INSS
	06.003.005 (-) VALE TRANSPORTE
	06.003.006 (-) OUTROS GASTOS COM PESSOAL
	06.003.007 (-) LANCHES/REFEIÇÕES
	06.003.008 (-) ALUGUEIS/IPTU/CONDOMÍNIOS/ALVARÁ
	06.003.009 (-) MATERIAL DE LIMPESA/COZINHA
	06.003.010 (-) CONSERVAÇÃO DE BENS INSTALAÇÕES
	06.003.011 (-) AGUA/LUZ
	06.003.012 (-) MATERIAL DE ESCRITORIO/INFORMATICA
	06.003.013 (-) MANUTENÇÃO DE SISTEMAS
	06.003.014 (-) TELEFONE/INTERNET
	06.003.015 (-) RETIRADAS ALEX
	06.003.016 (-) HONORÁRIOS CONTÁBEIS
	06.003.017 (-) CONTRIBUIÇÃO ASSOCIAÇÃO CLASSE
	06.003.018 (-) DESPESAS COM COBRANÇAS
	06.003.019 (-) DESPESAS COM VEÍCULOS
	06.003.020 (-) IMPOSTOS E TAXAS
	06.003.021 (-) CARTORIO/CORREIOS
	06.003.022 (-) DESPESAS COM SEGURANÇA
	06.003.023 (-) DESPESAS COM VIAGENS/FEIRAS
	06.003.024 (-) DESPESAS RATEADAS CONTORNO
	06.003.025 (-) DESPESAS COM PERCAS DE PRODUTOS
	06.003.026 (-) OUTRAS DESPESAS
	06.003.027 (-) DEPRECIAÇÕES/AMORTIZAÇÕES

--------------------------------------------------------------------------
-- 07 (=) DESPESAS FINANCEIRAS
--------------------------------------------------------------------------
07 (=) DESPESAS FINANCEIRAS
	07.001 (-) TARIFAS BANCÁRIAS/ALUGUEL MÁQUINAS DE CARTÃO
	07.002 (-) DESPESAS DE FINANCIAMENTOS
	07.003 (-) JUROS E DESCONTOS
	07.004 (-) TAXA ADMINISTRATIVA/JUROS ANTECIPAÇÃO DE CARTÃO 
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
	09.003 (-) COPNTRIBUIÇÃO SOCIAL


--------------------------------------------------------------------------
-- 10 (=) PROVISÃO PARA IRPJ E CSLL
--------------------------------------------------------------------------	


--------------------------------------------------------------------------
-- 11 (=) LUCRO LÍQUIDO ANTES DAS PARTICIPAÇÕES
--------------------------------------------------------------------------	
	11.001 (-) PRÓ-LABORE

--------------------------------------------------------------------------
-- 12 (=) ATIVIDADES DE INVESTIMENTO
--------------------------------------------------------------------------	
	12.001 () OBRAS E REFORMAS
	12.002 () MÁQUINAS E EQUIPAMENTOS
	12.003 () VEÍCULOS
	12.004 () ARMAZEM CENTRO MANHUMIRIM
	12.005 () OUTROS

--------------------------------------------------------------------------
-- 13 (=) ATIVIDADES DE FINANCIAMENTO
--------------------------------------------------------------------------	
	13.0001 (+) CAPTAÇÃO DE EMPRESTIMOS E FINANCIAMENTOS
	13.0002 (-) AMORTIZAÇÃO DE EMPRESTIMOS E FINANCIAMENTOS
	13.0003 (-) AMORTIZAÇÃO DE PASSIVOS DIVERSOS

--------------------------------------------------------------------------
-- 14 (=) MOVIMENTAÇÃO DOS SÓCIOS
--------------------------------------------------------------------------	
	14.0001 (+) APORTE DE CAPITAL
	14.0002 (-) DISTRIBUIÇÃO DE LUCROS

--------------------------------------------------------------------------
-- 15 (=) RESULTADO FINAL
--------------------------------------------------------------------------	




