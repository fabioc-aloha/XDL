-- Azure SQL Database Performance Monitoring Queries
-- File: sql/monitoring/performance_monitoring.sql

-- =====================================================================================
-- Azure SQL Database Performance Monitoring Query Collection
-- Description: Collection of queries to monitor Azure SQL Database performance
-- Author: Azure SQL Development Team
-- Date: 2025-07-14
-- =====================================================================================

-- 1. Current Database Performance Overview
SELECT
    'Database Performance Overview' AS QueryType,
    DB_NAME() AS DatabaseName,
    GETUTCDATE() AS QueryExecutionTime,
    (SELECT
        COUNT(*)
    FROM
        sys.dm_exec_sessions
    WHERE is_user_process = 1) AS ActiveSessions,
    (SELECT
        COUNT(*)
    FROM
        sys.dm_exec_requests) AS ActiveRequests,
    (SELECT
        COUNT(*)
    FROM
        sys.dm_os_waiting_tasks) AS WaitingTasks;

-- 2. Top 10 CPU Consuming Queries (from Query Store)
SELECT
    TOP 10
    'Top CPU Queries' AS QueryType,
    qsq.query_id,
    qsqt.query_sql_text,
    qsrs.avg_cpu_time,
    qsrs.max_cpu_time,
    qsrs.execution_count,
    qsrs.avg_duration,
    qsrs.last_execution_time
FROM
    sys.query_store_query qsq
    INNER JOIN sys.query_store_query_text qsqt ON qsq.query_text_id = qsqt.query_text_id
    INNER JOIN sys.query_store_runtime_stats qsrs ON qsq.query_id = qsrs.query_id
WHERE qsrs.last_execution_time >= DATEADD(hour, -24, GETUTCDATE())
ORDER BY qsrs.avg_cpu_time DESC;

-- 3. Index Usage Statistics
SELECT
    'Index Usage' AS QueryType,
    OBJECT_NAME(ius.object_id) AS TableName,
    i.name AS IndexName,
    ius.user_seeks,
    ius.user_scans,
    ius.user_lookups,
    ius.user_updates,
    ius.last_user_seek,
    ius.last_user_scan,
    ius.last_user_lookup
FROM
    sys.dm_db_index_usage_stats ius
    INNER JOIN sys.indexes i ON ius.object_id = i.object_id AND ius.index_id = i.index_id
WHERE ius.database_id = DB_ID()
    AND OBJECT_NAME(ius.object_id) IS NOT NULL
ORDER BY (ius.user_seeks + ius.user_scans + ius.user_lookups) DESC;

-- 4. Missing Index Suggestions
SELECT
    'Missing Indexes' AS QueryType,
    mid.statement AS TableName,
    mid.equality_columns,
    mid.inequality_columns,
    mid.included_columns,
    migs.avg_total_user_cost,
    migs.avg_user_impact,
    migs.user_seeks,
    migs.user_scans,
    'CREATE NONCLUSTERED INDEX [IX_' + 
    REPLACE(REPLACE(REPLACE(mid.statement, '[', ''), ']', ''), '.', '_') + '_' +
    CAST(NEWID() AS VARCHAR(36)) + '] ON ' + mid.statement + 
    ' (' + ISNULL(mid.equality_columns, '') + 
    CASE WHEN mid.inequality_columns IS NOT NULL AND mid.equality_columns IS NOT NULL 
         THEN ',' ELSE '' END + ISNULL(mid.inequality_columns, '') + ')' +
    CASE WHEN mid.included_columns IS NOT NULL 
         THEN ' INCLUDE (' + mid.included_columns + ')' ELSE '' END AS CreateIndexStatement
FROM
    sys.dm_db_missing_index_details mid
    INNER JOIN sys.dm_db_missing_index_groups mig ON mid.index_handle = mig.index_handle
    INNER JOIN sys.dm_db_missing_index_group_stats migs ON mig.index_group_handle = migs.group_handle
WHERE mid.database_id = DB_ID()
    AND migs.avg_user_impact > 10
ORDER BY migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) DESC;

-- 5. Wait Statistics
SELECT
    TOP 20
    'Wait Statistics' AS QueryType,
    wait_type,
    waiting_tasks_count,
    wait_time_ms,
    max_wait_time_ms,
    signal_wait_time_ms,
    wait_time_ms - signal_wait_time_ms AS resource_wait_time_ms,
    CAST(100.0 * wait_time_ms / SUM(wait_time_ms) OVER() AS DECIMAL(5,2)) AS percentage
FROM
    sys.dm_os_wait_stats
WHERE wait_type NOT IN (
    'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE', 'SLEEP_TASK',
    'SLEEP_SYSTEMTASK', 'SQLTRACE_BUFFER_FLUSH', 'WAITFOR', 'LOGMGR_QUEUE',
    'CHECKPOINT_QUEUE', 'REQUEST_FOR_DEADLOCK_SEARCH', 'XE_TIMER_EVENT',
    'BROKER_TO_FLUSH', 'BROKER_TASK_STOP', 'CLR_MANUAL_EVENT',
    'CLR_AUTO_EVENT', 'DISPATCHER_QUEUE_SEMAPHORE', 'FT_IFTS_SCHEDULER_IDLE_WAIT',
    'XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP'
)
    AND wait_time_ms > 100
ORDER BY wait_time_ms DESC;

-- 6. Database File I/O Statistics
SELECT
    'Database I/O Stats' AS QueryType,
    f.name AS FileName,
    f.physical_name AS FilePath,
    f.type_desc AS FileType,
    ios.num_of_reads,
    ios.num_of_bytes_read,
    ios.io_stall_read_ms,
    ios.num_of_writes,
    ios.num_of_bytes_written,
    ios.io_stall_write_ms,
    ios.io_stall,
    CASE WHEN ios.num_of_reads = 0 THEN 0 
         ELSE ios.io_stall_read_ms / ios.num_of_reads END AS avg_read_stall_ms,
    CASE WHEN ios.num_of_writes = 0 THEN 0 
         ELSE ios.io_stall_write_ms / ios.num_of_writes END AS avg_write_stall_ms
FROM
    sys.dm_io_virtual_file_stats(DB_ID(), NULL) ios
    INNER JOIN sys.database_files f ON ios.file_id = f.file_id
ORDER BY ios.io_stall DESC;

-- 7. Current Blocking Sessions
SELECT
    'Blocking Sessions' AS QueryType,
    blocking.session_id AS BlockingSessionID,
    blocked.session_id AS BlockedSessionID,
    blocked.wait_time AS WaitTimeMS,
    blocked.wait_type,
    blocked.wait_resource,
    blocking_text.text AS BlockingQuery,
    blocked_text.text AS BlockedQuery,
    blocking.login_name AS BlockingUser,
    blocked.login_name AS BlockedUser
FROM
    sys.dm_exec_requests blocked
    INNER JOIN sys.dm_exec_sessions blocking ON blocked.blocking_session_id = blocking.session_id
CROSS APPLY sys.dm_exec_sql_text(blocking.sql_handle) blocking_text
CROSS APPLY sys.dm_exec_sql_text(blocked.sql_handle) blocked_text
WHERE blocked.blocking_session_id <> 0;

-- 8. Database Size and Space Usage
SELECT
    'Database Space Usage' AS QueryType,
    f.name AS FileName,
    f.type_desc AS FileType,
    CAST((f.size * 8.0 / 1024) AS DECIMAL(10,2)) AS FileSizeMB,
    CAST(((f.size - FILEPROPERTY(f.name, 'SpaceUsed')) * 8.0 / 1024) AS DECIMAL(10,2)) AS FreeSpaceMB,
    CAST((FILEPROPERTY(f.name, 'SpaceUsed') * 8.0 / 1024) AS DECIMAL(10,2)) AS UsedSpaceMB,
    CAST((CAST(FILEPROPERTY(f.name, 'SpaceUsed') AS FLOAT) / CAST(f.size AS FLOAT) * 100) AS DECIMAL(5,2)) AS PercentUsed
FROM
    sys.database_files f
ORDER BY f.type, f.name;
