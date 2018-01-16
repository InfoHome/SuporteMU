USE [WebBI]
GO

/****** Object:  StoredProcedure [dbo].[SP_MUBI_CMPDATA]    Script Date: 10/01/2018 09:24:06 ******/
DROP PROCEDURE [dbo].[SP_MUBI_CMPDATA]
GO

/****** Object:  StoredProcedure [dbo].[SP_MUBI_CMPDATA]    Script Date: 10/01/2018 09:24:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[SP_MUBI_CMPDATA]
                @descricao varchar(50),
                @Dimensao int,
                @Metrica varchar(50),
                @Campo4 varchar(500), 
                @Campo5 varchar(500), 
                @DtInicial1 varchar(10),
                @DtFinal1 varchar(10),
                @DtInicial2 varchar(10),
                @DtFinal2 varchar(10),
                @DtInicial3 varchar(10),
                @DtFinal3 varchar(10),
                @SqlFiltro varchar(3000),
                @OrderBy int,
                @OrderByAsc int
as
begin
    set nocount on

    declare @nsql varchar(500)
    declare @tsql varchar(500)
    declare @lastsql varchar(8000)
    declare @periodo1 varchar(100)
    declare @periodo2 varchar(100)
    declare @periodo3 varchar(100)

    set @nsql = ', sum(n.' + @Metrica +') '+ @Metrica
    set @tsql = ', a.' + @Metrica + ' ' + @Metrica + ', case when b.' + @Metrica + ' = 0 then 0 else round((a.' + @Metrica + '*100/b.' + @Metrica + '),2) end p' + @Metrica

    set @periodo1 = ' and n.data between convert(datetime, ''' + @DtInicial1 + ''', 103) and convert(datetime, ''' + @DtFinal1 + ''', 103) '
    set @periodo2 = ' and n.data between convert(datetime, ''' + @DtInicial2 + ''', 103) and convert(datetime, ''' + @DtFinal2 + ''', 103) '
    if (@DtInicial3 is not null) and (@DtFinal3 is not null)
        set @periodo3 = ' and n.data between convert(datetime, ''' + @DtInicial3 + ''', 103) and convert(datetime, ''' + @DtFinal3 + ''', 103) '
    else
        set @periodo3 = null

    create table #tmp_aux1 (
        nivel varchar(50),
        descricao varchar(100),
        metrica float,
        pmetrica float)

    create table #tmp_aux2 (
        nivel varchar(50),
        descricao varchar(100),
        metrica float,
        pmetrica float)

    create table #tmp_aux3 (
        nivel varchar(50),
        descricao varchar(100),
        metrica float,
        pmetrica float)

    create table #tmp_result (
        descricao varchar(100),
        valperiodo1 numeric(10,2),
        valperiodo2 numeric(10,2),
        valperiodo3 numeric(10,2),
        percperiodo1 numeric(10,2),
        percperiodo2 numeric(10,2),
        percperiodo3 numeric(10,2),
        valper21 numeric(10,2),
        valper32 numeric(10,2),
        percper21 numeric(10,2),
        percper32 numeric(10,2))

    If @descricao = 'descricao' begin
        set @lastsql = ' select a.nivel' + ltrim(rtrim(str(@Dimensao))) + ',a.descricao descricao ' + @tsql +
                       ' from (select n.nivel' + ltrim(rtrim(str(@Dimensao))) + ',tn.descricao ' + @nsql +
                             ' from ' + @Campo4 + ' n , ' + @Campo5 + ' tn' +
                             ' where n.nivel' + ltrim(rtrim(str(@Dimensao))) + ' = tn.nivel' + ltrim(rtrim(str(@Dimensao))) + ' '+
                             @periodo1 + @SqlFiltro +
                             ' group by n.nivel' + ltrim(rtrim(str(@Dimensao))) + ',tn.descricao) a,' +
                            ' (select ''%'' perc' + @nsql +
                             ' from ' + @Campo4 + ' n, ' + @Campo5 + ' tn where n.nivel' + ltrim(rtrim(str(@Dimensao))) + ' = tn.nivel' + ltrim(rtrim(str(@Dimensao))) + ' '+
                             @periodo1 + @SqlFiltro + ') b' 
        insert into #tmp_aux1 execute(@lastsql)

        set @lastsql = ' select a.nivel' + ltrim(rtrim(str(@Dimensao))) + ',a.descricao descricao ' + @tsql +
                       ' from (select n.nivel' + ltrim(rtrim(str(@Dimensao))) + ',tn.descricao ' + @nsql +
                             ' from ' + @Campo4 + ' n , ' + @Campo5 + ' tn' +
                             ' where n.nivel' + ltrim(rtrim(str(@Dimensao))) + ' = tn.nivel' + ltrim(rtrim(str(@Dimensao))) + ' '+
                             @periodo2 + @SqlFiltro +
                             ' group by n.nivel' + ltrim(rtrim(str(@Dimensao))) + ',tn.descricao) a,' +
                            ' (select ''%'' perc' + @nsql +
                             ' from ' + @Campo4 + ' n, ' + @Campo5 + ' tn where n.nivel' + ltrim(rtrim(str(@Dimensao))) + ' = tn.nivel' + ltrim(rtrim(str(@Dimensao))) + ' '+
                             @periodo2 + @SqlFiltro + ') b' 
        insert into #tmp_aux2 execute(@lastsql)

        if @periodo3 is not null begin
            set @lastsql = ' select a.nivel' + ltrim(rtrim(str(@Dimensao))) + ',a.descricao descricao ' + @tsql +
                           ' from (select n.nivel' + ltrim(rtrim(str(@Dimensao))) + ',tn.descricao ' + @nsql +
                                 ' from ' + @Campo4 + ' n , ' + @Campo5 + ' tn' +
                                 ' where n.nivel' + ltrim(rtrim(str(@Dimensao))) + ' = tn.nivel' + ltrim(rtrim(str(@Dimensao))) + ' '+
                                 @periodo3 + @SqlFiltro +
                                 ' group by n.nivel' + ltrim(rtrim(str(@Dimensao))) + ',tn.descricao) a,' +
                                ' (select ''%'' perc' + @nsql +
                                 ' from ' + @Campo4 + ' n, ' + @Campo5 + ' tn where n.nivel' + ltrim(rtrim(str(@Dimensao))) + ' = tn.nivel' + ltrim(rtrim(str(@Dimensao))) + ' '+
                                 @periodo3 + @SqlFiltro + ') b' 
            insert into #tmp_aux3 execute(@lastsql)
        end    
    end  
    else begin
        set @lastsql = ' select null, a.' + ltrim(rtrim(@Descricao)) + ' descricao ' + @tsql +
                       ' from (select tn.' + ltrim(rtrim(@Descricao)) + ' ' + @nsql +
                             ' from ' + @Campo4 + ' n, ' + @Campo5 + ' tn' +
                             ' where n.nivel' + ltrim(rtrim(str(@Dimensao))) + ' = tn.nivel' + ltrim(rtrim(str(@Dimensao))) +' '+
                             @periodo1 + @SqlFiltro +
                             ' group by tn.' + ltrim(rtrim(@Descricao)) + ') a,' +
                            ' (select ''%'' perc' + @nsql +
                             ' from ' + @Campo4 + ' n, ' + @Campo5 + ' tn where n.nivel' + ltrim(rtrim(str(@Dimensao))) + ' = tn.nivel' + ltrim(rtrim(str(@Dimensao))) +' '+
                             @periodo1 + @SqlFiltro + ') b' 
        insert into #tmp_aux1 execute(@lastsql)

        set @lastsql = ' select null, a.' + ltrim(rtrim(@Descricao)) + ' descricao ' + @tsql +
                       ' from (select tn.' + ltrim(rtrim(@Descricao)) + ' ' + @nsql +
                             ' from ' + @Campo4 + ' n, ' + @Campo5 + ' tn' +
                             ' where n.nivel' + ltrim(rtrim(str(@Dimensao))) + ' = tn.nivel' + ltrim(rtrim(str(@Dimensao))) + ' '+
                             @periodo2 + @SqlFiltro +
                             ' group by tn.' + ltrim(rtrim(@Descricao)) + ') a,' +
                            ' (select ''%'' perc' + @nsql +
                             ' from ' + @Campo4 + ' n, ' + @Campo5 + ' tn where n.nivel' + ltrim(rtrim(str(@Dimensao))) + ' = tn.nivel' + ltrim(rtrim(str(@Dimensao))) + ' '+
                             @periodo2 + @SqlFiltro + ') b' 
        insert into #tmp_aux2 execute(@lastsql)

        if @periodo3 is not null begin
            set @lastsql = ' select null, a.' + ltrim(rtrim(@Descricao)) + ' descricao ' + @tsql +
                           ' from (select tn.' + ltrim(rtrim(@Descricao)) + ' ' + @nsql +
                                 ' from ' + @Campo4 + ' n, ' + @Campo5 + ' tn' +
                                 ' where n.nivel' + ltrim(rtrim(str(@Dimensao))) + ' = tn.nivel' + ltrim(rtrim(str(@Dimensao))) + ' '+
                                 @periodo3 + @SqlFiltro +
                                 ' group by tn.' + ltrim(rtrim(@Descricao)) + ') a,' +
                                ' (select ''%'' perc' + @nsql +
                                 ' from ' + @Campo4 + ' n, ' + @Campo5 + ' tn where n.nivel' + ltrim(rtrim(str(@Dimensao))) + ' = tn.nivel' + ltrim(rtrim(str(@Dimensao))) + ' '+
                                 @periodo3 + @SqlFiltro + ') b' 
            insert into #tmp_aux3 execute(@lastsql)
        end
    end

    if @periodo3 is null begin
        insert into #tmp_result 
        select isnull(aux1.descricao, aux2.descricao), 
               isnull(aux1.metrica, 0.00), 
               isnull(aux2.metrica, 0.00), 
               null, 
               isnull(aux1.pmetrica, 0.00),
               isnull(aux2.pmetrica, 0.00), 
               null, 
               isnull(aux2.metrica, 0.00) - isnull(aux1.metrica, 0.00),
               null, 
               case when isnull(aux1.metrica, 0) = 0 then null else (((isnull(aux2.metrica, 0.00) - aux1.metrica) *100) /aux1.metrica) end, 
               null
        from #tmp_aux1 aux1 FULL OUTER JOIN #tmp_aux2 aux2 on (aux1.descricao = aux2.descricao)
    end 
    else begin
        insert into #tmp_result 
        select descricao, sum(m1), sum(m2), sum(m3), sum(p1), sum(p2), sum(p3), sum(m2) - sum(m1), sum(m3) - sum(m2),
               case when sum(m1) = 0.00 then null else (((sum(m2) - sum(m1))*100)/sum(m1)) end, 
               case when sum(m2) = 0.00 then null else (((sum(m3) - sum(m2))*100)/sum(m2)) end
        from (select descricao, metrica m1, 0.0 m2, 0.0 m3, pmetrica p1, 0.0 p2, 0.0 p3 from #tmp_aux1
              union
              select descricao, 0.0 m1, metrica m2, 0.0 m3, 0.0 p1, pmetrica p2, 0.0 p3 from #tmp_aux2
              union 
              select descricao, 0.0 m1, 0.0 m2, metrica m3, 0.0 p1, 0.0 p2, pmetrica p3 from #tmp_aux3) aux
        group by descricao
    end

    set nocount off

    if @OrderBy = 1 begin
        if @OrderByAsc = 1
            select * from #tmp_result order by valperiodo1 asc
        else
            select * from #tmp_result order by valperiodo1 desc
    end
    else if @OrderBy = 2 begin
        if @OrderByAsc = 1
            select * from #tmp_result order by valperiodo2 asc
        else
            select * from #tmp_result order by valperiodo2 desc
    end
    else if @OrderBy = 3 begin
        if @OrderByAsc = 1
            select * from #tmp_result order by valperiodo3 asc
        else
            select * from #tmp_result order by valperiodo3 desc
    end

end

GO


