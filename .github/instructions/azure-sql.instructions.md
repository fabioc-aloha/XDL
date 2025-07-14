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
