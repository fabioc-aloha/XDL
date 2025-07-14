# Azure SQL Database Management PowerShell Script
param(
    [Parameter(Mandatory = $true)]
    [string]$ServerName,
    
    [Parameter(Mandatory = $true)]
    [string]$DatabaseName,
    
    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupName = 'default-rg',
    
    [Parameter(Mandatory = $false)]
    [string]$SubscriptionId
)

# Import required modules
Import-Module Az.Sql
Import-Module SqlServer
Import-Module dbatools

# Set Azure context if subscription provided
if ($SubscriptionId) {
    Set-AzContext -SubscriptionId $SubscriptionId
}

# Function to get database performance metrics
function Get-DatabasePerformanceMetrics {
    param([string]$ServerName, [string]$DatabaseName, [string]$ResourceGroupName)
    
    Write-Host "Retrieving performance metrics for $DatabaseName..." -ForegroundColor Green
    
    $metrics = Get-AzMetric -ResourceId "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Sql/servers/$ServerName/databases/$DatabaseName" -MetricName "cpu_percent", "dtu_consumption_percent", "storage_percent" -TimeGrain 01:00:00
    
    return $metrics
}

# Function to check database security configuration
function Test-DatabaseSecurity {
    param([string]$ServerName, [string]$DatabaseName, [string]$ResourceGroupName)
    
    Write-Host "Checking security configuration for $DatabaseName..." -ForegroundColor Green
    
    # Check audit settings
    $auditPolicy = Get-AzSqlDatabaseAudit -ResourceGroupName $ResourceGroupName -ServerName $ServerName -DatabaseName $DatabaseName
    
    # Check threat detection
    $threatPolicy = Get-AzSqlDatabaseThreatDetectionPolicy -ResourceGroupName $ResourceGroupName -ServerName $ServerName -DatabaseName $DatabaseName
    
    # Check transparent data encryption
    $tdeStatus = Get-AzSqlDatabaseTransparentDataEncryption -ResourceGroupName $ResourceGroupName -ServerName $ServerName -DatabaseName $DatabaseName
    
    return @{
        Audit           = $auditPolicy
        ThreatDetection = $threatPolicy
        TDE             = $tdeStatus
    }
}

# Function to optimize database performance
function Optimize-DatabasePerformance {
    param([string]$ServerName, [string]$DatabaseName)
    
    Write-Host "Running performance optimization for $DatabaseName..." -ForegroundColor Green
    
    # Update statistics
    Invoke-Sqlcmd -ServerInstance $ServerName -Database $DatabaseName -Query "EXEC sp_updatestats"
    
    # Reorganize indexes with fragmentation > 10%
    $indexQuery = @"
SELECT 
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
INNER JOIN sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE ips.avg_fragmentation_in_percent > 10
    AND i.index_id > 0
"@
    
    $fragmentedIndexes = Invoke-Sqlcmd -ServerInstance $ServerName -Database $DatabaseName -Query $indexQuery
    
    foreach ($index in $fragmentedIndexes) {
        if ($index.avg_fragmentation_in_percent -gt 30) {
            # Rebuild if fragmentation > 30%
            $rebuildQuery = "ALTER INDEX [$($index.IndexName)] ON [$($index.TableName)] REBUILD"
            Invoke-Sqlcmd -ServerInstance $ServerName -Database $DatabaseName -Query $rebuildQuery
            Write-Host "Rebuilt index $($index.IndexName) on $($index.TableName)" -ForegroundColor Yellow
        }
        else {
            # Reorganize if fragmentation 10-30%
            $reorganizeQuery = "ALTER INDEX [$($index.IndexName)] ON [$($index.TableName)] REORGANIZE"
            Invoke-Sqlcmd -ServerInstance $ServerName -Database $DatabaseName -Query $reorganizeQuery
            Write-Host "Reorganized index $($index.IndexName) on $($index.TableName)" -ForegroundColor Yellow
        }
    }
}

# Main execution
Write-Host "Azure SQL Database Management Script" -ForegroundColor Cyan
Write-Host "Server: $ServerName" -ForegroundColor White
Write-Host "Database: $DatabaseName" -ForegroundColor White
Write-Host "Resource Group: $ResourceGroupName" -ForegroundColor White

try {
    # Get performance metrics
    $metrics = Get-DatabasePerformanceMetrics -ServerName $ServerName -DatabaseName $DatabaseName -ResourceGroupName $ResourceGroupName
    
    # Check security
    $security = Test-DatabaseSecurity -ServerName $ServerName -DatabaseName $DatabaseName -ResourceGroupName $ResourceGroupName
    
    # Optimize performance
    Optimize-DatabasePerformance -ServerName $ServerName -DatabaseName $DatabaseName
    
    Write-Host "Database management tasks completed successfully!" -ForegroundColor Green
    
}
catch {
    Write-Error "Error occurred: $($_.Exception.Message)"
    exit 1
}
