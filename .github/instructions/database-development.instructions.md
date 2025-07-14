---
applyTo: "**/*procedure*,**/*function*,**/*view*,**/*trigger*,**/*schema*"
description: "Database development patterns for stored procedures, functions, views, and schemas"
---

# Database Development Procedural Memory

## Stored Procedure Development
- Use consistent naming conventions (e.g., usp_GetCustomerById, usp_UpdateOrderStatus)
- Implement proper parameter validation and error handling
- Use TRY...CATCH blocks for comprehensive error management
- Include proper documentation headers with purpose, parameters, and examples
- Optimize for parameter sniffing issues with OPTION (OPTIMIZE FOR UNKNOWN)

## Function Development
- Choose between scalar, table-valued, and inline table-valued functions appropriately
- Avoid scalar functions in WHERE clauses for performance reasons
- Use deterministic functions when possible for better optimization
- Implement proper input validation and null handling
- Consider security context and permissions for function execution

## View Design
- Create views for data abstraction and security layers
- Use indexed views for performance critical scenarios
- Implement proper column naming and avoid SELECT *
- Consider updateable views requirements and restrictions
- Document view purpose and underlying table relationships

## Schema Management
- Organize database objects into logical schemas
- Implement proper naming conventions for schemas and objects
- Use schema-level permissions for access control
- Version control schema changes with migration scripts
- Document schema design decisions and object relationships

## Code Quality Standards
- Use consistent formatting and indentation for SQL code
- Implement code reviews for all database object changes
- Use version control for all database schema and code
- Include unit tests for stored procedures and functions
- Follow security principles of least privilege access
