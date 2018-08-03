USE [BDENTER]
GO

/****** Object:  Trigger [dbo].[FOTO]    Script Date: 04/05/2018 07:36:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER trigger [dbo].[FOTO] on [dbo].[PRODUTOCAD] 
for INSERT as  begin  
DELETE FROM IMAGEMPRODUTO  
INSERT INTO IMAGEMPRODUTO (CODPRO,NOME,ORDEM,IMAGEM)   
SELECT CODPRO, LEFT(DESCR,30), 1, '\\192.168.0.198\FOTOS\'+CODPRO+'.GIF'  
FROM PRODUTOCAD  
END    
GO