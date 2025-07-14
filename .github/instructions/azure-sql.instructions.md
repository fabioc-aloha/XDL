---
applyTo: "**/*.sql,**/*.tsql,**/sql/**,**/azure-sql/**"
description: "General Azure SQL database patterns and best practices"
---

# Azure SQL Procedural Memory

## Connection Management
- Use Azure Active Directory authentication when possible for enhanced security
- **Azure MFA Implementation**: Use "Authentication=Active Directory Interactive" for secure MFA connections
- **Environment Variables**: Store connection parameters in .env files to prevent credential exposure
- **VS Code Integration**: Configure SQL Server extension with MFA profiles for seamless development
- **PowerShell Modules**: Import SqlServer module with proper error handling for MFA scenarios
- Implement connection pooling for optimal resource utilization
- Configure proper connection timeouts and retry logic (minimum 15 seconds for MFA)
- Use encrypted connections (TrustServerCertificate=False, Encrypt=True)
- Implement proper connection string management with Azure Key Vault

## Azure MFA Authentication Patterns
- **Connection String Format**: "Server=tcp:server,1433;Initial Catalog=database;Authentication=Active Directory Interactive;Encrypt=True;TrustServerCertificate=False;Connection Timeout=15;"
- **PowerShell Authentication**: Always test `Connect-AzAccount` before database operations
- **Error Handling**: Implement timeout and authentication failure recovery mechanisms
- **Interactive Requirements**: MFA requires user interaction - cannot be fully automated without service principals
- **Firewall Configuration**: Ensure Azure SQL firewall allows client IP addresses
- **Network Requirements**: Verify network connectivity to Azure SQL endpoints on port 1433

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

## Development Environment Setup
- **Directory Structure**: Organize projects with .github/, sql/, tools/, documentation/ folders
- **Git Security**: Implement comprehensive .gitignore to prevent credential exposure
- **Documentation Automation**: Create scripts for auto-generating database diagrams and documentation
- **Version Control**: Use structured commit messages and branch strategies for database development
- **Tool Integration**: Configure VS Code, PowerShell, and Azure CLI for seamless Azure SQL development
