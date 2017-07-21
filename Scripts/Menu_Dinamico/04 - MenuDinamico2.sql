IF EXISTS (SELECT name FROM sysobjects WHERE name = 'MU_DESMEMBRAR_GRUPUSUCAD_PERMISSAO' AND type = 'P')
   drop procedure MU_DESMEMBRAR_GRUPUSUCAD_PERMISSAO
go
CREATE PROCEDURE MU_DESMEMBRAR_GRUPUSUCAD_PERMISSAO
	 @codsis varchar(3)
AS
begin
    declare @grupo varchar(8),  @permrel varchar(100), @permmov varchar(100), @permcad varchar(100), @permtab varchar(100), @permuti varchar(100), 
            @codopc varchar(100), @ropcsistcad int, @permissao int, @contador int, @codopcanterior varchar(100)
    declare @rescopo int, @rusuario int, @acesso int, @novooid int, @quantidadeusuario int, @quantidadeopcoes int, @delta int
    -- obter novo OID    
	SELECT @quantidadeusuario = COUNT(*) FROM GRUPUSUCAD GR, USUARIOCAD US WHERE GR.GRUPO = US.GRUPOUSU AND GR.codsis = @codsis
	SELECT @quantidadeopcoes = COUNT(*) from OPCSISTCAD WHERE codsis = @codsis   
    set @delta = @quantidadeusuario*@quantidadeopcoes
	if @delta > 0
	BEGIN 
		BEGIN TRANSACTION
			UPDATE CONTROLAOID SET ULTIMOOID = ULTIMOOID + @delta 
			SELECT @novooid = (ULTIMOOID - @delta) FROM CONTROLAOID
			SELECT @novooid = @novooid + 1
			COMMIT
	END
	
    declare C_GRUPUSUCAD cursor local for SELECT GRU.grupo,usu.login, GRU.permrel, GRU.permmov, GRU.permcad, GRU.permtab, GRU.permuti FROM GRUPUSUCAD GRU, USUARIOCAD USU where GRU.GRUPO = USU.GRUPOUSU AND GRU.codsis = @codsis 
    open C_GRUPUSUCAD
    fetch C_GRUPUSUCAD into @grupo,@rusuario, @permrel, @permmov, @permcad, @permtab, @permuti
    while @@fetch_status <> -1
    begin
        IF @rusuario > 0
        BEGIN 
	   		declare C_OPCSISTCAD cursor local for select codopc from OPCSISTCAD where codsis = @codsis  order by codopc
			open C_OPCSISTCAD
			fetch C_OPCSISTCAD into @codopc
			set @codopcanterior = ''
			while @@fetch_status <> -1
			begin
				 --print @codopc
		         --print substring(@codopc,1,1)
		         --print cast(substring(@permrel,@contador,1) as int)
		         set @rescopo = 0
		         SELECT @rescopo = OID FROM LISTADEOBJETOS_R WHERE  CODIGO = @codopc 
                 IF @rescopo > 0
                 BEGIN		         
					if @codopcanterior <> substring(@codopc,1,1)
					begin
						set @contador = 1
						set @codopcanterior = substring(@codopc,1,1)
					 end
					set @permissao = 
				        case substring(@codopc,1,1)
						   when '1' then cast(substring(@permrel,@contador,1) as int)
						   when '2' then cast(substring(@permmov,@contador,1) as int)
				           when '3' then cast(substring(@permcad,@contador,1) as int)
			               when '4' then cast(substring(@permtab,@contador,1) as int)
						   when '5' then cast(substring(@permuti,@contador,1) as int)
						end
			         --print @permissao
                    set @acesso = 
                        case @permissao
                             when 1 then 5
                             when 2 then 15
                             when 3 then 31
                             else 0
                         end
					insert into PERMISSAO ( RESCOPO, RUSUARIO, ACESSOAOCONTEUDO, ACESSO, OID )
							values ( @rescopo, @rusuario, 0, @acesso, @novooid )
					set @novooid = @novooid + 1
					set @contador = @contador + 1
    			END
				fetch C_OPCSISTCAD into @codopc
			end
			close C_OPCSISTCAD
			deallocate C_OPCSISTCAD
			END
			fetch C_GRUPUSUCAD into @grupo,@rusuario, @permrel, @permmov, @permcad, @permtab, @permuti
	end
	close C_GRUPUSUCAD
	deallocate C_GRUPUSUCAD
end
go


