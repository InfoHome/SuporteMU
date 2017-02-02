-----------------------------------------------------------------------------------------------------------------------------------------
-- Lista divergências quando ocorre rejeção de nota Referenciada na emissão da NFE	
-----------------------------------------------------------------------------------------------------------------------------------------
select 
	--Opção que a nota foi feita, tem que ser pelo sistema TRA (TRADEWIN)
	(select TOP 1 Sist +' - '+ OPCAO 
		from LOGOPERCAD 
		where NUMORD = REF.NUMORDNFCOMPLEMENTAR 
		ORDER BY DATA DESC) as SITEMA_OPCAO,
	-----------------------------------------------------------------------------------------------------
	-- Dados REFERENCIANFCOMPLEMENTAR
	REF.NUMORDNFCOMPLEMENTAR as REF_NUMORD_NFC,			-- Numord da nota complemetar
	CNC.CHAVEDEACESSONFE as REF_CHAVEDEACESSONFE_NFC,	-- Chave de acesso da nota complemetar
	CNC.SITUACAONFE as REF_SITUACAONFE_NFC,				-- Situanfe da nota complemetar
	/*Dados NFSAIDACAD NFCOMPLEMENTAR*/ 
		NFS.numnota as NFS_NUMNOTA_NFC, 
		NFS.Serie as NFS_SERIE_NFC, 
		NFS.dtemis as NFS_DTEMIS_NFC, 
		NFS.VALCONTAB as NFS_VALCONTAB_NFC,
	-----------------------------------------------------------------------------------------------------
	REF.NUMORDNFSAIDA AS REF_NUMORDNFSAIDA,						-- Numord da nota de SAÍDA devolvida
	CNS.CHAVEDEACESSONFE as REF_CHAVEDEACESSONFE_NUMORDNFSAIDA, -- Chave de acesso na NUMORDNFSAIDA
	CNS.SITUACAONFE as REF_SITUACAONFE_NUMORDNFSAIDA,			-- Situação de acesso na NUMORDNFSAIDA
	/*Dados NFSAIDACAD NUMORDNFSAIDA*/ 
		NFS2.numnota as NFS2_NUMNOTA_NUMORDNFSAIDA, 
		NFS2.Serie as NFS2_SERIE_NUMORDNFSAIDA, 
		NFS2.dtemis as NFS2_DTEMIS_NUMORDNFSAIDA, 
		NFS2.VALCONTAB as NFS2_VALCONTAB_NUMORDNFSAIDA,
	-----------------------------------------------------------------------------------------------------
	REF.NUMORDNFENTRA AS REF_NUMORDNFENTRA,						-- Numord da nota de ENTRADA devolvida
	CNE.CHAVEDEACESSONFE as REF_CHAVEDEACESSONFE_NUMORDNFENTRA,	-- Tem que ter CHAVEDEACESSONFE na nota de entrada NUMORDNFENTRA
	CNE.SITUACAONFE as REF_SITUACAONFE_NUMORDNFENTRA,			-- Situação de acesso na NUMORDNFENTRA
	/*Dados NFENTRACAD NUMORDNFENTRA*/ 
		NFE2.numnota as NFE2_NUMNOTA_NUMORDNFENTRA, 
		NFE2.Serie as NFE2_SERIE_NUMORDNFENTRA, 
		NFE2.dtemis as NFE2_DTEMIS_NUMORDNFENTRA, 
		NFE2.VALCONTAB as NFE2_VALCONTAB_NUMORDNFENTRA
	
from NFSAIDACAD NFS
	LEFT JOIN REFERENCIANFCOMPLEMENTAR REF ON NFS.NUMORD = REF.NUMORDNFCOMPLEMENTAR -- Quando o numord da NFCOMPLEMENTAR for SAIDA
	LEFT JOIN NFENTRACAD NFE ON NFE.NUMORD = REF.NUMORDNFCOMPLEMENTAR -- Quando o numord da NFCOMPLEMENTAR for ENTRADA
	LEFT JOIN NFENTRACAD NFE2 ON NFE2.NUMORD = REF.NUMORDNFENTRA -- Dados da nota de entrada
	LEFT JOIN NFSAIDACAD NFS2 ON NFS2.NUMORD = REF.NUMORDNFSAIDA -- Dados da nota desaída
	LEFT JOIN COMPLEMENTONFENTRA CNE ON REF.NUMORDNFENTRA = CNE.NUMORD -- COMPLEMENTONFENTRA da NUMORDNFENTRA
	LEFT JOIN COMPLEMENTONFSAIDA CNS ON REF.NUMORDNFSAIDA = CNS.NUMORD -- COMPLEMENTONFSAIDA da NUMORDNFENTRA
	LEFT JOIN COMPLEMENTONFSAIDA CNC ON CNC.NUMORD = NFS.NUMORD -- COMPLEMENTONFSAIDA da NFCOMPLEMENTAR
	
WHERE 
	NFS.NUMORD = '92893' -- Informar se Numord da nota COMPLEMENTAR for SAÍDA
	--NFE.NUMORD = '' -- Informar se Numord da nota COMPLEMENTAR for SAÍDA ENTRADA

