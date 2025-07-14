-- Database Structure Exploration Queries
-- File: sql/utilities/explore_database_structure.sql
-- Description: Comprehensive queries to explore database structure and contents

-- =====================================================================================
-- SECTION 1: DATABASE OVERVIEW
-- =====================================================================================

-- Get database basic information
SELECT 
    DB_NAME() AS DatabaseName,
    GETUTCDATE() AS CurrentTime,
    @@VERSION AS SqlServerVersion,
    DATABASEPROPERTYEX(DB_NAME(), 'Status') AS DatabaseStatus,
    DATABASEPROPERTYEX(DB_NAME(), 'Collation') AS DatabaseCollation;

-- =====================================================================================
-- SECTION 2: TABLES AND SCHEMAS
-- =====================================================================================

-- List all user tables with detailed information
SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    t.object_id AS ObjectID,
    t.create_date AS CreatedDate,
    t.modify_date AS ModifiedDate,
    CASE 
        WHEN t.temporal_type = 2 THEN 'System-Versioned Temporal Table'
        WHEN t.temporal_type = 1 THEN 'History Table'
        ELSE 'Regular Table'
    END AS TableType
FROM sys.tables t
WHERE t.is_ms_shipped = 0
ORDER BY SchemaName, TableName;

-- =====================================================================================
-- SECTION 3: TABLE COLUMNS INFORMATION
-- =====================================================================================

-- Get column information for all user tables
SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    c.name AS ColumnName,
    c.column_id AS ColumnOrder,
    TYPE_NAME(c.user_type_id) AS DataType,
    CASE 
        WHEN TYPE_NAME(c.user_type_id) IN ('varchar', 'nvarchar', 'char', 'nchar') 
        THEN TYPE_NAME(c.user_type_id) + '(' + 
             CASE WHEN c.max_length = -1 THEN 'MAX' 
                  WHEN TYPE_NAME(c.user_type_id) IN ('nvarchar', 'nchar') THEN CAST(c.max_length/2 AS VARCHAR(10))
                  ELSE CAST(c.max_length AS VARCHAR(10)) 
             END + ')'
        WHEN TYPE_NAME(c.user_type_id) IN ('decimal', 'numeric')
        THEN TYPE_NAME(c.user_type_id) + '(' + CAST(c.precision AS VARCHAR(10)) + ',' + CAST(c.scale AS VARCHAR(10)) + ')'
        ELSE TYPE_NAME(c.user_type_id)
    END AS FullDataType,
    CASE WHEN c.is_nullable = 1 THEN 'NULL' ELSE 'NOT NULL' END AS Nullable,
    CASE WHEN c.is_identity = 1 THEN 'IDENTITY' ELSE '' END AS IDENTITY,
    ISNULL(dc.definition, '') AS DefaultValue
FROM sys.tables t
INNER JOIN sys.columns c ON t.object_id = c.object_id
LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
WHERE t.is_ms_shipped = 0
ORDER BY SchemaName, TableName, c.column_id;

-- =====================================================================================
-- SECTION 4: INDEXES INFORMATION
-- =====================================================================================

-- List all indexes with their properties
SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    CASE WHEN i.is_unique = 1 THEN 'UNIQUE' ELSE '' END AS UniqueConstraint,
    CASE WHEN i.is_primary_key = 1 THEN 'PRIMARY KEY' ELSE '' END AS PrimaryKey,
    STUFF((
        SELECT ', ' + c.name + CASE WHEN ic.is_descending_key = 1 THEN ' DESC' ELSE ' ASC' END
        FROM sys.index_columns ic
        INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 0
        ORDER BY ic.key_ordinal
        FOR XML PATH('')
    ), 1, 2, '') AS KeyColumns,
    STUFF((
        SELECT ', ' + c.name
        FROM sys.index_columns ic
        INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 1
        ORDER BY ic.key_ordinal
        FOR XML PATH('')
    ), 1, 2, '') AS IncludedColumns
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
WHERE t.is_ms_shipped = 0 AND i.index_id > 0
ORDER BY SchemaName, TableName, i.name;

-- =====================================================================================
-- SECTION 5: CONSTRAINTS INFORMATION
-- =====================================================================================

-- List all constraints
SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    con.name AS ConstraintName,
    con.type_desc AS ConstraintType,
    CASE con.type
        WHEN 'PK' THEN 'Primary Key'
        WHEN 'UQ' THEN 'Unique'
        WHEN 'F' THEN 'Foreign Key'
        WHEN 'C' THEN 'Check'
        WHEN 'D' THEN 'Default'
        ELSE con.type_desc
    END AS ConstraintDescription,
    STUFF((
        SELECT ', ' + c.name
        FROM sys.columns c
        INNER JOIN sys.key_constraints kc ON con.object_id = kc.parent_object_id
        INNER JOIN sys.index_columns ic ON kc.unique_index_id = ic.index_id AND kc.parent_object_id = ic.object_id
        WHERE ic.object_id = t.object_id AND ic.column_id = c.column_id
        FOR XML PATH('')
    ), 1, 2, '') AS ConstraintColumns
FROM sys.tables t
INNER JOIN sys.objects con ON t.object_id = con.parent_object_id
WHERE t.is_ms_shipped = 0 
    AND con.type IN ('PK', 'UQ', 'F', 'C', 'D')
ORDER BY SchemaName, TableName, con.type_desc, con.name;

-- =====================================================================================
-- SECTION 6: FOREIGN KEY RELATIONSHIPS
-- =====================================================================================

-- List all foreign key relationships
SELECT 
    SCHEMA_NAME(tp.schema_id) AS ParentSchema,
    tp.name AS ParentTable,
    cp.name AS ParentColumn,
    fk.name AS ForeignKeyName,
    SCHEMA_NAME(tr.schema_id) AS ReferencedSchema,
    tr.name AS ReferencedTable,
    cr.name AS ReferencedColumn,
    fk.delete_referential_action_desc AS DeleteAction,
    fk.update_referential_action_desc AS UpdateAction
FROM sys.foreign_keys fk
INNER JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
INNER JOIN sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
WHERE tp.is_ms_shipped = 0
ORDER BY ParentSchema, ParentTable, fk.name;

-- =====================================================================================
-- SECTION 7: STORED PROCEDURES AND FUNCTIONS
-- =====================================================================================

-- List all stored procedures and functions
SELECT 
    SCHEMA_NAME(p.schema_id) AS SchemaName,
    p.name AS ObjectName,
    p.type_desc AS ObjectType,
    p.create_date AS CreatedDate,
    p.modify_date AS ModifiedDate,
    CASE 
        WHEN p.type = 'P' THEN 'Stored Procedure'
        WHEN p.type = 'FN' THEN 'Scalar Function'
        WHEN p.type = 'TF' THEN 'Table-Valued Function'
        WHEN p.type = 'IF' THEN 'Inline Table-Valued Function'
        ELSE p.type_desc
    END AS ObjectDescription
FROM sys.objects p
WHERE p.type IN ('P', 'FN', 'TF', 'IF') 
    AND p.is_ms_shipped = 0
ORDER BY SchemaName, ObjectType, p.name;

-- =====================================================================================
-- SECTION 8: TABLE ROW COUNTS AND SIZES
-- =====================================================================================

-- Get row counts and size information for all tables
SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    p.rows AS ROWCOUNT,
    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS DECIMAL(36, 2)) AS TotalSpaceMB,
    CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS DECIMAL(36, 2)) AS UsedSpaceMB,
    CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS DECIMAL(36, 2)) AS UnusedSpaceMB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.is_ms_shipped = 0
    AND i.object_id > 255
GROUP BY 
    t.schema_id, 
    t.name, 
    p.rows
ORDER BY TotalSpaceMB DESC;

-- =====================================================================================
-- SECTION 9: QUICK DATA SAMPLES
-- =====================================================================================

-- This section would contain dynamic SQL to show sample data from each table
-- For security reasons, this is commented out but can be used as needed

/*
-- Example: Get sample data from a specific table
-- SELECT TOP 5 * FROM [schema].[tablename];

-- Example: Get row counts for all tables
DECLARE @sql NVARCHAR(MAX) = '';
SELECT @sql = @sql + 'SELECT ''' + SCHEMA_NAME(schema_id) + '.' + name + ''' AS TableName, COUNT(*) AS RowCount FROM [' + SCHEMA_NAME(schema_id) + '].[' + name + '] UNION ALL ' + CHAR(13)
FROM sys.tables 
WHERE is_ms_shipped = 0;

-- Remove the last UNION ALL
SET @sql = LEFT(@sql, LEN(@sql) - 12);
SET @sql = @sql + ' ORDER BY RowCount DESC';

-- Execute the dynamic SQL
-- EXEC sp_executesql @sql;
*/
