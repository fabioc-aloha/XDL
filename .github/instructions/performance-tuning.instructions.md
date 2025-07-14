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
