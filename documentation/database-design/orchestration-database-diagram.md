# Orchestration Database Entity Relationship Diagram

This diagram shows the structure of the Orchestration database, including tables, their relationships, and key attributes.

```mermaid
---
title: Orchestration Database Schema
---
erDiagram
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
```

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

- **Generated Date**: 2025-07-14 15:51:01
- **Database Server**: cxmidl.database.windows.net
- **Database Name**: Orchestration
- **Diagram Type**: Entity Relationship Diagram (ERD)
- **Data Source**: Common orchestration patterns (database not accessible)
