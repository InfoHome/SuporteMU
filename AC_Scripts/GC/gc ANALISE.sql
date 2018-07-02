/*
	select * from PRODUTOCAD-- where 
		--clasprod not like '01%'
		--and clasprod not like '02%'
		--and clasprod not like '03%'
		--and clasprod not like '04%'
		--and clasprod not like '05%'
		--and clasprod not like '90%'
	order by descr
	--clasprod
*/

declare @classe varchar(max)
set @classe = '020205'
select * from CLASSIFCAD where clasprod = @classe
select * from PRODUTOCAD WHERE clasprod like @classe +'%'
	--and clasprod not like '0504%'
	--and clasprod not like '0505%'
	--and clasprod not like '050201%'
	--and clasprod not like '050202%'
	--and clasprod not like '050190%' 
	--and clasprod not like '050203%' 
	--and clasprod not like '050204%' 
	--and clasprod not like '0501%' 
	--and clasprod not like '0503%' 
	--and clasprod not like '050205%' 
	--and clasprod not like '050206%' 
	ORDER BY DESCR

