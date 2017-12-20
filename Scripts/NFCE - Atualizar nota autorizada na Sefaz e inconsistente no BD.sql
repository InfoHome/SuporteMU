-- Atualizar NFCE autorizada na Sefaz
--------------------------------------------------------------------------------------------------------------------------
Declare @prot varchar(max), @numord int, @data datetime
Set @numord = 839956
Set @prot = 332170012636962
Set @data = '20171129 16:16:07'

Update COMPLEMENTONFSAIDA set SITUACAONFE = 'R', numeroprotocolo = @prot, DhProtocolo = @data where NUMORD = @numord
Update NFSAIDACAD set lif = 1, atualiz = 1, flagemit = 1, integrado = 1 where numord = @numord
Update itnfsaicad set atuaitem = 1 where numord = @numord
