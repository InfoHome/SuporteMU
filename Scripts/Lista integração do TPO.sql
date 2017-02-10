----------------------------------------------------------------------------------------------------------------
-- LISTA INTEGRA��O DOS TPOS 
-- CONFIGURA��O DA INTEGRA��O TPO 
-- OBS.: O DOM�NIO QUE N�O TIVER PELO MEMOS 1 TPO SETADO N�O � APRESENTADO
----------------------------------------------------------------------------------------------------------------
select    C.OID AS OIDTPO,
          B.OID AS OIDTPOINTEGRACAO,
          c.nome as TPO,
          C.CODIGO AS CODIGO,
          '<b>DOMINIO:',d.nome as DOMINIO,'</b>',
          'PAR�METRO: ',b.QUESTAO AS DESCRICAO,' = ',
             CASE
				WHEN a.VALOR = '37074' THEN 'Nenhuma'
				WHEN a.VALOR = '37076' THEN 'Exige conferencia de c�digo de barras'
				WHEN a.VALOR = '37078' THEN 'Exige conferencia de c�digo de barras conforme cadastro de produtos'
				WHEN a.VALOR = '37080' THEN 'Exige conferencia de numero de s�rie'
				WHEN a.VALOR = '37082' THEN 'Exige confirma��o'
				WHEN a.VALOR = '37227' THEN 'Exige conferencia de n�mero de s�rie e c�digo de barras'
				WHEN a.VALOR = '37228' THEN 'Exige confer�ncia de n�mero de s�rie e c�digo de barras conforme cadastro de produtos'
				ELSE a.VALOR 
			END AS VALOR
from TPOINTERFERENCIA_R a 
             INNER join TPOINTEGRACAO_R b on a.RTPOINTEGRACAO = b.OID 
             INNER join TPO_R c on a.RTPO = c.oid
             INNER join item d on d.oid = b.RDOMINIO 
where C.HIERARQUIANUMERO = '10010109' -- Informar o TPO da Nota
order by d.nome,b.QUESTAO


-- LOGS DE ALTERA��ES NO TPO
----------------------------------------
SELECT * FROM PARAMETROSTPOLOG WHERE RTPO = 2232966
SELECT * FROM TPOINTEGRACAO_R WHERE OID = 16130
SELECT * FROM TPOINTEGRACAO_R WHERE OID IN (SELECT RTPOINTEGRACAO FROM PARAMETROSTPOLOG WHERE RTPO = 2232966)

