UPDATE LISTADEOBJETOS_R SET ESPECIFICACAO=
'FDisableButtons(oToolPrinc)<BR>PUBLIC glSimplificada<BR>glSimplificada = .F.<BR>oAgMenuDinamico.DOFORM ("siswFaturaPendentes WITH 3")<BR>RELEASE glSimplificada<BR>fEnableButtons(oToolPrinc)<BR>'
WHERE OID=35349
go
UPDATE LISTADEOBJETOS_R SET ESPECIFICACAO=
'FDisableButtons(oToolPrinc)<BR>PUBLIC glSimplificada<BR>glSimplificada = .T.<BR>oAgMenuDinamico.DOFORM ("siswFaturaPendentes WITH 3")<BR>glSimplificada = .F.<BR>fEnableButtons(oToolPrinc)<BR>'
WHERE OID=35350
go
UPDATE LISTADEOBJETOS SET ESPECIFICACAO=
'PUBLIC glSimplificada<BR>glSimplificada = .f.<BR>FDisableButtons(oToolPrinc)<BR>oAgMenuDinamico.DOFORM ("siswFaturaPendentes WITH 1")<BR>RELEASE glSimplificada<BR>fEnableButtons(oToolPrinc)<BR>'
where oid=35357
go
UPDATE LISTADEOBJETOS SET ESPECIFICACAO=
'PUBLIC glSimplificada<BR>glSimplificada = .T.<BR>FDisableButtons(oToolPrinc)<BR>oAgMenuDinamico.DOFORM ("siswFaturaPendentes WITH 1")<BR>RELEASE glSimplificada<BR>fEnableButtons(oToolPrinc)<BR>'
where oid=35358
go
UPDATE LISTADEOBJETOS SET ESPECIFICACAO=
'PUBLIC glSimplificada<BR>glSimplificada = .f.<BR>FDisableButtons(oToolPrinc)<BR>oAgMenuDinamico.DOFORM ("siswFaturaPendentes WITH 2")<BR>RELEASE glSimplificada<BR>fEnableButtons(oToolPrinc)<BR>'
where oid=35359
go
UPDATE LISTADEOBJETOS SET ESPECIFICACAO=
'PUBLIC glSimplificada<BR>glSimplificada = .T.<BR>FDisableButtons(oToolPrinc)<BR>oAgMenuDinamico.DOFORM ("siswFaturaPendentes WITH 2")<BR>RELEASE glSimplificada<BR>fEnableButtons(oToolPrinc)<BR>'
where oid=35360
go
UPDATE LISTADEOBJETOS SET ESPECIFICACAO='=FDisableButtons(oToolPrinc)Set Procedure To Win1ProcSet Procedure To TrawPro1 AdditiveMImpNfEnt = .t.Do TrawEntr With "3", 0, "Entradas -> Devoluções de Vendas"Set Procedure To Win1ProcSet Procedure To TrawPro1 Additive=fEnableButtons(oToolPrinc)'
WHERE OID=35312
go
