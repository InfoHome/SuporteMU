-------------------------------------------------------------------------------------------------------
-- Ajustar nota NFCE para baixar na expedição
-- Atendimento: 327117
-- Gera um update onde na expedição não foi atualizado o numero de nota e série para NFCE emitida
--------------------------------------------------------------------------------------------------------
select
'update HISTENTCAD set numnota = '''+ n.NUMNOTA+''', serie = ''' + n.serie + ''' where numord =' + convert(varchar,n.numord),
n.numnota+'/'+n.serie,e.* 
from nfsaidacad n join HISTENTCAD e on n.numord = e.numord
and n.serie <> e.serie and n.numnota <> e.numnota
and n.modelonf = '65'
and n.atualiz = 1 and n.serie not in ('NFC','###')

select 
'update EXPEDICCAD set numnota = '''+ n.NUMNOTA+''', serie = ''' + n.serie + ''' where nordven =' + convert(varchar,n.numord),
n.numnota,n.serie,e.* 
from nfsaidacad n join EXPEDICCAD e on n.numord = e.nordven
and n.serie <> e.serie and n.numnota <> e.numnota
and n.modelonf = '65'
and n.atualiz = 1 and n.serie not in ('NFC','###')