
DROP TABLE #tmp_DRE_Contrular

SELECT 
	--'1'
	T.OID,
	FATOFINANCEIRO_R.OID as [Codigo],
	FATOFINANCEIRO_R.DATA as [Data],
	'-' as [Sinal],
	'09 - Despesas Administrativas' as [Tipo], 
	'Despesas Administrativas' as [Operacao],
	CASE 
		--WHEN CONTA.RTPO = 2300474 THEN '09.01 - ' + T.NOME --9.10
		--WHEN CONTA.RTPO = 2727274 THEN '09.02 - ' + T.NOME --9.07

		----SEM CONTA ESPECÍFICA ------------------------------------
		--WHEN CONTA.RTPO = 73243334 THEN '99.99 - Conta indefinida! - ' + T.NOME --9.07
		WHEN FATOFINANCEIRO_R.RTPO = 2300507 THEN '99.99 - Conta indefinida! - ' + T.NOME --9.07
	ELSE 'Nivel 11 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	FATOFINANCEIRO_R.VALOR/**FATOFINANCEIRO_R.SINAL*/ AS VALOR
	INTO #tmp_DRE_Contrular
------------------------------------
FROM 
	FATOFINANCEIRO_R, 
	CAIXABANCARIA,
	TPO_R T,
	PESSOA_R FILIAL
	
WHERE FATOFINANCEIRO_R.RFONTEPAGADORA = CAIXABANCARIA.OID
	AND T.OID =  FATOFINANCEIRO_R.RTPO
	AND FILIAL.OID = CAIXABANCARIA.RITEM
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND NOT EXISTS ( SELECT 1 FROM UTILIZACAO U WHERE U.RITEM = FATOFINANCEIRO_R.OID )  
	AND CAIXABANCARIA.RITEM IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND FATOFINANCEIRO_R.RTPO in (
		


		----SEM CONTA ESPECÍFICA ------------------------------------
		2300507 --Adiantamentos Colaboradores
		)

-------------------------------------------------------------------
UNION SELECT 
	--'2',
	T.OID,
	PG.OID as [Codigo],
	AT.DATA as [Data],
	'-' as [Sinal],
	'09 - Despesas Administrativas' as [Tipo], 
	'Despesas Administrativas' as [Operacao],
	CASE 
		--WHEN CONTA.RTPO = 2300474 THEN '09.01 - ' + T.NOME --9.10
		--WHEN CONTA.RTPO = 2727274 THEN '09.02 - ' + T.NOME --9.07

		----SEM CONTA ESPECÍFICA ------------------------------------
		--WHEN CONTA.RTPO = 73243334 THEN '99.99 - Conta indefinida! - ' + T.NOME --9.07
		WHEN CONTA.RTPO = 2300507 THEN '99.99 - Conta indefinida! - ' + T.NOME --9.07

	ELSE 'Nivel 11 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	PG.VALOR as [Valor]

FROM  
	PAGAMENTO PG, 
	CONTAAPAGAR_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT,
	TPO_R T,
	PESSOA_R FILIAL
WHERE 
	CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.RTPO = T.OID
	AND FILIAL.OID = CONTA.RDESTINATARIO
	AND CONTA.OID = AF.RCONTA 
	AND AF.OID = PG.RACAOFINANCEIRA
	AND AF.RATOFINANCEIRO = AT.OID 
	AND AT.RTIPO IN  ( 2372, 23709, 23724 ) 
	AND NOT ( AT.RTIPO = 23724 
	AND CONTA.RTIPO = 23669 )
	AND AT.RESTORNO = 7 

	AND PG.RTIPO = CAT.OID  
	AND CONTA.RMOEDA1 = 113702 
	AND CONTA.RDESTINATARIO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	--AND CONTA.RTPO in (
	--	--2300474, -- 09.01 - Água / Esgoto
	--	--2727274, -- 09.02 - Aluguel


	--	----SEM CONTA ESPECÍFICA ------------------------------------
	--	--73243334, -- Adiantamentos a Forncedores
		
		
	--	)

-----------------------------------------------------------------------------------------
UNION SELECT PG.*,
	--'3',
	T.OID,
	PG.OID as [Codigo],
	AT.DATA as [Data],
	'-' as [Sinal],
	'00 - Despesas Administrativas' as [Tipo], 
	'Despesas Administrativas' as [Operacao],
	CASE 
		--WHEN CONTA.RTPO = 2300474 THEN '09.01 - ' + T.NOME --9.10
		--WHEN CONTA.RTPO = 2727274 THEN '09.02 - ' + T.NOME --9.07

		----SEM CONTA ESPECÍFICA ------------------------------------
		--WHEN CONTA.RTPO = 73243334 THEN '99.99 - Conta indefinida! - ' + T.NOME --9.07
		WHEN CONTA.RTPO = 4945191 THEN '12.03 - ' + T.NOME --12.03

	ELSE 'Nivel 11 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	PG.VALOR as [Valor]
FROM  
	PAGAMENTO PG, 
	CONTAARECEBER_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT,
	TPO_R T,
	PESSOA_R FILIAL
WHERE CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.RTPO = T.OID
	AND CONTA.REMITENTE  = FILIAL.OID
	AND CONTA.OID = AF.RCONTA 
	AND AF.OID = PG.RACAOFINANCEIRA
	AND AF.RATOFINANCEIRO = AT.OID 
	AND AT.RTIPO IN ( 2718, 23739, 23744 )  
	AND NOT ( AT.RTIPO = 23744 AND CONTA.RTIPO = 23669 )
	AND AT.RESTORNO = 7 
	AND PG.RTIPO = CAT.OID  
	AND AT.DATA >= '20180201'
	AND AT.DATA <= '20180228 23:59:59' 
	AND CONTA.RMOEDA1 = 113702 
	AND CONTA.REMITENTE IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND CONTA.RTPO in (
		--2300474, -- 09.01 - Água / Esgoto
		--2727274, -- 09.02 - Aluguel
		4945191 --Adiantamento Cliente


		----SEM CONTA ESPECÍFICA ------------------------------------
		--73243334, -- Adiantamentos a Forncedores
		
		
		)
		--AND PG.VALOR >0

 ---------------------------------------------------------------------------------------------------------
 select 	--filial, 
	Tipo,Sinal, OID, Hierarquia,  	sum(valor) as Valor
 from #tmp_DRE_Contrular
where 
	--filial = '01' and 
	data between '20180201' and '20180228 23:59:59' 	
group by 	
	OID,Tipo, Hierarquia, Sinal 
	--filial
order by --filial,
	Hierarquia