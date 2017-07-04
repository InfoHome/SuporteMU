--35692	2.060		Consultas->Histórico de Montagem de Carga		
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35102, 1, 1, '2.060', '01/01/01', '01/01/01', ' ', 'Histórico de Montagem de Carga', 36, 35692, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 2110, 7, 35103, 7, 'CONSULTA_HISTORICO_MONTAGEM_CARGA', 'ESPECIFICACAO', 35692, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao=
'=FDisableButtons(OToolPrinc)<BR>Set Procedure To Win1proc Additive<BR>oAgMenuDinamico.DOFORM ("SisWConsultaHistoricoRemontagem")<BR>=FEnableButtons(OToolPrinc)<BR>'
where oid=35692
go

--37346	2.080	2.08	Lista Pendências de produtos		=FDisableButtons(OToolEstoq)<BR>DO FORM siswConsultaPendencias.scx<BR>=FEnableButtons(OToolEstoq)<BR>	35102	
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35102, 1, 1, '2.080', '01/01/01', '01/01/01', ' ', 'Lista Pendências de produtos', 36, 37346, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 2110, 7, 35102, 7, 'LISTA_PENDENCIAS_PRODUTOS', 'ESPECIFICACAO', 37346, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao=
'=FDisableButtons(OToolEstoq)<BR>oAgMenuDinamico.DOFORM ("siswConsultaPendencias.scx")<BR>=FEnableButtons(OToolEstoq)<BR>'
where oid=37346
go

--36307	2.080	3.090.08	Remarcação de preço avançada			
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35033, 1, 1, '3.090.08', '01/01/01', '01/01/01', ' ', 'Remarcação de preços avançada', 36, 36307, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 34945, 7, 35033, 7, 'MOVIMENTO_REMARCACAO_DE_PRECOS_AVANCADA', 'ESPECIFICACAO', 36307, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao=
'fDisableButtons(oToolPrinc)<BR>SET PROCEDURE TO Win1Proc<BR>oAgMenuDinamico.DOFORM ("SiswPesquisaPrecoFuturo with .T.")<BR>fEnableButtons(oToolPrinc)<BR>'
where oid=36307
go

