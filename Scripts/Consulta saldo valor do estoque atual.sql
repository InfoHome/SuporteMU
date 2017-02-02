--------------------------------------------------------------------------------------------------------
-- Consulta o saldo de estoque do produto filtrando pelo NCM do produto
--------------------------------------------------------------------------------------------------------
-- Saldo Agrupado por Filial
--------------------------------------------------------------------------
select 
	I.Filial,
	P.Codpro, 
	p.CODIGONCM as NCM, 
	p.descr as Descricao, 
	sum(i.quant) AS Est_Filiais,
	sum(i.quant * p.precoven) as Custo_Atual
from PRODUTOCAD p, ITEMFILEST i
where p.codpro = i.codpro
	--and p.CODIGONCM = '2508.30.00' -- Retire o comentário "--" no início dessa linha para filtrar por um determinado NCM
group by I.filial,P.codpro,p.CODIGONCM, p.descr
order by p.Descricao 

-- Saldo Agrupado por Filial
--------------------------------------------------------------------------
select 
	P.Codpro, 
	p.CODIGONCM as NCM, 
	p.descr as Descricao, 
	sum(i.quant) AS Est_Filiais,
	sum(i.quant * p.precoven) as Custo_Atual
from PRODUTOCAD p, ITEMFILEST i
where p.codpro = i.codpro
	--and p.CODIGONCM = '2508.30.00' -- Retire o comentário "--" no início dessa linha para filtrar por um determinado NCM
group by P.codpro,p.CODIGONCM, p.descr
order by p.Descricao 