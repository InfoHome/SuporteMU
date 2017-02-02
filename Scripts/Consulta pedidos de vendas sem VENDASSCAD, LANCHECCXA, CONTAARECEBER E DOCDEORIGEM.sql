---------------------------------------------------------------------------------------------------
-- Script para levantar pedidos de vendas sem VENDASSCAD, LANCHECCXA, CONTAARECEBER E DOCDEORIGEM
---------------------------------------------------------------------------------------------------
select		'PEDICLICAD',	pe.numped,pe.sitven,pe.filial,pe.valped,pe.sitmanut,pe.dtpedido,pe.tpo,
			'FORMADEPAGAR', fp.nome,
			'VENDASSCAD',	ve.numped,ve.situacao,ve.dtven,
			'NFSAIDACAD',	left(ns.numnota,6)+'/'+ns.serie,ns.dtemis,ns.lif,ns.dtcancel,
			--'DOCDEORIGEM',	do.oid,do.valornamoeda1,
			--'LANCHECCXA',	lc.numped,lc.vallanc,
			--'CONTAARECEBER',	cr.oid,cr.valornamoeda1,cr.situacaoprevisao,
			CASE do.oid		WHEN ISNULL(do.OID,NULL) 
							THEN 'GEROU DOCDEORIGEM' ELSE 'NAO GEROU DOCDEORIGEM' END,
			CASE lc.NUMPED  WHEN ISNULL(lc.numped,NULL) 
							THEN 'GEROU LANCHECCXA'	ELSE 'NAO GEROU LANCHECCXA'	END,
			CASE cr.oid		WHEN ISNULL(cr.OID,NULL) 
							THEN 'GEROU CONTAS A RECEBER'	ELSE 'NAO GEROU CONTAS A RECEBER' END
from pediclicad pe
	left join VENDASSCAD ve on pe.numped = ve.numped
	left join FORMADEPAGAR_R fp on pe.rformadepagar = fp.oid
	left join NFSAIDACAD ns on ns.numped = pe.numped 
	left join DOCDEORIGEM_R do on do.oid = ve.oiddocdeorigem
	left join LANCHECCXA lc on lc.numped = ve.numped
	left join CONTAARECEBER_R cr on cr.oid = ve.oiddocdeorigem
where pe.sitven = '2'
	  and pe.tpo like '2%'
	 -- and ISNULL(ve.NUMPED,7)<=7 
	  and ISNULL(cr.OID,7) <= 7 
			and ISNULL(lc.NUMPED,7) < = 7
	  --and ISNULL(do.OID,7) <= 7 */
group by	/*'PEDICLICAD'*/	pe.numped,pe.sitven,pe.filial,pe.valped,pe.sitmanut,pe.dtpedido,pe.tpo,
			/*'FORMADEPAGAR'*/  fp.nome,
			/*'VENDASSCAD'*/	ve.numped,ve.situacao,ve.dtven,
			/*'NFSAIDACAD'*/	ns.numnota,ns.serie,ns.dtemis,ns.lif,ns.dtcancel,
			/*'DOCDEORIGEM'*/	do.oid,do.valornamoeda1,
			/*'LANCHECCXA'*/	lc.numped,lc.vallanc,
			/*'CONTAARECEBER'*/	cr.oid,cr.valornamoeda1,cr.situacaoprevisao
