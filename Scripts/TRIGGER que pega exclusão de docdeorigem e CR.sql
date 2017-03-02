---- trigger pra pegar aonde que está excluindo docdeorigem e conta a receber de venda indevidamente ------ 
SET QUOTED_IDENTIFIER OFF

IF EXISTS (SELECT name FROM sysobjects WHERE name = 'TESTE_EXCLUIDO_TESTE_I' AND type = 'TR')
   drop trigger TESTE_EXCLUIDO_TESTE_I
go
create trigger TESTE_EXCLUIDO_TESTE_I on dbo.EXCLUIDO for insert as
begin
    declare @RTIPO integer, @RCATEGORIA integer, @CID integer, @OID integer
    declare C_INSERTED2 cursor local for select D.OID, D.RTIPO, C.RCATEGORIA, I.CID 
		from inserted a
		join DOCDEORIGEM D (nolock) on a.OID = D.OID
		join ITEM I (nolock) on a.OID = D.OID
		left join CLASSIFICACAO C (nolock) on D.OID = C.RITEM and C.Rcategoria = 2473
		where I.CID in (142,153)
    open C_INSERTED2
    fetch C_INSERTED2 into @OID, @RTIPO, @RCATEGORIA, @CID
    while @@fetch_status <> -1
    begin
        if @CID = 142 and @RCATEGORIA = 2473 and @RTIPO = 16178 and not exists(select 1 from NFSAIDACAD where oiddocdeorigem = @OID)
		   begin
		      close C_INSERTED2
		      deallocate C_INSERTED2
              raiserror 50065 "ATENÇÃO: bloqueado tentativa de excluir DocDeOrigem de venda. Envie OCOR para o atendimento da MicroUniverso"
              rollback transaction
              return
           end
        if @CID = 153 and exists(select 1 from CONTAARECEBER cr join DOCDEORIGEM do on cr.RDOCDEORIGEM = do.oid 
								 where cr.OID = @OID and do.RTIPO = 16178
								 and not exists(select 1 from NFSAIDACAD where oiddocdeorigem = do.OID))
		   begin 
		      close C_INSERTED2
		      deallocate C_INSERTED2
              raiserror 50065 "ATENÇÃO: bloqueado tentativa de excluir ContaAReceber de venda. Envie OCOR para o atendimento da MicroUniverso"
              rollback transaction
              return
		   end
        fetch C_INSERTED2 into @OID, @RTIPO, @RCATEGORIA, @CID
    end
    close C_INSERTED2
    deallocate C_INSERTED2
    return
end
go