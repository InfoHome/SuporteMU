---	Vicente Neto - 27/05/2016 - Ficha 310176
--- DROP TRIGGER Validar_Exclusao_VendasSCAD
CREATE TRIGGER Validar_Exclusao_VendasSCAD ON VendasSCAD FOR DELETE AS
BEGIN
	DECLARE @Pedido INT
	
	SELECT @Pedido = D.NumPed
	FROM Deleted D
	WHERE D.NumPed > 7 AND 
		(D.NumPed IN (SELECT NumPed FROM PediCliCad P WHERE D.NumPed = P.NumPed AND P.SitVen = '2')
		OR NumOrd IN (SELECT NORDVEN FROM NFSaidaCad N WHERE D.NumOrd = N.NORDVEN AND N.Atualiz = 1))
	
	IF COALESCE(@Pedido, 0) > 7
	BEGIN
		RAISERROR ('

A T E N Ç Ã O !
PRESSIONE OK e continue com processo.
E por favor, avise a MicroUniverso e envie arquivos de Log e Ocor.
VendasSCAD excluída indevidamente. Referência atendimento 310176.', 11, 0);
			RETURN
	END
END;