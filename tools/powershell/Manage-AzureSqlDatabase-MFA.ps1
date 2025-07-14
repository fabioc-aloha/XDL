# Azure SQL Database Management with Azure MFA Authentication
param(
    [Parameter(Mandatory = $false)]
    [string]$ServerName = "cxmidl.database.windows.net",
    
    [Parameter(Mandatory = $false)]
    [string]$DatabaseName = "Orchestration",
    
    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupName = "CPMQualtricsResourceGroup",
    
    [Parameter(Mandatory = $false)]
    [string]$SubscriptionId = "f6ab5f6d-606a-4256-aba7-1feeeb53784f"
)

Write-Host "Azure SQL Database Management with MFA Authentication" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# Import required modules
try {
    Import-Module Az.Accounts -Force
    Import-Module Az.Sql -Force
    Import-Module SqlServer -Force
    Write-Host "✓ PowerShell modules loaded successfully" -ForegroundColor Green
}
catch {
    Write-Error "Failed to import required modules. Please install: Install-Module Az.Accounts, Az.Sql, SqlServer"
    exit 1
}

# Function to connect to Azure with MFA
function Connect-AzureWithMFA {
    param([string]$SubscriptionId)
    
    Write-Host "Connecting to Azure with MFA..." -ForegroundColor Yellow
    
    try {
        # Check if already connected
        $context = Get-AzContext
        if ($context -and $context.Subscription.Id -eq $SubscriptionId) {
            Write-Host "✓ Already connected to Azure subscription: $($context.Subscription.Name)" -ForegroundColor Green
            return $true
        }
        
        # Connect with interactive authentication (MFA)
        Connect-AzAccount -SubscriptionId $SubscriptionId
        
        $context = Get-AzContext
        if ($context) {
            Write-Host "✓ Successfully connected to Azure" -ForegroundColor Green
            Write-Host "  Subscription: $($context.Subscription.Name)" -ForegroundColor White
            Write-Host "  Account: $($context.Account.Id)" -ForegroundColor White
            Write-Host "  Tenant: $($context.Tenant.Id)" -ForegroundColor White
            return $true
        }
    }
    catch {
        Write-Error "Failed to connect to Azure: $($_.Exception.Message)"
        return $false
    }
}

# Function to get Azure SQL access token for MFA authentication
function Get-AzureSqlAccessToken {
    try {
        $context = Get-AzContext
        if (-not $context) {
            throw "Not connected to Azure. Please run Connect-AzAccount first."
        }
        
        # Get access token for SQL Database
        $token = [Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.AuthenticationFactory.Authenticate($context.Account, $context.Environment, $context.Tenant.Id, $null, "https://database.windows.net/", $null).AccessToken
        return $token
    }
    catch {
        Write-Error "Failed to get Azure SQL access token: $($_.Exception.Message)"
        return $null
    }
}

# Function to execute SQL query with Azure MFA authentication
function Invoke-AzureSqlQueryWithMFA {
    param(
        [string]$ServerName,
        [string]$DatabaseName,
        [string]$Query,
        [string]$AccessToken
    )
    
    try {
        # Build connection string with access token
        $connectionString = "Server=tcp:$ServerName,1433;Initial Catalog=$DatabaseName;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
        
        # Execute query using SqlServer module with access token
        $result = Invoke-Sqlcmd -ConnectionString $connectionString -Query $Query -AccessToken $AccessToken -ErrorAction Stop
        return $result
    }
    catch {
        Write-Error "Failed to execute SQL query: $($_.Exception.Message)"
        return $null
    }
}

# Function to get database performance metrics with MFA
function Get-DatabasePerformanceMetricsWithMFA {
    param([string]$ServerName, [string]$DatabaseName, [string]$ResourceGroupName)
    
    Write-Host "Retrieving performance metrics for $DatabaseName..." -ForegroundColor Green
    
    try {
        # Get Azure SQL database metrics
        $resourceId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Sql/servers/$($ServerName.Split('.')[0])/databases/$DatabaseName"
        $endTime = (Get-Date).ToUniversalTime()
        $startTime = $endTime.AddHours(-1)
        
        $metrics = Get-AzMetric -ResourceId $resourceId -MetricName "cpu_percent", "dtu_consumption_percent", "storage_percent" -StartTime $startTime -EndTime $endTime -TimeGrain 00:05:00
        
        foreach ($metric in $metrics) {
            Write-Host "  $($metric.Name.LocalizedValue):" -ForegroundColor Yellow
            $latestValue = $metric.Data | Sort-Object TimeStamp -Descending | Select-Object -First 1
            if ($latestValue.Average) {
                Write-Host "    Average: $([math]::Round($latestValue.Average, 2))%" -ForegroundColor White
            }
            if ($latestValue.Maximum) {
                Write-Host "    Maximum: $([math]::Round($latestValue.Maximum, 2))%" -ForegroundColor White
            }
        }
        
        return $metrics
    }
    catch {
        Write-Error "Failed to retrieve performance metrics: $($_.Exception.Message)"
        return $null
    }
}

# Function to test database connectivity with MFA
function Test-DatabaseConnectivityWithMFA {
    param([string]$ServerName, [string]$DatabaseName)
    
    Write-Host "Testing database connectivity with MFA..." -ForegroundColor Yellow
    
    try {
        $accessToken = Get-AzureSqlAccessToken
        if (-not $accessToken) {
            throw "Failed to get access token"
        }
        
        $testQuery = "SELECT DB_NAME() AS DatabaseName, GETUTCDATE() AS CurrentTime, @@VERSION AS SqlVersion"
        $result = Invoke-AzureSqlQueryWithMFA -ServerName $ServerName -DatabaseName $DatabaseName -Query $testQuery -AccessToken $accessToken
        
        if ($result) {
            Write-Host "✓ Database connectivity test successful!" -ForegroundColor Green
            Write-Host "  Database: $($result.DatabaseName)" -ForegroundColor White
            Write-Host "  Current Time: $($result.CurrentTime)" -ForegroundColor White
            Write-Host "  SQL Version: $($result.SqlVersion.Split("`n")[0])" -ForegroundColor White
            return $true
        }
    }
    catch {
        Write-Error "Database connectivity test failed: $($_.Exception.Message)"
        return $false
    }
}

# Function to check database security configuration with MFA
function Test-DatabaseSecurityWithMFA {
    param([string]$ServerName, [string]$DatabaseName, [string]$ResourceGroupName)
    
    Write-Host "Checking security configuration for $DatabaseName..." -ForegroundColor Green
    
    try {
        $serverNameShort = $ServerName.Split('.')[0]
        
        # Check audit settings
        $auditPolicy = Get-AzSqlDatabaseAudit -ResourceGroupName $ResourceGroupName -ServerName $serverNameShort -DatabaseName $DatabaseName
        Write-Host "  Audit Status: $($auditPolicy.State)" -ForegroundColor $(if ($auditPolicy.State -eq 'Enabled') { 'Green' } else { 'Yellow' })
        
        # Check threat detection
        try {
            $threatPolicy = Get-AzSqlDatabaseThreatDetectionPolicy -ResourceGroupName $ResourceGroupName -ServerName $serverNameShort -DatabaseName $DatabaseName
            Write-Host "  Threat Detection: $($threatPolicy.ThreatDetectionState)" -ForegroundColor $(if ($threatPolicy.ThreatDetectionState -eq 'Enabled') { 'Green' } else { 'Yellow' })
        }
        catch {
            Write-Host "  Threat Detection: Not configured or not accessible" -ForegroundColor Yellow
        }
        
        # Check transparent data encryption
        $tdeStatus = Get-AzSqlDatabaseTransparentDataEncryption -ResourceGroupName $ResourceGroupName -ServerName $serverNameShort -DatabaseName $DatabaseName
        Write-Host "  Transparent Data Encryption: $($tdeStatus.State)" -ForegroundColor $(if ($tdeStatus.State -eq 'Enabled') { 'Green' } else { 'Yellow' })
        
        return @{
            Audit = $auditPolicy
            TDE   = $tdeStatus
        }
    }
    catch {
        Write-Error "Failed to check security configuration: $($_.Exception.Message)"
        return $null
    }
}

# Main execution
Write-Host "Configuration:" -ForegroundColor White
Write-Host "  Server: $ServerName" -ForegroundColor Gray
Write-Host "  Database: $DatabaseName" -ForegroundColor Gray
Write-Host "  Resource Group: $ResourceGroupName" -ForegroundColor Gray
Write-Host "  Subscription: $SubscriptionId" -ForegroundColor Gray

try {
    # Step 1: Connect to Azure with MFA
    if (-not (Connect-AzureWithMFA -SubscriptionId $SubscriptionId)) {
        throw "Failed to connect to Azure"
    }
    
    # Step 2: Test database connectivity
    if (-not (Test-DatabaseConnectivityWithMFA -ServerName $ServerName -DatabaseName $DatabaseName)) {
        throw "Failed to connect to database"
    }
    
    # Step 3: Get performance metrics
    Write-Host "`nRetrieving performance metrics..." -ForegroundColor Cyan
    $metrics = Get-DatabasePerformanceMetricsWithMFA -ServerName $ServerName -DatabaseName $DatabaseName -ResourceGroupName $ResourceGroupName
    
    # Step 4: Check security configuration
    Write-Host "`nChecking security configuration..." -ForegroundColor Cyan
    $security = Test-DatabaseSecurityWithMFA -ServerName $ServerName -DatabaseName $DatabaseName -ResourceGroupName $ResourceGroupName
    
    Write-Host "`n✓ Azure SQL Database management tasks completed successfully!" -ForegroundColor Green
    
}
catch {
    Write-Error "Error occurred: $($_.Exception.Message)"
    Write-Host "`nTroubleshooting tips:" -ForegroundColor Yellow
    Write-Host "1. Ensure you have proper permissions to the Azure SQL Database" -ForegroundColor White
    Write-Host "2. Verify your account is added as an Azure AD admin for the SQL Server" -ForegroundColor White
    Write-Host "3. Check that firewall rules allow your IP address" -ForegroundColor White
    Write-Host "4. Ensure the database name and server name are correct" -ForegroundColor White
    exit 1
}
