USE [WebBI]
GO

/****** Object:  StoredProcedure [dbo].[SP_MUBI_CROSSTABS_ORGRESULT]    Script Date: 10/01/2018 09:26:33 ******/
DROP PROCEDURE [dbo].[SP_MUBI_CROSSTABS_ORGRESULT]
GO

/****** Object:  StoredProcedure [dbo].[SP_MUBI_CROSSTABS_ORGRESULT]    Script Date: 10/01/2018 09:26:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create procedure [dbo].[SP_MUBI_CROSSTABS_ORGRESULT] 
                @query varchar(8000),
                @DelLinZeradas int,
                @DelColZeradas int,
                @OrdenaLinhas int,
                @ValColuna varchar(100), 
                @OrderByAsc int,
                @Formula varchar(3000)
as
begin
  declare @aux2 varchar(3000)
  declare @aux3 varchar(3000)
  declare @s1 varchar(3000)
  declare @s2 varchar(3000)
  declare @i int
  declare @j int
  declare @p1 int
  declare @p2 int

  --TRATA A EXISTÊNCIA DE FORMULA
  if @Formula <> ''
  begin
    set @formula = ' '+ @formula +' '
    
    --SUBUSTITUIR ^ POR POWER()
    if charindex('^', @formula) > 0
    begin
      set @p1 = 0
      set @p2 = 0
    
      while charindex('^', @formula) > 0
      begin
          set @i = charindex('^', @formula) - 1
          set @aux2 = substring(@formula, @i, 1)
          set @aux3 = ''
          set @j = 0
          while (@i > 0) and ((charindex(@aux2, '+-*/%^') = 0) or (@j <> 0))
          begin
            if @aux2 = ')' 
              set @j = @j + 1
    
            if @aux2 = '(' 
              set @j = @j - 1
    
            set @aux3 = @aux2 + @aux3
    
            set @i = @i - 1
            if @i > 0 
              set @aux2 = substring(@formula, @i, 1)
          end
          set @p1 = @i
          set @s1 = @aux3
    
          set @i = charindex('^', @formula) + 1
          set @aux2 = substring(@formula, @i, 1)
          set @aux3 = ''
          set @j = 0
          while ((charindex(@aux2, '+-*/%^') = 0) or (@j <> 0)) and (@i <= len(@formula))
          begin
            if @aux2 = '(' 
              set @j = @j + 1
    
            if @aux2 = ')' 
              set @j = @j - 1
    
            set @aux3 = @aux3 + @aux2 
    
            set @i = @i + 1
            set @aux2 = substring(@formula, @i, 1)
          end
          set @p2 = @i
          set @s2 = @aux3
    
          set @i = charindex('^', @formula)
          set @formula = left(@formula, @p1) + 'power('+ @s1 +','+ @s2 +')' + substring(@formula, @p2, len(@formula))
      end
    end
    
    --SUBUSTITUIR MOD POR %
    if charindex(' mod ', @formula) > 0
      set @formula = replace(@formula, ' mod ', ' % ')

    --set @query = replace(@query, 'sum(@formula)', @formula)
    --set @query = left(@query, charindex('order by', @query)-1)
  end

  --PROCESSA A QUERY
  if ((@OrdenaLinhas + @DelLinZeradas + @DelColZeradas) > 0) or (@Formula <> '')
  begin
     set nocount on      
     create table #tmpresult (
        maxvalue float,
        linha varchar(100),
        coluna varchar(100),
        valor float)

     if (@Formula = '')
     begin
        set @query = REPLACE(@query,'select ','select 0.0, ')
        insert into #tmpresult execute (@query)
     end
     else
     begin -- SE POSSUI FORMULA
        create table #tmpaux (
          linha varchar(100),
          coluna varchar(100),
          atr1 float,
          atr2 float,
          atr3 float,
          atr4 float,
          atr5 float,
          atr6 float,
          atr7 float,
          atr8 float,
          atr9 float,
          atr10 float,
          atr11 float,
          atr12 float,
          atr13 float,
          atr14 float,
          atr15 float)

        --Obtem o nome da tabela principal
        set @aux2 = @query
-- Luiz Carlos 22/04/16
--        set @aux2 = substring(@aux2, charindex('from ', @aux2)+5, len(@aux2))
        set @aux2 = substring(@aux2, charindex('Left ', @aux2)+10, len(@aux2))
        set @aux2 = ltrim(@aux2)
        set @aux2 = left(@aux2, charindex(' ', @aux2)-1)

        --Monta o insert para a #tmpaux
        set @aux3 = left(@query, charindex(' coluna', @query) + 6) -- será algo do tipo: 'select l.descricao linha, c.descricao coluna' mas pode variar se optou por atributos
        if exists(select * from sysobjects, syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'atr1' and sysobjects.name = @aux2) 
        begin
          set @aux3 = @aux3 + ', isnull(sum(atr1), 0) atr1 '
          if exists(select * from sysobjects, syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'atr2' and sysobjects.name = @aux2) 
          begin
            set @aux3 = @aux3 + ', isnull(sum(atr2), 0) atr2 '
            if exists(select * from sysobjects, syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'atr3' and sysobjects.name = @aux2) 
            begin
              set @aux3 = @aux3 + ', isnull(sum(atr3), 0) atr3 '
              if exists(select * from sysobjects, syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'atr4' and sysobjects.name = @aux2) 
              begin
                set @aux3 = @aux3 + ', isnull(sum(atr4), 0) atr4 '
                if exists(select * from sysobjects, syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'atr5' and sysobjects.name = @aux2) 
                begin
                  set @aux3 = @aux3 + ', isnull(sum(atr5), 0) atr5 '
                  if exists(select * from sysobjects, syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'atr6' and sysobjects.name = @aux2) 
                  begin
                    set @aux3 = @aux3 + ', isnull(sum(atr6), 0) atr6 '
                    if exists(select * from sysobjects, syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'atr7' and sysobjects.name = @aux2) 
                    begin
                      set @aux3 = @aux3 + ', isnull(sum(atr7), 0) atr7 '
                      if exists(select * from sysobjects, syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'atr8' and sysobjects.name = @aux2) 
                      begin
                        set @aux3 = @aux3 + ', isnull(sum(atr8), 0) atr8 '
                        if exists(select * from sysobjects, syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'atr9' and sysobjects.name = @aux2) 
                        begin
                          set @aux3 = @aux3 + ', isnull(sum(atr9), 0) atr9 '
                          if exists(select * from sysobjects, syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'atr10' and sysobjects.name = @aux2) 
                          begin
                            set @aux3 = @aux3 + ', isnull(sum(atr10), 0) atr10 '
                            if exists(select * from sysobjects, syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'atr11' and sysobjects.name = @aux2) 
                            begin
                              set @aux3 = @aux3 + ', isnull(sum(atr11), 0) atr11 '
                              if exists(select * from sysobjects, syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'atr12' and sysobjects.name = @aux2) 
                              begin
                                set @aux3 = @aux3 + ', isnull(sum(atr12), 0) atr12 '
                                if exists(select * from sysobjects, syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'atr13' and sysobjects.name = @aux2) 
                                begin
                                  set @aux3 = @aux3 + ', isnull(sum(atr13), 0) atr13 '
                                  if exists(select * from sysobjects, syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'atr14' and sysobjects.name = @aux2) 
                                  begin
                                    set @aux3 = @aux3 + ', isnull(sum(atr14), 0) atr14 '
                                    if exists(select * from sysobjects, syscolumns where sysobjects.id = syscolumns.id and syscolumns.name = 'atr15' and sysobjects.name = @aux2) 
                                      set @aux3 = @aux3 + ', isnull(sum(atr15), 0) atr15 '
                                    else
                                      set @aux3 = @aux3 + ', 0 '
                                    end
                                  else
                                    set @aux3 = @aux3 + ', 0, 0 '
                                  end
                                else
                                  set @aux3 = @aux3 + ', 0, 0, 0 '
                                end
                              else
                                set @aux3 = @aux3 + ', 0, 0, 0, 0 '
                              end
                            else
                              set @aux3 = @aux3 + ', 0, 0, 0, 0, 0 '
                            end
                          else
                            set @aux3 = @aux3 + ', 0, 0, 0, 0, 0, 0 '
                          end
                        else
                          set @aux3 = @aux3 + ', 0, 0, 0, 0, 0, 0, 0 '
                        end  
                      else
                        set @aux3 = @aux3 + ', 0, 0, 0, 0, 0, 0, 0, 0 '
                      end
                    else
                      set @aux3 = @aux3 + ', 0, 0, 0, 0, 0, 0, 0, 0, 0 '
                    end  
                  else
                    set @aux3 = @aux3 + ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 '
                  end
                else
                  set @aux3 = @aux3 + ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 '
                end  
              else
                set @aux3 = @aux3 + ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 '
              end
            else
              set @aux3 = @aux3 + ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 '
            end  
          else
            set @aux3 = @aux3 + ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 '
          end
        else
          set @aux3 = @aux3 + ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 '
          set @aux2 = substring(@query, charindex('from ', @query), len(@query))
          set @aux3 = @aux3 + @aux2

          insert into #tmpaux execute (@aux3)
          insert into #tmpresult execute ('select 0, linha, coluna, '+ @Formula +' from #tmpaux')
        end

        -- PROCESSA A INFORMAÇÃO DE RETORNO
        if @OrdenaLinhas = 1 
          update #tmpresult 
          set maxvalue = (select max(tmax.valor) from #tmpresult tmax where tmax.linha = #tmpresult.linha and tmax.coluna = @ValColuna)
    
        if @DelLinZeradas = 1 
          delete #tmpresult where linha in (select linha from #tmpresult group by linha having sum(valor) = 0)
    
        if @DelColZeradas = 1 
          delete #tmpresult where coluna in (select coluna from #tmpresult group by coluna having sum(valor) = 0)

        set nocount off

        if @OrderByAsc = 1 
          select linha, coluna, valor from #tmpresult order by maxvalue asc, linha, coluna
        else
          select linha, coluna, valor from #tmpresult order by maxvalue desc, linha, coluna
  end
  else 
    execute (@query)
end




GO


