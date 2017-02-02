-------------------------------------------------------------------------------------------
------------ SCRIPTs NECESSÁRIOS PARA O PROCESSAMENTO DAS NTs e NF-e em GERAL -------------
-------------------------------------------------------------------------------------------

--------------------- SEM IDENTIFICAÇÃO DO PA ----------

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
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7 ,1,1,' ','01/01/01','01/01/01','Define qual o CST deve ser utilizado na emissão da nota fiscal de devolução de compra com substituição tributária.','CST para nota de devolução de compra com substituição tributária',18,37589,0)
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
values (1884 ,7,15812,50,'','Utilizado na devolução','UTILIZADO_DEVOLUCAO',37591)
go

IF not EXISTS (SELECT 1 FROM TPOINTEGRACAO WHERE OID = 37592)
insert into tpointegracao (RAPLICATIVO,RLISTA,RDOMINIO,TIPO,PADRAO,QUESTAO,NOMEINTERNO,OID)
values (1884 ,7,15812,50,'','Exigir justificativa na emissão da NFe','EXIGIR_JUSTIFICATIVA_NFE',37592)
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
 
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('001','Imunidade','Livros, jornais, periódicos e o papel destinado à sua impressão - Art. 18 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('002','Imunidade','Produtos industrializados destinados ao exterior - Art. 18 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('003','Imunidade','Ouro, definido em lei como ativo financeiro ou instrumento cambial - Art. 18 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('004','Imunidade','Energia elétrica, derivados de petróleo, combustíveis e minerais do País - Art. 18 Inciso IV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('005','Imunidade','Exportação de produtos nacionais - sem saída do território brasileiro - venda para empresa sediada no exterior - atividades de pesquisa ou lavra de jazidas de petróleo e de gás natural - Art. 19 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('006','Imunidade','Exportação de produtos nacionais - sem saída do território brasileiro - venda para empresa sediada no exterior - incorporados a produto final exportado para o Brasil - Art. 19 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('007','Imunidade','Exportação de produtos nacionais - sem saída do território brasileiro - venda para órgão ou entidade de governo estrangeiro ou organismo internacional de que o Brasil seja membro,para ser entregue, no País, à ordem do comprador - Art. 19 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('101','Suspensão','Óleo de menta em bruto, produzido por lavradores - Art. 43 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('102','Suspensão','Produtos remetidos à exposição em feiras de amostras e promoções semelhantes - Art. 43 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('103','Suspensão','Produtos remetidos a depósitos fechados ou armazéns-gerais, bem assim aqueles devolvidos ao remetente - Art. 43 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('104','Suspensão','Produtos industrializados, que com matérias-primas (MP), produtos intermediários (PI) e material de embalagem (ME) importados submetidos a regime aduaneiro especial (drawback - suspensão/isenção), remetidos diretamente a empresas industriais exportadoras - Art. 43 Inciso IV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('105','Suspensão','Produtos, destinados à exportação, que saiam do estabelecimento industrial para empresas comerciais exportadoras, com o fim específico de exportação - Art. 43, Inciso V, alínea "a" do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('106','Suspensão','Produtos, destinados à exportação, que saiam do estabelecimento industrial para recintos alfandegados onde se processe o despacho aduaneiro de exportação - Art. 43, Inciso V, alíneas "b" do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('107','Suspensão','Produtos, destinados à exportação, que saiam do estabelecimento industrial para outros locais onde se processe o despacho aduaneiro de exportação - Art. 43, Inciso V, alíneas "c" do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('108','Suspensão','Matérias-primas (MP), produtos intermediários (PI) e material de embalagem (ME) destinados ao executor de industrialização por encomenda - Art. 43 Inciso VI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('109','Suspensão','Produtos industrializados por encomenda remetidos ao estabelecimento de origem - Art. 43 Inciso VII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('110','Suspensão','Matérias-primas ou produtos intermediários remetidos para emprego em operação industrial realizada pelo remetente fora do estabelecimento - Art. 43 Inciso VIII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('111','Suspensão','Veículo, aeronave ou embarcação destinados a emprego em provas de engenharia pelo fabricante - Art. 43 Inciso IX do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('112','Suspensão','Produtos remetidos, para industrialização ou comércio, de um para outro estabelecimento da mesma firma - Art. 43 Inciso X do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('113','Suspensão','Bens do ativo permanente remetidos a outro estabelecimento da mesma firma, para serem utilizados no processo industrial do recebedor - Art. 43 Inciso XI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('114','Suspensão','Bens do ativo permanente remetidos a outro estabelecimento, para serem utilizados no processo industrial de produtos encomendados pelo remetente - Art. 43 Inciso XII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('115','Suspensão','Partes e peças destinadas ao reparo de produtos com defeito de fabricação, quando a operação for executada gratuitamente, em virtude de garantia - Art. 43 Inciso XIII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('116','Suspensão','Matérias-primas (MP), produtos intermediários (PI) e material de embalagem (ME) de fabricação nacional, vendidos a estabelecimento industrial, para industrialização de produtos destinados à exportação ou a estabelecimento comercial, para industrialização em outro estabelecimento da mesma firma ou de terceiro, de produto destinado à exportação Art. 43 Inciso XIV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('117','Suspensão','Produtos para emprego ou consumo na industrialização ou elaboração de produto a ser exportado, adquiridos no mercado interno ou importados - Art. 43 Inciso XV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('118','Suspensão','Bebidas alcóolicas e demais produtos de produção nacional acondicionados em recipientes de capacidade superior ao limite máximo permitido para venda a varejo - Art. 44 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('119','Suspensão','Produtos classificados NCM 21.06.90.10 Ex 02, 22.01, 22.02, exceto os Ex 01 e Ex 02 do Código 22.02.90.00 e 22.03 saídos de estabelecimento industrial destinado a comercial equiparado a industrial - Art. 45 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('120','Suspensão','Produtos classificados NCM 21.06.90.10 Ex 02, 22.01, 22.02, exceto os Ex 01 e Ex 02 do Código 22.02.90.00 e 22.03 saídos de estabelecimento comercial equiparado a industrial destinado a equiparado a industrial - Art. 45 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('121','Suspensão','Produtos classificados NCM 21.06.90.10 Ex 02, 22.01, 22.02, exceto os Ex 01 e Ex 02 do Código 22.02.90.00 e 22.03 saídos de importador destinado a equiparado a industrial - Art.45 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('122','Suspensão','Matérias-primas (MP), produtos intermediários (PI) e material de embalagem (ME) destinados a estabelecimento que se dedique à elaboração de produtos classificados nos códigos previstos no art. 25 da Lei 10.684/2003 - Art. 46 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('123','Suspensão','Matérias-primas (MP), produtos intermediários (PI) e material de embalagem (ME) adquiridos por estabelecimentos industriais fabricantes de partes e peças destinadas a estabelecimento industrial fabricante de produto classificado no Capítulo 88 da Tipi - Art. 46 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('124','Suspensão','Matérias-primas (MP), produtos intermediários (PI) e material de embalagem (ME) adquiridos por pessoas jurídicas preponderantemente exportadoras - Art. 46 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('125','Suspensão','Materiais e equipamentos destinados a embarcações pré-registradas ou registradas no Registro Especial Brasileira - REB quando adquiridos por estaleiros navais brasileiros - Art. 46 Inciso IV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('126','Suspensão','Aquisição por beneficiário de regime aduaneiro suspensivo do imposto, destinado a industrialização para exportação - Art. 47 do Decreto 7.212/2010') 
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('127','Suspensão','Desembaraço de produtos de procedência estrangeira importados por lojas francas - Art. 48 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('128','Suspensão','Desembaraço de maquinas, equipamentos, veículos, aparelhos e instrumentos sem similar nacional importados por empresas nacionais de engenharia, destinados à execução de obras no exterior - Art. 48 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('129','Suspensão','Desembaraço de produtos de procedência estrangeira com saída de repartições aduaneiras com Suspensão do Imposto de Importação - Art. 48 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('130','Suspensão','Desembaraço de matérias-primas, produtos intermediários e materiais de embalagem, importados diretamente por estabelecimento de que tratam os incisos I a III do caput do Decreto 7.212/2010 - Art. 48 Inciso IV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('131','Suspensão','Remessa de produtos para a ZFM destinados ao seu consumo interno, utilização ou industrialização - Art. 84 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('132','Suspensão','Remessa de produtos para a ZFM destinados à exportação - Art. 85 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('133','Suspensão','Produtos que, antes de sua remessa à ZFM, forem enviados pelo seu fabricante a outro estabelecimento, para industrialização adicional, por conta e ordem do destinatário - Art. 85 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('134','Suspensão','Desembaraço de produtos de procedência estrangeira importados pela ZFM quando ali consumidos ou utilizados, exceto armas, munições, fumo, bebidas alcoólicas e automóveis de passageiros. - Art. 86 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('135','Suspensão','Remessa de produtos para a Amazônia Ocidental destinados ao seu consumo interno ou utilização - Art. 96 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('136','Suspensão','Entrada de produtos estrangeiros na Área de Livre Comércio de Tabatinga - ALCT destinados ao seu consumo interno ou utilização - Art. 106 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('137','Suspensão','Entrada de produtos estrangeiros na Área de Livre Comércio de Guajará-Mirim - ALCGM destinados ao seu consumo interno ou utilização - Art. 109 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('138','Suspensão','Entrada de produtos estrangeiros nas Áreas de Livre Comércio de Boa Vista - ALCBV e Bomfim - ALCB destinados a seu consumo interno ou utilização - Art. 112 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('139','Suspensão','Entrada de produtos estrangeiros na Área de Livre Comércio de Macapá e Santana - ALCMS destinados a seu consumo interno ou utilização - Art. 116 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('140','Suspensão','Entrada de produtos estrangeiros nas Áreas de Livre Comércio de Brasiléia - ALCB e de Cruzeiro do Sul - ALCCS destinados a seu consumo interno ou utilização - Art. 119 do Decreto 7.212/2010')

END
GO

IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE xtype='U' AND name='CodigoEnqIpi') 
BEGIN   

  DELETE FROM CODIGOENQIPI WHERE CODIGO >= '141' AND CODIGO <= '324'

  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('141','Suspensão','Remessa para Zona de Processamento de Exportação - ZPE - Art. 121 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('142','Suspensão','Setor Automotivo - Desembaraço aduaneiro, chassis e outros - regime aduaneiro especial - industrialização 87.01 a 87.05 - Art. 136, I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('143','Suspensão','Setor Automotivo - Do estabelecimento industrial produtos 87.01 a 87.05 da TIPI - mercado interno - empresa comercial atacadista controlada por PJ encomendante do exterior. - Art. 136, II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('144','Suspensão','Setor Automotivo - Do estabelecimento industrial - chassis e outros classificados nas posições 84.29, 84.32, 84.33, 87.01 a 87.06 e 87.11 da TIPI. - Art. 136, III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('145','Suspensão','Setor Automotivo - Desembaraço aduaneiro, chassis e outros classificados nas posições 84.29, 84.32, 84.33, 87.01 a 87.06 e 87.11 da TIPI quando importados diretamente por estabelecimento industrial - Art. 136, IV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('146','Suspensão','Setor Automotivo - do estabelecimento industrial matérias-primas, os produtos intermediários e os materiais de embalagem, adquiridos por fabricantes, preponderantemente, de componentes, chassis e outros classificados nos Códigos 84.29, 8432.40.00, 8432.80.00, 8433.20, 8433.30.00, 8433.40.00, 8433.5 e 87.01 a 87.06 da TIPI - Art. 136, V do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('147','Suspensão','Setor Automotivo - Desembaraço aduaneiro, as matérias-primas, os produtos intermediários e os materiais de embalagem, importados diretamente por fabricantes, preponderantemente, de componentes, chassis e outros classificados nos Códigos 84.29, 8432.40.00, 8432.80.00, 8433.20, 8433.30.00, 8433.40.00, 8433.5 e 87.01 a 87.06 da TIPI - Art. 136, VI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('148','Suspensão','Bens de Informática e Automação - matérias-primas, os produtos intermediários e os materiais de embalagem, quando adquiridos por estabelecimentos industriais fabricantes dos referidos bens. - Art. 148 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('149','Suspensão','Reporto - Saída de Estabelecimento de máquinas e outros quando adquiridos por beneficiários do REPORTO - Art. 166, I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('150','Suspensão','Reporto - Desembaraço aduaneiro de máquinas e outros quando adquiridos por beneficiários do REPORTO - Art. 166, II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('151','Suspensão','Repes - Desembaraço aduaneiro - bens sem similar nacional importados por beneficiários do REPES - Art. 171 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('152','Suspensão','Recine - Saída para beneficiário do regime - Art. 14, III da Lei 12.599/2012')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('153','Suspensão','Recine - Desembaraço aduaneiro por beneficiário do regime - Art. 14, IV da Lei 12.599/2012')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('154','Suspensão','Reif - Saída para beneficiário do regime - Lei 12.794/1013, art. 8, III')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('155','Suspensão','Reif - Desembaraço aduaneiro por beneficiário do regime - Lei 12.794/1013, art. 8, IV')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('156','Suspensão','Repnbl-Redes - Saída para beneficiário do regime - Lei nº 12.715/2012, art. 30, II')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('157','Suspensão','Recompe - Saída de matérias-primas e produtos intermediários para beneficiários do regime - Decreto nº 7.243/2010, art. 5º, I')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('158','Suspensão','Recompe - Saída de matérias-primas e produtos intermediários destinados a industrialização de equipamentos - Programa Estímulo Universidade-Empresa - Apoio à Inovação - Decreto nº 7.243/2010, art. 5º, III')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('159','Suspensão','Rio 2016 - Produtos nacionais, duráveis, uso e consumo dos eventos, adquiridos pelas pessoas jurídicas mencionadas no § 2o do art. 4o da Lei nº 12.780/2013 - Lei nº 12.780/2013, Art. 13')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('301','Isenção','Produtos industrializados por instituições de educação ou de assistência social, destinados a uso próprio ou a distribuição gratuita a seus educandos ou assistidos - Art. 54 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('302','Isenção','Produtos industrializados por estabelecimentos públicos e autárquicos da União, dos Estados, do Distrito Federal e dos Municípios, não destinados a comércio - Art. 54 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('303','Isenção','Amostras de produtos para distribuição gratuita, de diminuto ou nenhum valor comercial - Art. 54 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('304','Isenção','Amostras de tecidos sem valor comercial - Art. 54 Inciso IV do Decreto 7.212/2010') 
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('305','Isenção','Pés isolados de calçados - Art. 54 Inciso V do Decreto 7.212/2010') 
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('306','Isenção','Aeronaves de uso militar e suas partes e peças, vendidas à União - Art. 54 Inciso VI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('307','Isenção','Caixões funerários - Art. 54 Inciso VII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('308','Isenção','Papel destinado à impressão de músicas - Art. 54 Inciso VIII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('309','Isenção','Panelas e outros artefatos semelhantes, de uso doméstico, de fabricação rústica, de pedra ou barro bruto - Art. 54 Inciso IX do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('310','Isenção','Chapéus, roupas e proteção, de couro, próprios para tropeiros - Art. 54 Inciso X do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('311','Isenção','Material bélico, de uso privativo das Forças Armadas, vendido à União - Art. 54 Inciso XI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('312','Isenção','Automóvel adquirido diretamente a fabricante nacional, pelas missões diplomáticas e repartições consulares de caráter permanente, ou seus integrantes, bem assim pelas representações internacionais ou regionais de que o Brasil seja membro, e seus funcionários, peritos, técnicos e consultores, de nacionalidade estrangeira, que exerçam funções de caráter permanente - Art. 54 Inciso XII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('313','Isenção','Veículo de fabricação nacional adquirido por funcionário das missões diplomáticas acreditadas junto ao Governo Brasileiro - Art. 54 Inciso XIII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('314','Isenção','Produtos nacionais saídos diretamente para Lojas Francas - Art. 54 Inciso XIV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('315','Isenção','Materiais e equipamentos destinados a Itaipu Binacional - Art. 54 Inciso XV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('316','Isenção','Produtos Importados por missões diplomáticas, consulados ou organismo internacional - Art. 54 Inciso XVI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('317','Isenção','Bagagem de passageiros desembaraçada com isenção do II. - Art. 54 Inciso XVII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('318','Isenção','Bagagem de passageiros desembaraçada com pagamento do II. - Art. 54 Inciso XVIII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('319','Isenção','Remessas postais internacionais sujeitas a tributação simplificada. - Art. 54 Inciso XIX do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('320','Isenção','Máquinas e outros destinados à pesquisa científica e tecnológica - Art. 54 Inciso XX do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('321','Isenção','Produtos de procedência estrangeira, isentos do II conforme Lei nº 8032/1990. - Art. 54 Inciso XXI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('322','Isenção','Produtos de procedência estrangeira utilizados em eventos esportivos - Art. 54 Inciso XXII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('323','Isenção','Veículos automotores, máquinas, equipamentos, bem assim suas partes e peças separadas, destinadas à utilização nas atividades dos Corpos de Bombeiros - Art. 54 Inciso XXIII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('324','Isenção','Produtos importados para consumo em congressos, feiras e exposições - Art. 54 Inciso XXIV do Decreto 7.212/2010')

END
GO

IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE xtype='U' AND name='CodigoEnqIpi') 
BEGIN   

  DELETE FROM CODIGOENQIPI WHERE CODIGO >= '325' AND CODIGO <= '999'
  
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('325','Isenção','Bens de informática, Matéria Prima, produtos intermediários e embalagem destinados a Urnas eletrônicas - TSE - Art. 54 Inciso XXV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('326','Isenção','Materiais, equipamentos, máquinas, aparelhos e instrumentos, bem assim os respectivos acessórios, sobressalentes e ferramentas, que os acompanhem, destinados à construção do Gasoduto Brasil - Bolívia - Art. 54 Inciso XXVI do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('327','Isenção','Partes, peças e componentes, adquiridos por estaleiros navais brasileiros, destinados ao emprego na conservação, modernização, conversão ou reparo de embarcações registradas no Registro Especial Brasileiro - REB - Art. 54 Inciso XXVII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('328','Isenção','Aparelhos transmissores e receptores de radiotelefonia e radiotelegrafia; veículos para patrulhamento policial; armas e munições, destinados a órgãos de segurança pública da União, dos Estados e do Distrito Federal - Art. 54 Inciso XXVIII do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('329','Isenção','Automóveis de passageiros de fabricação nacional destinados à utilização como táxi adquiridos por motoristas profissionais - Art. 55 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('330','Isenção','Automóveis de passageiros de fabricação nacional destinados à utilização como táxi por impedidos de exercer atividade por destruição, furto ou roubo do veículo adquiridos por motoristas profissionais. - Art. 55 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('331','Isenção','Automóveis de passageiros de fabricação nacional destinados à utilização como táxi adquiridos por cooperativas de trabalho. - Art. 55 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('332','Isenção','Automóveis de passageiros de fabricação nacional, destinados a pessoas portadoras de deficiência física, visual, mental severa ou profunda, ou autistas - Art. 55 Inciso IV do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('333','Isenção','Produtos estrangeiros, recebidos em doação de representações diplomáticas estrangeiras sediadas no País, vendidos em feiras, bazares e eventos semelhantes por entidades beneficentes - Art. 67 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('334','Isenção','Produtos industrializados na Zona Franca de Manaus - ZFM, destinados ao seu consumo interno - Art. 81 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('335','Isenção','Produtos industrializados na ZFM, por estabelecimentos com projetos aprovados pela SUFRAMA, destinados a comercialização em qualquer outro ponto do Território Nacional - Art. 81 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('336','Isenção','Produtos nacionais destinados à entrada na ZFM, para seu consumo interno, utilização ou industrialização, ou ainda, para serem remetidos, por intermédio de seus entrepostos, à Amazônia Ocidental - Art. 81 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('337','Isenção','Produtos industrializados por estabelecimentos com projetos aprovados pela SUFRAMA, consumidos ou utilizados na Amazônia Ocidental, ou adquiridos através da ZFM ou de seus entrepostos na referida região - Art. 95 Inciso I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('338','Isenção','Produtos de procedência estrangeira, relacionados na legislação, oriundos da ZFM e que derem entrada na Amazônia Ocidental para ali serem consumidos ou utilizados: - Art. 95 Inciso II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('339','Isenção','Produtos elaborados com matérias-primas agrícolas e extrativas vegetais de produção regional, por estabelecimentos industriais localizados na Amazônia Ocidental, com projetos aprovados pela SUFRAMA - Art. 95 Inciso III do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('340','Isenção','Produtos industrializados em Área de Livre Comércio - Art. 105 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('341','Isenção','Produtos nacionais ou nacionalizados, destinados à entrada na Área de Livre Comércio de Tabatinga - ALCT - Art. 107 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('342','Isenção','Produtos nacionais ou nacionalizados, destinados à entrada na Área de Livre Comércio de Guajará-Mirim - ALCGM - Art. 110 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('343','Isenção','Produtos nacionais ou nacionalizados, destinados à entrada nas Áreas de Livre Comércio de Boa Vista - ALCBV e Bonfim - ALCB - Art. 113 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('344','Isenção','Produtos nacionais ou nacionalizados, destinados à entrada na Área de Livre Comércio de Macapá e Santana - ALCMS - Art. 117 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('345','Isenção','Produtos nacionais ou nacionalizados, destinados à entrada nas Áreas de Livre Comércio de Brasiléia - ALCB e de Cruzeiro do Sul - ALCCS - Art. 120 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('346','Isenção','Recompe - equipamentos de informática - de beneficiário do regime para escolas das redes públicas de ensino federal, estadual, distrital, municipal ou nas escolas sem fins lucrativos de atendimento a pessoas com deficiência - Decreto nº 7.243/2010, art. 7º')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('347','Isenção','Rio 2016 - Importação de materiais para os jogos (medalhas, troféus, impressos, bens não duráveis, etc.) - Lei nº 12.780/2013, Art. 4º, §1º, I')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('348','Isenção','Rio 2016 - Suspensão convertida em isenção - Lei nº 12.780/2013, Art. 6º, I')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('349','Isenção','Rio 2016 - Empresas vinculadas ao CIO - Lei nº 12.780/2013, Art. 9º, I, d')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('350','Isenção','Rio 2016 - Saída de produtos importados pelo RIO 2016 - Lei nº 12.780/2013, Art. 10, I, d')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('351','Isenção','Rio 2016 - Produtos nacionais, não duráveis, uso e consumo dos eventos, adquiridos pelas pessoas jurídicas mencionadas no § 2o do art. 4o da Lei nº 12.780/2013 - Lei nº 12.780/2013, Art. 12')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('601','Redução','Equipamentos e outros destinados à pesquisa e ao desenvolvimento tecnológico - Art. 72 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('602','Redução','Equipamentos e outros destinados à empresas habilitadas no PDTI e PDTA utilizados em pesquisa e ao desenvolvimento tecnológico - Art. 73 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('603','Redução','Microcomputadores e outros de até R$11.000,00, unidades de disco, circuitos, etc, destinados a bens de informática ou automação. Centro-Oeste SUDAM SUDENE - Art. 142, I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('604','Redução','Microcomputadores e outros de até R$11.000,00, unidades de disco, circuitos, etc, destinados a bens de informática ou automação. - Art. 142, I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('605','Redução','Bens de informática não incluídos no art. 142 do Decreto 7.212/2010 - Produzidos no Centro-Oeste, SUDAM, SUDENE - Art. 143, I do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('606','Redução','Bens de informática não incluídos no art. 142 do Decreto 7.212/2010 - Art. 143, II do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('607','Redução','Padis - Art. 150 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('608','Redução','Patvd - Art. 158 do Decreto 7.212/2010')
  INSERT INTO CODIGOENQIPI (CODIGO, GRUPOCST, DESCRICAO) VALUES ('999','Outros','Tributação normal IPI; Outros;')

END

--------------------- PA 288551 ------------------------

IF not EXISTS (SELECT 1 FROM DADOADICIONAL WHERE OID = 37764)
insert into dadoadicional ( RCLASSECONCRETA,RAPLICATIVO,RDOMINIO,RLISTA,RTIPO,RITEM,RESTRICAO,VISIVEL,MASCARA,PADRAO,MAXIMO,MINIMO,VALOR,OID) values (7,7    ,7,7,1014,52,0,0,'','',1,0,'Percentual do ICMS relativo ao fundo de combate à pobreza',37764)
GO
-- Adição de campos tabela 'DADOSITEMNFE'
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
-- Adição de campos tabela 'DADOSNOTANFE'
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

INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100100','Catalisadores em colmeia cerâmica ou metálica para conversão catalítica de gases de escape de veículos e outros catalisadores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100200','Tubos e seus acessórios (por exemplo, juntas, cotovelos, flanges, uniões), de plásticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100300','Protetores de caçamba')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100400','Reservatórios de óleo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100500','Frisos, decalques, molduras e acabamentos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100600','Correias de transmissão de borracha vulcanizada, de matérias têxteis, mesmo impregnadas, revestidas ou recobertas, de plástico, ou estratificadas com plástico ou reforçadas com metal ou com outras matérias')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100700','Juntas, gaxetas e outros elementos com função semelhante de vedação')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100800','Partes de veículos automóveis, tratores e máquinas autopropulsadas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0100900','Tapetes, revestimentos, mesmo confeccionados, batentes, buchas e coxins')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101000','Tecidos impregnados, revestidos, recobertos ou estratificados, com plástico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101100','Mangueiras e tubos semelhantes, de matérias têxteis, mesmo com reforço ou acessórios de outras matérias')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101200','Encerados e toldos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101300','Capacetes e artefatos de uso semelhante, de proteção, para uso em motocicletas, incluídos ciclomotores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101400','Guarnições de fricção (por exemplo, placas, rolos, tiras, segmentos, discos, anéis, pastilhas), não montadas, para freios, embreagens ou qualquer outro mecanismo de fricção, à base de amianto, de outras substâncias minerais ou de celulose, mesmo combinadas com têxteis ou outras matérias')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101500','Vidros de dimensões e formatos que permitam aplicação automotiva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101600','Espelhos retrovisores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101700','Lentes de faróis, lanternas e outros utensílios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101800','Cilindro de aço para GNV (gás natural veicular)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0101900','Recipientes para gases comprimidos ou liquefeitos, de ferro fundido, ferro ou aço, exceto o descrito no item 18.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102000','Molas e folhas de molas, de ferro ou aço')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102100','Obras moldadas, de ferro fundido, ferro ou aço, exceto as do código 7325.91.00')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102200','Peso de chumbo para balanceamento de roda')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102300','Peso para balanceamento de roda e outros utensílios de estanho')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102400','Fechaduras e partes de fechaduras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102500','Chaves apresentadas isoladamente')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102600','Dobradiças, guarnições, ferragens e artigos semelhantes de metais comuns')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102700','Triângulo de segurança')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102800','Motores de pistão alternativo dos tipos utilizados para propulsão de veículos do Capítulo 87')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0102900','Motores dos tipos utilizados para propulsão de veículos automotores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103000','Partes reconhecíveis como exclusiva ou principalmente destinadas aos motores das posições 8407 ou 8408')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103100','Motores hidráulicos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103200','Bombas para combustíveis, lubrificantes ou líquidos de arrefecimento, próprias para motores de ignição por centelha ou por compressão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103300','Bombas de vácuo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103400','Compressores e turbocompressores de ar')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103500','Partes das bombas, compressores e turbocompressores dos itens 32.0, 33.0 e 34.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103600','Máquinas e aparelhos de ar condicionado')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103700','Aparelhos para filtrar óleos minerais nos motores de ignição por centelha ou por compressão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103800','Filtros a vácuo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0103900','Partes dos aparelhos para filtrar ou depurar líquidos ou gases')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104000','Extintores, mesmo carregados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104100','Filtros de entrada de ar para motores de ignição por centelha ou por compressão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104200','Depuradores por conversão catalítica de gases de escape')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104300','Macacos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104400','Partes para macacos do item 43.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104500','Partes reconhecíveis como exclusiva ou principalmente destinadas às máquinas agrícolas ou rodoviárias')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104600','Válvulas redutoras de pressão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104700','Válvulas para transmissão óleo-hidráulicas ou pneumáticas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104800','Válvulas solenóides')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0104900','Rolamentos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105000','Árvores de transmissão (incluídas as árvores de "cames"e virabrequins) e manivelas; mancais e "bronzes"; engrenagens e rodas de fricção; eixos de esferas ou de roletes; redutores, multiplicadores, caixas de transmissão e variadores de velocidade, incluídos os conversores de torque; volantes e polias, incluídas as polias para cadernais; embreagens e dispositivos de acoplamento, incluídas as juntas de articulação')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105100','Juntas metaloplásticas; jogos ou sortidos de juntas de composições diferentes, apresentados em bolsas, envelopes ou embalagens semelhantes; juntas de vedação mecânicas (selos mecânicos)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105200','Acoplamentos, embreagens, variadores de velocidade e freios, eletromagnéticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105300','Acumuladores elétricos de chumbo, do tipo utilizado para o arranque dos motores de pistão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105400','Aparelhos e dispositivos elétricos de ignição ou de arranque para motores de ignição por centelha ou por compressão (por exemplo, magnetos, dínamos-magnetos, bobinas de ignição, velas de ignição ou de aquecimento, motores de arranque); geradores (dínamos e alternadores, por exemplo) e conjuntores-disjuntores utilizados com estes motores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105500','Aparelhos elétricos de iluminação ou de sinalização (exceto os da posição 8539), limpadores de para-brisas, degeladores e desembaçadores (desembaciadores) elétricos e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105600','Telefones móveis do tipo dos utilizados em veículos automóveis.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105700','Alto-falantes, amplificadores elétricos de audiofrequência e partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105800','Aparelhos elétricos de amplificação de som para veículos automotores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0105900','Aparelhos de reprodução de som')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106000','Aparelhos transmissores (emissores) de radiotelefonia ou radiotelegrafia (rádio receptor/transmissor)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106100','Aparelhos receptores de radiodifusão que só funcionam com fonte externa de energia, exceto os classificados na posição 8527.21.90')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106200','Outros aparelhos receptores de radiodifusão que funcionem com fonte externa de energia; outros aparelhos videofônicos de gravação ou de reprodução, mesmo incorporando um receptor de sinais videofônicos, dos tipos utilizados exclusivamente em veículos automotores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106300','Antenas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106400','Circuitos impressos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106500','Interruptores e seccionadores e comutadores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106600','Fusíveis e corta-circuitos de fusíveis')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106700','Disjuntores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106800','Relés')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0106900','Partes reconhecíveis como exclusivas ou principalmente destinados aos aparelhos dos itens 65.0, 66.0, 67.0 e 68.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107000','Faróis e projetores, em unidades seladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107100','Lâmpadas e tubos de incandescência, exceto de raios ultravioleta ou infravermelhos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107200','Cabos coaxiais e outros condutores elétricos coaxiais')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107300','Jogos de fios para velas de ignição e outros jogos de fios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107400','Carroçarias para os veículos automóveis das posições 8701 a 8705, incluídas as cabinas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107500','Partes e acessórios dos veículos automóveis das posições 8701 a 8705')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107600','Parte e acessórios de motocicletas (incluídos os ciclomotores)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107700','Engates para reboques e semi-reboques')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107800','Medidores de nível; Medidores de vazão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0107900','Aparelhos para medida ou controle da pressão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108000','Contadores, indicadores de velocidade e tacômetros, suas partes e acessórios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108100','Amperímetros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108200','Aparelhos digitais, de uso em veículos automóveis, para medida e indicação de múltiplas grandezas tais como: velocidade média, consumos instantâneo e médio e autonomia (computador de bordo)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108300','Controladores eletrônicos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108400','Relógios para painéis de instrumentos e relógios semelhantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108500','Assentos e partes de assentos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108600','Acendedores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108700','Tubos de borracha vulcanizada não endurecida, mesmo providos de seus acessórios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108800','Juntas de vedação de cortiça natural e de amianto')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0108900','Papel-diagrama para tacógrafo, em disco')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109000','Fitas, tiras, adesivos, auto-colantes, de plástico, refletores, mesmo em rolos; placas metálicas com película de plástico refletora, próprias para colocação em carrocerias, para-choques de veículos de carga, motocicletas, ciclomotores, capacetes, bonés de agentes de trânsito e de condutores de veículos, atuando como dispositivos refletivos de segurança rodoviários')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109100','Cilindros pneumáticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109200','Bomba elétrica de lavador de para-brisa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109300','Bomba de assistência de direção hidráulica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109400','Motoventiladores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109500','Filtros de pólen do ar-condicionado')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109600','"Máquina" de vidro elétrico de porta')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109700','Motor de limpador de para-brisa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109800','Bobinas de reatância e de auto-indução')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0109900','Baterias de chumbo e de níquel-cádmio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110000','Aparelhos de sinalização acústica (buzina)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110100','Instrumentos para regulação de grandezas não elétricas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110200','Analisadores de gases ou de fumaça (sonda lambda)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110300','Perfilados de borracha vulcanizada não endurecida')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110400','Artefatos de pasta de fibra de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110500','Tapetes/carpetes - nailón')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110600','Tapetes de matérias têxteis sintéticas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110700','Forração interior capacete')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110800','Outros para-brisas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0110900','Moldura com espelho')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111000','Corrente de transmissão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111100','Corrente transmissão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111200','Outras correntes de transmissão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111300','Condensador tubular metálico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111400','Trocadores de calor')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111500','Partes de aparelhos mecânicos de pulverizar ou dispersar')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111600','Macacos manuais para veículos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111700','Caçambas, pás, ganchos e tenazes para máquinas rodoviárias')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111800','Geradores de corrente alternada de potência não superior a 75 kva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0111900','Aparelhos elétricos para alarme de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112000','Bússolas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112100','Indicadores de temperatura')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112200','Partes de indicadores de temperatura')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112300','Partes de aparelhos de medida ou controle')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112400','Termostatos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112500','Instrumentos e aparelhos para regulação')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112600','Pressostatos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112700','Peças para reboques e semi-reboques')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0112800','Geradores de ar quente a combustível líquido, com capacidade superior ou igual a 1.500 kcal/h, mas inferior ou igual a 10.400 kcal/h, do tipo dos utilizados em veículos automóveis')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0200100','Aperitivos, amargos, bitter e similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0200200','Batida e similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0200300','Bebida ice')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0200400','Cachaça e aguardentes')
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
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0201600','Uísque')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0201700','Vermute e similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0201800','Vodka')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0201900','Derivados de vodka')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0202000','Arak')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0202100','Aguardente vínica / grappa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0202200','Sidra e similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0202300','Sangrias e coquetéis')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0202400','Vinhos de uvas frescas, incluindo os vinhos enriquecidos com álcool; mostos de uvas.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0202500','Outras bebidas alcoólicas não especificadas nos itens anteriores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300100','Água mineral, gasosa ou não, ou potável, naturais, em garrafa de vidro, retornável ou não, com capacidade de até 500 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300200','Água mineral, gasosa ou não, ou potável, naturais, em embalagem com capacidade igual ou superior a 5.000 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300300','Água mineral, gasosa ou não, ou potável, naturais, em embalagem de vidro, não retornável, com capacidade de até 300 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300400','Água mineral, gasosa ou não, ou potável, naturais, em garrafa plástica de 1.500 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300500','Água mineral, gasosa ou não, ou potável, naturais, em copos plásticos e embalagem plástica com capacidade de até 500 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300600','Outras águas minerais, potáveis ou naturais, gasosas ou não, inclusive gaseificadas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300700','Águas minerais, potáveis ou naturais, gasosas ou não, inclusive gaseificadas ou aromatizadas artificialmente, refrescos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300800','Outras águas minerais, potáveis ou naturais, gasosas ou não, inclusive gaseificadas ou aromatizadas artificialmente')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0300900','Néctares de frutas e outras bebidas não alcoólicas prontas para beber, exceto isotônicos e energéticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301000','Refrigerante em garrafa com capacidade igual ou superior a 600 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301100','Demais refrigerantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301200','Xarope ou extrato concentrado destinados ao preparo de refrigerante em máquina "pré-mix"ou "post-mix"')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301300','Bebidas energéticas em embalagem com capacidade inferior a 600ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301400','Bebidas energéticas em embalagem com capacidade igual ou superior a 600ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301500','Bebidas hidroeletrolíticas (isotônicas) em embalagem com capacidade inferior a 600ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301600','Bebidas hidroeletrolíticas (isotônicas) em embalagem com capacidade igual ou superior a 600ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301700','Bebidas prontas à base de mate ou chá')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301800','Bebidas prontas à base de café')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0301900','Refrescos e outras bebidas prontas para beber à base de chá e mate')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0302000','Bebidas alimentares prontas à base de soja, leite ou cacau, inclusive os produtos denominados bebidas lácteas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0302100','Cerveja')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0302200','Cerveja sem álcool')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0302300','Chope')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0400100','Charutos, cigarrilhas e cigarros, de tabaco ou dos seus sucedâneos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0400200','Tabaco para fumar, mesmo contendo sucedâneos de tabaco em qualquer proporção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0500100','Cimento')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600100','Álcool etílico não desnaturado, com um teor alcoólico em volume igual ou superior a 80% vol (álcool etílico anidro combustível e álcool etílico hidratado combustível)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600200','Gasolinas, exceto de aviação')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600300','Gasolina de aviação')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600400','Querosenes, exceto de aviação')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600500','Querosene de aviação')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600600','Óleos combustíveis')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600700','Óleos lubrificantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600800','Outros óleos de petróleo ou de minerais betuminosos (exceto óleos brutos) e preparações não especificadas nem compreendidas noutras posições, que contenham, como constituintes básicos, 70% ou mais, em peso, de óleos de petróleo ou de inerais betuminosos, exceto os que contenham biodiesel e exceto os resíduos de óleos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0600900','Resíduos de óleos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601000','Gás de petróleo e outros hidrocarbonetos gasosos, exceto GLP, GLGN e Gás Natural')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601100','Gás Liquefeito de Petróleo (GLP)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601200','Gás Liquefeito de Gás Natural (GLGN)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601300','Gás Natural')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601400','Coque de petróleo e outros resíduos de óleo de petróleo ou de minerais betuminosos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601500','Biodiesel e suas misturas, que não contenham ou que contenham menos de 70%, em peso, de óleos de petróleo ou de óleos minerais betuminosos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601600','Preparações lubrificantes, exceto as contendo, como constituintes de base, 70% ou mais, em peso, de óleos de petróleo ou de minerais betuminosos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0601700','Óleos de petróleo ou de minerais betuminosos (exceto óleos brutos) e preparações não especificadas nem compreendidas noutras posições, que contenham, como constituintes básicos, 70% ou mais, em peso, de óleos de petróleo ou de minerais betuminosos, que contenham biodiesel, exceto os resíduos de óleos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0700100','Energia elétrica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800100','Ferramentas de borracha vulcanizada não endurecida')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800200','Ferramentas, armações e cabos de ferramentas, de madeira')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800300','Mós e artefatos semelhantes, sem armação, para moer, desfibrar, triturar, amolar, polir, retificar ou cortar; pedras para amolar ou para polir, manualmente, e suas partes, de pedras naturais, de abrasivos naturais ou artificiais aglomerados ou de cerâmica, mesmo com partes de outras matérias')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800400','Pás, alviões, picaretas, enxadas, sachos, forcados e forquilhas, ancinhos e raspadeiras; machados, podões e ferramentas semelhantes com gume; tesouras de podar de todos os tipos; foices e foicinhas, facas para feno ou para palha, tesouras para sebes, cunhas e outras ferramentas manuais para agricultura, horticultura ou silvicultura')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800500','Folhas de serras de fita')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800600','Lâminas de serras máquinas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800700','Serras manuais e outras folhas de serras (incluídas as fresas-serras e as folhas não dentadas para serrar), exceto as classificadas nas posições 8202.20.00 e 8202.91.00')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800800','Limas, grosas, alicates (mesmo cortantes), tenazes, pinças, cisalhas para metais, corta-tubos, corta-pinos, saca-bocados e ferramentas semelhantes, manuais, exceto as pinças para sobrancelhas classificadas na posição 8203.20.90')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0800900','Chaves de porcas, manuais (incluídas as chaves dinamométricas); chaves de caixa intercambiáveis, mesmo com cabos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801000','Ferramentas manuais (incluídos os diamantes de vidraceiro) não especificadas nem compreendidas em outras posições, lamparinas ou lâmpadas de soldar (maçaricos) e semelhantes; tornos de apertar, sargentos e semelhantes, exceto os acessórios ou partes de máquinas-ferramentas; bigornas; forjas-portáteis; mós com armação, manuais ou de pedal')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801100','Ferramentas de pelo menos duas das posições 8202 a 8205, acondicionadas em sortidos para venda a retalho')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801200','Ferramentas de roscar interior ou exteriormente; de mandrilar ou de brochar; e de fresar')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801300','Outras ferramentas intercambiáveis para ferramentas manuais, mesmo mecânicas, ou para máquinas-ferramentas (por exemplo, de embutir, estampar, puncionar, furar, tornear, aparafusar), incluídas as fieiras de estiragem ou de extrusão, para metais, e as ferramentas de perfuração ou de sondagem, exceto forma ou gabarito de produtos em epoxy, exceto as classificadas nas posições 8207.40, 8207.60 e 8207.70')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801400','Facas e lâminas cortantes, para máquinas ou para aparelhos mecânicos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801500','Plaquetas ou pastilhas intercambiáveis')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801600','Outras plaquetas, varetas, pontas e objetos semelhantes para ferramentas, não montados, de ceramais ("cermets"), exceto as classificadas na posição 8209.00.11')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801700','Facas (exceto as da posição 8208) de lâmina cortante ou serrilhada, incluídas as podadeiras de lâmina móvel, e suas lâminas, exceto as de uso doméstico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801800','Tesouras e suas lâminas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0801900','Ferramentas pneumáticas, hidráulicas ou com motor (elétrico ou não elétrico) incorporado, de uso manual')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0802000','Instrumentos e aparelhos de geodésia, topografia, agrimensura, nivelamento, fotogrametria, hidrografia, oceanografia, hidrologia, meteorologia ou de geofísica, exceto bussolas; telêmetros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0802100','Instrumentos de desenho, de traçado ou de cálculo; metros, micrômetros, paquímetros, calibres e semelhantes; partes e acessórios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0802200','Termômetros, suas partes e acessórios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0802300','Pirômetros, suas partes e acessórios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0900100','Lâmpadas elétricas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0900200','Lâmpadas eletrônicas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0900300','Reatores para lâmpadas ou tubos de descargas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0900400','“Starter”')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('0900500','Lâmpadas de LED (Diodos Emissores de Luz)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000100','Cal')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000200','Argamassas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000300','Outras argamassas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000400','Silicones em formas primárias, para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000500','Revestimentos de PVC e outros plásticos; forro, sancas e afins de PVC, para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000600','Tubos, e seus acessórios (por exemplo, juntas, cotovelos, flanges, uniões), de plásticos, para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000700','Revestimento de pavimento de PVC e outros plásticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000800','Chapas, folhas, tiras, fitas, películas e outras formas planas, auto-adesivas, de plásticos, mesmo em rolos, para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1000900','Veda rosca, lona plástica para uso na construção, fitas isolantes e afins')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001000','Telha de plástico, mesmo reforçada com fibra de vidro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001100','Cumeeira de plástico, mesmo reforçada com fibra de vidro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001200','Chapas, laminados plásticos em bobina, para uso na construção, exceto os descritos nos itens 10.0 e 11.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001300','Banheiras, boxes para chuveiros, pias, lavatórios, bidês, sanitários e seus assentos e tampas, caixas de descarga e artigos semelhantes para usos sanitários ou higiênicos, de plásticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001400','Artefatos de higiene/toucador de plástico, para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001500','Caixa d’água, inclusive sua tampa, de plástico, mesmo reforçadas com fibra de vidro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001600','Outras telhas, cumeeira e caixa d’água, inclusive sua tampa, de plástico, mesmo reforçadas com fibra de vidro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001700','Artefatos para apetrechamento de construções, de plásticos, não especificados nem compreendidos em outras posições, incluindo persianas, sancas, molduras, apliques e rosetas, caixilhos de polietileno e outros plásticos, exceto os descritos nos itens 15.0 e 16.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001800','Portas, janelas e seus caixilhos, alizares e soleiras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1001900','Postigos, estores (incluídas as venezianas) e artefatos semelhantes e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002000','Outras obras de plástico, para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002100','Papel de parede e revestimentos de parede semelhantes; papel para vitrais')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002200','Telhas de concreto')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002300','Telha, cumeeira e caixa d’água, inclusive sua tampa, de fibrocimento, cimento-celulose')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002400','Caixas d’água, tanques e reservatórios e suas tampas, telhas, calhas, cumeeiras e afins, de fibrocimento, cimento-celulose ou semelhantes, contendo ou não amianto, exceto os descritos no item 23.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002500','Tijolos, placas (lajes), ladrilhos e outras peças cerâmicas de farinhas siliciosas fósseis ("kieselghur", tripolita, diatomita, por exemplo) ou de terras siliciosas semelhantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002600','Tijolos, placas (lajes), ladrilhos e peças cerâmicas semelhantes, para uso na construção, refratários, que não sejam de farinhas siliciosas fósseis nem de terras siliciosas semelhantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002700','Tijolos para construção, tijoleiras, tapa-vigas e produtos semelhantes, de cerâmica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002800','Telhas, elementos de chaminés, condutores de fumaça, ornamentos arquitetônicos, de cerâmica, e outros produtos cerâmicos para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1002900','Tubos, calhas ou algerozes e acessórios para canalizações, de cerâmica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003000','Ladrilhos e placas de cerâmica, exclusivamente para pavimentação ou revestimento')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003001','Cubos, pastilhas e artigos semelhantes de cerâmica, mesmo com suporte.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003100','Pias, lavatórios, colunas para lavatórios, banheiras, bidês, sanitários, caixas de descarga, mictórios e aparelhos fixos semelhantes para usos sanitários, de cerâmica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003200','Artefatos de higiene/toucador de cerâmica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003300','Vidro vazado ou laminado, em chapas, folhas ou perfis, mesmo com camada absorvente, refletora ou não, mas sem qualquer outro trabalho')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003400','Vidro estirado ou soprado, em folhas, mesmo com camada absorvente, refletora ou não, mas sem qualquer outro trabalho')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003500','Vidro flotado e vidro desbastado ou polido em uma ou em ambas as faces, em chapas ou em folhas, mesmo com camada absorvente, refletora ou não, mas sem qualquer outro trabalho')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003600','Vidros temperados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003700','Vidros laminados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003800','Vidros isolantes de paredes múltiplas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1003900','Blocos, placas, tijolos, ladrilhos, telhas e outros artefatos, de vidro prensado ou moldado, mesmo armado, para uso na construção; cubos, pastilhas e outros artigos semelhantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004000','Barras próprias para construções, exceto vergalhões')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004100','Outras barras próprias para construções, exceto vergalhões')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004200','Vergalhões')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004300','Outros vergalhões')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004400','Fios de ferro ou aço não ligados, não revestidos, mesmo polidos; cordas, cabos, tranças (entrançados), lingas e artefatos semelhantes, de ferro ou aço, não isolados para usos elétricos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004500','Outros fios de ferro ou aço, não ligados, galvanizados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004600','Acessórios para tubos (inclusive uniões, cotovelos, luvas ou mangas), de ferro fundido, ferro ou aço')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004700','Portas e janelas, e seus caixilhos, alizares e soleiras de ferro fundido, ferro ou aço')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004800','Material para andaimes, para armações (cofragens) e para escoramentos, (inclusive armações prontas, para estruturas de concreto armado ou argamassa armada), eletrocalhas e perfilados de ferro fundido, ferro ou aço, próprios para construção, exceto treliças de aço')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1004900','Treliças de aço')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005000','Telhas metálicas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005100','Caixas diversas (tais como caixa de correio, de entrada de água, de energia, de instalação) de ferro, ferro fundido ou aço; próprias para a construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005200','Arame farpado, de ferro ou aço, arames ou tiras, retorcidos, mesmo farpados, de ferro ou aço, dos tipos utilizados em cercas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005300','Telas metálicas, grades e redes, de fios de ferro ou aço')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005400','Correntes de rolos, de ferro fundido, ferro ou aço')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005500','Outras correntes de elos articulados, de ferro fundido, ferro ou aço')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005600','Correntes de elos soldados, de ferro fundido, de ferro ou aço')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005700','Tachas, pregos, percevejos, escápulas, grampos ondulados ou biselados e artefatos semelhantes, de ferro fundido, ferro ou aço, mesmo com a cabeça de outra matéria, exceto cobre')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005800','Parafusos, pinos ou pernos, roscados, porcas, tira-fundos, ganchos roscados, rebites, chavetas, cavilhas, contrapinos, arruelas (incluídas as de pressão) e artefatos semelhantes, de ferro fundido, ferro ou aço')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1005900','Palha de ferro ou aço; esponjas, esfregões, luvas e artefatos semelhantes para limpeza, polimento e usos semelhantes, de ferro ou aço, exceto os de uso doméstico classificados na posição 7323.10.00')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006000','Artefatos de higiene ou de toucador, e suas partes, de ferro fundido, ferro ou aço, incluídas as pias, banheiras, lavatórios, cubas, mictórios, tanques e afins de ferro fundido, ferro ou aço, para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006100','Outras obras moldadas, de ferro fundido, ferro ou aço, para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006200','Abraçadeiras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006300','Barras de cobre')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006400','Tubos de cobre e suas ligas, para instalações de água quente e gás, para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006500','Acessórios para tubos (por exemplo, uniões, cotovelos, luvas ou mangas) de cobre e suas ligas, para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006600','Tachas, pregos, percevejos, escápulas e artefatos semelhantes, de cobre, ou de ferro ou aço com cabeça de cobre, parafusos, pinos ou pernos, roscados, porcas, ganchos roscados, rebites, chavetas, cavilhas, contrapinos, arruelas (incluídas as de pressão), e artefatos semelhantes, de cobre')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006700','Artefatos de higiene/toucador de cobre, para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006800','Manta de subcobertura aluminizada')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1006900','Tubos de alumínio e suas ligas, para refrigeração e ar condicionado, para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007000','Acessórios para tubos (por exemplo, uniões, cotovelos, luvas ou mangas), de alumínio, para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007100','Construções e suas partes (por exemplo, pontes e elementos de pontes, torres, pórticos ou pilones, pilares, colunas, armações, estruturas para telhados, portas e janelas, e seus caixilhos, alizares e soleiras, balaustradas), de alumínio, exceto as construções pré-fabricadas da posição 9406; chapas, barras, perfis, tubos e semelhantes, de alumínio, próprios para construções')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007200','Artefatos de higiene/toucador de alumínio, para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007300','Outras obras de alumínio, próprias para construções, incluídas as persianas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007400','Outras guarnições, ferragens e artigos semelhantes de metais comuns, para construções, inclusive puxadores.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007500','Fechaduras e ferrolhos (de chave, de segredo ou elétricos), de metais comuns, incluídas as suas partes fechos e armações com fecho, com fechadura, de metais comuns chaves para estes artigos, de metais comuns; exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007600','Dobradiças de metais comuns, de qualquer tipo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007700','Tubos flexíveis de metais comuns, mesmo com acessórios, para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007800','Fios, varetas, tubos, chapas, eletrodos e artefatos semelhantes, de metais comuns ou de carbonetos metálicos, revestidos exterior ou interiormente de decapantes ou de fundentes, para soldagem (soldadura) ou depósito de metal ou de carbonetos metálicos fios e varetas de pós de metais comuns aglomerados, para metalização por projeção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1007900','Torneiras, válvulas (incluídas as redutoras de pressão e as termostáticas) e dispositivos semelhantes, para canalizações, caldeiras, reservatórios, cubas e outros recipientes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100100','Água sanitária, branqueador e outros alvejantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100200','Sabões em pó, flocos, palhetas, grânulos ou outras formas semelhantes, para lavar roupas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100300','Sabões líquidos para lavar roupas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100400','Detergentes em pó, flocos, palhetas, grânulos ou outras formas semelhantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100500','Detergentes líquidos, exceto para lavar roupa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100600','Detergente líquido para lavar roupa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100700','Outros agentes orgânicos de superfície (exceto sabões); preparações tensoativas, preparações para lavagem (incluídas as preparações auxiliares para lavagem) e preparações para limpeza (inclusive multiuso e limpadores), mesmo contendo sabão, exceto as da posição 3401 e os produtos descritos nos itens 3 a 5; em embalagem de conteúdo inferior ou igual a 50 litros ou 50 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100800','Amaciante/suavizante')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1100900','Esponjas para limpeza')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1101000','Álcool etílico para limpeza')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1101100','Esponjas e palhas de aço; esponjas para limpeza, polimento ou uso semelhantes; todas de uso doméstico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200100','Transformadores, bobinas de reatância e de auto indução, inclusive os transformadores de potência superior a 16 KVA, classificados nas posições 8504.33.00 e 8504.34.00; exceto os demais transformadores da subposição 8504.3, os reatores para lâmpadas elétricas de descarga classificados no código 8504.10.00, os carregadores de acumuladores  do código 8504.40.10, os equipamentos de alimentação ininterrupta de energia (UPS ou “no break”), no código 8504.40.40 e os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200200','Aquecedores elétricos de água, incluídos os de imersão, chuveiros ou duchas elétricos, torneiras elétricas, resistências de aquecimento, inclusive as de duchas e chuveiros elétricos e suas partes; exceto outros fornos, fogareiros (incluídas as chapas de cocção), grelhas e assadeiras, classificados na posição 8516.60.00')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200300','Aparelhos para interrupção, seccionamento, proteção, derivação, ligação ou conexão de circuitos elétricos (por exemplo, interruptores, comutadores, corta-circuitos, para-raios, limitadores de tensão, eliminadores de onda, tomadas de corrente e outros conectores, caixas de junção), para tensão superior a 1.000V, exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200400','Aparelhos para interrupção, seccionamento, proteção, derivação, ligação ou conexão de circuitos elétricos (por exemplo, interruptores, comutadores, relés, corta-circuitos, eliminadores de onda, plugues e tomadas de corrente, suportes para lâmpadas e outros conectores, caixas de junção), para uma tensão não superior a 1.000V; conectores para fibras ópticas, feixes ou cabos de fibras ópticas; exceto "starter" classificado na subposição 8536.50 e os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200500','Partes reconhecíveis como exclusiva ou principalmente destinadas aos aparelhos das posições 8535 e 8536')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200600','Cabos, tranças e semelhantes, de cobre, não isolados para usos elétricos, exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200700','Fios, cabos (incluídos os cabos coaxiais) e outros condutores, isolados ou não, para usos elétricos (incluídos os de cobre ou alumínio, envernizados ou oxidados anodicamente), mesmo com peças de conexão, inclusive fios e cabos elétricos, para tensão não superior a 1000V, para uso na construção; fios e cabos telefônicos e para transmissão de dados; cabos de fibras ópticas, constituídos de fibras embainhadas individualmente, mesmo com condutores elétricos ou munidos de peças de conexão; cordas, cabos, tranças')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200800','Isoladores de qualquer matéria, para usos elétricos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1200900','Peças isolantes inteiramente de matérias isolantes, ou com simples peças metálicas de montagem (suportes roscados, por exemplo) incorporadas na massa, para máquinas, aparelhos e instalações elétricas; tubos isoladores e suas peças de ligação, de metais comuns, isolados interiormente')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300100','Medicamentos de referência – positiva, exceto para uso veterinário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300101','Medicamentos de referência – negativa, exceto para uso veterinário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300102','Medicamentos de referência – neutra, exceto para uso veterinário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300200','Medicamentos genérico – positiva, exceto para uso veterinário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300201','Medicamentos genérico – negativa, exceto para uso veterinário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300202','Medicamentos genérico – neutra, exceto para uso veterinário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300300','Medicamentos similar – positiva, exceto para uso veterinário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300301','Medicamentos similar – negativa, exceto para uso veterinário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300302','Medicamentos similar – neutra, exceto para uso veterinário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300400','Outros tipos de medicamentos – positiva, exceto para uso veterinário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300401','Outros tipos de medicamentos -  negativa, exceto para uso veterinário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300402','Outros tipos de medicamentos – neutra, exceto para uso veterinário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300500','Preparações químicas contraceptivas à base de hormônios, de outros produtos da posição 29.37 ou de espermicidas - positiva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300501','Preparações químicas contraceptivas à base de hormônios, de outros produtos da posição 29.37 ou de espermicidas - negativa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300600','Provitaminas e vitaminas, naturais ou reproduzidas por síntese (incluídos os concentrados naturais), bem como os seus derivados utilizados principalmente como vitaminas, misturados ou não entre si, mesmo em quaisquer soluções - neutra')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300700','Preparações opacificantes (contrastantes) para exames radiográficos e reagentes de diagnóstico concebidos para serem administrados ao paciente - positiva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300701','Preparações opacificantes (contrastantes) para exames radiográficos e reagentes de diagnóstico concebidos para serem administrados ao paciente - negativa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300800','Antissoro, outras frações do sangue, produtos imunológicos modificados, mesmo obtidos por via biotecnológica,  exceto para uso veterinário - positiva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300801','Antissoro, outras frações do sangue, produtos imunológicos modificados, mesmo obtidos por via biotecnológica, exceto para uso veterinário - negativa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300900','Vacinas e produtos semelhantes, exceto para uso veterinário - positiva;')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1300901','Vacinas e produtos semelhantes, exceto para uso veterinário - negativa;')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301000','Algodão, atadura, esparadrapo, haste flexível ou não, com uma ou ambas extremidades de algodão, gazes, pensos, sinapismos, e outros, impregnados ou recobertos de substâncias farmacêuticas ou acondicionados para venda a retalho para usos medicinais, cirúrgicos ou dentários - positiva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301001','Algodão, atadura, esparadrapo, haste flexível ou não, com uma ou ambas extremidades de algodão, gazes, pensos, sinapismos, e outros, impregnados ou recobertos de substâncias farmacêuticas ou acondicionados para venda a retalho para usos medicinais, cirúrgicos ou dentários - negativa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301100','Algodão, atadura, esparadrapo, haste flexível ou não, com uma ou ambas extremidades de algodão, gazes, pensos, sinapismos, e outros, não impregnados ou recobertos de substâncias farmacêuticas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301101','Algodão, atadura, esparadrapo, haste flexível ou não, com uma ou ambas extremidades de algodão, gazes, pensos, sinapismos, e outros, não impregnados ou recobertos de substâncias farmacêuticas ou acondicionados para venda a retalho para usos medicinais, cirúrgicos ou dentários')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301200','Luvas cirúrgicas e luvas de procedimento - neutra')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301300','Preservativo - neutra')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301400','Seringas, mesmo com agulhas - neutra')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301500','Agulhas para seringas - neutra')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1301600','Contraceptivos (dispositivos intra-uterinos - DIU) - neutra')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1400100','Filtros descartáveis para coar café ou chá')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1400200','Bandejas, travessas, pratos, xícaras ou chávenas, taças, copos e artigos semelhantes, de papel ou cartão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1400300','Papel para cigarro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1500100','Lonas plásticas, exceto as para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1500200','Artefatos de higiene/toucador de plástico, exceto os para uso na construção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1500300','Serviços de mesa e outros utensílios de mesa ou de cozinha, de plástico, inclusive os descartáveis')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1500400','Sacos de lixo de conteúdo igual ou inferior a 100 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600100','Pneus novos, dos tipos utilizados em automóveis de passageiros (incluídos os veículos de uso misto - camionetas e os automóveis de corrida)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600200','Pneus novos, dos tipos utilizados em caminhões (inclusive para os fora-de-estrada), ônibus, aviões, máquinas de terraplenagem, de construção e conservação de estradas, máquinas e tratores agrícolas, pá-carregadeira')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600300','Pneus novos para motocicletas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600400','Outros tipos de pneus novos, exceto para bicicletas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600500','Pneus novos de borracha dos tipos utilizados em bicicletas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600600','Pneus recauchutados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600700','Protetores de borracha, exceto para bicicletas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600701','Protetores de borracha para bicicletas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600800','Câmaras de ar de borracha, exceto para bicicletas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1600900','Câmaras de ar de borracha dos tipos utilizados em bicicletas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700100','Chocolate branco, em embalagens de conteúdo inferior ou igual a 1 kg, excluídos os ovos de páscoa de chocolate.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700200','Chocolates contendo cacau, em embalagens de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700300','Chocolate em barras, tabletes ou blocos ou no estado líquido, em pasta, em pó, grânulos ou formas semelhantes, em recipientes ou embalagens imediatas de conteúdo inferior ou igual a 2 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700400','Chocolates e outras preparações alimentícias contendo cacau, em embalagens de conteúdo inferior ou igual a 1 kg, excluídos os achocolatados em pó e ovos de páscoa de chocolate.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700500','Ovos de páscoa de chocolate')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700600','Achocolatados em pó, em embalagens de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700700','Caixas de bombons contendo cacau, em embalagens de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700800','Bombons, inclusive à base de chocolate branco sem cacau')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1700900','Bombons, balas, caramelos, confeitos, pastilhas e outros produtos de confeitaria, contendo cacau')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701000','Sucos de frutas ou de produtos hortícolas; mistura de sucos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701100','Água de coco')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701200','Leite em pó, blocos ou grânulos, exceto creme de leite')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701300','Farinha láctea')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701400','Leite modificado para alimentação de crianças')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701500','Preparações para alimentação infantil à base de farinhas, grumos, sêmolas ou amidos e outros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701600','Leite “longa vida” (UHT - “Ultra High Temperature”), em recipiente de conteúdo inferior ou igual a 2 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701601','Leite “longa vida” (UHT - “Ultra High Temperature”), em recipiente de conteúdo superior a 2 litros e inferior ou igual a 5 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701700','Leite em recipiente de conteúdo inferior ou igual a 1 litro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701701','Leite em recipiente de conteúdo superior a 1 litro e inferior ou igual a 5 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701800','Leite do tipo pasteurizado em recipiente de conteúdo inferior ou igual a 1 litro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701801','Leite do tipo pasteurizado em recipiente de conteúdo superior a 1 litro e inferior ou igual a 5 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701900','Creme de leite, em recipiente de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701901','Creme de leite, em recipiente de conteúdo superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1701902','Outros cremes de leite, em recipiente de conteúdo inferior ou igual a 1kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702000','Leite condensado, em recipiente de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702001','Leite condensado, em recipiente de conteúdo superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702100','Iogurte e leite fermentado em recipiente de conteúdo inferior ou igual a 2 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702101','Iogurte e leite fermentado em recipiente de conteúdo superior a 2 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702200','Coalhada')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702300','Requeijão e similares, em recipiente de conteúdo inferior ou igual a 1 kg, exceto as embalagens individuais de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702301','Requeijão e similares, em recipiente de conteúdo superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702400','Queijos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702500','Manteiga, em embalagem de conteúdo inferior ou igual a 1 kg, exceto as embalagens individuais de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702501','Manteiga, em embalagem de conteúdo superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702600','Margarina em recipiente de conteúdo inferior ou igual a 500 g, exceto as embalagens individuais de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702700','Margarina, em recipiente de conteúdo superior a 500 g e inferior a 1 kg, creme vegetal em recipiente de conteúdo inferior a 1 kg, exceto as embalagens individuais de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702701','Margarina e creme vegetal, em recipiente de conteúdo de 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702702','Outras margarinas e cremes vegetais em recipiente de conteúdo inferior a 1 kg, exceto as embalagens individuais de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702800','Gorduras e óleos vegetais e respectivas frações, parcial ou totalmente hidrogenados, interesterificados, reesterificados ou elaidinizados, mesmo refinados, mas não preparados de outro modo, em recipiente de conteúdo inferior ou igual a 1 kg, exceto as embalagens individuais de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702801','Gorduras e óleos vegetais e respectivas frações, parcial ou totalmente hidrogenados, interesterificados, reesterificados ou elaidinizados, mesmo refinados, mas não preparados de outro modo, em recipiente de conteúdo superior a 1 kg, exceto as embalagens individuais de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1702900','Doces de leite')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703000','Produtos à base de cereais, obtidos por expansão ou torrefação')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703100','Salgadinhos diversos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703200','Batata frita, inhame e mandioca fritos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703300','Amendoim e castanhas tipo aperitivo, em embalagem de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703301','Amendoim e castanhas tipo aperitivo, em embalagem de conteúdo superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703400','Catchup em embalagens imediatas de conteúdo inferior ou igual a 650 g, exceto as embalagens contendo envelopes individualizados (sachês) de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703500','Condimentos e temperos compostos, incluindo molho de pimenta e outros molhos, em embalagens imediatas de conteúdo inferior ou igual a 1 kg, exceto as embalagens contendo envelopes individualizados (sachês) de conteúdo inferior ou igual a 3 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703600','Molhos de soja preparados em embalagens imediatas de conteúdo inferior ou igual a 650 g, exceto as embalagens contendo envelopes individualizados (sachês) de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703700','Farinha de mostarda em embalagens de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703800','Mostarda preparada em embalagens imediatas de conteúdo inferior ou igual a 650 g, exceto as embalagens contendo envelopes individualizados (sachês) de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1703900','Maionese em embalagens imediatas de conteúdo inferior ou igual a 650 g, exceto as embalagens contendo envelopes individualizados (sachês) de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704000','Tomates preparados ou conservados, exceto em vinagre ou em ácido acético, em embalagens de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704100','Molhos de tomate em embalagens imediatas de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704200','Barra de cereais')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704300','Barra de cereais contendo cacau')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704400','Farinha de trigo, em embalagem inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704401','Farinha de trigo, em embalagem superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704500','Farinha de mistura de trigo com centeio (méteil)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704600','Misturas e preparações para bolos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704700','Massas alimentícias tipo instantânea')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704800','Massas alimentícias, cozidas ou recheadas (de carne ou de outras substâncias) ou preparadas de outro modo, exceto as massas alimentícias tipo instantânea')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704801','Cuscuz')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1704900','Massas alimentícias não cozidas, nem recheadas, nem preparadas de outro modo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705000','Pães industrializados, inclusive de especiarias, exceto panetones e bolo de forma')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705100','Bolo de forma, inclusive de especiarias')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705200','Panetones')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705300','Biscoitos e bolachas derivados de farinha de trigo; exceto dos tipos "cream cracker", "água e sal", "maisena", "maria" e outros de consumo popular, não adicionados de cacau, nem recheados, cobertos ou amanteigados, independentemente de sua denominação comercial')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705400','Biscoitos e bolachas não derivados de farinha de trigo; exceto dos tipos "cream cracker", "água e sal", "maisena" e "maria" e outros de consumo popular, não adicionados de cacau, nem recheados, cobertos ou amanteigados, independentemente de sua denominação comercial')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705500','Biscoitos e bolachas dos tipos "cream cracker", "água e sal", "maisena" e "maria" e outros de consumo popular, adicionados de edulcorantes e não adicionados de cacau, nem recheados, cobertos ou amanteigados, independentemente de sua denominação comercial')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705600','Biscoitos e bolachas dos tipos "cream cracker", "água e sal", "maisena" e "maria" e outros de consumo popular, não adicionados de cacau, nem recheados, cobertos ou amanteigados, independentemente de sua denominação comercial')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705700','“Waffles” e “wafers” - sem cobertura')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705800','“Waffles” e “wafers”- com cobertura')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1705900','Torradas, pão torrado e produtos semelhantes torrados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706000','Outros pães de forma')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706100','Outras bolachas, exceto casquinhas para sorvete')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706200','Outros pães e bolos industrializados e produtos de panificação não especificados anteriormente; exceto casquinhas para sorvete e pão francês de até 200 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706300','Pão denominado knackebrot')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706400','Demais pães industrializados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706500','Óleo de soja refinado, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteúdo inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706600','Óleo de amendoim refinado, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteúdo inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706700','Azeites de oliva, em recipientes com capacidade inferior ou igual a 2 litros, exceto as embalagens individuais de conteúdo inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706701','Azeites de oliva, em recipientes com capacidade superior a 2 litros e inferior ou igual a 5 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706702','Azeites de oliva, em recipientes com capacidade superior a 5 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706800','Outros óleos e respectivas frações, obtidos exclusivamente a partir de azeitonas, mesmo refinados, mas não quimicamente modificados, e misturas desses óleos ou frações com óleos ou frações da posição 15.09, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteúdo inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1706900','Óleo de girassol ou de algodão refinado, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteúdo inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707000','Óleo de canola, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteúdo inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707100','Óleo de linhaça refinado, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteúdo inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707200','Óleo de milho refinado, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteúdo inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707300','Outros óleos refinados, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteúdo inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707400','Misturas de óleos refinados, para consumo humano, em recipientes com capacidade inferior ou igual a 5 litros, exceto as embalagens individuais de conteúdo inferior ou igual a 15 mililitros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707500','Outros óleos vegetais comestíveis não especificados anteriormente')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707600','Enchidos (embutidos) e produtos semelhantes, de carne, miudezas ou sangue; exceto salsicha, linguiça e mortadela')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707700','Salsicha e linguiça')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707800','Mortadela')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1707900','Outras preparações e conservas de carne, miudezas ou de sangue')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708000','Preparações e conservas de peixes; caviar e seus sucedâneos preparados a partir de ovas de peixe; exceto sardinha em conserva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708100','Sardinha em conserva')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708200','Crustáceos, moluscos e outros invertebrados aquáticos, preparados ou em conservas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708300','Carne de gado bovino, ovino e bufalino e produtos comestíveis resultantes da matança desse gado submetidos à salga, secagem ou desidratação')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708400','Carne de gado bovino, ovino e bufalino e demais produtos comestíveis resultantes da matança desse gado frescos, refrigerados ou congelados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708500','Carnes de animais das espécies caprina, frescas, refrigeradas ou congeladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708600','Carnes e demais produtos comestíveis frescos, resfriados, congelados, salgados ou salmourados resultantes do abate de caprinos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708700','Carnes e demais produtos comestíveis frescos, resfriados, congelados, salgados, em salmoura, simplesmente temperados, secos ou defumados, resultantes do abate de aves e de suínos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708800','Produtos hortícolas, cozidos em água ou vapor, congelados, em embalagens de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708801','Produtos hortícolas, cozidos em água ou vapor, congelados, em embalagens de conteúdo superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708900','Frutas, não cozidas ou cozidas em água ou vapor, congeladas, mesmo adicionadas de açúcar ou de outros edulcorantes, em embalagens de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1708901','Frutas, não cozidas ou cozidas em água ou vapor, congeladas, mesmo adicionadas de açúcar ou de outros edulcorantes, em embalagens de conteúdo superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709000','Produtos hortícolas, frutas e outras partes comestíveis de plantas, preparados ou conservados em vinagre ou em ácido acético, em embalagens de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709001','Produtos hortícolas, frutas e outras partes comestíveis de plantas, preparados ou conservados em vinagre ou em ácido acético, em embalagens de conteúdo superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709100','Outros produtos hortícolas preparados ou conservados, exceto em vinagre ou em ácido acético, congelados, com exceção dos produtos da posição 20.06, em embalagens de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709101','Outros produtos hortícolas preparados ou conservados, exceto em vinagre ou em ácido acético, congelados, com exceção dos produtos da posição 20.06, em embalagens de conteúdo superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709200','Outros produtos hortícolas preparados ou conservados, exceto em vinagre ou em ácido acético, não congelados, com exceção dos produtos da posição 20.06, excluídos batata, inhame e mandioca fritos, em embalagens de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709201','Outros produtos hortícolas preparados ou conservados, exceto em vinagre ou em ácido acético, não congelados, com exceção dos produtos da posição 20.06, excluídos batata, inhame e mandioca fritos, em embalagens de conteúdo superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709300','Produtos hortícolas, frutas, cascas de frutas e outras partes de plantas, conservados com açúcar (passados por calda, glaceados ou cristalizados), em embalagens de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709301','Produtos hortícolas, frutas, cascas de frutas e outras partes de plantas, conservados com açúcar (passados por calda, glaceados ou cristalizados), em embalagens de conteúdo superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709400','Doces, geléias, “marmelades”, purês e pastas de frutas, obtidos por cozimento, com ou sem adição de açúcar ou de outros edulcorantes, em embalagens de conteúdo inferior ou igual a 1 kg, exceto as embalagens individuais de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709401','Doces, geléias, “marmelades”, purês e pastas de frutas, obtidos por cozimento, com ou sem adição de açúcar ou de outros edulcorantes, em embalagens de conteúdo superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709500','Frutas e outras partes comestíveis de plantas, preparadas ou conservadas de outro modo, com ou sem adição de açúcar ou de outros edulcorantes ou de álcool, não especificadas nem compreendidas em outras posições, excluídos os amendoins e castanhas tipo aperitivo, da posição 2008.1, em embalagens de conteúdo inferior ou igual a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709501','Frutas e outras partes comestíveis de plantas, preparadas ou conservadas de outro modo, com ou sem adição de açúcar ou de outros edulcorantes ou de álcool, não especificadas nem compreendidas em outras posições, excluídos os amendoins e castanhas tipo aperitivo, da posição 2008.1, em embalagens superior a 1 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709600','Café torrado e moído, em embalagens de conteúdo inferior ou igual a 2 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709601','Café torrado e moído, em embalagens de conteúdo superior a 2 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709700','Chá, mesmo aromatizado')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709800','Mate')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709900','Açúcar refinado, em embalagens de conteúdo inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (sachês) de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709901','Açúcar refinado, em embalagens de conteúdo superior a 2 kg e inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1709902','Açúcar refinado, em embalagens de conteúdo superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710000','Açúcar refinado adicionado de aromatizante ou de corante em embalagens de conteúdo inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (sachês) de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710001','Açúcar refinado adicionado de aromatizante ou de corante em embalagens de conteúdo superior a 2 kg e inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710002','Açúcar refinado adicionado de aromatizante ou de corante em embalagens de conteúdo superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710100','Açúcar cristal, em embalagens de conteúdo inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (sachês) de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710101','Açúcar cristal, em embalagens de conteúdo superior a 2 kg e inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710102','Açúcar cristal, em embalagens de conteúdo superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710200','Açúcar cristal adicionado de aromatizante ou de corante, em embalagens de conteúdo inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (sachês) de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710201','Açúcar cristal adicionado de aromatizante ou de corante, em embalagens de conteúdo superior a 2 kg e inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710202','Açúcar cristal adicionado de aromatizante ou de corante, em embalagens de conteúdo superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710300','Outros tipos de açúcar, em embalagens de conteúdo inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (sachês) de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710301','Outros tipos de açúcar, em embalagens de conteúdo superior a 2 kg e inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710302','Outros tipos de açúcar, em embalagens de conteúdo superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710400','Outros tipos de açúcar adicionado de aromatizante ou de corante, em embalagens de conteúdo inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (sachês) de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710401','Outros tipos de açúcar adicionado de aromatizante ou de corante, em embalagens de conteúdo superior a 2 kg e inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710402','Outros tipos de açúcar adicionado de aromatizante ou de corante, em embalagens de conteúdo superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710500','Outros açúcares em embalagens de conteúdo inferior ou igual a 2 kg, exceto as embalagens contendo envelopes individualizados (sachês) de conteúdo inferior ou igual a 10 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710501','Outros açúcares, em embalagens de conteúdo superior a 2 kg e inferior ou igual a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710502','Outros açúcares, em embalagens de conteúdo superior a 5 kg')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710600','Milho para pipoca (micro-ondas)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710700','Extratos, essências e concentrados de café e preparações à base destes extratos, essências ou concentrados ou à base de café, em embalagens de conteúdo inferior ou igual a 500 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710800','Extratos, essências e concentrados de chá ou de mate e preparações à base destes extratos, essências ou concentrados ou à base de chá ou de mate, em embalagens de conteúdo inferior ou igual a 500 g, exceto as bebidas prontas à base de mate ou chá')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1710900','Preparações em pó para cappuccino e similares, em embalagens de conteúdo inferior ou igual a 500 g')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1800100','Artigos para serviço de mesa ou de cozinha, de porcelana, inclusive os descartáveis – estojos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1800200','Artigos para serviço de mesa ou de cozinha, de porcelana, inclusive os descartáveis – avulsos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1800300','Artigos para serviço de mesa ou de cozinha, de cerâmica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1800400','Velas para filtros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900100','Tinta guache')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900200','Espiral - perfil para encadernação, de plástico e outros materiais classificados nas posições 3901 a 3914')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900300','Outros espirais - perfil para encadernação, de plástico e outros materiais classificados nas posições 3901 a 3914')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900400','Artigos de escritório e artigos escolares de plástico e outros materiais classificados nas posições 3901 a 3914, exceto estojos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900500','Maletas e pastas para documentos e de estudante, e artefatos semelhantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900600','Prancheta de plástico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900700','Bobina para fax')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900800','Papel seda')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1900900','Bobina para máquina de calcular,  PDV ou equipamentos similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901000','Cartolina escolar e papel cartão, brancos e coloridos; recados auto adesivos (LP note); papéis de presente, todos cortados em tamanho pronto para uso escolar e doméstico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901100','Papel fotográfico, exceto: (i) os papéis fotográficos emulsionados com haleto de prata tipo brilhante, matte ou lustre, em rolo e, com largura igual ou superior a 102 mm e comprimento inferior ou igual a 350 m, (ii) os papéis fotográficos emulsionados com haleto de prata tipo brilhante ou fosco, em folha e com largura igual ou superior a 152 mm e comprimento inferior ou igual a 307 mm, (iii) papel de qualidade fotográfica com tecnologia “Thermo-autochrome”, que submetido a um processo de aquecimento seja ca')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901200','Papel almaço')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901300','Papel hectográfico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901400','Papel celofane e tipo celofane')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901500','Papel impermeável')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901600','Papel crepon')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901700','Papel fantasia')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901800','Papel-carbono, papel autocopiativo (exceto os vendidos em rolos de diâmetro igual ou superior a 60 cm e os vendidos em folhas de formato igual ou superior a 60 cm de altura e igual ou superior a 90 cm de largura) e outros papéis para cópia ou duplicação (incluídos os papéis para estênceis ou para chapas ofsete), estênceis completos e chapas ofsete, de papel, em folhas, mesmo acondicionados em caixas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1901900','Envelopes, aerogramas, bilhetes-postais não ilustrados e cartões para correspondência, de papel ou cartão, caixas, sacos e semelhantes, de papel ou cartão, contendo um sortido de artigos para correspondência')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902000','Livros de registro e de contabilidade, blocos de notas,de encomendas, de recibos, de apontamentos, de papel para cartas, agendas e artigos semelhantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902100','Cadernos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902200','Classificadores, capas para encadernação (exceto as capas para livros) e capas de processos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902300','Formulários em blocos tipo "manifold", mesmo com folhas intercaladas de papel-carbono')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902400','Álbuns para amostras ou para coleções')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902500','Pastas para documentos, outros artigos escolares, de escritório ou de papelaria, de papel ou cartão e capas para livros, de papel ou cartão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902600','Cartões postais impressos ou ilustrados, cartões impressos com votos ou mensagens pessoais, mesmo ilustrados, com ou sem envelopes, guarnições ou aplicações (conhecidos como cartões de expressão social - de época/sentimento)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902700','Canetas esferográficas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902800','Canetas e marcadores, com ponta de feltro ou com outras pontas porosas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1902900','Canetas tinteiro')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1903000','Outras canetas; sortidos de canetas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1903100','Papel cortado "cutsize" (tipo A3, A4, ofício I e II, carta e outros)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1903200','Papel camurça')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('1903300','Papel laminado e papel espelho')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000100','Henna (embalagens de conteúdo inferior ou igual a 200 g)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000101','Henna (embalagens de conteúdo superior a 200 g)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000200','Vaselina')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000300','Amoníaco em solução aquosa (amônia)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000400','Peróxido de hidrogênio, em embalagens de conteúdo inferior ou igual a 500 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000500','Lubrificação íntima')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000600','Óleos essenciais (desterpenados ou não), incluídos os chamados "concretos" ou "absolutos"; resinóides; oleorresinas de extração; soluções concentradas de óleos essenciais em gorduras, em óleos fixos, em ceras ou em matérias análogas, obtidas portratamento de flores através de substâncias gordas ou por maceração; subprodutos terpênicos residuais da desterpenação dos óleos essenciais; águas destiladas aromáticas e soluções aquosas de óleos essenciais, em embalagens de conteúdo inferior ou igual a 500 ml')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000700','Perfumes (extratos)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000800','Águas-de-colônia')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2000900','Produtos de maquilagem para os lábios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001000','Sombra, delineador, lápis para sobrancelhas e rímel')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001100','Outros produtos de maquilagem para os olhos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001200','Preparações para manicuros e pedicuros, incluindo removedores de esmalte à base de acetona')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001300','Pós, incluídos os compactos, para maquilagem')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001400','Cremes de beleza, cremes nutritivos e loções tônicas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001500','Outros produtos de beleza ou de maquilagem preparados e preparações para conservação ou cuidados da pele, exceto as preparações solares e antisolares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001600','Preparações solares e antisolares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001700','Xampus para o cabelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001800','Preparações para ondulação ou alisamento, permanentes, dos cabelos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2001900','Laquês para o cabelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002000','Outras preparações capilares, incluindo máscaras e finalizadores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002100','Condicionadores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002200','Tintura para o cabelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002300','Dentifrícios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002400','Fios utilizados para limpar os espaços interdentais (fios dentais)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002500','Outras preparações para higiene bucal ou dentária')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002600','Preparações para barbear (antes, durante ou após)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002700','Desodorantes (desodorizantes) corporais líquidos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002800','Antiperspirantes líquidos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2002900','Outros desodorantes (desodorizantes) corporais')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003000','Outros antiperspirantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003100','Sais perfumados e outras preparações para banhos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003200','Outros produtos de perfumaria ou de toucador preparados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003300','Soluções para lentes de contato ou para olhos artificiais')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003400','Sabões de toucador em barras, pedaços ou figuras moldados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003500','Outros sabões, produtos e preparações, em barras, pedaços ou figuras moldados, inclusive lenços umedecidos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003600','Sabões de toucador sob outras formas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003700','Produtos e preparações orgânicos tensoativos para lavagem da pele, na forma de líquido ou de creme, acondicionados para venda a retalho, mesmo contendo sabão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003800','Bolsa para gelo ou para água quente')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2003900','Chupetas e bicos para mamadeiras e para chupetas, de borracha')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004000','Chupetas e bicos para mamadeiras e para chupetas, de silicone')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004100','Malas e maletas de toucador')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004200','Papel higiênico - folha simples')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004300','Papel higiênico - folha dupla e tripla')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004400','Lenços (incluídos os de maquilagem) e toalhas de mão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004500','Papel toalha de uso institucional do tipo comercializado em rolos igual ou superior a 80 metros e do tipo comercializado em folhas intercaladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004600','Toalhas e guardanapos de mesa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004700','Toalhas de cozinha (papel toalha de uso doméstico)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004800','Fraldas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2004900','Tampões higiênicos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005000','Absorventes higiênicos externos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005100','Hastes flexíveis (uso não medicinal)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005200','Sutiã descartável, assemelhados e papel para depilação')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005300','Pinças para sobrancelhas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005400','Espátulas (artigos de cutelaria)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005500','Utensílios e sortidos de utensílios de manicuros ou de pedicuros (incluídas as limas para unhas)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005600','Termômetros, inclusive o digital')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005700','Escovas e pincéis de barba, escovas para cabelos, para cílios ou para unhas e outras escovas de toucador de pessoas, incluídas as que sejam partes de aparelhos, exceto escovas de dentes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005800','Escovas de dentes, incluídas as escovas para dentaduras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2005900','Pincéis para aplicação de produtos cosméticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2006000','Sortidos de viagem, para toucador de pessoas para costura ou para limpeza de calçado ou de roupas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2006100','Pentes, travessas para cabelo e artigos semelhantes; grampos (alfinetes) para cabelo; pinças (pinceguiches), onduladores, bobes (rolos) e artefatos semelhantes para penteados, e suas partes, exceto os classificados na posição 8516 e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2006200','Borlas ou esponjas para pós ou para aplicação de outros cosméticos ou de produtos de toucador')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2006300','Mamadeiras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2006400','Aparelhos e lâminas de barbear')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100100','Fogões de cozinha de uso doméstico e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100200','Combinações de refrigeradores e congeladores ("freezers"), munidos de portas exteriores separadas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100300','Refrigeradores do tipo doméstico, de compressão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100400','Outros refrigeradores do tipo doméstico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100500','Congeladores ("freezers") horizontais tipo arca, de capacidade não superior a 800 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100600','Congeladores ("freezers") verticais tipo armário, de capacidade não superior a 900 litros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100700','Outros móveis (arcas, armários, vitrines, balcões e móveis semelhantes) para a conservação e exposição de produtos, que incorporem um equipamento para a produção de frio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100800','Mini adega e similares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2100900','Máquinas para produção de gelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101000','Partes dos refrigeradores, congeladores, mini adegas e similares, máquinas para produção de gelo e bebedouros descritos nos itens 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0 e 13.0.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101100','Secadoras de roupa de uso doméstico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101200','Outras secadoras de roupas e centrífugas de uso doméstico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101300','Bebedouros refrigerados para água')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101400','Partes das secadoras de roupas e centrífugas de uso doméstico e dos aparelhos para filtrar ou depurar água, descritos nos itens 11.0 e 12.0 e 98.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101500','Máquinas de lavar louça do tipo doméstico e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101600','Máquinas que executem pelo menos duas das seguintes funções: impressão, cópia ou transmissão de telecópia (fax), capazes de ser conectadas a uma máquina automática para processamento de dados ou a uma rede')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101700','Outras impressoras, máquinas copiadoras e telecopiadores (fax), mesmo combinados entre si, capazes de ser conectados a uma máquina automática para processamento de dados ou a uma rede')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101800','Partes e acessórios de máquinas e aparelhos de impressão por meio de blocos, cilindros e outros elementos de impressão da posição 8442; e de outras impressoras, máquinas copiadoras e telecopiadores (fax), mesmo combinados entre si')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2101900','Máquinas de lavar roupa, mesmo com dispositivos de secagem, de uso doméstico, de capacidade não superior a 10 kg, em peso de roupa seca, inteiramente automáticas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102000','Outras máquinas de lavar roupa, mesmo com dispositivos de secagem, de uso doméstico, com secador centrífugo incorporado')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102100','Outras máquinas de lavar roupa, mesmo com dispositivos de secagem, de uso doméstico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102200','Máquinas de lavar roupa, mesmo com dispositivos de secagem, de uso doméstico, de capacidade superior a 10 kg, em peso de roupa seca')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102300','Partes de máquinas de lavar roupa, mesmo com dispositivos de secagem, de uso doméstico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102400','Máquinas de secar de uso doméstico de capacidade não superior a 10 kg, em peso de roupa seca')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102500','Outras máquinas de secar de uso doméstico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102600','Partes de máquinas de secar de uso doméstico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102700','Máquinas de costura de uso doméstico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102800','Máquinas automáticas para processamento de dados, portáteis, de peso não superior a 10 kg, contendo pelo menos uma unidade central de processamento, um teclado e uma tela')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2102900','Outras máquinas automáticas para processamento de dados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103000','Unidades de processamento, de pequena capacidade, exceto as das subposições 8471.41 ou 8471.49, podendo conter, no mesmo corpo, um ou dois dos seguintes tipos de unidades: unidade de memória, unidade de entrada e unidade de saída;baseadas em microprocessadores, com capacidade de instalação, dentro do mesmo gabinete, de unidades de memória da subposição 8471.70, podendo conter múltiplos conectores de expansão ("slots"), e valor FOB inferior ou igual a US$ 12.500,00, por unidade')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103100','Unidades de entrada, exceto as classificadas no código 8471.60.54')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103200','Outras unidades de entrada ou de saída, podendo conter, no mesmo corpo, unidades de memória')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103300','Unidades de memória')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103400','Outras máquinas automáticas para processamento de dados e suas unidades; leitores magnéticos ou ópticos, máquinas para registrar dados em suporte sob forma codificada, e máquinas para processamento desses dados, não especificadas nem compreendidas em outras posições')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103500','Partes e acessórios das máquinas da posição 84.71')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103600','Outros transformadores, exceto os classificados nos códigos 8504.33.00 e 8504.34.00')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103700','Carregadores de acumuladores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103800','Equipamentos de alimentação ininterrupta de energia (UPS ou "no break")')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2103900','Outros acumuladores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104000','Aspiradores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104100','Aparelhos eletromecânicos de motor elétrico incorporado, de uso doméstico e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104200','Enceradeiras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104300','Chaleiras elétricas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104400','Ferros elétricos de passar')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104500','Fornos de microondas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104600','Outros fornos; fogareiros (incluídas as chapas de cocção), grelhas e assadeiras, exceto os portáteis')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104700','Outros fornos; fogareiros (incluídas as chapas de cocção), grelhas e assadeiras, portáteis')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104800','Outros aparelhos eletrotérmicos de uso doméstico - Cafeteiras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2104900','Outros aparelhos eletrotérmicos de uso doméstico - Torradeiras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105000','Outros aparelhos eletrotérmicos de uso doméstico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105100','Partes das chaleiras, ferros, fornos e outros aparelhos eletrotérmicos da posição 85.16, descritos nos itens 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0 e 50.0')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105200','Aparelhos telefônicos por fio com unidade auscultador - microfone sem fio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105300','Telefones para redes celulares, exceto por satélite e os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105400','Outros telefones para outras redes sem fio, exceto para redes de celulares e os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105500','Outros aparelhos telefônicos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105600','Aparelhos para transmissão ou recepção de voz, imagem ou outros dados em rede com fio, exceto os classificados nos códigos 8517.62.51, 8517.62.52 e 8517.62.53')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105700','Microfones e seus suportes; altofalantes, mesmo montados nos seus receptáculos, fones de ouvido (auscultadores), mesmo combinados com microfone e conjuntos ou sortidos constituídos por um microfone e um ou mais alto-falantes, amplificadores elétricos de audiofreqüência, aparelhos elétricos de amplificação de som; suas partes e acessórios; exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105800','Aparelhos de radiodifusão suscetíveis de funcionarem sem fonte externa de energia. Aparelhos de gravação de som; aparelhos de reprodução de som; aparelhos de gravação e de reprodução de som; partes e acessórios; exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2105900','Outros aparelhos de gravação de som; aparelhos de reprodução de som; aparelhos de gravação e de reprodução de som; partes e acessórios; exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106000','Gravador-reprodutor e editor de imagem e som, em discos, por meio magnético, óptico ou optomagnético, exceto de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106100','Outros aparelhos videofônicos de gravação ou reprodução, mesmo incorporando um receptor de sinais videofônicos, exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106200','Cartões de memória ("memory cards")')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106300','Cartões inteligentes ("smart cards")')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106400','Cartões inteligentes ("sim cards")')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106500','Câmeras fotográficas digitais e câmeras de vídeo e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106600','Outros aparelhos receptores para radiodifusão, mesmo combinados num invólucro, com um aparelho de gravação ou de reprodução de som, ou com um relógio, inclusive caixa acústica para Home Theaters classificados na posição 8518')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106700','Monitores e projetores que não incorporem aparelhos receptores de televisão, policromáticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106800','Outros monitores dos tipos utilizados exclusiva ou principalmente com uma máquina automática para processamento de dados da posição 84.71, policromáticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2106900','Aparelhos receptores de televisão, mesmo que incorporem um aparelho receptor de radiodifusão ou um aparelho de gravação ou reprodução de som ou de imagens - Televisores de CRT (tubo de raios catódicos)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107000','Aparelhos receptores de televisão, mesmo que incorporem um aparelho receptor de radiodifusão ou um aparelho de gravação ou reprodução de som ou de imagens - Televisores de LCD (Display de Cristal Líquido)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107100','Aparelhos receptores de televisão, mesmo que incorporem um aparelho receptor de radiodifusão ou um aparelho de gravação ou reprodução de som ou de imagens - Televisores de Plasma')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107200','Outros aparelhos receptores de televisão não dotados de monitores ou display de vídeo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107300','Outros aparelhos receptores de televisão não relacionados em outros itens deste anexo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107400','Câmeras fotográficas dos tipos utilizadas para preparação de clichês ou cilindros de impressão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107500','Câmeras fotográficas para filmes de revelação e copiagem instantâneas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107600','Aparelhos de diatermia')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107700','Aparelhos de massagem')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107800','Reguladores de voltagem eletrônicos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2107900','Consoles e máquinas de jogos de vídeo, exceto os classificados na subposição 9504.30')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108000','Multiplexadores e concentradores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108100','Centrais automáticas privadas, de capacidade inferior ou igual a 25 ramais')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108200','Outros aparelhos para comutação')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108300','Roteadores digitais, em redes com ou sem fio')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108400','Aparelhos emissores com receptor incorporado de sistema troncalizado ("trunking"), de tecnologia celular')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108500','Outros aparelhos de recepção, conversão e transmissão ou regeneração de voz, imagens ou outros dados, incluindo os aparelhos de comutação e roteamento')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108600','Antenas próprias para telefones celulares portáteis, exceto as telescópicas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108700','Aparelhos ou máquinas de barbear, máquinas de cortar o cabelo ou de tosquiar e aparelhos de depilar, e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108800','Ventiladores, exceto os de uso agrícola')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2108900','Ventiladores de uso agrícola')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109000','Coifas com dimensão horizontal máxima não superior a 120 cm')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109100','Partes de ventiladores ou coifas aspirantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109200','Máquinas e aparelhos de ar condicionado contendo um ventilador motorizado e dispositivos próprios para modificar a temperatura e a umidade, incluídos as máquinas e aparelhos em que a umidade não seja regulável separadamente')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109300','Aparelhos de ar-condicionado tipo Split System (sistema com elementos separados) com unidade externa e interna')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109400','Aparelhos de ar-condicionado com capacidade inferior ou igual a 30.000 frigorias/hora')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109500','Aparelhos de ar-condicionado com capacidade acima de 30.000 frigorias/hora')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109600','Unidades evaporadoras (internas) de aparelho de ar-condicionado do tipo Split System (sistema com elementos separados), com capacidade inferior ou igual a 30.000 frigorias/hora')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109700','Unidades condensadoras (externas) de aparelho de ar-condicionado do tipo Split System (sistema com elementos separados), com capacidade inferior ou igual a 30.000 frigorias/hora')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109800','Aparelhos elétricos para filtrar ou depurar água')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2109900','Lavadora de alta pressão e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110000','Furadeiras elétricas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110100','Aparelhos elétricos para aquecimento de ambientes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110200','Secadores de cabelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110300','Outros aparelhos para arranjos do cabelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110400','Aparelhos receptores para radiodifusão, mesmo combinados num mesmo invólucro, com um aparelho de gravação ou de reprodução de som, ou com um relógio, exceto os classificados na posição 8527.1, 8527.2 e 8527.9  que sejam de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110500','Climatizadores de ar')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110600','Outras partes para máquinas e aparelhos de ar-condicionado que contenham um ventilador motorizado e dispositivos próprios para modificar a temperatura e a umidade, incluindo as máquinas e aparelhos em que a umidade não seja regulável separadamente')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110700','Câmeras de televisão e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110800','Balanças de uso doméstico')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2110900','Tubos e válvulas, eletrônicos, de cátodo quente, cátodo frio ou fotocátodo (por exemplo, tubos e válvulas, de vácuo, de vapor ou de gás, ampolas retificadoras de vapor de mercúrio, tubos catódicos, tubos e válvulas para câmeras de televisão)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111000','Aparelhos elétricos para telefonia; outros aparelhos para transmissão ou recepção de voz, imagens ou outros dados, incluídos os aparelhos para comunicação em redes por fio ou redes sem fio (tal como uma rede local (LAN) ou uma rede de área estendida (WAN), incluídas suas partes, exceto os de uso automotivo e os classificados nos códigos  8517.62.51, 8517.62.52 e 8517.62.53')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111100','Interfones, seus acessórios, tomadas e "plugs"')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111200','Partes reconhecíveis como exclusiva ou principalmente destinadas aos aparelhos das posições 8525 a 8528; exceto as de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111300','Aparelhos elétricos de sinalização acústica ou visual (por exemplo, campainhas, sirenes, quadros indicadores, aparelhos de alarme para proteção contra roubo ou incêndio); exceto os de uso automotivo e os classificados nas posições 8531.10 e 8531.80.00.')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111400','Aparelhos elétricos de alarme, para proteção contra roubo ou incêndio e aparelhos semelhantes, exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111500','Outros aparelhos de sinalização acústica ou visual, exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111600','Circuitos impressos, exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111700','Diodos emissores de luz (LED), exceto diodos "laser"')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111800','Eletrificadores de cercas eletrônicos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2111900','Aparelhos e instrumentos para medida ou controle da tensão, intensidade, resistência ou da potência, sem dispositivo registrador; exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2112000','Analisadores lógicos de circuitos digitais, de espectro de frequência, frequencímetros, fasímetros, e outros instrumentos e aparelhos de controle de grandezas elétricas e detecção')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2112100','Interruptores horários e outros aparelhos que permitam acionar um mecanismo em tempo determinado, munidos de maquinismo de aparelhos de relojoaria ou de motor síncrono')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2112200','Aparelhos de iluminação (incluídos os projetores) e suas partes, não especificados nem compreendidos em outras posições; anúncios, cartazes ou tabuletas e placas indicadoras luminosos, e artigos semelhantes, contendo uma fonte luminosa fixa permanente, e suas partes não especificadas nem compreendidas em outras posições')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2200100','Ração tipo “pet” para animais domésticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2300100','Sorvetes de qualquer espécie')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2300200','Preparados para fabricação de sorvete em máquina')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2400100','Tintas, vernizes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2400200','Xadrez e pós assemelhados, exceto pigmentos à base de dióxido de titânio classificados no código 3206.11.19')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500100','Veículos automóveis para transporte de 10 pessoas ou mais, incluindo o motorista, com motor de pistão, de ignição por compressão (diesel ou semidiesel), com volume interno de habitáculo, destinado a passageiros e motorista, superior a 6 m³, mas inferior a 9 m³')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500200','Outros veículos automóveis para transporte de 10 pessoas ou mais, incluindo o motorista, com volume interno de habitáculo, destinado a passageiros e motorista, superior a 6 m³, mas inferior a 9 m³')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500300','Automóveis com motor explosão, de cilindrada não superior a 1000 cm³')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500400','Automóveis com motor explosão, de cilindrada superior a 1000 cm³, mas não superior a 1500 cm³, com capacidade de transporte de pessoas sentadas inferior ou igual a 6, incluído o condutor, exceto carro celular')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500500','Outros automóveis com motor explosão, de cilindrada superior a 1000 cm³, mas não superior a 1500 cm³, exceto carro celular')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500600','Automóveis com motor explosão, de cilindrada superior a 1500 cm³, mas não superior a 3000 cm³, com capacidade de transporte de pessoas sentadas inferior ou igual a 6, incluído o condutor, exceto carro celular, carro funerário e automóveis de corrida')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500700','Outros automóveis com motor explosão, de cilindrada superior a 1500 cm³, mas não superior a 3000 cm³, exceto carro celular, carro funerário e automóveis de corrida')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500800','Automóveis com motor explosão, de cilindrada superior a 3000 cm³, com capacidade de transporte de pessoas sentadas inferior ou igual a 6, incluído o condutor, exceto carro celular, carro funerário e automóveis de corrida')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2500900','Outros automóveis com motor explosão, de cilindrada superior a 3000 cm³, exceto carro celular, carro funerário e automóveis de corrida')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501000','Automóveis com motor diesel ou semidiesel, de cilindrada superior a 1500 cm³, mas não superior a 2500 cm³, com capacidade de transporte de pessoas sentadas inferior ou igual a 6, incluído o condutor, exceto ambulância, carro celular e carro funerário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501100','Outros automóveis com motor diesel ou semidiesel, de cilindrada superior a 1500 cm³, mas não superior a 2500 cm³, exceto ambulância, carro celular e carro funerário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501200','Automóveis com motor diesel ou semidiesel, de cilindrada superior a 2500 cm³, com capacidade de transporte de pessoas sentadas inferior ou igual a 6, incluído o condutor, exceto carro celular e carro funerário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501300','Outros automóveis com motor diesel ou semidiesel, de cilindrada superior a 2500 cm³, exceto carro celular e carro funerário')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501400','Veículos automóveis para transporte de mercadorias, de peso em carga máxima não superior a 5 toneladas, chassis com motor diesel ou semidiesel e cabina, exceto caminhão de peso em carga máxima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501500','Veículos automóveis para transporte de mercadorias, de peso em carga máxima não superior a 5 toneladas, com motor diesel ou semidiesel, com caixa basculante, exceto caminhão de peso em carga máxima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501600','Veículos automóveis para transporte de mercadorias, de peso em carga máxima não superior a 5 toneladas, frigoríficos ou isotérmicos, com motor diesel ou semidiesel, exceto caminhão de peso em carga máxima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501700','Outros veículos automóveis para transporte de mercadorias, de peso em carga máxima não superior a 5 toneladas, com motor diesel ou semidiesel, exceto carro-forte para transporte de valores e caminhão de peso em carga máxima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501800','Veículos automóveis para transporte de mercadorias, de peso em carga máxima não superior a 5 toneladas, com motor a explosão, chassis e cabina, exceto caminhão de peso em carga máxima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2501900','Veículos automóveis para transporte de mercadorias, de peso em carga máxima não superior a 5 toneladas, com motor explosão com caixa basculante, exceto caminhão de peso em carga máxima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2502000','Veículos automóveis para transporte de mercadorias, de peso em carga máxima não superior a 5 toneladas, frigoríficos ou isotérmicos com motor explosão, exceto caminhão de peso em carga máxima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2502100','Outros veículos automóveis para transporte de mercadorias, de peso em carga máxima não superior a 5 toneladas, com motor a explosão, exceto carro-forte para transporte de valores e caminhão de peso em carga máxima superior a 3,9 toneladas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2600100','Motocicletas (incluídos os ciclomotores) e outros ciclos equipados com motor auxiliar, mesmo com carro lateral; carros laterais')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2700100','Espelhos de vidro, mesmo emoldurados, exceto os de uso automotivo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2700200','Objetos de vidro para serviço de mesa ou de cozinha')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2700300','Outros copos, exceto de vitrocerâmica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2700400','Objetos para serviço de mesa (exceto copos) ou de cozinha, exceto de vitrocerâmica')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800100','Perfumes (extratos)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800200','Águas-de-colônia')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800300','Produtos de maquiagem para os lábios')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800400','Sombra, delineador, lápis para sobrancelhas e rímel')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800500','Outros produtos de maquiagem para os olhos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800600','Preparações para manicuros e pedicuros')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800700','Pós para maquiagem, incluindo os compactos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800800','Cremes de beleza, cremes nutritivos e loções tônicas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2800900','Outros produtos de beleza ou de maquiagem preparados e preparações para conservação ou cuidados da pele, exceto as preparações antisolares e os bronzeadores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801000','Preparações antisolares e os bronzeadores')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801100','Xampus para o cabelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801200','Preparações para ondulação ou alisamento, permanentes, dos cabelos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801300','Outras preparações capilares')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801400','Tintura para o cabelo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801500','Preparações para barbear (antes, durante ou após)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801600','Desodorantes corporais e antiperspirantes, líquidos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801700','Outros desodorantes corporais e antiperspirantes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801800','Outros produtos de perfumaria ou de toucador preparados')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2801900','Outras preparações cosméticas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802000','Sabões de toucador, em barras, pedaços ou figuras moldadas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802100','Outros sabões, produtos e preparações orgânicos tensoativos, inclusive papel, pastas (ouates), feltros e falsos tecidos, impregnados, revestidos ou recobertos de sabão ou de detergentes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802200','Sabões de toucador sob outras formas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802300','Produtos e preparações orgânicos tensoativos para lavagem da pele, em forma de líquido ou de creme, acondicionados para venda a retalho, mesmo contendo sabão')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802400','Lenços de papel, incluindo os de desmaquiar')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802500','Apontadores de lápis para maquiagem')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802600','Utensílios e sortidos de utensílios de manicuros ou de pedicuros (incluindo as limas para unhas)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802700','Escovas e pincéis de barba, escovas para cabelos, para cílios ou para unhas e outras escovas de toucador de pessoas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802800','Pincéis para aplicação de produtos cosméticos')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2802900','Vaporizadores de toucador, suas armações e cabeças de armações')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803000','Borlas ou esponjas para pós ou para aplicação de outros cosméticos ou de produtos de toucador')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803100','Malas e maletas de toucador')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803200','Pentes, travessas para cabelo e artigos semelhantes; grampos (alfinetes) para cabelo; pinças (“pinceguiches”), onduladores, bobs (rolos) e artefatos semelhantes para penteados, e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803300','Mamadeiras')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803400','Chupetas e bicos para mamadeiras e para chupetas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803500','Outros produtos cosméticos e de higiene pessoal não relacionados em outros itens deste anexo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803600','Outros artigos destinados a cuidados pessoais não relacionados em outros itens deste anexo')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803700','Acessórios (por exemplo, bijuterias, relógios, óculos de sol, bolsas, mochilas, frasqueiras, carteiras, porta-cartões, porta-documentos, porta-celulares e embalagens presenteáveis (por exemplo, caixinhas de papel), entre outros itens assemelhados)')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803800','Vestuário e seus acessórios; calçados, polainas e artefatos semelhantes, e suas partes')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2803900','Outros artigos de vestuário em geral, exceto os relacionados no item anterior')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2804000','Artigos de casa')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2804100','Produtos das indústrias alimentares e bebidas')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2804200','Produtos destinados à higiene bucal')
INSERT INTO CODIGOCEST (CODIGO, DESCRICAO) VALUES ('2804300','Produtos de limpeza e conservação doméstica')

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

-- Parâmetros
IF not EXISTS (SELECT 1 FROM ITEM WHERE OID = 37917)
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','Libera mudança de Modo de emissão NF-e',18,37917,0)
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
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7           ,1,1,'','01/01/01','01/01/01','','Tipo de Mudança emissão NF-e',18,37902,0)
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
insert into item (rescopo, criadopor, atualizadopor, codigo, criadoem, atualizadoem , observacao, nome, cid, oid, excluido) values (7 ,1,1,' ','01/01/01','01/01/01','Define se a filial esta dispensada de destacar/recolher o ICMS DIFAL (Partilha de ICMS de Operações Interestaduais de Vendas a Consumidor Final). Valores possíveis S ou N.','Dispensado do cálculo do ICMS DIFAL nas vendas para não contribuinte fora do estado',18,37798,0)
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

-- Adição de campos tabela 'BASECALFAT'

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
