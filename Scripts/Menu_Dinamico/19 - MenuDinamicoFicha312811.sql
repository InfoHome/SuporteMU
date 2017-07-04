insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35101, 1, 1, '1.710', '01/01/01', '01/01/01', ' ', 'Chegada de Pedido sob Encomenda', 36, 36322, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884,1080, 7, 35101, 7, 'RELATORIO_CHEGADA_PEDIDO_ENCOMENDA', 'ESPECIFICACAO', 36322, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao=
'FDisableButtons(OToolPrinc)<BR>SET PROCEDURE TO TradeII\Win1Proc<BR>DO SiswRelChegadaProdSobEncomenda<BR>FEnableButtons(OToolPrinc)<BR>'
where oid=36322
go