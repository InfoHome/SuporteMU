------------------------------------------------------------------------------------------------------------
--Rateio de Frete
------------------------------------------------------------------------------------------------------------

Declare @pnFrete  numeric(15,8), @pnResult  numeric(15,8)

set @pnFrete = 60

Select @pnResult =  @pnFrete / SUM(quant*preco) from itnfsaicad where numord = '8359918'

Select 
	'update nfsaidacad set valfrete = '+ CONVERT(varchar,@pnFrete)+ ' where numord = ' +  convert(varchar,numord),
	'update ITNFSAICOMPLEMENTO set ValorFrete = ' + CONVERT(varchar,@pnResult*(quant*preco))
			+ ' where numord = ' + convert(varchar,numord)+ ' and item = '''+  convert(varchar,item)+''''
from itnfsaicad where numord = '8359918'

