# Orchestration Database - Quick Reference Guide

## 📊 Database Diagram Overview

Your Orchestration database diagram has been created and includes:

### 🏗️ Core Components
- **11 Main Tables** designed for workflow orchestration
- **Entity Relationship Diagram** showing all connections
- **Detailed Attributes** for each table with data types
- **Relationship Mappings** with cardinality indicators

### 📁 File Locations
- **Main Diagram**: `documentation/database-design/orchestration-database-diagram.md`
- **Generator Script**: `tools/powershell/Create-DatabaseDiagram.ps1`

## 🎯 Key Database Entities

### Workflow Management
- **WORKFLOWS** - Main workflow definitions and metadata
- **WORKFLOW_STEPS** - Individual steps within each workflow
- **WORKFLOW_TEMPLATES** - Reusable workflow templates
- **WORKFLOW_VARIABLES** - Configuration variables per workflow

### Execution Tracking
- **WORKFLOW_EXECUTIONS** - Runtime execution instances
- **STEP_EXECUTIONS** - Individual step execution records
- **EXECUTION_LOGS** - Detailed logging for debugging and audit

### Automation & Control
- **WORKFLOW_TRIGGERS** - Automated workflow triggers (schedule, event-based)
- **WORKFLOW_PERMISSIONS** - Access control and security management

### Message Processing
- **ORCHESTRATION_QUEUES** - Message queuing system
- **QUEUE_MESSAGES** - Individual messages in queues

## 🔄 Key Relationships

```
WORKFLOWS (1) → (Many) WORKFLOW_STEPS
WORKFLOWS (1) → (Many) WORKFLOW_EXECUTIONS  
WORKFLOW_EXECUTIONS (1) → (Many) STEP_EXECUTIONS
ALL_EXECUTIONS (1) → (Many) EXECUTION_LOGS
WORKFLOW_TEMPLATES (1) → (Many) WORKFLOWS
ORCHESTRATION_QUEUES (1) → (Many) QUEUE_MESSAGES
```

## 🛠️ How to Use the Diagram

### 1. View in VS Code
- Open `documentation/database-design/orchestration-database-diagram.md`
- Install Mermaid Preview extension if not already installed
- Use preview to see the visual diagram

### 2. Update the Diagram
- Run `.\tools\powershell\Create-DatabaseDiagram.ps1` 
- Script will attempt to connect to live database first
- Falls back to standard orchestration patterns if connection fails

### 3. Export Options
- Copy Mermaid code to online viewers (mermaid.live, draw.io)
- Export as SVG, PNG, or PDF from Mermaid viewers
- Share the markdown file for documentation

## 🔍 Database Exploration Tools

### For VS Code (Recommended)
- **SQL Server Extension** configured with Azure MFA
- **Connection Profile**: "Orchestration-MFA" 
- **Server**: cxmidl.database.windows.net
- **Database**: Orchestration

### For PowerShell Scripts
- `.\tools\powershell\Test-AzureSqlMFA.ps1` - Test connection
- `.\tools\powershell\Get-DatabaseTables.ps1` - List tables
- `.\tools\powershell\Manage-AzureSqlDatabase-MFA.ps1` - Full management

### Alternative Methods
- **Azure Portal** → SQL Databases → Orchestration → Query Editor
- **SQL Server Management Studio (SSMS)** with Azure MFA
- **Azure Data Studio** with Azure AD authentication

## 🚀 Next Steps

1. **Test Connection**: Use VS Code SQL Server extension to connect
2. **Explore Tables**: Run sample queries to understand the data
3. **Update Diagram**: Re-run the script if you discover additional tables
4. **Document Queries**: Save useful queries in the `sql/` folder

## 🔧 Troubleshooting

### Connection Issues
- Ensure you're connected to VPN if required
- Verify Azure MFA is working: `Connect-AzAccount`
- Check firewall rules in Azure portal
- Try browser-based query editor as fallback

### Diagram Updates
- Re-run `Create-DatabaseDiagram.ps1` to refresh from live database
- Manually edit the markdown file for custom additions
- Validate Mermaid syntax using the preview

---
**Generated**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Database**: cxmidl.database.windows.net/Orchestration  
**Authentication**: Azure MFA
