	DROP TABLE AC_GC_EXT_CLASPROD
	GO

	-- ARGAMASSAS ------------------------------------------------------ 210
	SELECT 
		'ARGAMASSA' as Descr, CLASPROD 	
		into AC_GC_EXT_CLASPROD
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,6) = '050190' -- ARGAMASSAS E REJUNTES		-- 33
	
	-- COBERTURAS ------------------------------------------------------
	UNION ALL SELECT 
	'COBERTURA', CLASPROD 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) in ('0605',								-- 122
								'0606' -- MADEIRAS					-- 60
								)
	-- COLANTES ------------------------------------------------------
	UNION ALL SELECT 
	'COLANTE', CLASPROD 
	FROM CLASSIFCAD 
	WHERE 
		(LEFT(CLASPROD,6) =  '060101'			-- CIMENTOS				-- 21
		   OR LEFT(CLASPROD,8) = '02020403'			-- HIDRACAL 5KG		--5 
	              
		 )

	-- FERRAGEMS ------------------------------------------------------
	UNION ALL SELECT 
	'FERRAGEM', CLASPROD 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) = '0602' --  FERRAGENS						-- 18

	-- METAIS ------------------------------------------------------
	UNION ALL SELECT 'METAIS', CLASPROD
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) IN ('0103') -- METAIS    

	-- FERRAMENTAS ------------------------------------------------------ 1434
	UNION ALL SELECT 'FERRAMENTA', CLASPROD 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,2) = '04' --  MAT.AGRICOLA/PEDREIRO				-- 492    


	-- HIDRAÚLICO ------------------------------------------------------ 
	UNION ALL SELECT 'HIDRAÚLICO', CLASPROD 
	FROM CLASSIFCAD 
	WHERE (LEFT(CLASPROD,2) IN ('01') -- MATERIAL HIDRAULICO		-- 756  
			AND CLASPROD NOT LIKE ('0103%')
			OR LEFT(CLASPROD,4) IN	('0309') -- BOMBAS				--   5
			)					

	
	-- ILUMINACAO ------------------------------------------------------ 304 + 811
	UNION ALL SELECT 'ILUMINACAO', CLASPROD 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) IN ('0301', -- LAMPADAS							-- 59
								'0305'	-- LUMINARIAS, PLAFONS, GLOB		--270
								)
	
	--IPERMEBEALIZAÇÃO ------------------------------------------------------
	UNION ALL SELECT 'IMPERMEABELIZACAO', CLASPROD 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,6) IN ('020205') --   IMPERMEABILIZANTE        


	-- LOUÇAS ------------------------------------------------------
	UNION ALL SELECT 'LOUCA', CLASPROD
	FROM CLASSIFCAD 
	WHERE 
	LEFT(CLASPROD,6) IN (
						'050204',  --  ASSENTO					-- 55
						'050201', 	-- JOGOS DE VASO			-- 112  
						'050202',	-- PIAS E TANQUES           -- 85
						'050205'	-- BANHEIRAS                -- 21
						)									-- Total 273
	   
	-- MATERIAL ELETRICO ------------------------------------------------------ 987
	UNION ALL SELECT 'MATERIAL_ELETRICO', CLASPROD 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,2) = '03' -- MATERIAL ELETRICO		       			-- 519
					and clasprod not like '0301%' -- LAMPADAS
					and clasprod not like '0305%' -- LUMINARIAS, PLAFONS, GLOB
					and clasprod not like '0309%' -- BOMBAS

	-- MATERIAL BÁSICO ------------------------------------------------------
	UNION ALL SELECT 'MATERIAL_BASICO', CLASPROD
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) IN ('0601', -- PRODUTOS CIMENTICIOS      -- 6  
								'0603',-- BRITAS E AREIAS			-- 11
								'0604'								-- 19
								) --TIJOLOS                  
		and clasprod not like '060101%' 
	
	-- MOVEIS ------------------------------------------------------
	UNION ALL SELECT 'MOVEIS', CLASPROD
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,6) IN ('050203') -- ARMARIOS E GABINETES  -- 190      		

	-- ORGANIZAÇÃO E DECORAÇÃO ------------------------------------------------------
	UNION ALL SELECT 'ORG_DECORACAO', CLASPROD 
	FROM CLASSIFCAD 
	WHERE (
		LEFT(CLASPROD,6) IN ('050206')					-- 8
				OR LEFT(CLASPROD,4) IN ('0504',			-- 147		
										'0505'			--  DIVERSOS -- 5            
										)				-- total 160
				)

	-- PINTURA ------------------------------------------------------ 1839
	UNION ALL SELECT 'PINTURA', CLASPROD 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,2) IN ('02')			--    504
		AND CLASPROD NOT LIKE '02020403%'
		AND CLASPROD NOT LIKE '020205%'

	
	-- PISOS E RESVESTIMENTOS ------------------------------------------------------ 3610
	UNION ALL SELECT 'PISO_REVESTIMENTO', CLASPROD
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) = '0501'				-- 309
		AND clasprod not like '050190%'
	
	-- PORTAS E JANELAS ------------------------------------------------------
	UNION ALL SELECT 'PORTA_JANELA', CLASPROD 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) IN ('0503') --  PORTAS E JANELAS       --  234
	
	-- INATIVOS/OUTROS ------------------------------------------------------
	UNION ALL SELECT 'INATIVO', CLASPROD 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,2) IN ('90',       -- OUTROS PRODUTOS   87
							'99'			-- INATIVOS		-- 6
							) 
							
	-- INATIVOS/OUTROS ------------------------------------------------------
	UNION ALL SELECT 'INDETERMINADO', CLASPROD 
	FROM CLASSIFCAD 
	WHERE 
		CLASPROD = '05'
		OR CLASPROD = '06' 
			OR CLASPROD = '0502'

ORDER BY 2

------------------------------------------------------------------------------------------------------

SELECT 
	PROD.CLASPROD,
	EXT_CLAS.DESCR, 
	PROD.* 
	FROM PRODUTOCAD PROD 
		JOIN AC_GC_EXT_CLASPROD EXT_CLAS ON PROD.clasprod = EXT_CLAS.clasprod
--where EXT_CLAS.Descr = 'INDETERMINADO'
ORDER BY EXT_CLAS.DESCR, PROD.DESCR







