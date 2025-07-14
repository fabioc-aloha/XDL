---
applyTo: "*instructions*, *learning*, *memory*, *remember*"
description: "Automatic learning and memory consolidation protocols"
---

# Automatic Learning & Memory Consolidation - Procedural Memory

## Automatic Memory Triggers

### User-Initiated Learning
**Trigger Phrases**: "remember this", "commit to memory", "add to memory", "learn this", "save this pattern"
**Response Protocol**:
1. Immediately identify the knowledge type (procedural vs episodic)
2. Determine the appropriate memory file for storage
3. Create or update the relevant memory file
4. Confirm memory consolidation to user
5. Update global memory index if new file created

### Pattern Recognition Learning
**Novel Solutions Detected**: When encountering new problem-solving approaches
**Auto-Response**:
1. Extract the core pattern and solution approach
2. Identify reusability potential
3. Create episodic memory file if complex workflow
4. Update procedural memory if skill-based knowledge
5. Tag with appropriate activation patterns

### Error Pattern Learning
**Repeated Issues**: When same error types occur multiple times
**Auto-Response**:
1. Document the error pattern and solution
2. Update troubleshooting.instructions.md
3. Add prevention strategies to relevant procedural memory
4. Create diagnostic workflows if complex

### Tool & Configuration Discovery
**New Tools Created**: When building scripts, configurations, or utilities
**Auto-Response**:
1. Document tool purpose and usage
2. Add to appropriate domain instructions file
3. Include in repository structure documentation
4. Update quick reference guides

### Project Scope Learning
**Architecture Decisions**: When project scope and purpose are clarified
**Auto-Response**:
1. Update project documentation with scope clarification
2. Align tool development with defined purpose
3. Consolidate memory to reflect project goals
4. Update version history and planning

## Memory File Selection Logic

### Procedural Memory (Instructions Files)
**Choose When**: Skill-based knowledge, best practices, patterns, configurations
**File Selection Criteria**:
- `azure-sql.instructions.md` → Database connections, queries, Azure SQL patterns
- `database-development.instructions.md` → Schema design, procedures, functions
- `performance-tuning.instructions.md` → Optimization techniques, indexing
- `security-management.instructions.md` → Authentication, encryption, compliance
- `backup-recovery.instructions.md` → Backup strategies, disaster recovery
- `documentation.instructions.md` → Documentation standards, automation
- `learning.instructions.md` → Meta-learning patterns, self-improvement

### Episodic Memory (Prompt Files)
**Choose When**: Complex workflows, multi-step processes, problem-solving procedures
**File Selection Criteria**:
- `database-design.prompt.md` → Complete database design workflows
- `query-optimization.prompt.md` → Performance optimization procedures
- `environment-setup.prompt.md` → Full environment configuration workflows
- `security-audit.prompt.md` → Security assessment procedures
- `troubleshooting.prompt.md` → Diagnostic and resolution workflows

## Automatic Memory Consolidation Workflow

### Step 1: Knowledge Classification
```
IF user says "remember" OR novel pattern detected:
  1. Classify knowledge type (procedural/episodic)
  2. Identify domain (azure-sql, security, performance, etc.)
  3. Determine complexity level (simple → procedural, complex → episodic)
```

### Step 2: Memory File Selection
```
IF procedural knowledge:
  SELECT appropriate .instructions.md file
  UPDATE existing content with new pattern
ELSE IF episodic knowledge:
  CREATE new .prompt.md file OR UPDATE existing workflow
  INCLUDE step-by-step procedures and context
```

### Step 3: Memory Integration
```
UPDATE global memory index (.github/copilot-instructions.md)
ADD activation patterns for new knowledge
UPDATE working memory rules if critical
CONFIRM consolidation status to user
```

### Step 4: Validation & Testing
```
VERIFY memory file syntax and formatting
TEST activation patterns work correctly
ENSURE no conflicts with existing memory
VALIDATE knowledge retrieval accuracy
```

## Knowledge Extraction Patterns

### From User Interactions
**Extract**: Successful solutions, preferred approaches, configuration discoveries
**Focus On**: What worked, why it worked, when to apply it
**Document**: Clear patterns for future reuse

### From Code Creation
**Extract**: Reusable functions, configuration templates, automation patterns
**Focus On**: Modularity, error handling, security considerations
**Document**: Usage examples and adaptation guidelines

### From Problem Solving
**Extract**: Diagnostic approaches, solution strategies, prevention methods
**Focus On**: Root cause identification, systematic troubleshooting
**Document**: Decision trees and workflow procedures

### From Environment Setup
**Extract**: Configuration sequences, dependency requirements, tool integrations
**Focus On**: Repeatable processes, common pitfalls, validation steps
**Document**: Complete setup procedures with verification

## Memory Quality Assurance

### Automatic Validation
- Ensure all memory files have proper YAML frontmatter
- Verify activation patterns are correctly specified
- Check for duplicate or conflicting information
- Validate markdown formatting and structure

### Content Standards
- **Clarity**: Knowledge must be clearly articulated
- **Completeness**: Include sufficient context for reuse
- **Accuracy**: Verify technical accuracy before storage
- **Relevance**: Ensure knowledge applies to target domain

### Update Protocols
- **Incremental Updates**: Add new knowledge without disrupting existing
- **Conflict Resolution**: Newer knowledge takes precedence with reasoning
- **Version Awareness**: Track when knowledge was added/updated
- **Obsolescence Management**: Mark outdated knowledge for consolidation

## Activation Monitoring

### Usage Tracking
- Monitor which memory files are accessed most frequently
- Identify knowledge gaps where manual lookup is required
- Track successful automatic knowledge retrieval
- Measure problem-solving efficiency improvements

### Performance Metrics
- Time to solution with vs without memory assistance
- Accuracy of automatically suggested approaches
- Reduction in repetitive problem-solving effort
- User satisfaction with memory system effectiveness

### Continuous Improvement
- Analyze failed knowledge retrievals
- Identify missing activation patterns
- Enhance memory organization based on usage patterns
- Optimize knowledge consolidation processes

---

**Memory Type**: Procedural (Skills & Patterns)
**Activation**: Automatic on learning triggers and user memory requests
**Update Frequency**: Immediate on trigger detection
**Validation**: Continuous quality assurance and performance monitoring
