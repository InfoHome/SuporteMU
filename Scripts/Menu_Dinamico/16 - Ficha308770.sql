--36314	1.210.15	Comissão por Meta de Vendas
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (34966, 1, 1, '1.210.15', '01/01/01', '01/01/01', ' ', 'Comissão por Meta de Vendas', 36, 36314, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884,1080, 7, 34966, 7, 'RELATORIO_COMISSAO_META_VENDAS', 'ESPECIFICACAO', 36314, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao=
'FDisableButtons(OToolPrinc)<BR>SET PROCEDURE TO TradeII\Win1Proc<BR>DO siswrelcomissaopormetadevendas<BR>FEnableButtons(OToolPrinc)<BR>'
where oid=36314
go