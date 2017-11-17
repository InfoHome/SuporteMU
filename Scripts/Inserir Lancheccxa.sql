
insert into lancheccxa (datalanc,tpo,filial,vallanc,documen,localporta,datadisp,numord,codigo,tipolanc,moeda,atualiz,numped,codutil)
select dtemis,tpo,filial,valcontab,condpag,localporta,dtemis,numord,7,'C',1,1,numped,'' from nfsaidacad where numord = 8618679 


declare @pDocumen int 

set @pDocumen = 11056

insert into lancheccxa 
(DATALANC,TPO,FILIAL,CCUSTO,VALLANC,DOCUMEN,CODHIST,HIST1,HIST2,LOCALPORTA,CONTA,NUMDOCPAG,DATADISP,NUMORD,CODIGO,TIPOATUAL,TIPOLANC,MOEDA,ATUALIZ,TRANSF,
CLASSE,CTB,CUS,INTEGRADO,PROVIS,ATUALIZ2,NUMDOC,REALFLUXO,LANCDIRET,CODUTIL,JAEMIT,EXPORTADO,NUMPED,NUMORDFIS,IMPOGER,QUANTPARCELA,NUMORDDEV,RITEMPREV,RRECEBIMENTODETERCEIROS,CARENCIA,
CREDITODECARTAO,RATOLIGACAOCONTAPAGAR,RFONTEPAGADORACP,NOMEEMITENTE,CPFCNPJEMITENTE,NUMEROBANCO,NUMEROAGENCIA,NUMEROCONTA,
CMC7,ANALITICO,NUMEROCHEQUE)
SELECT  
	nf.dtemis as DATALANC,
	nf.tpo as tpo, 
	nf.filial as filial,
	'' as ccusto,	
	nf.valcontab as vallanc,
	@pDocumen as document,	
	'' as CODHIST,	
	'' as HIST1,	
	'' as HIST2,	
	case when nf.localporta > 7 then nf.localporta when v.localporta > 7 then v.localporta else NULL end as localporta,
	
	7 as CONTA,
	'' as NUMDOCPAG,
	nf.dtemis as DATADISP,	
	case when nf.numord > 7 then nf.numord	when v.numord > 7 then v.numord	else nf.nordven end as numord, 
	7 as codigo,
	'' as tipoatual,
	'C' as TIPOLANC,
	1 as moeda,
	1 as atualiz,
	0 as transf,
	'' as classe,	
	0 as ctb,	
	0 as cus,	
	0 as integrado,	
	0 as provis,	
	0 as atualiz2,	
	'' as numdoc,	
	0 as REALFLUXO,	
	0 LANCDIRET,	
	'' as CODUTIL,
	'' as JAEMIT,
	0 as EXPORTADO,	
	nf.numped NUMPED,	
	'' as NUMORDFIS,	
	0 as IMPOGER,	
	1 as QUANTPARCELA,	
	0 as NUMORDDEV,	
	0 as RITEMPREV,	
	7 as RRECEBIMENTODETERCEIROS,	
	0 as CARENCIA,	
	0 as CREDITODECARTAO,	
	7 as RATOLIGACAOCONTAPAGAR,	
	7 as RFONTEPAGADORACP,	
	NULL as NOMEEMITENTE,	
	NULL as CPFCNPJEMITENTE,	
	NULL as NUMEROBANCO,	
	NULL as NUMEROAGENCIA,	
	NULL as NUMEROCONTA,	
	NULL as CMC7,	
	0 as ANALITICO,	
	NULL as NUMEROCHEQUE
		
FROM	NFSAIDACAD nf
		LEFT JOIN VENDASSCAD v ON v.numord = nf.numord
WHERE	nf.numord = 8125491 -- Informar o numord da nota