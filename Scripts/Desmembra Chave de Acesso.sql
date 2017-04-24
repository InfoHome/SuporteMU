-------------------------------------------------------------------------------------------------------
--Desmembra Chave de Acesso
-------------------------------------------------------------------------------------------------------

declare @chave varchar(44)

--Informe abaixo entre aspas simples somente números da chave de acesso.
set @chave = '35170412619240000239570010000011131843310810'  

select 
	 substring(@chave,1,2)  as [Cod_UF] 			-- cUF 			
	,substring(@chave,3,4)  as [Abo] 				-- AAMM
	,substring(@chave,7,14) as [CNPJ] 				-- CNPJ
	,substring(@chave,21,2) as [Modelo] 			-- MOD
	,substring(@chave,23,3) as [Serie] 				-- Serie
	,substring(@chave,26,9) as [Numero] 			-- nnf
	,substring(@chave,35,1) as [Forma_Emissao] 		-- tpEmis
	,substring(@chave,36,8) as [Cod_Numérico] 		-- cNF
	,substring(@chave,44,1) as [Didigo_Verificador]	-- cDV
