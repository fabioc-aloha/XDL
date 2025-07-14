---
applyTo: "**/*backup*,**/*recovery*,**/*restore*,**/*disaster*"
description: "Backup and recovery strategies for Azure SQL Database"
---

# Backup and Recovery Procedural Memory

## Automated Backup Management
- Leverage Azure SQL Database automated backup features
- Configure point-in-time restore retention periods (7-35 days)
- Enable long-term retention for compliance requirements
- Set up geo-redundant backups for disaster recovery
- Monitor backup storage consumption and costs

## Point-in-Time Recovery
- Understand recovery time objectives (RTO) and recovery point objectives (RPO)
- Use Azure portal, PowerShell, or CLI for point-in-time restores
- Test restore procedures regularly to validate backup integrity
- Document restore procedures and recovery workflows
- Implement automated restore testing for critical databases

## Disaster Recovery Planning
- Configure geo-replication for high availability
- Set up failover groups for automatic failover
- Plan for cross-region disaster recovery scenarios
- Document failover and failback procedures
- Test disaster recovery plans regularly

## Backup Monitoring and Alerting
- Monitor backup completion and failure events
- Set up alerts for backup storage threshold violations
- Track backup retention policy compliance
- Monitor geo-replication lag and health
- Implement automated backup validation processes

## Data Export and Migration
- Use Azure Data Studio or SSMS for database exports
- Leverage BACPAC files for database migration
- Implement Azure Database Migration Service for large migrations
- Plan for minimal downtime migration strategies
- Validate data integrity after migration operations
