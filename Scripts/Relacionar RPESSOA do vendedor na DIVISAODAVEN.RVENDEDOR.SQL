declare @oidDiv int, @RPessoa int, @sql varchar(500)
declare CurCorrigeDivisaoDaVenda_RVENDEDOR cursor for 
					select 
						dv.oid, vc.RPessoa
					from 
						ContaaReceber_r cr, 
						VendasSCad ve, 
						PediCliCad pe, 
						VendedoCad vc,
						DivisaoDaVenda dv
					where 
						cr.RDocDeOrigem = ve.OidDocDeOrigem 
						and ve.NumpED = pe.Numped
						and pe.CodVend = vc.Codvend
						and cr.Oid = dv.RdocDeOrigem
						and Vc.RPessoa > 7
						and dv.RVendedor <= 7
						and dv.rdocdeorigem > 7

open CurCorrigeDivisaoDaVenda_RVENDEDOR
fetch CurCorrigeDIVISAODAVENDA_RVENDEDOR into @oidDiv, @RPessoa
while @@fetch_status <> -1
begin
    select @sql = 'UPDATE DIVISAODAVENDA SET RVENDEDOR = ''' + cast(@RPessoa  as varchar) + ''' where oid = ' + cast(@oidDiv as varchar)
    ------------------------------------------------------------------------------------------------------------------
    --Ponto de Consulta e Ajuste
    ------------------------------------------------------------------------------------------------------------------
    print @sql		-- Descomente o início dessa linha e comente o início da linha DEBAIXO para só CONSULTAR
    --execute(@sql)		-- Descomente o início dessa linha e comente a o início da linha ACIMA para AJUSTAR
    ------------------------------------------------------------------------------------------------------------------
    fetch CurCorrigeDivisaoDaVenda_RVENDEDOR into @oidDiv, @RPessoa
end
close CurCorrigeDivisaoDaVenda_RVENDEDOR
deallocate CurCorrigeDivisaoDaVenda_RVENDEDOR
