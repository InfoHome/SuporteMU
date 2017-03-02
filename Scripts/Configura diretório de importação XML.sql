select * from aditivo_r where svalor like 'z%:%'


update ADITIVO_R set svalor = 'Z:\0-Comunicação\Interna\Time\XML\Importado' 
where RDEFINICAO = 35998 and ritem in (select oid from filialcad)

update ADITIVO_R set svalor = 'Z:\0-Comunicação\Interna\Time\XML\Importar' 
where RDEFINICAO = 35995 and ritem in (select oid from filialcad)

select * from filialcad



