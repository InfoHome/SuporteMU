update LISTADEOBJETOS set RDOMINIO=34966  where OID=35188
go
update ITEM set RESCOPO=34966  where OID=35188
go
update ITEM set codigo='1.170.14.01' where OID=35208
update ITEM set codigo='1.170.14.02' where OID=35209
go
update ITEM set codigo='1.170.30.01' where OID=35262
update ITEM set codigo='1.170.30.02' where OID=35263
update ITEM set codigo='1.170.30.02.01' where OID=35266
update ITEM set codigo='1.170.30.02.01.01' where OID=35267
update ITEM set codigo='1.170.30.02.01.01.01' where OID=35269
update ITEM set RESCOPO=35267 where OID=35269
update ITEM set codigo='1.170.30.02.01.01.02' where OID=35270
update ITEM set RESCOPO=35267 where OID=35270
update ITEM set codigo='1.170.30.02.01.02' where OID=35268
update ITEM set codigo='1.170.30.02.01.02.01' where OID=35271
update ITEM set codigo='1.170.30.02.01.02.02' where OID=35272
update ITEM set codigo='1.170.30.03' where OID=35264
update ITEM set codigo='1.170.30.04' where OID=35265
update ITEM set codigo='1.170.30.04.01' where OID=35273
update ITEM set codigo='1.170.30.04.01.01' where OID=35274
update ITEM set codigo='1.170.16.01' where OID=35275
update ITEM set codigo='1.170.16.02' where OID=35276
update ITEM set codigo='1.170.16.03' where OID=35277
go
update ITEM set codigo='1.210.19' where OID=36213
update ITEM set RESCOPO=34966 where OID=36213
update LISTADEOBJETOS set RDOMINIO=34966 where OID=36213
go
update ITEM set RESCOPO=35301 where OID=35195
update LISTADEOBJETOS set Rdominio=35301 where OID=35195
go
update ITEM set codigo='1.210.10.01' where OID=35278
update ITEM set codigo='1.210.10.02' where OID=35279
go
update ITEM set RESCOPO=35282 where OID=35285
update LISTADEOBJETOS set RDOMINIO=35282 where OID=35285
go
update ITEM set RESCOPO=35282 where OID=35286
update LISTADEOBJETOS set RDOMINIO=35282 where OID=35286
go
update ITEM set RESCOPO=35282 where OID=35287
update LISTADEOBJETOS set RDOMINIO=35282 where OID=35287
go
update ITEM set codigo='1.400.12.01' where OID=35288
update ITEM set codigo='1.400.12.02' where OID=35289
update ITEM set NOME = 'Modelo 2' where OID=35289
go
update ITEM set codigo='1.400.16.01' where OID=35296
update ITEM set codigo='1.400.16.02' where OID=35297
go
update ITEM set codigo='3.140.06' where OID=35400
update ITEM set codigo='3.140.07' where OID=35401
go
update ITEM set nome='Exportação/Importação' where oid=35666
go
update ITEM set RESCOPO=35666 where OID=35069
update LISTADEOBJETOS set RDOMINIO=35666 where OID=35069
go
update ITEM set RESCOPO=35666 where OID=35070
update LISTADEOBJETOS set RDOMINIO=35666 where OID=35070
go

-----OID INTERNO 37333 - 37355
--37333	1.070.95		Saldo de Produtos Consignados	RELATORIO_SALDO_PRODUTO_CONSIGNADO	RELATORIO_SALDO_PRODUTO_CONSIGNADO	35672	
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35672, 1, 1, '1.070.95', '01/01/01', '01/01/01', ' ', 'Saldo de Produtos Consignados', 36, 37333, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1080, 7, 35672, 7, 'RELATORIO_SALDO_PRODUTO_CONSIGNADO', 'RELATORIO_SALDO_PRODUTO_CONSIGNADO', 37333, 'OPCAO_MENU_TRADE')
go

--37334	1.070.95.01		Analítico	RELATORIO_SALDO_PRODUTO_CONSIGNADO_ANALITICO	=FDisableButtons(OToolEstoq)<BR>Set Procedure To Estoque\EstwProc<BR>Set Procedure To Estoque\EstwPro1 Additive<BR>Set Procedure To Win1Proc Additive<BR>lCadastroSPT = .f.<BR>o SiswSaldoProdutosConsignados WITH 'A'<BR>=FEnableButtons(OToolEstoq)<BR>	37033	
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (37333, 1, 1, '1.070.95.01', '01/01/01', '01/01/01', ' ', 'Analítico', 36, 37334, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1080, 7, 37333, 7, 'RELATORIO_SALDO_PRODUTO_CONSIGNADO_ANALITICO', 'ESPECIFICACAO', 37334, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(OToolEstoq)<BR>Set Procedure To Estoque\EstwProc<BR>Set Procedure To Estoque\EstwPro1 Additive<BR>Set Procedure To Win1Proc Additive<BR>Do SiswSaldoProdutosConsignados WITH ''A''<BR>=FEnableButtons(OToolEstoq)<BR>'
where oid=37334
go

--37335	1.070.95.02		Sintético	RELATORIO_SALDO_PRODUTO_CONSIGNADO_SINTETICO	=FDisableButtons(OToolEstoq)<BR>Set Procedure To Estoque\EstwProc<BR>Set Procedure To Estoque\EstwPro1 Additive<BR>Set Procedure To Win1Proc Additive<BR>lCadastroSPT = .f.<BR>o SiswSaldoProdutosConsignados WITH 'S'<BR>=FEnableButtons(OToolEstoq)<BR>	37033	
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (37333, 1, 1, '1.070.95.01', '01/01/01', '01/01/01', ' ', 'Sintético', 36, 37335, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1080, 7, 37333, 7, 'RELATORIO_SALDO_PRODUTO_CONSIGNADO_SINTETICO', 'ESPECIFICACAO', 37335, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(OToolEstoq)<BR>Set Procedure To Estoque\EstwProc<BR>Set Procedure To Estoque\EstwPro1 Additive<BR>Set Procedure To Win1Proc Additive<BR>Do SiswSaldoProdutosConsignados WITH ''S''<BR>=FEnableButtons(OToolEstoq)<BR>'
where oid=37335
go

--37336	1.070.20.03.07	1.08	Modelo 5	RELATORIO_INVENTARIO_REGISTRO_DE_INVENTARIO_MODELO_5	=FDisableButtons(OToolEstoq)<BR>Set Procedure to Win1Proc<BR>Set procedure to Estoque\EstWProc Additive<BR>Set Procedure to Estoque\EstWPro1 Additive<BR>lCadastroSPT = .f.<BR>Do Estoque\EstWLIR5<BR>=FEnableButtons(OToolEstoq)<BR>	35173	
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35173, 1, 1, '1.070.20.03.07', '01/01/01', '01/01/01', ' ', 'Modelo 5', 36, 37336, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1080, 7, 35173, 7, 'RELATORIO_INVENTARIO_REGISTRO_DE_INVENTARIO_MODELO_5', 'ESPECIFICACAO', 37336, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(OToolEstoq)<BR>Set Procedure to Win1Proc<BR>Set procedure to Estoque\EstWProc Additive<BR>Set Procedure to Estoque\EstWPro1 Additive<BR>lCadastroSPT = .f.<BR>Do Estoque\EstWLIR5<BR>=FEnableButtons(OToolEstoq)<BR>'
where oid=37336
go

--37337	1.110.19	1.86	Avaliação da Qualidade do Fornecedor			35676	
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35676, 1, 1, '1.110.19', '01/01/01', '01/01/01', ' ', 'Avaliação da Qualidade do Fornecedor', 36, 37337, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1080, 7, 35676, 7, 'RELATORIO_AVALIACAO_QUALIDADE_FORNECEDOR', 'RELATORIO_AVALIACAO_QUALIDADE_FORNECEDOR', 37337, 'OPCAO_MENU_TRADE')
go


--37338	1.110.19.01		Analítico		=FDisableButtons(OToolEstoq)<BR>Set Procedure To Win1Proc ADDITIVE<BR>DO siswrelavaliacaoqualidadefornecedor WITH 1<BR>==FEnableButtons(OToolEstoq)<BR>	37037	
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (37337, 1, 1, '1.110.19.01', '01/01/01', '01/01/01', ' ', 'Analítico', 36, 37338, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1080, 7, 37337, 7, 'RELATORIO_AVALIACAO_QUALIDADE_FORNECEDOR_ANALITICO', 'ESPECIFICACAO', 37338, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(OToolEstoq)<BR>Set Procedure To Win1Proc ADDITIVE<BR>DO siswrelavaliacaoqualidadefornecedor WITH 1<BR>==FEnableButtons(OToolEstoq)<BR>'
where oid=37338
go

--37339	1.110.19.02		Sintético		=FDisableButtons(OToolEstoq)<BR>Set Procedure To Win1Proc ADDITIVE<BR>DO siswrelavaliacaoqualidadefornecedor WITH 2<BR>==FEnableButtons(OToolEstoq)<BR>	37037	
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (37337, 1, 1, '1.110.19.02', '01/01/01', '01/01/01', ' ', 'Sintético', 36, 37339, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1080, 7, 37337, 7, 'RELATORIO_AVALIACAO_QUALIDADE_FORNECEDOR_SINTETICO', 'ESPECIFICACAO', 37339, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(OToolEstoq)<BR>Set Procedure To Win1Proc ADDITIVE<BR>DO siswrelavaliacaoqualidadefornecedor WITH 2<BR>==FEnableButtons(OToolEstoq)<BR>'
where oid=37339
go

--37340	1.110.20	1.90	Auxiliar de compras		=FDisableButtons(OToolPrinc)<BR>DO SiswRelAuxiliarCompras<BR>==FEnableButtons(OToolPrinc)<BR>	35676	
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35676, 1, 1, '1.110.20', '01/01/01', '01/01/01', ' ', 'Auxiliar de compras', 36, 37340, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1080, 7, 35676, 7, 'RELATORIO_AUXILIAR_COMPRAS', 'RELATORIO_AUXILIAR_COMPRAS', 37340, 'OPCAO_MENU_TRADE')
go

--37341	1.100.12.02.03	1.13	Mapa de carga simplificado	RELATORIO_MAPA_DA_CARGA_SIMPLIFICADO	set procedure to tradeii\win1proc <BR>=FDisableButtons(OToolPrinc)<BR>do SiswRelatorioMapadaCarga.prg with 4<BR>=FEnableButtons(OToolPrinc)<BR>	35184	
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35184, 1, 1, '1.100.12.02.03', '01/01/01', '01/01/01', ' ', 'Mapa de carga simplificado', 36, 37341, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1080, 7, 35184, 7, 'RELATORIO_MAPA_DA_CARGA_SIMPLIFICADO', 'ESPECIFICACAO', 37341, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='set procedure to tradeii\win1proc <BR>=FDisableButtons(OToolPrinc)<BR>do SiswRelatorioMapadaCarga.prg with 4<BR>=FEnableButtons(OToolPrinc)<BR>'
where oid=37341
go

--37342	1.210.20	1.89	Comissão Recebimento por Produto	RELATORIO_COMISSAO_RECEBIMENTO_POR_PRODUTO		34966	

--37343	1.705	1.87	Listagem M3 Vendidos	RELATORIO_LISTAGEM_M3_VENDIDO		35101	

--37344	2.060	2.06	Liberação de Vendas de Auto-Serviço		=FDisableButtons(OToolEstoq)<BR>Set Procedure To Estoque\EstwProc ADDITIVE<BR>Set Procedure To Estoque\EstwPro1 Additive<BR>Set Procedure To Win1Proc Additive<BR>lCadastroSPT = .f.<BR>DO FORM  trainformacaocliente<BR>=FEnableButtons(OToolEstoq)<BR>	35102	
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35102, 1, 1, '2.060', '01/01/01', '01/01/01', ' ', 'Liberação de Vendas de Auto-Serviço', 36, 37344, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 2110, 7, 35102, 7, 'LIBERACAO_VENDAS_AUTO_SERVICO', 'ESPECIFICACAO', 37344, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(OToolEstoq)<BR>Set Procedure To Estoque\EstwProc ADDITIVE<BR>Set Procedure To Estoque\EstwPro1 Additive<BR>Set Procedure To Win1Proc Additive<BR>lCadastroSPT = .f.<BR>DO FORM  trainformacaocliente<BR>=FEnableButtons(OToolEstoq)<BR>'
where oid=37344
go

--37345	2.070	2.07	Acompanhamento de Vendas		=FDisableButtons(OToolEstoq)<BR>DO FORM siswAcompanhamentoDeVendas.scx WITH 1<BR>=FEnableButtons(OToolEstoq)<BR>	35102	
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35102, 1, 1, '2.070', '01/01/01', '01/01/01', ' ', 'Acompanhamento de Vendas', 36, 37345, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 2110, 7, 35102, 7, 'ACOMPANHAMENTO_VENDAS', 'ESPECIFICACAO', 37345, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(OToolEstoq)<BR>DO FORM siswAcompanhamentoDeVendas.scx WITH 1<BR>=FEnableButtons(OToolEstoq)<BR>'
where oid=37345
go

--37346	2.080	2.08	Lista Pendências de produtos		=FDisableButtons(OToolEstoq)<BR>DO FORM siswConsultaPendencias.scx<BR>=FEnableButtons(OToolEstoq)<BR>	35102	
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35102, 1, 1, '2.080', '01/01/01', '01/01/01', ' ', 'Lista Pendências de produtos', 36, 37346, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 2110, 7, 35102, 7, 'LISTA_PENDENCIAS_PRODUTOS', 'ESPECIFICACAO', 37346, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(OToolEstoq)<BR>DO FORM siswConsultaPendencias.scx<BR>=FEnableButtons(OToolEstoq)<BR>'
where oid=37346
go

--37347	3.490.04	3.57	Exportação de Faturamento BASF		=FDisableButtons(OToolEstoq)<BR>Set Procedure To Trawpro1 Additive<BR>Set Procedure To Win1Proc Additive<BR>DO FORM TrawExportaFaturamentoBASF<BR>=FEnableButtons(OToolEstoq)<BR>	35666	
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35666, 1, 1, '3.490.07', '01/01/01', '01/01/01', ' ', 'Exportação de Faturamento BASF', 36, 37347, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 34945, 7, 35666, 7, 'MOVIMENTO_EXPORTACAO_BASF', 'ESPECIFICACAO', 37347, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(OToolEstoq)<BR>Set Procedure To Trawpro1 Additive<BR>Set Procedure To Win1Proc Additive<BR>DO FORM TrawExportaFaturamentoBASF<BR>=FEnableButtons(OToolEstoq)<BR>'
where oid=37347
go

--37348	3.495	3.58	Controle de Previsão de entrega		=FDisableButtons(oToolPrinc)<BR>Set Procedure To Trawpro1 Additive<BR>Set Procedure To Win1Proc Additive<BR>DO FORM SiswControleDePrevisaoDeEntrega<BR>=FEnableButtons(oToolPrinc)<BR>		
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35103, 1, 1, '3.490.04', '01/01/01', '01/01/01', ' ', 'Controle de Previsão de entrega', 36, 37348, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 34945, 7, 35103, 7, 'MOVIMENTO_CONTROLE_PREVISAO_ENTREGA', 'ESPECIFICACAO', 37348, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(oToolPrinc)<BR>Set Procedure To Trawpro1 Additive<BR>Set Procedure To Win1Proc Additive<BR>DO FORM SiswControleDePrevisaoDeEntrega<BR>=FEnableButtons(oToolPrinc)<BR>'
where oid=37348
go

--37349	4.140	4.14	Metas de venda por filial e markup		=FDisableButtons(oToolPrinc)<BR>Set Procedure To Win1Proc Additive<BR>DO FORM SiswCadastroMetaVendedor WITH 2<BR>=FEnableButtons(oToolPrinc)<BR>		
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35104, 1, 1, '4.140', '01/01/01', '01/01/01', ' ', 'Metas de venda por filial e markup', 36, 37349, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1085, 7, 35104, 7, 'CADASTRO_METAS_DE_VENDA_POR_FILIAL_MARKUP', 'ESPECIFICACAO', 37349, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(oToolPrinc)<BR>Set Procedure To Win1Proc Additive<BR>DO FORM SiswCadastroMetaVendedor WITH 2<BR>=FEnableButtons(oToolPrinc)<BR>'
where oid=37349
go

--37350	4.150	4.15	Metas de venda por fornecedor e markup		=FDisableButtons(oToolPrinc)<BR>Set Procedure To Win1Proc Additive<BR>DO FORM SiswCadastroMetaVendedor WITH 3<BR>=FEnableButtons(oToolPrinc)<BR>		
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35104, 1, 1, '4.150', '01/01/01', '01/01/01', ' ', 'Metas de venda por fornecedor e markup', 36, 37350, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1085, 7, 35104, 7, 'CADASTRO_METAS_DE_VENDA_POR_FORNECEDOR_MARKUP', 'ESPECIFICACAO', 37350, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(oToolPrinc)<BR>Set Procedure To Win1Proc Additive<BR>DO FORM SiswCadastroMetaVendedor WITH 3<BR>=FEnableButtons(oToolPrinc)<BR>'
where oid=37350
go

--37351	4.160	4.16	Metas de venda por vendedor e markup		=FDisableButtons(oToolPrinc)<BR>Set Procedure To Win1Proc Additive<BR>DO FORM SiswCadastroMetaVendedor WITH 4<BR>=FEnableButtons(oToolPrinc)<BR>		
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35104, 1, 1, '4.160', '01/01/01', '01/01/01', ' ', 'Metas de venda por vendedor e markup', 36, 37351, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1085, 7, 35104, 7, 'CADASTRO_METAS_DE_VENDA_POR_VENDEDOR_MARKUP', 'ESPECIFICACAO', 37351, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(oToolPrinc)<BR>Set Procedure To Win1Proc Additive<BR>DO FORM SiswCadastroMetaVendedor WITH 4<BR>=FEnableButtons(oToolPrinc)<BR>'
where oid=37351
go

--37352	4.170	4.17	Comissão por meta de vendas		=FDisableButtons(oToolPrinc)<BR>Set Procedure To Win1Proc Additive<BR>DO FORM siswComissaoPorMetaDeVendas<BR>=FEnableButtons(oToolPrinc)<BR>IF TYPE('oToolPrinc') = 'O'		
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35104, 1, 1, '4.170', '01/01/01', '01/01/01', ' ', 'Comissão por meta de vendas', 36, 37352, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1085, 7, 35104, 7, 'CADASTRO_COMISSAO_METAS_DE_VENDA', 'ESPECIFICACAO', 37352, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(oToolPrinc)<BR>Set Procedure To Win1Proc Additive<BR>DO FORM siswComissaoPorMetaDeVendas<BR>=FEnableButtons(oToolPrinc)<BR>IF TYPE(''oToolPrinc'') = ''O'''
where oid=37352
go

--37353	4.180	4.18	Comissão Por Classificação		=FDisableButtons(oToolPrinc)<BR>Set Procedure To Win1Proc Additive<BR>DO FORM cadwComissaoPorClassificacao<BR>=FEnableButtons(oToolPrinc)<BR>IF TYPE('oToolPrinc') = 'O'		
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35104, 1, 1, '4.180', '01/01/01', '01/01/01', ' ', 'Comissão Por Classificação', 36, 37353, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1085, 7, 35104, 7, 'CADASTRO_COMISSAO_POR_CLASSIFICACAO', 'ESPECIFICACAO', 37353, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(oToolPrinc)<BR>Set Procedure To Win1Proc Additive<BR>DO FORM cadwComissaoPorClassificacao<BR>=FEnableButtons(oToolPrinc)<BR>IF TYPE(''oToolPrinc'') = ''O'''
where oid=37353
go

--37354	4.190	4.19	Fator de Redução de Comissão		=FDisableButtons(oToolPrinc)<BR>Set Procedure To Win1Proc Additive<BR>DO FORM cadwFatorReducaoComissao<BR>=FEnableButtons(oToolPrinc)<BR>IF TYPE('oToolPrinc') = 'O'		
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35104, 1, 1, '4.190', '01/01/01', '01/01/01', ' ', 'Fator de Redução de Comissão', 36, 37354, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1085, 7, 35104, 7, 'CADASTRO_FATOR_REDUCAO_COMISSAO', 'ESPECIFICACAO', 37354, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(oToolPrinc)<BR>Set Procedure To Win1Proc Additive<BR>DO FORM cadwFatorReducaoComissao<BR>=FEnableButtons(oToolPrinc)<BR>IF TYPE(''oToolPrinc'') = ''O'''
where oid=37354
go

--37355	5.120	5.12	Limite de Faturamento por Conta Corrente				
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35104, 1, 1, '5.120', '01/01/01', '01/01/01', ' ', 'Fator de Redução de Comissão', 36, 37355, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 1085, 7, 35104, 7, 'CADASTRO_FATOR_REDUCAO_COMISSAO', 'ESPECIFICACAO', 37355, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao='=FDisableButtons(oToolPrinc)<BR>Set Procedure To Win1Proc Additive<BR>DO FORM cadwFatorReducaoComissao<BR>=FEnableButtons(oToolPrinc)<BR>IF TYPE(''oToolPrinc'') = ''O'''
where oid=37355
go

--37356	5.130	5.13	Avaliação da Qualidade do Fornecedor				

--37357	5.140	5.14	Comissão por faixa de descontos				

-- ficha 258630
update LISTADEOBJETOS_R 
set ESPECIFICACAO = '=FDisableButtons(OToolPrinc)<BR>Sistema = "cad"<BR>SET PROCEDURE TO TradeII\Win1Proc<BR>SET PROCEDURE TO Cadastro\CadWProc ADDITIVE<BR>SET PROCEDURE TO Estoque\EstWPro1 ADDITIVE<BR>oAgMenuDinamico.DOFORM ("Cadastro\CadWProd")<BR>Sistema = "sis"<BR>SET PROCEDURE TO TradeII\Win1Proc<BR>=FEnableButtons(OToolPrinc)<BR>'
where oid = 35423
