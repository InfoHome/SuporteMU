SELECT 
	Distinct
	pro.CODIGONCM, 
	forn.NOME,
	'' as [Código Cest]
FROM 
	COMPLEMENTOPRODUTO cp 
	join PRODUTOCAD pro on cp.CODPRO = pro.codpro
	join fornecedor_r forn on pro.codfor = forn.oid
WHERE CODIGOCEST = ''



