update item set NOME='Modelo 1' where OID=35280
GO
update item set NOME='Modelo 2' where OID=35281
GO
update LISTADEOBJETOS set NOMEINTERNO='RELATORIO_LISTA_DE_OFERTAS_MODELO1' where OID=35280
GO
update LISTADEOBJETOS set NOMEINTERNO='RELATORIO_LISTA_DE_OFERTAS_MODELO2' where OID=35281
GO
update LISTADEOBJETOS set ESPECIFICACAO='=FDisableButtons(OToolEstoq)<BR>Set Procedure To Estoque\EstwProc<BR>Set Procedure To Estoque\EstwPro1 Additive<BR>Set Procedure To Win1Proc Additive<BR>lCadastroSPT = .f.<BR>Do EstwLOAn<BR>=FEnableButtons(OToolEstoq)<BR>'
WHERE OID=35280
GO
update LISTADEOBJETOS set ESPECIFICACAO='=FDisableButtons(OToolEstoq)<BR>Set Procedure To Estoque\EstwProc<BR>Set Procedure To Estoque\EstwPro1 Additive<BR>Set Procedure To Win1Proc Additive<BR>lCadastroSPT = .f.<BR>Do EstwLOAnrEDUZIDO<BR>=FEnableButtons(OToolEstoq)<BR>'
WHERE OID=35281
GO
insert into EXCLUIDO(oid) values (35282)
GO
insert into EXCLUIDO(oid) values (35283)
GO