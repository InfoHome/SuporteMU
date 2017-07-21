insert into CHAVEUNICA(OID,DESCRICAO)
select oid, chave from (select numord * (-1) as oid,
'##NumNFCE##' + filial + '-' + (case when len(ltrim(rtrim(serie))) = 1 then '00' when len(ltrim(rtrim(serie))) = 2 then '0' else '' end) + ltrim(rtrim(serie)) + '-' 
+ cast(cast( rtrim(numnota) as integer) as varchar) as chave
from NFSAIDACAD where modelonf = '65' and atualiz = 1 and serie != 'NFC' and serie != '###') T
where not exists(select 1 from CHAVEUNICA where DESCRICAO = T.chave)
