-----------------------------------------------------------------------------------------------------------------------------
--Inserir nota de transferência de entrada que não registrou no banco de dados
--A T E N Ç Ã O: após essa inserção os dados da nota de entrada devem ser conferidos no Livro Fiscal
-- Declarações --------------------------------------------------------------------------------------------------------------
Declare @pnfilTransfEntrada char(2), @pnNumord int,
Declare @pnTPOEntrada varchar(max), @pnNatOperacao int
Declare @pnCFOP int, @pnCFOPST int
-- Definições ---------------------------------------------------------------------------------------------------------------

set @pnNumord = 1885497			-- Informe o numord da nota de saída
set @pnTPOEntrada = 9004		-- Informe o TPO na Transferencia de Entrada


-- Filial de Transferencia de Entrada
------------------------------------------
Select @pnfilTransfEntrada = filtransf from NFSAIDACAD where numord = @pnNumord 
-- Natureza de operação
------------------------------------------
select  @pnNatOperacao = a.VALOR from TPOINTERFERENCIA_R a INNER join TPOINTEGRACAO_R b on a.RTPOINTEGRACAO = b.OID 
	INNER join TPO_R c on a.RTPO = c.oid INNER join item d on d.oid = b.RDOMINIO 
where C.HIERARQUIANUMERO = @pnTPOEntrada and b.oid =  19275 -- Natureza de Operações
-- CFOP Normal
------------------------------------------
select @pnCFOP = a.VALOR
from TPOINTERFERENCIA_R a 
             INNER join TPOINTEGRACAO_R b on a.RTPOINTEGRACAO = b.OID 
             INNER join TPO_R c on a.RTPO = c.oid
             INNER join item d on d.oid = b.RDOMINIO 
where C.HIERARQUIANUMERO = @pnTPOEntrada and b.OID = 15890 --C.F.O.P.
-- CFOP ST
------------------------------------------
select @pnCFOPST = a.VALOR
from TPOINTERFERENCIA_R a 
             INNER join TPOINTEGRACAO_R b on a.RTPOINTEGRACAO = b.OID 
             INNER join TPO_R c on a.RTPO = c.oid
             INNER join item d on d.oid = b.RDOMINIO 
where C.HIERARQUIANUMERO = @pnTPOEntrada and b.OID = 16593 --C.F.O.P. Subst. Tributária
------------------------------------------------------------------------------------------------------------------------------
--Insert nfentracad
------------------------------------
insert into NFENTRACAD( NUMNOTA,SERIE,codfor,DTEMIS,ESPDOC,FILIAL,ESTADO,CFO,TPO, VALCONTAB,BASEICM,BASEICM2,BASEICM3,
	ALQICM,ALQICM2,ALQICM3,	VALICM,VALICM2,VALICM3,	BASEIPI,VALIPI,VALSEMICM,VALSEMIPI,BASESTRIB,VALSUBSTRI,
	DESTAQIPI,VALISS,VALFRETE,OUTRICM,OUTRIPI,	CCUSTO,OBS,CODVEND,NUMPED,VALENTRAD,CODMETRA,CODTRAN,DESCONTO,COMISSAO,NUMORD,
	ATUALIZ,FLAGATUA,ICMSIPI,CODNATOP,TIPONF,FLAGCONTAB,CXA,FLU,CTB,CUS,INTEGRADO,DTCANCEL,BASEISS,MODELONF,EST,LIF)
select 
	numnota,serie,codclie,dtemis,ESPDOC,
	@pnfilTransfEntrada,
	ESTADO,
	@pnCFOP,
	@pnTPOEntrada,
	valcontab,BASEICM,BASEICM2,BASEICM3, ALQICM,ALQICM2,ALQICM3,
	VALICM,VALICM2,VALICM3,	BASEIPI,VALIPI,VALSEMICM,VALSEMIPI,BASESTRIB,VALSUBSTRI,
	'',VALISS,VALFRETE,OUTRICM,OUTRIPI,	'','',CODVEND,NUMPED,
	0.0000,'','',0.0000,0.0000,NUMORD,0,0.0000,'N',
	@pnNatOperacao,
	'13',0.0000,0.0000,0.0000,1.0000,'',1.0000,Null,0.0000,'01','1',1.0000
from nfsaidacad where numord = @pnNumord
------------------------------------
--Inserir cfo
------------------------------------
INSERT INTO CFOENTRCAD (NUMNOTA,SERIE,codfor,NUMORD,CFO,CODNATOP,BASEICM,BASEICM2,BASEICM3,BASEICM4,BASEICM5,ALQICM,ALQICM2,ALQICM3,ALQICM4,ALQICM5,VALICM,VALICM2,VALICM3,VALICM4,VALICM5,OUTRICM,VALSEMICM,BASEIPI,ALIQIPI,VALIPI,OUTRIPI,VALSEMIPI,VALSUBSTRI,BASESTRIB,OBSVALORIPI,OBSBASESUBSTRI,OBSVALSUBSTRI)
select numnota, serie, '7',NUMORD,
	Case when baseicm+baseicm2+baseicm3+baseicm4+baseicm5 > 0 then @pnCFOP else @pnCFOPST end,
	CODNATOP,BASEICM,BASEICM2,BASEICM3,BASEICM4,BASEICM5,ALQICM,ALQICM2,ALQICM3,ALQICM4,ALQICM5,VALICM,VALICM2,VALICM3,VALICM4,VALICM5,OUTRICM,VALSEMICM,BASEIPI,ALIQIPI,VALIPI,OUTRIPI,VALSEMIPI,VALSUBSTRI,BASESTRIB,OBSVALORIPI,OBSBASESUBSTRI,OBSVALSUBSTRI
from CFOSAIDCAD where numord = @pnNumord
------------------------------------
-- Inserir itens
------------------------------------
insert into itnfentcad(numnota,serie,codpro,dv,quant,unidade,preco,precototal,numord,flagmov,emisetiq,dtcheg,filial,valoripi,aliqicms,baseicms,
	cfo,ccusto,c2moetran, cm,ct,valche,custgeral,valsubstri,faconv,item,itemsaida,CUSTOMARGEM0)
select numnota,serie,codpro,dv,quant,unidade,preco, 0, numord,0,0, dtemis, 
	@pnfilTransfEntrada,0, aliqicms,baseicms,
	Case when ct in ('000','020','070') then @pnCFOP else @pnCFOPST	end,'',0,
cm,ct,valche,custgeral,valsubstri,faconv,item,0,0
from itnfsaicad where numord = @pnNumord

insert into ITNFENTCOMPLEMENTO(NUMORD,ITEM) select numord, ITEM from ITNFSAICAD where numord = @pnNumord
------------------------------------
--Insert COMPLEMENTONFENTRA
------------------------------------
insert into COMPLEMENTONFENTRA(NUMORD,FLAGEMIT,chavedeacessonfe) 
select numord, 1, chavedeacessonfe from complementonfsaida where numord =  @pnNumord
------------------------------------
--Ajustando o precototal
------------------------------------
update itnfentcad set precototal=quant*preco where numord = @pnNumord


/*
SELECT NFS.Filial, NFS.NumNota, NFS.Serie, NFS.DtEmis, NFS.ValContab Valor, NFS.Est, NFS.NumOrd, 
NFS.NumPed, NFS.Tpo, NFS.FilTransf, NFS.CodVend, NFS.CodTran, NFS.CodTran2, NFS.CodRote, 
NFE.Tpo TpoEntrada, '' Fornecedor, CNFE.FlagCriacao, NFE.OidDocDeOrigem, 1 NFConferida 
FROM NFSaidaCad NFS 
JOIN NFEntraCad NFE ON NFS.NumOrd = NFE.NumOrd 
LEFT JOIN ComplementoNFEntra CNFE ON NFE.NumOrd = CNFE.NumOrd 
WHERE SUBSTRING(NFS.TPO,1,1) = '9' 
	and nfe.numord=1885497
	AND NFS.Atualiz = 1 
	AND NFE.Atualiz = 0 
	AND NFE.Filial = '06'
	AND NFS.DtEmis >= '20170530' 
	AND NFS.DtEmis <= '20170530' 

select filtransf,lif,atualiz,dtcancel,flagemit,numord,* from NFSAIDACAD where numnota = '1054611'
select * from NFENTRACAD where numord = 1884227
select * from itnfentcad where numord = 1884227
select * from CFOENTRCAD where numord = 1884227
select * from ITNFENTCOMPLEMENTO where numord = 1884227
select * from ComplementoNFEntra where numord = 1884227
select * from COMPLNFFAT where numord = 1884227
	
*/	



