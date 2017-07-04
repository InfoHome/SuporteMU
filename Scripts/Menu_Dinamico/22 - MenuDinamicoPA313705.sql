if not exists(select 1 from item where oid = 35702)
begin
	insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
	values (35101, 1, 1, '1.730', '01/01/01', '01/01/01', ' ', 'Frete', 36, 35702, 0)

	insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
	values (1884,1080, 7, 35101, 7, 'RELATORIO_FRETE', 'ESPECIFICACAO', 35702, 'OPCAO_MENU_TRADE')
end
go

if not exists(select 1 from item where oid = 35709)
begin
	insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
	values (35702, 1, 1, '1.730.01', '01/01/01', '01/01/01', ' ', 'Frete', 36, 35709, 0)

	insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
	values (1884,1080, 7, 35702, 7, 'RELATORIO_FRETE', 'ESPECIFICACAO', 35709, 'OPCAO_MENU_TRADE')

	update listadeobjetos set especificacao=
	'FDisableButtons(OToolPrinc)<BR>SET PROCEDURE TO TradeII\Win1Proc ADDITIVE<BR>DO SiswRelFrete<BR>FEnableButtons(OToolPrinc)<BR>'
	where oid=35709
end
go

if not exists(select 1 from item where oid = 35770)
begin
	insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
	values (35702, 1, 1, '1.730.02', '01/01/01', '01/01/01', ' ', 'Frete por Roteiro e Filial', 36, 35770, 0)

	insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
	values (1884,1080, 7, 35702, 7, 'RELATORIO_FRETE_ROTEIRO_FILIAL', 'ESPECIFICACAO', 35770, 'OPCAO_MENU_TRADE')

	update listadeobjetos set especificacao=
	'FDisableButtons(OToolPrinc)<BR>SET PROCEDURE TO TradeII\Win1Proc ADDITIVE<BR>DO SiswRelFreteRoteiroFilial<BR>FEnableButtons(OToolPrinc)<BR>'
	where oid=35770
end
go
