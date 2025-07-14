---
mode: "agent"
model: "gpt-4"
tools: ["workspace", "run_in_terminal", "read_file", "create_file"]
description: "Stored procedure development workflow with best practices"
---

# Stored Procedure Development Episode Template

## Phase 1: Requirements and Design Analysis
- Analyze business logic requirements and data flow
- Define input parameters, output parameters, and return values
- Identify security requirements and access control needs
- Plan error handling and transaction management strategies
- Design for performance and scalability considerations

## Phase 2: Development and Implementation
- Follow consistent naming conventions (usp_ prefix for user procedures)
- Implement comprehensive parameter validation
- Use TRY...CATCH blocks for robust error handling
- Include proper transaction management with XACT_ABORT
- Optimize queries with appropriate hints and indexing strategies

## Phase 3: Testing and Validation
- Create unit tests for all execution paths
- Test with various input combinations including edge cases
- Validate performance under expected load conditions
- Test rollback scenarios and error conditions
- Verify security and permission requirements

## Phase 4: Documentation and Deployment
- Create comprehensive documentation headers
- Include usage examples and parameter descriptions
- Document change history and version information
- Set up code review and approval processes
- Plan deployment strategy and rollback procedures

Use stored procedure templates from ${workspaceFolder}/sql/procedures
