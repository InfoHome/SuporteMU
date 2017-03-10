
--------------------------------------------------------------------------------------------------------------------
-- ********* Passo 1
-- ****** // INICIO para Veridicação inexistente no banco de dados
-- Verifica e Cria Tabela Temporária para Criar os registros sequanciais
-- Processo para gerar a sequencia numerada Atual.
--------------------------------------------------------------------------------------------------------------------
IF object_id('TB_Registros_F01') IS NOT NULL DROP TABLE TB_Registros_F01
Create  table  TB_Registros_F01 (Numero varchar(6))
-------------------------------------------------------------------------------------
declare @registros int, @UltimoNumero int, @filial char(2)

Set @filial = '01' -- Informar o código da Filial
select @UltimoNumero = max(cast(numnota as int)) from nfsaidacad 
							where 
								modelonf = '65' 
								and serie = '1'	
								and filial = @filial -- Pegar a numeração Final

-- Gerar os Registros na tabela TB_Registros
-------------------------------------------------------------------------------------
SET @registros = 1
while @registros <= @UltimoNumero
BEGIN
	INSERT INTO TB_Registros values (RIGHT('000000' + LTRIM(RTRIM( @registros )),6))
		set @registros= @registros + 1
END	

-- Exibe quais numerações não estão presentes 
-- Processo identificar os saltos na sequencia numerada.
-------------------------------------------------------------------------------------
select Numero from TB_Registros_F01 
	where Numero not in (Select distinct numnota from nfsaidacad where  modelonf = '65' and serie = '1'
	and filial = '01')

-- ****** // FIM para Veridicação inexistente no banco de dados
-- ****************************************************************
-----------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
-- ********* Passo 2
-- Gerar Registos de Numerações que não foram geradas para ser inutilizadas pelo Gerenciamento de NFCE
-- A T E N Ç Ã O - Antes de iniciar este passo tem que separa um faixa de numord para prosseguir
--------------------------------------------------------------------------------------------------------------------
Begin transaction
go
Declare @NNumord int, @NumordFinal int, @NNF char(6), @Count int , @NFilial char(2) 
declare @sqlnCFOSaidCad varchar(5000), @sqlnNFSaida varchar(5000),  @sqlComplementoNFSaida varchar(5000)

set @NNumord = 4256562			--Informa o numord inicial da faixa a ser utilizado
set @NumordFinal = 4256630		--Informa o numord final da faixa ser utilizado
set @NFilial = '01'				--Informa a final
set @Count = 1

WHILE  @Count = 1

BEGIN
	(select @NNF = min(numero) from TB_Registros_F01
				where Numero not in (Select distinct numnota from nfsaidacad 
										where modelonf = '65' and serie = '1' and filial = @NFilial))
   
	select @sqlnNFSaida = 'INSERT INTO nfsaidacad(NUMNOTA,SERIE,CODCLIE,DTEMIS,ESPDOC,FILIAL,ESTADO,CFO,TPO,VALCONTAB,BASEICM,BASEICM2,BASEICM3,ALQICM,ALQICM2,ALQICM3,VALICM,VALICM2,VALICM3,BASEIPI,VALIPI,VALSEMICM,VALSEMIPI,BASESTRIB,VALSUBSTRI,VALTRIBDIF,DESTAQIPI,VALSERVICO,VALISS,VALFRETE,VALSEGURO,FRETEINC,OUTRICM,OUTRIPI,CCUSTO,OBS,CODVEND,NUMPED,VALENTRAD,CODMETRA,CODTRAN,DESCONTO,COMISSAO,NUMORD,FATURADO,ATUALIZ,FLAGEMIT,FLAGREGFIS,FLAGATUA,ICMSIPI,VALEMBA,CODROTE,CODNATOP,FILTRANSF,TIPONF,FLAGINTER,FLAGCONTAB,CODSITEST,CODSITFED,PERCSUBST,LUCRO,REC,CXA,FLU,CTB,ATF,CUS,INTEGRADO,DTCANCEL,BASEISS,MODELONF,CONDPAG,EST,LIF,FAT,EXPORTADO,CODMES,PERIPI,LOCALPORTA,CONTA,CODTRAN2,CUPOMINI,CUPOMFIM,GVE,BASEICM4,ALQICM4,VALICM4,CLASVEND,FLAGCONS,CLIFIM,EXPORTA,PEDIMPO,TIPONOTA,NUMECF,NUMCUPON,VALNFCHE,CLIENTEA,NORDVEN,NUMNFECF,BASEICM5,ALQICM5,VALICM5,NUMORDFIS,IMPOGER,ICMSFONTE,TOTMERC,TOTPESO,TXFINAN,EXCED,CODLIS,OIDDOCDEORIGEM,ATUACUM,JACOMIS,CONTABILIZADO,CODFOROUT,DEPORIGEM,TPOOUTRAENT,CONTREDZ,GT,BASEIR,ALIQIR,CODGER,OIDREVENDA,HISTORICO,BASEINSS,ALIQINSS,VALINSS,ALIQISSRET,BASEISSRET,VALISSRET,VALIRRF,NFFUTURA,NORDEXPEDIC,VALIDADE,SITPRODUTO,DESPNAOINCLUSAS,ICMSDESPNAOINCLUSAS,FRETESUBSTRIBUTARIA,SERIEECF,GTFIM,VALCANECF,VALDESCECF,CONTREIOPE,OUTRASDESPESASINCLUSAS,TIPOENTR,NUMORDECF,TOTALPRECOCOMICMS,TOTALVALORICMS,DESPESASIMPORTACAO,OIDSERIALECF) VALUES(''' + RIGHT('000000' + LTRIM(RTRIM(@NNF)),6)+ ''',''1'',7,''20170224'',''NF'','''+CONVERT(varchar,@NFilial)+''',''PR'',''0000'',''2024'',0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,'''',0.0000,0.0000,0.0000,0.0000,'''',0.0000,0.0000,'''','''','''',7,0.0000,'''','''',0.0000,0.0000,'+ convert(varchar, @NNumord) +',0.0000,0.0000,0.0000,0.0000,0.0000,'''',0.0000,'''',0,'''',''24'',0.0000,0.0000,'''','''',0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,'''',0.0000,Null,0.0000,''65'',7,'''',1.0000,0.0000,0.0000,'''',0.0000,7,7,'''','''','''',0.0000,0.0000,0.0000,0.0000,'''',0.0000,0,0.0000,'''','''','''','''',0.0000,0,0,'''',0.0000,0.0000,0.0000,0,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,'''',Null,0.0000,0.0000,0.0000,7,'''',7,'''',0.0000,0.0000,0.0000,'''',Null,'''',0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,Null,0.0000,0.0000,0.0000,0.0000,0.0000,'''',0.0000,0.0000,0.0000,'''',0.0000,'''',Null,0.0000,0.0000,0.0000,Null)'
	select @sqlnCFOSaidCad = 'INSERT INTO cfosaidcad(NUMNOTA,SERIE,CODCLIE,NUMORD,CFO,CODNATOP,BASEICM,BASEICM2,BASEICM3,BASEICM4,BASEICM5,ALQICM,ALQICM2,ALQICM3,ALQICM4,ALQICM5,VALICM,VALICM2,VALICM3,VALICM4,VALICM5,OUTRICM,VALSEMICM,BASEIPI,ALIQIPI,VALIPI,OUTRIPI,VALSEMIPI,VALSUBSTRI,VALTRIBDIF,PERCSUBST,BASESTRIB,OBSVALORIPI,OBSBASESUBSTRI,OBSVALSUBSTRI,BASEEXCEDENTE,NOVOIPI) VALUES('''+RIGHT('000000' + LTRIM(RTRIM(@NNF)),6)+''',''1'',7,'+ convert(varchar, @NNumord) +',''0000'',0,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000,Null,Null,Null,0.0000,0.0000)'
	select @sqlComplementoNFSaida = 'INSERT INTO complementonfsaida(BASEICMDESTACADO,CODIGOREGIAO,CONSULTASUFRAMA,COTACAOMOEDA,EXPEDIDOR,FRETEPAGAR,GERARNFSERVICO,KMATUAL,KMMES,MOEDA,MOTORISTA,NUMORD,NUMORDNFVENDA,NUMORDPRODPROPRIO,NUMPEDREGIONAL,OIDCONTRATANTE,PERCENTUALCOFINS,PERCENTUALPIS,PERCICMDESTACADO,PLACA,PREVISAOENTREGA,RESPONSAVELCONSULTA,SITUACAOCADASTROSUFRAMA,STATUSCONSIGNACAO,TIPOFRETE,VALORFRETEDESTACADO,VALORICMFRETE,CODVENDEXT,ITINERARIO,MARKUPREALTOTAL,NUMEROEMPENHO,NUMPEDPRODREL,ORDEM,UNIDADEEXECUTORA,VALORICMSDISPENSADO,MANUAL,OBSERVACAO,AIDF,CLASSE,VALCUSTOFRETE,ISSCIDADE,FLAGPESOALTERADO,VALORICMFRETEO,OIDDOCDEORIGEMFRETE,CHAVEDEACESSONFE,CODIGONFE,CODPROCONJ,DESCONTOSUFRAMA,JUSTIFICATIVA,LOTENFE,NUMEROPROTOCOLO,QUANTCONJ,RATENDIMENTO,RECIBONFE,SITUACAONFE,VALORACRESCIMO,RECEBIMENTOTEF,VALORDESCONTOPISCOFINS,FLAGEMITCONTINGENCIA,FILIALNFE,FINNFE,NUMORDCONTINGENCIA,NUMEROPROTOCOLOCANCELAMENTO,NUMEROPROTOCOLOINUTILIZACAO,RECIBODPEC,DHPROTOCOLO,DHRECIBODPEC,DHCANCELAMENTO,DHINUTILIZAÇÃO,FLAGPISCOFINS,REDZMANUAL,FLAGRENTABI,TOTALTRIBUTO,DHEMISSAO,DTEMIS,ADE_ATODECLARATORIO,ADE_DATADOCUMENTO,ADE_MODELODOCUMENTO,ADE_NUMERODOCUMENTO,ADE_PARTICIPANTE,ADE_SERIEDOCUMENTO,DESCONTODEVOLUCAO,ETIQUETAEMITIDA,NFEIMPORTADA,NUMPEDAUTOMATICO,OIDDOCDEORIGEMCOMISSAO,PERCENTUALCOMISSAO,USULIBCANCELAMENTONF,DHINUTILIZACAO1,COD_INF_COMPL,DES_INF_COMPL,FLAGCRIACAO,CHAVECANCELAMENTOCFE) VALUES(Null,Null,Null,0.0000,Null,Null,Null,Null,Null,Null,Null,'+convert(varchar, @NNumord)+',Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,'''',0,0.0000,Null,Null,Null,Null,Null,Null,''INUTILIZARNFCEAVULSA'','''','''',Null,0.0000,Null,Null,Null,''0'',0,Null,0.0000,''NUMERACAOINUTILIZADAPORERRONOSISTEMA'',Null,0.0000,Null,Null,0.0000,''Q'',Null,0.0000,0.0000,Null,'''+convert(varchar, @NFilial)+''',Null,Null,0.0000,0,Null,Null,Null,Null,Null,0.0000,0.0000,0.0000,0.0000,Null,Null,'''',Null,'''','''','''','''',Null,0.0000,'''',0,Null,0.0000,Null,Null,'''','''',0.0000,Null)'
   
   PRINT @sqlnNFSaida;
   PRINT @sqlnCFOSaidCad;
   PRINT @sqlComplementoNFSaida;
   --execute @sqlnNFSaida;
   --execute @sqlnCFOSaidCad;
   --execute @sqlComplementoNFSaida;
   
   --Incremento das variáveis   
   ---------------------------------------------------------------------------------------------------------
   set @NNumord = @NNumord + 1 -- Pegar o próximo numord da faixa
   delete from TB_Registros_F01 where numero = @NNF -- Liberar o numero
   -- verificar se existem registros para serem processados
   set @Count = (select distinct 1 from TB_Registros_F01
				where Numero not in (Select distinct numnota from nfsaidacad 
										where modelonf = '65' and serie = '1' and filial = @NFilial))
   -- // verificar se existem registros para serem processados
  
    IF (@Count = 0)
      BREAK  
   ELSE  
      CONTINUE  
END  

--PRINT 'Termino do prcessamento';  
--rollback
commit


--------------------------------------------------------------------------------------------------------------------
-- ********* Passo 3
-- *********** EXCLUIR TABELA CRIADA APÓS CONSULTAS E AJUSTES ***************
--------------------------------------------------------------------------------------------------------------------
--IF object_id('TB_Registros') IS NOT NULL DROP TABLE TB_Registros
--IF object_id('TB_Registros_F01') IS NOT NULL DROP TABLE TB_Registros_F01
--IF object_id('TB_Registros_F02') IS NOT NULL DROP TABLE TB_Registros_F02
--IF object_id('TB_Registros_F03') IS NOT NULL DROP TABLE TB_Registros_F03
--------------------------------------------------------------------------------------------------------------------


