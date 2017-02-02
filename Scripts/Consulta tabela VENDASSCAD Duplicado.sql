---------------------------------------------------------------------------------------------------
-- Script para levantar VENDASSCAD DUPLICADO
---------------------------------------------------------------------------------------------------
select numped, count(numped)as REPETICOES 
from vendasscad 
group by numped having count(numped) > 1 
order by numped desc