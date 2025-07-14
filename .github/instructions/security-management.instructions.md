---
applyTo: "**/*security*,**/*auth*,**/*permission*,**/*audit*"
description: "Azure SQL security management and compliance best practices"
---

# Security Management Procedural Memory

## Authentication and Authorization
- Implement Azure Active Directory authentication for enhanced security
- Use service principals for application authentication
- Configure proper database user mapping and permissions
- Implement role-based access control (RBAC) with custom roles
- Regular review and audit of user permissions and access

## Data Protection
- Enable Transparent Data Encryption (TDE) for data at rest
- Implement Always Encrypted for highly sensitive data
- Use dynamic data masking for non-production environments
- Configure column-level security for sensitive information
- Implement proper backup encryption and secure storage

## Network Security
- Configure Azure SQL Database firewall rules restrictively
- Use Virtual Network Service Endpoints for enhanced network security
- Implement Private Link for private network connectivity
- Monitor network access patterns and unauthorized attempts
- Configure SSL/TLS encryption for data in transit

## Auditing and Compliance
- Enable Azure SQL Database auditing for security monitoring
- Configure audit log retention and storage requirements
- Implement threat detection and security alerts
- Regular security assessments and vulnerability scans
- Maintain compliance with regulatory requirements (GDPR, HIPAA, SOX)

## Security Monitoring
- Set up security alerts for suspicious activities
- Monitor failed login attempts and access patterns
- Implement automated responses to security threats
- Regular security reviews and penetration testing
- Maintain security incident response procedures
