# Git Configuration for Azure SQL Development

## Repository Information
- **Repository**: Azure SQL Development Environment (XDL)
- **Primary Branch**: main
- **Created**: July 14, 2025
- **Purpose**: Azure SQL Database development and administration

## Branch Strategy

### Main Branches
- `main` - Production-ready code and documentation
- `develop` - Integration branch for new features
- `feature/*` - Feature development branches
- `hotfix/*` - Critical production fixes

### Recommended Workflow
```bash
# Create feature branch
git checkout -b feature/new-database-script main

# Work on feature, commit changes
git add .
git commit -m "feat: add new monitoring query for index usage"

# Merge back to main (or create pull request)
git checkout main
git merge feature/new-database-script
git branch -d feature/new-database-script
```

## Commit Message Conventions

### Format
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types
- `feat` - New feature or enhancement
- `fix` - Bug fix
- `docs` - Documentation updates
- `refactor` - Code refactoring
- `perf` - Performance improvements
- `test` - Adding or updating tests
- `chore` - Maintenance tasks
- `security` - Security-related changes
- `sql` - Database schema or query changes
- `config` - Configuration changes

### Examples
```bash
git commit -m "feat(powershell): add database backup automation script"
git commit -m "fix(sql): correct syntax error in stored procedure"
git commit -m "docs(readme): update connection instructions"
git commit -m "sql(schema): add new indexes for performance optimization"
git commit -m "security(auth): update MFA configuration"
```

## File Tracking Guidelines

### Always Track
- SQL scripts and procedures
- PowerShell management scripts
- Documentation files
- Configuration templates
- Schema definitions

### Never Track (Already in .gitignore)
- Connection strings with credentials
- .env files
- Azure authentication files
- Database backup files (.bak, .bacpac)
- VS Code personal settings

## Cognitive Memory Integration

### Memory Updates
When updating cognitive memory files:
```bash
git commit -m "memory(procedural): update azure-sql best practices"
git commit -m "memory(episodic): add new query optimization workflow"
git commit -m "memory(consolidation): optimize working memory rules"
```

### Documentation Sync
Keep documentation in sync with code changes:
```bash
git commit -m "docs(diagram): update ER diagram with new tables"
git commit -m "docs(procedures): document new stored procedure workflow"
```

## Useful Git Commands

### Daily Workflow
```bash
# Check status
git status

# Stage all changes
git add .

# Commit with message
git commit -m "type(scope): description"

# View commit history
git log --oneline

# View changes
git diff
```

### Branch Management
```bash
# List all branches
git branch -a

# Create and switch to new branch
git checkout -b feature/branch-name

# Switch branches
git checkout main

# Delete branch
git branch -d branch-name
```

### Undoing Changes
```bash
# Unstage files
git reset HEAD <file>

# Discard working directory changes
git checkout -- <file>

# Undo last commit (keep changes)
git reset --soft HEAD~1

# View file history
git log --follow <file>
```

## Integration with Development Tools

### VS Code Integration
- Use VS Code Git integration for visual diff and staging
- Install GitLens extension for enhanced Git capabilities
- Use Source Control panel for commit management

### PowerShell Integration
```powershell
# Check Git status in PowerShell
git status

# Add and commit in one line
git add .; git commit -m "your message"

# Push to remote when configured
git push origin main
```

## Remote Repository Setup (When Ready)

### Azure DevOps
```bash
git remote add origin https://dev.azure.com/organization/project/_git/repository
git push -u origin main
```

### GitHub
```bash
git remote add origin https://github.com/username/repository.git
git push -u origin main
```

### Azure Repos
```bash
git remote add origin https://organization@dev.azure.com/organization/project/_git/repository
git push -u origin main
```

---

**Note**: This configuration supports the cognitive memory architecture and Azure SQL development workflow established in this repository.
