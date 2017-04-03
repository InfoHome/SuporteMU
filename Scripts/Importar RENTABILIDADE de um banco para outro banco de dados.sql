----------------------------------------------------------------------------------------------------------------------------------------------
-- Script para Importar a RENTABILIDADE de um banco de dados para outro banco de dados
-- No script abaixo onde está BBBBBBBBBBBBB colocar o nome do banco de backup
----------------------------------------------------------------------------------------------------------------------------------------------
-- RENTABIEST
-----------------------------------------------------------------------
Begin transaction
truncate table RentabiEst
insert into RentabiEst select * From BBBBBBBBBBBBB..RentabiEst

-- Conferir antes de dar o Commit, se estiver errado fazer o Rollback
select count(*) From RentabiEst
select count(*) From BBBBBBBBBBBBB..RentabiEst
select max(dataproc) From RentabiEst
select max(dataproc) From BBBBBBBBBBBBB..RentabiEst
--Commit --OK
--Rollback
---------------------------------------------------------------------------------------------
-- RENTABIVENDEDO
-----------------------------------------------------------------------
Begin transaction
truncate table rentabivendedo
insert into rentabivendedo select * From BBBBBBBBBBBBB..rentabivendedo

-- Conferir antes de dar o Commit, se estiver errado fazer o Rollback
select count(*) From rentabivendedo
select count(*) From BBBBBBBBBBBBB..rentabivendedo
select max(dtproc) From rentabivendedo
select max(dtproc) From BBBBBBBBBBBBB..rentabivendedo
--Commit -- ok
--Rollback
---------------------------------------------------------------------------------------------
-- RENTABICONDPAG
-----------------------------------------------------------------------
Begin transaction
truncate table rentabicondpagto
insert into rentabicondpagto select * From BBBBBBBBBBBBB..rentabicondpagto

-- Conferir antes de dar o Commit, se estiver errado fazer o Rollback
select count(*) From rentabicondpagto
select count(*) From BBBBBBBBBBBBB..rentabicondpagto
select max(dataproc) From rentabicondpagto
select max(dataproc) From BBBBBBBBBBBBB..rentabicondpagto

--Commit --OK
--Rollback
---------------------------------------------------------------------------------------------
-- RENTABICLIENTEVENDEDO
-----------------------------------------------------------------------
Begin transaction
truncate table RENTABICLIENTEVENDEDO
insert into RENTABICLIENTEVENDEDO select * From BBBBBBBBBBBBB..RENTABICLIENTEVENDEDO

-- Conferir antes de dar o Commit, se estiver errado fazer o Rollback
select count(*) From RENTABICLIENTEVENDEDO
select count(*) From BBBBBBBBBBBBB..RENTABICLIENTEVENDEDO
select max(dtproc) From RENTABICLIENTEVENDEDO
select max(dtproc) From BBBBBBBBBBBBB..RENTABICLIENTEVENDEDO
--Commit --ok
--Rollback
---------------------------------------------------------------------------------------------
-- RENTABICLIENTE
-----------------------------------------------------------------------
Begin transaction 
truncate table rentabicliente
insert into rentabicliente select * From BBBBBBBBBBBBB..rentabicliente

-- Conferir antes de dar o Commit, se estiver errado fazer o Rollback
select count(*) From rentabicliente
select count(*) From BBBBBBBBBBBBB..rentabicliente
select max(dtproc) From rentabicliente
select max(dtproc) From BBBBBBBBBBBBB..rentabicliente
--Commit -- OK
--Rollback
---------------------------------------------------------------------------------------------
-- RENTABIPRAZOMEDIO
-----------------------------------------------------------------------
Begin transaction
truncate table RentabiPrazoPagto
insert into RentabiPrazoPagto select * From BBBBBBBBBBBBB..RentabiPrazoPagto

-- Conferir antes de dar o Commit, se estiver errado fazer o Rollback
select count(*) From RentabiPrazoPagto
select count(*) From BBBBBBBBBBBBB..RentabiPrazoPagto
select max(dataproc) From RentabiPrazoPagto
select max(dataproc) From BBBBBBBBBBBBB..RentabiPrazoPagto
--Commit -- ok
--Rollback
---------------------------------------------------------------------------------------------
-- RENTABILIDADEITEM
-----------------------------------------------------------------------
Begin transaction
truncate table RentabilidadeItem
insert into RentabilidadeItem select * From BBBBBBBBBBBBB..RentabilidadeItem

-- Conferir antes de dar o Commit, se estiver errado fazer o Rollback
select count(*) From RentabilidadeItem
select count(*) From BBBBBBBBBBBBB..RentabilidadeItem
select max(data) From RentabilidadeItem				--?
select max(data) From BBBBBBBBBBBBB..RentabilidadeItem		--?
--Commit
--Rollback

-----------------------------------------------------------------------------------------------

-- Tem que Alterar a data da rentabilidade

-----------------------------------------------------------------------------------------------

select top 1 * from rentabivendedo order by dtproc desc			--2016-01-30 00:00:00
select top 1 * from rentabicondpagto order by dataproc desc		--2016-01-30 00:00:00.000
select top 1 * from RENTABICLIENTEVENDEDO order by dtproc desc	--2016-01-30 00:00:00.000
select top 1 * from rentabicliente order by dtproc desc			--2016-01-30 00:00:00.000
select top 1 * FROM RentabiPrazoPagto order by dataproc desc	--2016-01-30 00:00:00.000
select top 1 * FROM RentabilidadeItem order by data desc		--2016-08-01 15:04:00.000

select * from ADITIVO_R where RDEFINICAO = '19826'
update ADITIVO_R set svalor = '06/03/2017', DTVALOR = '20170306' where RDEFINICAO = '19826'