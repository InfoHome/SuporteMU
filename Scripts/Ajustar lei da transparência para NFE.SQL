select ISNULL((sum(i.quant * i.preco * ( case when d.origem in ('0','3','4','5') then t.aliqnac else aliqimp end) /100)),0) 
from itnfsaicad i, produtocad p, complementoproduto d, tabelaIbpt t 
where i.codpro = p.codpro and p.codpro = d.codpro 
and stuff(stuff(p.codigoncm,5,1,''),7,1,'') = t.codigo 
and p.codpro = 46220 
and i.numord = 1201016
and p.extipi = t.ex 

select ISNULL((sum(i.quant * i.preco * ( case when d.origem in ('0','3','4','5') then t.aliqnac else aliqimp end) /100)),0) 
from itnfsaicad i, produtocad p, complementoproduto d, tabelaIbpt t 
where i.codpro = p.codpro and p.codpro = d.codpro 
and stuff(stuff(p.codigoncm,5,1,''),7,1,'') = t.codigo 
and p.codpro = 55750 
and i.numord = 1201016
and p.extipi = t.ex 

select ISNULL((sum(i.quant * i.preco * ( case when d.origem in ('0','3','4','5') then t.aliqnac else aliqimp end) /100)),0) 
from itnfsaicad i, produtocad p, complementoproduto d, tabelaIbpt t 
where i.codpro = p.codpro and p.codpro = d.codpro 
and stuff(stuff(p.codigoncm,5,1,''),7,1,'') = t.codigo 
and p.codpro = 59453 
and i.numord = 1210225 
and p.extipi = t.ex 

UPDATE PRODUTOCAD SET ExtIPI = '' 