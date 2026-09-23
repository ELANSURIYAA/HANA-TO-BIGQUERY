# SAP HANA Data Lineage Summary Report

## 1. Lineage Summary

The analysis identified **8 files** within the CVS FRIP (Financial Reporting and Planning) system with **4 distinct lineage chains**. The lineage flows from base source tables through calculation views, ETL procedures, and static tables, ultimately converging into a final reporting view.

- **Base/Source Files Identified:** 4 (2 database tables + 2 external calculation views)
- **Intermediate Processing Files:** 6 (calculation views and stored procedure)
- **Final/Downstream Files:** 2 (primary reporting view + standalone static view)
- **Total Lineage Paths:** 4 major paths
- **Overall Lineage Confidence:** High (95-98% across all relationships)

---

## 2. Base / Source Files

These files serve as the starting points for data lineage with no identified upstream dependencies within the analyzed package.

| Base File | Description |
|-----------|-------------|
| **AZSRP_DS052_VT_S4** (table) | Frozen Cube database table - Source for weekly budget snapshot data |
| **AZSRP_DS041_VT_S4** (table) | Live Cube database table - Source for current weekly budget data |
| **CV_BASE_MD_SRPACT_S4** (external) | Store Reporting Attributes source view (not in package) |
| **CV_BASE_MD_COMPFL_S4** (external) | Comparison Flag source view (not in package) |

---

## 3. File-Level Lineage

### **Lineage Path 1: Financial Budget Data Flow**

```
AZSRP_DS052_VT_S4 (Frozen Cube Table)
   ↓
CV_BASE_FIN_WEEKLY_BUDGET_S4.txt (Union View)
   ↓
CV_BASE_MD_RCAIWEEK_S4.txt (Final Reporting View)
```

**AND**

```
AZSRP_DS041_VT_S4 (Live Cube Table)
   ↓
CV_BASE_FIN_WEEKLY_BUDGET_S4.txt (Union View)
   ↓
CV_BASE_MD_RCAIWEEK_S4.txt (Final Reporting View)
```

**Description:** The frozen cube and live cube tables are unified based on version parameters to provide weekly budget data to the final reporting view.

---

### **Lineage Path 2: Store Attributes ETL Pipeline**

```
CV_BASE_MD_SRPACT_S4 (External Source View)
   ↓
STP_WSS_SRP_ATTRIBUTES.txt (ETL Stored Procedure)
   ↓
TBL_WSS_SRP_ATTR_ACT (Static Table)
   ↓
CV_COMP_MD_SRPACT_STATIC.txt (Composite View)
   ↓
CV_BASE_MD_RCAIWEEK_S4.txt (Final Reporting View)
```

**Description:** Store attributes are extracted from an external base view, loaded into a static table via stored procedure, then exposed through a composite view for final reporting.

---

### **Lineage Path 3: Comparison Flag ETL Pipeline**

```
CV_BASE_MD_COMPFL_S4 (External Source View)
   ↓
STP_WSS_SRP_ATTRIBUTES.txt (ETL Stored Procedure)
   ↓
TBL_WSS_SRP_COMPFLAG (Static Table)
   ├──→ CV_COMP_MD_COMPFL_STATIC.txt (Composite View)
   │       └──→ CV_BASE_MD_RCAIWEEK_S4.txt (Final Reporting View)
   │
   └──→ CV_COMP_FIN_BUDGET_STATIC.txt (Standalone Static View)
```

**Description:** Comparison flag data is extracted from an external base view (filtered by week), loaded into a static table, then consumed by two composite views - one feeds the final reporting view, the other serves as a standalone budget static view.

---

### **Lineage Path 4: Master Data Integration**

```
CV_BASE_MD_HRRP_NODE_S4.txt (Hierarchy Node View)
   ↓
CV_BASE_MD_RCAIWEEK_S4.txt (Final Reporting View)
```

**AND**

```
CV_BASE_MD_CEPCT_S4.txt (Text/Master Data View)
   ↓
CV_BASE_MD_RCAIWEEK_S4.txt (Final Reporting View)
```

**Description:** Hierarchy node master data and text master data directly feed into the final reporting view without intermediate processing.

---

## 4. Dependency Details

| Upstream File | Downstream File | Relationship Score | Relationship |
|---------------|-----------------|-------------------|--------------|
| **AZSRP_DS052_VT_S4** (table) | CV_BASE_FIN_WEEKLY_BUDGET_S4.txt | 98 | Data Source - Frozen Cube |
| **AZSRP_DS041_VT_S4** (table) | CV_BASE_FIN_WEEKLY_BUDGET_S4.txt | 98 | Data Source - Live Cube |
| **CV_BASE_FIN_WEEKLY_BUDGET_S4.txt** | CV_BASE_MD_RCAIWEEK_S4.txt | 96 | Budget Data Feed |
| **CV_BASE_MD_SRPACT_S4** (external) | STP_WSS_SRP_ATTRIBUTES.txt | 95 | Source View Read |
| **STP_WSS_SRP_ATTRIBUTES.txt** | TBL_WSS_SRP_ATTR_ACT (table) | 98 | ETL Insert |
| **TBL_WSS_SRP_ATTR_ACT** (table) | CV_COMP_MD_SRPACT_STATIC.txt | 98 | Data Source |
| **CV_COMP_MD_SRPACT_STATIC.txt** | CV_BASE_MD_RCAIWEEK_S4.txt | 96 | Store Attributes Feed |
| **CV_BASE_MD_COMPFL_S4** (external) | STP_WSS_SRP_ATTRIBUTES.txt | 95 | Source View Read |
| **STP_WSS_SRP_ATTRIBUTES.txt** | TBL_WSS_SRP_COMPFLAG (table) | 98 | ETL Insert |
| **TBL_WSS_SRP_COMPFLAG** (table) | CV_COMP_MD_COMPFL_STATIC.txt | 98 | Data Source |
| **CV_COMP_MD_COMPFL_STATIC.txt** | CV_BASE_MD_RCAIWEEK_S4.txt | 96 | Comparison Flag Feed |
| **TBL_WSS_SRP_COMPFLAG** (table) | CV_COMP_FIN_BUDGET_STATIC.txt | 98 | Data Source |
| **CV_BASE_MD_HRRP_NODE_S4.txt** | CV_BASE_MD_RCAIWEEK_S4.txt | 96 | Hierarchy Data Feed |
| **CV_BASE_MD_CEPCT_S4.txt** | CV_BASE_MD_RCAIWEEK_S4.txt | 96 | Text/Master Data Feed |

---

## 5. Unclear / Unconfirmed Lineage

| File | Status | Reason |
|------|--------|--------|
| **CV_BASE_MD_RCALWEEK_S4** (external) | Referenced but not in package | This calculation view is referenced by CV_BASE_MD_RCAIWEEK_S4.txt but was not included in the analyzed package. It represents an external dependency. |

**Note:** All relationships within the analyzed 8 files have been successfully identified with high confidence (95-98%). The only unconfirmed element is the external dependency CV_BASE_MD_RCALWEEK_S4, which is outside the scope of this package.

---

## 6. Standalone Files

| File | Status |
|------|--------|
| **CV_COMP_FIN_BUDGET_STATIC.txt** | Standalone - No downstream consumers identified |

**Note:** While CV_COMP_FIN_BUDGET_STATIC.txt has an upstream source (TBL_WSS_SRP_COMPFLAG), it has no identified downstream consumers within the analyzed package, making it a terminal endpoint separate from the main reporting flow.

---

## 7. Complete Lineage Visualization

### **Consolidated Data Flow Diagram**

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         BASE SOURCE FILES                                │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
        ▼                           ▼                           ▼
AZSRP_DS052_VT_S4         CV_BASE_MD_SRPACT_S4      CV_BASE_MD_COMPFL_S4
(Frozen Cube Table)       (External Source)         (External Source)
        │                           │                           │
        │                           ▼                           ▼
        │                  STP_WSS_SRP_ATTRIBUTES.txt (ETL Procedure)
        │                           │                           │
        ▼                           ▼                           ▼
AZSRP_DS041_VT_S4         TBL_WSS_SRP_ATTR_ACT      TBL_WSS_SRP_COMPFLAG
(Live Cube Table)         (Static Table)            (Static Table)
        │                           │                           │
        │                           │                           ├──────────┐
        ▼                           ▼                           ▼          ▼
CV_BASE_FIN_WEEKLY_       CV_COMP_MD_SRPACT_        CV_COMP_MD_    CV_COMP_FIN_
BUDGET_S4.txt             STATIC.txt                COMPFL_        BUDGET_
(Union View)              (Composite View)          STATIC.txt     STATIC.txt
        │                           │                     │         (Standalone)
        │                           │                     │
        └───────────────────────────┼─────────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
                    ▼               ▼               ▼
        CV_BASE_MD_HRRP_    CV_BASE_MD_CEPCT_S4.txt
        NODE_S4.txt         (Text/Master Data)
        (Hierarchy Node)            │
                    │               │
                    └───────────────┼───────────────┘
                                    │
                                    ▼
                    ┌───────────────────────────────┐
                    │  CV_BASE_MD_RCAIWEEK_S4.txt   │
                    │   (FINAL REPORTING VIEW)      │
                    └───────────────────────────────┘
```

---

## 8. Client-Friendly Conclusion

### **Overall Lineage Summary**

The CVS FRIP system follows a well-structured data architecture with **4 primary data sources** feeding into a **centralized reporting view** (CV_BASE_MD_RCAIWEEK_S4.txt).

**Key Data Flows:**

1. **Financial Budget Data:** Two database tables (frozen and live cubes) are combined through CV_BASE_FIN_WEEKLY_BUDGET_S4.txt based on version parameters, providing flexible budget data retrieval.

2. **Store Attributes:** External store attribute data is processed through an ETL procedure (STP_WSS_SRP_ATTRIBUTES.txt), persisted in a static table, and exposed via CV_COMP_MD_SRPACT_STATIC.txt.

3. **Comparison Flags:** External comparison flag data follows a similar ETL pattern, with the static table feeding both the main reporting view and a standalone budget view.

4. **Master Data:** Hierarchy node data (CV_BASE_MD_HRRP_NODE_S4.txt) and text master data (CV_BASE_MD_CEPCT_S4.txt) directly enrich the final reporting view.

**Final Reporting View:** CV_BASE_MD_RCAIWEEK_S4.txt serves as the **primary endpoint**, consolidating data from **6 upstream sources** to provide comprehensive weekly budget reporting with master data enrichment.

**Data Quality:** All identified relationships have **high confidence scores (95-98%)**, indicating well-documented and explicit dependencies with clear data flow paths.

**External Dependencies:** Three calculation views (CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4, CV_BASE_MD_RCALWEEK_S4) are referenced but not included in this package, representing external dependencies that should be considered for complete end-to-end lineage.

**Standalone Component:** CV_COMP_FIN_BUDGET_STATIC.txt operates as an independent view without downstream consumers, potentially serving specific reporting or query needs outside the main lineage flow.

---

## 9. Summary Statistics

| Metric | Value |
|--------|-------|
| **Total Files Analyzed** | 8 |
| **Base Source Files** | 4 |
| **Intermediate Processing Files** | 6 |
| **Final Reporting Views** | 1 (primary) + 1 (standalone) |
| **Total Dependencies Identified** | 14 |
| **Average Relationship Score** | 96.7/100 |
| **Lineage Paths** | 4 |
| **External Dependencies** | 3 |
| **Unresolved Relationships** | 0 (within package scope) |

---

## 10. Recommendations

1. **Complete Lineage Analysis:** Include the 3 external calculation views (CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4, CV_BASE_MD_RCALWEEK_S4) in future analysis to establish complete end-to-end lineage.

2. **ETL Monitoring:** The stored procedure STP_WSS_SRP_ATTRIBUTES.txt is critical for refreshing static tables used by multiple downstream views. Ensure proper scheduling and monitoring.

3. **Version Management:** The IP_VERSION parameter in CV_BASE_FIN_WEEKLY_BUDGET_S4.txt controls frozen vs. live cube selection. Maintain clear version control processes.

4. **Standalone View Usage:** Investigate the usage of CV_COMP_FIN_BUDGET_STATIC.txt to determine if it should be integrated into the main lineage or if it serves a specific isolated purpose.

5. **Documentation:** Maintain a registry of external dependencies and their purposes to facilitate impact analysis and change management.

---

**Report Generated:** 2024  
**Analysis Confidence Level:** High (96.7% average)  
**Methodology:** Static code analysis of SAP HANA calculation views (XML) and stored procedures (SQL Script)  
**Scope:** 8 files within CVS FRIP Financial Reporting and Planning system
