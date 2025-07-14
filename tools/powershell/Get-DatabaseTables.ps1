# List all tables in Azure SQL Database using MFA
param(
    [Parameter(Mandatory = $false)]
    [string]$ServerName = "cxmidl.database.windows.net",
    
    [Parameter(Mandatory = $false)]
    [string]$DatabaseName = "Orchestration"
)

Write-Host "Listing tables in Azure SQL Database" -ForegroundColor Cyan
Write-Host "Server: $ServerName" -ForegroundColor White
Write-Host "Database: $DatabaseName" -ForegroundColor White
Write-Host "=================================" -ForegroundColor Cyan

try {
    Import-Module SqlServer -Force
    
    # Build connection string for Azure MFA
    $connectionString = "Server=tcp:$ServerName,1433;Initial Catalog=$DatabaseName;Authentication=Active Directory Interactive;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    
    # Query to get all user tables
    $tablesQuery = @"
SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    t.create_date AS CreatedDate,
    t.modify_date AS ModifiedDate,
    p.rows AS RowCount,
    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS DECIMAL(36, 2)) AS TotalSpaceMB,
    CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS DECIMAL(36, 2)) AS UsedSpaceMB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.is_ms_shipped = 0
    AND i.object_id > 255
GROUP BY 
    t.schema_id, 
    t.name, 
    t.create_date, 
    t.modify_date, 
    p.rows
ORDER BY SchemaName, TableName
"@
    
    Write-Host "Retrieving table information..." -ForegroundColor Yellow
    $tables = Invoke-Sqlcmd -ConnectionString $connectionString -Query $tablesQuery -QueryTimeout 30
    
    if ($tables) {
        Write-Host "`n📊 Found $($tables.Count) table(s):" -ForegroundColor Green
        Write-Host ""
        
        # Display tables in a formatted way
        $tables | Format-Table -Property @{
            Label = "Schema"; Expression = { $_.SchemaName }; Width = 10
        }, @{
            Label = "Table Name"; Expression = { $_.TableName }; Width = 30
        }, @{
            Label = "Rows"; Expression = { "{0:N0}" -f $_.RowCount }; Width = 10; Alignment = "Right"
        }, @{
            Label = "Size (MB)"; Expression = { "{0:N2}" -f $_.TotalSpaceMB }; Width = 12; Alignment = "Right"
        }, @{
            Label = "Created"; Expression = { $_.CreatedDate.ToString("yyyy-MM-dd") }; Width = 12
        } -AutoSize
        
        # Show schema summary
        $schemaGroups = $tables | Group-Object SchemaName
        Write-Host "`n📋 Schema Summary:" -ForegroundColor Cyan
        foreach ($schema in $schemaGroups) {
            $totalRows = ($schema.Group | Measure-Object RowCount -Sum).Sum
            $totalSize = ($schema.Group | Measure-Object TotalSpaceMB -Sum).Sum
            Write-Host "  $($schema.Name): $($schema.Count) tables, $($totalRows:N0) total rows, $($totalSize:N2) MB" -ForegroundColor White
        }
        
    }
    else {
        Write-Host "No user tables found in the database." -ForegroundColor Yellow
    }
    
}
catch {
    Write-Host "Error retrieving table information: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Message -like "*authentication*") {
        Write-Host "`nAuthentication Help:" -ForegroundColor Yellow
        Write-Host "1. Run 'Connect-AzAccount' first" -ForegroundColor White
        Write-Host "2. Ensure you have database access permissions" -ForegroundColor White
    }
}
