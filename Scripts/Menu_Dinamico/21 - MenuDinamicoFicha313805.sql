--37791	3.125	Cálculo de Rentabilidade 			
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35103, 1, 1, '3.125', '01/01/01', '01/01/01', ' ', 'Cálculo de Rentabilidade', 36, 37791, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 34945, 7, 35665, 7, 'MOVIMENTO_CALCULO_RENTABILIDADE', 'ESPECIFICACAO', 37791, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao=
'FDisableButtons(oToolPrinc)<BR>oAgMenuDinamico.DOFORM ("bcomisrt")<BR>fEnableButtons(oToolPrinc)<BR>'
where oid=37791
go
-- Diário de saídas
update item set rescopo=35291 where oid in (35294,35295)
go
update listadeobjetos set rdominio=35291 where oid in (35294,35295)
go
