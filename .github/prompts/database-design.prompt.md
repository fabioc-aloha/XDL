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
