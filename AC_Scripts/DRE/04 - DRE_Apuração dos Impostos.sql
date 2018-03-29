---------------------------------------------------------------------------------------------------------------------------
-- Apuração dos Impostos
-- 4 - Impostos S/ Vendas
---------------------------------------------------------------------------------------------------------------------------
SELECT 
DISTINCT
	PG.OID as [Codigo],
	AT.DATA as [Data],
	'-' as [Sinal],
	'04 - Receitas Líquida' as [Tipo], 
	'Impostos S/ Vendas' as [Operacao],
	CASE 
		WHEN CONTA.RTPO = 2663712 THEN '04.01 - Simples Nacional'
		WHEN CONTA.RTPO = 2663795 THEN '04.02 - ICMS'
		WHEN CONTA.RTPO = 2673459 THEN '04.03 - IRPJ'
		WHEN CONTA.RTPO = 2673423 THEN '04.04 - CSSL'
		WHEN CONTA.RTPO = 2300534 THEN '04.05 - PIS'
		WHEN CONTA.RTPO = 2300537 THEN '04.06 - COFINS'
		WHEN CONTA.RTPO = 6021891 THEN '04.07 - ISSQN'
	ELSE 'Imposto Nivel 4 Indeterminado' + TPO_R.NOME
	end as [Hierarquia],
	FIL.CODIGO as [Filial],
	PG.VALOR as [Valor]
FROM  
	PAGAMENTO PG, 
	CONTAAPAGAR_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT, 
	TPO_R,
	PESSOA_R FIL
WHERE 
	CONTA.RSITUACAO IN ( 2346, 2347 )
	AND FIL.OID = CONTA.RDESTINATARIO
	AND CONTA.RTPO = TPO_R.OID
	AND CONTA.OID = AF.RCONTA 
	AND AF.OID = PG.RACAOFINANCEIRA
	AND AF.RATOFINANCEIRO = AT.OID 
	AND AT.RTIPO IN  ( 2372, 23709, 23724 ) 
	AND NOT ( AT.RTIPO = 23724	AND CONTA.RTIPO = 23669 )
	AND AT.RESTORNO = 7 
	AND PG.RTIPO = CAT.OID   
	AND CONTA.RMOEDA1 = 113702 
	AND CONTA.RDESTINATARIO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND CONTA.RTPO IN (
						2663712, --Simples Nacional
						2663795, --ICMS
						2673459, --IRPJ
						2673423, --CSSL
						2300534, --PIS
						2300537, --COFINS
						85202590 --ISSQN
						)