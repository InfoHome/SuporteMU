-------------------------------------------------------------------------------------------
------------ SCRIPTs NECESS�RIOS PARA O PROCESSAMENTO DAS NTs e NF-e em GERAL -------------
-------------------------------------------------------------------------------------------

--------------------- SEM IDENTIFICA��O DO PA ----------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'CEANTRIB') 
alter TABLE dbo.DADOSITEMNFE add CEANTRIB CHAR(20) NULL
go

--------------------- PA 220750 ------------------------

IF NOT EXISTS (SELECT 1 FROM SYSCOLUMNS WHERE name = 'CPRODANP' and syscolumns.id IN (SELECT ID FROM SYSOBJECTS WHERE xtype='U' AND name='DADOSITEMNFE'))
alter table dadositemnfe add cprodanp numeric(9) NOT NULL DEFAULT 0
Go

IF NOT EXISTS (SELECT 1 FROM SYSCOLUMNS WHERE name = 'UFCONS' and syscolumns.id IN (SELECT ID FROM SYSOBJECTS WHERE xtype='U' AND name='DADOSITEMNFE'))
alter table dadositemnfe add Ufcons varchar(2) not null DEFAULT ''
Go

--------------------- PA 254295 ------------------------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'NFCI') 
alter TABLE dbo.DADOSITEMNFE add NFCI VARCHAR(100)
go

--------------------- PA 256081 ------------------------

IF NOT EXISTS (SELECT 1 FROM SYSCOLUMNS WHERE name = 'vICMSDeson' and syscolumns.id IN (SELECT ID FROM SYSOBJECTS WHERE xtype='U' AND name='DadosItemNfe')) 
ALTER TABLE DadosNotaNfe ADD vICMSDeson NUMERIC(15,2)
go

IF NOT EXISTS (SELECT 1 FROM SYSCOLUMNS WHERE name = 'vICMSDeson' and syscolumns.id IN (SELECT ID FROM SYSOBJECTS WHERE xtype='U' AND name='DadosItemNfe')) 
ALTER TABLE DadosItemNfe ADD vICMSDeson NUMERIC(15,2)
go

--------------------- PA 258904 ------------------------

IF NOT EXISTS (SELECT 1 FROM SYSCOLUMNS C JOIN SYSOBJECTS T ON C.ID = T.ID AND T.XTYPE = 'U'
WHERE T.NAME = 'CLAFISCCAD' AND C.NAME = 'CSTPIS_SAIDA_LP')
ALTER TABLE dbo.CLAFISCCAD 
ADD CSTPIS_SAIDA_LP CHAR(2), 
CSTCOFINS_SAIDA_LP CHAR(2),
CSTPIS_ENTRADA_LP CHAR(2),
CSTCOFINS_ENTRADA_LP CHAR(2),
ALIQUOTA_PIS_LP NUMERIC(5,2),
ALIQUOTA_COFINS_LP NUMERIC(5,2),
ALIQCOFINSIMPORTACAO_LP NUMERIC(5,2)
go

--------------------- PA 261679 ------------------------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSNOTANFE' AND COLUMN_NAME = 'idDest') 
	ALTER TABLE DBO.DADOSNOTANFE ADD idDest SMALLINT DEFAULT 1
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSNOTANFE' AND COLUMN_NAME = 'IndFinal') 
	ALTER TABLE DBO.DADOSNOTANFE ADD IndFinal SMALLINT  DEFAULT 0
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSNOTANFE' AND COLUMN_NAME = 'IndPres') 
	ALTER TABLE DBO.DADOSNOTANFE ADD IndPres SMALLINT  DEFAULT 1
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSNOTANFE' AND COLUMN_NAME = 'IdEstrangeiro') 
	ALTER TABLE DBO.DADOSNOTANFE ADD IdEstrangeiro CHAR(20) DEFAULT ''
go	
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSNOTANFE' AND COLUMN_NAME = 'IndIeDest') 
	ALTER TABLE DBO.DADOSNOTANFE ADD IndIeDest SMALLINT 
go
IF EXISTS (SELECT name FROM sysobjects WHERE name = 'COMPLEMENTONFSAIDA_I' AND type = 'TR')
   drop trigger COMPLEMENTONFSAIDA_I
go

CREATE TRIGGER COMPLEMENTONFSAIDA_I ON COMPLEMENTONFSAIDA FOR INSERT AS
BEGIN
    UPDATE COMPLEMENTONFSAIDA SET DTEMIS = GETDATE() WHERE NUMORD = (SELECT NUMORD FROM INSERTED)
    RETURN
END
GO

IF not EXISTS (SELECT 1 FROM DADOADICIONAL WHERE OID = 37387) insert into dadoadicional ( RCLASSECONCRETA,RAPLICATIVO,RDOMINIO,RLISTA,RTIPO,RITEM,RESTRICAO,VISIVEL,MASCARA,PADRAO,MAXIMO,MINIMO,VALOR,OID) values (7,7    ,7,7,1013,44,0,0,'','',1,0,'Identificador estrangeiro',37387)
go

----------------------- PA 272183 -------------------------

-- Adicionando coluna NUMORDNFENTRA na tabela REFERENCIANFCOMPLEMENTAR

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'REFERENCIANFCOMPLEMENTAR' AND COLUMN_NAME = 'NUMORDNFENTRA') 
alter TABLE dbo.REFERENCIANFCOMPLEMENTAR add NUMORDNFENTRA INT NULL
go

----------------------- PA 274603 -------------------------

-- Adicionando coluna INFADFISCO na tabela DADOSNOTANFE

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSNOTANFE' AND COLUMN_NAME = 'INFADFISCO') 
alter TABLE dbo.DADOSNOTANFE add INFADFISCO VARCHAR(200) NULL
go

IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37589)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7 ,1,1,' ','01/01/01','01/01/01','Define qual o CST deve ser utilizado na emiss�o da nota fiscal de devolu��o de compra com substitui��o tribut�ria.','CST para nota de devolu��o de compra com substitui��o tribut�ria',18,37589,0)
go

IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37589)
insert into categoria (rsuper, nomeinterno, oid) values (11767,'CST_NOTA_DEVOLUCAO_COMPRA_COM_ST',37589)
go

IF not EXISTS (SELECT 1 FROM DADOADICIONAL WHERE OID = 37588)
insert into dadoadicional ( RCLASSECONCRETA,RAPLICATIVO,RDOMINIO,RLISTA,RTIPO,RITEM,RESTRICAO,VISIVEL,MASCARA,PADRAO,MAXIMO,MINIMO,VALOR,OID) values (7,1884 ,15812,7,37589,10124,0,0,'999',' ',0,0,'',37588)
go

IF not EXISTS (SELECT 1 FROM ADITIVO WHERE OID = 37590)
insert into aditivo (RITEM,RDEFINICAO,SVALOR,OID) values (1 ,37588,'',37590)
go

IF not EXISTS (SELECT 1 FROM TPOINTEGRACAO WHERE OID = 37591)
insert into tpointegracao (RAPLICATIVO,RLISTA,RDOMINIO,TIPO,PADRAO,QUESTAO,NOMEINTERNO,OID)
values (1884 ,7,15812,50,'','Utilizado na devolu��o','UTILIZADO_DEVOLUCAO',37591)
go

IF not EXISTS (SELECT 1 FROM TPOINTEGRACAO WHERE OID = 37592)
insert into tpointegracao (RAPLICATIVO,RLISTA,RDOMINIO,TIPO,PADRAO,QUESTAO,NOMEINTERNO,OID)
values (1884 ,7,15812,50,'','Exigir justificativa na emiss�o da NFe','EXIGIR_JUSTIFICATIVA_NFE',37592)
go

----------------------- PA 285317 -------------------------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ITNFSAICOMPLEMENTO' AND COLUMN_NAME = 'CENQIPI') 
   ALTER TABLE ITNFSAICOMPLEMENTO ADD CENQIPI CHAR(3)
GO
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ITNFENTCOMPLEMENTO' AND COLUMN_NAME = 'CENQIPI') 
   ALTER TABLE ITNFENTCOMPLEMENTO ADD CENQIPI CHAR(3)
GO
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'CENQIPI') 
   ALTER TABLE DADOSITEMNFE ADD CENQIPI CHAR(3)
GO
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE xtype='U' AND name='CodigoEnqIpi') 
BEGIN
create table CodigoEnqIpi (
       CODIGO CHAR(3) NOT NULL,
       GRUPOCST VARCHAR(100),
       DESCRICAO VARCHAR(500))
alter table CodigoEnqIpi ADD CONSTRAINT PK_CodigoEnqIpi PRIMARY KEY CLUSTERED(CODIGO)
END
GO

IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE xtype='U' AND name='CodigoEnqIpi') 
BEGIN   

  DELETE FROM CODIGOENQIPI WHERE CODIGO >= '001' AND CODIGO <= '140'
 
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('001','Imunidade','Livros, jornais, peri�dicos e o papel destinado � sua impress�o - Art. 18 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('002','Imunidade','Produtos industrializados destinados ao exterior - Art. 18 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('003','Imunidade','Ouro, definido em lei como ativo financeiro ou instrumento cambial - Art. 18 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('004','Imunidade','Energia el�trica, derivados de petr�leo, combust�veis e minerais do Pa�s - Art. 18 Inciso IV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('005','Imunidade','Exporta��o de produtos nacionais - sem sa�da do territ�rio brasileiro - venda para empresa sediada no exterior - atividades de pesquisa ou lavra de jazidas de petr�leo e de g�s natural - Art. 19 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('006','Imunidade','Exporta��o de produtos nacionais - sem sa�da do territ�rio brasileiro - venda para empresa sediada no exterior - incorporados a produto final exportado para o Brasil - Art. 19 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('007','Imunidade','Exporta��o de produtos nacionais - sem sa�da do territ�rio brasileiro - venda para �rg�o ou entidade de governo estrangeiro ou organismo internacional de que o Brasil seja membro,para ser entregue, no Pa�s, � ordem do comprador - Art. 19 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('101','Suspens�o','�leo de menta em bruto, produzido por lavradores - Art. 43 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('102','Suspens�o','Produtos remetidos � exposi��o em feiras de amostras e promo��es semelhantes - Art. 43 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('103','Suspens�o','Produtos remetidos a dep�sitos fechados ou armaz�ns-gerais, bem assim aqueles devolvidos ao remetente - Art. 43 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('104','Suspens�o','Produtos industrializados, que com mat�rias-primas (MP), produtos intermedi�rios (PI) e material de embalagem (ME) importados submetidos a regime aduaneiro especial (drawback - suspens�o/isen��o), remetidos diretamente a empresas industriais exportadoras - Art. 43 Inciso IV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('105','Suspens�o','Produtos, destinados � exporta��o, que saiam do estabelecimento industrial para empresas comerciais exportadoras, com o fim espec�fico de exporta��o - Art. 43, Inciso V, al�nea "a" do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('106','Suspens�o','Produtos, destinados � exporta��o, que saiam do estabelecimento industrial para recintos alfandegados onde se processe o despacho aduaneiro de exporta��o - Art. 43, Inciso V, al�neas "b" do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('107','Suspens�o','Produtos, destinados � exporta��o, que saiam do estabelecimento industrial para outros locais onde se processe o despacho aduaneiro de exporta��o - Art. 43, Inciso V, al�neas "c" do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('108','Suspens�o','Mat�rias-primas (MP), produtos intermedi�rios (PI) e material de embalagem (ME) destinados ao executor de industrializa��o por encomenda - Art. 43 Inciso VI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('109','Suspens�o','Produtos industrializados por encomenda remetidos ao estabelecimento de origem - Art. 43 Inciso VII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('110','Suspens�o','Mat�rias-primas ou produtos intermedi�rios remetidos para emprego em opera��o industrial realizada pelo remetente fora do estabelecimento - Art. 43 Inciso VIII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('111','Suspens�o','Ve�culo, aeronave ou embarca��o destinados a emprego em provas de engenharia pelo fabricante - Art. 43 Inciso IX do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('112','Suspens�o','Produtos remetidos, para industrializa��o ou com�rcio, de um para outro estabelecimento da mesma firma - Art. 43 Inciso X do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('113','Suspens�o','Bens do ativo permanente remetidos a outro estabelecimento da mesma firma, para serem utilizados no processo industrial do recebedor - Art. 43 Inciso XI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('114','Suspens�o','Bens do ativo permanente remetidos a outro estabelecimento, para serem utilizados no processo industrial de produtos encomendados pelo remetente - Art. 43 Inciso XII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('115','Suspens�o','Partes e pe�as destinadas ao reparo de produtos com defeito de fabrica��o, quando a opera��o for executada gratuitamente, em virtude de garantia - Art. 43 Inciso XIII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('116','Suspens�o','Mat�rias-primas (MP), produtos intermedi�rios (PI) e material de embalagem (ME) de fabrica��o nacional, vendidos a estabelecimento industrial, para industrializa��o de produtos destinados � exporta��o ou a estabelecimento comercial, para industrializa��o em outro estabelecimento da mesma firma ou de terceiro, de produto destinado � exporta��o Art. 43 Inciso XIV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('117','Suspens�o','Produtos para emprego ou consumo na industrializa��o ou elabora��o de produto a ser exportado, adquiridos no mercado interno ou importados - Art. 43 Inciso XV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('118','Suspens�o','Bebidas alc�olicas e demais produtos de produ��o nacional acondicionados em recipientes de capacidade superior ao limite m�ximo permitido para venda a varejo - Art. 44 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('119','Suspens�o','Produtos classificados NCM 21.06.90.10 Ex 02, 22.01, 22.02, exceto os Ex 01 e Ex 02 do C�digo 22.02.90.00 e 22.03 sa�dos de estabelecimento industrial destinado a comercial equiparado a industrial - Art. 45 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('120','Suspens�o','Produtos classificados NCM 21.06.90.10 Ex 02, 22.01, 22.02, exceto os Ex 01 e Ex 02 do C�digo 22.02.90.00 e 22.03 sa�dos de estabelecimento comercial equiparado a industrial destinado a equiparado a industrial - Art. 45 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('121','Suspens�o','Produtos classificados NCM 21.06.90.10 Ex 02, 22.01, 22.02, exceto os Ex 01 e Ex 02 do C�digo 22.02.90.00 e 22.03 sa�dos de importador destinado a equiparado a industrial - Art.45 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('122','Suspens�o','Mat�rias-primas (MP), produtos intermedi�rios (PI) e material de embalagem (ME) destinados a estabelecimento que se dedique � elabora��o de produtos classificados nos c�digos previstos no art. 25 da Lei 10.684/2003 - Art. 46 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('123','Suspens�o','Mat�rias-primas (MP), produtos intermedi�rios (PI) e material de embalagem (ME) adquiridos por estabelecimentos industriais fabricantes de partes e pe�as destinadas a estabelecimento industrial fabricante de produto classificado no Cap�tulo 88 da Tipi - Art. 46 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('124','Suspens�o','Mat�rias-primas (MP), produtos intermedi�rios (PI) e material de embalagem (ME) adquiridos por pessoas jur�dicas preponderantemente exportadoras - Art. 46 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('125','Suspens�o','Materiais e equipamentos destinados a embarca��es pr�-registradas ou registradas no Registro Especial Brasileira - REB quando adquiridos por estaleiros navais brasileiros - Art. 46 Inciso IV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('126','Suspens�o','Aquisi��o por benefici�rio de regime aduaneiro suspensivo do imposto, destinado a industrializa��o para exporta��o - Art. 47 do Decreto 7.212/2010') 
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('127','Suspens�o','Desembara�o de produtos de proced�ncia estrangeira importados por lojas francas - Art. 48 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('128','Suspens�o','Desembara�o de maquinas, equipamentos, ve�culos, aparelhos e instrumentos sem similar nacional importados por empresas nacionais de engenharia, destinados � execu��o de obras no exterior - Art. 48 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('129','Suspens�o','Desembara�o de produtos de proced�ncia estrangeira com sa�da de reparti��es aduaneiras com Suspens�o do Imposto de Importa��o - Art. 48 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('130','Suspens�o','Desembara�o de mat�rias-primas, produtos intermedi�rios e materiais de embalagem, importados diretamente por estabelecimento de que tratam os incisos I a III do caput do Decreto 7.212/2010 - Art. 48 Inciso IV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('131','Suspens�o','Remessa de produtos para a ZFM destinados ao seu consumo interno, utiliza��o ou industrializa��o - Art. 84 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('132','Suspens�o','Remessa de produtos para a ZFM destinados � exporta��o - Art. 85 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('133','Suspens�o','Produtos que, antes de sua remessa � ZFM, forem enviados pelo seu fabricante a outro estabelecimento, para industrializa��o adicional, por conta e ordem do destinat�rio - Art. 85 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('134','Suspens�o','Desembara�o de produtos de proced�ncia estrangeira importados pela ZFM quando ali consumidos ou utilizados, exceto armas, muni��es, fumo, bebidas alco�licas e autom�veis de passageiros. - Art. 86 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('135','Suspens�o','Remessa de produtos para a Amaz�nia Ocidental destinados ao seu consumo interno ou utiliza��o - Art. 96 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('136','Suspens�o','Entrada de produtos estrangeiros na �rea de Livre Com�rcio de Tabatinga - ALCT destinados ao seu consumo interno ou utiliza��o - Art. 106 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('137','Suspens�o','Entrada de produtos estrangeiros na �rea de Livre Com�rcio de Guajar�-Mirim - ALCGM destinados ao seu consumo interno ou utiliza��o - Art. 109 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('138','Suspens�o','Entrada de produtos estrangeiros nas �reas de Livre Com�rcio de Boa Vista - ALCBV e Bomfim - ALCB destinados a seu consumo interno ou utiliza��o - Art. 112 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('139','Suspens�o','Entrada de produtos estrangeiros na �rea de Livre Com�rcio de Macap� e Santana - ALCMS destinados a seu consumo interno ou utiliza��o - Art. 116 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('140','Suspens�o','Entrada de produtos estrangeiros nas �reas de Livre Com�rcio de Brasil�ia - ALCB e de Cruzeiro do Sul - ALCCS destinados a seu consumo interno ou utiliza��o - Art. 119 do Decreto 7.212/2010')

END
GO

IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE xtype='U' AND name='CodigoEnqIpi') 
BEGIN   

  DELETE FROM CODIGOENQIPI WHERE CODIGO >= '141' AND CODIGO <= '324'

  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('141','Suspens�o','Remessa para Zona de Processamento de Exporta��o - ZPE - Art. 121 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('142','Suspens�o','Setor Automotivo - Desembara�o aduaneiro, chassis e outros - regime aduaneiro especial - industrializa��o 87.01 a 87.05 - Art. 136, I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('143','Suspens�o','Setor Automotivo - Do estabelecimento industrial produtos 87.01 a 87.05 da TIPI - mercado interno - empresa comercial atacadista controlada por PJ encomendante do exterior. - Art. 136, II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('144','Suspens�o','Setor Automotivo - Do estabelecimento industrial - chassis e outros classificados nas posi��es 84.29, 84.32, 84.33, 87.01 a 87.06 e 87.11 da TIPI. - Art. 136, III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('145','Suspens�o','Setor Automotivo - Desembara�o aduaneiro, chassis e outros classificados nas posi��es 84.29, 84.32, 84.33, 87.01 a 87.06 e 87.11 da TIPI quando importados diretamente por estabelecimento industrial - Art. 136, IV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('146','Suspens�o','Setor Automotivo - do estabelecimento industrial mat�rias-primas, os produtos intermedi�rios e os materiais de embalagem, adquiridos por fabricantes, preponderantemente, de componentes, chassis e outros classificados nos C�digos 84.29, 8432.40.00, 8432.80.00, 8433.20, 8433.30.00, 8433.40.00, 8433.5 e 87.01 a 87.06 da TIPI - Art. 136, V do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('147','Suspens�o','Setor Automotivo - Desembara�o aduaneiro, as mat�rias-primas, os produtos intermedi�rios e os materiais de embalagem, importados diretamente por fabricantes, preponderantemente, de componentes, chassis e outros classificados nos C�digos 84.29, 8432.40.00, 8432.80.00, 8433.20, 8433.30.00, 8433.40.00, 8433.5 e 87.01 a 87.06 da TIPI - Art. 136, VI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('148','Suspens�o','Bens de Inform�tica e Automa��o - mat�rias-primas, os produtos intermedi�rios e os materiais de embalagem, quando adquiridos por estabelecimentos industriais fabricantes dos referidos bens. - Art. 148 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('149','Suspens�o','Reporto - Sa�da de Estabelecimento de m�quinas e outros quando adquiridos por benefici�rios do REPORTO - Art. 166, I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('150','Suspens�o','Reporto - Desembara�o aduaneiro de m�quinas e outros quando adquiridos por benefici�rios do REPORTO - Art. 166, II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('151','Suspens�o','Repes - Desembara�o aduaneiro - bens sem similar nacional importados por benefici�rios do REPES - Art. 171 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('152','Suspens�o','Recine - Sa�da para benefici�rio do regime - Art. 14, III da Lei 12.599/2012')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('153','Suspens�o','Recine - Desembara�o aduaneiro por benefici�rio do regime - Art. 14, IV da Lei 12.599/2012')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('154','Suspens�o','Reif - Sa�da para benefici�rio do regime - Lei 12.794/1013, art. 8, III')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('155','Suspens�o','Reif - Desembara�o aduaneiro por benefici�rio do regime - Lei 12.794/1013, art. 8, IV')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('156','Suspens�o','Repnbl-Redes - Sa�da para benefici�rio do regime - Lei n� 12.715/2012, art. 30, II')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('157','Suspens�o','Recompe - Sa�da de mat�rias-primas e produtos intermedi�rios para benefici�rios do regime - Decreto n� 7.243/2010, art. 5�, I')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('158','Suspens�o','Recompe - Sa�da de mat�rias-primas e produtos intermedi�rios destinados a industrializa��o de equipamentos - Programa Est�mulo Universidade-Empresa - Apoio � Inova��o - Decreto n� 7.243/2010, art. 5�, III')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('159','Suspens�o','Rio 2016 - Produtos nacionais, dur�veis, uso e consumo dos eventos, adquiridos pelas pessoas jur�dicas mencionadas no � 2o do art. 4o da Lei n� 12.780/2013 - Lei n� 12.780/2013, Art. 13')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('301','Isen��o','Produtos industrializados por institui��es de educa��o ou de assist�ncia social, destinados a uso pr�prio ou a distribui��o gratuita a seus educandos ou assistidos - Art. 54 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('302','Isen��o','Produtos industrializados por estabelecimentos p�blicos e aut�rquicos da Uni�o, dos Estados, do Distrito Federal e dos Munic�pios, n�o destinados a com�rcio - Art. 54 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('303','Isen��o','Amostras de produtos para distribui��o gratuita, de diminuto ou nenhum valor comercial - Art. 54 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('304','Isen��o','Amostras de tecidos sem valor comercial - Art. 54 Inciso IV do Decreto 7.212/2010') 
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('305','Isen��o','P�s isolados de cal�ados - Art. 54 Inciso V do Decreto 7.212/2010') 
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('306','Isen��o','Aeronaves de uso militar e suas partes e pe�as, vendidas � Uni�o - Art. 54 Inciso VI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('307','Isen��o','Caix�es funer�rios - Art. 54 Inciso VII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('308','Isen��o','Papel destinado � impress�o de m�sicas - Art. 54 Inciso VIII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('309','Isen��o','Panelas e outros artefatos semelhantes, de uso dom�stico, de fabrica��o r�stica, de pedra ou barro bruto - Art. 54 Inciso IX do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('310','Isen��o','Chap�us, roupas e prote��o, de couro, pr�prios para tropeiros - Art. 54 Inciso X do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('311','Isen��o','Material b�lico, de uso privativo das For�as Armadas, vendido � Uni�o - Art. 54 Inciso XI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('312','Isen��o','Autom�vel adquirido diretamente a fabricante nacional, pelas miss�es diplom�ticas e reparti��es consulares de car�ter permanente, ou seus integrantes, bem assim pelas representa��es internacionais ou regionais de que o Brasil seja membro, e seus funcion�rios, peritos, t�cnicos e consultores, de nacionalidade estrangeira, que exer�am fun��es de car�ter permanente - Art. 54 Inciso XII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('313','Isen��o','Ve�culo de fabrica��o nacional adquirido por funcion�rio das miss�es diplom�ticas acreditadas junto ao Governo Brasileiro - Art. 54 Inciso XIII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('314','Isen��o','Produtos nacionais sa�dos diretamente para Lojas Francas - Art. 54 Inciso XIV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('315','Isen��o','Materiais e equipamentos destinados a Itaipu Binacional - Art. 54 Inciso XV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('316','Isen��o','Produtos Importados por miss�es diplom�ticas, consulados ou organismo internacional - Art. 54 Inciso XVI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('317','Isen��o','Bagagem de passageiros desembara�ada com isen��o do II. - Art. 54 Inciso XVII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('318','Isen��o','Bagagem de passageiros desembara�ada com pagamento do II. - Art. 54 Inciso XVIII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('319','Isen��o','Remessas postais internacionais sujeitas a tributa��o simplificada. - Art. 54 Inciso XIX do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('320','Isen��o','M�quinas e outros destinados � pesquisa cient�fica e tecnol�gica - Art. 54 Inciso XX do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('321','Isen��o','Produtos de proced�ncia estrangeira, isentos do II conforme Lei n� 8032/1990. - Art. 54 Inciso XXI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('322','Isen��o','Produtos de proced�ncia estrangeira utilizados em eventos esportivos - Art. 54 Inciso XXII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('323','Isen��o','Ve�culos automotores, m�quinas, equipamentos, bem assim suas partes e pe�as separadas, destinadas � utiliza��o nas atividades dos Corpos de Bombeiros - Art. 54 Inciso XXIII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('324','Isen��o','Produtos importados para consumo em congressos, feiras e exposi��es - Art. 54 Inciso XXIV do Decreto 7.212/2010')

END
GO

IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE xtype='U' AND name='CodigoEnqIpi') 
BEGIN   

  DELETE FROM CODIGOENQIPI WHERE CODIGO >= '325' AND CODIGO <= '999'
  
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('325','Isen��o','Bens de inform�tica, Mat�ria Prima, produtos intermedi�rios e embalagem destinados a Urnas eletr�nicas - TSE - Art. 54 Inciso XXV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('326','Isen��o','Materiais, equipamentos, m�quinas, aparelhos e instrumentos, bem assim os respectivos acess�rios, sobressalentes e ferramentas, que os acompanhem, destinados � constru��o do Gasoduto Brasil - Bol�via - Art. 54 Inciso XXVI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('327','Isen��o','Partes, pe�as e componentes, adquiridos por estaleiros navais brasileiros, destinados ao emprego na conserva��o, moderniza��o, convers�o ou reparo de embarca��es registradas no Registro Especial Brasileiro - REB - Art. 54 Inciso XXVII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('328','Isen��o','Aparelhos transmissores e receptores de radiotelefonia e radiotelegrafia; ve�culos para patrulhamento policial; armas e muni��es, destinados a �rg�os de seguran�a p�blica da Uni�o, dos Estados e do Distrito Federal - Art. 54 Inciso XXVIII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('329','Isen��o','Autom�veis de passageiros de fabrica��o nacional destinados � utiliza��o como t�xi adquiridos por motoristas profissionais - Art. 55 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('330','Isen��o','Autom�veis de passageiros de fabrica��o nacional destinados � utiliza��o como t�xi por impedidos de exercer atividade por destrui��o, furto ou roubo do ve�culo adquiridos por motoristas profissionais. - Art. 55 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('331','Isen��o','Autom�veis de passageiros de fabrica��o nacional destinados � utiliza��o como t�xi adquiridos por cooperativas de trabalho. - Art. 55 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('332','Isen��o','Autom�veis de passageiros de fabrica��o nacional, destinados a pessoas portadoras de defici�ncia f�sica, visual, mental severa ou profunda, ou autistas - Art. 55 Inciso IV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('333','Isen��o','Produtos estrangeiros, recebidos em doa��o de representa��es diplom�ticas estrangeiras sediadas no Pa�s, vendidos em feiras, bazares e eventos semelhantes por entidades beneficentes - Art. 67 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('334','Isen��o','Produtos industrializados na Zona Franca de Manaus - ZFM, destinados ao seu consumo interno - Art. 81 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('335','Isen��o','Produtos industrializados na ZFM, por estabelecimentos com projetos aprovados pela SUFRAMA, destinados a comercializa��o em qualquer outro ponto do Territ�rio Nacional - Art. 81 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('336','Isen��o','Produtos nacionais destinados � entrada na ZFM, para seu consumo interno, utiliza��o ou industrializa��o, ou ainda, para serem remetidos, por interm�dio de seus entrepostos, � Amaz�nia Ocidental - Art. 81 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('337','Isen��o','Produtos industrializados por estabelecimentos com projetos aprovados pela SUFRAMA, consumidos ou utilizados na Amaz�nia Ocidental, ou adquiridos atrav�s da ZFM ou de seus entrepostos na referida regi�o - Art. 95 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('338','Isen��o','Produtos de proced�ncia estrangeira, relacionados na legisla��o, oriundos da ZFM e que derem entrada na Amaz�nia Ocidental para ali serem consumidos ou utilizados: - Art. 95 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('339','Isen��o','Produtos elaborados com mat�rias-primas agr�colas e extrativas vegetais de produ��o regional, por estabelecimentos industriais localizados na Amaz�nia Ocidental, com projetos aprovados pela SUFRAMA - Art. 95 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('340','Isen��o','Produtos industrializados em �rea de Livre Com�rcio - Art. 105 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('341','Isen��o','Produtos nacionais ou nacionalizados, destinados � entrada na �rea de Livre Com�rcio de Tabatinga - ALCT - Art. 107 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('342','Isen��o','Produtos nacionais ou nacionalizados, destinados � entrada na �rea de Livre Com�rcio de Guajar�-Mirim - ALCGM - Art. 110 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('343','Isen��o','Produtos nacionais ou nacionalizados, destinados � entrada nas �reas de Livre Com�rcio de Boa Vista - ALCBV e Bonfim - ALCB - Art. 113 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('344','Isen��o','Produtos nacionais ou nacionalizados, destinados � entrada na �rea de Livre Com�rcio de Macap� e Santana - ALCMS - Art. 117 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('345','Isen��o','Produtos nacionais ou nacionalizados, destinados � entrada nas �reas de Livre Com�rcio de Brasil�ia - ALCB e de Cruzeiro do Sul - ALCCS - Art. 120 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('346','Isen��o','Recompe - equipamentos de inform�tica - de benefici�rio do regime para escolas das redes p�blicas de ensino federal, estadual, distrital, municipal ou nas escolas sem fins lucrativos de atendimento a pessoas com defici�ncia - Decreto n� 7.243/2010, art. 7�')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('347','Isen��o','Rio 2016 - Importa��o de materiais para os jogos (medalhas, trof�us, impressos, bens n�o dur�veis, etc.) - Lei n� 12.780/2013, Art. 4�, �1�, I')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('348','Isen��o','Rio 2016 - Suspens�o convertida em isen��o - Lei n� 12.780/2013, Art. 6�, I')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('349','Isen��o','Rio 2016 - Empresas vinculadas ao CIO - Lei n� 12.780/2013, Art. 9�, I, d')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('350','Isen��o','Rio 2016 - Sa�da de produtos importados pelo RIO 2016 - Lei n� 12.780/2013, Art. 10, I, d')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('351','Isen��o','Rio 2016 - Produtos nacionais, n�o dur�veis, uso e consumo dos eventos, adquiridos pelas pessoas jur�dicas mencionadas no � 2o do art. 4o da Lei n� 12.780/2013 - Lei n� 12.780/2013, Art. 12')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('601','Redu��o','Equipamentos e outros destinados � pesquisa e ao desenvolvimento tecnol�gico - Art. 72 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('602','Redu��o','Equipamentos e outros destinados � empresas habilitadas no PDTI e PDTA utilizados em pesquisa e ao desenvolvimento tecnol�gico - Art. 73 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('603','Redu��o','Microcomputadores e outros de at� R$11.000,00, unidades de disco, circuitos, etc, destinados a bens de inform�tica ou automa��o. Centro-Oeste SUDAM SUDENE - Art. 142, I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('604','Redu��o','Microcomputadores e outros de at� R$11.000,00, unidades de disco, circuitos, etc, destinados a bens de inform�tica ou automa��o. - Art. 142, I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('605','Redu��o','Bens de inform�tica n�o inclu�dos no art. 142 do Decreto 7.212/2010 - Produzidos no Centro-Oeste, SUDAM, SUDENE - Art. 143, I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('606','Redu��o','Bens de inform�tica n�o inclu�dos no art. 142 do Decreto 7.212/2010 - Art. 143, II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('607','Redu��o','Padis - Art. 150 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('608','Redu��o','Patvd - Art. 158 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('999','Outros','Tributa��o normal IPI; Outros;')

END

--------------------- PA 288551 ------------------------

IF not EXISTS (SELECT 1 FROM DADOADICIONAL WHERE OID = 37764)
insert into dadoadicional ( RCLASSECONCRETA,RAPLICATIVO,RDOMINIO,RLISTA,RTIPO,RITEM,RESTRICAO,VISIVEL,MASCARA,PADRAO,MAXIMO,MINIMO,VALOR,OID) values (7,7    ,7,7,1014,52,0,0,'','',1,0,'Percentual do ICMS relativo ao fundo de combate � pobreza',37764)
GO
-- Adi��o de campos tabela 'DADOSITEMNFE'
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'CEST') 
alter TABLE dbo.DADOSITEMNFE add CEST CHAR(14)
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'vBCUFDest') 
alter TABLE dbo.DADOSITEMNFE add vBCUFDest NUMERIC(15,2)
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'pFCPUFDest') 
alter TABLE dbo.DADOSITEMNFE add pFCPUFDest NUMERIC(5,2)
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'pICMSUFDest') 
alter TABLE dbo.DADOSITEMNFE add pICMSUFDest NUMERIC(5,2)
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'pICMSInter') 
alter TABLE dbo.DADOSITEMNFE add pICMSInter NUMERIC(5,2)
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'pICMSInterPart') 
alter TABLE dbo.DADOSITEMNFE add pICMSInterPart NUMERIC(5,2)
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'vFCPUFDest') 
alter TABLE dbo.DADOSITEMNFE add vFCPUFDest NUMERIC(15,2)
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'vICMSUFDest') 
alter TABLE dbo.DADOSITEMNFE add vICMSUFDest NUMERIC(15,2)
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'vICMSUFRemet') 
alter TABLE dbo.DADOSITEMNFE add vICMSUFRemet NUMERIC(15,2)
go
-- Adi��o de campos tabela 'DADOSNOTANFE'
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSNOTANFE' AND COLUMN_NAME = 'vFCPUFDest') 
alter TABLE dbo.DADOSNOTANFE add vFCPUFDest NUMERIC(15,2)
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSNOTANFE' AND COLUMN_NAME = 'vICMSUFDest') 
alter TABLE dbo.DADOSNOTANFE add vICMSUFDest NUMERIC(15,2)
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSNOTANFE' AND COLUMN_NAME = 'vICMSUFRemet') 
alter TABLE dbo.DADOSNOTANFE add vICMSUFRemet NUMERIC(15,2)
go
-- Criar tabela PARTICMSDEST
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE xtype='U' AND name='PARTICMSDEST') 
BEGIN
   CREATE TABLE PARTICMSDEST(
   ANO INT NOT NULL,
   PERCPARTICMSDEST NUMERIC(5,2) NULL)
END
GO
-- Povoar tabela recem criada com os percentuais
IF not EXISTS (SELECT 1 FROM PARTICMSDEST WHERE ANO = 2016) INSERT INTO PARTICMSDEST (ANO, PERCPARTICMSDEST) VALUES (2016, 40.00)
GO
IF not EXISTS (SELECT 1 FROM PARTICMSDEST WHERE ANO = 2017) INSERT INTO PARTICMSDEST (ANO, PERCPARTICMSDEST) VALUES (2017, 60.00)
GO
IF not EXISTS (SELECT 1 FROM PARTICMSDEST WHERE ANO = 2018) INSERT INTO PARTICMSDEST (ANO, PERCPARTICMSDEST) VALUES (2018, 80.00)
GO

------------------ PA 286696 -------------------

-- Criar tabela CODIGOCEST
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE xtype='U' AND name='CODIGOCEST') 
BEGIN
   CREATE TABLE CODIGOCEST(
   CODIGO CHAR(14) NOT NULL,
   DESCRICAO VARCHAR(1000) DEFAULT '')
   ALTER TABLE CODIGOCEST ADD CONSTRAINT PK_CODIGOCEST PRIMARY KEY CLUSTERED(CODIGO)
END
GO

-- Adicionando coluna CODIGOCEST na tabela COMPLEMENTOPRODUTO
IF NOT EXISTS (SELECT 1 FROM SYSCOLUMNS WHERE name = 'CODIGOCEST' and syscolumns.id IN (SELECT ID FROM SYSOBJECTS WHERE xtype='U' AND name='COMPLEMENTOPRODUTO')) 
ALTER TABLE COMPLEMENTOPRODUTO ADD CODIGOCEST CHAR(14)
go

DELETE FROM CODIGOCEST

INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100100','Catalisadores em colmeia cer�mica ou met�lica para convers�o catal�tica de gases de escape de ve�culos e outros catalisadores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100200','Tubos e seus acess�rios (por exemplo, juntas, cotovelos, flanges, uni�es), de pl�sticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100300','Protetores de ca�amba')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100400','Reservat�rios de �leo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100500','Frisos, decalques, molduras e acabamentos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100600','Correias de transmiss�o de borracha vulcanizada, de mat�rias t�xteis, mesmo impregnadas, revestidas ou recobertas, de pl�stico, ou estratificadas com pl�stico ou refor�adas com metal ou com outras mat�rias')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100700','Juntas, gaxetas e outros elementos com fun��o semelhante de veda��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100800','Partes de ve�culos autom�veis, tratores e m�quinas autopropulsadas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100900','Tapetes, revestimentos, mesmo confeccionados, batentes, buchas e coxins')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101000','Tecidos impregnados, revestidos, recobertos ou estratificados, com pl�stico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101100','Mangueiras e tubos semelhantes, de mat�rias t�xteis, mesmo com refor�o ou acess�rios de outras mat�rias')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101200','Encerados e toldos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101300','Capacetes e artefatos de uso semelhante, de prote��o, para uso em motocicletas, inclu�dos ciclomotores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101400','Guarni��es de fric��o (por exemplo, placas, rolos, tiras, segmentos, discos, an�is, pastilhas), n�o montadas, para freios, embreagens ou qualquer outro mecanismo de fric��o, � base de amianto, de outras subst�ncias minerais ou de celulose, mesmo combinadas com t�xteis ou outras mat�rias')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101500','Vidros de dimens�es e formatos que permitam aplica��o automotiva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101600','Espelhos retrovisores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101700','Lentes de far�is, lanternas e outros utens�lios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101800','Cilindro de a�o para GNV (g�s natural veicular)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101900','Recipientes para gases comprimidos ou liquefeitos, de ferro fundido, ferro ou a�o, exceto o descrito no item 18.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102000','Molas e folhas de molas, de ferro ou a�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102100','Obras moldadas, de ferro fundido, ferro ou a�o, exceto as do c�digo 7325.91.00')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102200','Peso de chumbo para balanceamento de roda')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102300','Peso para balanceamento de roda e outros utens�lios de estanho')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102400','Fechaduras e partes de fechaduras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102500','Chaves apresentadas isoladamente')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102600','Dobradi�as, guarni��es, ferragens e artigos semelhantes de metais comuns')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102700','Tri�ngulo de seguran�a')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102800','Motores de pist�o alternativo dos tipos utilizados para propuls�o de ve�culos do Cap�tulo 87')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102900','Motores dos tipos utilizados para propuls�o de ve�culos automotores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103000','Partes reconhec�veis como exclusiva ou principalmente destinadas aos motores das posi��es 8407 ou 8408')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103100','Motores hidr�ulicos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103200','Bombas para combust�veis, lubrificantes ou l�quidos de arrefecimento, pr�prias para motores de igni��o por centelha ou por compress�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103300','Bombas de v�cuo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103400','Compressores e turbocompressores de ar')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103500','Partes das bombas, compressores e turbocompressores dos itens 32.0, 33.0 e 34.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103600','M�quinas e aparelhos de ar condicionado')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103700','Aparelhos para filtrar �leos minerais nos motores de igni��o por centelha ou por compress�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103800','Filtros a v�cuo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103900','Partes dos aparelhos para filtrar ou depurar l�quidos ou gases')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104000','Extintores, mesmo carregados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104100','Filtros de entrada de ar para motores de igni��o por centelha ou por compress�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104200','Depuradores por convers�o catal�tica de gases de escape')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104300','Macacos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104400','Partes para macacos do item 43.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104500','Partes reconhec�veis como exclusiva ou principalmente destinadas �s m�quinas agr�colas ou rodovi�rias')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104600','V�lvulas redutoras de press�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104700','V�lvulas para transmiss�o �leo-hidr�ulicas ou pneum�ticas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104800','V�lvulas solen�ides')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104900','Rolamentos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105000','�rvores de transmiss�o (inclu�das as �rvores de "cames"e virabrequins) e manivelas; mancais e "bronzes"; engrenagens e rodas de fric��o; eixos de esferas ou de roletes; redutores, multiplicadores, caixas de transmiss�o e variadores de velocidade, inclu�dos os conversores de torque; volantes e polias, inclu�das as polias para cadernais; embreagens e dispositivos de acoplamento, inclu�das as juntas de articula��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105100','Juntas metalopl�sticas; jogos ou sortidos de juntas de composi��es diferentes, apresentados em bolsas, envelopes ou embalagens semelhantes; juntas de veda��o mec�nicas (selos mec�nicos)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105200','Acoplamentos, embreagens, variadores de velocidade e freios, eletromagn�ticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105300','Acumuladores el�tricos de chumbo, do tipo utilizado para o arranque dos motores de pist�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105400','Aparelhos e dispositivos el�tricos de igni��o ou de arranque para motores de igni��o por centelha ou por compress�o (por exemplo, magnetos, d�namos-magnetos, bobinas de igni��o, velas de igni��o ou de aquecimento, motores de arranque); geradores (d�namos e alternadores, por exemplo) e conjuntores-disjuntores utilizados com estes motores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105500','Aparelhos el�tricos de ilumina��o ou de sinaliza��o (exceto os da posi��o 8539), limpadores de para-brisas, degeladores e desemba�adores (desembaciadores) el�tricos e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105600','Telefones m�veis do tipo dos utilizados em ve�culos autom�veis.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105700','Alto-falantes, amplificadores el�tricos de audiofrequ�ncia e partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105800','Aparelhos el�tricos de amplifica��o de som para ve�culos automotores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105900','Aparelhos de reprodu��o de som')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106000','Aparelhos transmissores (emissores) de radiotelefonia ou radiotelegrafia (r�dio receptor/transmissor)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106100','Aparelhos receptores de radiodifus�o que s� funcionam com fonte externa de energia, exceto os classificados na posi��o 8527.21.90')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106200','Outros aparelhos receptores de radiodifus�o que funcionem com fonte externa de energia; outros aparelhos videof�nicos de grava��o ou de reprodu��o, mesmo incorporando um receptor de sinais videof�nicos, dos tipos utilizados exclusivamente em ve�culos automotores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106300','Antenas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106400','Circuitos impressos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106500','Interruptores e seccionadores e comutadores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106600','Fus�veis e corta-circuitos de fus�veis')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106700','Disjuntores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106800','Rel�s')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106900','Partes reconhec�veis como exclusivas ou principalmente destinados aos aparelhos dos itens 65.0, 66.0, 67.0 e 68.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107000','Far�is e projetores, em unidades seladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107100','L�mpadas e tubos de incandesc�ncia, exceto de raios ultravioleta ou infravermelhos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107200','Cabos coaxiais e outros condutores el�tricos coaxiais')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107300','Jogos de fios para velas de igni��o e outros jogos de fios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107400','Carro�arias para os ve�culos autom�veis das posi��es 8701 a 8705, inclu�das as cabinas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107500','Partes e acess�rios dos ve�culos autom�veis das posi��es 8701 a 8705')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107600','Parte e acess�rios de motocicletas (inclu�dos os ciclomotores)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107700','Engates para reboques e semi-reboques')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107800','Medidores de n�vel; Medidores de vaz�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107900','Aparelhos para medida ou controle da press�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108000','Contadores, indicadores de velocidade e tac�metros, suas partes e acess�rios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108100','Amper�metros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108200','Aparelhos digitais, de uso em ve�culos autom�veis, para medida e indica��o de m�ltiplas grandezas tais como: velocidade m�dia, consumos instant�neo e m�dio e autonomia (computador de bordo)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108300','Controladores eletr�nicos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108400','Rel�gios para pain�is de instrumentos e rel�gios semelhantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108500','Assentos e partes de assentos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108600','Acendedores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108700','Tubos de borracha vulcanizada n�o endurecida, mesmo providos de seus acess�rios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108800','Juntas de veda��o de corti�a natural e de amianto')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108900','Papel-diagrama para tac�grafo, em disco')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109000','Fitas, tiras, adesivos, auto-colantes, de pl�stico, refletores, mesmo em rolos; placas met�licas com pel�cula de pl�stico refletora, pr�prias para coloca��o em carrocerias, para-choques de ve�culos de carga, motocicletas, ciclomotores, capacetes, bon�s de agentes de tr�nsito e de condutores de ve�culos, atuando como dispositivos refletivos de seguran�a rodovi�rios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109100','Cilindros pneum�ticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109200','Bomba el�trica de lavador de para-brisa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109300','Bomba de assist�ncia de dire��o hidr�ulica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109400','Motoventiladores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109500','Filtros de p�len do ar-condicionado')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109600','"M�quina" de vidro el�trico de porta')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109700','Motor de limpador de para-brisa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109800','Bobinas de reat�ncia e de auto-indu��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109900','Baterias de chumbo e de n�quel-c�dmio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110000','Aparelhos de sinaliza��o ac�stica (buzina)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110100','Instrumentos para regula��o de grandezas n�o el�tricas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110200','Analisadores de gases ou de fuma�a (sonda lambda)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110300','Perfilados de borracha vulcanizada n�o endurecida')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110400','Artefatos de pasta de fibra de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110500','Tapetes/carpetes - nail�n')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110600','Tapetes de mat�rias t�xteis sint�ticas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110700','Forra��o interior capacete')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110800','Outros para-brisas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110900','Moldura com espelho')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111000','Corrente de transmiss�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111100','Corrente transmiss�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111200','Outras correntes de transmiss�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111300','Condensador tubular met�lico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111400','Trocadores de calor')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111500','Partes de aparelhos mec�nicos de pulverizar ou dispersar')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111600','Macacos manuais para ve�culos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111700','Ca�ambas, p�s, ganchos e tenazes para m�quinas rodovi�rias')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111800','Geradores de corrente alternada de pot�ncia n�o superior a 75 kva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111900','Aparelhos el�tricos para alarme de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112000','B�ssolas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112100','Indicadores de temperatura')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112200','Partes de indicadores de temperatura')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112300','Partes de aparelhos de medida ou controle')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112400','Termostatos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112500','Instrumentos e aparelhos para regula��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112600','Pressostatos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112700','Pe�as para reboques e semi-reboques')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112800','Geradores de ar quente a combust�vel l�quido, com capacidade superior ou igual a 1.500 kcal/h, mas inferior ou igual a 10.400 kcal/h, do tipo dos utilizados em ve�culos autom�veis')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0200100','Aperitivos, amargos, bitter e similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0200200','Batida e similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0200300','Bebida ice')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0200400','Cacha�a e aguardentes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0200500','Catuaba e similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0200600','Conhaque, brandy e similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0200700','Cooler')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0200800','Gim (gin) e genebra')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0200900','Jurubeba e similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0201000','Licores e similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0201100','Pisco')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0201200','Rum')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0201300','Saque')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0201400','Steinhaeger')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0201500','Tequila')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0201600','U�sque')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0201700','Vermute e similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0201800','Vodka')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0201900','Derivados de vodka')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0202000','Arak')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0202100','Aguardente v�nica / grappa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0202200','Sidra e similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0202300','Sangrias e coquet�is')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0202400','Vinhos de uvas frescas, incluindo os vinhos enriquecidos com �lcool; mostos de uvas.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0202500','Outras bebidas alco�licas n�o especificadas nos itens anteriores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300100','�gua mineral, gasosa ou n�o, ou pot�vel, naturais, em garrafa de vidro, retorn�vel ou n�o, com capacidade de at� 500 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300200','�gua mineral, gasosa ou n�o, ou pot�vel, naturais, em embalagem com capacidade igual ou superior a 5.000 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300300','�gua mineral, gasosa ou n�o, ou pot�vel, naturais, em embalagem de vidro, n�o retorn�vel, com capacidade de at� 300 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300400','�gua mineral, gasosa ou n�o, ou pot�vel, naturais, em garrafa pl�stica de 1.500 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300500','�gua mineral, gasosa ou n�o, ou pot�vel, naturais, em copos pl�sticos e embalagem pl�stica com capacidade de at� 500 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300600','Outras �guas minerais, pot�veis ou naturais, gasosas ou n�o, inclusive gaseificadas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300700','�guas minerais, pot�veis ou naturais, gasosas ou n�o, inclusive gaseificadas ou aromatizadas artificialmente, refrescos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300800','Outras �guas minerais, pot�veis ou naturais, gasosas ou n�o, inclusive gaseificadas ou aromatizadas artificialmente')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300900','N�ctares de frutas e outras bebidas n�o alco�licas prontas para beber, exceto isot�nicos e energ�ticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301000','Refrigerante em garrafa com capacidade igual ou superior a 600 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301100','Demais refrigerantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301200','Xarope ou extrato concentrado destinados ao preparo de refrigerante em m�quina "pr�-mix"ou "post-mix"')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301300','Bebidas energ�ticas em embalagem com capacidade inferior a 600ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301400','Bebidas energ�ticas em embalagem com capacidade igual ou superior a 600ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301500','Bebidas hidroeletrol�ticas (isot�nicas) em embalagem com capacidade inferior a 600ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301600','Bebidas hidroeletrol�ticas (isot�nicas) em embalagem com capacidade igual ou superior a 600ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301700','Bebidas prontas � base de mate ou ch�')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301800','Bebidas prontas � base de caf�')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301900','Refrescos e outras bebidas prontas para beber � base de ch� e mate')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0302000','Bebidas alimentares prontas � base de soja, leite ou cacau, inclusive os produtos denominados bebidas l�cteas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0302100','Cerveja')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0302200','Cerveja sem �lcool')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0302300','Chope')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0400100','Charutos, cigarrilhas e cigarros, de tabaco ou dos seus suced�neos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0400200','Tabaco para fumar, mesmo contendo suced�neos de tabaco em qualquer propor��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0500100','Cimento')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600100','�lcool et�lico n�o desnaturado, com um teor alco�lico em volume igual ou superior a 80% vol (�lcool et�lico anidro combust�vel e �lcool et�lico hidratado combust�vel)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600200','Gasolinas, exceto de avia��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600300','Gasolina de avia��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600400','Querosenes, exceto de avia��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600500','Querosene de avia��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600600','�leos combust�veis')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600700','�leos lubrificantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600800','Outros �leos de petr�leo ou de minerais betuminosos (exceto �leos brutos) e prepara��es n�o especificadas nem compreendidas noutras posi��es, que contenham, como constituintes b�sicos, 70% ou mais, em peso, de �leos de petr�leo ou de inerais betuminosos, exceto os que contenham biodiesel e exceto os res�duos de �leos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600900','Res�duos de �leos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601000','G�s de petr�leo e outros hidrocarbonetos gasosos, exceto GLP, GLGN e G�s Natural')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601100','G�s Liquefeito de Petr�leo (GLP)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601200','G�s Liquefeito de G�s Natural (GLGN)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601300','G�s Natural')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601400','Coque de petr�leo e outros res�duos de �leo de petr�leo ou de minerais betuminosos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601500','Biodiesel e suas misturas, que n�o contenham ou que contenham menos de 70%, em peso, de �leos de petr�leo ou de �leos minerais betuminosos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601600','Prepara��es lubrificantes, exceto as contendo, como constituintes de base, 70% ou mais, em peso, de �leos de petr�leo ou de minerais betuminosos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601700','�leos de petr�leo ou de minerais betuminosos (exceto �leos brutos) e prepara��es n�o especificadas nem compreendidas noutras posi��es, que contenham, como constituintes b�sicos, 70% ou mais, em peso, de �leos de petr�leo ou de minerais betuminosos, que contenham biodiesel, exceto os res�duos de �leos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0700100','Energia el�trica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800100','Ferramentas de borracha vulcanizada n�o endurecida')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800200','Ferramentas, arma��es e cabos de ferramentas, de madeira')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800300','M�s e artefatos semelhantes, sem arma��o, para moer, desfibrar, triturar, amolar, polir, retificar ou cortar; pedras para amolar ou para polir, manualmente, e suas partes, de pedras naturais, de abrasivos naturais ou artificiais aglomerados ou de cer�mica, mesmo com partes de outras mat�rias')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800400','P�s, alvi�es, picaretas, enxadas, sachos, forcados e forquilhas, ancinhos e raspadeiras; machados, pod�es e ferramentas semelhantes com gume; tesouras de podar de todos os tipos; foices e foicinhas, facas para feno ou para palha, tesouras para sebes, cunhas e outras ferramentas manuais para agricultura, horticultura ou silvicultura')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800500','Folhas de serras de fita')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800600','L�minas de serras m�quinas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800700','Serras manuais e outras folhas de serras (inclu�das as fresas-serras e as folhas n�o dentadas para serrar), exceto as classificadas nas posi��es 8202.20.00 e 8202.91.00')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800800','Limas, grosas, alicates (mesmo cortantes), tenazes, pin�as, cisalhas para metais, corta-tubos, corta-pinos, saca-bocados e ferramentas semelhantes, manuais, exceto as pin�as para sobrancelhas classificadas na posi��o 8203.20.90')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800900','Chaves de porcas, manuais (inclu�das as chaves dinamom�tricas); chaves de caixa intercambi�veis, mesmo com cabos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801000','Ferramentas manuais (inclu�dos os diamantes de vidraceiro) n�o especificadas nem compreendidas em outras posi��es, lamparinas ou l�mpadas de soldar (ma�aricos) e semelhantes; tornos de apertar, sargentos e semelhantes, exceto os acess�rios ou partes de m�quinas-ferramentas; bigornas; forjas-port�teis; m�s com arma��o, manuais ou de pedal')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801100','Ferramentas de pelo menos duas das posi��es 8202 a 8205, acondicionadas em sortidos para venda a retalho')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801200','Ferramentas de roscar interior ou exteriormente; de mandrilar ou de brochar; e de fresar')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801300','Outras ferramentas intercambi�veis para ferramentas manuais, mesmo mec�nicas, ou para m�quinas-ferramentas (por exemplo, de embutir, estampar, puncionar, furar, tornear, aparafusar), inclu�das as fieiras de estiragem ou de extrus�o, para metais, e as ferramentas de perfura��o ou de sondagem, exceto forma ou gabarito de produtos em epoxy, exceto as classificadas nas posi��es 8207.40, 8207.60 e 8207.70')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801400','Facas e l�minas cortantes, para m�quinas ou para aparelhos mec�nicos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801500','Plaquetas ou pastilhas intercambi�veis')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801600','Outras plaquetas, varetas, pontas e objetos semelhantes para ferramentas, n�o montados, de ceramais ("cermets"), exceto as classificadas na posi��o 8209.00.11')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801700','Facas (exceto as da posi��o 8208) de l�mina cortante ou serrilhada, inclu�das as podadeiras de l�mina m�vel, e suas l�minas, exceto as de uso dom�stico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801800','Tesouras e suas l�minas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801900','Ferramentas pneum�ticas, hidr�ulicas ou com motor (el�trico ou n�o el�trico) incorporado, de uso manual')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0802000','Instrumentos e aparelhos de geod�sia, topografia, agrimensura, nivelamento, fotogrametria, hidrografia, oceanografia, hidrologia, meteorologia ou de geof�sica, exceto bussolas; tel�metros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0802100','Instrumentos de desenho, de tra�ado ou de c�lculo; metros, micr�metros, paqu�metros, calibres e semelhantes; partes e acess�rios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0802200','Term�metros, suas partes e acess�rios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0802300','Pir�metros, suas partes e acess�rios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0900100','L�mpadas el�tricas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0900200','L�mpadas eletr�nicas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0900300','Reatores para l�mpadas ou tubos de descargas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0900400','�Starter�')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0900500','L�mpadas de LED (Diodos Emissores de Luz)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000100','Cal')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000200','Argamassas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000300','Outras argamassas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000400','Silicones em formas prim�rias, para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000500','Revestimentos de PVC e outros pl�sticos; forro, sancas e afins de PVC, para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000600','Tubos, e seus acess�rios (por exemplo, juntas, cotovelos, flanges, uni�es), de pl�sticos, para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000700','Revestimento de pavimento de PVC e outros pl�sticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000800','Chapas, folhas, tiras, fitas, pel�culas e outras formas planas, auto-adesivas, de pl�sticos, mesmo em rolos, para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000900','Veda rosca, lona pl�stica para uso na constru��o, fitas isolantes e afins')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001000','Telha de pl�stico, mesmo refor�ada com fibra de vidro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001100','Cumeeira de pl�stico, mesmo refor�ada com fibra de vidro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001200','Chapas, laminados pl�sticos em bobina, para uso na constru��o, exceto os descritos nos itens 10.0 e 11.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001300','Banheiras, boxes para chuveiros, pias, lavat�rios, bid�s, sanit�rios e seus assentos e tampas, caixas de descarga e artigos semelhantes para usos sanit�rios ou higi�nicos, de pl�sticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001400','Artefatos de higiene/toucador de pl�stico, para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001500','Caixa d��gua, inclusive sua tampa, de pl�stico, mesmo refor�adas com fibra de vidro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001600','Outras telhas, cumeeira e caixa d��gua, inclusive sua tampa, de pl�stico, mesmo refor�adas com fibra de vidro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001700','Artefatos para apetrechamento de constru��es, de pl�sticos, n�o especificados nem compreendidos em outras posi��es, incluindo persianas, sancas, molduras, apliques e rosetas, caixilhos de polietileno e outros pl�sticos, exceto os descritos nos itens 15.0 e 16.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001800','Portas, janelas e seus caixilhos, alizares e soleiras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001900','Postigos, estores (inclu�das as venezianas) e artefatos semelhantes e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002000','Outras obras de pl�stico, para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002100','Papel de parede e revestimentos de parede semelhantes; papel para vitrais')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002200','Telhas de concreto')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002300','Telha, cumeeira e caixa d��gua, inclusive sua tampa, de fibrocimento, cimento-celulose')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002400','Caixas d��gua, tanques e reservat�rios e suas tampas, telhas, calhas, cumeeiras e afins, de fibrocimento, cimento-celulose ou semelhantes, contendo ou n�o amianto, exceto os descritos no item 23.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002500','Tijolos, placas (lajes), ladrilhos e outras pe�as cer�micas de farinhas siliciosas f�sseis ("kieselghur", tripolita, diatomita, por exemplo) ou de terras siliciosas semelhantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002600','Tijolos, placas (lajes), ladrilhos e pe�as cer�micas semelhantes, para uso na constru��o, refrat�rios, que n�o sejam de farinhas siliciosas f�sseis nem de terras siliciosas semelhantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002700','Tijolos para constru��o, tijoleiras, tapa-vigas e produtos semelhantes, de cer�mica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002800','Telhas, elementos de chamin�s, condutores de fuma�a, ornamentos arquitet�nicos, de cer�mica, e outros produtos cer�micos para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002900','Tubos, calhas ou algerozes e acess�rios para canaliza��es, de cer�mica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003000','Ladrilhos e placas de cer�mica, exclusivamente para pavimenta��o ou revestimento')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003001','Cubos, pastilhas e artigos semelhantes de cer�mica, mesmo com suporte.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003100','Pias, lavat�rios, colunas para lavat�rios, banheiras, bid�s, sanit�rios, caixas de descarga, mict�rios e aparelhos fixos semelhantes para usos sanit�rios, de cer�mica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003200','Artefatos de higiene/toucador de cer�mica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003300','Vidro vazado ou laminado, em chapas, folhas ou perfis, mesmo com camada absorvente, refletora ou n�o, mas sem qualquer outro trabalho')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003400','Vidro estirado ou soprado, em folhas, mesmo com camada absorvente, refletora ou n�o, mas sem qualquer outro trabalho')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003500','Vidro flotado e vidro desbastado ou polido em uma ou em ambas as faces, em chapas ou em folhas, mesmo com camada absorvente, refletora ou n�o, mas sem qualquer outro trabalho')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003600','Vidros temperados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003700','Vidros laminados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003800','Vidros isolantes de paredes m�ltiplas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003900','Blocos, placas, tijolos, ladrilhos, telhas e outros artefatos, de vidro prensado ou moldado, mesmo armado, para uso na constru��o; cubos, pastilhas e outros artigos semelhantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004000','Barras pr�prias para constru��es, exceto vergalh�es')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004100','Outras barras pr�prias para constru��es, exceto vergalh�es')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004200','Vergalh�es')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004300','Outros vergalh�es')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004400','Fios de ferro ou a�o n�o ligados, n�o revestidos, mesmo polidos; cordas, cabos, tran�as (entran�ados), lingas e artefatos semelhantes, de ferro ou a�o, n�o isolados para usos el�tricos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004500','Outros fios de ferro ou a�o, n�o ligados, galvanizados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004600','Acess�rios para tubos (inclusive uni�es, cotovelos, luvas ou mangas), de ferro fundido, ferro ou a�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004700','Portas e janelas, e seus caixilhos, alizares e soleiras de ferro fundido, ferro ou a�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004800','Material para andaimes, para arma��es (cofragens) e para escoramentos, (inclusive arma��es prontas, para estruturas de concreto armado ou argamassa armada), eletrocalhas e perfilados de ferro fundido, ferro ou a�o, pr�prios para constru��o, exceto treli�as de a�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004900','Treli�as de a�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005000','Telhas met�licas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005100','Caixas diversas (tais como caixa de correio, de entrada de �gua, de energia, de instala��o) de ferro, ferro fundido ou a�o; pr�prias para a constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005200','Arame farpado, de ferro ou a�o, arames ou tiras, retorcidos, mesmo farpados, de ferro ou a�o, dos tipos utilizados em cercas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005300','Telas met�licas, grades e redes, de fios de ferro ou a�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005400','Correntes de rolos, de ferro fundido, ferro ou a�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005500','Outras correntes de elos articulados, de ferro fundido, ferro ou a�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005600','Correntes de elos soldados, de ferro fundido, de ferro ou a�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005700','Tachas, pregos, percevejos, esc�pulas, grampos ondulados ou biselados e artefatos semelhantes, de ferro fundido, ferro ou a�o, mesmo com a cabe�a de outra mat�ria, exceto cobre')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005800','Parafusos, pinos ou pernos, roscados, porcas, tira-fundos, ganchos roscados, rebites, chavetas, cavilhas, contrapinos, arruelas (inclu�das as de press�o) e artefatos semelhantes, de ferro fundido, ferro ou a�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005900','Palha de ferro ou a�o; esponjas, esfreg�es, luvas e artefatos semelhantes para limpeza, polimento e usos semelhantes, de ferro ou a�o, exceto os de uso dom�stico classificados na posi��o 7323.10.00')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006000','Artefatos de higiene ou de toucador, e suas partes, de ferro fundido, ferro ou a�o, inclu�das as pias, banheiras, lavat�rios, cubas, mict�rios, tanques e afins de ferro fundido, ferro ou a�o, para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006100','Outras obras moldadas, de ferro fundido, ferro ou a�o, para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006200','Abra�adeiras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006300','Barras de cobre')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006400','Tubos de cobre e suas ligas, para instala��es de �gua quente e g�s, para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006500','Acess�rios para tubos (por exemplo, uni�es, cotovelos, luvas ou mangas) de cobre e suas ligas, para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006600','Tachas, pregos, percevejos, esc�pulas e artefatos semelhantes, de cobre, ou de ferro ou a�o com cabe�a de cobre, parafusos, pinos ou pernos, roscados, porcas, ganchos roscados, rebites, chavetas, cavilhas, contrapinos, arruelas (inclu�das as de press�o), e artefatos semelhantes, de cobre')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006700','Artefatos de higiene/toucador de cobre, para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006800','Manta de subcobertura aluminizada')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006900','Tubos de alum�nio e suas ligas, para refrigera��o e ar condicionado, para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007000','Acess�rios para tubos (por exemplo, uni�es, cotovelos, luvas ou mangas), de alum�nio, para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007100','Constru��es e suas partes (por exemplo, pontes e elementos de pontes, torres, p�rticos ou pilones, pilares, colunas, arma��es, estruturas para telhados, portas e janelas, e seus caixilhos, alizares e soleiras, balaustradas), de alum�nio, exceto as constru��es pr�-fabricadas da posi��o 9406; chapas, barras, perfis, tubos e semelhantes, de alum�nio, pr�prios para constru��es')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007200','Artefatos de higiene/toucador de alum�nio, para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007300','Outras obras de alum�nio, pr�prias para constru��es, inclu�das as persianas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007400','Outras guarni��es, ferragens e artigos semelhantes de metais comuns, para constru��es, inclusive puxadores.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007500','Fechaduras e ferrolhos (de chave, de segredo ou el�tricos), de metais comuns, inclu�das as suas partes fechos e arma��es com fecho, com fechadura, de metais comuns chaves para estes artigos, de metais comuns; exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007600','Dobradi�as de metais comuns, de qualquer tipo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007700','Tubos flex�veis de metais comuns, mesmo com acess�rios, para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007800','Fios, varetas, tubos, chapas, eletrodos e artefatos semelhantes, de metais comuns ou de carbonetos met�licos, revestidos exterior ou interiormente de decapantes ou de fundentes, para soldagem (soldadura) ou dep�sito de metal ou de carbonetos met�licos fios e varetas de p�s de metais comuns aglomerados, para metaliza��o por proje��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007900','Torneiras, v�lvulas (inclu�das as redutoras de press�o e as termost�ticas) e dispositivos semelhantes, para canaliza��es, caldeiras, reservat�rios, cubas e outros recipientes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100100','�gua sanit�ria, branqueador e outros alvejantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100200','Sab�es em p�, flocos, palhetas, gr�nulos ou outras formas semelhantes, para lavar roupas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100300','Sab�es l�quidos para lavar roupas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100400','Detergentes em p�, flocos, palhetas, gr�nulos ou outras formas semelhantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100500','Detergentes l�quidos, exceto para lavar roupa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100600','Detergente l�quido para lavar roupa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100700','Outros agentes org�nicos de superf�cie (exceto sab�es); prepara��es tensoativas, prepara��es para lavagem (inclu�das as prepara��es auxiliares para lavagem) e prepara��es para limpeza (inclusive multiuso e limpadores), mesmo contendo sab�o, exceto as da posi��o 3401 e os produtos descritos nos itens 3 a 5; em embalagem de conte�do inferior ou igual a 50 litros ou 50 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100800','Amaciante/suavizante')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100900','Esponjas para limpeza')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1101000','�lcool et�lico para limpeza')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1101100','Esponjas e palhas de a�o; esponjas para limpeza, polimento ou uso semelhantes; todas de uso dom�stico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200100','Transformadores, bobinas de reat�ncia e de auto indu��o, inclusive os transformadores de pot�ncia superior a 16 KVA, classificados nas posi��es 8504.33.00 e 8504.34.00; exceto os demais transformadores da subposi��o 8504.3, os reatores para l�mpadas el�tricas de descarga classificados no c�digo 8504.10.00, os carregadores de acumuladores  do c�digo 8504.40.10, os equipamentos de alimenta��o ininterrupta de energia (UPS ou �no break�), no c�digo 8504.40.40 e os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200200','Aquecedores el�tricos de �gua, inclu�dos os de imers�o, chuveiros ou duchas el�tricos, torneiras el�tricas, resist�ncias de aquecimento, inclusive as de duchas e chuveiros el�tricos e suas partes; exceto outros fornos, fogareiros (inclu�das as chapas de coc��o), grelhas e assadeiras, classificados na posi��o 8516.60.00')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200300','Aparelhos para interrup��o, seccionamento, prote��o, deriva��o, liga��o ou conex�o de circuitos el�tricos (por exemplo, interruptores, comutadores, corta-circuitos, para-raios, limitadores de tens�o, eliminadores de onda, tomadas de corrente e outros conectores, caixas de jun��o), para tens�o superior a 1.000V, exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200400','Aparelhos para interrup��o, seccionamento, prote��o, deriva��o, liga��o ou conex�o de circuitos el�tricos (por exemplo, interruptores, comutadores, rel�s, corta-circuitos, eliminadores de onda, plugues e tomadas de corrente, suportes para l�mpadas e outros conectores, caixas de jun��o), para uma tens�o n�o superior a 1.000V; conectores para fibras �pticas, feixes ou cabos de fibras �pticas; exceto "starter" classificado na subposi��o 8536.50 e os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200500','Partes reconhec�veis como exclusiva ou principalmente destinadas aos aparelhos das posi��es 8535 e 8536')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200600','Cabos, tran�as e semelhantes, de cobre, n�o isolados para usos el�tricos, exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200700','Fios, cabos (inclu�dos os cabos coaxiais) e outros condutores, isolados ou n�o, para usos el�tricos (inclu�dos os de cobre ou alum�nio, envernizados ou oxidados anodicamente), mesmo com pe�as de conex�o, inclusive fios e cabos el�tricos, para tens�o n�o superior a 1000V, para uso na constru��o; fios e cabos telef�nicos e para transmiss�o de dados; cabos de fibras �pticas, constitu�dos de fibras embainhadas individualmente, mesmo com condutores el�tricos ou munidos de pe�as de conex�o; cordas, cabos, tran�as')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200800','Isoladores de qualquer mat�ria, para usos el�tricos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200900','Pe�as isolantes inteiramente de mat�rias isolantes, ou com simples pe�as met�licas de montagem (suportes roscados, por exemplo) incorporadas na massa, para m�quinas, aparelhos e instala��es el�tricas; tubos isoladores e suas pe�as de liga��o, de metais comuns, isolados interiormente')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300100','Medicamentos de refer�ncia � positiva, exceto para uso veterin�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300101','Medicamentos de refer�ncia � negativa, exceto para uso veterin�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300102','Medicamentos de refer�ncia � neutra, exceto para uso veterin�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300200','Medicamentos gen�rico � positiva, exceto para uso veterin�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300201','Medicamentos gen�rico � negativa, exceto para uso veterin�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300202','Medicamentos gen�rico � neutra, exceto para uso veterin�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300300','Medicamentos similar � positiva, exceto para uso veterin�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300301','Medicamentos similar � negativa, exceto para uso veterin�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300302','Medicamentos similar � neutra, exceto para uso veterin�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300400','Outros tipos de medicamentos � positiva, exceto para uso veterin�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300401','Outros tipos de medicamentos -  negativa, exceto para uso veterin�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300402','Outros tipos de medicamentos � neutra, exceto para uso veterin�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300500','Prepara��es qu�micas contraceptivas � base de horm�nios, de outros produtos da posi��o 29.37 ou de espermicidas - positiva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300501','Prepara��es qu�micas contraceptivas � base de horm�nios, de outros produtos da posi��o 29.37 ou de espermicidas - negativa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300600','Provitaminas e vitaminas, naturais ou reproduzidas por s�ntese (inclu�dos os concentrados naturais), bem como os seus derivados utilizados principalmente como vitaminas, misturados ou n�o entre si, mesmo em quaisquer solu��es - neutra')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300700','Prepara��es opacificantes (contrastantes) para exames radiogr�ficos e reagentes de diagn�stico concebidos para serem administrados ao paciente - positiva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300701','Prepara��es opacificantes (contrastantes) para exames radiogr�ficos e reagentes de diagn�stico concebidos para serem administrados ao paciente - negativa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300800','Antissoro, outras fra��es do sangue, produtos imunol�gicos modificados, mesmo obtidos por via biotecnol�gica,  exceto para uso veterin�rio - positiva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300801','Antissoro, outras fra��es do sangue, produtos imunol�gicos modificados, mesmo obtidos por via biotecnol�gica, exceto para uso veterin�rio - negativa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300900','Vacinas e produtos semelhantes, exceto para uso veterin�rio - positiva;')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300901','Vacinas e produtos semelhantes, exceto para uso veterin�rio - negativa;')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301000','Algod�o, atadura, esparadrapo, haste flex�vel ou n�o, com uma ou ambas extremidades de algod�o, gazes, pensos, sinapismos, e outros, impregnados ou recobertos de subst�ncias farmac�uticas ou acondicionados para venda a retalho para usos medicinais, cir�rgicos ou dent�rios - positiva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301001','Algod�o, atadura, esparadrapo, haste flex�vel ou n�o, com uma ou ambas extremidades de algod�o, gazes, pensos, sinapismos, e outros, impregnados ou recobertos de subst�ncias farmac�uticas ou acondicionados para venda a retalho para usos medicinais, cir�rgicos ou dent�rios - negativa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301100','Algod�o, atadura, esparadrapo, haste flex�vel ou n�o, com uma ou ambas extremidades de algod�o, gazes, pensos, sinapismos, e outros, n�o impregnados ou recobertos de subst�ncias farmac�uticas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301101','Algod�o, atadura, esparadrapo, haste flex�vel ou n�o, com uma ou ambas extremidades de algod�o, gazes, pensos, sinapismos, e outros, n�o impregnados ou recobertos de subst�ncias farmac�uticas ou acondicionados para venda a retalho para usos medicinais, cir�rgicos ou dent�rios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301200','Luvas cir�rgicas e luvas de procedimento - neutra')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301300','Preservativo - neutra')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301400','Seringas, mesmo com agulhas - neutra')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301500','Agulhas para seringas - neutra')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301600','Contraceptivos (dispositivos intra-uterinos - DIU) - neutra')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1400100','Filtros descart�veis para coar caf� ou ch�')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1400200','Bandejas, travessas, pratos, x�caras ou ch�venas, ta�as, copos e artigos semelhantes, de papel ou cart�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1400300','Papel para cigarro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1500100','Lonas pl�sticas, exceto as para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1500200','Artefatos de higiene/toucador de pl�stico, exceto os para uso na constru��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1500300','Servi�os de mesa e outros utens�lios de mesa ou de cozinha, de pl�stico, inclusive os descart�veis')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1500400','Sacos de lixo de conte�do igual ou inferior a 100 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600100','Pneus novos, dos tipos utilizados em autom�veis de passageiros (inclu�dos os ve�culos de uso misto - camionetas e os autom�veis de corrida)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600200','Pneus novos, dos tipos utilizados em caminh�es (inclusive para os fora-de-estrada), �nibus, avi�es, m�quinas de terraplenagem, de constru��o e conserva��o de estradas, m�quinas e tratores agr�colas, p�-carregadeira')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600300','Pneus novos para motocicletas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600400','Outros tipos de pneus novos, exceto para bicicletas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600500','Pneus novos de borracha dos tipos utilizados em bicicletas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600600','Pneus recauchutados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600700','Protetores de borracha, exceto para bicicletas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600701','Protetores de borracha para bicicletas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600800','C�maras de ar de borracha, exceto para bicicletas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600900','C�maras de ar de borracha dos tipos utilizados em bicicletas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700100','Chocolate branco, em embalagens de conte�do inferior ou igual a 1 kg, exclu�dos os ovos de p�scoa de chocolate.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700200','Chocolates contendo cacau, em embalagens de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700300','Chocolate em barras, tabletes ou blocos ou no estado l�quido, em pasta, em p�, gr�nulos ou formas semelhantes, em recipientes ou embalagens imediatas de conte�do inferior ou igual a 2 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700400','Chocolates e outras prepara��es aliment�cias contendo cacau, em embalagens de conte�do inferior ou igual a 1 kg, exclu�dos os achocolatados em p� e ovos de p�scoa de chocolate.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700500','Ovos de p�scoa de chocolate')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700600','Achocolatados em p�, em embalagens de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700700','Caixas de bombons contendo cacau, em embalagens de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700800','Bombons, inclusive � base de chocolate branco sem cacau')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700900','Bombons, balas, caramelos, confeitos, pastilhas e outros produtos de confeitaria, contendo cacau')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701000','Sucos de frutas ou de produtos hort�colas; mistura de sucos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701100','�gua de coco')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701200','Leite em p�, blocos ou gr�nulos, exceto creme de leite')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701300','Farinha l�ctea')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701400','Leite modificado para alimenta��o de crian�as')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701500','Prepara��es para alimenta��o infantil � base de farinhas, grumos, s�molas ou amidos e outros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701600','Leite �longa vida� (UHT - �Ultra High Temperature�), em recipiente de conte�do inferior ou igual a 2 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701601','Leite �longa vida� (UHT - �Ultra High Temperature�), em recipiente de conte�do superior a 2 litros e inferior ou igual a 5 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701700','Leite em recipiente de conte�do inferior ou igual a 1 litro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701701','Leite em recipiente de conte�do superior a 1 litro e inferior ou igual a 5 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701800','Leite do tipo pasteurizado em recipiente de conte�do inferior ou igual a 1 litro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701801','Leite do tipo pasteurizado em recipiente de conte�do superior a 1 litro e inferior ou igual a 5 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701900','Creme de leite, em recipiente de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701901','Creme de leite, em recipiente de conte�do superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701902','Outros cremes de leite, em recipiente de conte�do inferior ou igual a 1kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702000','Leite condensado, em recipiente de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702001','Leite condensado, em recipiente de conte�do superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702100','Iogurte e leite fermentado em recipiente de conte�do inferior ou igual a 2 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702101','Iogurte e leite fermentado em recipiente de conte�do superior a 2 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702200','Coalhada')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702300','Requeij�o e similares, em recipiente de conte�do inferior ou igual a 1 kg, exceto as embalagens individuais de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702301','Requeij�o e similares, em recipiente de conte�do superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702400','Queijos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702500','Manteiga, em embalagem de conte�do inferior ou igual a 1 kg, exceto as embalagens individuais de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702501','Manteiga, em embalagem de conte�do superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702600','Margarina em recipiente de conte�do inferior ou igual a 500 g, exceto as embalagens individuais de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702700','Margarina, em recipiente de conte�do superior a 500 g e inferior a 1 kg, creme vegetal em recipiente de conte�do inferior a 1 kg, exceto as embalagens individuais de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702701','Margarina e creme vegetal, em recipiente de conte�do de 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702702','Outras margarinas e cremes vegetais em recipiente de conte�do inferior a 1 kg, exceto as embalagens individuais de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702800','Gorduras e �leos vegetais e respectivas fra��es, parcial ou totalmente hidrogenados, interesterificados, reesterificados ou elaidinizados, mesmo refinados, mas n�o preparados de outro modo, em recipiente de conte�do inferior ou igual a 1 kg, exceto as embalagens individuais de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702801','Gorduras e �leos vegetais e respectivas fra��es, parcial ou totalmente hidrogenados, interesterificados, reesterificados ou elaidinizados, mesmo refinados, mas n�o preparados de outro modo, em recipiente de conte�do superior a 1 kg, exceto as embalagens individuais de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702900','Doces de leite')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703000','Produtos � base de cereais, obtidos por expans�o ou torrefa��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703100','Salgadinhos diversos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703200','Batata frita, inhame e mandioca fritos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703300','Amendoim e castanhas tipo aperitivo, em embalagem de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703301','Amendoim e castanhas tipo aperitivo, em embalagem de conte�do superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703400','Catchup em embalagens imediatas de conte�do inferior ou igual a 650 g, exceto as embalagens contendo envelopes individualizados (sach�s) de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703500','Condimentos e temperos compostos, incluindo molho de pimenta e outros molhos, em embalagens imediatas de conte�do inferior ou igual a 1 kg, exceto as embalagens contendo envelopes individualizados (sach�s) de conte�do inferior ou igual a 3 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703600','Molhos de soja preparados em embalagens imediatas de conte�do inferior ou igual a 650 g, exceto as embalagens contendo envelopes individualizados (sach�s) de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703700','Farinha de mostarda em embalagens de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703800','Mostarda preparada em embalagens imediatas de conte�do inferior ou igual a 650 g, exceto as embalagens contendo envelopes individualizados (sach�s) de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703900','Maionese em embalagens imediatas de conte�do inferior ou igual a 650 g, exceto as embalagens contendo envelopes individualizados (sach�s) de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704000','Tomates preparados ou conservados, exceto em vinagre ou em �cido ac�tico, em embalagens de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704100','Molhos de tomate em embalagens imediatas de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704200','Barra de cereais')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704300','Barra de cereais contendo cacau')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704400','Farinha de trigo, em embalagem inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704401','Farinha de trigo, em embalagem superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704500','Farinha de mistura de trigo com centeio (m�teil)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704600','Misturas e prepara��es para bolos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704700','Massas aliment�cias tipo instant�nea')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704800','Massas aliment�cias, cozidas ou recheadas (de carne ou de outras subst�ncias) ou preparadas de outro modo, exceto as massas aliment�cias tipo instant�nea')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704801','Cuscuz')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704900','Massas aliment�cias n�o cozidas, nem recheadas, nem preparadas de outro modo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705000','P�es industrializados, inclusive de especiarias, exceto panetones e bolo de forma')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705100','Bolo de forma, inclusive de especiarias')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705200','Panetones')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705300','Biscoitos e bolachas derivados de farinha de trigo; exceto dos tipos "cream cracker", "�gua e sal", "maisena", "maria" e outros de consumo popular, n�o adicionados de cacau, nem recheados, cobertos ou amanteigados, independentemente de sua denomina��o comercial')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705400','Biscoitos e bolachas n�o derivados de farinha de trigo; exceto dos tipos "cream cracker", "�gua e sal", "maisena" e "maria" e outros de consumo popular, n�o adicionados de cacau, nem recheados, cobertos ou amanteigados, independentemente de sua denomina��o comercial')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705500','Biscoitos e bolachas dos tipos "cream cracker", "�gua e sal", "maisena" e "maria" e outros de consumo popular, adicionados de edulcorantes e n�o adicionados de cacau, nem recheados, cobertos ou amanteigados, independentemente de sua denomina��o comercial')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705600','Biscoitos e bolachas dos tipos "cream cracker", "�gua e sal", "maisena" e "maria" e outros de consumo popular, n�o adicionados de cacau, nem recheados, cobertos ou amanteigados, independentemente de sua denomina��o comercial')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705700','�Waffles� e �wafers� - sem cobertura')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705800','�Waffles� e �wafers�- com cobertura')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705900','Torradas, p�o torrado e produtos semelhantes torrados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706000','Outros p�es de forma')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706100','Outras bolachas, exceto casquinhas para sorvete')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706200','Outros p�es e bolos industrializados e produtos de panifica��o n�o especificados anteriormente; exceto casquinhas para sorvete e p�o franc�s de at� 200 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706300','P�o denominado knackebrot')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706400','Demais p�es industrializados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706500','�leo de soja refinado, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conte�do inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706600','�leo de amendoim refinado, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conte�do inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706700','Azeites de oliva, em recipientes com capacidade inferior ou igual a 2 litros, exceto as embalagens individuais de conte�do inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706701','Azeites de oliva, em recipientes com capacidade superior a 2 litros e inferior ou igual a 5 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706702','Azeites de oliva, em recipientes com capacidade superior a 5 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706800','Outros �leos e respectivas fra��es, obtidos exclusivamente a partir de azeitonas, mesmo refinados, mas n�o quimicamente modificados, e misturas desses �leos ou fra��es com �leos ou fra��es da posi��o 15.09, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conte�do inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706900','�leo de girassol ou de algod�o refinado, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conte�do inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707000','�leo de canola, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conte�do inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707100','�leo de linha�a refinado, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conte�do inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707200','�leo de milho refinado, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conte�do inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707300','Outros �leos refinados, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conte�do inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707400','Misturas de �leos refinados, para consumo humano, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conte�do inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707500','Outros �leos vegetais comest�veis n�o especificados anteriormente')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707600','Enchidos (embutidos) e produtos semelhantes, de carne, miudezas ou sangue; exceto salsicha, lingui�a e mortadela')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707700','Salsicha e lingui�a')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707800','Mortadela')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707900','Outras prepara��es e conservas de carne, miudezas ou de sangue')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708000','Prepara��es e conservas de peixes; caviar e seus suced�neos preparados a partir de ovas de peixe; exceto sardinha em conserva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708100','Sardinha em conserva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708200','Crust�ceos, moluscos e outros invertebrados aqu�ticos, preparados ou em conservas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708300','Carne de gado bovino, ovino e bufalino e produtos comest�veis resultantes da matan�a desse gado submetidos � salga, secagem ou desidrata��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708400','Carne de gado bovino, ovino e bufalino e demais produtos comest�veis resultantes da matan�a desse gado frescos, refrigerados ou congelados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708500','Carnes de animais das esp�cies caprina, frescas, refrigeradas ou congeladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708600','Carnes e demais produtos comest�veis frescos, resfriados, congelados, salgados ou salmourados resultantes do abate de caprinos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708700','Carnes e demais produtos comest�veis frescos, resfriados, congelados, salgados, em salmoura, simplesmente temperados, secos ou defumados, resultantes do abate de aves e de su�nos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708800','Produtos hort�colas, cozidos em �gua ou vapor, congelados, em embalagens de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708801','Produtos hort�colas, cozidos em �gua ou vapor, congelados, em embalagens de conte�do superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708900','Frutas, n�o cozidas ou cozidas em �gua ou vapor, congeladas, mesmo adicionadas de a��car ou de outros edulcorantes, em embalagens de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708901','Frutas, n�o cozidas ou cozidas em �gua ou vapor, congeladas, mesmo adicionadas de a��car ou de outros edulcorantes, em embalagens de conte�do superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709000','Produtos hort�colas, frutas e outras partes comest�veis de plantas, preparados ou conservados em vinagre ou em �cido ac�tico, em embalagens de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709001','Produtos hort�colas, frutas e outras partes comest�veis de plantas, preparados ou conservados em vinagre ou em �cido ac�tico, em embalagens de conte�do superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709100','Outros produtos hort�colas preparados ou conservados, exceto em vinagre ou em �cido ac�tico, congelados, com exce��o dos produtos da posi��o 20.06, em embalagens de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709101','Outros produtos hort�colas preparados ou conservados, exceto em vinagre ou em �cido ac�tico, congelados, com exce��o dos produtos da posi��o 20.06, em embalagens de conte�do superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709200','Outros produtos hort�colas preparados ou conservados, exceto em vinagre ou em �cido ac�tico, n�o congelados, com exce��o dos produtos da posi��o 20.06, exclu�dos batata, inhame e mandioca fritos, em embalagens de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709201','Outros produtos hort�colas preparados ou conservados, exceto em vinagre ou em �cido ac�tico, n�o congelados, com exce��o dos produtos da posi��o 20.06, exclu�dos batata, inhame e mandioca fritos, em embalagens de conte�do superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709300','Produtos hort�colas, frutas, cascas de frutas e outras partes de plantas, conservados com a��car (passados por calda, glaceados ou cristalizados), em embalagens de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709301','Produtos hort�colas, frutas, cascas de frutas e outras partes de plantas, conservados com a��car (passados por calda, glaceados ou cristalizados), em embalagens de conte�do superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709400','Doces, gel�ias, �marmelades�, pur�s e pastas de frutas, obtidos por cozimento, com ou sem adi��o de a��car ou de outros edulcorantes, em embalagens de conte�do inferior ou igual a 1 kg, exceto as embalagens individuais de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709401','Doces, gel�ias, �marmelades�, pur�s e pastas de frutas, obtidos por cozimento, com ou sem adi��o de a��car ou de outros edulcorantes, em embalagens de conte�do superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709500','Frutas e outras partes comest�veis de plantas, preparadas ou conservadas de outro modo, com ou sem adi��o de a��car ou de outros edulcorantes ou de �lcool, n�o especificadas nem compreendidas em outras posi��es, exclu�dos os amendoins e castanhas tipo aperitivo, da posi��o 2008.1, em embalagens de conte�do inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709501','Frutas e outras partes comest�veis de plantas, preparadas ou conservadas de outro modo, com ou sem adi��o de a��car ou de outros edulcorantes ou de �lcool, n�o especificadas nem compreendidas em outras posi��es, exclu�dos os amendoins e castanhas tipo aperitivo, da posi��o 2008.1, em embalagens superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709600','Caf� torrado e mo�do, em embalagens de conte�do inferior ou igual a 2 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709601','Caf� torrado e mo�do, em embalagens de conte�do superior a 2 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709700','Ch�, mesmo aromatizado')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709800','Mate')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709900','A��car refinado, em embalagens de conte�do inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (sach�s) de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709901','A��car refinado, em embalagens de conte�do superior a 2 kg e inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709902','A��car refinado, em embalagens de conte�do superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710000','A��car refinado adicionado de aromatizante ou de corante em embalagens de conte�do inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (sach�s) de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710001','A��car refinado adicionado de aromatizante ou de corante em embalagens de conte�do superior a 2 kg e inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710002','A��car refinado adicionado de aromatizante ou de corante em embalagens de conte�do superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710100','A��car cristal, em embalagens de conte�do inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (sach�s) de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710101','A��car cristal, em embalagens de conte�do superior a 2 kg e inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710102','A��car cristal, em embalagens de conte�do superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710200','A��car cristal adicionado de aromatizante ou de corante, em embalagens de conte�do inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (sach�s) de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710201','A��car cristal adicionado de aromatizante ou de corante, em embalagens de conte�do superior a 2 kg e inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710202','A��car cristal adicionado de aromatizante ou de corante, em embalagens de conte�do superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710300','Outros tipos de a��car, em embalagens de conte�do inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (sach�s) de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710301','Outros tipos de a��car, em embalagens de conte�do superior a 2 kg e inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710302','Outros tipos de a��car, em embalagens de conte�do superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710400','Outros tipos de a��car adicionado de aromatizante ou de corante, em embalagens de conte�do inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (sach�s) de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710401','Outros tipos de a��car adicionado de aromatizante ou de corante, em embalagens de conte�do superior a 2 kg e inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710402','Outros tipos de a��car adicionado de aromatizante ou de corante, em embalagens de conte�do superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710500','Outros a��cares em embalagens de conte�do inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (sach�s) de conte�do inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710501','Outros a��cares, em embalagens de conte�do superior a 2 kg e inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710502','Outros a��cares, em embalagens de conte�do superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710600','Milho para pipoca (micro-ondas)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710700','Extratos, ess�ncias e concentrados de caf� e prepara��es � base destes extratos, ess�ncias ou concentrados ou � base de caf�, em embalagens de conte�do inferior ou igual a 500 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710800','Extratos, ess�ncias e concentrados de ch� ou de mate e prepara��es � base destes extratos, ess�ncias ou concentrados ou � base de ch� ou de mate, em embalagens de conte�do inferior ou igual a 500 g, exceto as bebidas prontas � base de mate ou ch�')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710900','Prepara��es em p� para cappuccino e similares, em embalagens de conte�do inferior ou igual a 500 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1800100','Artigos para servi�o de mesa ou de cozinha, de porcelana, inclusive os descart�veis � estojos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1800200','Artigos para servi�o de mesa ou de cozinha, de porcelana, inclusive os descart�veis � avulsos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1800300','Artigos para servi�o de mesa ou de cozinha, de cer�mica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1800400','Velas para filtros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900100','Tinta guache')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900200','Espiral - perfil para encaderna��o, de pl�stico e outros materiais classificados nas posi��es 3901 a 3914')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900300','Outros espirais - perfil para encaderna��o, de pl�stico e outros materiais classificados nas posi��es 3901 a 3914')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900400','Artigos de escrit�rio e artigos escolares de pl�stico e outros materiais classificados nas posi��es 3901 a 3914, exceto estojos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900500','Maletas e pastas para documentos e de estudante, e artefatos semelhantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900600','Prancheta de pl�stico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900700','Bobina para fax')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900800','Papel seda')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900900','Bobina para m�quina de calcular,  PDV ou equipamentos similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901000','Cartolina escolar e papel cart�o, brancos e coloridos; recados auto adesivos (LP note); pap�is de presente, todos cortados em tamanho pronto para uso escolar e dom�stico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901100','Papel fotogr�fico, exceto: (i) os pap�is fotogr�ficos emulsionados com haleto de prata tipo brilhante, matte ou lustre, em rolo e, com largura igual ou superior a 102 mm e comprimento inferior ou igual a 350 m, (ii) os pap�is fotogr�ficos emulsionados com haleto de prata tipo brilhante ou fosco, em folha e com largura igual ou superior a 152 mm e comprimento inferior ou igual a 307 mm, (iii) papel de qualidade fotogr�fica com tecnologia �Thermo-autochrome�, que submetido a um processo de aquecimento seja ca')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901200','Papel alma�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901300','Papel hectogr�fico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901400','Papel celofane e tipo celofane')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901500','Papel imperme�vel')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901600','Papel crepon')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901700','Papel fantasia')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901800','Papel-carbono, papel autocopiativo (exceto os vendidos em rolos de di�metro igual ou superior a 60 cm e os vendidos em folhas de formato igual ou superior a 60 cm de altura e igual ou superior a 90 cm de largura) e outros pap�is para c�pia ou duplica��o (inclu�dos os pap�is para est�nceis ou para chapas ofsete), est�nceis completos e chapas ofsete, de papel, em folhas, mesmo acondicionados em caixas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901900','Envelopes, aerogramas, bilhetes-postais n�o ilustrados e cart�es para correspond�ncia, de papel ou cart�o, caixas, sacos e semelhantes, de papel ou cart�o, contendo um sortido de artigos para correspond�ncia')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902000','Livros de registro e de contabilidade, blocos de notas,de encomendas, de recibos, de apontamentos, de papel para cartas, agendas e artigos semelhantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902100','Cadernos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902200','Classificadores, capas para encaderna��o (exceto as capas para livros) e capas de processos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902300','Formul�rios em blocos tipo "manifold", mesmo com folhas intercaladas de papel-carbono')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902400','�lbuns para amostras ou para cole��es')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902500','Pastas para documentos, outros artigos escolares, de escrit�rio ou de papelaria, de papel ou cart�o e capas para livros, de papel ou cart�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902600','Cart�es postais impressos ou ilustrados, cart�es impressos com votos ou mensagens pessoais, mesmo ilustrados, com ou sem envelopes, guarni��es ou aplica��es (conhecidos como cart�es de express�o social - de �poca/sentimento)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902700','Canetas esferogr�ficas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902800','Canetas e marcadores, com ponta de feltro ou com outras pontas porosas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902900','Canetas tinteiro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1903000','Outras canetas; sortidos de canetas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1903100','Papel cortado "cutsize" (tipo A3, A4, of�cio I e II, carta e outros)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1903200','Papel camur�a')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1903300','Papel laminado e papel espelho')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000100','Henna (embalagens de conte�do inferior ou igual a 200 g)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000101','Henna (embalagens de conte�do superior a 200 g)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000200','Vaselina')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000300','Amon�aco em solu��o aquosa (am�nia)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000400','Per�xido de hidrog�nio, em embalagens de conte�do inferior ou igual a 500 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000500','Lubrifica��o �ntima')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000600','�leos essenciais (desterpenados ou n�o), inclu�dos os chamados "concretos" ou "absolutos"; resin�ides; oleorresinas de extra��o; solu��es concentradas de �leos essenciais em gorduras, em �leos fixos, em ceras ou em mat�rias an�logas, obtidas portratamento de flores atrav�s de subst�ncias gordas ou por macera��o; subprodutos terp�nicos residuais da desterpena��o dos �leos essenciais; �guas destiladas arom�ticas e solu��es aquosas de �leos essenciais, em embalagens de conte�do inferior ou igual a 500 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000700','Perfumes (extratos)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000800','�guas-de-col�nia')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000900','Produtos de maquilagem para os l�bios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001000','Sombra, delineador, l�pis para sobrancelhas e r�mel')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001100','Outros produtos de maquilagem para os olhos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001200','Prepara��es para manicuros e pedicuros, incluindo removedores de esmalte � base de acetona')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001300','P�s, inclu�dos os compactos, para maquilagem')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001400','Cremes de beleza, cremes nutritivos e lo��es t�nicas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001500','Outros produtos de beleza ou de maquilagem preparados e prepara��es para conserva��o ou cuidados da pele, exceto as prepara��es solares e antisolares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001600','Prepara��es solares e antisolares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001700','Xampus para o cabelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001800','Prepara��es para ondula��o ou alisamento, permanentes, dos cabelos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001900','Laqu�s para o cabelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002000','Outras prepara��es capilares, incluindo m�scaras e finalizadores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002100','Condicionadores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002200','Tintura para o cabelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002300','Dentifr�cios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002400','Fios utilizados para limpar os espa�os interdentais (fios dentais)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002500','Outras prepara��es para higiene bucal ou dent�ria')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002600','Prepara��es para barbear (antes, durante ou ap�s)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002700','Desodorantes (desodorizantes) corporais l�quidos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002800','Antiperspirantes l�quidos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002900','Outros desodorantes (desodorizantes) corporais')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003000','Outros antiperspirantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003100','Sais perfumados e outras prepara��es para banhos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003200','Outros produtos de perfumaria ou de toucador preparados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003300','Solu��es para lentes de contato ou para olhos artificiais')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003400','Sab�es de toucador em barras, peda�os ou figuras moldados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003500','Outros sab�es, produtos e prepara��es, em barras, peda�os ou figuras moldados, inclusive len�os umedecidos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003600','Sab�es de toucador sob outras formas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003700','Produtos e prepara��es org�nicos tensoativos para lavagem da pele, na forma de l�quido ou de creme, acondicionados para venda a retalho, mesmo contendo sab�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003800','Bolsa para gelo ou para �gua quente')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003900','Chupetas e bicos para mamadeiras e para chupetas, de borracha')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004000','Chupetas e bicos para mamadeiras e para chupetas, de silicone')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004100','Malas e maletas de toucador')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004200','Papel higi�nico - folha simples')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004300','Papel higi�nico - folha dupla e tripla')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004400','Len�os (inclu�dos os de maquilagem) e toalhas de m�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004500','Papel toalha de uso institucional do tipo comercializado em rolos igual ou superior a 80 metros e do tipo comercializado em folhas intercaladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004600','Toalhas e guardanapos de mesa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004700','Toalhas de cozinha (papel toalha de uso dom�stico)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004800','Fraldas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004900','Tamp�es higi�nicos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005000','Absorventes higi�nicos externos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005100','Hastes flex�veis (uso n�o medicinal)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005200','Suti� descart�vel, assemelhados e papel para depila��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005300','Pin�as para sobrancelhas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005400','Esp�tulas (artigos de cutelaria)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005500','Utens�lios e sortidos de utens�lios de manicuros ou de pedicuros (inclu�das as limas para unhas)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005600','Term�metros, inclusive o digital')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005700','Escovas e pinc�is de barba, escovas para cabelos, para c�lios ou para unhas e outras escovas de toucador de pessoas, inclu�das as que sejam partes de aparelhos, exceto escovas de dentes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005800','Escovas de dentes, inclu�das as escovas para dentaduras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005900','Pinc�is para aplica��o de produtos cosm�ticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2006000','Sortidos de viagem, para toucador de pessoas para costura ou para limpeza de cal�ado ou de roupas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2006100','Pentes, travessas para cabelo e artigos semelhantes; grampos (alfinetes) para cabelo; pin�as (pinceguiches), onduladores, bobes (rolos) e artefatos semelhantes para penteados, e suas partes, exceto os classificados na posi��o 8516 e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2006200','Borlas ou esponjas para p�s ou para aplica��o de outros cosm�ticos ou de produtos de toucador')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2006300','Mamadeiras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2006400','Aparelhos e l�minas de barbear')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100100','Fog�es de cozinha de uso dom�stico e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100200','Combina��es de refrigeradores e congeladores ("freezers"), munidos de portas exteriores separadas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100300','Refrigeradores do tipo dom�stico, de compress�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100400','Outros refrigeradores do tipo dom�stico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100500','Congeladores ("freezers") horizontais tipo arca, de capacidade n�o superior a 800 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100600','Congeladores ("freezers") verticais tipo arm�rio, de capacidade n�o superior a 900 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100700','Outros m�veis (arcas, arm�rios, vitrines, balc�es e m�veis semelhantes) para a conserva��o e exposi��o de produtos, que incorporem um equipamento para a produ��o de frio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100800','Mini adega e similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100900','M�quinas para produ��o de gelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101000','Partes dos refrigeradores, congeladores, mini adegas e similares, m�quinas para produ��o de gelo e bebedouros descritos nos itens 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0 e 13.0.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101100','Secadoras de roupa de uso dom�stico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101200','Outras secadoras de roupas e centr�fugas de uso dom�stico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101300','Bebedouros refrigerados para �gua')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101400','Partes das secadoras de roupas e centr�fugas de uso dom�stico e dos aparelhos para filtrar ou depurar �gua, descritos nos itens 11.0 e 12.0 e 98.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101500','M�quinas de lavar lou�a do tipo dom�stico e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101600','M�quinas que executem pelo menos duas das seguintes fun��es: impress�o, c�pia ou transmiss�o de telec�pia (fax), capazes de ser conectadas a uma m�quina autom�tica para processamento de dados ou a uma rede')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101700','Outras impressoras, m�quinas copiadoras e telecopiadores (fax), mesmo combinados entre si, capazes de ser conectados a uma m�quina autom�tica para processamento de dados ou a uma rede')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101800','Partes e acess�rios de m�quinas e aparelhos de impress�o por meio de blocos, cilindros e outros elementos de impress�o da posi��o 8442; e de outras impressoras, m�quinas copiadoras e telecopiadores (fax), mesmo combinados entre si')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101900','M�quinas de lavar roupa, mesmo com dispositivos de secagem, de uso dom�stico, de capacidade n�o superior a 10 kg, em peso de roupa seca, inteiramente autom�ticas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102000','Outras m�quinas de lavar roupa, mesmo com dispositivos de secagem, de uso dom�stico, com secador centr�fugo incorporado')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102100','Outras m�quinas de lavar roupa, mesmo com dispositivos de secagem, de uso dom�stico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102200','M�quinas de lavar roupa, mesmo com dispositivos de secagem, de uso dom�stico, de capacidade superior a 10 kg, em peso de roupa seca')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102300','Partes de m�quinas de lavar roupa, mesmo com dispositivos de secagem, de uso dom�stico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102400','M�quinas de secar de uso dom�stico de capacidade n�o superior a 10 kg, em peso de roupa seca')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102500','Outras m�quinas de secar de uso dom�stico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102600','Partes de m�quinas de secar de uso dom�stico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102700','M�quinas de costura de uso dom�stico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102800','M�quinas autom�ticas para processamento de dados, port�teis, de peso n�o superior a 10 kg, contendo pelo menos uma unidade central de processamento, um teclado e uma tela')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102900','Outras m�quinas autom�ticas para processamento de dados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103000','Unidades de processamento, de pequena capacidade, exceto as das subposi��es 8471.41 ou 8471.49, podendo conter, no mesmo corpo, um ou dois dos seguintes tipos de unidades: unidade de mem�ria, unidade de entrada e unidade de sa�da;baseadas em microprocessadores, com capacidade de instala��o, dentro do mesmo gabinete, de unidades de mem�ria da subposi��o 8471.70, podendo conter m�ltiplos conectores de expans�o ("slots"), e valor FOB inferior ou igual a US$ 12.500,00, por unidade')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103100','Unidades de entrada, exceto as classificadas no c�digo 8471.60.54')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103200','Outras unidades de entrada ou de sa�da, podendo conter, no mesmo corpo, unidades de mem�ria')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103300','Unidades de mem�ria')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103400','Outras m�quinas autom�ticas para processamento de dados e suas unidades; leitores magn�ticos ou �pticos, m�quinas para registrar dados em suporte sob forma codificada, e m�quinas para processamento desses dados, n�o especificadas nem compreendidas em outras posi��es')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103500','Partes e acess�rios das m�quinas da posi��o 84.71')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103600','Outros transformadores, exceto os classificados nos c�digos 8504.33.00 e 8504.34.00')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103700','Carregadores de acumuladores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103800','Equipamentos de alimenta��o ininterrupta de energia (UPS ou "no break")')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103900','Outros acumuladores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104000','Aspiradores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104100','Aparelhos eletromec�nicos de motor el�trico incorporado, de uso dom�stico e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104200','Enceradeiras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104300','Chaleiras el�tricas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104400','Ferros el�tricos de passar')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104500','Fornos de microondas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104600','Outros fornos; fogareiros (inclu�das as chapas de coc��o), grelhas e assadeiras, exceto os port�teis')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104700','Outros fornos; fogareiros (inclu�das as chapas de coc��o), grelhas e assadeiras, port�teis')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104800','Outros aparelhos eletrot�rmicos de uso dom�stico - Cafeteiras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104900','Outros aparelhos eletrot�rmicos de uso dom�stico - Torradeiras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105000','Outros aparelhos eletrot�rmicos de uso dom�stico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105100','Partes das chaleiras, ferros, fornos e outros aparelhos eletrot�rmicos da posi��o 85.16, descritos nos itens 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0 e 50.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105200','Aparelhos telef�nicos por fio com unidade auscultador - microfone sem fio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105300','Telefones para redes celulares, exceto por sat�lite e os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105400','Outros telefones para outras redes sem fio, exceto para redes de celulares e os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105500','Outros aparelhos telef�nicos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105600','Aparelhos para transmiss�o ou recep��o de voz, imagem ou outros dados em rede com fio, exceto os classificados nos c�digos 8517.62.51, 8517.62.52 e 8517.62.53')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105700','Microfones e seus suportes; altofalantes, mesmo montados nos seus recept�culos, fones de ouvido (auscultadores), mesmo combinados com microfone e conjuntos ou sortidos constitu�dos por um microfone e um ou mais alto-falantes, amplificadores el�tricos de audiofreq��ncia, aparelhos el�tricos de amplifica��o de som; suas partes e acess�rios; exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105800','Aparelhos de radiodifus�o suscet�veis de funcionarem sem fonte externa de energia. Aparelhos de grava��o de som; aparelhos de reprodu��o de som; aparelhos de grava��o e de reprodu��o de som; partes e acess�rios; exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105900','Outros aparelhos de grava��o de som; aparelhos de reprodu��o de som; aparelhos de grava��o e de reprodu��o de som; partes e acess�rios; exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106000','Gravador-reprodutor e editor de imagem e som, em discos, por meio magn�tico, �ptico ou optomagn�tico, exceto de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106100','Outros aparelhos videof�nicos de grava��o ou reprodu��o, mesmo incorporando um receptor de sinais videof�nicos, exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106200','Cart�es de mem�ria ("memory cards")')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106300','Cart�es inteligentes ("smart cards")')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106400','Cart�es inteligentes ("sim cards")')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106500','C�meras fotogr�ficas digitais e c�meras de v�deo e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106600','Outros aparelhos receptores para radiodifus�o, mesmo combinados num inv�lucro, com um aparelho de grava��o ou de reprodu��o de som, ou com um rel�gio, inclusive caixa ac�stica para Home Theaters classificados na posi��o 8518')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106700','Monitores e projetores que n�o incorporem aparelhos receptores de televis�o, policrom�ticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106800','Outros monitores dos tipos utilizados exclusiva ou principalmente com uma m�quina autom�tica para processamento de dados da posi��o 84.71, policrom�ticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106900','Aparelhos receptores de televis�o, mesmo que incorporem um aparelho receptor de radiodifus�o ou um aparelho de grava��o ou reprodu��o de som ou de imagens - Televisores de CRT (tubo de raios cat�dicos)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107000','Aparelhos receptores de televis�o, mesmo que incorporem um aparelho receptor de radiodifus�o ou um aparelho de grava��o ou reprodu��o de som ou de imagens - Televisores de LCD (Display de Cristal L�quido)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107100','Aparelhos receptores de televis�o, mesmo que incorporem um aparelho receptor de radiodifus�o ou um aparelho de grava��o ou reprodu��o de som ou de imagens - Televisores de Plasma')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107200','Outros aparelhos receptores de televis�o n�o dotados de monitores ou display de v�deo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107300','Outros aparelhos receptores de televis�o n�o relacionados em outros itens deste anexo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107400','C�meras fotogr�ficas dos tipos utilizadas para prepara��o de clich�s ou cilindros de impress�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107500','C�meras fotogr�ficas para filmes de revela��o e copiagem instant�neas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107600','Aparelhos de diatermia')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107700','Aparelhos de massagem')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107800','Reguladores de voltagem eletr�nicos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107900','Consoles e m�quinas de jogos de v�deo, exceto os classificados na subposi��o 9504.30')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108000','Multiplexadores e concentradores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108100','Centrais autom�ticas privadas, de capacidade inferior ou igual a 25 ramais')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108200','Outros aparelhos para comuta��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108300','Roteadores digitais, em redes com ou sem fio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108400','Aparelhos emissores com receptor incorporado de sistema troncalizado ("trunking"), de tecnologia celular')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108500','Outros aparelhos de recep��o, convers�o e transmiss�o ou regenera��o de voz, imagens ou outros dados, incluindo os aparelhos de comuta��o e roteamento')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108600','Antenas pr�prias para telefones celulares port�teis, exceto as telesc�picas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108700','Aparelhos ou m�quinas de barbear, m�quinas de cortar o cabelo ou de tosquiar e aparelhos de depilar, e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108800','Ventiladores, exceto os de uso agr�cola')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108900','Ventiladores de uso agr�cola')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109000','Coifas com dimens�o horizontal m�xima n�o superior a 120 cm')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109100','Partes de ventiladores ou coifas aspirantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109200','M�quinas e aparelhos de ar condicionado contendo um ventilador motorizado e dispositivos pr�prios para modificar a temperatura e a umidade, inclu�dos as m�quinas e aparelhos em que a umidade n�o seja regul�vel separadamente')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109300','Aparelhos de ar-condicionado tipo Split System (sistema com elementos separados) com unidade externa e interna')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109400','Aparelhos de ar-condicionado com capacidade inferior ou igual a 30.000 frigorias/hora')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109500','Aparelhos de ar-condicionado com capacidade acima de 30.000 frigorias/hora')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109600','Unidades evaporadoras (internas) de aparelho de ar-condicionado do tipo Split System (sistema com elementos separados), com capacidade inferior ou igual a 30.000 frigorias/hora')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109700','Unidades condensadoras (externas) de aparelho de ar-condicionado do tipo Split System (sistema com elementos separados), com capacidade inferior ou igual a 30.000 frigorias/hora')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109800','Aparelhos el�tricos para filtrar ou depurar �gua')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109900','Lavadora de alta press�o e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110000','Furadeiras el�tricas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110100','Aparelhos el�tricos para aquecimento de ambientes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110200','Secadores de cabelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110300','Outros aparelhos para arranjos do cabelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110400','Aparelhos receptores para radiodifus�o, mesmo combinados num mesmo inv�lucro, com um aparelho de grava��o ou de reprodu��o de som, ou com um rel�gio, exceto os classificados na posi��o 8527.1, 8527.2 e 8527.9  que sejam de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110500','Climatizadores de ar')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110600','Outras partes para m�quinas e aparelhos de ar-condicionado que contenham um ventilador motorizado e dispositivos pr�prios para modificar a temperatura e a umidade, incluindo as m�quinas e aparelhos em que a umidade n�o seja regul�vel separadamente')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110700','C�meras de televis�o e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110800','Balan�as de uso dom�stico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110900','Tubos e v�lvulas, eletr�nicos, de c�todo quente, c�todo frio ou fotoc�todo (por exemplo, tubos e v�lvulas, de v�cuo, de vapor ou de g�s, ampolas retificadoras de vapor de merc�rio, tubos cat�dicos, tubos e v�lvulas para c�meras de televis�o)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111000','Aparelhos el�tricos para telefonia; outros aparelhos para transmiss�o ou recep��o de voz, imagens ou outros dados, inclu�dos os aparelhos para comunica��o em redes por fio ou redes sem fio (tal como uma rede local (LAN) ou uma rede de �rea estendida (WAN), inclu�das suas partes, exceto os de uso automotivo e os classificados nos c�digos  8517.62.51, 8517.62.52 e 8517.62.53')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111100','Interfones, seus acess�rios, tomadas e "plugs"')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111200','Partes reconhec�veis como exclusiva ou principalmente destinadas aos aparelhos das posi��es 8525 a 8528; exceto as de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111300','Aparelhos el�tricos de sinaliza��o ac�stica ou visual (por exemplo, campainhas, sirenes, quadros indicadores, aparelhos de alarme para prote��o contra roubo ou inc�ndio); exceto os de uso automotivo e os classificados nas posi��es 8531.10 e 8531.80.00.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111400','Aparelhos el�tricos de alarme, para prote��o contra roubo ou inc�ndio e aparelhos semelhantes, exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111500','Outros aparelhos de sinaliza��o ac�stica ou visual, exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111600','Circuitos impressos, exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111700','Diodos emissores de luz (LED), exceto diodos "laser"')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111800','Eletrificadores de cercas eletr�nicos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111900','Aparelhos e instrumentos para medida ou controle da tens�o, intensidade, resist�ncia ou da pot�ncia, sem dispositivo registrador; exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2112000','Analisadores l�gicos de circuitos digitais, de espectro de frequ�ncia, frequenc�metros, fas�metros, e outros instrumentos e aparelhos de controle de grandezas el�tricas e detec��o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2112100','Interruptores hor�rios e outros aparelhos que permitam acionar um mecanismo em tempo determinado, munidos de maquinismo de aparelhos de relojoaria ou de motor s�ncrono')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2112200','Aparelhos de ilumina��o (inclu�dos os projetores) e suas partes, n�o especificados nem compreendidos em outras posi��es; an�ncios, cartazes ou tabuletas e placas indicadoras luminosos, e artigos semelhantes, contendo uma fonte luminosa fixa permanente, e suas partes n�o especificadas nem compreendidas em outras posi��es')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2200100','Ra��o tipo �pet� para animais dom�sticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2300100','Sorvetes de qualquer esp�cie')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2300200','Preparados para fabrica��o de sorvete em m�quina')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2400100','Tintas, vernizes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2400200','Xadrez e p�s assemelhados, exceto pigmentos � base de di�xido de tit�nio classificados no c�digo 3206.11.19')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500100','Ve�culos autom�veis para transporte de 10 pessoas ou mais, incluindo o motorista, com motor de pist�o, de igni��o por compress�o (diesel ou semidiesel), com volume interno de habit�culo, destinado a passageiros e motorista, superior a 6 m�, mas inferior a 9 m�')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500200','Outros ve�culos autom�veis para transporte de 10 pessoas ou mais, incluindo o motorista, com volume interno de habit�culo, destinado a passageiros e motorista, superior a 6 m�, mas inferior a 9 m�')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500300','Autom�veis com motor explos�o, de cilindrada n�o superior a 1000 cm�')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500400','Autom�veis com motor explos�o, de cilindrada superior a 1000 cm�, mas n�o superior a 1500 cm�, com capacidade de transporte de pessoas sentadas inferior ou igual a 6, inclu�do o condutor, exceto carro celular')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500500','Outros autom�veis com motor explos�o, de cilindrada superior a 1000 cm�, mas n�o superior a 1500 cm�, exceto carro celular')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500600','Autom�veis com motor explos�o, de cilindrada superior a 1500 cm�, mas n�o superior a 3000 cm�, com capacidade de transporte de pessoas sentadas inferior ou igual a 6, inclu�do o condutor, exceto carro celular, carro funer�rio e autom�veis de corrida')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500700','Outros autom�veis com motor explos�o, de cilindrada superior a 1500 cm�, mas n�o superior a 3000 cm�, exceto carro celular, carro funer�rio e autom�veis de corrida')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500800','Autom�veis com motor explos�o, de cilindrada superior a 3000 cm�, com capacidade de transporte de pessoas sentadas inferior ou igual a 6, inclu�do o condutor, exceto carro celular, carro funer�rio e autom�veis de corrida')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500900','Outros autom�veis com motor explos�o, de cilindrada superior a 3000 cm�, exceto carro celular, carro funer�rio e autom�veis de corrida')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501000','Autom�veis com motor diesel ou semidiesel, de cilindrada superior a 1500 cm�, mas n�o superior a 2500 cm�, com capacidade de transporte de pessoas sentadas inferior ou igual a 6, inclu�do o condutor, exceto ambul�ncia, carro celular e carro funer�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501100','Outros autom�veis com motor diesel ou semidiesel, de cilindrada superior a 1500 cm�, mas n�o superior a 2500 cm�, exceto ambul�ncia, carro celular e carro funer�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501200','Autom�veis com motor diesel ou semidiesel, de cilindrada superior a 2500 cm�, com capacidade de transporte de pessoas sentadas inferior ou igual a 6, inclu�do o condutor, exceto carro celular e carro funer�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501300','Outros autom�veis com motor diesel ou semidiesel, de cilindrada superior a 2500 cm�, exceto carro celular e carro funer�rio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501400','Ve�culos autom�veis para transporte de mercadorias, de peso em carga m�xima n�o superior a 5 toneladas, chassis com motor diesel ou semidiesel e cabina, exceto caminh�o de peso em carga m�xima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501500','Ve�culos autom�veis para transporte de mercadorias, de peso em carga m�xima n�o superior a 5 toneladas, com motor diesel ou semidiesel, com caixa basculante, exceto caminh�o de peso em carga m�xima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501600','Ve�culos autom�veis para transporte de mercadorias, de peso em carga m�xima n�o superior a 5 toneladas, frigor�ficos ou isot�rmicos, com motor diesel ou semidiesel, exceto caminh�o de peso em carga m�xima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501700','Outros ve�culos autom�veis para transporte de mercadorias, de peso em carga m�xima n�o superior a 5 toneladas, com motor diesel ou semidiesel, exceto carro-forte para transporte de valores e caminh�o de peso em carga m�xima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501800','Ve�culos autom�veis para transporte de mercadorias, de peso em carga m�xima n�o superior a 5 toneladas, com motor a explos�o, chassis e cabina, exceto caminh�o de peso em carga m�xima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501900','Ve�culos autom�veis para transporte de mercadorias, de peso em carga m�xima n�o superior a 5 toneladas, com motor explos�o com caixa basculante, exceto caminh�o de peso em carga m�xima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2502000','Ve�culos autom�veis para transporte de mercadorias, de peso em carga m�xima n�o superior a 5 toneladas, frigor�ficos ou isot�rmicos com motor explos�o, exceto caminh�o de peso em carga m�xima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2502100','Outros ve�culos autom�veis para transporte de mercadorias, de peso em carga m�xima n�o superior a 5 toneladas, com motor a explos�o, exceto carro-forte para transporte de valores e caminh�o de peso em carga m�xima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2600100','Motocicletas (inclu�dos os ciclomotores) e outros ciclos equipados com motor auxiliar, mesmo com carro lateral; carros laterais')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2700100','Espelhos de vidro, mesmo emoldurados, exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2700200','Objetos de vidro para servi�o de mesa ou de cozinha')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2700300','Outros copos, exceto de vitrocer�mica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2700400','Objetos para servi�o de mesa (exceto copos) ou de cozinha, exceto de vitrocer�mica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800100','Perfumes (extratos)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800200','�guas-de-col�nia')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800300','Produtos de maquiagem para os l�bios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800400','Sombra, delineador, l�pis para sobrancelhas e r�mel')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800500','Outros produtos de maquiagem para os olhos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800600','Prepara��es para manicuros e pedicuros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800700','P�s para maquiagem, incluindo os compactos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800800','Cremes de beleza, cremes nutritivos e lo��es t�nicas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800900','Outros produtos de beleza ou de maquiagem preparados e prepara��es para conserva��o ou cuidados da pele, exceto as prepara��es antisolares e os bronzeadores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801000','Prepara��es antisolares e os bronzeadores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801100','Xampus para o cabelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801200','Prepara��es para ondula��o ou alisamento, permanentes, dos cabelos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801300','Outras prepara��es capilares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801400','Tintura para o cabelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801500','Prepara��es para barbear (antes, durante ou ap�s)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801600','Desodorantes corporais e antiperspirantes, l�quidos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801700','Outros desodorantes corporais e antiperspirantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801800','Outros produtos de perfumaria ou de toucador preparados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801900','Outras prepara��es cosm�ticas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802000','Sab�es de toucador, em barras, peda�os ou figuras moldadas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802100','Outros sab�es, produtos e prepara��es org�nicos tensoativos, inclusive papel, pastas (ouates), feltros e falsos tecidos, impregnados, revestidos ou recobertos de sab�o ou de detergentes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802200','Sab�es de toucador sob outras formas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802300','Produtos e prepara��es org�nicos tensoativos para lavagem da pele, em forma de l�quido ou de creme, acondicionados para venda a retalho, mesmo contendo sab�o')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802400','Len�os de papel, incluindo os de desmaquiar')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802500','Apontadores de l�pis para maquiagem')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802600','Utens�lios e sortidos de utens�lios de manicuros ou de pedicuros (incluindo as limas para unhas)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802700','Escovas e pinc�is de barba, escovas para cabelos, para c�lios ou para unhas e outras escovas de toucador de pessoas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802800','Pinc�is para aplica��o de produtos cosm�ticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802900','Vaporizadores de toucador, suas arma��es e cabe�as de arma��es')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803000','Borlas ou esponjas para p�s ou para aplica��o de outros cosm�ticos ou de produtos de toucador')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803100','Malas e maletas de toucador')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803200','Pentes, travessas para cabelo e artigos semelhantes; grampos (alfinetes) para cabelo; pin�as (�pinceguiches�), onduladores, bobs (rolos) e artefatos semelhantes para penteados, e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803300','Mamadeiras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803400','Chupetas e bicos para mamadeiras e para chupetas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803500','Outros produtos cosm�ticos e de higiene pessoal n�o relacionados em outros itens deste anexo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803600','Outros artigos destinados a cuidados pessoais n�o relacionados em outros itens deste anexo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803700','Acess�rios (por exemplo, bijuterias, rel�gios, �culos de sol, bolsas, mochilas, frasqueiras, carteiras, porta-cart�es, porta-documentos, porta-celulares e embalagens presente�veis (por exemplo, caixinhas de papel), entre outros itens assemelhados)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803800','Vestu�rio e seus acess�rios; cal�ados, polainas e artefatos semelhantes, e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803900','Outros artigos de vestu�rio em geral, exceto os relacionados no item anterior')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2804000','Artigos de casa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2804100','Produtos das ind�strias alimentares e bebidas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2804200','Produtos destinados � higiene bucal')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2804300','Produtos de limpeza e conserva��o dom�stica')

-------------------- PA 289748 ------------------

if not exists(select 1 from OPCSISTCAD where codsis = 'LIF' and codopc = '1.30')
insert into OPCSISTCAD(codsis,codopc,nomeopc,ativado,numeroativ,mediauso,numdemeses,usoultmes)
values('LIF','1.30','ICMS/DIFAL Consumidor Final','S',0,0,0,0)
GO

-------------------- PA 292088 ------------------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'vBCDif') 
alter TABLE DADOSITEMNFE add vBCDif NUMERIC(15,2) DEFAULT 0
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'pICMSDif') 
alter TABLE DADOSITEMNFE add pICMSDif NUMERIC(5,2) DEFAULT 0
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'vICMSOp') 
alter TABLE DADOSITEMNFE add vICMSOp NUMERIC(15,2) DEFAULT 0
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'pDif') 
alter TABLE DADOSITEMNFE add pDif NUMERIC(5,2) DEFAULT 0
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DADOSITEMNFE' AND COLUMN_NAME = 'VICMSDif') 
alter TABLE DADOSITEMNFE add VICMSDif NUMERIC(15,2) DEFAULT 0
go

-------------------- PA 292707 ------------------

-- Par�metros
IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37917)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','Libera mudan�a de Modo de emiss�o NF-e',18,37917,0)
go
IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37915)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','FSDA para SVC',18,37915,0)
go
IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37914)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','FSDA para EPEC',18,37914,0)
go
IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37913)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','FSDA para Normal',18,37913,0)
go
IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37912)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','SVC para FSDA',18,37912,0)
go
IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37911)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','SVC para EPEC',18,37911,0)
go
IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37910)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','SVC para Normal',18,37910,0)
go
IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37909)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','EPEC para FSDA',18,37909,0)
go
IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37908)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','EPEC para Normal',18,37908,0)
go
IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37907)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','EPEC para SVC-AN ou SVC-RS',18,37907,0)
go
IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37906)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','Normal para FSDA',18,37906,0)
go
IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37905)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','Normal para SVC-AN ou SVC-RS',18,37905,0)
go
IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37904)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','Normal para EPEC',18,37904,0)
go
IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37902)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','Tipo de Mudan�a emiss�o NF-e',18,37902,0)
GO
IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37917)
insert into categoria (rsuper, nomeinterno, oid) values (36419,'TIPO_LIBERACAO_LIBERA_MUDANCA_MODO_EMISSAO_NFE',37917)
go
IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37915)
insert into categoria (rsuper, nomeinterno, oid) values (37902,'TIPO_MUDANCA_NFE_FSDA_SVC',37915)
go
IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37914)
insert into categoria (rsuper, nomeinterno, oid) values (37902,'TIPO_MUDANCA_NFE_FSDA_EPEC',37914)
go
IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37913)
insert into categoria (rsuper, nomeinterno, oid) values (37902,'TIPO_MUDANCA_NFE_FSDA_NORMAL',37913)
go
IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37912)
insert into categoria (rsuper, nomeinterno, oid) values (37902,'TIPO_MUDANCA_NFE_SVC_FSDA',37912)
go
IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37911)
insert into categoria (rsuper, nomeinterno, oid) values (37902,'TIPO_MUDANCA_NFE_SVC_EPEC',37911)
go
IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37910)
insert into categoria (rsuper, nomeinterno, oid) values (37902,'TIPO_MUDANCA_NFE_SVC_NORMAL',37910)
go
IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37909)
insert into categoria (rsuper, nomeinterno, oid) values (37902,'TIPO_MUDANCA_NFE_EPEC_FSDA',37909)
go
IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37908)
insert into categoria (rsuper, nomeinterno, oid) values (37902,'TIPO_MUDANCA_NFE_EPEC_NORMAL',37908)
go
IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37907)
insert into categoria (rsuper, nomeinterno, oid) values (37902,'TIPO_MUDANCA_NFE_EPEC_SVC',37907)
go
IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37906)
insert into categoria (rsuper, nomeinterno, oid) values (37902,'TIPO_MUDANCA_NFE_NORMAL_FSDA',37906)
go
IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37905)
insert into categoria (rsuper, nomeinterno, oid) values (37902,'TIPO_MUDANCA_NFE_NORMAL_SVC',37905)
go
IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37904)
insert into categoria (rsuper, nomeinterno, oid) values (37902,'TIPO_MUDANCA_NFE_NORMAL_EPEC',37904)
go
IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37902)
insert into categoria (rsuper, nomeinterno, oid) values (2    ,'TIPO_MUDANCA_NFE',37902)
go
-- Tabelas
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE xtype='U' AND name='CONSULTASTATUSSERVICOSEFAZ') 
BEGIN
	create table CONSULTASTATUSSERVICOSEFAZ (
		ID INT IDENTITY NOT NULL,
		FILIAL CHAR(2),
		UF CHAR(2),
		DATA DATETIME,
		CODIGORETORNO VARCHAR(5),
		DATARETORNO DATETIME,
		TIPOMUDANCA INT,
		TEXTORETORNO VARCHAR(5000),
		TEMPORETORNO INT,
		LIBERADOPOR CHAR(3),
		CONSTRAINT PK_CONSULTASTATUSSERVICOSEFAZ PRIMARY KEY (ID))
END 
GO
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE xtype='U' AND name='STATUSFILANFE') 
BEGIN
	create table STATUSFILANFE (
		ID INT IDENTITY NOT NULL,
		FILIAL CHAR(2),
		DATA DATETIME,
		SITUACAOFILANFE NUMERIC(1,0),
		RUSUARIO INT,
		CONSTRAINT PK_STATUSFILANFE PRIMARY KEY (ID))
END
GO

-------------------- PA 293281 ------------------

IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37798)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7 ,1,1,' ','01/01/01','01/01/01','Define se a filial esta dispensada de destacar/recolher o ICMS DIFAL (Partilha de ICMS de Opera��es Interestaduais de Vendas a Consumidor Final). Valores poss�veis S ou N.','Dispensado do c�lculo do ICMS DIFAL nas vendas para n�o contribuinte fora do estado',18,37798,0)
GO

IF not EXISTS (SELECT 1 FROM CATEGORIA WHERE OID = 37798)
insert into categoria (rsuper, nomeinterno, oid) values (11767,'DISPENSADO_CALCULO_DIFAL',37798)
GO

IF not EXISTS (SELECT 1 FROM DADOADICIONAL WHERE OID = 37797)
insert into dadoadicional ( RCLASSECONCRETA,RAPLICATIVO,RDOMINIO,RLISTA,RTIPO,RITEM,RESTRICAO,VISIVEL,MASCARA,PADRAO,MAXIMO,MINIMO,VALOR,OID) values (7,1884 ,16024,7,37798,10128,0,0,'A',' ',0,0,'',37797)
GO

IF not EXISTS (SELECT 1 FROM ADITIVO WHERE OID = 37799)
insert into aditivo (RITEM,RDEFINICAO,SVALOR,OID) values (1 ,37797,'',37799)
GO

-- Adi��o de campos tabela 'BASECALFAT'

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BASECALFAT' AND COLUMN_NAME = 'BASECHEIADIFAL') 
alter TABLE dbo.BASECALFAT add BASECHEIADIFAL NUMERIC(1,0) DEFAULT 0
go

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BASECALFAT' AND COLUMN_NAME = 'PERFCP') 
alter TABLE dbo.BASECALFAT add PERFCP NUMERIC(5,2)

/*
*********************************
NUMERO:297780
*********************************
*/

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE xtype='U' AND name='RESSARCIMENTO_ST') 

BEGIN

CREATE TABLE RESSARCIMENTO_ST 

(

ID INT IDENTITY PRIMARY KEY NOT NULL, 

FILIAL CHAR(2), 

DATAINICIAL DATETIME, 

DATAFINAL DATETIME,

CODPRO CHAR (5),

NUMORD_S INT,

ITEM_S CHAR(5),

QUANT_S NUMERIC (13,3),

NUMORD_E INT,

ITEM_E CHAR(5),

QUANT_E NUMERIC (13,3),

BCICMS_E NUMERIC (18,5),

CREDITOICMS_E NUMERIC (18,5),

VALOR_UN_ST_E NUMERIC (18,5),

QUANT_RESSARCIMENTO NUMERIC (13,3),

VALOR_UN_RESSARCIMENTO NUMERIC (18,5),

VALOR_RESSARCIMENTO NUMERIC (18,5)

)

end

go

DELETE OPCSISTCAD WHERE CODSIS = 'LIF' AND CODOPC = '3.05'

INSERT INTO OPCSISTCAD (CODSIS, CODOPC, NOMEOPC, ATIVADO, RAZDESATIV, MENSAGEM, NUMEROATIV, MEDIAUSO, NUMDEMESES, USOULTMES, AUDITATIVO, ATIVPOROPC) 

VALUES ('LIF', '3.05', 'CALCULO DE RESSARCIMENTO', 'S', '', '', 0, 0, 0, 0, '', '')

/*
*********************************
NUMERO:300807
*********************************
*/
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPLNFFAT' AND COLUMN_NAME = 'OIDENDERECOFATURAMENTO') 

alter TABLE dbo.COMPLNFFAT add OIDENDERECOFATURAMENTO INT DEFAULT 0

go

/*

*********************************

NUMERO:290118

*********************************
*/
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPLEMENTONFENTRA' AND COLUMN_NAME = 'VALORFORNECIDO') 

alter TABLE COMPLEMENTONFENTRA add VALORFORNECIDO NUMERIC(15,2)

go
