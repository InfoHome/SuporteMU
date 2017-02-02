-------------------------------------------------------------------------------------------------------------------------
-- Introdu��o: Views de gerenciamento din�mico (DMV) no SQL Server
-------------------------------------------------------------------------------------------------------------------------
	/*
	 * Views de gerenciamento din�mico (tamb�m chamado de DMV) s�o o conjunto de informa��es que retratam o comportamento 
	 * do ambiente do banco de dados, mostrando ao DBA informa��es sobre diversas situa��es como �ndices ausentes, espa�o 
	 * armazenado pelos objetos, consultas que est�o consumindo mais recursos, entre outras informa��es.
	 */
-------------------------------------------------------------------------------------------------------------------------
-- Script retorna informa��es sobre o espa�o F�sico de Disco
---------------------------------------------------------------------------
SELECT 
	database_id, f.file_id, volume_mount_point, total_bytes, available_bytes
FROM sys.database_files AS f
CROSS APPLY sys.dm_os_volume_stats(DB_ID(f.name), f.file_id);



-- Script retorna informa��es sobre o STATUS sobre os VOLUMES
---------------------------------------------------------------------------
USE [master]
GO
SELECT * FROM sys.dm_os_volume_stats (1, 1);
GO



-- Script retorna informa��es sobre o espaso utilizado do Log de Transa��o
---------------------------------------------------------------------------
DBCC SQLPERF(LOGSPACE)



-- Script retorna informa��es sobre a mem�ria alocada atualmente.
---------------------------------------------------------------------------
SELECT  
	(physical_memory_in_use_kb/1024) AS Memory_usedby_Sqlserver_MB,  
	(locked_page_allocations_kb/1024) AS Locked_pages_used_Sqlserver_MB,  
	(total_virtual_address_space_kb/1024) AS Total_VAS_in_MB,  
	process_physical_memory_low,  
	process_virtual_memory_low  
FROM sys.dm_os_process_memory;  



-- Script Verificar se tem processo obstru�do, Deadlock - Erro 1205.
---------------------------------------------------------------------------
select 
	blocking_session_id,* 
from sys.dm_exec_requests 
where  blocking_session_id > 0



-- Script exibe todos os  processos
---------------------------------------------------------------------------
sp_who2  



-- Script termina o  processo indicado
-- 000 � o valor contido no campo SESSION_ID do processo.
---------------------------------------------------------------------------
KILL 000



--  Script para analisar poss�veis candidatos a �ndices
---------------------------------------------------------------------------
 SELECT 
	  user_seeks * avg_total_user_cost * ( avg_user_impact * 0.01 ) 
	  AS [index_advantage] ,migs.last_user_seek ,
	  mid.[statement] AS [Database.Schema.Table] , mid.equality_columns , 
	  mid.inequality_columns , mid.included_columns , migs.unique_compiles , 
	  migs.user_seeks , migs.avg_total_user_cost , migs.avg_user_impact
 FROM sys.dm_db_missing_index_group_stats AS migs WITH ( NOLOCK ) 
   INNER JOIN sys.dm_db_missing_index_groups AS mig WITH ( NOLOCK ) ON migs.group_handle = mig.index_group_handle 
   INNER JOIN sys.dm_db_missing_index_details AS mid WITH ( NOLOCK ) ON mig.index_handle = mid.index_handle
  WHERE mid.database_id = DB_ID()
  ORDER BY index_advantage DESC



-- Script para realizar o monitoramento das sess�es existentes
---------------------------------------------------------------------------
SELECT 
	login_name , COUNT(session_id) AS [session_count] 
FROM sys.dm_exec_sessions 
GROUP BY login_name 
ORDER BY COUNT(session_id) DESC



-- Script para mostrar o detalhamento das conex�es existentes
---------------------------------------------------------------------------
SELECT 
	ec.client_net_address , es.[program_name] , es.[host_name] , es.login_name , COUNT(ec.session_id) AS [connection count] 
FROM sys.dm_exec_sessions AS es 
	INNER JOIN sys.dm_exec_connections AS ec ON es.session_id = ec.session_id 
GROUP BY ec.client_net_address , es.[program_name] , es.[host_name] , es.login_name 
ORDER BY ec.client_net_address



-- Script para monitoramento das consultas em execu��o
---------------------------------------------------------------------------
SELECT   
	r.session_id , r.[status] , r.wait_type , r.scheduler_id , 
	SUBSTRING(qt.[text], r.statement_start_offset / 2,    
	( CASE  WHEN r.statement_end_offset = -1   THEN LEN(CONVERT(NVARCHAR(MAX), qt.[text])) * 2  ELSE r.statement_end_offset  END - r.statement_start_offset ) / 2)    AS [statement_executing] ,    DB_NAME(qt.[dbid]) AS [DatabaseName] ,  OBJECT_NAME(qt.objectid) AS [ObjectName] , r.cpu_time ,
	r.total_elapsed_time , r.reads , r.writes ,    r.logical_reads , r.plan_handle
FROM sys.dm_exec_requests AS r    CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS qt
WHERE r.session_id > 50  
ORDER BY r.scheduler_id ,r.[status] , r.session_id



-- Script para verificar quais consultas est�o com maior tempo de execu��o
---------------------------------------------------------------------------
SELECT 
	TOP (5) total_worker_time , 
	execution_count ,  total_worker_time / execution_count AS [Avg CPU Time] , 
	CASE  WHEN deqs.statement_start_offset = 0   AND deqs.statement_end_offset = -1     THEN '-- see objectText column--' 
	ELSE '-- query --' + CHAR(13) + CHAR(10) + SUBSTRING(execText.text, deqs.statement_start_offset / 2, 
	(( CASE   WHEN deqs.statement_end_offset = -1 
	THEN DATALENGTH(execText.text)   ELSE deqs.statement_end_offset END ) - deqs.statement_start_offset ) 
	--/ 
	)END AS queryText  FROM sys.dm_exec_query_stats AS deqs 
	CROSS APPLY sys.dm_exec_sql_text(deqs.plan_handle) AS execText
ORDER BY deqs.total_worker_time DESC ;



-- Script para verificar o status de armazenamento das tabelas
---------------------------------------------------------------------------
SELECT 
	OBJECT_NAME(ps.[object_id]) AS [TableName] , i.name AS [IndexName] , 
	SUM(ps.row_count) AS [RowCount]
FROM sys.dm_db_partition_stats AS ps 
	INNER JOIN sys.indexes AS i  ON i.[object_id] = ps.[object_id] AND i.index_id = ps.index_id
WHERE i.type_desc IN ( 'CLUSTERED', 'HEAP' ) AND i.[object_id] > 100 
	AND OBJECT_SCHEMA_NAME(ps.[object_id]) <> 'sys'
GROUP BY ps.[object_id] , i.name
ORDER BY SUM(ps.row_count) DESC
