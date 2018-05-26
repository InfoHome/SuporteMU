SELECT
	(SELECT DESCR FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,2)) +' - '+ 
		(SELECT clasprod FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,2))			AS Nivel_1,

	(SELECT DESCR FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,4)) +' - '+ 
		(SELECT clasprod FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,4))			AS Nivel_2,

	(SELECT DESCR FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,6)) +' - '+ 
		(SELECT clasprod FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,6))			AS Nivel_3,

	(SELECT DESCR FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,8)) +' - '+ 
		(SELECT clasprod FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,8))			AS Nivel_4,

	(SELECT DESCR FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,10)) +' - '+ 
		(SELECT clasprod FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,10))			AS Nivel_5,

	(SELECT DESCR FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,12)) +' - '+ 
		(SELECT clasprod FROM CLASSIFCAD WHERE clasprod = SUBSTRING(p.clasprod,1,12))			AS Nivel_6,

	P.CLASPROD +' - '+ P.CODPRO, 
	P.DESCR 
	FROM PRODUTOCAD P 
	JOIN CLASSIFCAD C ON C.clasprod = p.clasprod
	ORDER BY 1,2,3,8


	SELECT * FROM CLASSIFCAD WHERE DESCR LIKE '%HIDRA%'
	SELECT * FROM PRODUTOCAD WHERE DESCR LIKE '%CAL%' ORDER BY CLASPROD
	
	

	
	
	-- ARGAMASSAS ------------------------------------------------------ 210
	SELECT 'ARGAMASSA', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,6) = '050190' -- ARGAMASSAS E REJUNTES
	 

	-- COBERTURAS ------------------------------------------------------
	SELECT 'COBERTURA', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) = '0605' -- 
	
	-- COLANTES ------------------------------------------------------
	SELECT 'COLANTE', * 
	FROM CLASSIFCAD 
	WHERE 
		(LEFT(CLASPROD,6) =  '060101'			-- CIMENTOS    
		   OR LEFT(CLASPROD,8) = '02020403'			-- HIDRACAL 5KG    
	              
		 )

	-- FERRAGEMS ------------------------------------------------------
	SELECT 'FERRAGEM', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) = '0602' --   

	-- FERRAMENTAS ------------------------------------------------------ 1434
	SELECT 'FERRAMENTA', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,2) = '04' --   


	-- HIDRAÚLICO ------------------------------------------------------ 2752
	SELECT 'HIDRAÚLICO', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,2) IN ('01', -- MATERIAL HIDRAULICO   
								'0309' -- BOMBAS
								)

	
	-- ILUMINACAO ------------------------------------------------------ 304 + 811
	SELECT 'ILUMINACAO', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) IN ('0301', -- LAMPADAS 
								'0305'	-- LUMINARIAS, PLAFONS, GLOB
								)
	
	-- IPERMEBEALIZAÇÃO ------------------------------------------------------
	SELECT 'IPERMEBEALIZACAO', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) IN ('') --   


	-- LOUÇAS ------------------------------------------------------
	SELECT 'LOUCA', * 
	FROM CLASSIFCAD 
	WHERE 
	LEFT(CLASPROD,6) IN ('050204',  -- ASSENTO
						'050201', 	-- JOGOS DE VASO            
						'050202',	-- PIAS E TANQUES           
						'050205'	--BANHEIRAS                
						)
	   
	-- MATERIAL ELETRICO ------------------------------------------------------ 987
	SELECT 'MAT_ELETRICO', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,2) = '03' -- MATERIAL ELETRICO   
					and clasprod not like '0301%'
					and clasprod not like '0305%'
					and clasprod not like '0309%' -- BOMBAS

	-- MATERIAL BÁSICO ------------------------------------------------------
	SELECT 'MAT_BASICO', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) IN ('0601', -- PRODUTOS CIMENTICIOS     
								'0603',-- BRITAS E AREIAS    
								'0606',-- MAT.P/ FUNDAÇÃO E BASICO          
								'0604') --TIJOLOS                  
		and clasprod not like '060101%' 
	
	-- METAL ------------------------------------------------------
	SELECT 'METAL', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) IN ('') --  

	-- MOVEIS ------------------------------------------------------
	SELECT 'MOVEIS', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,6) IN ('050203') -- BANHEIRO E COZINHA        		

	-- ORGANIZAÇÃO E DECORAÇÃO ------------------------------------------------------
	SELECT 'ORG_DECORACAO', * 
	FROM CLASSIFCAD 
	WHERE (LEFT(CLASPROD,6) IN ('050206')
				OR LEFT(CLASPROD,4) IN ('0504','0505') --  DIVERSOS                                
				)

	-- PINTURA ------------------------------------------------------ 1839
	SELECT 'PINTURA', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,2) IN ('02') --   TINTA 

	-- PISOS E RESVESTIMENTOS ------------------------------------------------------ 3610
	SELECT 'PISO_REVESTIMENTO', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) = '0501'  
		AND clasprod not like '050190%'

	-- PORTAS E JANELAS ------------------------------------------------------
	SELECT 'PORTA_JANELA', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,4) IN ('0503') --  PORTAS E JANELAS         

	-- INATIVOS/OUTROS ------------------------------------------------------
	SELECT 'INATIVO', * 
	FROM CLASSIFCAD 
	WHERE LEFT(CLASPROD,6) = '90' -- INATIVOS
	