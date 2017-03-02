-- PROCESSO DE INUTILIZA��O NFCE INCONSISTENTE
-----------------------------------------------------------------------------------------------------
-- ****** // INICIO Ajuste numera��o existente no banco de dados inconsistente ******
-----------------------------------------------------------------------------------------------------
declare @nNumord int, @sqlITEM varchar(500),  @sqlNF varchar(500),  @sqlCOMPL varchar(500)
declare CurAjusta_NFCE_PARA_INUTILIZAR cursor for 
					
					Select n.numord from Nfsaidacad n 
						join complementonfsaida c on n.numord = c.numord 
						and  modelonf = '65' and serie = '1'
					where filial = '01'
						and len(c.CHAVEDEACESSONFE) = 44 
						and c.SITUACAONFE <> 'R' and c.SITUACAONFE not in ('G','H')
						and (NUMEROPROTOCOLO is null or NUMEROPROTOCOLO = 0)
						and (numeroprotocoloinutilizacao is null or numeroprotocoloinutilizacao = 0)
						and (numeroprotocolocancelamento is null or numeroprotocolocancelamento = 0)

open CurAjusta_NFCE_PARA_INUTILIZAR
fetch CurAjusta_NFCE_PARA_INUTILIZAR into @nNumord
while @@fetch_status <> -1
begin
    select @sqlITEM =	'UPDATE ITNFSAICAD SET ATUAITEM = 0 WHERE NUMORD = ' + cast(@nNumord as varchar)
	select @sqlNF =		'UPDATE NFSAIDACAD SET ATUALIZ= 0,INTEGRADO= 0 WHERE NUMORD =' + cast(@nNumord as varchar)
	select @sqlCOMPL =	'UPDATE COMPLEMENTONFSAIDA SET SITUACAONFE = 3 WHERE NUMORD = ' + cast(@nNumord as varchar)
    ------------------------------------------------------------------------------------------------------------------
    -- Ponto de Consulta e Ajuste
    ------------------------------------------------------------------------------------------------------------------
    print @sqlITEM		-- Descomente o in�cio dessa linha e comente o in�cio da linha DEBAIXO para s� CONSULTAR
	print @sqlNF		-- Descomente o in�cio dessa linha e comente o in�cio da linha DEBAIXO para s� CONSULTAR
	print @sqlCOMPL		-- Descomente o in�cio dessa linha e comente o in�cio da linha DEBAIXO para s� CONSULTAR
	--execute(@sqlITEM)	-- Descomente o in�cio dessa linha e comente a o in�cio da linha ACIMA para AJUSTAR
	--execute(@sqlNF)		-- Descomente o in�cio dessa linha e comente a o in�cio da linha ACIMA para AJUSTAR
	--execute(@sqlCOMPL)	-- Descomente o in�cio dessa linha e comente a o in�cio da linha ACIMA para AJUSTAR
    ------------------------------------------------------------------------------------------------------------------
    fetch CurAjusta_NFCE_PARA_INUTILIZAR into @nNumord
end
close CurAjusta_NFCE_PARA_INUTILIZAR
deallocate CurAjusta_NFCE_PARA_INUTILIZAR

-- ****** // FIM Ajuste numera��o existente no banco de dados inconsistente ******
-----------------------------------------------------------------------------------------------------
