SELECT U.NOME AS Usu�rio, TELA.NOME AS Op��o, 
(CASE WHEN P.ACESSO = 1 THEN 'Listar' WHEN P.ACESSO = 0 THEN 'Sem Acesso' 
   WHEN P.ACESSO = 5 THEN 'Ler' WHEN P.ACESSO = 3 THEN 'Adicionar' 
   WHEN P.ACESSO = 7 THEN 'Ler e adicionar' WHEN P.ACESSO = 15 THEN 'Alterar' 
   WHEN P.ACESSO = 31 THEN 'Acesso Total' ELSE '?? ' + CAST(P.ACESSO AS VARCHAR) + ' ??' END) as AcessoItem, 
(CASE WHEN P.ACESSOAOCONTEUDO = 1 THEN 'Listar' WHEN P.ACESSOAOCONTEUDO = 0 THEN 'Sem Acesso' 
   WHEN P.ACESSOAOCONTEUDO = 5 THEN 'Ler' WHEN P.ACESSOAOCONTEUDO = 3 THEN 'Adicionar' 
   WHEN P.ACESSOAOCONTEUDO = 7 THEN 'Ler e adicionar' WHEN P.ACESSOAOCONTEUDO = 15 THEN 'Alterar' 
   WHEN P.ACESSOAOCONTEUDO = 31 THEN 'Acesso Total' ELSE '?? ' + CAST(P.ACESSOAOCONTEUDO AS VARCHAR) + ' ??' END) as AcessoAoConte�do
FROM PERMISSAO P, USUARIO_R U, ITEM_R TELA 
WHERE P.RUSUARIO <> 7 AND P.RUSUARIO = U.OID 
AND P.RESCOPO = TELA.OID AND TELA.OID > 7 AND TELA.CID != 36
UNION ALL
SELECT U.NOME, TELA.NOME + ' ('+ C.NOME + ')' AS Op��o, 
(CASE WHEN P.ACESSO IN (1, 31) THEN 'Permite' WHEN P.ACESSO = 0 THEN 'N�o Permite' 
  ELSE '?? ' + CAST(P.ACESSO AS VARCHAR) + ' ??' END) as permissao, ''
FROM PERMISSAO P, USUARIO_R U, LISTADEOBJETOS_R TELA, ITEM C
WHERE P.RUSUARIO <> 7 AND P.RUSUARIO = U.OID 
AND P.RESCOPO = TELA.OID AND TELA.OID > 7 --AND TELA.OID < 100000
AND TELA.RCATEGORIA = C.OID
ORDER BY 1, 2