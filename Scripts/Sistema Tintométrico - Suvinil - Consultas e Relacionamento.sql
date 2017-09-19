--Informações sobre a importação: o resultado do select abaixo tem que retornar 8
-----------------------------------------------------------------------------------------
--Esse select é executado no banco da SuviniL
Select count(*) QtdeViews from SysObjects where name in 
('V_TWEB_EMBALAGENS', 
'V_TWEB_CORES_COLORANTES', 
'V_TWEB_TIPOS_BASES', 
'V_TWEB_PRODUTOS', 
'V_TWEB_COLORANTES', 
'V_TWEB_GRUPOS', 
'V_TWEB_BASES', 
'V_TWEB_CORES') 


--Consultas no banco da Suvinil
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
Select * from V_TWEB_EMBALAGENS				
select * from V_TWEB_CORES_COLORANTES			
select * from V_TWEB_TIPOS_BASES			
select * from V_TWEB_PRODUTOS				
Select * from V_TWEB_COLORANTES				
Select * from V_TWEB_GRUPOS					
Select * from V_TWEB_BASES					
Select * from V_TWEB_CORES


-- Relacionamentos:
-- Entre o Banco da Suvinil com o Banco DBENTER
---------------------------------------------------------------------------------------------------
Banco Suvinil					    					| DBENTER
--------------------------------------------------------|------------------------------------------
[V_TWEB_EMBALAGENS].[COD_EMBALAGEM]	 					= COMPONENTEFORMULA.CODCOMPONENTEEXTERNO
[V_TWEB_CORES_COLORANTES].[COD_COLORANTE]				= COMPONENTEFORMULA.CODCOMPONENTEEXTERNO
[V_TWEB_TIPOS_BASES].[COD_BASE]							= COMPONENTEFORMULA.CODCOMPONENTEEXTERNO
[V_TWEB_PRODUTOS].[COD_PRODUTO]							= COMPONENTEFORMULA.CODCOMPONENTEEXTERNO
[V_TWEB_COLORANTES].[COD_COLORANTE] 					= COMPONENTEFORMULA.CODCOMPONENTEEXTERNO
[V_TWEB_GRUPOS].[COD_GRUPO]								= COMPONENTEFORMULA.CODCOMPONENTEEXTERNO
[V_TWEB_BASES].[COD_PRODUTO],[COD_BASE],[COD_EMBALAGEM]	= COMPONENTEFORMULA.CODCOMPONENTEEXTERNO
[V_TWEB_CORES].[COD_COR]								= COMPONENTEFORMULA.CODCOMPONENTEEXTERNO

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Entre o Banco da Suvinil com o Banco DBENTER
-- OID SISTEMATINTOMETRICO = 31983
-------------------------------------------------
Produto			|TipoComponente	| Relacionamento
-------------------------------------------------------------------------------------------------------------
Bases			|B				|COMPONENTEFORMULA.CODCOMPONETE = COMPLEMENTOPRODUTO.CODCOMPONETE
Corantes		|C				|COMPONENTEFORMULA.CODCOMPONETE = COMPLEMENTOPRODUTO.CODCOMPONETE
Embalagens		|E				|COMPONENTEFORMULA.CODCOMPONETE = COMPLEMENTOPRODUTO.CODCOMPONETE
Produto Final	|P				|COMPONENTEFORMULA.CODCOMPONETE = COMPLEMENTOPRODUTO.CODCOMPONETE
Cores			|T				|COMPONENTEFORMULA.CODCOMPONETE = COMPLEMENTOPRODUTO.CODCOMPONETE
-------------------------------------------------------------------------------------------------------------
-- Listar nossos cadastros da importação
select * from COMPONENTEFORMULA where SISTEMATINTOMETRICO = '31983' and TIPOCOMPONENTE = 'C' 
select * from COMPONENTEFORMULA where SISTEMATINTOMETRICO = '31983' and TIPOCOMPONENTE = 'P' and NOMECOMPONENTE like '%Informa a Linha para analisar%' 
select * from COMPONENTEFORMULA where SISTEMATINTOMETRICO = '31983' and TIPOCOMPONENTE = 'B' and NOMECOMPONENTE like '%Informa a Linha para analisar%' 
select * from COMPONENTEFORMULA where SISTEMATINTOMETRICO = '31983' and TIPOCOMPONENTE = 'T' and NOMECOMPONENTE like '%Informa a Linha para analisar%' 


