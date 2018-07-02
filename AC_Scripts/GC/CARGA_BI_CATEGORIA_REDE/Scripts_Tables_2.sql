USE WEBBI
GO
DROP TABLE NIVEL1_AC_REDE
DROP TABLE NIVEL2_AC_REDE
DROP TABLE NIVEL3_AC_REDE
DROP TABLE NIVEL4_AC_REDE
DROP TABLE NIVEL5_AC_REDE
DROP TABLE NIVEL6_AC_REDE
DROP TABLE NIVEL7_AC_REDE
DROP TABLE TAB_NIVEL1_AC_REDE
DROP TABLE TAB_NIVEL2_AC_REDE
DROP TABLE TAB_NIVEL3_AC_REDE
DROP TABLE TAB_NIVEL4_AC_REDE
DROP TABLE TAB_NIVEL5_AC_REDE
DROP TABLE TAB_NIVEL6_AC_REDE
DROP TABLE TAB_NIVEL7_AC_REDE
DROP TABLE tab_parametros_AC_REDE
GO
/****** Object:  Table [dbo].[NIVEL1_AC_REDE]    Script Date: 30/05/2018 08:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NIVEL1_AC_REDE](
	[NIVEL1] [char](8) NOT NULL,
	[DATA] [datetime] NOT NULL,
	[ATR1] [float] NULL,
	[ATR2] [float] NULL,
	[ATR3] [float] NULL,
	[ATR4] [float] NULL,
	[ATR5] [float] NULL,
	[ATR6] [float] NULL,
	[ATR7] [float] NULL,
	[ATR8] [float] NULL,
 CONSTRAINT [PK_NIVEL1_AC_REDE] PRIMARY KEY CLUSTERED 
(
	[NIVEL1] ASC,
	[DATA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NIVEL2_AC_REDE]    Script Date: 30/05/2018 08:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NIVEL2_AC_REDE](
	[NIVEL2] [char](2) NOT NULL,
	[NIVEL1] [char](8) NOT NULL,
	[DATA] [datetime] NOT NULL,
	[ATR1] [float] NULL,
	[ATR2] [float] NULL,
	[ATR3] [float] NULL,
	[ATR4] [float] NULL,
	[ATR5] [float] NULL,
	[ATR6] [float] NULL,
	[ATR7] [float] NULL,
	[ATR8] [float] NULL,
 CONSTRAINT [PK_NIVEL2_AC_REDE] PRIMARY KEY CLUSTERED 
(
	[NIVEL1] ASC,
	[NIVEL2] ASC,
	[DATA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NIVEL3_AC_REDE]    Script Date: 30/05/2018 08:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NIVEL3_AC_REDE](
	[NIVEL3] [char](20) NOT NULL,
	[NIVEL1] [char](8) NOT NULL,
	[NIVEL2] [char](2) NOT NULL,
	[DATA] [datetime] NOT NULL,
	[ATR1] [float] NULL,
	[ATR2] [float] NULL,
	[ATR3] [float] NULL,
	[ATR4] [float] NULL,
	[ATR5] [float] NULL,
	[ATR6] [float] NULL,
	[ATR7] [float] NULL,
	[ATR8] [float] NULL,
 CONSTRAINT [PK_NIVEL3_AC_REDE] PRIMARY KEY CLUSTERED 
(
	[NIVEL1] ASC,
	[NIVEL2] ASC,
	[NIVEL3] ASC,
	[DATA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NIVEL4_AC_REDE]    Script Date: 30/05/2018 08:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NIVEL4_AC_REDE](
	[NIVEL4] [char](5) NOT NULL,
	[NIVEL1] [char](8) NOT NULL,
	[NIVEL2] [char](2) NOT NULL,
	[NIVEL3] [char](20) NOT NULL,
	[DATA] [datetime] NOT NULL,
	[ATR1] [float] NULL,
	[ATR2] [float] NULL,
	[ATR3] [float] NULL,
	[ATR4] [float] NULL,
	[ATR5] [float] NULL,
	[ATR6] [float] NULL,
	[ATR7] [float] NULL,
	[ATR8] [float] NULL,
 CONSTRAINT [PK_NIVEL4_AC_REDE] PRIMARY KEY CLUSTERED 
(
	[NIVEL1] ASC,
	[NIVEL2] ASC,
	[NIVEL3] ASC,
	[NIVEL4] ASC,
	[DATA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NIVEL5_AC_REDE]    Script Date: 30/05/2018 08:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NIVEL5_AC_REDE](
	[NIVEL5] [char](10) NOT NULL,
	[NIVEL1] [char](8) NOT NULL,
	[NIVEL2] [char](2) NOT NULL,
	[NIVEL3] [char](20) NOT NULL,
	[NIVEL4] [char](5) NOT NULL,
	[DATA] [datetime] NOT NULL,
	[ATR1] [float] NULL,
	[ATR2] [float] NULL,
	[ATR3] [float] NULL,
	[ATR4] [float] NULL,
	[ATR5] [float] NULL,
	[ATR6] [float] NULL,
	[ATR7] [float] NULL,
	[ATR8] [float] NULL,
 CONSTRAINT [PK_NIVEL5_AC_REDE] PRIMARY KEY CLUSTERED 
(
	[NIVEL1] ASC,
	[NIVEL2] ASC,
	[NIVEL3] ASC,
	[NIVEL4] ASC,
	[NIVEL5] ASC,
	[DATA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NIVEL6_AC_REDE]    Script Date: 30/05/2018 08:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NIVEL6_AC_REDE](
	[NIVEL6] [char](10) NOT NULL,
	[NIVEL1] [char](8) NOT NULL,
	[NIVEL2] [char](2) NOT NULL,
	[NIVEL3] [char](20) NOT NULL,
	[NIVEL4] [char](5) NOT NULL,
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
 CONSTRAINT [PK_NIVEL6_AC_REDE] PRIMARY KEY CLUSTERED 
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
/****** Object:  Table [dbo].[NIVEL7_AC_REDE]    Script Date: 30/05/2018 08:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NIVEL7_AC_REDE](
	[NIVEL7] [char](5) NOT NULL,
	[NIVEL1] [char](8) NOT NULL,
	[NIVEL2] [char](2) NOT NULL,
	[NIVEL3] [char](20) NOT NULL,
	[NIVEL4] [char](5) NOT NULL,
	[NIVEL5] [char](10) NOT NULL,
	[NIVEL6] [varchar](10) NOT NULL,
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
 CONSTRAINT [PK_NIVEL7_AC_REDE] PRIMARY KEY CLUSTERED 
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

GO
/****** Object:  Table [dbo].[TAB_NIVEL1_AC_REDE]    Script Date: 30/05/2018 08:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAB_NIVEL1_AC_REDE](
	[NIVEL1] [char](8) NOT NULL,
	[DESCRICAO] [varchar](100) NULL,
	[MES] [varchar](50) NULL,
	[BIMESTRE] [varchar](50) NULL,
	[TRIMESTRE] [varchar](50) NULL,
	[QUADRIMESTRE] [varchar](50) NULL,
	[SEMESTRE] [varchar](50) NULL,
	[ANO] [varchar](50) NULL,
	[DIAUTIL] [varchar](1) NULL,
 CONSTRAINT [PK_TAB_NIVEL1_AC_REDE] PRIMARY KEY CLUSTERED 
(
	[NIVEL1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TAB_NIVEL2_AC_REDE]    Script Date: 30/05/2018 08:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAB_NIVEL2_AC_REDE](
	[NIVEL2] [char](2) NOT NULL,
	[DESCRICAO] [varchar](50) NULL,
 CONSTRAINT [PK_TAB_NIVEL2_AC_REDE] PRIMARY KEY CLUSTERED 
(
	[NIVEL2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TAB_NIVEL3_AC_REDE]    Script Date: 30/05/2018 08:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAB_NIVEL3_AC_REDE](
	[NIVEL3] [char](20) NOT NULL,
	[DESCRICAO] [varchar](100) NULL,
 CONSTRAINT [PK_TAB_NIVEL3_AC_REDE] PRIMARY KEY CLUSTERED 
(
	[NIVEL3] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TAB_NIVEL4_AC_REDE]    Script Date: 30/05/2018 08:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAB_NIVEL4_AC_REDE](
	[NIVEL4] [char](5) NOT NULL,
	[DESCRICAO] [varchar](100) NULL,
	[GERENTE] [varchar](100) NULL,
 CONSTRAINT [PK_TAB_NIVEL4_AC_REDE] PRIMARY KEY CLUSTERED 
(
	[NIVEL4] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TAB_NIVEL5_AC_REDE]    Script Date: 30/05/2018 08:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAB_NIVEL5_AC_REDE](
	[NIVEL5] [char](10) NOT NULL,
	[DESCRICAO] [varchar](100) NULL,
 CONSTRAINT [PK_TAB_NIVEL5_AC_REDE] PRIMARY KEY CLUSTERED 
(
	[NIVEL5] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TAB_NIVEL6_AC_REDE]    Script Date: 30/05/2018 08:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAB_NIVEL6_AC_REDE](
	[NIVEL6] [varchar](10) NOT NULL,
	[DESCRICAO] [varchar](100) NULL,
 CONSTRAINT [PK_TAB_NIVEL6_AC_REDE] PRIMARY KEY CLUSTERED 
(
	[NIVEL6] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TAB_NIVEL7_AC_REDE]    Script Date: 30/05/2018 08:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAB_NIVEL7_AC_REDE](
	[NIVEL7] [char](5) NOT NULL,
	[DESCRICAO] [varchar](100) NULL,
	[COMPRADOR] [varchar](100) NULL,
 CONSTRAINT [PK_TAB_NIVEL7_AC_REDE] PRIMARY KEY CLUSTERED 
(
	[NIVEL7] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tab_parametros_AC_REDE]    Script Date: 30/05/2018 08:13:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tab_parametros_AC_REDE](
	[empresa] [varchar](50) NULL,
	[nivel1] [varchar](20) NULL,
	[nivel2] [varchar](20) NULL,
	[nivel3] [varchar](20) NULL,
	[nivel4] [varchar](20) NULL,
	[nivel5] [varchar](20) NULL,
	[nivel6] [varchar](20) NULL,
	[nivel7] [varchar](20) NULL,
	[nivel8] [varchar](20) NULL,
	[nivel9] [varchar](20) NULL,
	[nivel10] [varchar](20) NULL,
	[nivel11] [varchar](20) NULL,
	[nivel12] [varchar](20) NULL,
	[nivel13] [varchar](20) NULL,
	[nivel14] [varchar](20) NULL,
	[nivel15] [varchar](20) NULL,
	[atr1] [varchar](20) NULL,
	[atr2] [varchar](20) NULL,
	[atr3] [varchar](20) NULL,
	[atr4] [varchar](20) NULL,
	[atr5] [varchar](20) NULL,
	[atr6] [varchar](20) NULL,
	[atr7] [varchar](20) NULL,
	[atr8] [varchar](20) NULL,
	[atr9] [varchar](20) NULL,
	[atr10] [varchar](20) NULL,
	[atr11] [varchar](20) NULL,
	[atr12] [varchar](20) NULL,
	[atr13] [varchar](20) NULL,
	[atr14] [varchar](20) NULL,
	[atr15] [varchar](20) NULL,
	[atualizadoem] [datetime] NULL
) ON [PRIMARY]

GO

---- REGISTROS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT INTO TAB_INI VALUES
		--(
		--	'CATEGORIA_REDE',
		--	'*NIVEL1_AC_REDE,NIVEL2_AC_REDE,NIVEL3_AC_REDE,NIVEL4_AC_REDE,NIVEL5_AC_REDE,NIVEL6_AC_REDE,NIVEL7_AC_REDE',
		--	'TAB_NIVEL1_AC_REDE,TAB_NIVEL2_AC_REDE,TAB_NIVEL3_AC_REDE,TAB_NIVEL4_AC_REDE,TAB_NIVEL5_AC_REDE,TAB_NIVEL6_AC_REDE,TAB_NIVEL7_AC_REDE',
		--	'TAB_PARAMETROS_AC_REDE,TAB_SENHA,,ULTIMAS,,,CONSULTA,FORMULA',
		--	'NIVEL1,NIVEL2,NIVEL3,NIVEL4,NIVEL5,NIVEL6,NIVEL7,NIVEL8,NIVEL9,NIVEL10,NIVEL11,NIVEL12,NIVEL13,NIVEL14,NIVEL15,DATA,DESCRICAO,,,,,,,,,,ATR1,ATR2,ATR3,ATR4,ATR5,ATR6,ATR7,ATR8,ATR9,ATR10,ATR11,ATR12,ATR13,ATR14,ATR15,',
		--	'08,02,05,10,25,51,10,02,04,06,05'
		--)

INSERT INTO tab_parametros_AC_REDE VALUES
		(
			'CATEGORIA_REDE', 'TEMPO', 'FILIAL','CATEGORIA', 'VENDEDOR', 'FORNECEDOR', 'CLIENTE', 'PRODUTO', NULL,	NULL, NULL,	NULL, NULL,	NULL, NULL,	NULL,
			'QT_VENDA',	'VALOR_VENDA', 'VALOR_TABELA', 'CUSTO_VENDA', 'CUSTO_ATUAL', 'QT_DEV', 'VALOR_DEV',	'CUSTO_DEV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
		)

--SELECT * FROM tab_parametros_AC_REDE
--SELECT * FROM TAB_INI