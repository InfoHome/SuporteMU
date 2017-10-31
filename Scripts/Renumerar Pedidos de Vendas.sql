-- Lista pedidos duplicados.
----------------------------------------------------------------
select numped from PEDICLICAD 
where numped in (select numped from PEDICLICAD 
where year(dtpedido)=2017 and month(dtpedido)= 10
group by numped having COUNT (*) >=2 )
and filial = '03'
order by numped

select numped from PEDICLICOMPLEMENTO 
group by numped 
having COUNT (*) > = 2 

-- Listar tabelas com numped para filtrar
----------------------------------------------------------------
SELECT 
	'select * from ' +OBJECT_NAME(ps.[object_id]) + ' where numped = 1962592 and filial = ''03''',
	OBJECT_NAME(ps.[object_id]) AS [TableName] ,C.NAME, i.name AS [IndexName] , 
	SUM(ps.row_count) AS [RowCount]
FROM sys.dm_db_partition_stats AS ps 
	INNER JOIN sys.indexes AS i  ON i.[object_id] = ps.[object_id] AND i.index_id = ps.index_id
	INNER JOIN SYS.columns C ON i.[object_id] = C.[object_id] AND C.NAME LIKE 'NUMPED'
	INNER JOIN SYS.objects O ON i.[object_id] = C.[object_id] AND O.type_desc = 'USER_TABLE'
WHERE i.type_desc IN ( 'CLUSTERED', 'HEAP' ) AND i.[object_id] > 100 
	AND OBJECT_SCHEMA_NAME(ps.[object_id]) <> 'sys' 
GROUP BY ps.[object_id] , i.name,C.NAME
HAVING SUM(ps.row_count) > 0

ORDER BY SUM(ps.row_count) 
DESC



-- CURSOR PARA AJUSTAR AS TABELAS
----------------------------------------------------------------------------------------------------------
declare @numped_Novo INT , @numped_Antigo int
Declare @sql01 varchar(5000),@sql02 varchar(5000),@sql03 varchar(5000),@sql04 varchar(5000),@sql05 varchar(5000),@sql06 varchar(5000),@sql07 varchar(5000),
@sql08 varchar(5000),@sql09 varchar(5000),@sql10 varchar(5000),@sql11 varchar(5000),@sql12 varchar(5000),@sql13 varchar(5000),@sql14 varchar(5000)

declare CurRenumeraCodComponente cursor for 

			select 
				 numped_Novo, numped_Antigo
			from 
				NumerosPedidos

open CurRenumeraCodComponente
fetch CurRenumeraCodComponente into  @numped_Novo, @numped_Antigo
while @@fetch_status <> -1
begin
select @sql01 = 'UPDATE HISTORICOPEDIDO SET NUMPED = '''			+ cast(@numped_Novo  as varchar) + ''' where filial = ''03'' and NUMPED = ' + cast(@numped_Antigo as varchar) + CHAR(13)+'GO'
select @sql02 = 'UPDATE ITEMCLICAD SET NUMPED = '''					+ cast(@numped_Novo  as varchar) + ''' where filial = ''03'' and NUMPED = ' + cast(@numped_Antigo as varchar) + CHAR(13)+'GO'
select @sql03 = 'UPDATE ITEMCLICOMPLEMENTO SET NUMPED = '''			+ cast(@numped_Novo  as varchar) + ''' where NUMPED = ' + cast(@numped_Antigo as varchar) + ' and ritem in (select item from ITEMCLICAD where numped = '+ cast(@numped_Antigo as varchar) +' and filial = ''03'') '+ CHAR(13)+'GO'
select @sql04 = 'UPDATE PREVCLICAD SET NUMPED = '''					+ cast(@numped_Novo  as varchar) + ''' where filial = ''03'' and NUMPED = ' + cast(@numped_Antigo as varchar) + CHAR(13)+'GO'
select @sql05 = 'UPDATE PEDICLICAD SET NUMPED = '''					+ cast(@numped_Novo  as varchar) + ''' where filial = ''03'' and NUMPED = ' + cast(@numped_Antigo as varchar) + CHAR(13)+'GO'
select @sql06 = 'UPDATE LANCHECCXA SET NUMPED = '''					+ cast(@numped_Novo  as varchar) + ''' where filial = ''03'' and NUMPED = ' + cast(@numped_Antigo as varchar) + CHAR(13)+'GO'
select @sql07 = 'UPDATE NFSAIDACAD SET NUMPED = '''					+ cast(@numped_Novo  as varchar) + ''' where filial = ''03'' and NUMPED = ' + cast(@numped_Antigo as varchar) + CHAR(13)+'GO'
select @sql08 = 'UPDATE VENDASSCAD SET NUMPED = '''					+ cast(@numped_Novo  as varchar) + ''' where filial = ''03'' and NUMPED = ' + cast(@numped_Antigo as varchar) + CHAR(13)+'GO'
select @sql09 = 'UPDATE PEDICLICLASSIFICACAOCLIENTE SET NUMPED = '''+ cast(@numped_Novo  as varchar) + ''' where filial = ''03'' and NUMPED = ' + cast(@numped_Antigo as varchar) + CHAR(13)+'GO'
select @sql10 = 'UPDATE ENTRCLICAD SET NUMPED = '''					+ cast(@numped_Novo  as varchar) + ''' where filial = ''03'' and NUMPED = ' + cast(@numped_Antigo as varchar) + CHAR(13)+'GO'
select @sql11 = 'UPDATE ITEMFATURADO SET PEDIDO = '''				+ cast(@numped_Novo  as varchar) + ''' Where filial = ''03'' and PEDIDO = ' + cast(@numped_Antigo as varchar) + CHAR(13)+'GO'
select @sql12 = 'UPDATE ITEMLIBFAT SET NUMPED = '''					+ cast(@numped_Novo  as varchar) + ''' where filial = ''03'' and NUMPED = ' + cast(@numped_Antigo as varchar) + CHAR(13)+'GO'
select @sql13 = 'UPDATE ITEMCANCELADO SET NUMPED = '''				+ cast(@numped_Novo  as varchar) + ''' where filial = ''03'' and NUMPED = ' + cast(@numped_Antigo as varchar) + CHAR(13)+'GO'
select @sql14 = 'UPDATE PEDIDOCANCELADO SET NUMPED = '''			+ cast(@numped_Novo  as varchar) + ''' where filial = ''03'' and NUMPED = ' + cast(@numped_Antigo as varchar) + CHAR(13)+'GO'

	------------------------------------------------------------------------------------------------------------------
    --Ponto de Consulta e Ajuste
    ------------------------------------------------------------------------------------------------------------------
    print @sql01		-- Descomente o início dessa linha e comente o início da linha DEBAIXO para só CONSULTAR
	print @sql02		-- Descomente o início dessa linha e comente o início da linha DEBAIXO para só CONSULTAR
	print @sql03		-- Descomente o início dessa linha e comente o início da linha DEBAIXO para só CONSULTAR
	print @sql04		-- Descomente o início dessa linha e comente o início da linha DEBAIXO para só CONSULTAR
	print @sql05		-- Descomente o início dessa linha e comente o início da linha DEBAIXO para só CONSULTAR
	print @sql06		-- Descomente o início dessa linha e comente o início da linha DEBAIXO para só CONSULTAR
	print @sql07		-- Descomente o início dessa linha e comente o início da linha DEBAIXO para só CONSULTAR
	print @sql08		-- Descomente o início dessa linha e comente o início da linha DEBAIXO para só CONSULTAR
	print @sql09		-- Descomente o início dessa linha e comente o início da linha DEBAIXO para só CONSULTAR
	print @sql10		-- Descomente o início dessa linha e comente o início da linha DEBAIXO para só CONSULTAR
	print @sql11		-- Descomente o início dessa linha e comente o início da linha DEBAIXO para só CONSULTAR
	print @sql12		-- Descomente o início dessa linha e comente o início da linha DEBAIXO para só CONSULTAR
	print @sql13		-- Descomente o início dessa linha e comente o início da linha DEBAIXO para só CONSULTAR
	print @sql14		-- Descomente o início dessa linha e comente o início da linha DEBAIXO para só CONSULTAR

    --execute(@sql01)		-- Descomente o início dessa linha e comente a o início da linha ACIMA para AJUSTAR

    ------------------------------------------------------------------------------------------------------------------
    fetch CurRenumeraCodComponente into @numped_Novo, @numped_Antigo
end
close CurRenumeraCodComponente
deallocate CurRenumeraCodComponente




select * from HISTORICOPEDIDO where numped = 1962592 and filial = '03'
select * from ITEMCLICAD where numped = 1962592 and filial = '03'
select * from ITEMCLICOMPLEMENTO where numped = 1962592 and ritem in (select item from ITEMCLICAD where numped = 1962592 and filial = '03')
select * from PREVCLICAD where numped = 1962592 and filial = '03'
select * from PEDICLICAD where numped = 1962592 and filial = '03'
--select * from PEDICLICOMPLEMENTO where numped = 1962592 and filial = '03'
select * from LANCHECCXA where numped = 1962592 and filial = '03'
select * from NFSAIDACAD where numped = 1962592 and filial = '03'
select * from VENDASSCAD where numped = 1962592 and filial = '03'
select * from PEDICLICLASSIFICACAOCLIENTE where numped = 1962592
select * from ENTRCLICAD where numped = 1962592 and filial = '03'
select * from ITEMLIBFAT where numped = 1962592 and filial = '03'
select * from ITEMCANCELADO where numped = 1962592 and filial = '03'
select * from PEDIDOCANCELADO where numped = 1962592 and filial = '03'
