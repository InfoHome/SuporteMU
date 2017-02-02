-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Script para ACOMPANHAR lado a lado o faturamento das tabelas: NFSAIDACAD + DADOSNOTANFE + COMPLEMENTONFSAIDA + FILANFE + FILARETORNONFE + INCONSISTENCIANFE
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 'NFSAIDACAD',n.numord,n.filial,n.numped,convert(char(6),n.numnota)+'/'+convert(char(6),n.serie) as numnota_serie,
					n.valcontab,n.desconto,n.dtemis,n.tiponf,n.lif,n.atualiz,n.dtcancel,n.flagemit,
					n.integrado,n.modelonf,n.serieecf,
		'DADOSNOTANFE',d.nnf,d.demi,d.hsaient,d.dsaient,d.infcpl,d.vnf,d.cmun,d.cep,d.cmund,d.cepd,
		'COMPLEMENTONFSAIDA',co.situacaonfe,co.numeroprotocolo,co.chavedeacessonfe,
		'FILANFE', fn.tiponfe,fn.situacaonfe,fn.sitanterior,fn.filial,
		'FILARETORNONFE', fr.tipoes,fr.situacaonfe,fr.atualizadoem,fr.guid,
		'INCONSISTENCIANFE', icn.codmensagem,icn.descricao
FROM	PEDICLICAD p
		LEFT JOIN VENDASSCAD v ON v.numped = p.numped
		LEFT JOIN NFSAIDACAD n on p.numped = n.numped or v.numord = n.numord 
		LEFT JOIN DADOSNOTANFE d on d.NUMORD = n.numord
		LEFT JOIN COMPLEMENTONFSAIDA co on co.numord = n.numord
		LEFT JOIN FILANFE fn on fn.numord = n.numord
		LEFT JOIN FILARETORNONFE fr on fr.numord = n.numord
		LEFT JOIN INCONSISTENCIANFE icn on icn.numord = n.numord 
					and icn.dataprocessamento in (select  top 1 dataprocessamento  
					from inconsistencianfe where numord = n.numord order by dataprocessamento desc)

WHERE 
	n.modelonf = '55'  
	-- and n.NUMORD  = 
	-- and n.numnota  = ''
	-- and P.NUMPED = 
		
GROUP BY	/*'NFSAIDACAD'*/			n.numord,n.filial,n.numped,n.numnota,n.serie,n.valcontab,n.desconto,
										n.dtemis,n.modelonf,n.lif,n.atualiz,n.dtcancel,n.tiponf,n.flagemit,
										n.integrado,n.modelonf,n.serieecf,
			/*'DADOSNOTANFE'*/			d.nnf,d.demi,d.hsaient,d.dsaient,d.infcpl,d.vnf,d.cmun,d.cep,
										d.cmund,d.cepd,
			/*'COMPLEMENTONFSAIDA'*/	co.situacaonfe,co.numeroprotocolo,co.chavedeacessonfe,
			/*'FILANFE'*/				fn.tiponfe,fn.situacaonfe,fn.sitanterior,fn.filial,
			/*'FILARETORNONFE'*/		fr.tipoes,fr.situacaonfe,fr.atualizadoem,fr.guid,
			/*'INCONSISTENCIANFE'*/		icn.codmensagem,icn.descricao


-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Script para ACOMPANHAR lado a lado o faturamento das tabelas: NFENTRACAD + DADOSNOTANFE + COMPLEMENTONFENTRA + FILANFE + FILARETORNONFE + INCONSISTENCIANFE
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 'NFENTRACAD',n.numord,n.filial,n.numped,convert(char(6),n.numnota)+'/'+convert(char(6),n.serie) as numnota_serie,
					n.valcontab,n.desconto,n.dtemis,n.tiponf,n.lif,n.atualiz,n.dtcancel,
					n.integrado,n.modelonf,
		'DADOSNOTANFE',d.nnf,d.demi,d.hsaient,d.dsaient,d.infcpl,d.vnf,d.cmun,d.cep,d.cmund,d.cepd,
		'COMPLEMENTONFENTRA',co.situacaonfe,co.numeroprotocolo,co.chavedeacessonfe,
		'FILANFE', fn.tiponfe,fn.situacaonfe,fn.sitanterior,fn.filial,
		'FILARETORNONFE', fr.tipoes,fr.situacaonfe,fr.atualizadoem,fr.guid,
		'INCONSISTENCIANFE', icn.codmensagem,icn.descricao
FROM	NFENTRACAD n
		LEFT JOIN DADOSNOTANFE d on d.NUMORD = n.numord
		LEFT JOIN COMPLEMENTONFENTRA co on co.numord = n.numord
		LEFT JOIN FILANFE fn on fn.numord = n.numord
		LEFT JOIN FILARETORNONFE fr on fr.numord = n.numord
		LEFT JOIN INCONSISTENCIANFE icn on icn.numord = n.numord 
					and icn.dataprocessamento in (select  top 1 dataprocessamento  
					from inconsistencianfe where numord = n.numord order by dataprocessamento desc)

WHERE 
	n.modelonf = '55'  
	-- and n.NUMORD  = 
	-- and n.numnota  = ''
		
GROUP BY	/*'NFSAIDACAD'*/			n.numord,n.filial,n.numped,n.numnota,n.serie,n.valcontab,n.desconto,
										n.dtemis,n.modelonf,n.lif,n.atualiz,n.dtcancel,n.tiponf,
										n.integrado,n.modelonf,
			/*'DADOSNOTANFE'*/			d.nnf,d.demi,d.hsaient,d.dsaient,d.infcpl,d.vnf,d.cmun,d.cep,
										d.cmund,d.cepd,
			/*'COMPLEMENTONFSAIDA'*/	co.situacaonfe,co.numeroprotocolo,co.chavedeacessonfe,
			/*'FILANFE'*/				fn.tiponfe,fn.situacaonfe,fn.sitanterior,fn.filial,
			/*'FILARETORNONFE'*/		fr.tipoes,fr.situacaonfe,fr.atualizadoem,fr.guid,
			/*'INCONSISTENCIANFE'*/		icn.codmensagem,icn.descricao
			
			

			