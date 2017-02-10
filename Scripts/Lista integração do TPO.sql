----------------------------------------------------------------------------------------------------------------
-- LISTA INTEGRAÇÃO DOS TPOS 
-- CONFIGURAÇÃO DA INTEGRAÇÃO TPO 
-- OBS.: O DOMÍNIO QUE NÃO TIVER PELO MEMOS 1 TPO SETADO NÃO É APRESENTADO
----------------------------------------------------------------------------------------------------------------
select    C.OID AS OIDTPO,
          B.OID AS OIDTPOINTEGRACAO,
          c.nome as TPO,
          C.CODIGO AS CODIGO,
          '<b>DOMINIO:',d.nome as DOMINIO,'</b>',
          'PARÂMETRO: ',b.QUESTAO AS DESCRICAO,' = ',
             CASE
				WHEN a.VALOR = '37074' THEN 'Nenhuma'
				WHEN a.VALOR = '37076' THEN 'Exige conferencia de código de barras'
				WHEN a.VALOR = '37078' THEN 'Exige conferencia de código de barras conforme cadastro de produtos'
				WHEN a.VALOR = '37080' THEN 'Exige conferencia de numero de série'
				WHEN a.VALOR = '37082' THEN 'Exige confirmação'
				WHEN a.VALOR = '37227' THEN 'Exige conferencia de número de série e código de barras'
				WHEN a.VALOR = '37228' THEN 'Exige conferência de número de série e código de barras conforme cadastro de produtos'
				ELSE a.VALOR 
			END AS VALOR
from TPOINTERFERENCIA_R a 
             INNER join TPOINTEGRACAO_R b on a.RTPOINTEGRACAO = b.OID 
             INNER join TPO_R c on a.RTPO = c.oid
             INNER join item d on d.oid = b.RDOMINIO 
where C.HIERARQUIANUMERO = '10010109' -- Informar o TPO da Nota
order by d.nome,b.QUESTAO


-- LOGS DE ALTERAÇÕES NO TPO
----------------------------------------
SELECT * FROM PARAMETROSTPOLOG WHERE RTPO = 2232966
SELECT * FROM TPOINTEGRACAO_R WHERE OID = 16130
SELECT * FROM TPOINTEGRACAO_R WHERE OID IN (SELECT RTPOINTEGRACAO FROM PARAMETROSTPOLOG WHERE RTPO = 2232966)

