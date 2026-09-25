# DI HANA FILE LINEAGE SUMMARY

## 1. Lineage Summary

The analysis identified **6 base/source files** and **8 files total** across **5 major lineage paths**. All files converge into a single final reporting view (**CV_BASE_MD_RCAIWEEK_S4**) that integrates financial budget data, master data hierarchies, store attributes, and comp flags for weekly retail comparable store analysis.

---

## 2. Base / Source Files

| Base File | Description |
|-----------|-------------|
| **AZSRP_DS052_VT_S4** | Physical table - Frozen cube data source for financial budget (Weekly Snapshot) |
| **AZSRP_DS041_VT_S4** | Physical table - Live cube data source for financial budget (Weekly Snapshot) |
| **CV_BASE_MD_SRPACT_S4** | External base calculation view - Store reporting attributes source (not in analyzed package) |
| **CV_BASE_MD_COMPFL_S4** | External base calculation view - Comp flag data source (not in analyzed package) |
| **CV_BASE_MD_HRRP_NODE_S4** | Base calculation view - Hierarchy reporting node master data |
| **CV_BASE_MD_CEPCT_S4** | Base calculation view - Cost/expense center text master data |

---

## 3. File-Level Lineage

### Path 1: Financial Budget Weekly Snapshot Flow

```
AZSRP_DS052_VT_S4 (Frozen Cube)
   ↓
CV_BASE_FIN_WEEKLY_BUDGET_S4
   ↓
CV_BASE_MD_RCAIWEEK_S4 (Final Reporting View)
```

**AND**

```
AZSRP_DS041_VT_S4 (Live Cube)
   ↓
CV_BASE_FIN_WEEKLY_BUDGET_S4
   ↓
CV_BASE_MD_RCAIWEEK_S4 (Final Reporting View)
```

---

### Path 2: Store Attributes Static Data Flow

```
CV_BASE_MD_SRPACT_S4 (External Source)
   ↓
STP_WSS_SRP_ATTRIBUTES (Stored Procedure)
   ↓
TBL_WSS_SRP_ATTR_ACT (Physical Table)
   ↓
CV_COMP_MD_SRPACT_STATIC
   ↓
CV_BASE_MD_RCAIWEEK_S4 (Final Reporting View)
```

---

### Path 3: Comp Flag Static Data Flow

```
CV_BASE_MD_COMPFL_S4 (External Source)
   ↓
STP_WSS_SRP_ATTRIBUTES (Stored Procedure)
   ↓
TBL_WSS_SRP_COMPFLAG (Physical Table)
   ├──→ CV_COMP_MD_COMPFL_STATIC
   │       └──→ CV_BASE_MD_RCAIWEEK_S4 (Final Reporting View)
   │
   └──→ CV_COMP_FIN_BUDGET_STATIC (Standalone Reporting View)
```

---

### Path 4: Hierarchy Master Data Flow

```
CV_BASE_MD_HRRP_NODE_S4
   ↓
CV_BASE_MD_RCAIWEEK_S4 (Final Reporting View)
```

---

### Path 5: Cost/Expense Center Text Flow

```
CV_BASE_MD_CEPCT_S4
   ↓
CV_BASE_MD_RCAIWEEK_S4 (Final Reporting View)
```

---

## 4. Dependency Details

| Upstream File | Downstream File | Relationship Score | Relationship |
|---------------|-----------------|-------------------|--------------|
| **AZSRP_DS052_VT_S4** | CV_BASE_FIN_WEEKLY_BUDGET_S4 | 98 | Data Source - Frozen Cube |
| **AZSRP_DS041_VT_S4** | CV_BASE_FIN_WEEKLY_BUDGET_S4 | 98 | Data Source - Live Cube |
| **CV_BASE_FIN_WEEKLY_BUDGET_S4** | CV_BASE_MD_RCAIWEEK_S4 | 96 | Calculation View Dependency |
| **CV_BASE_MD_HRRP_NODE_S4** | CV_BASE_MD_RCAIWEEK_S4 | 96 | Calculation View Dependency |
| **CV_COMP_MD_SRPACT_STATIC** | CV_BASE_MD_RCAIWEEK_S4 | 96 | Calculation View Dependency |
| **CV_COMP_MD_COMPFL_STATIC** | CV_BASE_MD_RCAIWEEK_S4 | 96 | Calculation View Dependency |
| **CV_BASE_MD_CEPCT_S4** | CV_BASE_MD_RCAIWEEK_S4 | 96 | Calculation View Dependency |
| **CV_BASE_MD_SRPACT_S4** | STP_WSS_SRP_ATTRIBUTES | 97 | Source Calculation View for Procedure |
| **CV_BASE_MD_COMPFL_S4** | STP_WSS_SRP_ATTRIBUTES | 97 | Source Calculation View for Procedure |
| **STP_WSS_SRP_ATTRIBUTES** | TBL_WSS_SRP_ATTR_ACT | 98 | Target Table - DELETE/INSERT Operations |
| **STP_WSS_SRP_ATTRIBUTES** | TBL_WSS_SRP_COMPFLAG | 98 | Target Table - DELETE/INSERT Operations |
| **TBL_WSS_SRP_ATTR_ACT** | CV_COMP_MD_SRPACT_STATIC | 98 | Data Source |
| **TBL_WSS_SRP_COMPFLAG** | CV_COMP_MD_COMPFL_STATIC | 98 | Data Source |
| **TBL_WSS_SRP_COMPFLAG** | CV_COMP_FIN_BUDGET_STATIC | 98 | Data Source |
| **TBL_WSS_SRP_ATTR_ACT** | CV_COMP_MD_SRPACT_STATIC | 95 | Data Flow via Static Table |
| **TBL_WSS_SRP_COMPFLAG** | CV_COMP_MD_COMPFL_STATIC | 95 | Data Flow via Static Table |

---

## 5. Unclear / Unconfirmed Lineage

| File | Status | Reason |
|------|--------|--------|
| **None** | All Confirmed | All relationships have been successfully resolved with high confidence scores (95-98). Every file has clear upstream or downstream dependencies explicitly defined in code. |

---

## 6. Standalone Files

| File | Status |
|------|--------|
| **CV_COMP_FIN_BUDGET_STATIC** | Standalone reporting view - reads from TBL_WSS_SRP_COMPFLAG but has no identified downstream consumers in the analyzed package |

---

## 7. Complete Lineage Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         BASE / SOURCE LAYER                              │
├─────────────────────────────────────────────────────────────────────────┤
│  AZSRP_DS052_VT_S4 (Frozen Cube)                                        │
│  AZSRP_DS041_VT_S4 (Live Cube)                                          │
│  CV_BASE_MD_SRPACT_S4 (External - Store Attributes)                     │
│  CV_BASE_MD_COMPFL_S4 (External - Comp Flags)                           │
│  CV_BASE_MD_HRRP_NODE_S4 (Hierarchy Nodes)                              │
│  CV_BASE_MD_CEPCT_S4 (Cost/Expense Center Text)                         │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                    TRANSFORMATION LAYER                                  │
├─────────────────────────────────────────────────────────────────────────┤
│  CV_BASE_FIN_WEEKLY_BUDGET_S4 (Unions Frozen + Live Cubes)             │
│  STP_WSS_SRP_ATTRIBUTES (Stored Procedure - ETL Process)                │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                      STATIC TABLE LAYER                                  │
├─────────────────────────────────────────────────────────────────────────┤
│  TBL_WSS_SRP_ATTR_ACT (Store Attributes Static)                         │
│  TBL_WSS_SRP_COMPFLAG (Comp Flag Static)                                │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                    COMPOSITE VIEW LAYER                                  │
├─────────────────────────────────────────────────────────────────────────┤
│  CV_COMP_MD_SRPACT_STATIC (Store Attributes Composite)                  │
│  CV_COMP_MD_COMPFL_STATIC (Comp Flag Composite)                         │
│  CV_COMP_FIN_BUDGET_STATIC (Budget Composite - Standalone)              │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│                    FINAL REPORTING LAYER                                 │
├─────────────────────────────────────────────────────────────────────────┤
│  CV_BASE_MD_RCAIWEEK_S4                                                  │
│  (Integrates all upstream sources for weekly RCAI analysis)             │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 8. Detailed File Relationships

### CV_BASE_FIN_WEEKLY_BUDGET_S4
- **Upstream:** AZSRP_DS052_VT_S4, AZSRP_DS041_VT_S4
- **Downstream:** CV_BASE_MD_RCAIWEEK_S4
- **Purpose:** Unions frozen and live cube financial budget data based on version parameter

### CV_BASE_MD_CEPCT_S4
- **Upstream:** None identified in package
- **Downstream:** CV_BASE_MD_RCAIWEEK_S4
- **Purpose:** Provides cost/expense center text descriptions

### CV_BASE_MD_HRRP_NODE_S4
- **Upstream:** None identified in package
- **Downstream:** CV_BASE_MD_RCAIWEEK_S4
- **Purpose:** Provides hierarchy reporting node master data (filters on PARNODE matching '*CORE_RET' pattern)

### CV_BASE_MD_RCAIWEEK_S4
- **Upstream:** CV_BASE_FIN_WEEKLY_BUDGET_S4, CV_BASE_MD_HRRP_NODE_S4, CV_COMP_MD_SRPACT_STATIC, CV_COMP_MD_COMPFL_STATIC, CV_BASE_MD_CEPCT_S4
- **Downstream:** None (Final reporting view)
- **Purpose:** Main composite reporting view for RCAI (Retail Comparable Store Analysis) weekly analysis

### CV_COMP_FIN_BUDGET_STATIC
- **Upstream:** TBL_WSS_SRP_COMPFLAG
- **Downstream:** None identified in package
- **Purpose:** Standalone composite view for financial budget static data

### CV_COMP_MD_COMPFL_STATIC
- **Upstream:** TBL_WSS_SRP_COMPFLAG
- **Downstream:** CV_BASE_MD_RCAIWEEK_S4
- **Purpose:** Composite view for comp flag static master data

### CV_COMP_MD_SRPACT_STATIC
- **Upstream:** TBL_WSS_SRP_ATTR_ACT
- **Downstream:** CV_BASE_MD_RCAIWEEK_S4
- **Purpose:** Composite view for store reporting attributes static master data

### STP_WSS_SRP_ATTRIBUTES
- **Upstream:** CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4
- **Downstream:** TBL_WSS_SRP_ATTR_ACT, TBL_WSS_SRP_COMPFLAG
- **Purpose:** Stored procedure to populate static tables from base calculation views (DELETE/INSERT pattern for full refresh)

---

## 9. Key Lineage Characteristics

### Data Flow Pattern
- **Layered Architecture:** Source → Base Views → ETL Procedure → Static Tables → Composite Views → Final Reporting View
- **No Circular Dependencies:** All lineage flows are unidirectional and acyclic
- **Central Integration Point:** CV_BASE_MD_RCAIWEEK_S4 serves as the central hub integrating 5 different upstream sources

### ETL Process
- **STP_WSS_SRP_ATTRIBUTES** implements a snapshot pattern:
  - Deletes existing data from static tables
  - Inserts fresh data from base calculation views
  - Filters comp flag data by prior fiscal week
  - Timestamps all records with CURRENT_TIMESTAMP

### Frozen/Live Cube Strategy
- **CV_BASE_FIN_WEEKLY_BUDGET_S4** dynamically switches between:
  - **Frozen Cube (AZSRP_DS052_VT_S4):** Historical/frozen snapshot data
  - **Live Cube (AZSRP_DS041_VT_S4):** Current/live transactional data
  - Selection based on IP_VERSION and IP_FC_COUNT parameters

---

## 10. External Dependencies

The following files are referenced but not included in the analyzed package:

| External File | Referenced By | Purpose |
|---------------|---------------|---------|
| **CV_BASE_MD_SRPACT_S4** | STP_WSS_SRP_ATTRIBUTES | Source for store reporting attributes |
| **CV_BASE_MD_COMPFL_S4** | STP_WSS_SRP_ATTRIBUTES | Source for comp flag data |
| **CV_BASE_MD_RCALWEEK_S4** | CV_BASE_MD_RCAIWEEK_S4 | Calendar week master data (referenced but not analyzed) |
| **SFN_PRIOR_FISCAL_WEEK** | STP_WSS_SRP_ATTRIBUTES | Scalar function to determine prior fiscal week |
| **SFN_FC_FLAG** | CV_BASE_FIN_WEEKLY_BUDGET_S4 | Scalar function to determine frozen cube flag |

---

## 11. Client-Friendly Conclusion

The file lineage analysis reveals a well-structured data architecture for weekly retail store reporting and analysis. 

**Primary Data Sources:**
- Financial budget data originates from two physical tables (frozen and live cubes) that are unified into a single base view
- Master data comes from multiple sources including hierarchy nodes, cost center descriptions, store attributes, and comp flags

**Data Processing:**
- A stored procedure (STP_WSS_SRP_ATTRIBUTES) periodically refreshes static tables with the latest store attributes and comp flag information
- The financial budget view intelligently switches between frozen historical data and live current data based on version parameters

**Final Output:**
- All data streams converge into **CV_BASE_MD_RCAIWEEK_S4**, which serves as the primary reporting interface for weekly retail comparable store analysis (RCAI)
- This final view integrates financial metrics with store characteristics, organizational hierarchies, and comparability flags to enable comprehensive weekly performance analysis

**Data Quality:**
- All relationships are confirmed with high confidence (95-98% scores)
- No circular dependencies or unresolved relationships exist
- The architecture follows a clear layered pattern making it maintainable and traceable

**Standalone Component:**
- CV_COMP_FIN_BUDGET_STATIC exists as an independent reporting view for financial budget static data and does not feed into the main RCAI reporting flow

This lineage structure supports reliable weekly retail analysis by ensuring data consistency, clear dependency tracking, and separation of concerns across different data domains (financial, master data, hierarchies, and attributes).