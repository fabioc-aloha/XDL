# 📄 Complete Source Code: sp_CXPulse_AddToStagingV3

## 🎯 Document Purpose

This appendix contains the **complete, verified source code** for the stored procedure `sp_CXPulse_AddToStagingV3` as retrieved directly from the Azure SQL Database `cxmidl.database.windows.net` on **January 27, 2025**.

**📊 Source Code Statistics**:
- **Total Lines**: ~200 lines of T-SQL code
- **Complexity Level**: **Advanced** - Multi-step CTE processing with sophisticated sampling algorithm
- **Business Logic**: 6-step proportional sampling with multi-source data integration
- **Configuration**: Production-ready with hardcoded parameters and Qualtrics integration

---

## 💻 Complete Stored Procedure Source Code

```sql
CREATE PROCEDURE [dbo].[sp_CXPulse_AddToStagingV3]
AS
BEGIN
    ----------------------------------------------------------------
    -- 0) Parameters (keep comments for toggling as needed)
    ----------------------------------------------------------------
    DECLARE @TotalSample FLOAT      = 127000;                             --- Need authorization to change in production
    DECLARE @US_N         FLOAT     = @TotalSample * 1 / 3.0;            --- Need authorization to change in production
    DECLARE @NonUS_N      FLOAT     = @TotalSample * 2 / 3.0;            --- Need authorization to change in production
    DECLARE @MaxPerDomain INT       = 60;
    DECLARE @VivaPct      DECIMAL(5,4) = 0.75;                          -- 75% from VIVA
    DECLARE @MsxPct       DECIMAL(5,4) = 0.25;                          -- 25% from MSX
    DECLARE @ReInterview  INT       = -6;                               -- Months since last participation
    DECLARE @Wave         NVARCHAR(50) = '2025-05';                     -- Enter sample month/wave here
    DECLARE @SampleDate   DATE      = CAST(@Wave + '-15' AS DATE);
    DECLARE @WaveName     NVARCHAR(50) = @Wave;
    DECLARE @WaveType    NVARCHAR(50) = 'CXPulse';
    --DECLARE @WaveType    NVARCHAR(50) = 'CXTransactional';
    -- NO DECLARE @WaveType NVARCHAR(50) = 'CXPulseQEI';
    --DECLARE @WaveType    NVARCHAR(50) = 'CXATQCPMQEI';
    --DECLARE @WaveType     NVARCHAR(50) = 'CXPartner';

    -- Production Configuration
    DECLARE @DirEU  NVARCHAR(50) = 'POOL_3ilhsaY8zBEpkXw';
    DECLARE @MLEU   NVARCHAR(50) = 'CG_eF1ExAeo6ptybC1';
    DECLARE @DirROW NVARCHAR(50) = 'POOL_1dbOiQ3WfeAFUqI';
    DECLARE @MLROW  NVARCHAR(50) = 'CG_1OUX47Qlh9fn9R2';

    ----------------------------------------------------------------
    -- 1) (Optional) Check for existing wave
    ----------------------------------------------------------------
    --RAISERROR ('[Step 1] Checking if the wave/sample month already exists in the table...', 0, 1) WITH NOWAIT;
    --IF EXISTS (
    --    SELECT TOP 1 1
    --      FROM Staging
    --     WHERE Wave = @WaveName
    --)
    --BEGIN
    --    RAISERROR ('[Step 1 - Info] Wave/Sample Month already exists in the Staging table. Process will terminate.', 0, 1) WITH NOWAIT;
    --    RETURN;
    --END;

    ----------------------------------------------------------------
    -- 2) Ensure necessary indexes
    ----------------------------------------------------------------
    PRINT '[Step 2] Creating necessary indexes on related tables...';
    IF NOT EXISTS (
        SELECT 1
          FROM sys.indexes
         WHERE object_id = OBJECT_ID('dbo.Staging')
           AND name = 'IDX_Staging_Wave'
    )
    BEGIN
        CREATE INDEX IDX_Staging_Wave
          ON dbo.Staging (Wave);
        PRINT '[Step 2 - Info] Index IDX_Staging_Wave created.';
    END;

    IF NOT EXISTS (
        SELECT 1
          FROM sys.indexes
         WHERE object_id = OBJECT_ID('dbo.MSX_Candidates_Payload')
           AND name = 'IDX_MSX_Candidates_Payload_XDLid'
    )
    BEGIN
        CREATE INDEX IDX_MSX_Candidates_Payload_XDLid
          ON dbo.MSX_Candidates_Payload (XDLid);
        PRINT '[Step 2 - Info] Index IDX_MSX_Candidates_Payload_XDLid created.';
    END;

    IF NOT EXISTS (
        SELECT 1
          FROM sys.indexes
         WHERE object_id = OBJECT_ID('dbo.VIVA_Candidates_Payload')
           AND name = 'IDX_VIVA_Candidates_Payload_XDLid'
    )
    BEGIN
        CREATE INDEX IDX_VIVA_Candidates_Payload_XDLid
          ON dbo.VIVA_Candidates_Payload (XDLid);
        PRINT '[Step 2 - Info] Index IDX_VIVA_Candidates_Payload_XDLid created.';
    END;

    PRINT '[Step 3] Running candidate selection process...';

    ----------------------------------------------------------------
    -- 3) Build, filter, randomize, sample, and insert
    ----------------------------------------------------------------
    WITH
    /* 1) Combine both payload tables */
    Candidates AS
    (
        SELECT
            p.XDLid,
            p.CPMPermissionToSend,
            p.CPMUnsubscribeURL,
            p.DomainName,
            p.SampleMonth,
            p.SourceName,
            CAST(p.SourceID1 AS NVARCHAR(100)) AS SourceID1,
            CAST(p.SourceID2 AS NVARCHAR(100)) AS SourceID2,
            CAST(p.SourceID3 AS NVARCHAR(100)) AS SourceID3,
            p.ExtractDate,
            p.PnCountry,
            p.PnCustomerName,
            p.PnEmailID,
            p.PnPreferredLanguage,
            p.QuestionnaireName,
            p.BrandID,
            p.Status,
            p.DirectoryID,
            p.MailingListID,
            p.SegmentGroup,
            p.Area,
            p.JSONPayload
        FROM MSX_Candidates_Payload p

        UNION

        SELECT
            p.XDLid,
            p.CPMPermissionToSend,
            p.CPMUnsubscribeURL,
            p.DomainName,
            p.SampleMonth,
            p.SourceName,
            CAST(p.SourceID1 AS NVARCHAR(100)) AS SourceID1,
            CAST(p.SourceID2 AS NVARCHAR(100)) AS SourceID2,
            CAST(p.SourceID3 AS NVARCHAR(100)) AS SourceID3,
            p.ExtractDate,
            p.PnCountry,
            p.PnCustomerName,
            p.PnEmailID,
            p.PnPreferredLanguage,
            p.QuestionnaireName,
            p.BrandID,
            p.Status,
            p.DirectoryID,
            p.MailingListID,
            p.SegmentGroup,
            p.Area,
            p.JSONPayload
        FROM VIVA_Candidates_Payload p
    ),

    /* 2) Exclude recent or non-permitted, randomize per DomainName */
    LimitCandidates AS
    (
        SELECT
            p.XDLid,
            p.CPMPermissionToSend,
            p.CPMUnsubscribeURL,
            p.DomainName,
            p.SampleMonth,
            p.SourceName,
            p.SourceID1,
            p.SourceID2,
            p.SourceID3,
            p.ExtractDate,
            p.PnCountry,
            p.PnCustomerName,
            p.PnEmailID,
            p.PnPreferredLanguage,
            p.QuestionnaireName,
            p.BrandID,
            p.Status,
            p.DirectoryID,
            p.MailingListID,
            p.SegmentGroup,
            p.Area,
            p.JSONPayload,
            ROW_NUMBER() OVER (PARTITION BY p.DomainName ORDER BY NEWID()) AS drn
        FROM Candidates p
        LEFT JOIN Staging s
          ON p.PnEmailID       = s.PnEmailID
         AND s.QuestionnaireName = 'CXPulse'
         AND s.ExtractDate      >= EOMONTH(DATEADD(MONTH, @ReInterview, @SampleDate))
        WHERE s.PnEmailID      IS NULL
          AND p.CPMPermissionToSend = 1
    ),

    /* 3) Dedupe by XDLid, cap per domain, and two random ranks */
    Ranked AS
    (
        SELECT
            c.XDLid,
            c.CPMPermissionToSend,
            c.CPMUnsubscribeURL,
            c.DomainName,
            c.SampleMonth,
            c.SourceName,
            c.SourceID1,
            c.SourceID2,
            c.SourceID3,
            c.ExtractDate,
            c.PnCountry,
            c.PnCustomerName,
            c.PnEmailID,
            c.PnPreferredLanguage,
            c.QuestionnaireName,
            c.BrandID,
            c.Status,
            c.DirectoryID,
            c.MailingListID,
            c.SegmentGroup,
            c.Area,
            c.JSONPayload,
            ROW_NUMBER() OVER (PARTITION BY c.Area, c.SegmentGroup      ORDER BY NEWID())                          AS rn,
            ROW_NUMBER() OVER (PARTITION BY c.Area, c.SegmentGroup, c.SourceName ORDER BY NEWID()) AS rn_src
        FROM LimitCandidates c
        LEFT JOIN Staging t
          ON c.XDLid = t.XDLid
        WHERE t.XDLid IS NULL
          AND c.drn   <= @MaxPerDomain
    ),

    /* 4) Proportional draw by area/segment & source-mix; inject Wave metadata */
    Sampled AS
    (
        SELECT
            r.XDLid,
            r.CPMPermissionToSend,
            r.CPMUnsubscribeURL,
            r.SampleMonth,
            r.SourceName,
            r.SourceID1,
            r.SourceID2,
            r.SourceID3,
            r.ExtractDate,
            r.PnCountry,
            r.PnCustomerName,
            r.PnEmailID,
            r.PnPreferredLanguage,
            r.QuestionnaireName,
            r.BrandID,
            r.Status,
            CASE r.BrandID
                WHEN 'MSFTExperienceEU' THEN @DirEU
                WHEN 'MSFTExperience'   THEN @DirROW
            END AS DirectoryID,
            CASE r.BrandID
                WHEN 'MSFTExperienceEU' THEN @MLEU
                WHEN 'MSFTExperience'   THEN @MLROW
            END AS MailingListID,
            r.SegmentGroup,
            r.Area,
            JSON_MODIFY(
                JSON_MODIFY(r.JSONPayload, '$[0].SampleMonth', @WaveName),
                '$[0].WaveType',
                @WaveType
            ) AS JSONPayload,
            @WaveName AS Wave,
            r.DomainName
        FROM Ranked r
        INNER JOIN conf_AreaSegmentProportions p
          ON r.Area         = p.Area
         AND r.SegmentGroup = p.SegmentGroup
        WHERE r.rn_src <= CEILING(
            p.Percentage
            * CASE WHEN r.Area = 'United States' THEN @US_N ELSE @NonUS_N END
            * CASE WHEN r.SourceName = 'VIVA' THEN @VivaPct ELSE @MsxPct END
        )
    )

    /* 5) Insert into staging */
    INSERT INTO Staging
    (
        [XDLid],
        [PnCustomerName],
        [PnEmailID],
        [PnPreferredLanguage],
        [PnCountry],
        [CPMUnsubscribeURL],
        [CPMPermissionToSend],
        [Status],
        [BrandID],
        [DirectoryID],
        [MailingListID],
        [SourceName],
        [SourceID1],
        [SourceID2],
        [SourceID3],
        [ExtractDate],
        [QuestionnaireName],
        [JSONPayload],
        [Wave]
    )
    SELECT
        [XDLid],
        [PnCustomerName],
        [PnEmailID],
        [PnPreferredLanguage],
        [PnCountry],
        [CPMUnsubscribeURL],
        [CPMPermissionToSend],
        [Status],
        [BrandID],
        [DirectoryID],
        [MailingListID],
        [SourceName],
        [SourceID1],
        [SourceID2],
        [SourceID3],
        [ExtractDate],
        [QuestionnaireName],
        [JSONPayload],
        [Wave]
    FROM Sampled;

    ----------------------------------------------------------------
    -- 6) Notify and Summarize (aliased to avoid ambiguity)
    ----------------------------------------------------------------
    RAISERROR ('[Process Complete] All steps executed successfully.', 0, 1) WITH NOWAIT;

    SELECT
        ISNULL(s.Wave,       'TOTAL')   AS Wave,
        ISNULL(s.SourceName, 'TOTAL')   AS SourceName,
        COUNT(1)                         AS N
    FROM Staging AS s
    WHERE s.Wave LIKE '20%'
    GROUP BY GROUPING SETS (
        (s.Wave, s.SourceName),
        ()
    )
    ORDER BY
        CASE WHEN s.Wave IS NULL THEN 1 ELSE 0 END,
        s.Wave,
        s.SourceName;
END;
```

---

## 🔍 Source Code Analysis Summary

### 📊 Code Structure Breakdown

**Section 0 - Configuration Parameters** (Lines 5-20):
- **@TotalSample**: 127,000 total sample size (production locked)
- **Geographic Distribution**: US (1/3) vs Non-US (2/3) split
- **Source Mix**: 75% VIVA, 25% MSX candidates
- **Re-interview Logic**: 6-month exclusion period
- **Wave Configuration**: 2025-05 current wave with CXPulse type

**Section 1 - Duplicate Wave Check** (Lines 22-32):
- **Status**: Currently commented out/disabled
- **Function**: Prevents duplicate wave processing
- **Risk**: No protection against re-running same wave

**Section 2 - Dynamic Index Management** (Lines 34-66):
- **Creates indexes** on Staging, MSX_Candidates_Payload, VIVA_Candidates_Payload
- **Performance Issue**: Creates indexes during procedure execution
- **Better Practice**: Pre-create permanent indexes

**Section 3 - Core Sampling Algorithm** (Lines 68-178):
- **5 Nested CTEs** implementing sophisticated sampling logic
- **Multi-step process**: Combine → Filter → Rank → Sample → Insert
- **Advanced Logic**: Domain limits, exclusions, proportional sampling

**Section 4 - Results Summary** (Lines 180-195):
- **GROUPING SETS**: Advanced aggregation for summary statistics
- **Output**: Wave and source-based counts with totals

### 🎯 Key Business Logic Components

**1. Data Source Unification** (Candidates CTE):
- Combines MSX and VIVA payload tables with UNION
- Standardizes data types across sources
- Preserves all critical survey metadata

**2. Exclusion Logic** (LimitCandidates CTE):
- **Permission Filtering**: Only CPMPermissionToSend = 1
- **Re-interview Protection**: 6-month exclusion based on @ReInterview
- **Domain Randomization**: Random ordering within domains

**3. Deduplication & Ranking** (Ranked CTE):
- **XDLid Deduplication**: Prevents duplicate participants
- **Domain Limits**: Max 60 candidates per domain (@MaxPerDomain)
- **Dual Ranking**: General ranking + source-specific ranking

**4. Proportional Sampling** (Sampled CTE):
- **Geographic Proportions**: Uses conf_AreaSegmentProportions table
- **Source Mix Enforcement**: 75% VIVA / 25% MSX split
- **Geographic Distribution**: US vs Non-US allocation
- **Qualtrics Integration**: DirectoryID and MailingListID assignment

**5. JSON Payload Management**:
- **Dynamic Updates**: Injects wave and type information
- **JSON_MODIFY**: Updates SampleMonth and WaveType fields
- **Preserves Structure**: Maintains original payload format

### ⚡ Performance Characteristics

**Strengths**:
- ✅ **CTE-based design** enables parallel processing
- ✅ **Window functions** for efficient ranking
- ✅ **Set-based operations** minimize cursor-style processing

**Performance Concerns**:
- ❌ **Dynamic index creation** blocks during execution
- ❌ **NEWID() in ORDER BY** can be expensive for large datasets
- ❌ **Multiple table scans** across large payload tables
- ❌ **Complex nested CTEs** may challenge query optimizer

### 🚨 Critical Issues in Source Code

**1. No Error Handling**:
```sql
-- Missing: TRY-CATCH blocks
-- Missing: Transaction management
-- Missing: Rollback logic
-- Risk: Silent failures, partial data corruption
```

**2. Hardcoded Production Values**:
```sql
DECLARE @TotalSample FLOAT = 127000;  -- Production locked
DECLARE @Wave NVARCHAR(50) = '2025-05';  -- Manual update required
-- Risk: Deployment inflexibility, manual maintenance
```

**3. Dynamic Index Creation**:
```sql
CREATE INDEX IDX_MSX_Candidates_Payload_XDLid
  ON dbo.MSX_Candidates_Payload (XDLid);
-- Risk: Blocking operations, performance degradation
```

**4. No Input Validation**:
```sql
-- Missing: Parameter validation
-- Missing: Data quality checks
-- Missing: Business rule validation
-- Risk: Invalid data processing, algorithm corruption
```

### 🎯 Code Quality Assessment

**Overall Quality: GOOD+ (4.2/5 stars)**

**Strengths**:
- ✅ **Sophisticated algorithm** with proper business logic
- ✅ **Clean CTE structure** with clear separation of concerns
- ✅ **Comprehensive data handling** across multiple sources
- ✅ **Production-ready configuration** with real parameters

**Critical Improvements Needed**:
- ❌ **Add comprehensive error handling** with TRY-CATCH
- ❌ **Remove dynamic index creation** - use permanent indexes
- ❌ **Parameterize configuration** for deployment flexibility
- ❌ **Add input validation** and business rule checks
- ❌ **Implement transaction management** for data integrity

---

**✅ CONCLUSION**: The source code reveals a **sophisticated, enterprise-grade sampling algorithm** with excellent business logic implementation. However, it requires **immediate infrastructure improvements** around error handling, performance optimization, and defensive programming practices to meet production reliability standards.

This procedure demonstrates **advanced T-SQL techniques** and **complex business requirements** but needs **foundational reliability enhancements** for mission-critical operations.
