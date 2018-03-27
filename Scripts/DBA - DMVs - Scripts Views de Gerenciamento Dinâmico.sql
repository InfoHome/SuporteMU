-------------------------------------------------------------------------------------------------------------------------
-- Introdução: Views de gerenciamento dinâmico (DMV) no SQL Server
-------------------------------------------------------------------------------------------------------------------------
	/*
	 * Views de gerenciamento dinâmico (também chamado de DMV) são o conjunto de informações que retratam o comportamento 
	 * do ambiente do banco de dados, mostrando ao DBA informações sobre diversas situações como índices ausentes, espaço 
	 * armazenado pelos objetos, consultas que estão consumindo mais recursos, entre outras informações.
	 */
-------------------------------------------------------------------------------------------------------------------------
-- Script retorna informações sobre o espaço Físico de Disco
---------------------------------------------------------------------------
SELECT 
	database_id, f.file_id, volume_mount_point, total_bytes, available_bytes
FROM sys.database_files AS f
CROSS APPLY sys.dm_os_volume_stats(DB_ID(f.name), f.file_id);



-- Script retorna informações sobre o STATUS sobre os VOLUMES
---------------------------------------------------------------------------
USE [master]
GO
SELECT * FROM sys.dm_os_volume_stats (1, 1);
GO



-- Script retorna informações sobre o espaso utilizado do Log de Transação
---------------------------------------------------------------------------
DBCC SQLPERF(LOGSPACE)



-- Script retorna informações sobre a memória alocada atualmente.
---------------------------------------------------------------------------
SELECT  
	(physical_memory_in_use_kb/1024) AS Memory_usedby_Sqlserver_MB,  
	(locked_page_allocations_kb/1024) AS Locked_pages_used_Sqlserver_MB,  
	(total_virtual_address_space_kb/1024) AS Total_VAS_in_MB,  
	process_physical_memory_low,  
	process_virtual_memory_low  
FROM sys.dm_os_process_memory;  



-- Script Verificar se tem processo obstruído, Deadlock - Erro 1205.
---------------------------------------------------------------------------
select 
	blocking_session_id,* 
from sys.dm_exec_requests 
where  blocking_session_id > 0



-- Script exibe todos os  processos
---------------------------------------------------------------------------
sp_who2  



-- Script termina o  processo indicado
-- 000 é o valor contido no campo SESSION_ID do processo.
---------------------------------------------------------------------------
KILL 000



--  Script para analisar possíveis candidatos a índices
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

  -- Descobrir todos os índices que estão faltando.
  ---------------------------------------------------------------------------
  SELECT  sys.objects.name
, (avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) AS Impact
,  'CREATE NONCLUSTERED INDEX ix_IndexName ON ' + sys.objects.name COLLATE DATABASE_DEFAULT + ' ( ' + IsNull(mid.equality_columns, '') + CASE WHEN mid.inequality_columns IS NULL
                THEN '' 
    ELSE CASE WHEN mid.equality_columns IS NULL
                    THEN '' 
        ELSE ',' END + mid.inequality_columns END + ' ) ' + CASE WHEN mid.included_columns IS NULL
                THEN '' 
    ELSE 'INCLUDE (' + mid.included_columns + ')' END + ';' AS CreateIndexStatement
, mid.equality_columns
, mid.inequality_columns
, mid.included_columns 
    FROM sys.dm_db_missing_index_group_stats AS migs 
            INNER JOIN sys.dm_db_missing_index_groups AS mig ON migs.group_handle = mig.index_group_handle 
            INNER JOIN sys.dm_db_missing_index_details AS mid ON mig.index_handle = mid.index_handle AND mid.database_id = DB_ID() 
            INNER JOIN sys.objects WITH (nolock) ON mid.OBJECT_ID = sys.objects.OBJECT_ID 
    WHERE     (migs.group_handle IN
        ( 
        SELECT     TOP (500) group_handle 
            FROM          sys.dm_db_missing_index_group_stats WITH (nolock) 
            ORDER BY (avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) DESC))  
        AND OBJECTPROPERTY(sys.objects.OBJECT_ID, 'isusertable')=1 
		
		--and sys.objects.name = 'PRODUTOCAD'
    
	ORDER BY 1 desc, 2 DESC 



-- Script para realizar o monitoramento das sessões existentes
---------------------------------------------------------------------------
SELECT 
	login_name , COUNT(session_id) AS [session_count] 
FROM sys.dm_exec_sessions 
GROUP BY login_name 
ORDER BY COUNT(session_id) DESC



-- Script para mostrar o detalhamento das conexões existentes
---------------------------------------------------------------------------
SELECT 
	ec.client_net_address , es.[program_name] , es.[host_name] , es.login_name , COUNT(ec.session_id) AS [connection count] 
FROM sys.dm_exec_sessions AS es 
	INNER JOIN sys.dm_exec_connections AS ec ON es.session_id = ec.session_id 
GROUP BY ec.client_net_address , es.[program_name] , es.[host_name] , es.login_name 
ORDER BY ec.client_net_address



-- Script para monitoramento das consultas em execução
---------------------------------------------------------------------------
SELECT   
	r.session_id , r.[status] , r.wait_type , r.scheduler_id , 
	SUBSTRING(qt.[text], r.statement_start_offset / 2,    
	( CASE  WHEN r.statement_end_offset = -1   THEN LEN(CONVERT(NVARCHAR(MAX), qt.[text])) * 2  ELSE r.statement_end_offset  END - r.statement_start_offset ) / 2)    AS [statement_executing] ,    DB_NAME(qt.[dbid]) AS [DatabaseName] ,  OBJECT_NAME(qt.objectid) AS [ObjectName] , r.cpu_time ,
	r.total_elapsed_time , r.reads , r.writes ,    r.logical_reads , r.plan_handle
FROM sys.dm_exec_requests AS r    CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS qt
WHERE r.session_id > 50  
ORDER BY r.scheduler_id ,r.[status] , r.session_id



-- Script para verificar quais consultas estão com maior tempo de execução
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


-- Script para verificar o armazenamento das tabelas
---------------------------------------------------------------------------
SELECT
    --'TRUNCATE TABLE ' + 
	OBJECT_NAME(object_id) As Tabela, Rows As Linhas,
    SUM(Total_Pages * 8) As Reservado,
    SUM(CASE WHEN Index_ID > 1 THEN 0 ELSE Data_Pages * 8 END) As Dados,
        SUM(Used_Pages * 8) -
        SUM(CASE WHEN Index_ID > 1 THEN 0 ELSE Data_Pages * 8 END) As Indice,
    SUM((Total_Pages - Used_Pages) * 8) As NaoUtilizado
FROM
    sys.partitions As P
    INNER JOIN sys.allocation_units As A ON P.hobt_id = A.container_id
	--AND OBJECT_NAME(object_id) LIKE '%NIVEL%'
GROUP BY OBJECT_NAME(object_id), Rows
ORDER BY TABELA desc
