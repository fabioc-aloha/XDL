# 📋 CXPulse Business Rules Documentation

## 🎯 Document Purpose

This document outlines the **comprehensive business rules** for the Microsoft CXPulse survey system as inferred from the complete source code analysis of stored procedures, views, and database schema. These rules govern survey sampling, participant eligibility, data processing, and response management.

**📊 Source Analysis**:
- **9 Stored Procedures** analyzed for business logic
- **21 Views** examined for operational rules
- **4 Database Tables** reviewed for data constraints
- **Production Configuration** extracted from live system

---

## 🏢 SECTION 1: ORGANIZATIONAL & SURVEY MANAGEMENT RULES

### 1.1 📈 Survey Volume & Distribution Rules

**R1.1 - Total Sample Size Management**
- **Rule**: Total sample size is fixed at **127,000 participants** per wave
- **Authority**: Requires authorization to change in production
- **Source**: `@TotalSample FLOAT = 127000` in sp_CXPulse_AddToStagingV3
- **Business Impact**: Ensures consistent survey reach and statistical validity

**R1.2 - Geographic Distribution Requirements**
- **Rule**: Sample must be distributed as:
  - **United States**: 33.33% (1/3 of total sample = ~42,333 participants)
  - **Non-US Markets**: 66.67% (2/3 of total sample = ~84,667 participants)
- **Source**: `@US_N = @TotalSample * 1 / 3.0` and `@NonUS_N = @TotalSample * 2 / 3.0`
- **Business Rationale**: Reflects Microsoft's global customer distribution priorities

**R1.3 - Multi-Source Data Integration**
- **Rule**: Candidate selection must combine data from two primary sources:
  - **VIVA Source**: 75% of total sample allocation
  - **MSX Source**: 25% of total sample allocation
- **Source**: `@VivaPct = 0.75` and `@MsxPct = 0.25`
- **Business Rationale**: Ensures diverse representation across Microsoft's customer engagement platforms

### 1.2 🗓️ Survey Wave & Timing Rules

**R2.1 - Wave Identification Standards**
- **Rule**: Each survey wave must be identified by year-month format (YYYY-MM)
- **Current Example**: '2025-05' for May 2025 wave
- **Source**: `@Wave = '2025-05'` and `@WaveName = @Wave`
- **Business Impact**: Enables temporal tracking and trend analysis

**R2.2 - Sample Date Calculation**
- **Rule**: Sample date is automatically calculated as the 15th day of the wave month
- **Formula**: `CAST(@Wave + '-15' AS DATE)`
- **Business Rationale**: Provides consistent mid-month timing for survey launches

**R2.3 - Wave Type Classification**
- **Rule**: Surveys must be classified into specific types:
  - **CXPulse**: Standard customer experience survey (default)
  - **CXTransactional**: Transaction-specific feedback
  - **CXPulseQEI**: Quality Experience Index focused
  - **CXATQCPMQEI**: Advanced quality metrics
  - **CXPartner**: Partner-focused surveys
- **Source**: Various `@WaveType` declarations across procedures
- **Business Impact**: Enables specialized survey routing and analysis

---

## 👥 SECTION 2: PARTICIPANT ELIGIBILITY & EXCLUSION RULES

### 2.1 ✅ Core Eligibility Requirements

**R3.1 - Consent & Permission Requirements**
- **Rule**: Participants MUST have explicit permission to receive surveys
- **Technical**: `CPMPermissionToSend = 1` (mandatory filter)
- **Source**: `WHERE p.CPMPermissionToSend = 1` in LimitCandidates CTE
- **Compliance**: Ensures GDPR and privacy regulation adherence

**R3.2 - Re-Interview Exclusion Period**
- **Rule**: Participants are excluded if they participated in CXPulse surveys within the last **6 months**
- **Technical**: `@ReInterview = -6` months from sample date
- **Source**: `AND s.ExtractDate >= EOMONTH(DATEADD(MONTH, @ReInterview, @SampleDate))`
- **Business Rationale**: Prevents survey fatigue and ensures fresh perspectives

**R3.3 - Unique Participant Constraint**
- **Rule**: No participant can be selected multiple times within the same wave
- **Technical**: XDLid deduplication through LEFT JOIN exclusion
- **Source**: `LEFT JOIN Staging t ON c.XDLid = t.XDLid WHERE t.XDLid IS NULL`
- **Data Integrity**: Ensures statistical validity and prevents duplicate invitations

### 2.2 🚫 Domain-Level Restrictions

**R4.1 - Domain Participation Limits**
- **Rule**: Maximum of **60 participants** per email domain per wave
- **Technical**: `@MaxPerDomain INT = 60`
- **Source**: `WHERE c.drn <= @MaxPerDomain` after domain-based ranking
- **Business Rationale**: Prevents single organizations from dominating sample

**R4.2 - Domain Randomization**
- **Rule**: Within each domain, participants must be selected randomly
- **Technical**: `ROW_NUMBER() OVER (PARTITION BY p.DomainName ORDER BY NEWID())`
- **Purpose**: Ensures fair representation within organizational boundaries

---

## 🌍 SECTION 3: GEOGRAPHIC & SEGMENTATION RULES

### 3.1 🗺️ Area-Based Sampling Rules

**R5.1 - Area-Segment Proportional Allocation**
- **Rule**: Sample allocation must follow predefined proportions stored in `conf_AreaSegmentProportions`
- **Technical**: Participants selected based on `p.Percentage * [Geographic Allocation] * [Source Mix]`
- **Source**: Complex calculation in Sampled CTE
- **Business Impact**: Ensures representative geographic and demographic distribution

**R5.2 - United States Special Handling**
- **Rule**: United States market receives distinct treatment in allocation calculations
- **Technical**: `CASE WHEN r.Area = 'United States' THEN @US_N ELSE @NonUS_N END`
- **Strategic Rationale**: Recognizes US market significance while maintaining global representation

**R5.3 - Multi-Dimensional Ranking**
- **Rule**: Participants are ranked using dual criteria:
  - **General Ranking**: By Area and SegmentGroup
  - **Source-Specific Ranking**: By Area, SegmentGroup, and SourceName
- **Technical**: Two separate ROW_NUMBER() functions in Ranked CTE
- **Purpose**: Enables precise source mix control within geographic segments

---

## 🏷️ SECTION 4: BRANDING & ROUTING RULES

### 4.1 🌐 Brand-Based Directory Assignment

**R6.1 - European Market Routing**
- **Rule**: Participants with BrandID 'MSFTExperienceEU' must be routed to European Qualtrics pool
- **Technical**: `WHEN 'MSFTExperienceEU' THEN @DirEU` (POOL_3ilhsaY8zBEpkXw)
- **Mailing List**: CG_eF1ExAeo6ptybC1
- **Compliance**: Ensures data residency and localization requirements

**R6.2 - Rest of World Routing**
- **Rule**: Participants with BrandID 'MSFTExperience' must be routed to global Qualtrics pool
- **Technical**: `WHEN 'MSFTExperience' THEN @DirROW` (POOL_1dbOiQ3WfeAFUqI)
- **Mailing List**: CG_1OUX47Qlh9fn9R2
- **Purpose**: Handles all non-European markets with unified routing

### 4.2 📊 Data Payload Management

**R7.1 - JSON Metadata Injection**
- **Rule**: Survey metadata must be dynamically injected into JSON payload before deployment
- **Required Fields**:
  - **SampleMonth**: Current wave identifier
  - **WaveType**: Survey classification type
- **Technical**: `JSON_MODIFY(JSON_MODIFY(r.JSONPayload, '$[0].SampleMonth', @WaveName), '$[0].WaveType', @WaveType)`
- **Purpose**: Ensures proper survey routing and response tracking

---

## 🔄 SECTION 5: DATA PROCESSING & WORKFLOW RULES

### 5.1 📋 Processing Sequence Rules

**R8.1 - Mandatory Processing Order**
- **Rule**: Candidate processing must follow strict sequence:
  1. **Population Processing**: Base data preparation
  2. **Candidate Processing**: Multi-source candidate preparation
  3. **Staging Process**: Final sample selection and deployment
- **Source**: sp_CXPulse_Process_Population → sp_CXPulse_Process_Candidates → sp_CXPulse_AddToStagingV3
- **Critical**: Sequence ensures data integrity and dependency resolution

**R8.2 - Source-Specific Processing**
- **Rule**: Each data source requires independent processing pipeline:
  - **MSX Pipeline**: sp_MSX_Candidates → sp_MSX_Candidates_Embedded → sp_MSX_Candidates_Payload
  - **VIVA Pipeline**: sp_VIVA_Candidates → sp_VIVA_Candidates_Embedded → sp_VIVA_Candidates_Payload
- **Quality Check**: Overlap validation between sources is mandatory
- **Source**: sp_CXPulse_Process_Candidates procedure

### 5.2 🧹 Data Quality & Validation Rules

**R9.1 - Permission Validation**
- **Rule**: No-permission-to-send records must be processed and tracked separately
- **Technical**: sp_UpdateNoPermissionToSend execution
- **Compliance**: Maintains opt-out and permission compliance

**R9.2 - Bounce-Back Management**
- **Rule**: Email bounce-backs must be processed to update participant eligibility
- **Technical**: sp_UpdateBounceBacks execution
- **Data Quality**: Prevents sending to invalid email addresses

**R9.3 - Source Overlap Prevention**
- **Rule**: System must validate and report any email overlap between MSX and VIVA sources
- **Technical**: Intersection query between VIVA_Candidates_Embedded and MSX_Candidates_Embedded
- **Data Integrity**: Ensures clean source separation

---

## 📊 SECTION 6: RESPONSE PROCESSING RULES

### 6.1 🎯 Response Collection Standards

**R10.1 - Response Source Validation**
- **Rule**: Only responses from approved sources are processed
- **Approved Sources**: 'VIVA', 'MSX'
- **Technical**: `WHERE r.SourceName IN ('VIVA', 'MSX')`
- **Quality Control**: Prevents unauthorized or test responses

**R10.2 - XDLid Requirement**
- **Rule**: Responses must have valid, non-empty XDLid for processing
- **Technical**: `AND r.XDLid <> ''`
- **Traceability**: Ensures response linkage to original participant

**R10.3 - Wave Type Filtering**
- **Rule**: Response processing must exclude pilot and test responses
- **Included Types**: 'CXPulse', 'CXPluse' (legacy), 'CXPulseQEI', or NULL/empty
- **Technical**: `WHERE NOT(WaveType IN ('CXPulse', 'CXPluse', 'CXPulseQEI', '') OR WaveType is NULL)`
- **Data Quality**: Maintains production response integrity

### 6.2 🔄 Response Transformation Rules

**R11.1 - Wide Format Conversion**
- **Rule**: JSON responses must be converted to wide columnar format for analysis
- **Technical**: ExtractJSONColumns_Object procedure execution
- **Purpose**: Enables traditional SQL analysis and reporting

**R11.2 - Metadata Cleanup**
- **Rule**: System-generated and provider metadata must be removed from analytical datasets
- **Removed Elements**: '_comment%', 'Provider%', 'Response' columns
- **Technical**: Dynamic column dropping based on pattern matching
- **Optimization**: Reduces dataset size and focuses on business-relevant data

### 6.3 📈 Response Enhancement Rules

**R12.1 - TPID Assignment Logic**
- **Rule**: Technical Point Identifier (TPID) assignment varies by source:
  - **VIVA Source**: Use SourceID1 as primary TPID
  - **MSX Source**: Use SourceID2 as primary TPID
- **Technical**: `IIF(SourceName = 'VIVA', SourceID1, IIF(SourceName = 'MSX', SourceID2, NULL))`
- **Business Value**: Enables technical contact identification and follow-up

**R12.2 - Sales ID Resolution**
- **Rule**: Microsoft Sales ID resolution follows source-specific logic:
  - **VIVA**: Use SourceID2, fallback to SourceID1 if empty
  - **MSX**: Use SourceID3, fallback to SourceID2 if empty
- **Purpose**: Links responses to sales representatives for account management

---

## 🔒 SECTION 7: SECURITY & COMPLIANCE RULES

### 7.1 🛡️ Data Protection Requirements

**R13.1 - Permission-Based Access**
- **Rule**: All survey invitations must respect CPM (Customer Permission Management) settings
- **Technical**: CPMPermissionToSend flag enforcement
- **Compliance**: GDPR, CCPA, and Microsoft privacy policy adherence

**R13.2 - Unsubscribe URL Management**
- **Rule**: Every survey invitation must include valid unsubscribe mechanism
- **Technical**: CPMUnsubscribeURL field population and validation
- **Legal Requirement**: Regulatory compliance for commercial communications

### 7.2 🌍 Regional Data Governance

**R14.1 - Data Residency Compliance**
- **Rule**: European participant data must be processed through EU-specific Qualtrics infrastructure
- **Technical**: EU BrandID routing to European DirectoryID and MailingListID
- **Compliance**: GDPR data residency and transfer requirements

**R14.2 - Cross-Border Data Rules**
- **Rule**: Non-EU participants use global infrastructure with appropriate safeguards
- **Purpose**: Balances operational efficiency with regulatory compliance

---

## 📊 SECTION 8: ANALYTICAL & REPORTING RULES

### 8.1 📈 Statistical Validity Requirements

**R15.1 - Sample Size Sufficiency**
- **Rule**: Total sample must maintain statistical power of 127,000 participants
- **Distribution**: Must be proportionally distributed across geographic and demographic segments
- **Quality Threshold**: Ensures representative insights with appropriate confidence intervals

**R15.2 - Randomization Requirements**
- **Rule**: All participant selection must use randomization (NEWID()) to prevent bias
- **Application**: Domain-level, area-level, and source-level randomization
- **Statistical Integrity**: Ensures unbiased, representative sampling

### 8.2 🎯 Segmentation Analysis Rules

**R16.1 - Multi-Dimensional Segmentation**
- **Rule**: Analysis must support segmentation by:
  - **Geographic**: Country, Area groupings
  - **Demographic**: SegmentGroup classifications
  - **Source**: VIVA vs MSX origin tracking
  - **Temporal**: Wave-based trend analysis
- **Purpose**: Enables comprehensive customer experience insights

**R16.2 - Longitudinal Tracking**
- **Rule**: System must maintain participant history for trend analysis while respecting re-interview exclusions
- **Balance**: Historical insights vs. survey fatigue prevention

---

## 🔄 SECTION 9: OPERATIONAL EXCELLENCE RULES

### 9.1 ⚡ Performance & Reliability Standards

**R17.1 - Index Management**
- **Rule**: Critical performance indexes must be created dynamically if missing
- **Required Indexes**: Wave-based, XDLid-based, and email-based indexes
- **Purpose**: Ensures consistent query performance regardless of system state

**R17.2 - Transaction Safety**
- **Rule**: All data modifications should support rollback and recovery
- **Current Gap**: Limited transaction management implementation
- **Improvement Needed**: Comprehensive TRY-CATCH and transaction control

### 9.2 📊 Monitoring & Alerting Rules

**R18.1 - Process Visibility**
- **Rule**: All critical processing steps must generate progress messages
- **Technical**: RAISERROR statements with step identification
- **Operations**: Enables monitoring and troubleshooting

**R18.2 - Summary Reporting**
- **Rule**: Each sampling process must generate summary statistics
- **Format**: Wave, SourceName, and count aggregations
- **Purpose**: Immediate validation of sampling results

---

## 🎯 SECTION 10: BUSINESS IMPACT & STRATEGIC RULES

### 10.1 💼 Customer Experience Strategy

**R19.1 - Microsoft-Wide Coverage**
- **Rule**: Survey system must capture feedback across all major Microsoft customer touchpoints
- **Implementation**: Multi-source integration (VIVA collaboration, MSX sales)
- **Strategic Value**: Comprehensive customer journey insights

**R19.2 - Account-Centric Approach**
- **Rule**: Survey design must support account-level analysis and follow-up
- **Technical**: TPID and Sales ID tracking for relationship management
- **Business Impact**: Enables targeted customer success interventions

### 10.2 🌍 Global Scale Operations

**R20.1 - Multi-Regional Support**
- **Rule**: System must operate effectively across all Microsoft global markets
- **Technical**: Region-specific routing and compliance management
- **Scale**: 127,000 participants across diverse geographic and cultural contexts

**R20.2 - Localization Requirements**
- **Rule**: Survey experience must respect local language, culture, and regulatory requirements
- **Implementation**: Country-specific routing, EU data residency, language preference tracking
- **Quality**: Ensures culturally appropriate and legally compliant survey experience

---

## ✅ CONCLUSION: BUSINESS RULES SUMMARY

The Microsoft CXPulse survey system operates under **20 core business rule categories** encompassing:

- **📊 Sample Management**: 127,000 participants with 33%/67% US/Global split
- **🎯 Source Integration**: 75%/25% VIVA/MSX allocation with sophisticated sampling
- **🚫 Exclusion Controls**: 6-month re-interview protection and domain limits (60/domain)
- **🌍 Global Compliance**: EU data residency and region-specific routing
- **📈 Quality Assurance**: Multi-stage validation and randomization requirements

These rules ensure **statistical validity**, **regulatory compliance**, **operational excellence**, and **strategic business value** while maintaining **customer privacy** and **survey quality** at enterprise scale.

**🎯 Strategic Value**: This comprehensive rule framework enables Microsoft to capture **representative**, **actionable**, and **compliant** customer feedback across its global ecosystem, supporting data-driven improvements in customer experience and business outcomes.
