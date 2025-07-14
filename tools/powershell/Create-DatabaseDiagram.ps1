# Generate Orchestration Database ER Diagram
# This script creates a Mermaid ER diagram of the Orchestration database

Write-Host "Creating Orchestration Database Entity Relationship Diagram..." -ForegroundColor Cyan

# Try to get live database structure first
$liveStructure = $null
try {
    Import-Module SqlServer -Force -ErrorAction SilentlyContinue
    
    $serverName = "cxmidl.database.windows.net"
    $databaseName = "Orchestration"
    $connectionString = "Server=tcp:$serverName,1433;Initial Catalog=$databaseName;Authentication=Active Directory Interactive;Encrypt=True;TrustServerCertificate=False;Connection Timeout=15;"
    
    Write-Host "Attempting to connect to live database..." -ForegroundColor Yellow
    
    # Quick structure query
    $quickQuery = @"
SELECT 
    t.TABLE_NAME as TableName,
    STRING_AGG(c.COLUMN_NAME, ', ') as Columns
FROM INFORMATION_SCHEMA.TABLES t
LEFT JOIN INFORMATION_SCHEMA.COLUMNS c ON t.TABLE_NAME = c.TABLE_NAME
WHERE t.TABLE_TYPE = 'BASE TABLE'
GROUP BY t.TABLE_NAME
ORDER BY t.TABLE_NAME
"@
    
    $liveStructure = Invoke-Sqlcmd -ConnectionString $connectionString -Query $quickQuery -QueryTimeout 15 -ErrorAction Stop
    Write-Host "✓ Successfully retrieved live database structure" -ForegroundColor Green
    
}
catch {
    Write-Host "⚠ Could not connect to live database: $($_.Exception.Message.Split('.')[0])" -ForegroundColor Yellow
    Write-Host "Creating diagram based on common Orchestration database patterns..." -ForegroundColor White
}

# Create Mermaid ER Diagram
$mermaidDiagram = @"
---
title: Orchestration Database Schema
---
erDiagram
"@

if ($liveStructure) {
    # Use live database structure
    Write-Host "Building diagram from live database structure..." -ForegroundColor Green
    
    foreach ($table in $liveStructure) {
        $mermaidDiagram += "`n    $($table.TableName.ToUpper()) {"
        if ($table.Columns) {
            $columns = $table.Columns -split ', '
            foreach ($column in $columns[0..4]) {
                # Show first 5 columns
                $mermaidDiagram += "`n        string $column"
            }
            if ($columns.Count -gt 5) {
                $mermaidDiagram += "`n        string ... `"$($columns.Count - 5) more columns`""
            }
        }
        $mermaidDiagram += "`n    }"
    }
    
}
else {
    # Use common Orchestration database patterns
    Write-Host "Building diagram from common orchestration patterns..." -ForegroundColor White
    
    $mermaidDiagram += @"

    %% Core Orchestration Entities
    WORKFLOWS {
        int WorkflowId PK "Unique workflow identifier"
        string WorkflowName "Name of the workflow"
        string Description "Workflow description"
        string Status "Current status"
        datetime CreatedDate "When created"
        datetime ModifiedDate "Last modified"
        string CreatedBy "Who created"
        string Version "Workflow version"
    }
    
    WORKFLOW_STEPS {
        int StepId PK "Unique step identifier"
        int WorkflowId FK "Parent workflow"
        string StepName "Name of the step"
        string StepType "Type of step"
        int OrderIndex "Execution order"
        string Configuration "Step configuration"
        string Status "Step status"
        datetime CreatedDate "When created"
    }
    
    WORKFLOW_EXECUTIONS {
        int ExecutionId PK "Unique execution identifier"
        int WorkflowId FK "Workflow being executed"
        string Status "Execution status"
        datetime StartTime "When started"
        datetime EndTime "When completed"
        string ExecutedBy "Who executed"
        string InputParameters "Input data"
        string OutputResults "Output data"
        string ErrorMessage "Any errors"
    }
    
    STEP_EXECUTIONS {
        int StepExecutionId PK "Unique step execution identifier"
        int ExecutionId FK "Parent execution"
        int StepId FK "Step being executed"
        string Status "Step execution status"
        datetime StartTime "When step started"
        datetime EndTime "When step completed"
        string InputData "Step input"
        string OutputData "Step output"
        string ErrorMessage "Step errors"
        int RetryCount "Number of retries"
    }
    
    WORKFLOW_TEMPLATES {
        int TemplateId PK "Unique template identifier"
        string TemplateName "Template name"
        string Description "Template description"
        string Category "Template category"
        string TemplateData "Template definition"
        string Version "Template version"
        datetime CreatedDate "When created"
        string CreatedBy "Who created"
        bit IsActive "Template active status"
    }
    
    WORKFLOW_TRIGGERS {
        int TriggerId PK "Unique trigger identifier"
        int WorkflowId FK "Workflow to trigger"
        string TriggerType "Type of trigger"
        string TriggerCondition "Trigger condition"
        string Schedule "Cron schedule if applicable"
        bit IsActive "Trigger active status"
        datetime CreatedDate "When created"
        datetime LastTriggered "Last trigger time"
    }
    
    WORKFLOW_VARIABLES {
        int VariableId PK "Unique variable identifier"
        int WorkflowId FK "Parent workflow"
        string VariableName "Variable name"
        string VariableType "Data type"
        string DefaultValue "Default value"
        string Description "Variable description"
        bit IsRequired "Required flag"
        datetime CreatedDate "When created"
    }
    
    EXECUTION_LOGS {
        int LogId PK "Unique log identifier"
        int ExecutionId FK "Related execution"
        int StepExecutionId FK "Related step execution"
        string LogLevel "Log level"
        string Message "Log message"
        string Details "Additional details"
        datetime Timestamp "When logged"
        string Source "Log source"
    }
    
    WORKFLOW_PERMISSIONS {
        int PermissionId PK "Unique permission identifier"
        int WorkflowId FK "Workflow"
        string UserOrRole "User or role"
        string PermissionType "Permission type"
        datetime GrantedDate "When granted"
        string GrantedBy "Who granted"
        bit IsActive "Permission active"
    }
    
    ORCHESTRATION_QUEUES {
        int QueueId PK "Unique queue identifier"
        string QueueName "Queue name"
        string QueueType "Queue type"
        int MaxSize "Maximum queue size"
        int CurrentSize "Current queue size"
        string Status "Queue status"
        datetime CreatedDate "When created"
        string Configuration "Queue configuration"
    }
    
    QUEUE_MESSAGES {
        int MessageId PK "Unique message identifier"
        int QueueId FK "Parent queue"
        string MessageType "Message type"
        string MessageData "Message content"
        string Status "Message status"
        int Priority "Message priority"
        datetime CreatedDate "When created"
        datetime ProcessedDate "When processed"
        int RetryCount "Retry attempts"
    }
    
    %% Core Relationships
    WORKFLOWS ||--o{ WORKFLOW_STEPS : "contains"
    WORKFLOWS ||--o{ WORKFLOW_EXECUTIONS : "executed as"
    WORKFLOWS ||--o{ WORKFLOW_TRIGGERS : "triggered by"
    WORKFLOWS ||--o{ WORKFLOW_VARIABLES : "uses"
    WORKFLOWS ||--o{ WORKFLOW_PERMISSIONS : "secured by"
    
    WORKFLOW_EXECUTIONS ||--o{ STEP_EXECUTIONS : "contains"
    WORKFLOW_EXECUTIONS ||--o{ EXECUTION_LOGS : "logged in"
    
    WORKFLOW_STEPS ||--o{ STEP_EXECUTIONS : "executed as"
    
    STEP_EXECUTIONS ||--o{ EXECUTION_LOGS : "logged in"
    
    WORKFLOW_TEMPLATES ||--o{ WORKFLOWS : "generates"
    
    ORCHESTRATION_QUEUES ||--o{ QUEUE_MESSAGES : "contains"
    
    WORKFLOW_EXECUTIONS ||--o{ QUEUE_MESSAGES : "may create"
"@
}

# Save the diagram to a file
$diagramPath = "documentation/database-design/orchestration-database-diagram.md"
$diagramContent = @"
# Orchestration Database Entity Relationship Diagram

This diagram shows the structure of the Orchestration database, including tables, their relationships, and key attributes.

``````mermaid
$mermaidDiagram
``````

## Database Overview

The Orchestration database is designed to manage workflow execution and orchestration processes. Key components include:

### Core Entities

- **WORKFLOWS**: Main workflow definitions
- **WORKFLOW_STEPS**: Individual steps within workflows  
- **WORKFLOW_EXECUTIONS**: Runtime execution instances
- **STEP_EXECUTIONS**: Individual step execution records

### Supporting Entities

- **WORKFLOW_TEMPLATES**: Reusable workflow templates
- **WORKFLOW_TRIGGERS**: Automated workflow triggers
- **WORKFLOW_VARIABLES**: Workflow configuration variables
- **EXECUTION_LOGS**: Detailed execution logging
- **WORKFLOW_PERMISSIONS**: Access control and security
- **ORCHESTRATION_QUEUES**: Message queuing system
- **QUEUE_MESSAGES**: Individual queue messages

### Key Relationships

1. **Workflows** contain multiple **Steps** and can have multiple **Executions**
2. **Executions** contain multiple **Step Executions** for each workflow step
3. **All executions** are logged in **Execution Logs** for audit and debugging
4. **Workflows** can be created from **Templates** for standardization
5. **Triggers** can automatically start **Workflow Executions**
6. **Queues** and **Messages** support asynchronous processing

## Generated Information

- **Generated Date**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
- **Database Server**: cxmidl.database.windows.net
- **Database Name**: Orchestration
- **Diagram Type**: Entity Relationship Diagram (ERD)
"@

if ($liveStructure) {
    $diagramContent += "`n- **Data Source**: Live database structure"
    $diagramContent += "`n- **Tables Found**: $($liveStructure.Count)"
}
else {
    $diagramContent += "`n- **Data Source**: Common orchestration patterns (database not accessible)"
}

# Create the documentation directory if it doesn't exist
$docDir = Split-Path $diagramPath -Parent
if (!(Test-Path $docDir)) {
    New-Item -ItemType Directory -Force -Path $docDir | Out-Null
}

# Save the diagram
$diagramContent | Out-File -FilePath $diagramPath -Encoding UTF8

Write-Host "`n✓ Orchestration Database Diagram Created!" -ForegroundColor Green
Write-Host "📄 Saved to: $diagramPath" -ForegroundColor White
Write-Host "`nTo view the diagram:" -ForegroundColor Cyan
Write-Host "1. Open the file in VS Code" -ForegroundColor White  
Write-Host "2. Use Mermaid Preview extension to render the diagram" -ForegroundColor White
Write-Host "3. Or copy the Mermaid code to any Mermaid viewer online" -ForegroundColor White

# Display a summary
Write-Host "`n📊 Diagram Summary:" -ForegroundColor Yellow
if ($liveStructure) {
    Write-Host "• Database Tables: $($liveStructure.Count)" -ForegroundColor White
    Write-Host "• Data Source: Live database" -ForegroundColor White
}
else {
    Write-Host "• Database Tables: 11 (common orchestration pattern)" -ForegroundColor White
    Write-Host "• Data Source: Standard orchestration schema" -ForegroundColor White
}
Write-Host "• Diagram Type: Entity Relationship Diagram" -ForegroundColor White
Write-Host "• Format: Mermaid Markdown" -ForegroundColor White
