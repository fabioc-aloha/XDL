---
mode: "agent"
model: "gpt-4"
tools: ["workspace", "run_in_terminal", "read_file", "create_file"]
description: "Comprehensive security audit and compliance workflow"
---

# Security Audit Episode Template

## Phase 1: Security Assessment and Baseline
- Review current security configuration and policies
- Audit user accounts, roles, and permissions
- Analyze authentication methods and access patterns
- Check encryption settings (TDE, Always Encrypted, SSL/TLS)
- Document current security posture and compliance status

## Phase 2: Vulnerability Analysis
- Run Azure SQL Database vulnerability assessment
- Identify security risks and potential threats
- Analyze audit logs for suspicious activities
- Review network security and firewall configurations
- Check for compliance with regulatory requirements

## Phase 3: Security Enhancement Implementation
- Implement recommended security controls and policies
- Configure advanced threat protection and alerting
- Update authentication and authorization mechanisms
- Enable additional encryption and data protection measures
- Establish security monitoring and incident response procedures

## Phase 4: Compliance Validation and Reporting
- Validate compliance with regulatory standards (GDPR, HIPAA, SOX)
- Generate security audit reports and documentation
- Implement ongoing security monitoring and assessments
- Establish regular security review and update processes
- Document security policies and procedures

Use security scripts from ${workspaceFolder}/sql/security
