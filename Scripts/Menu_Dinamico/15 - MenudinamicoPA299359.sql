--36310	3.395	Manuten��o de comiss�o por indicador 			
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35665, 1, 1, '3.395', '01/01/01', '01/01/01', ' ', 'Manuten��o de comiss�o por indicador ', 36, 36310, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 34945, 7, 35665, 7, 'MOVIMENTO_MANUTENCAO_COMISS�O_INDICADORES', 'ESPECIFICACAO', 36310, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao=
'SET PROCEDURE TO Win1Proc ADDITIVE<BR>oAgMenuDinamico.DOFORM ("siswmanutencaocomissaoindicador")<BR>SET PROCEDURE TO Win1Proc ADDITIVE<BR>'
where oid=36310
go
