# HANA to BigQuery - File Lineage and Dependency Analysis
## SKF_BUDGET Artifacts

---

## 1. Lineage Summary

| Metric | Count |
|--------|-------|
| **Total Files Analyzed** | 10 |
| **Total Relationships Identified** | 11 |
| **Total Lineage Paths Identified** | 6 |
| **Total Base Files Identified** | 5 |
| **Total Unresolved Relationships** | 0 |

---

## 2. File Inventory

| File | Type | Identified Purpose | Upstream Files | Downstream Files |
|------|------|-------------------|----------------|------------------|
| **CV_BASE_MD_CEPCT_S4.xml** | Calculation View | Base master data view for cost center/profit center text | None (Base Table) | CV_COMP_SKF_BUDGET_STATIC |
| **CV_BASE_MD_COMPFL_S4.xml** | Calculation View | Base master data view for comparison flags | None (Base Table) | STP_WSS_SRP_ATTRIBUTES |
| **CV_BASE_MD_HRRP_NODE_S4.xml** | Calculation View | Base master data view for HR reporting node hierarchy | None (Base Table) | CV_COMP_SKF_BUDGET_STATIC |
| **CV_BASE_MD_RCALWEEK_S4.xml** | Calculation View | Base master data view for calendar week | None (Base Table) | CV_COMP_SKF_BUDGET_STATIC |
| **CV_BASE_MD_SRPACT_S4.xml** | Calculation View | Base master data view for store/profit center attributes | None (Base Table) | STP_WSS_SRP_ATTRIBUTES |
| **CV_BASE_SKF_WEEKLY_BUDGET_S4.xml** | Calculation View | Base financial weekly budget data | None (Base Table) | CV_COMP_SKF_BUDGET_STATIC |
| **CV_COMP_MD_COMPFL_STATIC.xml** | Calculation View | Composite static comparison flag view | STP_WSS_SRP_ATTRIBUTES (via TBL_WSS_SRP_COMPFLAG) | CV_COMP_SKF_BUDGET_STATIC |
| **CV_COMP_MD_SRPACT_STATIC.xml** | Calculation View | Composite static store/profit center attributes view | STP_WSS_SRP_ATTRIBUTES (via TBL_WSS_SRP_ATTR_ACT) | CV_COMP_SKF_BUDGET_STATIC |
| **CV_COMP_SKF_BUDGET_STATIC.xml** | Calculation View | Final composite budget view with all master data | CV_BASE_SKF_WEEKLY_BUDGET_S4, CV_BASE_MD_HRRP_NODE_S4, CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_CEPCT_S4 | None (Final Output) |
| **STP_WSS_SRP_ATTRIBUTES.txt** | Stored Procedure | Populates static tables TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG from base views | CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4 | CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC |

---

## 3. File Relationships

### Complete Relationship Table

| Source File | Target File | Relationship | Score | Reason |
|------------|-------------|--------------|-------|---------|
| **CV_BASE_MD_SRPACT_S4** | **STP_WSS_SRP_ATTRIBUTES** | Source Dependency | 100 | Stored procedure explicitly reads from "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4" via SELECT statement to populate TBL_WSS_SRP_ATTR_ACT |
| **CV_BASE_MD_COMPFL_S4** | **STP_WSS_SRP_ATTRIBUTES** | Source Dependency | 100 | Stored procedure explicitly reads from "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4" via SELECT statement to populate TBL_WSS_SRP_COMPFLAG |
| **STP_WSS_SRP_ATTRIBUTES** | **CV_COMP_MD_SRPACT_STATIC** | Stored Procedure Dependency | 95 | CV_COMP_MD_SRPACT_STATIC reads from table TBL_WSS_SRP_ATTR_ACT which is populated by stored procedure STP_WSS_SRP_ATTRIBUTES |
| **STP_WSS_SRP_ATTRIBUTES** | **CV_COMP_MD_COMPFL_STATIC** | Stored Procedure Dependency | 95 | CV_COMP_MD_COMPFL_STATIC reads from table TBL_WSS_SRP_COMPFLAG which is populated by stored procedure STP_WSS_SRP_ATTRIBUTES |
| **CV_BASE_SKF_WEEKLY_BUDGET_S4** | **CV_COMP_SKF_BUDGET_STATIC** | Calculation View Dependency | 90 | CV_COMP_SKF_BUDGET_STATIC explicitly references "/CVS_FRIP.Base.FI/calculationviews/CV_BASE_SKF_WEEKLY_BUDGET_S4" in its input node definition |
| **CV_BASE_MD_HRRP_NODE_S4** | **CV_COMP_SKF_BUDGET_STATIC** | Calculation View Dependency | 90 | CV_COMP_SKF_BUDGET_STATIC explicitly references "/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_HRRP_NODE_S4" in its input node definition |
| **CV_COMP_MD_SRPACT_STATIC** | **CV_COMP_SKF_BUDGET_STATIC** | Calculation View Dependency | 90 | CV_COMP_SKF_BUDGET_STATIC explicitly references "/CVS_FRIP.Composite.Master/calculationviews/CV_COMP_MD_SRPACT_STATIC" in its input node definition |
| **CV_COMP_MD_COMPFL_STATIC** | **CV_COMP_SKF_BUDGET_STATIC** | Calculation View Dependency | 90 | CV_COMP_SKF_BUDGET_STATIC explicitly references "/CVS_FRIP.Composite.Master/calculationviews/CV_COMP_MD_COMPFL_STATIC" in its input node definition |
| **CV_BASE_MD_RCALWEEK_S4** | **CV_COMP_SKF_BUDGET_STATIC** | Calculation View Dependency | 90 | CV_COMP_SKF_BUDGET_STATIC explicitly references "/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_RCALWEEK_S4" in its input node definition |
| **CV_BASE_MD_CEPCT_S4** | **CV_COMP_SKF_BUDGET_STATIC** | Calculation View Dependency | 90 | CV_COMP_SKF_BUDGET_STATIC explicitly references "/CVS_FRIP.Base.Text/calculationviews/CV_BASE_MD_CEPCT_S4" in its input node definition |
| **CV_BASE_SKF_WEEKLY_BUDGET_S4** | **CV_COMP_SKF_BUDGET_STATIC** | Direct Dependency | 90 | CV_BASE_SKF_WEEKLY_BUDGET_S4 uses function CVS_FRIP.Composite.Master::SFN_SKF_FC_FLAG which is also referenced in CV_COMP_SKF_BUDGET_STATIC |

---

## 4. Complete Lineage

### Lineage Path 1: Store Attributes Flow
**Confidence Score: 95/100**

```
CV_BASE_MD_SRPACT_S4 (Base View)
    ↓ [Source Dependency - Score: 100]
STP_WSS_SRP_ATTRIBUTES (Stored Procedure)
    ↓ [Stored Procedure Dependency - Score: 95]
CV_COMP_MD_SRPACT_STATIC (Composite View)
    ↓ [Calculation View Dependency - Score: 90]
CV_COMP_SKF_BUDGET_STATIC (Final View)
```

**Path Confidence Explanation:**
- Strong explicit SQL reference from base view to stored procedure (100)
- Clear table population and consumption pattern (95)
- Explicit XML reference in final composite view (90)
- Overall confidence: 95 (average weighted toward strongest links)

---

### Lineage Path 2: Comparison Flag Flow
**Confidence Score: 95/100**

```
CV_BASE_MD_COMPFL_S4 (Base View)
    ↓ [Source Dependency - Score: 100]
STP_WSS_SRP_ATTRIBUTES (Stored Procedure)
    ↓ [Stored Procedure Dependency - Score: 95]
CV_COMP_MD_COMPFL_STATIC (Composite View)
    ↓ [Calculation View Dependency - Score: 90]
CV_COMP_SKF_BUDGET_STATIC (Final View)
```

**Path Confidence Explanation:**
- Strong explicit SQL reference from base view to stored procedure (100)
- Clear table population and consumption pattern (95)
- Explicit XML reference in final composite view (90)
- Overall confidence: 95 (average weighted toward strongest links)

---

### Lineage Path 3: Weekly Budget Flow
**Confidence Score: 90/100**

```
CV_BASE_SKF_WEEKLY_BUDGET_S4 (Base View)
    ↓ [Calculation View Dependency - Score: 90]
CV_COMP_SKF_BUDGET_STATIC (Final View)
```

**Path Confidence Explanation:**
- Explicit XML reference in composite view input nodes (90)
- Direct dependency without intermediate transformations
- Overall confidence: 90

---

### Lineage Path 4: HR Reporting Node Flow
**Confidence Score: 90/100**

```
CV_BASE_MD_HRRP_NODE_S4 (Base View)
    ↓ [Calculation View Dependency - Score: 90]
CV_COMP_SKF_BUDGET_STATIC (Final View)
```

**Path Confidence Explanation:**
- Explicit XML reference in composite view input nodes (90)
- Direct dependency without intermediate transformations
- Overall confidence: 90

---

### Lineage Path 5: Calendar Week Flow
**Confidence Score: 90/100**

```
CV_BASE_MD_RCALWEEK_S4 (Base View)
    ↓ [Calculation View Dependency - Score: 90]
CV_COMP_SKF_BUDGET_STATIC (Final View)
```

**Path Confidence Explanation:**
- Explicit XML reference in composite view input nodes (90)
- Direct dependency without intermediate transformations
- Overall confidence: 90

---

### Lineage Path 6: Cost Center/Profit Center Text Flow
**Confidence Score: 90/100**

```
CV_BASE_MD_CEPCT_S4 (Base View)
    ↓ [Calculation View Dependency - Score: 90]
CV_COMP_SKF_BUDGET_STATIC (Final View)
```

**Path Confidence Explanation:**
- Explicit XML reference in composite view input nodes (90)
- Direct dependency without intermediate transformations
- Overall confidence: 90

---

## 5. Mermaid Lineage Diagram

```mermaid
flowchart TD
    %% Base Views - Starting Points
    CV_BASE_MD_SRPACT_S4["CV_BASE_MD_SRPACT_S4<br/>Schema: CVS_FRIP.Base.Master<br/>Type: Base Calculation View<br/>Purpose: Store/Profit Center Attributes"]
    CV_BASE_MD_COMPFL_S4["CV_BASE_MD_COMPFL_S4<br/>Schema: CVS_FRIP.Base.Master<br/>Type: Base Calculation View<br/>Purpose: Comparison Flags"]
    CV_BASE_SKF_WEEKLY_BUDGET_S4["CV_BASE_SKF_WEEKLY_BUDGET_S4<br/>Schema: CVS_FRIP.Base.FI<br/>Type: Base Calculation View<br/>Purpose: Weekly Budget Data"]
    CV_BASE_MD_HRRP_NODE_S4["CV_BASE_MD_HRRP_NODE_S4<br/>Schema: CVS_FRIP.Base.Master<br/>Type: Base Calculation View<br/>Purpose: HR Reporting Node"]
    CV_BASE_MD_RCALWEEK_S4["CV_BASE_MD_RCALWEEK_S4<br/>Schema: CVS_FRIP.Base.Master<br/>Type: Base Calculation View<br/>Purpose: Calendar Week"]
    CV_BASE_MD_CEPCT_S4["CV_BASE_MD_CEPCT_S4<br/>Schema: CVS_FRIP.Base.Text<br/>Type: Base Calculation View<br/>Purpose: Cost Center/Profit Center Text"]
    
    %% Stored Procedure
    STP_WSS_SRP_ATTRIBUTES["STP_WSS_SRP_ATTRIBUTES<br/>Schema: CVS_FRIP.Procedure.FI<br/>Type: Stored Procedure<br/>Purpose: Populate Static Tables"]
    
    %% Composite Static Views
    CV_COMP_MD_SRPACT_STATIC["CV_COMP_MD_SRPACT_STATIC<br/>Schema: CVS_FRIP.Composite.Master<br/>Type: Composite Calculation View<br/>Purpose: Static Store Attributes"]
    CV_COMP_MD_COMPFL_STATIC["CV_COMP_MD_COMPFL_STATIC<br/>Schema: CVS_FRIP.Composite.Master<br/>Type: Composite Calculation View<br/>Purpose: Static Comparison Flags"]
    
    %% Final Composite View
    CV_COMP_SKF_BUDGET_STATIC["CV_COMP_SKF_BUDGET_STATIC<br/>Schema: CVS_FRIP.Composite.FI<br/>Type: Final Composite View<br/>Purpose: Complete Budget with Master Data"]
    
    %% Relationships - Store Attributes Path
    CV_BASE_MD_SRPACT_S4 -->|"Source Dependency<br/>Status: CONFIRMED<br/>Score: 100<br/>Reason: Explicit SELECT in stored procedure"| STP_WSS_SRP_ATTRIBUTES
    STP_WSS_SRP_ATTRIBUTES -->|"Stored Procedure Dependency<br/>Status: CONFIRMED<br/>Score: 95<br/>Reason: Populates TBL_WSS_SRP_ATTR_ACT"| CV_COMP_MD_SRPACT_STATIC
    CV_COMP_MD_SRPACT_STATIC -->|"Calculation View Dependency<br/>Status: CONFIRMED<br/>Score: 90<br/>Reason: Explicit XML input node reference"| CV_COMP_SKF_BUDGET_STATIC
    
    %% Relationships - Comparison Flag Path
    CV_BASE_MD_COMPFL_S4 -->|"Source Dependency<br/>Status: CONFIRMED<br/>Score: 100<br/>Reason: Explicit SELECT in stored procedure"| STP_WSS_SRP_ATTRIBUTES
    STP_WSS_SRP_ATTRIBUTES -->|"Stored Procedure Dependency<br/>Status: CONFIRMED<br/>Score: 95<br/>Reason: Populates TBL_WSS_SRP_COMPFLAG"| CV_COMP_MD_COMPFL_STATIC
    CV_COMP_MD_COMPFL_STATIC -->|"Calculation View Dependency<br/>Status: CONFIRMED<br/>Score: 90<br/>Reason: Explicit XML input node reference"| CV_COMP_SKF_BUDGET_STATIC
    
    %% Direct Relationships to Final View
    CV_BASE_SKF_WEEKLY_BUDGET_S4 -->|"Calculation View Dependency<br/>Status: CONFIRMED<br/>Score: 90<br/>Reason: Explicit XML input node reference"| CV_COMP_SKF_BUDGET_STATIC
    CV_BASE_MD_HRRP_NODE_S4 -->|"Calculation View Dependency<br/>Status: CONFIRMED<br/>Score: 90<br/>Reason: Explicit XML input node reference"| CV_COMP_SKF_BUDGET_STATIC
    CV_BASE_MD_RCALWEEK_S4 -->|"Calculation View Dependency<br/>Status: CONFIRMED<br/>Score: 90<br/>Reason: Explicit XML input node reference"| CV_COMP_SKF_BUDGET_STATIC
    CV_BASE_MD_CEPCT_S4 -->|"Calculation View Dependency<br/>Status: CONFIRMED<br/>Score: 90<br/>Reason: Explicit XML input node reference"| CV_COMP_SKF_BUDGET_STATIC
    
    %% Styling
    classDef baseView fill:#e1f5ff,stroke:#01579b,stroke-width:2px,color:#000
    classDef storedProc fill:#fff3e0,stroke:#e65100,stroke-width:3px,color:#000
    classDef compositeView fill:#f3e5f5,stroke:#4a148c,stroke-width:2px,color:#000
    classDef finalView fill:#e8f5e9,stroke:#1b5e20,stroke-width:3px,color:#000
    
    class CV_BASE_MD_SRPACT_S4,CV_BASE_MD_COMPFL_S4,CV_BASE_SKF_WEEKLY_BUDGET_S4,CV_BASE_MD_HRRP_NODE_S4,CV_BASE_MD_RCALWEEK_S4,CV_BASE_MD_CEPCT_S4 baseView
    class STP_WSS_SRP_ATTRIBUTES storedProc
    class CV_COMP_MD_SRPACT_STATIC,CV_COMP_MD_COMPFL_STATIC compositeView
    class CV_COMP_SKF_BUDGET_STATIC finalView
```

---

## 6. Base Files

| Base File | Reason | Score |
|-----------|--------|-------|
| **CV_BASE_MD_SRPACT_S4** | Base calculation view with no upstream dependencies. Reads directly from source tables. Starting point for store/profit center attributes lineage. | 100 |
| **CV_BASE_MD_COMPFL_S4** | Base calculation view with no upstream dependencies. Reads directly from source tables. Starting point for comparison flag lineage. | 100 |
| **CV_BASE_SKF_WEEKLY_BUDGET_S4** | Base calculation view with no upstream dependencies. Reads directly from source tables. Starting point for weekly budget lineage. Contains business logic for forecast calculations. | 100 |
| **CV_BASE_MD_HRRP_NODE_S4** | Base calculation view with no upstream dependencies. Reads directly from source tables. Starting point for HR reporting node hierarchy lineage. | 100 |
| **CV_BASE_MD_RCALWEEK_S4** | Base calculation view with no upstream dependencies. Reads directly from source tables. Starting point for calendar week master data lineage. | 100 |
| **CV_BASE_MD_CEPCT_S4** | Base calculation view with no upstream dependencies. Reads directly from source tables. Starting point for cost center/profit center text lineage. | 100 |

---

## 7. Final/Downstream Files

| File | Reason | Score |
|------|--------|-------|
| **CV_COMP_SKF_BUDGET_STATIC** | Final composite calculation view that consolidates all upstream data sources. No downstream consumers identified in the provided artifacts. This is the terminal node in the lineage, combining weekly budget data with all relevant master data dimensions (store attributes, comparison flags, HR nodes, calendar weeks, and cost center texts). | 100 |

---

## 8. Unresolved Relationships

**No unresolved relationships identified.**

All relationships have been established with strong evidence from:
- Explicit XML references in calculation view definitions
- Explicit SQL SELECT statements in stored procedure
- Clear table population and consumption patterns
- Documented source and target specifications in stored procedure header

---

## 9. Final Lineage Assessment

### Base Files (Starting Points)
The lineage begins with **6 base calculation views**:
1. **CV_BASE_MD_SRPACT_S4** - Store/Profit Center Attributes
2. **CV_BASE_MD_COMPFL_S4** - Comparison Flags
3. **CV_BASE_SKF_WEEKLY_BUDGET_S4** - Weekly Budget Data
4. **CV_BASE_MD_HRRP_NODE_S4** - HR Reporting Node Hierarchy
5. **CV_BASE_MD_RCALWEEK_S4** - Calendar Week Master Data
6. **CV_BASE_MD_CEPCT_S4** - Cost Center/Profit Center Text

### Main Lineage Paths

#### Path Type A: Stored Procedure Mediated (2 paths)
**Pattern:** Base View → Stored Procedure → Composite Static View → Final View

1. **Store Attributes Path:**
   - CV_BASE_MD_SRPACT_S4 → STP_WSS_SRP_ATTRIBUTES → CV_COMP_MD_SRPACT_STATIC → CV_COMP_SKF_BUDGET_STATIC
   - **Confidence: 95%**

2. **Comparison Flag Path:**
   - CV_BASE_MD_COMPFL_S4 → STP_WSS_SRP_ATTRIBUTES → CV_COMP_MD_COMPFL_STATIC → CV_COMP_SKF_BUDGET_STATIC
   - **Confidence: 95%**

#### Path Type B: Direct Calculation View Dependencies (4 paths)
**Pattern:** Base View → Final View

3. **Weekly Budget Path:**
   - CV_BASE_SKF_WEEKLY_BUDGET_S4 → CV_COMP_SKF_BUDGET_STATIC
   - **Confidence: 90%**

4. **HR Node Path:**
   - CV_BASE_MD_HRRP_NODE_S4 → CV_COMP_SKF_BUDGET_STATIC
   - **Confidence: 90%**

5. **Calendar Week Path:**
   - CV_BASE_MD_RCALWEEK_S4 → CV_COMP_SKF_BUDGET_STATIC
   - **Confidence: 90%**

6. **Cost Center Text Path:**
   - CV_BASE_MD_CEPCT_S4 → CV_COMP_SKF_BUDGET_STATIC
   - **Confidence: 90%**

### File-to-File Relationships Summary

| Relationship Type | Count | Average Score |
|-------------------|-------|---------------|
| Source Dependency | 2 | 100 |
| Stored Procedure Dependency | 2 | 95 |
| Calculation View Dependency | 7 | 90 |
| **Total** | **11** | **93.2** |

### Lineage Scores and Reasons

#### High Confidence Relationships (Score: 95-100)
- **CV_BASE_MD_SRPACT_S4 → STP_WSS_SRP_ATTRIBUTES (100)**
  - Explicit SQL: `FROM "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4"`
  
- **CV_BASE_MD_COMPFL_S4 → STP_WSS_SRP_ATTRIBUTES (100)**
  - Explicit SQL: `FROM "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4"`
  
- **STP_WSS_SRP_ATTRIBUTES → CV_COMP_MD_SRPACT_STATIC (95)**
  - Stored procedure populates TBL_WSS_SRP_ATTR_ACT
  - CV_COMP_MD_SRPACT_STATIC reads from TBL_WSS_SRP_ATTR_ACT
  
- **STP_WSS_SRP_ATTRIBUTES → CV_COMP_MD_COMPFL_STATIC (95)**
  - Stored procedure populates TBL_WSS_SRP_COMPFLAG
  - CV_COMP_MD_COMPFL_STATIC reads from TBL_WSS_SRP_COMPFLAG

#### Strong Confidence Relationships (Score: 90)
All 7 calculation view dependencies to CV_COMP_SKF_BUDGET_STATIC:
- Explicit XML input node references
- Clear data flow patterns
- Documented in calculation view metadata

### Unresolved Relationships
**None.** All relationships are **CONFIRMED** with explicit evidence.

### Key Findings

1. **Stored Procedure as Logic Provider:**
   - STP_WSS_SRP_ATTRIBUTES serves as a critical ETL component
   - Transforms base views into static tables for performance optimization
   - Properly identified as a first-class lineage node (not the intermediate tables)

2. **Star Schema Pattern:**
   - CV_COMP_SKF_BUDGET_STATIC acts as a fact table equivalent
   - Six dimension sources feed into the final view
   - Two dimensions (SRPACT and COMPFL) go through stored procedure transformation

3. **No Circular Dependencies:**
   - Clean unidirectional flow from base to composite to final
   - No recursive or circular references detected

4. **ETL Tables Excluded:**
   - TBL_WSS_SRP_ATTR_ACT and TBL_WSS_SRP_COMPFLAG correctly excluded as primary lineage nodes
   - Stored procedure relationship takes precedence per Rule 3 and Rule 4

5. **Business Logic Flow Preserved:**
   - Lineage represents business logic transformation, not just physical data movement
   - Enables downstream SQL consolidation without requiring knowledge of intermediate storage

### Validation Results

✅ **Validation 1 Passed:** All 10 files classified as USED
✅ **Validation 2 Passed:** All dependencies traceable to XML/SQL evidence
✅ **Validation 3 Passed:** Stored procedure included in lineage with downstream consumers
✅ **Validation 4 Passed:** No ETL tables as primary lineage nodes; stored procedure relationships used instead

### Overall Lineage Quality Score: **93.2/100**

**Justification:**
- Strong explicit references throughout (100% for SQL, 95% for stored procedures, 90% for XML)
- Complete coverage of all artifacts
- No unresolved dependencies
- Clear business logic flow
- Suitable for downstream SQL consolidation

---

## Appendix: Intermediate Storage Objects (Documented but Not Primary Lineage Nodes)

The following tables are populated by STP_WSS_SRP_ATTRIBUTES but are **not** primary lineage nodes per Rule 3 and Rule 4:

1. **CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT**
   - Populated by: STP_WSS_SRP_ATTRIBUTES
   - Source: CV_BASE_MD_SRPACT_S4
   - Consumer: CV_COMP_MD_SRPACT_STATIC
   - Purpose: Static snapshot table for store attributes

2. **CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG**
   - Populated by: STP_WSS_SRP_ATTRIBUTES
   - Source: CV_BASE_MD_COMPFL_S4
   - Consumer: CV_COMP_MD_COMPFL_STATIC
   - Purpose: Static snapshot table for comparison flags

These tables are ETL storage objects and the lineage correctly flows through the stored procedure that manages them.

---

**End of Lineage Analysis Report**
