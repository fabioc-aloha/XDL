# Quick Azure SQL MFA Connection Test
# This script tests basic connectivity to Azure SQL Database using MFA authentication

param(
    [Parameter(Mandatory = $false)]
    [string]$ServerName = "cxmidl.database.windows.net",
    
    [Parameter(Mandatory = $false)]
    [string]$DatabaseName = "Orchestration"
)

Write-Host "Azure SQL MFA Connection Test" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan

# Test 1: Check if required modules are available
Write-Host "`nStep 1: Checking PowerShell modules..." -ForegroundColor Yellow

$requiredModules = @('Az.Accounts', 'Az.Sql', 'SqlServer')
$missingModules = @()

foreach ($module in $requiredModules) {
    if (Get-Module -ListAvailable -Name $module) {
        Write-Host "✓ $module is available" -ForegroundColor Green
    }
    else {
        Write-Host "✗ $module is missing" -ForegroundColor Red
        $missingModules += $module
    }
}

if ($missingModules.Count -gt 0) {
    Write-Host "`nMissing modules detected. To install them, run:" -ForegroundColor Yellow
    Write-Host "Install-Module $($missingModules -join ', ') -Force" -ForegroundColor White
    exit 1
}

# Test 2: Check Azure connection
Write-Host "`nStep 2: Checking Azure connection..." -ForegroundColor Yellow

try {
    Import-Module Az.Accounts -Force
    $context = Get-AzContext
    
    if ($context) {
        Write-Host "✓ Already connected to Azure" -ForegroundColor Green
        Write-Host "  Account: $($context.Account.Id)" -ForegroundColor White
        Write-Host "  Subscription: $($context.Subscription.Name)" -ForegroundColor White
    }
    else {
        Write-Host "⚠ Not connected to Azure. Run 'Connect-AzAccount' to sign in with MFA" -ForegroundColor Yellow
        Write-Host "  You can also run: .\Manage-AzureSqlDatabase-MFA.ps1" -ForegroundColor White
        exit 0
    }
}
catch {
    Write-Host "✗ Failed to check Azure connection: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 3: Test SQL connection with MFA
Write-Host "`nStep 3: Testing SQL Database connection..." -ForegroundColor Yellow

try {
    Import-Module SqlServer -Force
    
    # Build connection string for Azure MFA
    $connectionString = "Server=tcp:$ServerName,1433;Initial Catalog=$DatabaseName;Authentication=Active Directory Interactive;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    
    Write-Host "Attempting connection to: $ServerName/$DatabaseName" -ForegroundColor White
    Write-Host "(This may prompt for MFA authentication)" -ForegroundColor Gray
    
    # Simple test query
    $testQuery = "SELECT 
        DB_NAME() AS DatabaseName,
        GETUTCDATE() AS CurrentTime,
        USER_NAME() AS CurrentUser,
        @@VERSION AS SqlVersion"
    
    $result = Invoke-Sqlcmd -ConnectionString $connectionString -Query $testQuery -QueryTimeout 30
    
    if ($result) {
        Write-Host "✓ SQL Database connection successful!" -ForegroundColor Green
        Write-Host "  Database: $($result.DatabaseName)" -ForegroundColor White
        Write-Host "  Connected as: $($result.CurrentUser)" -ForegroundColor White
        Write-Host "  Server time: $($result.CurrentTime)" -ForegroundColor White
        Write-Host "  SQL Server version: $($result.SqlVersion.Split("`n")[0].Trim())" -ForegroundColor White
        
        Write-Host "`n🎉 All tests passed! Your Azure SQL MFA setup is working correctly." -ForegroundColor Green
    }
    
}
catch {
    Write-Host "✗ SQL Database connection failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "`nTroubleshooting checklist:" -ForegroundColor Yellow
    Write-Host "1. Verify you have access to the database with your Azure AD account" -ForegroundColor White
    Write-Host "2. Check if your account is added as an Azure AD admin for the SQL Server" -ForegroundColor White
    Write-Host "3. Ensure firewall rules allow your IP address" -ForegroundColor White
    Write-Host "4. Verify the server name: $ServerName" -ForegroundColor White
    Write-Host "5. Verify the database name: $DatabaseName" -ForegroundColor White
    exit 1
}

Write-Host "`n✨ Azure SQL MFA connection test completed successfully!" -ForegroundColor Cyan
