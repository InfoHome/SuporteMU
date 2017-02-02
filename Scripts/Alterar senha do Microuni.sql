-------------------------------------------------------------------------------------
-- Alterar senha do Microuni
-------------------------------------------------------------------------------------
-- 1 - Fazer Backup da senha original do cliente:
	select senha from usuario_r where OID = 1 
--Backup: 

-- 2 - Alterar a senha
update usuario_r set senha = 'HSBFRMUEDJ' where oid = 1

-- 3 Retornar a senha original do cliente
update usuario_r set senha = 'Informar a criptografia feita backup' where oid = 1


