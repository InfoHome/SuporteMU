---------------------------------------------------------------------------------------------------------------------------
-- Inserir na FilaNFE notas de SAÍDAS e ENTRADAS - Situação de Envio Normal
---------------------------------------------------------------------------------------------------------------------------
-- Consulte as situações de envio NFE em: https://github.com/InfoHome/Suporte/tree/master/Planilhas
-- Documento: Situações de Envio NFE.xlsx
---------------------------------------------------------------------------------------------------------------------------

-- insert nota de SAÍDA
--------------------------------
insert into FILANFE (DATAPROCESSAMENTONFE,NUMORD,SITUACAONFE,TEMPOMEDIOESTIMADO,TIPONFE,FILIAL,SITANTERIOR)
select GETDATE(),c.NUMORD,1,0,'S',n.FILIAL,c.SITUACAONFE 
	from COMPLEMENTONFSAIDA c 
		join nfsaidacad n on c.numord = n.numord 
	where c.NUMORD = 'Colocar aqui o Numord da nota'
	
	
-- insert nota de ENTRADA
--------------------------------
insert into FILANFE (DATAPROCESSAMENTONFE,NUMORD,SITUACAONFE,TEMPOMEDIOESTIMADO,TIPONFE,FILIAL,SITANTERIOR)
select GETDATE(),c.NUMORD,1,0,'E',n.FILIAL,c.SITUACAONFE 
	from COMPLEMENTONFENTRA c 
		join nfentracad n on c.numord = n.numord 
	where c.NUMORD =  'Colocar aqui o Numord da nota'
