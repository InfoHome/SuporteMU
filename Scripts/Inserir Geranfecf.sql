----------------------------------------------------------------------------------------------------------------------------------------------------
-- Script para Insereir registro de pedido no GeraNFECF
--------------------------------------------------------------------------------------------------------------------------------------------------
declare @pnSessao int,  @pnNumped int, @pnRcaixa int, @pnrUsuario int, @pnSerieSerialECF varchar(max), @pnCOO char(6), @pnData datetime

set @pnSessao = 234099232								-- Pegar no Log LinkTime o oid da Sessao Aplicativo criada para o usuário
set @pnNumped = 2340994									-- Informar o Número do pedido
set @pnSerieSerialECF = '001/BE091310100011250008'		-- Pegar Série/Serial da Impressora do Cupom Fiscal
set @pnData = '20170701 09:42:58'						-- Pegar Data/Hora do Cupom Fiscal
set @pnCOO = '000006'

/* Pegar o usuario */	select @pnrUsuario= RUSUARIO from sessaoaplicativo_r  where oid = @pnSessao
/* Pegar o localporta */ select distinct @pnRcaixa = localporta from vendasscad where usuven=@pnrUsuario and year(dtven)= year(@pnData) and month(dtven)= month(@pnData) and day(dtven)= day(@pnData)

--ATENÇÃO! Descomente o insert e os updates para inserir na GeraNFECF
----------------------------------------------------------------------
-- update itemclicad set itemselecionado='1',reserva='S', sitfat='0' where numped= @pnNumped
-- update PEDICLICAD set sitmanut='F', sitven='1' where numped= @pnNumped
-- insert GERANFECF (NUMPED,NUMEROCUPOM,NUMEROECF,RCAIXA,OPERACAO,RSESSAODEUSO,impreq,DTOPERA,RUSUARIO,DIFMERC) 
select @pnNumped as NUMPED,	@pnCOO as COO, @pnSerieSerialECF as NUMEROECF ,@pnRcaixa as RCAIXA,'N' as OPERACAO,7 as RSESSAODEUSO,0 as impreq,@pnData as DTOPERA, @pnrUsuario as RUSUARIO,0 as DIFMERC

-- Após esse ajuste deve ter gerado o cupom no banco de dados, consulte a NFSaidacad e demais tabelas do cupom.