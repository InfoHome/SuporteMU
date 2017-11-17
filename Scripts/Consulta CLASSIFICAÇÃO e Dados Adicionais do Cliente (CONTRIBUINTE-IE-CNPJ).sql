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
	'Classificação:', ca.nome 
from  CLASSIFICACAO_R cl, Categoria_r ca 
where cl.rcategoria = ca.oid and cl.ritem = @idCliente


-- Buscar contatos gravados no campo contato
--------------------------------------------------------------------
SELECT 
	'Contatos:', SUBSTRING(Nome,1,40) Nome,	-- Contato
	OID							-- Oid da tabela Item 
FROM Pessoa_R 
WHERE OID IN (SELECT C.RItem FROM Classificacao C, Agrupamento A 
				WHERE C.RCategoria = 1000 
					AND C.RItem = A.RItem 
					AND A.RGrupo = @idCliente -- Oid do Cliente da tabela Pessoa_R
					)
-----------------------------------------------------------------------------------