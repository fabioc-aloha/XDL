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
