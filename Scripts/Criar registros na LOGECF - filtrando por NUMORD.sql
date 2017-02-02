---------------------------------------------------------------------------------------------------------------------------------------
-- Script para criar LOGECF - filtrando por NUMORD
---------------------------------------------------------------------------------------------------------------------------------------


/*COMANDO PARA LISTAR NOTAS SEM LOG ECF*/ 
---------------------------------------------------------------------------------------------------------------------------------------
select nf.numord , nf.*
from nfsaidacad nf
where nf.dtemis>='20090501' and nf.dtemis<'20090601' 
	and nf.espdoc='CF' 
	and nf.filial='03' 
	and nf.tpo<>'20010106' 
	and nf.dtcancel is  NULL
	and nf.numord not in (select oidoperacao 
							from logecf 
							where rfilial = 2228750 
								and data >='20090501' and data <'20090601'  
								and numerocupom=coo )

/*GERAR LOGECF AUTOMATICO - FILTRANDO POR NUMORD*/
---------------------------------------------------------------------------------------------------------------------------------------
insert into logecf (numerocupom,coo, numeroecf, rfilial, rcaixa, data, rtipooperacao, valor, oidoperacao, ratofinanceiro, codsen)
	(select nf.numnota,
		nf.numnota,
		nf.serie+'/'+nf.serieecf,
		fl.oid,
		ve.localporta,
		ve.dtven,
		'26750',
		nf.valcontab,
		nf.numord,
		'7',
		'999'
	from nfsaidacad nf, filialcad fl, vendasscad ve
	where nf.numord=ve.numord 
		and fl.filial=nf.filial 
		and ve.numord in (16660,16855)) --Inserir cadei de numords
select * from filialcad
