--------------------------------------------------------------------------------------------
-- Ajustar número de parcelas de vendas débito na Conciliação de Cartões.
-- Disponibilizado por email: Fernando Araujo
-- A ferramenta de Conciliação  de Cartões  trata as vendas débito como 1 parcela e não zero
--------------------------------------------------------------------------------------------
Pra resolver.

1. Dê um update mudando todas as parcelas 0 pra 1.
2. Rode esta trigger pra evitar o problema.

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[TRANSACAOCARTAO_NUMPARC] ON [dbo].[TRANSACAOCARTAO] AFTER INSERT AS
BEGIN
    declare @item int, @numparc int
    SELECT @numparc = ISNULL(NUMPARC,0), @item = ITEM FROM INSERTED
    if @numparc = 0 AND @item > 0
        UPDATE TRANSACAOCARTAO SET NUMPARC = 1 WHERE ITEM = @item
    RETURN
END