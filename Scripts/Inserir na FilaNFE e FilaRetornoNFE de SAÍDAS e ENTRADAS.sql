---------------------------------------------------------------------------------------------------------------------------
-- Script 1: Inserir na FilaNFE notas de SAÍDAS e ENTRADAS - Situação de Envio Normal
---------------------------------------------------------------------------------------------------------------------------
-- Consulte as situações de envio NFE em: http://tobias/suporte
-- Menu Tabelas: Situações NFE 
---------------------------------------------------------------------------------------------------------------------------
DECLARE @vpNumord int, @vpSituacaoEnvio char(1)

Set @vpNumord = 217855				-- Informe o Numord da nota a ser enviada
Set @vpSituacaoEnvio = '1'			-- Informe a situação de envio da nota

If EXISTS (Select 1 from COMPLEMENTONFSAIDA where numord =  @vpNumord) -- insert nota de SAÍDA
	begin 
	update COMPLEMENTONFSAIDA set recibonfe = 0, lotenfe=0 where numord = @vpNumord
	insert into FILANFE (DATAPROCESSAMENTONFE,NUMORD,SITUACAONFE,TEMPOMEDIOESTIMADO,TIPONFE,FILIAL,SITANTERIOR)
	select GETDATE(),c.NUMORD,@vpSituacaoEnvio,0,'S',n.FILIAL,c.SITUACAONFE 
		from COMPLEMENTONFSAIDA c join nfsaidacad n on c.numord = n.numord 	where c.NUMORD = @vpNumord
	end
ELSE -- insert nota de ENTRADA
	begin
	update COMPLEMENTONFENTRA set recibonfe = 0, lotenfe=0 where numord = @vpNumord
	insert into FILANFE (DATAPROCESSAMENTONFE,NUMORD,SITUACAONFE,TEMPOMEDIOESTIMADO,TIPONFE,FILIAL,SITANTERIOR)
	select GETDATE(),c.NUMORD,@vpSituacaoEnvio,0,'E',n.FILIAL,c.SITUACAONFE 
		from COMPLEMENTONFENTRA c join nfentracad n on c.numord = n.numord 	where c.NUMORD =  @vpNumord
	end
GO
---------------------------------------------------------------------------------------------------------------------------
-- Script 2: Inserir na FilaRETORNO NFE notas de SAÍDAS e ENTRADAS - Situação de Envio Normal
---------------------------------------------------------------------------------------------------------------------------
-- Consulte as situações de envio NFE em: http://tobias/suporte
-- Menu Tabelas: Situações NFE 
---------------------------------------------------------------------------------------------------------------------------

DECLARE @vpNumord int, @vpSituacaoRetorno char(1)

Set @vpNumord = 217855				-- Informe o Numord da nota a ser enviada
Set @vpSituacaoRetorno = '1'			-- Informe a situação de retorno da nota

If EXISTS (Select 1 from COMPLEMENTONFSAIDA where numord =  @vpNumord) -- insert nota de SAÍDA
	insert into FILARETORNONFE (NUMORD,SITUACAONFE,TIPOES,GUID,ATUALIZADOEM) VALUES(@vpNumord,@vpSituacaoRetorno,'S',NULL,NULL)

ELSE -- insert nota de ENTRADA
	insert into FILARETORNONFE (NUMORD,SITUACAONFE,TIPOES,GUID,ATUALIZADOEM) VALUES(@vpNumord,@vpSituacaoRetorno,'E',NULL,NULL)
GO


---------------------------------------------------------------------------------------------------------------------------
-- Script 3: Consultas
---------------------------------------------------------------------------------------------------------------------------
--Saida
-------------------------------
select cp.situacaonfe,cp.numeroprotocolo,cp.chavedeacessonfe,cp.recibonfe,fn.*,fr.* 
from complementonfsaida cp 
	left join FILANFE fn on fn.numord = cp.numord
	left join FILAretornoNFE fr on cp.numord = fr.numord 
	where cp.NUMORD = 2071928 -- Informe o numord da nota


--Entrada
-------------------------------
select ce.situacaonfe,ce.numeroprotocolo,ce.chavedeacessonfe,ce.recibonfe,fne.*,fre.* 
from complementonfentra ce 
	left join FILANFE fne on fne.numord = ce.numord
	left join FILAretornoNFE fre on ce.numord = fre.numord 
where ce.NUMORD = 1453686 -- Informe o numord da nota