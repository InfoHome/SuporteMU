--SELECT
--	(SELECT DESCR FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,2)) +' - '+ 		(SELECT clasprod FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,2))			AS Nivel_1,
--	(SELECT DESCR FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,4)) +' - '+ 		(SELECT clasprod FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,4))			AS Nivel_2,
--	(SELECT DESCR FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,6)) +' - '+ 		(SELECT clasprod FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,6))			AS Nivel_3,
--	(SELECT DESCR FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,8)) +' - '+ 		(SELECT clasprod FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,8))			AS Nivel_4,
--	(SELECT DESCR FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,10)) +' - '+		(SELECT clasprod FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,10))			AS Nivel_5,
--	(SELECT DESCR FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,12)) +' - '+		(SELECT clasprod FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,12))			AS Nivel_6,
--	P.CLASPROD +' - '+ P.CODPRO, 
--	P.DESCR 
--FROM PRODUTOCAD P 
--JOIN CLASSIFCAD C ON C.clasprod = p.clasprod
--ORDER BY 1,2,3,8



	
	
	-- ARGAMASSAS ------------------------------------------------------ 210
	SELECT 'ARGAMASSA', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,6) = '050190' -- ARGAMASSAS E REJUNTES		-- 33
	 

	-- COBERTURAS ------------------------------------------------------
	SELECT 'COBERTURA', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) in ('0605',					-- 122
								'0606' -- MADEIRAS			-- 60
								)
	-- COLANTES ------------------------------------------------------
	SELECT 'COLANTE', * 
	FROM CLASSIFCAD 
	WHERE 
		(LEFT(CLASPROD,6) =  '060101'			-- CIMENTOS      -- 21
		   OR LEFT(CLASPROD,8) = '02020403'			-- HIDRACAL 5KG   --5 
	              
		 )

	-- FERRAGEMS ------------------------------------------------------
	SELECT 'FERRAGEM', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) = '0602' --  FERRAGENS			-- 18

	-- FERRAMENTAS ------------------------------------------------------ 1434
	SELECT 'FERRAMENTA', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,2) = '04' --  MAT.AGRICOLA/PEDREIRO			 -- 492    


	-- * HIDRA�LICO ------------------------------------------------------ 
	SELECT 'HIDRA�LICO', * 
	FROM CLASSIFCAD 
	WHERE (LEFT(CLASPROD,2) IN ('01') -- MATERIAL HIDRAULICO		-- 756  
			OR LEFT(CLASPROD,4) IN	('0309') -- BOMBAS				--   5
			)					

	
	-- ILUMINACAO ------------------------------------------------------ 304 + 811
	SELECT 'ILUMINACAO', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) IN ('0301', -- LAMPADAS							-- 59
								'0305'	-- LUMINARIAS, PLAFONS, GLOB		--270
								)
	
	-- IPERMEBEALIZA��O ------------------------------------------------------
	--SELECT 'IPERMEBEALIZACAO', * 
	--FROM CLASSIFCAD 
	--WHERE LEFT(CLASPROD,4) IN ('') --   


	-- LOU�AS ------------------------------------------------------
	SELECT 'LOUCA', * 
	FROM CLASSIFCAD 
	WHERE 
	LEFT(CLASPROD,6) IN (
						'050204',  --  ASSENTO					-- 55
						'050201', 	-- JOGOS DE VASO			-- 112  
						'050202',	-- PIAS E TANQUES           -- 85
						'050205'	-- BANHEIRAS                -- 21
						)									-- Total 273
	   
	-- MATERIAL ELETRICO ------------------------------------------------------ 987
	SELECT 'MAT_ELETRICO', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,2) = '03' -- MATERIAL ELETRICO		       			-- 519
					and clasprod not like '0301%' -- LAMPADAS
					and clasprod not like '0305%' -- LUMINARIAS, PLAFONS, GLOB
					and clasprod not like '0309%' -- BOMBAS

	-- MATERIAL B�SICO ------------------------------------------------------
	SELECT 'MAT_BASICO', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) IN ('0601', -- PRODUTOS CIMENTICIOS      -- 6  
								'0603',-- BRITAS E AREIAS			-- 11
								'0604'								-- 19
								) --TIJOLOS                  
		and clasprod not like '060101%' 
	
	-- MOVEIS ------------------------------------------------------
	SELECT 'MOVEIS', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,6) IN ('050203') -- ARMARIOS E GABINETES  -- 190      		

	-- ORGANIZA��O E DECORA��O ------------------------------------------------------
	SELECT 'ORG_DECORACAO', * 
	FROM CLASSIFCAD 
	WHERE (
		LEFT(CLASPROD,6) IN ('050206')					-- 8
				OR LEFT(CLASPROD,4) IN ('0504',			-- 147		
										'0505'			--  DIVERSOS -- 5            
										)				-- total 160
				)

	-- * PINTURA ------------------------------------------------------ 1839
	SELECT 'PINTURA', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,2) IN ('02')			--    504
		AND CLASPROD NOT LIKE '02020403%'

	
	-- PISOS E RESVESTIMENTOS ------------------------------------------------------ 3610
	SELECT 'PISO_REVESTIMENTO', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) = '0501'				-- 309
		AND clasprod not like '050190%'
	
	-- PORTAS E JANELAS ------------------------------------------------------
	SELECT 'PORTA_JANELA', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) IN ('0503') --  PORTAS E JANELAS       --  234
	
	-- INATIVOS/OUTROS ------------------------------------------------------
	SELECT 'INATIVO', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,2) IN ('90',       -- OUTROS PRODUTOS   87
							'99'			-- INATIVOS		-- 6
							) 
							
	-- INATIVOS/OUTROS ------------------------------------------------------
	SELECT 'INDETERMINADO', * 
	FROM CLASSIFCAD 
	WHERE (LEFT(CLASPROD,2) IN ('05','06') -- INATIVOS
			OR LEFT(CLASPROD,4) IN ('0502'))
		and clasprod not like '050190%'
		and clasprod not like '050204%'
		and clasprod not like '050201%'
		and clasprod not like '050202%'
		and clasprod not like '050205%' 
		and clasprod not like '050203%' 
		and clasprod not like '050206%' 
		and clasprod not like '0504%' 
		and clasprod not like '0505%' 
		and clasprod not like '0501%' 
		and clasprod not like '0503%' 
		and clasprod not like '0605%'
		and clasprod not like '0606%'
		and clasprod not like '060101%'
		and clasprod not like '0602%'
		and clasprod not like '0601%' 
		and clasprod not like '0603%' 
		and clasprod not like '0604%' 

	