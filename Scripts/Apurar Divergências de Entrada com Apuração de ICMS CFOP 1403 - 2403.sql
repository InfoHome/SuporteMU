--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Tratamento PA 317862 (Padovani)

-- Busca notas de entradas lançadas pelo sistema de usuário que estão com os seguintes campos diverfências:
-- OBSBaseSubsTri <> BasesTrib
-- OBSValSubsTri <> VasSubsTri
-- OBSValorIPI <> VrIPI
-- Calculo:
-- BaseICM + BaseICM2 + BaseICM3 + BaseICM4 + BaseICM5 + ValsemICM + OutrICM  + BaseExcedente + OBSValSubstri + OBSValorIPI
-- sum(BaseICM) + sum(BaseICM2) + sum(BaseICM3) + sum(BaseICM4) + sum(BaseICM5) + sum(ValsemICM) + sum(OutrICM)  + sum(BaseExcedente) + sum(OBSValSubstri) + sum(OBSValorIPI)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select c.*
--sum(BaseICM) + sum(BaseICM2) + sum(BaseICM3) + sum(BaseICM4) + sum(BaseICM5) + sum(ValsemICM) + sum(OutrICM)  + sum(BaseExcedente) + sum(OBSValSubstri) + sum(OBSValorIPI)
from cfoentrcad c join COMPLEMENTONFENTRA cp on c.numord = cp.numord 
	and cp.FLAGCRIACAO = 0 --Notas Lançadas no Sistema de usuário
	--and cp.FLAGCRIACAO <> 0 --Notas Lançadas pelo MasterEn
where c.numord in (SELECT nfe.numord FROM NFENTRACAD NFE, CADACFOCAD CFO,  CFOENTRCAD CFE  
						WHERE CFE.NUMORD = NFE.NUMORD 
						AND CFE.CFO=CFO.CFO  AND  year(NFE.dtcheg) = 2017  AND  month(NFE.dtcheg)  =  5
						AND  NFE.atualiz = 1 AND CFE.CFO in ('1403','2403')	AND NFE.LIF = 1  
						AND NFE.DTCANCEL IS NULL AND NFE.FILIAL IN ('11')
						) 
and c.cfo in ('1403','2403') 
and (OBSVALORIPI <> vripi 	or OBSVALSUBSTRI <> valsubstri 	or valsemipi <> valsubstri or OutrICM <= 0)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------		
	
-- Ajuste notas lançadas pelo Sistema de usuário
/*
update CFOENTRCAD set 
					OBSBASESUBSTRI = basestrib,
					OBSVALSUBSTRI = valsubstri,
					OBSVALORIPI = vripi
where cfo = 1403 and numord in (Informe os numords para ajustar)

update cfoentrcad set outricm = outricm - (vripi+valsubstri) where cfo = '1403' and  numord in (Informe os numords para ajustar) 

*** Verifique também se tem alguma nota com o CFOP 1403 e 2403 com o campo outras ICMS como valor Zerado.
*/


Filtros dos Relatórios:
--------------------------------------------------------------------------
Filtro -> Registro de Apuração do ICMS
<Filial = (Igual) [11]
Mês/Ano Referência = (Igual) [05/17]
Saldo Anterior = (Igual) [0]
Oficial (S/N) = (Igual) [S]
Imprime NF Servico (S/N) = (Igual) [S]
Imprime IPI em Out. ICMS? = (Igual) [N]
Recalcular Saldo a partir de <= (Menor ou Igual) [       ]
Recalcular Saldo Anterior? = (Igual) [N]
Imprime Cheque Moradia? = (Igual) [N]
Imprimir apuração de substituição? = (Igual) [N]
Imprimir resumo da apuração do imposto? = (Igual) [S]
Tratar margem para encadernação = (Igual) [N]
Imprimir número do livro (S/N)? = (Igual) [S]
Imprimir descrição do CFOP? = (Igual) [N]
Considera notas fiscais de simples remessa (S/N)? = (Igual) [S]

-----------------------------------------------------------------------------------------------------------------------
Filtro -> Registro de Entradas ...... [FILTROS 1/2]
<Local de Entrada = (Igual) [11]
Data Inicial >= (Maior ou Igual) [01/05/17]
Data Final <= (Menor ou Igual) [31/05/17]
Oficial (S/N) = (Igual) [S]
Imp UF da Nota (S/N) = (Igual) [N]
Modelo (1/2/3/4/5/6/7/8/9/10/11) = (Igual) [9]
Impr. Totais (S/N) = (Igual) [S]
Impr. NF Canceladas? = (Igual) [N]
Data Emissão Inicial >= (Maior ou Igual) [  /  /  ]
Data Emissão Final <= (Menor ou Igual) [  /  /  ]
CFOP = (Igual) [1403]
Emite Nome da Filial ? = (Igual) [N]
Serie da Nota Fiscal = (Igual) [   ]
Imprimir Resumo de ICMS por CFOP? = (Igual) [S]
Imprime IPI em Out. ICMS? = (Igual) [N]
Imprime Observação da Nota (S/N)? = (Igual) [S]
Tratar margem para encadernação = (Igual) [N]
Imprimir número do livro (S/N)? = (Igual) [S]
Listar dados dos emitentes? = (Igual) [N]
Ordenar por numero da nota (S/N) = (Igual) [N]
Imprime Observação de IPI/ST - A[Ipi/St].I[I].S[St].N? = (Igual) [A]
Imprime resumo por estado-Modelo9? = (Igual) [N]


Filtro -> Registro de Entradas ...... [FILTROS 2/2]
<Imprimir NF-e cancelada com valor zerado (S/N)? = (Igual) [N]