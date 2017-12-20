----------------------------------------------------------------------------------------------------------------------------------------------
-- Consulta CLASSIFICAÇÃO e Dados Adicionais do Cliente (CONTRIBUINTE-IE-CNPJ)
-- O que não retornar na consulta é porque não está relacionado ao cliente
----------------------------------------------------------------------------------------------------------------------------------------------

/*
select numord,lif,atualiz,dtcancel,* from nfsaidacad where numnota = '130418' and filial = '01'
select * from tpo_r where hierarquianumero = '2016'
--VENDA MERCADORIAS BIG NFE
select * from itnfsaicad where numord = 4695714
select * from complnffat where numord = 4695714
select * from dadosnotanfe where numord = 4695714
select * from dadositemnfe where numord = 4695714

select * from basecalfat 
	where (estadoorigem = '' or estadoorigem = 'PR') 
	and (tpo = '' or tpo = '2016') 
	and (estadodestino = '' or estadodestino = 'PR') 
	and codpro in ('05428','06916','13377','39337','')
	and cf in ('0034','0176','0274','0231','')

*/


Declare @idCliente int
	Select @idCliente = codclie 
	from nfsaidacad 
	where numord = 4695714

-- PESSOA
---------------------------------------------------------		
select 	
	Nome, Identificador
from Pessoa_r where oid = @idCliente


-- DADOS ADICIONAIS 
---------------------------------------------------------		
select 	
	d.Valor, a.SVALOR, a.NVALOR
from aditivo_r a, Dadoadicional_r d
where a.rdefinicao = d.oid and a.ritem = @idCliente

-- CLASSIFICAÇÃO
---------------------------------------------------------
select 
	'Classificação: ', ca.nome 
from  CLASSIFICACAO_R cl, Categoria_r ca 
where cl.rcategoria = ca.oid and cl.ritem = @idCliente


-- Buscar contatos gravados no campo contato
--------------------------------------------------------------------
SELECT 
	'Contatos: ', SUBSTRING(Nome,1,40) Nome,	-- Contato
	OID							-- Oid da tabela Item 
FROM Pessoa_R 
WHERE OID IN (SELECT C.RItem FROM Classificacao C, Agrupamento A 
				WHERE C.RCategoria = 1000 
					AND C.RItem = A.RItem 
					AND A.RGrupo = @idCliente -- Oid do Cliente da tabela Pessoa_R
					)
-----------------------------------------------------------------------------------