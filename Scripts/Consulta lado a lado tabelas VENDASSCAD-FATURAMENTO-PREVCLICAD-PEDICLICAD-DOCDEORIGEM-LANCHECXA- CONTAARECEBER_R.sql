----------------------------------------------------------------------------------------------------------------------------------------------------
-- VENDASSCAD + FATURAMENTO + PREVCLICAD + PEDICLICAD + DOCDEORIGEM + LANCHECXA + CONTAARECEBER_R
-- Script para ACOMPANHAR lado a lado o faturamento das tabelas acima
--------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 'VENDASSCAD',v.numord,v.localporta,UPPER(i3.nome) as localportador, v.situacao,v.totven,v.freteorc,v.dtven,v.oiddocdeorigem,count(*) as Repeticoes,
	   'FATURAMENTO',UPPER(i1.nome) as rformadepagar,UPPER(i2.nome) as tipodoc,pr.item,
	   'PREVCLICAD',pr.tipopar,pr.valprev,
	   'PEDICLICAD',p.numped,UPPER(i4.nome) as Cliente,p.codvend,p.valped,p.desconto,p.dtpedido,p.filial,p.sitven,p.sitmanut,p.sitconf,
       'DOCDEORIGEM',do.CODIGO,do.VALORNAMOEDA1,do.RSITUACAO,
       'LANCHECXA',l.numped,l.vallanc,
       'CONTAARECEBER_R',cr.NOME,cr.codigo,cr.VALORNAMOEDA1,cr.CREDITOACUMULADO,cr.RSITUACAO,UPPER(i5.nome)as RSITUACAO ,cr.SITUACAOPREVISAO,cr.oid
FROM	PEDICLICAD p
		LEFT JOIN PREVCLICAD pr ON pr.numped = p.numped
		LEFT JOIN ITEM i1 ON i1.oid = p.rformadepagar
		LEFT JOIN ITEM i2 ON i2.oid = pr.tipodoc
		LEFT JOIN ITEM i4 on i4.oid = p.codclie
		LEFT JOIN VENDASSCAD v ON v.numped = p.numped
		LEFT JOIN ITEM i3 ON i3.oid = v.localporta
		LEFT JOIN DOCDEORIGEM_R do ON do.oid = v.oiddocdeorigem
		LEFT JOIN LANCHECCXA l ON p.numped = l.numped
		LEFT JOIN CONTAARECEBER_R cr ON v.oiddocdeorigem = cr.RDOCDEORIGEM
		LEFT JOIN ITEM i5 on i5.oid = cr.rsituacao

WHERE	p.numped = 1008994
		
GROUP BY /*'VENDASSCAD'*/			v.localporta,UPPER(i3.nome),v.numord,v.situacao,v.freteorc,v.totven,v.dtven,v.oiddocdeorigem,
		 /*'FATURAMENTO'*/			UPPER(i1.nome),UPPER(i2.nome),pr.item,
	     /*'PREVCLICAD'*/			pr.tipopar,pr.valprev,
	     /*'PEDICLICAD'*/			p.numped,UPPER(i4.nome),p.codvend,p.valped,p.desconto,p.dtpedido,p.filial,p.sitven,p.sitmanut,p.sitconf,
         /*'DOCDEORIGEM'*/          do.CODIGO,do.VALORNAMOEDA1,do.RSITUACAO,
         /*'LANCHECXA'*/			l.numped,l.vallanc,
         /*'CONTAARECEBER_R'*/		cr.NOME,cr.codigo,cr.VALORNAMOEDA1,cr.CREDITOACUMULADO,cr.RSITUACAO,UPPER(i5.nome),cr.SITUACAOPREVISAO,cr.oid