--Consultas no banco da Coral
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Relacionamentos:
-- Entre o Banco da Coral com o Banco DBENTER
-----------------------------------------------
Banco Coral					| DBENTER
----------------------------|------------------------------------------
Linha.Id_Linha				= COMPONENTEFORMULA.CODCOMPONENTEEXTERNO
Corantes.Id_Corantes		= COMPONENTEFORMULA.CODCOMPONENTEEXTERNO
Bases.Id_Base				= COMPONENTEFORMULA.CODCOMPONENTEEXTERNO
Embalagens.Id_Embalagens	= COMPONENTEFORMULA.CODCOMPONENTEEXTERNO
CoresPadrao.Id_Cor			= COMPONENTEFORMULA.CODCOMPONENTEEXTERNO
-----------------------------------------------------------------------
Select * from Linha						-- Corresponde aos Produtos Finais
select * from Corantes					-- Corresponde aos Corantes
select * from Bases						-- Corresponde as Bases
select * from CoresPadrao				-- Corresponde as Cores
Select * from Embalagens				-- Corresponde as Embalagens
Select * from frmPadrao where Tag = 'E' -- Corresponde as formulas relacionadas ao corante Vermelho Antigo
Select * from frmPadrao where Tag = 'V' -- Corresponde as formulas relacionadas ao corante Vermelho Novo

-- Composição da Coluna Formula da tabela frmPadrao
----------------------------------------------------
-- Esta coluna é separa por vígulas, O código do corante e sua quantidate fica assim: 
-- 12,95.40 ou seja o Corante é 12(Vermelho Intenso) e sua quantidate é 95.40.
-- Então em uma Formula assim: 12,95.4,9,254.18,4,35.06,7,56.14 temos:
-- 12,95.4,		-- Corante 12 e quantidate 95.40 na medida da coral
-- 9,254.18,	-- Corante  9 e quantidate 254.18 na medida da coral
-- 4,35,06,		-- Corante  4 e quantidate 35,06 na medida da coral
-- 7,56,14,		-- Corante  7 e quantidate 56,14 na medida da coral
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Entre o Banco da Coral com o Banco DBENTER
-- OID SISTEMATINTOMETRICO = 31780
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
select * from COMPONENTEFORMULA where SISTEMATINTOMETRICO = '31780' and TIPOCOMPONENTE = 'C' 
select * from COMPONENTEFORMULA where SISTEMATINTOMETRICO = '31780' and TIPOCOMPONENTE = 'P' and NOMECOMPONENTE like '%Informa a Linha para analisar%' 
select * from COMPONENTEFORMULA where SISTEMATINTOMETRICO = '31780' and TIPOCOMPONENTE = 'B' and NOMECOMPONENTE like '%Informa a Linha para analisar%' 
select * from COMPONENTEFORMULA where SISTEMATINTOMETRICO = '31780' and TIPOCOMPONENTE = 'T' and NOMECOMPONENTE like '%Informa a Linha para analisar%' 

-- Listar cadastros ANTIGOS feitos pelo usuário
select DESCRICAOLONGA,* from COMPLEMENTOPRODUTO where SISTEMATINTOMETRICO = '31780' and TIPOCOMPONENTE = 'C' and CODCOMPONENTE = 'Informar CodComponente'
select DESCRICAOLONGA,* from COMPLEMENTOPRODUTO where SISTEMATINTOMETRICO = '31780' and TIPOCOMPONENTE = 'P' and CODCOMPONENTE = 'Informar CodComponente'
select DESCRICAOLONGA,* from COMPLEMENTOPRODUTO where SISTEMATINTOMETRICO = '31780' and TIPOCOMPONENTE = 'B' and CODCOMPONENTE = 'Informar CodComponente'
select DESCRICAOLONGA,* from COMPLEMENTOPRODUTO where SISTEMATINTOMETRICO = '31780' and TIPOCOMPONENTE = 'T' and CODCOMPONENTE = 'Informar CodComponente'

