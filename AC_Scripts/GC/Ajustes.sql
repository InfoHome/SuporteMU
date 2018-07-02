USE WEB_DESENV
GO
-- AJUSTE 1
-- SELECT * FROM TAB_PARAMETROS_CONST
-------------------------------------------------------------------------------
drop table TAB_NIVEL6_CONST
drop table TAB_NIVEL7_CONST
drop table TAB_NIVEL8_CONST
drop table TAB_NIVEL9_CONST
drop table TAB_NIVEL10_CONST
drop table TAB_NIVEL11_CONST
drop table TAB_NIVEL12_CONST
drop table TAB_NIVEL13_CONST
-------------------------------------------------------------------------------
drop table NIVEL6_CONST
drop table NIVEL7_CONST
drop table NIVEL8_CONST
drop table NIVEL9_CONST
drop table NIVEL10_CONST
drop table NIVEL11_CONST
drop table NIVEL12_CONST
drop table NIVEL13_CONST

UPDATE TAB_PARAMETROS_CONST 
	SET NIVEL6 = 'CATEGORIA',
		NIVEL7 = 'PRODUTO',
		NIVEL8 = NULL,
		NIVEL9 = NULL,
		NIVEL10 = NULL,
		NIVEL11 = NULL,
		NIVEL12 = NULL,
		NIVEL13 = NULL
-------------------------------------------------------------------------------
-- AJUSTE 2
----------------------------------------------------------
/****** Object:  Table [dbo].[TAB_NIVEL12_CONST]    Script Date: 28/05/2018 15:22:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [dbo].[NIVEL12_CONST]    Script Date: 28/05/2018 15:15:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NIVEL6_CONST](
	[NIVEL6] [char](12) NOT NULL,
	[NIVEL1] [char](10) NOT NULL,
	[NIVEL2] [char](2) NOT NULL,
	[NIVEL3] [char](5) NOT NULL,
	[NIVEL4] [char](10) NOT NULL,
	[NIVEL5] [char](10) NOT NULL,
	[DATA] [datetime] NOT NULL,
	[ATR1] [float] NULL,
	[ATR2] [float] NULL,
	[ATR3] [float] NULL,
	[ATR4] [float] NULL,
	[ATR5] [float] NULL,
	[ATR6] [float] NULL,
	[ATR7] [float] NULL,
	[ATR8] [float] NULL,
 CONSTRAINT [PK_NIVEL6_CONST] PRIMARY KEY CLUSTERED 
(
	[NIVEL1] ASC,
	[NIVEL2] ASC,
	[NIVEL3] ASC,
	[NIVEL4] ASC,
	[NIVEL5] ASC,
	[NIVEL6] ASC,
	[DATA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
-------------------------------------------------------------------------------
CREATE TABLE [dbo].[TAB_NIVEL6_CONST](
	[NIVEL6] [char](12) NOT NULL,
	[DESCRICAO] [varchar](100) NULL,
 CONSTRAINT [PK_TAB_NIVEL6_CONST] PRIMARY KEY CLUSTERED 
(
	[NIVEL6] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- AJUSTE 3
-------------------------------------------------------------------------------
/****** Object:  Table [dbo].[NIVEL13_CONST]    Script Date: 28/05/2018 15:15:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NIVEL7_CONST](
	[NIVEL7] [char](5) NOT NULL,
	[NIVEL1] [char](10) NOT NULL,
	[NIVEL2] [char](2) NOT NULL,
	[NIVEL3] [char](5) NOT NULL,
	[NIVEL4] [char](10) NOT NULL,
	[NIVEL5] [char](10) NOT NULL,
	[NIVEL6] [char](12) NOT NULL,
	[DATA] [datetime] NOT NULL,
	[TIPO] [char](1) NOT NULL,
	[ATR1] [float] NULL,
	[ATR2] [float] NULL,
	[ATR3] [float] NULL,
	[ATR4] [float] NULL,
	[ATR5] [float] NULL,
	[ATR6] [float] NULL,
	[ATR7] [float] NULL,
	[ATR8] [float] NULL,
 CONSTRAINT [PK_NIVEL7_CONST] PRIMARY KEY CLUSTERED 
(
	[NIVEL1] ASC,
	[NIVEL2] ASC,
	[NIVEL3] ASC,
	[NIVEL4] ASC,
	[NIVEL5] ASC,
	[NIVEL6] ASC,
	[NIVEL7] ASC,
	[DATA] ASC,
	[TIPO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

--------------------------------------------------------------------------------------------------------------------------
GO
/****** Object:  Table [dbo].[TAB_NIVEL12_CONST]    Script Date: 28/05/2018 15:22:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAB_NIVEL7_CONST](
	[NIVEL7] [char](5) NOT NULL,
	[DESCRICAO] [varchar](100) NULL,
	[COMPRADOR] [varchar](100) NULL,
 CONSTRAINT [PK_TAB_NIVEL7_CONST] PRIMARY KEY CLUSTERED 
(
	[NIVEL7] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
Select visao, campo4, campo5, campo6 from tab_ini where visao ='COMERCIAL'

UPDATE TAB_INI 
	SET VISAO = 'CATEGORIA_REDE',
		CAMPO4 = '*NIVEL1_CONST,NIVEL2_CONST,NIVEL3_CONST,NIVEL4_CONST,NIVEL5_CONST,NIVEL6_CONST,NIVEL7_CONST',
		CAMPO5 = 'TAB_NIVEL1_CONST,TAB_NIVEL2_CONST,TAB_NIVEL3_CONST,TAB_NIVEL4_CONST,TAB_NIVEL5_CONST,TAB_NIVEL6_CONST,TAB_NIVEL7_CONST'
WHERE VISAO = 'COMERCIAL'

UPDATE TAB_PARAMETROS_CONST SET empresa = 'CATEGORIA_REDE'

SELECT * FROM TAB_INI
SELECT * FROM TAB_PARAMETROS_CONST
SELECT * FROM CUBOPERMISSAO 


