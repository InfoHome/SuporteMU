----------------------------------------------------------------------------------------------------------------------------------------------------
-- Script para extrair a tabela SUBSTENTRADA (Substituição Tributária)
----------------------------------------------------------------------------------------------------------------------------------------------------
select 'insert into SUBSTENTRADA (
CF,
CODPRO,
ESTADODESTINO,
ESTADOORIGEM,
SUBSTRIB,
TIPOSUBSTCOMPRA,
TPO,
CFO,
ALIQUOTAICMSST,
BASEICMSST,
NAOABATERCREDITOICMS,
BaseICMS,
AliquotaICMS)
values (
'''+rtrim(ltrim((CF)))+''',',
''''+rtrim(ltrim(isnull(codpro,'')))+''',',
''''+ltrim(rtrim(estadodestino))+''',',
''''+ltrim(rtrim(estadoorigem))+''',',
isnull(SUBSTRIB,0),',',
''''+rtrim(ltrim((TIPOSUBSTCOMPRA)))+''',',
''''+rtrim(ltrim((isnull(tpo,''))))+''',',
''''+rtrim(ltrim((isnull(cfo,''))))+''',',
isnull(ALIQUOTAICMSST,0),',',
isnull(BASEICMSST,0),',',
isnull(NAOABATERCREDITOICMS,0),
isnull(BaseICMS,0),',',
isnull(AliquotaICMS,0),')'

from substentrada

