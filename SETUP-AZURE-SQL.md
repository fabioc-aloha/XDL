# Azure SQL Development and Administration Cognitive Architecture Auto-Setup Guide

**INSTRUCTIONS FOR GITHUB COPILOT**: This file contains complete setup instructions for implementing the Self-Learning Vibe Coding cognitive memory architecture optimized for Azure SQL database development, administration, and management. Follow these instructions to create all necessary directories, files, and configurations.

## 🗄️ Azure SQL Development & Administration Automated Setup Protocol

**Execute these steps in order to establish a complete cognitive architecture system for Azure SQL database development and administration:**

### Step 1: VS Code Configuration (Required)

Add these settings to VS Code `settings.json`:

```json
{
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "chat.promptFiles": true,
  "chat.instructionsFilesLocations": [".github/instructions"],
  "mssql.connections": [
    {
      "connectionString": "",
      "database": "",
      "server": "",
      "user": "",
      "authenticationType": "AzureMFA",
      "azureAccountToken": "",
      "tenant": "",
      "clientId": "",
      "savePassword": false,
      "profileName": "Azure SQL Development"
    }
  ],
  "mssql.enableConnectionPooling": true,
  "mssql.maxPoolSize": 15,
  "mssql.enableIntelliSense": true,
  "mssql.intelliSense.enableIntelliSense": true,
  "mssql.intelliSense.enableErrorChecking": true,
  "mssql.intelliSense.enableSuggestions": true,
  "mssql.intelliSense.enableQuickInfo": true,
  "mssql.format.alignColumnDefinitionsInColumns": true,
  "mssql.format.datatypeCasing": "uppercase",
  "mssql.format.keywordCasing": "uppercase",
  "mssql.format.placeCommasBeforeNextStatement": false,
  "mssql.format.placeSelectStatementReferencesOnNewLine": true,
  "files.associations": {
    "*.sql": "sql",
    "*.ddl": "sql",
    "*.dml": "sql",
    "*.tsql": "sql",
    "*.proc": "sql",
    "*.view": "sql",
    "*.func": "sql",
    "*.trig": "sql",
    "*.dacpac": "binary",
    "*.bacpac": "binary"
  },
  "sql.connections": [
    {
      "server": "your-azure-sql-server.database.windows.net",
      "database": "your-database",
      "authenticationType": "AzureMFA",
      "user": "",
      "password": "",
      "port": 1433,
      "encrypt": true,
      "trustServerCertificate": false,
      "hostNameInCertificate": "",
      "connectTimeout": 30,
      "commandTimeout": 30
    }
  ],
  "azureResourceGroups.showExplorer": true,
  "azure.showSignedInEmail": true,
  "powershell.integratedConsole.showOnStartup": false,
  "terminal.integrated.defaultProfile.windows": "PowerShell"
}
```

**Access settings.json**: `Ctrl+Shift+P` → "Preferences: Open User Settings (JSON)"

### Step 2: Create Directory Structure

Create this exact folder structure in the project root:

```
project-root/
├── .github/
│   ├── copilot-instructions.md          # Global Declarative Memory
│   ├── instructions/                    # Procedural Memory Store
│   │   ├── azure-sql.instructions.md
│   │   ├── database-development.instructions.md
│   │   ├── performance-tuning.instructions.md
│   │   ├── security-management.instructions.md
│   │   ├── backup-recovery.instructions.md
│   │   ├── monitoring-alerts.instructions.md
│   │   ├── migration-deployment.instructions.md
│   │   ├── troubleshooting.instructions.md
│   │   ├── documentation.instructions.md
│   │   ├── learning.instructions.md     # Meta-Cognitive Learning
│   │   └── meta-cognition.instructions.md  # Self-Monitoring
│   └── prompts/                         # Episodic Memory Store
│       ├── database-design.prompt.md
│       ├── query-optimization.prompt.md
│       ├── stored-procedure-development.prompt.md
│       ├── index-strategy.prompt.md
│       ├── security-audit.prompt.md
│       ├── performance-analysis.prompt.md
│       ├── backup-strategy.prompt.md
│       ├── disaster-recovery.prompt.md
│       ├── capacity-planning.prompt.md
│       ├── migration-assessment.prompt.md
│       ├── compliance-review.prompt.md
│       ├── automation-scripting.prompt.md
│       ├── consolidation.prompt.md
│       ├── self-assessment.prompt.md    # Meta-Cognitive Assessment
│       ├── meta-learning.prompt.md      # Learning Strategy Evolution
│       └── cognitive-health.prompt.md   # Architecture Maintenance
├── sql/                                 # SQL Scripts
│   ├── schemas/                         # Database Schemas
│   ├── tables/                          # Table Definitions
│   ├── views/                           # View Definitions
│   ├── procedures/                      # Stored Procedures
│   ├── functions/                       # User-Defined Functions
│   ├── triggers/                        # Database Triggers
│   ├── indexes/                         # Index Scripts
│   ├── constraints/                     # Constraint Definitions
│   ├── security/                        # Security Scripts
│   ├── maintenance/                     # Maintenance Scripts
│   ├── monitoring/                      # Monitoring Queries
│   ├── migration/                       # Migration Scripts
│   └── utilities/                       # Utility Scripts
├── deployment/
│   ├── dacpac/                         # Data-tier Applications
│   ├── scripts/                        # Deployment Scripts
│   ├── rollback/                       # Rollback Scripts
│   └── environments/                   # Environment Configs
├── documentation/
│   ├── database-design/                # Design Documentation
│   ├── procedures/                     # Procedure Documentation
│   ├── security/                       # Security Documentation
│   └── operations/                     # Operations Runbooks
├── tools/
│   ├── powershell/                     # PowerShell Scripts
│   ├── azure-cli/                      # Azure CLI Scripts
│   ├── monitoring/                     # Monitoring Tools
│   └── automation/                     # Automation Scripts
├── tests/
│   ├── unit/                          # Unit Tests
│   ├── integration/                   # Integration Tests
│   └── performance/                   # Performance Tests
├── config/
│   ├── connections/                   # Connection Configs
│   ├── environments/                  # Environment Settings
│   └── security/                      # Security Configs
├── .env                               # Environment Variables
├── .gitignore                        # Git Ignore
└── azure-sql-config.json            # Azure SQL Configuration
```

### Step 3: Azure SQL Development Environment Setup

**Install required tools and configure Azure SQL connectivity:**

```powershell
# Install Azure CLI (if not already installed)
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Azure CLI..." -ForegroundColor Green
    Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
    Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
    Remove-Item .\AzureCLI.msi
}

# Install SQL Server PowerShell module
Write-Host "Installing SQL Server PowerShell modules..." -ForegroundColor Green
Install-Module -Name SqlServer -Force -SkipPublisherCheck
Install-Module -Name Az.Sql -Force -SkipPublisherCheck
Install-Module -Name Az.Accounts -Force -SkipPublisherCheck
Install-Module -Name dbatools -Force -SkipPublisherCheck

# Create project directories
Write-Host "Creating directory structure..." -ForegroundColor Green
$directories = @(
    "sql/schemas", "sql/tables", "sql/views", "sql/procedures", "sql/functions",
    "sql/triggers", "sql/indexes", "sql/constraints", "sql/security", "sql/maintenance",
    "sql/monitoring", "sql/migration", "sql/utilities",
    "deployment/dacpac", "deployment/scripts", "deployment/rollback", "deployment/environments",
    "documentation/database-design", "documentation/procedures", "documentation/security", "documentation/operations",
    "tools/powershell", "tools/azure-cli", "tools/monitoring", "tools/automation",
    "tests/unit", "tests/integration", "tests/performance",
    "config/connections", "config/environments", "config/security"
)

foreach ($dir in $directories) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

# Create Azure SQL configuration file
@"
{
  "azureSqlConfig": {
    "subscriptionId": "your-subscription-id",
    "resourceGroupName": "your-resource-group",
    "serverName": "your-azure-sql-server",
    "administratorLogin": "your-admin-username",
    "databases": [
      {
        "name": "development",
        "edition": "Standard",
        "serviceObjective": "S2",
        "maxSizeBytes": "268435456000"
      },
      {
        "name": "staging", 
        "edition": "Standard",
        "serviceObjective": "S2",
        "maxSizeBytes": "268435456000"
      },
      {
        "name": "production",
        "edition": "Premium",
        "serviceObjective": "P2", 
        "maxSizeBytes": "536870912000"
      }
    ],
    "firewallRules": [
      {
        "name": "AllowAzureIPs",
        "startIpAddress": "0.0.0.0",
        "endIpAddress": "0.0.0.0"
      }
    ],
    "security": {
      "enableAudit": true,
      "enableThreatDetection": true,
      "enableTransparentDataEncryption": true,
      "enableAdvancedDataSecurity": true
    },
    "backup": {
      "retentionPeriod": 35,
      "enableLongTermRetention": true,
      "geoRedundantBackup": true
    },
    "monitoring": {
      "enableMetrics": true,
      "enableDiagnostics": true,
      "logAnalyticsWorkspace": "your-log-analytics-workspace"
    }
  },
  "connectionStrings": {
    "development": "Server=tcp:your-server.database.windows.net,1433;Initial Catalog=development;Persist Security Info=False;User ID=your-username;Password={your_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;",
    "staging": "Server=tcp:your-server.database.windows.net,1433;Initial Catalog=staging;Persist Security Info=False;User ID=your-username;Password={your_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;",
    "production": "Server=tcp:your-server.database.windows.net,1433;Initial Catalog=production;Persist Security Info=False;User ID=your-username;Password={your_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  },
  "tools": {
    "sqlcmd": "sqlcmd",
    "bcp": "bcp", 
    "sqlpackage": "sqlpackage",
    "dacfx": "Microsoft.SqlServer.Dac",
    "powerShell": "pwsh",
    "azureCli": "az"
  }
}
"@ | Out-File -FilePath "azure-sql-config.json" -Encoding utf8

# Create environment configuration
@"
# Azure SQL Environment Variables
AZURE_SUBSCRIPTION_ID=your-subscription-id
AZURE_RESOURCE_GROUP=your-resource-group
AZURE_SQL_SERVER=your-azure-sql-server.database.windows.net
AZURE_SQL_DATABASE=your-database
AZURE_SQL_USERNAME=your-username
AZURE_SQL_PASSWORD=your-password

# Connection Settings
SQL_CONNECTION_TIMEOUT=30
SQL_COMMAND_TIMEOUT=30
SQL_ENCRYPT=True
SQL_TRUST_SERVER_CERTIFICATE=False

# Development Settings
ENVIRONMENT=development
DEBUG_MODE=True
ENABLE_QUERY_LOGGING=True
ENABLE_PERFORMANCE_MONITORING=True

# Security Settings
ENABLE_AUDIT_LOGGING=True
ENABLE_THREAT_DETECTION=True
ENABLE_DATA_CLASSIFICATION=True
ENABLE_VULNERABILITY_ASSESSMENT=True

# Backup and Recovery
BACKUP_RETENTION_DAYS=35
ENABLE_GEO_REDUNDANT_BACKUP=True
ENABLE_LONG_TERM_RETENTION=True

# Monitoring and Alerting
ENABLE_METRICS_COLLECTION=True
ENABLE_DIAGNOSTIC_LOGGING=True
LOG_ANALYTICS_WORKSPACE=your-log-analytics-workspace
ALERT_EMAIL=your-email@company.com
"@ | Out-File -FilePath ".env" -Encoding utf8

# Create comprehensive .gitignore
@"
# Sensitive Configuration
.env
.env.local
.env.*.local
*.secret
*.key
*.pfx
*.p12
connection-strings.json
secrets.json

# Azure Credentials
.azure/
azure-credentials.json
service-principal.json

# SQL Server Files
*.mdf
*.ldf
*.ndf
*.bak
*.trn
*.dmp

# DACPAC/BACPAC Files (except templates)
*.dacpac
*.bacpac
!templates/*.dacpac
!templates/*.bacpac

# PowerShell
profile.ps1
Microsoft.PowerShell_profile.ps1

# Visual Studio
.vs/
*.user
*.suo
*.cache
bin/
obj/
packages/

# SQL Server Management Studio
*.ssms_suo
*.sqlsuo
SqlSchemaCompare*.scmp

# Temporary Files
*.tmp
*.temp
*.log
*.tlog
*.cache
*~

# OS Files
.DS_Store
Thumbs.db
desktop.ini

# IDE Files
.vscode/settings.json
.idea/
*.swp
*.swo

# Test Results
TestResults/
coverage.xml
*.coverage
*.coveragexml

# Documentation Build
docs/_build/
site/
"@ | Out-File -FilePath ".gitignore" -Encoding utf8

# Create sample PowerShell scripts
@"
# Azure SQL Database Management PowerShell Script
param(
    [Parameter(Mandatory=`$true)]
    [string]`$ServerName,
    
    [Parameter(Mandatory=`$true)]
    [string]`$DatabaseName,
    
    [Parameter(Mandatory=`$false)]
    [string]`$ResourceGroupName = 'default-rg',
    
    [Parameter(Mandatory=`$false)]
    [string]`$SubscriptionId
)

# Import required modules
Import-Module Az.Sql
Import-Module SqlServer
Import-Module dbatools

# Set Azure context if subscription provided
if (`$SubscriptionId) {
    Set-AzContext -SubscriptionId `$SubscriptionId
}

# Function to get database performance metrics
function Get-DatabasePerformanceMetrics {
    param([string]`$ServerName, [string]`$DatabaseName, [string]`$ResourceGroupName)
    
    Write-Host "Retrieving performance metrics for `$DatabaseName..." -ForegroundColor Green
    
    `$metrics = Get-AzMetric -ResourceId "/subscriptions/`$SubscriptionId/resourceGroups/`$ResourceGroupName/providers/Microsoft.Sql/servers/`$ServerName/databases/`$DatabaseName" -MetricName "cpu_percent","dtu_consumption_percent","storage_percent" -TimeGrain 01:00:00
    
    return `$metrics
}

# Function to check database security configuration
function Test-DatabaseSecurity {
    param([string]`$ServerName, [string]`$DatabaseName, [string]`$ResourceGroupName)
    
    Write-Host "Checking security configuration for `$DatabaseName..." -ForegroundColor Green
    
    # Check audit settings
    `$auditPolicy = Get-AzSqlDatabaseAudit -ResourceGroupName `$ResourceGroupName -ServerName `$ServerName -DatabaseName `$DatabaseName
    
    # Check threat detection
    `$threatPolicy = Get-AzSqlDatabaseThreatDetectionPolicy -ResourceGroupName `$ResourceGroupName -ServerName `$ServerName -DatabaseName `$DatabaseName
    
    # Check transparent data encryption
    `$tdeStatus = Get-AzSqlDatabaseTransparentDataEncryption -ResourceGroupName `$ResourceGroupName -ServerName `$ServerName -DatabaseName `$DatabaseName
    
    return @{
        Audit = `$auditPolicy
        ThreatDetection = `$threatPolicy
        TDE = `$tdeStatus
    }
}

# Function to optimize database performance
function Optimize-DatabasePerformance {
    param([string]`$ServerName, [string]`$DatabaseName)
    
    Write-Host "Running performance optimization for `$DatabaseName..." -ForegroundColor Green
    
    # Update statistics
    Invoke-Sqlcmd -ServerInstance `$ServerName -Database `$DatabaseName -Query "EXEC sp_updatestats"
    
    # Reorganize indexes with fragmentation > 10%
    `$indexQuery = @"
SELECT 
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
INNER JOIN sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE ips.avg_fragmentation_in_percent > 10
    AND i.index_id > 0
"@
    
    `$fragmentedIndexes = Invoke-Sqlcmd -ServerInstance `$ServerName -Database `$DatabaseName -Query `$indexQuery
    
    foreach (`$index in `$fragmentedIndexes) {
        if (`$index.avg_fragmentation_in_percent -gt 30) {
            # Rebuild if fragmentation > 30%
            `$rebuildQuery = "ALTER INDEX [`$(`$index.IndexName)] ON [`$(`$index.TableName)] REBUILD"
            Invoke-Sqlcmd -ServerInstance `$ServerName -Database `$DatabaseName -Query `$rebuildQuery
            Write-Host "Rebuilt index `$(`$index.IndexName) on `$(`$index.TableName)" -ForegroundColor Yellow
        } else {
            # Reorganize if fragmentation 10-30%
            `$reorganizeQuery = "ALTER INDEX [`$(`$index.IndexName)] ON [`$(`$index.TableName)] REORGANIZE"
            Invoke-Sqlcmd -ServerInstance `$ServerName -Database `$DatabaseName -Query `$reorganizeQuery
            Write-Host "Reorganized index `$(`$index.IndexName) on `$(`$index.TableName)" -ForegroundColor Yellow
        }
    }
}

# Main execution
Write-Host "Azure SQL Database Management Script" -ForegroundColor Cyan
Write-Host "Server: `$ServerName" -ForegroundColor White
Write-Host "Database: `$DatabaseName" -ForegroundColor White
Write-Host "Resource Group: `$ResourceGroupName" -ForegroundColor White

try {
    # Get performance metrics
    `$metrics = Get-DatabasePerformanceMetrics -ServerName `$ServerName -DatabaseName `$DatabaseName -ResourceGroupName `$ResourceGroupName
    
    # Check security
    `$security = Test-DatabaseSecurity -ServerName `$ServerName -DatabaseName `$DatabaseName -ResourceGroupName `$ResourceGroupName
    
    # Optimize performance
    Optimize-DatabasePerformance -ServerName `$ServerName -DatabaseName `$DatabaseName
    
    Write-Host "Database management tasks completed successfully!" -ForegroundColor Green
    
} catch {
    Write-Error "Error occurred: `$(`$_.Exception.Message)"
    exit 1
}
"@ | Out-File -FilePath "tools/powershell/Manage-AzureSqlDatabase.ps1" -Encoding utf8

# Create Azure CLI script
@"
#!/bin/bash
# Azure SQL Database Management with Azure CLI

# Set variables
SUBSCRIPTION_ID="your-subscription-id"
RESOURCE_GROUP="your-resource-group"
SERVER_NAME="your-azure-sql-server"
DATABASE_NAME="your-database"
ADMIN_USER="your-admin-username"

# Function to check database status
check_database_status() {
    echo "Checking database status..."
    az sql db show \
        --resource-group `$RESOURCE_GROUP \
        --server `$SERVER_NAME \
        --name `$DATABASE_NAME \
        --query "{Name:name,Status:status,Edition:edition,ServiceObjective:currentServiceObjectiveName,MaxSize:maxSizeBytes}" \
        --output table
}

# Function to get database metrics
get_database_metrics() {
    echo "Getting database metrics..."
    az monitor metrics list \
        --resource "/subscriptions/`$SUBSCRIPTION_ID/resourceGroups/`$RESOURCE_GROUP/providers/Microsoft.Sql/servers/`$SERVER_NAME/databases/`$DATABASE_NAME" \
        --metric "cpu_percent" "dtu_consumption_percent" "storage_percent" \
        --interval PT1H \
        --query "value[].{Metric:name.localizedValue,Average:average,Maximum:maximum}" \
        --output table
}

# Function to configure security
configure_security() {
    echo "Configuring database security..."
    
    # Enable audit
    az sql db audit-policy update \
        --resource-group `$RESOURCE_GROUP \
        --server `$SERVER_NAME \
        --name `$DATABASE_NAME \
        --state Enabled \
        --storage-account-access-key "`$STORAGE_ACCESS_KEY" \
        --storage-endpoint "`$STORAGE_ENDPOINT"
    
    # Enable threat detection
    az sql db threat-policy update \
        --resource-group `$RESOURCE_GROUP \
        --server `$SERVER_NAME \
        --name `$DATABASE_NAME \
        --state Enabled \
        --email-addresses "admin@company.com" \
        --email-account-admins Enabled
    
    # Enable transparent data encryption
    az sql db tde set \
        --resource-group `$RESOURCE_GROUP \
        --server `$SERVER_NAME \
        --database `$DATABASE_NAME \
        --status Enabled
}

# Function to backup database
backup_database() {
    echo "Creating database backup..."
    az sql db export \
        --resource-group `$RESOURCE_GROUP \
        --server `$SERVER_NAME \
        --name `$DATABASE_NAME \
        --storage-key "`$STORAGE_ACCESS_KEY" \
        --storage-key-type StorageAccessKey \
        --storage-uri "`$STORAGE_URI/backup-`$(date +%Y%m%d).bacpac" \
        --admin-user `$ADMIN_USER \
        --admin-password "`$ADMIN_PASSWORD"
}

# Main execution
echo "Azure SQL Database Management Script"
echo "Subscription: `$SUBSCRIPTION_ID"
echo "Resource Group: `$RESOURCE_GROUP"
echo "Server: `$SERVER_NAME"
echo "Database: `$DATABASE_NAME"

# Set Azure subscription
az account set --subscription `$SUBSCRIPTION_ID

# Execute functions
check_database_status
get_database_metrics
configure_security

echo "Database management completed successfully!"
"@ | Out-File -FilePath "tools/azure-cli/manage-azure-sql.sh" -Encoding utf8

Write-Host "Azure SQL development environment setup complete!" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Update azure-sql-config.json with your Azure SQL details" -ForegroundColor White
Write-Host "2. Update .env file with your connection information" -ForegroundColor White
Write-Host "3. Run 'az login' to authenticate with Azure" -ForegroundColor White
Write-Host "4. Test connection using VS Code SQL Server extension" -ForegroundColor White
```

### Step 4: Global Azure SQL Declarative Memory Setup

**Create `.github/copilot-instructions.md`** with this exact content:

```markdown
# Self-Learning Vibe Coding - Azure SQL Development & Administration Cognitive Memory Architecture

IMPORTANT: This file serves as Global Azure SQL Declarative Memory. Keep minimal and efficient. Detailed execution resides in specialized memory files.

## 🧠 Azure SQL Cognitive Architecture Status

**Working Memory**: 4/4 rules (at optimal capacity for Azure SQL development and administration)
**Consolidation**: Auto-trigger when exceeding capacity
**Memory Distribution**: Active across Azure SQL procedural (.instructions.md) and database episodic (.prompt.md) systems

## 🚀 Azure SQL Working Memory - Quick Reference (Limit: 4 Critical Rules)

| Priority | Rule | Load | Auto-Consolidate |
|----------|------|------|------------------|
| P1 | `@security` - Implement comprehensive security measures including authentication, authorization, encryption, and auditing | High | Never |
| P2 | `@performance` - Optimize database performance through proper indexing, query optimization, and resource management | Medium | >30 days unused |
| P3 | `@meditation` - Auto-consolidate when working memory capacity exceeded | High | When triggered |
| P4 | `@reliability` - Ensure high availability, disaster recovery, and data integrity through proper backup and monitoring strategies | Medium | When obsolete |

## 🎯 Azure SQL Cognitive Architecture Coordination

### Multi-Modal Azure SQL Memory Distribution

**Procedural Memory Activation** (Context-Dependent):
- `azure-sql.instructions.md` → General Azure SQL patterns for .sql, .tsql, database operations
- `database-development.instructions.md` → Schema design, stored procedures, functions, triggers
- `performance-tuning.instructions.md` → Query optimization, indexing strategies, execution plans
- `security-management.instructions.md` → Authentication, authorization, encryption, compliance
- `backup-recovery.instructions.md` → Backup strategies, disaster recovery, point-in-time restore
- `monitoring-alerts.instructions.md` → Performance monitoring, alerting, diagnostics
- `migration-deployment.instructions.md` → Database migrations, CI/CD, environment management
- `troubleshooting.instructions.md` → Issue diagnosis, resolution, root cause analysis
- `documentation.instructions.md` → Database documentation and knowledge management standards
- `learning.instructions.md` → Meta-cognitive learning and self-monitoring protocols
- `meta-cognition.instructions.md` → Self-awareness and cognitive monitoring patterns

**Episodic Memory Activation** (Problem-Solving):
- `database-design.prompt.md` → Comprehensive database design and architecture workflows
- `query-optimization.prompt.md` → SQL query performance optimization procedures
- `stored-procedure-development.prompt.md` → Stored procedure development and best practices
- `index-strategy.prompt.md` → Index design and optimization strategies
- `security-audit.prompt.md` → Security assessment and compliance workflows
- `performance-analysis.prompt.md` → Database performance analysis and tuning
- `backup-strategy.prompt.md` → Backup and recovery planning procedures
- `disaster-recovery.prompt.md` → Disaster recovery testing and implementation
- `capacity-planning.prompt.md` → Resource planning and scaling strategies
- `migration-assessment.prompt.md` → Database migration planning and execution
- `compliance-review.prompt.md` → Regulatory compliance and audit procedures
- `automation-scripting.prompt.md` → PowerShell and Azure CLI automation workflows
- `consolidation.prompt.md` → Memory consolidation and cognitive architecture optimization
- `self-assessment.prompt.md` → Cognitive performance evaluation and improvement
- `meta-learning.prompt.md` → Learning strategy development and evolution
- `cognitive-health.prompt.md` → Architecture health monitoring and maintenance

### Auto-Consolidation Triggers

- Working memory > 4 rules → Execute consolidation.prompt.md
- Rule conflicts detected → Activate learning.instructions.md
- Performance degradation → Review and redistribute memory load
- User requests meditation → Full cognitive architecture optimization
- **Security vulnerabilities detected → Execute security-audit.prompt.md**
- **Performance issues identified → Execute performance-analysis.prompt.md**
- **Meta-cognitive assessment needed → Execute self-assessment.prompt.md**
- **Learning strategy evolution required → Execute meta-learning.prompt.md**
- **Cognitive architecture health check → Execute cognitive-health.prompt.md**

## 🔄 Memory Transfer Protocol

**Immediate Transfer**: Critical errors → Quick Reference (P1-P4)
**Gradual Consolidation**: Repeated patterns → Procedural memory (.instructions.md)
**Complex Workflows**: Multi-step processes → Episodic memory (.prompt.md)
**Archive Management**: Obsolete rules → Historical storage in specialized files
**Index Maintenance**: Auto-update Long-Term Memory Index during all transfers

## 📚 Long-Term Memory Index

### Procedural Memory Store (.github/instructions/)
| File | Domain | Activation Pattern | Last Updated |
|------|--------|-------------------|--------------|
| azure-sql.instructions.md | General Azure SQL | *.sql, *.tsql, Azure SQL operations | Auto-tracked |
| database-development.instructions.md | Database Development | schema, procedures, functions | Auto-tracked |
| performance-tuning.instructions.md | Performance Optimization | indexing, query optimization | Auto-tracked |
| security-management.instructions.md | Security Management | authentication, encryption, compliance | Auto-tracked |
| backup-recovery.instructions.md | Backup & Recovery | backup, restore, disaster recovery | Auto-tracked |
| monitoring-alerts.instructions.md | Monitoring & Alerts | metrics, diagnostics, alerting | Auto-tracked |
| migration-deployment.instructions.md | Migration & Deployment | CI/CD, migrations, environments | Auto-tracked |
| troubleshooting.instructions.md | Troubleshooting | debugging, issue resolution | Auto-tracked |
| documentation.instructions.md | Documentation | database documentation | Auto-tracked |
| learning.instructions.md | Meta-Learning | *instructions*, *learning* | Auto-tracked |
| meta-cognition.instructions.md | Self-Monitoring | *meta*, *monitor*, *assess* | Auto-tracked |

### Episodic Memory Store (.github/prompts/)
| File | Workflow Type | Complexity Level | Usage Frequency |
|------|---------------|------------------|-----------------|
| database-design.prompt.md | Database Design | High | Auto-tracked |
| query-optimization.prompt.md | Query Optimization | High | Auto-tracked |
| stored-procedure-development.prompt.md | Procedure Development | Medium | Auto-tracked |
| index-strategy.prompt.md | Index Strategy | High | Auto-tracked |
| security-audit.prompt.md | Security Audit | High | Auto-tracked |
| performance-analysis.prompt.md | Performance Analysis | High | Auto-tracked |
| backup-strategy.prompt.md | Backup Strategy | Medium | Auto-tracked |
| disaster-recovery.prompt.md | Disaster Recovery | High | Auto-tracked |
| capacity-planning.prompt.md | Capacity Planning | Medium | Auto-tracked |
| migration-assessment.prompt.md | Migration Assessment | High | Auto-tracked |
| compliance-review.prompt.md | Compliance Review | High | Auto-tracked |
| automation-scripting.prompt.md | Automation Scripting | Medium | Auto-tracked |
| consolidation.prompt.md | Memory Optimization | High | Auto-tracked |
| self-assessment.prompt.md | Self-Evaluation | High | Auto-tracked |
| meta-learning.prompt.md | Learning Evolution | High | Auto-tracked |
| cognitive-health.prompt.md | Health Monitoring | Medium | Auto-tracked |

### Memory Transfer Protocol Status
- **Active Files**: 26 specialized memory files (11 procedural + 15 episodic)
- **Last Consolidation**: Setup initialization with Azure SQL meta-cognitive enhancements
- **Cognitive Load Status**: Optimized through distributed processing with Azure SQL patterns
- **Index Synchronization**: Maintained automatically during consolidation
- **Meta-Cognitive Status**: Fully operational with self-assessment and learning evolution capabilities

---

*Global Declarative Memory Component - Coordinates distributed cognitive architecture while maintaining optimal working memory efficiency. Detailed execution protocols reside in specialized memory files.*
```

### Step 5: Procedural Memory Files

#### Create `.github/instructions/azure-sql.instructions.md`:

```markdown
---
applyTo: "**/*.sql,**/*.tsql,**/sql/**,**/azure-sql/**"
description: "General Azure SQL database patterns and best practices"
---

# Azure SQL Procedural Memory

## Connection Management
- Use Azure Active Directory authentication when possible for enhanced security
- Implement connection pooling for optimal resource utilization
- Configure proper connection timeouts and retry logic
- Use encrypted connections (TrustServerCertificate=False, Encrypt=True)
- Implement proper connection string management with Azure Key Vault

## Database Design Principles
- Follow normalization principles while considering performance implications
- Use appropriate data types to minimize storage and maximize performance
- Implement proper primary keys, foreign keys, and constraints
- Design indexes based on query patterns and performance requirements
- Consider partitioning strategies for large tables

## Security Best Practices
- Implement row-level security (RLS) for data isolation
- Use dynamic data masking for sensitive information
- Configure transparent data encryption (TDE) for data at rest
- Implement Always Encrypted for highly sensitive data
- Regular security audits and vulnerability assessments

## Performance Optimization
- Analyze execution plans for query optimization opportunities
- Implement appropriate indexing strategies (clustered, non-clustered, columnstore)
- Use Query Store for performance monitoring and regression detection
- Implement proper statistics maintenance and update strategies
- Consider read-scale out for read-heavy workloads

## Monitoring and Maintenance
- Set up Azure SQL Database monitoring and alerting
- Implement automated maintenance tasks (index reorganization, statistics updates)
- Monitor DTU/vCore utilization and scaling requirements
- Track query performance metrics and identify bottlenecks
- Implement backup verification and restore testing procedures
```

#### Create `.github/instructions/database-development.instructions.md`:

```markdown
---
applyTo: "**/*procedure*,**/*function*,**/*view*,**/*trigger*,**/*schema*"
description: "Database development patterns for stored procedures, functions, views, and schemas"
---

# Database Development Procedural Memory

## Stored Procedure Development
- Use consistent naming conventions (e.g., usp_GetCustomerById, usp_UpdateOrderStatus)
- Implement proper parameter validation and error handling
- Use TRY...CATCH blocks for comprehensive error management
- Include proper documentation headers with purpose, parameters, and examples
- Optimize for parameter sniffing issues with OPTION (OPTIMIZE FOR UNKNOWN)

## Function Development
- Choose between scalar, table-valued, and inline table-valued functions appropriately
- Avoid scalar functions in WHERE clauses for performance reasons
- Use deterministic functions when possible for better optimization
- Implement proper input validation and null handling
- Consider security context and permissions for function execution

## View Design
- Create views for data abstraction and security layers
- Use indexed views for performance critical scenarios
- Implement proper column naming and avoid SELECT *
- Consider updateable views requirements and restrictions
- Document view purpose and underlying table relationships

## Schema Management
- Organize database objects into logical schemas
- Implement proper naming conventions for schemas and objects
- Use schema-level permissions for access control
- Version control schema changes with migration scripts
- Document schema design decisions and object relationships

## Code Quality Standards
- Use consistent formatting and indentation for SQL code
- Implement code reviews for all database object changes
- Use version control for all database schema and code
- Include unit tests for stored procedures and functions
- Follow security principles of least privilege access
```

#### Create `.github/instructions/performance-tuning.instructions.md`:

```markdown
---
applyTo: "**/*performance*,**/*optimization*,**/*index*,**/*query*"
description: "Database performance tuning and optimization best practices"
---

# Performance Tuning Procedural Memory

## Query Optimization
- Analyze execution plans to identify performance bottlenecks
- Use SARGable predicates in WHERE clauses for index utilization
- Avoid functions on columns in WHERE clauses unless necessary
- Implement proper JOIN strategies (INNER, LEFT, RIGHT, FULL OUTER)
- Use EXISTS instead of IN for better performance with NULL values

## Index Strategy
- Create clustered indexes on frequently searched columns
- Design non-clustered indexes based on query patterns
- Consider covering indexes to include all required columns
- Use filtered indexes for selective data subsets
- Monitor index usage with sys.dm_db_index_usage_stats

## Statistics Management
- Keep statistics up to date with regular updates
- Use manual statistics updates for critical tables
- Monitor statistics quality with DBCC SHOW_STATISTICS
- Consider statistics sampling rates for large tables
- Implement automated statistics maintenance jobs

## Resource Management
- Monitor DTU/vCore consumption and identify resource bottlenecks
- Implement query timeouts and resource governor policies
- Use elastic pools for cost optimization with multiple databases
- Monitor tempdb usage and configuration
- Implement proper memory allocation and buffer pool management

## Performance Monitoring
- Use Azure SQL Database Query Performance Insight
- Implement custom performance monitoring queries
- Set up alerts for performance threshold violations
- Track wait statistics to identify system bottlenecks
- Use Extended Events for detailed performance analysis
```

#### Create `.github/instructions/security-management.instructions.md`:

```markdown
---
applyTo: "**/*security*,**/*auth*,**/*permission*,**/*audit*"
description: "Azure SQL security management and compliance best practices"
---

# Security Management Procedural Memory

## Authentication and Authorization
- Implement Azure Active Directory authentication for enhanced security
- Use service principals for application authentication
- Configure proper database user mapping and permissions
- Implement role-based access control (RBAC) with custom roles
- Regular review and audit of user permissions and access

## Data Protection
- Enable Transparent Data Encryption (TDE) for data at rest
- Implement Always Encrypted for highly sensitive data
- Use dynamic data masking for non-production environments
- Configure column-level security for sensitive information
- Implement proper backup encryption and secure storage

## Network Security
- Configure Azure SQL Database firewall rules restrictively
- Use Virtual Network Service Endpoints for enhanced network security
- Implement Private Link for private network connectivity
- Monitor network access patterns and unauthorized attempts
- Configure SSL/TLS encryption for data in transit

## Auditing and Compliance
- Enable Azure SQL Database auditing for security monitoring
- Configure audit log retention and storage requirements
- Implement threat detection and security alerts
- Regular security assessments and vulnerability scans
- Maintain compliance with regulatory requirements (GDPR, HIPAA, SOX)

## Security Monitoring
- Set up security alerts for suspicious activities
- Monitor failed login attempts and access patterns
- Implement automated responses to security threats
- Regular security reviews and penetration testing
- Maintain security incident response procedures
```

### Step 6: Episodic Memory Files

#### Create `.github/prompts/database-design.prompt.md`:

```markdown
---
mode: "agent"
model: "gpt-4"
tools: ["workspace", "run_in_terminal", "read_file", "create_file"]
description: "Comprehensive database design and architecture workflow"
---

# Database Design Episode Template

## Phase 1: Requirements Analysis and Data Modeling
- Gather business requirements and identify entities and relationships
- Create conceptual data model with ER diagrams
- Define business rules and constraints
- Identify data sources and integration requirements
- Document functional and non-functional requirements

## Phase 2: Logical Database Design
- Transform conceptual model to logical data model
- Apply normalization techniques (1NF, 2NF, 3NF, BCNF)
- Define primary keys, foreign keys, and unique constraints
- Identify indexes and performance optimization opportunities
- Design for data integrity and consistency

## Phase 3: Physical Database Implementation
- Create database schemas and table structures
- Implement indexes, constraints, and triggers
- Design stored procedures and functions for business logic
- Configure security roles and permissions
- Set up backup and recovery strategies

## Phase 4: Performance and Security Optimization
- Analyze query performance and optimize indexes
- Implement security measures (encryption, auditing, access controls)
- Configure monitoring and alerting
- Plan for scalability and high availability
- Document design decisions and maintenance procedures

Use Azure SQL development tools from ${workspaceFolder}/tools
```

#### Create `.github/prompts/query-optimization.prompt.md`:

```markdown
---
mode: "agent"
model: "gpt-4"
tools: ["workspace", "run_in_terminal", "read_file", "create_file"]
description: "SQL query performance optimization workflow"
---

# Query Optimization Episode Template

## Phase 1: Performance Problem Identification
- Identify slow-performing queries using Azure SQL Database insights
- Analyze execution plans for bottlenecks and inefficiencies
- Review query wait statistics and resource consumption
- Examine index usage and missing index recommendations
- Document baseline performance metrics

## Phase 2: Query Analysis and Rewriting
- Analyze query structure and logic for optimization opportunities
- Rewrite queries to use SARGable predicates
- Optimize JOIN operations and eliminate unnecessary complexity
- Consider alternative query approaches (EXISTS vs IN, CTEs vs subqueries)
- Test query variations and measure performance improvements

## Phase 3: Index Strategy Implementation
- Create or modify indexes based on query requirements
- Implement covering indexes for frequently accessed columns
- Consider filtered indexes for selective data
- Remove unused or duplicate indexes
- Monitor index usage and maintenance overhead

## Phase 4: Validation and Monitoring
- Compare before and after performance metrics
- Validate query results consistency
- Implement ongoing performance monitoring
- Set up alerts for performance regression
- Document optimization techniques and lessons learned

Use performance monitoring scripts from ${workspaceFolder}/sql/monitoring
```

#### Create `.github/prompts/security-audit.prompt.md`:

```markdown
---
mode: "agent"
model: "gpt-4"
tools: ["workspace", "run_in_terminal", "read_file", "create_file"]
description: "Comprehensive security audit and compliance workflow"
---

# Security Audit Episode Template

## Phase 1: Security Assessment and Baseline
- Review current security configuration and policies
- Audit user accounts, roles, and permissions
- Analyze authentication methods and access patterns
- Check encryption settings (TDE, Always Encrypted, SSL/TLS)
- Document current security posture and compliance status

## Phase 2: Vulnerability Analysis
- Run Azure SQL Database vulnerability assessment
- Identify security risks and potential threats
- Analyze audit logs for suspicious activities
- Review network security and firewall configurations
- Check for compliance with regulatory requirements

## Phase 3: Security Enhancement Implementation
- Implement recommended security controls and policies
- Configure advanced threat protection and alerting
- Update authentication and authorization mechanisms
- Enable additional encryption and data protection measures
- Establish security monitoring and incident response procedures

## Phase 4: Compliance Validation and Reporting
- Validate compliance with regulatory standards (GDPR, HIPAA, SOX)
- Generate security audit reports and documentation
- Implement ongoing security monitoring and assessments
- Establish regular security review and update processes
- Document security policies and procedures

Use security scripts from ${workspaceFolder}/sql/security
```

#### Create additional episodic memory files:

```markdown
# Additional episodic memory files to create:
# - .github/prompts/stored-procedure-development.prompt.md
# - .github/prompts/index-strategy.prompt.md
# - .github/prompts/performance-analysis.prompt.md
# - .github/prompts/backup-strategy.prompt.md
# - .github/prompts/disaster-recovery.prompt.md
# - .github/prompts/capacity-planning.prompt.md
# - .github/prompts/migration-assessment.prompt.md
# - .github/prompts/compliance-review.prompt.md
# - .github/prompts/automation-scripting.prompt.md
# - .github/prompts/consolidation.prompt.md (same as other setups)
# - .github/prompts/self-assessment.prompt.md (same as other setups)
# - .github/prompts/meta-learning.prompt.md (same as other setups)
# - .github/prompts/cognitive-health.prompt.md (same as other setups)
```

## 🎯 Setup Validation

After creating all files, verify setup:

1. **Check Azure connectivity**: Ensure Azure CLI and PowerShell modules are installed
2. **Test database connection**: Verify connection to Azure SQL Database
3. **Validate VS Code extensions**: Confirm SQL Server extension is working
4. **Check security configuration**: Verify encryption and authentication settings
5. **Test monitoring capabilities**: Confirm performance monitoring and alerting

## 🚀 Quick Start Commands

After setup, test with these commands in GitHub Copilot:

**Database Development Tests**:
- `@workspace Design a new database schema for customer management` (Should activate database-design.prompt.md)
- `Create a stored procedure for order processing` (Should activate stored-procedure-development.prompt.md)

**Performance Optimization Tests**:
- `@workspace Optimize this slow query` (Should activate query-optimization.prompt.md)
- `Analyze database performance issues` (Should activate performance-analysis.prompt.md)
- `Design indexing strategy for this table` (Should activate index-strategy.prompt.md)

**Security and Compliance Tests**:
- `@workspace Perform security audit on database` (Should activate security-audit.prompt.md)
- `Review compliance requirements` (Should activate compliance-review.prompt.md)

**Administration Tests**:
- `@workspace Plan backup and recovery strategy` (Should activate backup-strategy.prompt.md)
- `Assess database migration requirements` (Should activate migration-assessment.prompt.md)

**Meta-Cognition Tests**:
- `@workspace Assess your database administration performance` (Should activate self-assessment.prompt.md)
- `How can you improve your SQL development strategies?` (Should activate meta-learning.prompt.md)

## ⚡ Success Indicators

Your Azure SQL cognitive architecture is working when:
- Database connections are secure and optimized
- SQL queries follow performance best practices
- Security measures are comprehensive and compliant
- Monitoring and alerting systems are effective
- Database operations are well-documented and automated
- **Meta-cognitive capabilities**: The AI can assess its database management performance
- **Self-monitoring**: The system tracks SQL patterns and suggests improvements
- **Learning evolution**: The AI improves its database development techniques over time
- **Security awareness**: The system maintains security best practices automatically

## 🔄 Maintenance

- Keep Azure SQL Database and tools updated to latest versions
- Review and update security configurations regularly
- Execute consolidation meditation when adding 5+ new database patterns
- Monitor database performance and optimize as needed
- **Execute self-assessment weekly to monitor database management quality**
- **Run meta-learning analysis monthly for technique optimization**
- **Perform cognitive architecture health checks quarterly**
- **Update database capabilities based on new Azure SQL features**

## 📖 Recommended Learning Resources

- **Azure SQL Database**: Microsoft official documentation and best practices
- **Database Design**: "Database Design for Mere Mortals" by Michael Hernandez
- **Query Optimization**: "SQL Performance Explained" by Markus Winand
- **Security**: "Azure Security Center" documentation and compliance guides
- **Administration**: "Azure SQL Database Administration" learning paths

---

**AZURE SQL SETUP COMPLETE**: Your adaptive AI Azure SQL database development and administration partner is now ready with comprehensive security management, performance optimization, disaster recovery planning, and meta-cognitive self-monitoring for enterprise database operations.
