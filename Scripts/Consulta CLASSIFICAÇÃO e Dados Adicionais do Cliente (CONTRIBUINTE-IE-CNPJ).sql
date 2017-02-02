----------------------------------------------------------------------------------------------------------------------------------------------
-- Consulta CLASSIFICAÇÃO e Dados Adicionais do Cliente (CONTRIBUINTE-IE-CNPJ)
-- O que não retornar na consulta é porque não está relacionado ao cliente
----------------------------------------------------------------------------------------------------------------------------------------------

Declare @idCliente int
	Select @idCliente = codclie 
	from nfsaidacad 
	where numord = 'Informar numord da nota'

-- DADOS ADICIONAIS 
---------------------------------------------------------		
select 	
	d.Valor, a.SVALOR, a.NVALOR
from aditivo_r a, Dadoadicional_r d
where a.rdefinicao = d.oid and a.ritem = @idCliente

-- CLASSIFICAÇÃO
---------------------------------------------------------
select 
	ca.nome 
from  CLASSIFICACAO_R cl, Categoria_r ca 
where cl.rcategoria = ca.oid and cl.ritem = @idCliente
