
-- 9 - Despesas Administrativas
--------------------------------------------------------------------------------
if object_id('tempdb..#tmp_dre_constrular') is not null drop table #tmp_DRE_Constrular

SELECT 
	'1' AS ORIGEM,
	FATOFINANCEIRO_R.OID as [Codigo],
	FATOFINANCEIRO_R.DATA as [Data],
	'-' as [Sinal],
	'09 - Despesas Administrativas' as [Tipo], 
	'Despesas Administrativas' as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 4360902 THEN '09.03 - ' + T.NOME --9.14
		WHEN FATOFINANCEIRO_R.RTPO = 2683982 THEN '09.04 - ' + T.NOME --9.07
		WHEN FATOFINANCEIRO_R.RTPO = 9093199 THEN '12.04 - ' + T.NOME --12.4
		WHEN FATOFINANCEIRO_R.RTPO = 2300486 THEN '09.06 - ' + T.NOME --9.20
		WHEN FATOFINANCEIRO_R.RTPO = 2714271 THEN '09.06 - ' + T.NOME --9.20
		WHEN FATOFINANCEIRO_R.RTPO = 2300498 THEN '07.08 - ' + T.NOME --7.1
		WHEN FATOFINANCEIRO_R.RTPO = 2709379 THEN '07.08 - ' + T.NOME --7.1
		WHEN FATOFINANCEIRO_R.RTPO = 2714265 THEN '07.06 - ' + T.NOME --7.6
		WHEN FATOFINANCEIRO_R.RTPO = 2300495 THEN '09.08 - ' + T.NOME	--09.1
		WHEN FATOFINANCEIRO_R.RTPO = 2714240 THEN '09.11 - ' + T.NOME	--09.20
		WHEN FATOFINANCEIRO_R.RTPO = 2673406 THEN '09.11 - ' + T.NOME	--09.20
		WHEN FATOFINANCEIRO_R.RTPO = 2670454 THEN '07.09 - ' + T.NOME	--07.09
		WHEN FATOFINANCEIRO_R.RTPO = 2714246 THEN '07.10 - ' + T.NOME	--09.20
		WHEN FATOFINANCEIRO_R.RTPO = 2673408 THEN '07.10 - ' + T.NOME	--07.10
		WHEN FATOFINANCEIRO_R.RTPO = 2357841 THEN '09.12 - ' + T.NOME	--09.22
		WHEN FATOFINANCEIRO_R.RTPO = 2670451 THEN '11.07 - ' + T.NOME	--11.01
		WHEN FATOFINANCEIRO_R.RTPO = 2300489 THEN '09.19 - ' + T.NOME	--09.8
		WHEN FATOFINANCEIRO_R.RTPO = 2683987 THEN '09.19 - ' + T.NOME	--09.8
		WHEN FATOFINANCEIRO_R.RTPO = 324856885 THEN '09.20 - ' + T.NOME	--09.11
		WHEN FATOFINANCEIRO_R.RTPO = 2672734 THEN '09.20 - ' + T.NOME	--09.11
		WHEN FATOFINANCEIRO_R.RTPO = 29844075 THEN '13.03 - ' + T.NOME	--13.01
		WHEN FATOFINANCEIRO_R.RTPO = 2670460 THEN '09.22 - ' + T.NOME	--13.01
		WHEN FATOFINANCEIRO_R.RTPO = 2713130 THEN '09.23 - ' + T.NOME	--09.18
		WHEN FATOFINANCEIRO_R.RTPO = 2673443 THEN '05.09.03 - ' + T.NOME	--05.9.3
	
	
		----SEM CONTA ESPEC�FICA ------------------------------------
		WHEN FATOFINANCEIRO_R.RTPO = 2300507 THEN '99.02 - Conta indefinida! - ' + T.NOME --9.07
	ELSE 'Nivel 9 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	FATOFINANCEIRO_R.VALOR/**FATOFINANCEIRO_R.SINAL*/ AS VALOR
	into #tmp_DRE_Constrular
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
		4360902,				-- 09.03 - Alex
		2683982,				-- 09.04 - Aluguel Projetado
		9093199,				-- 12.04 - Aplica��es Financeiras
		2300486, 2714271,		-- 09.06 - Cart�rio
		2300498,				-- 07.08 - Comiss�es
		2709379,				-- 07.08 - Comiss�es
		2714265,				-- 07.06 - Comiss�es de Indicadores
		2300495,				-- 09.08 - Sal�rios
		2714240, 2673406,		-- 09.11 - Correios e SEDEX
		2670454,				-- 07.09 - DESPESA COM BOLETO
		2714246, 2673408,		-- 07.09 - Despesas c/ Refeicoes
		2357841,				-- 09.12 - Despesas de Viagem/Servi�o
		2670451,				-- 11.07 - MANUTEN��O CONTA
		2672786,				-- 16.01 - Manutencao Patrimonial
		2300489,2683987,		-- 09.19 - Materiais de Cozinha e Limpeza
		324856885,2672734,		-- 09.20 - Material de Escritorio
		29844075,				-- 13.03 - Outras Receitas n�o Operacionais
		2670460,				-- 09.22 - Patroc�nio
		2713130,				-- 09.23 - Pe�as
		2673443,				-- 05.09.03 - Recis�o e Indenizacao Trabalhista

		----SEM CONTA ESPEC�FICA ------------------------------------
		2300507 --Adiantamentos Colaboradores
	)

UNION ALL SELECT 
	'2' AS ORIGEM,
	PG.OID as [Codigo],
	AT.DATA as [Data],
	'-' as [Sinal],
	'09 - Despesas Administrativas' as [Tipo], 
	'Despesas Administrativas' as [Operacao],
	CASE 
		WHEN CONTA.RTPO = 2300474 THEN '09.01 - ' + T.NOME --9.10
		WHEN CONTA.RTPO = 2727274 THEN '09.02 - ' + T.NOME --9.07
		WHEN CONTA.RTPO = 4360902 THEN '09.03 - ' + T.NOME --9.14
		WHEN CONTA.RTPO = 2679697 THEN '12.03 - ' + T.NOME --12.3
		WHEN CONTA.RTPO = 6021891 THEN '02.03 - ' + T.NOME --2.3
		WHEN CONTA.RTPO = 25384195 THEN '02.03 - ' + T.NOME --2.3
		WHEN CONTA.RTPO = 4427400 THEN '16.01 - ' + T.NOME --16.1
		WHEN CONTA.RTPO = 2673414 THEN '09.05 - ' + T.NOME --9.16
		WHEN CONTA.RTPO = 2300498 THEN '07.08 - ' + T.NOME --7.1
		WHEN CONTA.RTPO = 2356541 THEN '05.02.02 - ' + T.NOME --5.2.2
		WHEN CONTA.RTPO = 5289599 THEN '09.07 - ' + T.NOME -- 9.18
		WHEN CONTA.RTPO = 2676721 THEN '09.09 - ' + T.NOME -- 9.11
		WHEN CONTA.RTPO = 2672745 THEN '09.10 - ' + T.NOME -- 9.18
		WHEN CONTA.RTPO = 2670454 THEN '07.09 - ' + T.NOME	--07.09
		WHEN CONTA.RTPO = 2673408 THEN '07.10 - ' + T.NOME	--07.10
		WHEN CONTA.RTPO = 5403690 THEN '09.13 - ' + T.NOME	--09.24
		WHEN CONTA.RTPO = 2300477 THEN '09.14 - ' + T.NOME	--09.10
		WHEN CONTA.RTPO = 2300501 THEN '09.15 - ' + T.NOME	--09.10
		WHEN CONTA.RTPO = 2672782 THEN '09.16 - ' + T.NOME	--09.10
		WHEN CONTA.RTPO = 2300459 THEN '09.17 - (Retiradas Alex) ' + T.NOME	--09.14
		WHEN CONTA.RTPO = 49530894 THEN '09.18 - ' + T.NOME	--09.12
		WHEN CONTA.RTPO = 4390595 THEN '09.18 - ' + T.NOME	--09.12
		WHEN CONTA.RTPO = 2694938 THEN '05.09.01 - ' + T.NOME	--05.9.1
		WHEN CONTA.RTPO = 2300489 THEN '09.19 - ' + T.NOME	--09.8
		WHEN CONTA.RTPO = 148309741 THEN '09.20 - ' + T.NOME	--09.11
		WHEN CONTA.RTPO = 2673449 THEN '05.09.03 - ' + T.NOME	--05.9.3
		WHEN CONTA.RTPO = 2672762 THEN '09.21 - ' + T.NOME	--09.18
		WHEN CONTA.RTPO = 2670460 THEN '09.22 - ' + T.NOME	--13.01
		WHEN CONTA.RTPO = 2673443 THEN '05.09.03 - ' + T.NOME	--05.9.3
		WHEN CONTA.RTPO = 2672764 THEN '09.10 - ' + T.NOME	--09.18
		WHEN CONTA.RTPO = 2300483 THEN '09.24 - ' + T.NOME	--09.13
		WHEN CONTA.RTPO = 2300480 THEN '09.24 - ' + T.NOME	--09.13
		WHEN CONTA.RTPO = 2300453 THEN '09.10 - ' + T.NOME	--09.18

		

		
		--SEM CONTA ESPEC�FICA ------------------------------------
		WHEN CONTA.RTPO = 73243334 THEN '99.01 - Conta indefinida! - ' + T.NOME --99.99
		WHEN CONTA.RTPO = 2300507  THEN '99.02 - Conta indefinida! - ' + T.NOME --99.99

	ELSE 'Nivel 9 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END as [Valor]
	

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
	AND CONTA.RTPO in (
		2300474, -- 09.01 - �gua / Esgoto
		2727274, -- 09.02 - Aluguel
		4360902, -- 09.03 - Alex
		2679697, -- 12.03 - Aplica��es
		6021891, -- 02.03 - Aquisi��o de Servi�o Tributado ISSQN
		25384195, -- 02.03 - Aquisi��o de Servi�o Tributado ISSQN (Aproveita Cr�dito Pis e Cofins)
		4427400, -- 16.01 - Armaz�m Centro Manhumirim
		2673414, -- 09.05 - Associacoes Diversas
		2300498, --	07.08 - Comiss�es
		2356541, -- 05.02.02 - Complemento de Nota Fiscal
		5289599, -- 09.07 - Compra de Combustive�s
		2676721, -- 09.09 - COMPRA DE MATERIAL P/ USO CONSUMO
		2672745, -- 09.10 - Compra de Pe�as p/ Veiculos
		2670454, -- 07.09 - DESPESA COM BOLETO
		2673408, -- 07.10 - Despesas c/ Refeicoes
		5403690, --	09.13 - Despesas Diversos e Atestados M�dicos
		2300477, -- 09.14 - Energia El�trica
		2300501, -- 09.15 - F�rias
		2672782, -- 09.16 - Honorarios Contabeis
		2300459, -- 09.17 - Im�veis (Retiradas
		49530894, 4390595, -- 09.18 - Manuten��o de Inform�tica (Hardware)
		2694938, --05.09.01 - M�o de Obra
		2300489, -- 09.19 - Materiais de Cozinha e Limpeza
		148309741, -- 09.20 - Material de Escritorio
		2673449, -- 05.09.03 - Multas Recisorias
		2672762, -- 09.21 - Multas de Transito
		2670460, -- 09.22 - Patroc�nio
		2673443, -- 05.09.03 - Recis�o e Indenizacao Trabalhista.
		2672764, -- 09.10 - Seguro de Veiculos
		2300483, 2300480, -- 09.24 - Telefone Celular, 09.24 - Telefone Fixo
		2300453, -- 09.10 - Ve�culos
	

		--SEM CONTA ESPEC�FICA ------------------------------------
		73243334, -- Adiantamentos a Forncedores
		2300507 -- Adiantamentos Colaboradores
		)
UNION SELECT 
	'3' AS ORIGEM,
	PG.OID as [Codigo],
	AT.DATA as [Data],
	'-' as [Sinal],
	'09 - Despesas Administrativas' as [Tipo], 
	'Despesas Administrativas' as [Operacao],
	CASE 
		WHEN CONTA.RTPO = 4945191 THEN '12.03 - ' + T.NOME --12.03
		WHEN CONTA.RTPO = 142402891 THEN '13.01 - ' + T.NOME --13.01
		WHEN CONTA.RTPO = 2356845 THEN '13.02 - ' + T.NOME --13.02
		WHEN CONTA.RTPO = 9397590 THEN '07.07 - ' + T.NOME --7.7
		WHEN CONTA.RTPO = 29846882 THEN '02.01 - ' + T.NOME --7.7
		WHEN CONTA.RTPO = 5403690 THEN '09.13 - ' + T.NOME	--09.24
		WHEN CONTA.RTPO = 29844075 THEN '13.03 - ' + T.NOME	--13.01
		
		--SEM CONTA ESPEC�FICA ------------------------------------
	


	ELSE 'Nivel 9 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	CASE WHEN PG.VALOR < 0 THEN PG.VALOR *-1 ELSE PG.VALOR END as [Valor]
FROM  
	PAGAMENTO PG, 
	CONTAARECEBER_R CONTA, 
	ACAOFINANCEIRA AF,
	ATOFINANCEIRO AT, 
	CATEGORIA CAT,
	TPO_R T,
	PESSOA_R filial
WHERE CONTA.RSITUACAO IN ( 2346, 2347 )
	AND CONTA.RTPO = T.OID
	AND FILIAL.OID = CONTA.REMITENTE
	AND CONTA.OID = AF.RCONTA 
	AND AF.OID = PG.RACAOFINANCEIRA
	AND AF.RATOFINANCEIRO = AT.OID 
	AND AT.RTIPO IN ( 2718, 23739, 23744 )  
	AND NOT ( AT.RTIPO = 23744 AND CONTA.RTIPO = 23669 )
	AND AT.RESTORNO = 7 
	AND PG.RTIPO = CAT.OID   
	AND CONTA.RMOEDA1 = 113702 
	AND CONTA.REMITENTE IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND CONTA.RTPO in (

		142402891,	-- 13.01 - Alugu�is Recebidos
		9397590,	-- 07.07 - Brindes para Indicadores
		2356845,	-- 13.02 - Cheque Devolvido Receita
		29846882,	-- 02.01 - Desconto Concedido
		5403690,	-- 09.13 - Despesas Diversos e Atestados M�dicos
		29844075,   -- 13.03 - Outras Receitas n�o Operacionais

	----SEM CONTA ESPEC�FICA ------------------------------------
	4945191 --Adiantamentos Colaboradores
	)

UNION ALL SELECT 
	'4', 
	FATOFINANCEIRO_R.OID as [Codigo],
	FATOFINANCEIRO_R.DATA as [Data],
	'-' as [Sinal],
	'09 - Despesas Administrativas' as [Tipo], 
	'Despesas Administrativas' as [Operacao],
	CASE 
		WHEN FATOFINANCEIRO_R.RTPO = 154201517	THEN '11.01 - ' + T.NOME --11.6
		WHEN FATOFINANCEIRO_R.RTPO = 252479014	THEN '11.02 - ' + T.NOME --11.6
		WHEN FATOFINANCEIRO_R.RTPO = 154260629	THEN '11.03 - ' + T.NOME --11.6
		WHEN FATOFINANCEIRO_R.RTPO = 259379944	THEN '11.04 - ' + T.NOME --11.6
		WHEN FATOFINANCEIRO_R.RTPO = 2318047	THEN '11.05 - ' + T.NOME	--11.6
		WHEN FATOFINANCEIRO_R.RTPO = 2318050	THEN '11.06 - ' + T.NOME	--11.6
		WHEN FATOFINANCEIRO_R.RTPO = 2318536	THEN '11.07 - ' + T.NOME --11.6
		WHEN FATOFINANCEIRO_R.RTPO = 4191965	THEN '11.08 - ' + T.NOME --11.6
		WHEN FATOFINANCEIRO_R.RTPO = 154260645	THEN '11.09 - ' + T.NOME	--11.6
		WHEN FATOFINANCEIRO_R.RTPO = 164202804	THEN '11.10 - ' + T.NOME	--11.6
		WHEN FATOFINANCEIRO_R.RTPO = 2300495	THEN '09.08 - ' + T.NOME	--09.1
	ELSE 'Nivel 4 Indeterminado - ' + T.NOME
	end as [Hierarquia],
	FILIAL.CODIGO as [Filial],
	FATOFINANCEIRO_R.VALOR/**FATOFINANCEIRO_R.SINAL*/ AS VALOR
FROM 
	FATOFINANCEIRO_R, UTILIZACAO U, TPO_R T, PESSOA_R FILIAL
WHERE FATOFINANCEIRO_R.OID = U.RITEM
	AND FILIAL.OID =  U.RUTILIZADO
	AND FATOFINANCEIRO_R.RTPO = T.OID
	AND FATOFINANCEIRO_R.SITUACAO = 1
	AND FATOFINANCEIRO_R.RATOFINANCEIRO <= 7
	AND FATOFINANCEIRO_R.RTPO > 7   
	AND FATOFINANCEIRO_R.RMOEDA = 113702 
	AND U.RUTILIZADO IN ( 2302256, 2302250, 2653583, 2653570, 1224953, 2537974, 227135206 ) 
	AND FATOFINANCEIRO_R.RTPO IN (
		154201517,	-- Comiss�o Amex
		252479014,	-- Comiss�o BIGCARD
		154260629,	-- Comiss�o Cabal
		259379944,	-- COMISS�O GMINAS
		2318047,	-- Comiss�o Mastercard
		2318050,	-- Comiss�o Visa
		2318536,	-- Comiss�o CDC Banco do Brasil
		4191965,	-- Comiss�o Construcard
		154260645,	-- Comiss�o BNDS
		164202804, 	-- Comiss�o Cresol
		2300495		-- 09.08 - Sal�rios
	)

-- Listar 
------------------------------------------------------
select 
	--filial, 
	Tipo,Sinal, Hierarquia,  sum(valor) as Valor
from #tmp_DRE_Constrular
where 
	--filial = '01' and 
	data between '20180201' and '20180228 23:59:59' 
group by 	
	Tipo, Hierarquia, Sinal
	--filial
order by Hierarquia