-- Rel. Posição Fisica Comparativo de Estoque PA 277194
insert into item 
(rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values 
(34966, 1, 1, '1.070.03', '01/01/01', '01/01/01', ' ', 'Comparativo de Estoque', 36, 36703, 0)
insert into listadeobjetos 
(raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values 
(1884, 1080, 7, 34982, 7, 'RELATORIO_POSICAO_FISICA_COMPARATIVO_ESTOQUE','SET PROCEDURE TO tradeii\win1proc<BR>=FDisableButtons(OToolPrinc)<BR>Do siswrelcomparativoestoque<BR>=FEnableButtons(OToolPrinc)<BR>', 36703, 'OPCAO_MENU_TRADE')
go


-- PA 273880 Rel Levantamento de Estoque
update listadeobjetos set especificacao=
'RELATORIO_LEVANTAMENTO_ESTOQUE'
where oid=34982
go

-- Rel. Levantamento Estoque Completo
insert into item 
(rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values 
(34982, 1, 1, '1.070.60.01', '01/01/01', '01/01/01', ' ', 'Completo', 36, 36216, 0)
insert into listadeobjetos 
(raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values 
(1884, 1080, 7, 34982, 7, 'RELATORIO_LEVANTAMENTO_ESTOQUE_COMPLETO', '=FDisableButtons(OToolEstoq)<BR>SET PROCEDURE TO Win1Proc ADDITIVE<BR>DO SiswRelLevantamentoEstoque<BR>=FEnableButtons(OToolEstoq)<BR>', 36216, 'OPCAO_MENU_TRADE')
go
-- Rel. Levantamento Estoque Simplificado
insert into item 
(rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values 
(34982, 1, 1, '1.070.60.02', '01/04/15', '01/04/15', ' ', 'Simplificado', 36, 36217, 0)
insert into listadeobjetos 
(raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values 
(1884, 1080, 7, 34982, 7, 'RELATORIO_LEVANTAMENTO_ESTOQUE_SIMPLIFICADO', '=FDisableButtons(OToolEstoq)<BR>SET PROCEDURE TO Win1Proc ADDITIVE<BR>DO SiswRelLevantamentoEstoque with .T.<BR>=FEnableButtons(OToolEstoq)<BR>', 36217, 'OPCAO_MENU_TRADE')
go

-- PA 272517
--35692	2.060		Consultas->Histórico de Montagem de Carga		
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35102, 1, 1, '2.060', '01/01/01', '01/01/01', ' ', 'Histórico de Montagem de Carga', 36, 35692, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 2110, 7, 35103, 7, 'CONSULTA_HISTORICO_MONTAGEM_CARGA', 'ESPECIFICACAO', 35692, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao=
'=FDisableButtons(OToolPrinc)<BR>Set Procedure To Win1proc Additive<BR>DO FORM SisWConsultaHistoricoRemontagem<BR>=FEnableButtons(OToolPrinc)<BR>'
where oid=35692
go

-- PA 272514
--35690	3.510		Atualização automática de disponibilidade		
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values (35103, 1, 1, '3.510', '01/01/01', '01/01/01', ' ', 'Atualização automática de disponibilidade', 36, 35690, 0)
insert into listadeobjetos (raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values (1884, 34945, 7, 35103, 7, 'MOVIMENTO_ATUALIZACAO_AUTOMATICA_DISPONIBILIDADE', 'ESPECIFICACAO', 35690, 'OPCAO_MENU_TRADE')
go
update listadeobjetos set especificacao=
'=FDisableButtons(OToolPrinc)<BR>Set Procedure To Win1proc<BR>DO FORM siswatualizacaoautomaticadisponibilidade WITH .T.<BR>=FEnableButtons(OToolPrinc)<BR>'
where oid=35690
go

-- Rel. Comissão por area de vendas PA 265243
insert into item 
(rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values 
(34966, 1, 1, '1.210.19', '01/01/01', '01/01/01', ' ', 'Por Área de Vendas', 36, 36218, 0)
insert into listadeobjetos 
(raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values 
(1884, 1080, 7, 34982, 7, 'RELATORIO_COMISSAO_POR_AREA_DE_VENDAS', 'SET PROCEDURE TO tradeii\win1proc<BR>=FDisableButtons(OToolPrinc)<BR>DO siswrelcomissaoareadevendas<BR>=FEnableButtons(OToolPrinc)<BR>', 36218, 'OPCAO_MENU_TRADE')
go

-- PA 285998
-- Rel Valor de Estoque
update listadeobjetos set especificacao=
'RELATORIO_VALOR_ESTOQUE'
where oid=34983
go
-- Rel. Valor Estoque Por Classe
insert into item 
(rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values 
(34983, 1, 1, '1.070.70.01', '23/10/15', '23/10/15', ' ', 'Por Classe', 36, 36305, 0)
insert into listadeobjetos 
(raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values 
(1884, 1080, 7, 34983, 7, 'RELATORIO_VALOR_ESTOQUE_PORCLASSE', '=FDisableButtons(OToolEstoq)<BR>SET PROCEDURE TO Win1Proc ADDITIVE<BR>DO SiswRelValorTotalEstoque WITH 1<BR>=FEnableButtons(OToolEstoq)<BR>', 36305, 'OPCAO_MENU_TRADE')
go

-- Rel. Valor Estoque Por Fornecedor
insert into item 
(rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) 
values 
(34983, 1, 1, '1.070.70.02', '23/10/15', '23/10/15', ' ', 'Por Fornecedor', 36, 36306, 0)
insert into listadeobjetos 
(raplicativo, rcategoria, rtipodeservidor, rdominio, rclassepadrao, nomeinterno, especificacao, oid, mecanismo) 
values 
(1884, 1080, 7, 34983, 7, 'RELATORIO_VALOR_ESTOQUE_PORFORNECEDOR', '=FDisableButtons(OToolEstoq)<BR>SET PROCEDURE TO Win1Proc ADDITIVE<BR>DO SiswRelValorTotalEstoque WITH 2<BR>=FEnableButtons(OToolEstoq)<BR>', 36306, 'OPCAO_MENU_TRADE')
go

-- atualização 09092014
-- muda categoria da opção para tipo CADASTRO, para permitir acessos correspondentes (só não exlui, somente leitura, etc.)
update LISTADEOBJETOS set RCATEGORIA=1085 where OID = 35026
go
update LISTADEOBJETOS set RCATEGORIA=1085 where OID = 35025
go


update LISTADEOBJETOS set ESPECIFICACAO=
'#INCLUDE 'TradeSQL.H'<BR>PUBLIC glSimplificada<BR>glSimplificada = .F.<BR>FDisableButtons(oToolPrinc)<BR>DOFORM ("siswFaturaPendentes WITH 3")<BR>RELEASE glSimplificada<BR>fEnableButtons(oToolPrinc)<BR>'  where OID=35349
'FDisableButtons(oToolPrinc)<BR>PUBLIC glSimplificada<BR>glSimplificada = .F.<BR>oAgMenuDinamico.DOFORM ("siswFaturaPendentes WITH 3")<BR>fEnableButtons(oToolPrinc)<BR>'
go
update LISTADEOBJETOS set ESPECIFICACAO='FDisableButtons(oToolPrinc)<BR>DOFORM ("siswFaturaPendentes WITH 3")<BR>fEnableButtons(oToolPrinc)<BR>'  where OID=35349
update LISTADEOBJETOS set ESPECIFICACAO=
'FDisableButtons(oToolPrinc)<BR>PUBLIC glSimplificada<BR>glSimplificada = .T.<BR>oAgMenuDinamico.DOFORM ("siswFaturaPendentes WITH 3")<BR>glSimplificada = .F.<BR>fEnableButtons(oToolPrinc)<BR>'
where oid=35350
go
UPDATE LISTADEOBJETOS SET ESPECIFICACAO=
'FDisableButtons(oToolPrinc)<BR>PUBLIC glSimplificada<BR>glSimplificada = .F.<BR>oAgMenuDinamico.DOFORM ("siswFaturaPendentes WITH 3")<BR>fEnableButtons(oToolPrinc)<BR>'
WHERE OID=35349
update LISTADEOBJETOS set ESPECIFICACAO=
'FDisableButtons(oToolPrinc)<BR>PUBLIC glSimplificada<BR>glSimplificada = .T.<BR>oAgMenuDinamico.DOFORM ("siswFaturaPendentes WITH 3")<BR>glSimplificada = .F.<BR>fEnableButtons(oToolPrinc)<BR>'
where oid=35350
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


--287901 - SU Trocar Endereço de Entrega
update LISTADEOBJETOS set ESPECIFICACAO='FDisableButtons(oToolPrinc)<BR>oAgMenuDinamico.DOFORM ("siswTrocarenderecoentrega")<BR>fEnableButtons(oToolPrinc)<BR>'  where oid=35435
go



--281301 - MDFe especifico SU Britadora
if not exists(select 1 from OPCSISTCAD where codsis = 'SIS' and codopc = '3.10')
insert into OPCSISTCAD
(codsis,codopc,nomeopc,ativado,numeroativ,mediauso,numdemeses,usoultmes,auditativo,ativporopc,SISUTILIZADO)
values('SIS','3.10','Gerar MDF-e','S',0,0,0,0,'','','P')
go



--283007 - MDFe especifico SU Eletro
if not exists(select 1 from OPCSISTCAD where codsis = 'SIS' and codopc = '3.28')
insert into OPCSISTCAD
(codsis,codopc,nomeopc,ativado,razdesativ,mensagem,numeroativ,mediauso,numdemeses,usoultmes,auditativo,ativporopc)
values('SIS','3.28','Gerar MDF-e','S','','',0,0,0,0,'','')
go


--272756 - MDFe especifico SU HCU
if not exists(select 1 from OPCSISTCAD where codsis = 'SIS' and codopc = '3.59')
insert into OPCSISTCAD(codsis,codopc,nomeopc,ativado,numeroativ,mediauso,numdemeses,usoultmes)
values('SIS','3.59','Gerar MDF-e','S',0,0,0,0)
go



--261118 - MDFe especifico SU ABC
if not exists(select 1 from OPCSISTCAD where codsis = 'SIS' and codopc = '3.29')
insert into OPCSISTCAD(codsis,codopc,nomeopc,ativado,numeroativ,mediauso,numdemeses,usoultmes)
values('SIS','3.29','Gerar MDF-e','S',0,0,0,0)
go



