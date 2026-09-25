# File Relationships Table

## Complete File-to-File Relationships

| Source File | Target File | Relationship Type | Score | Reason |
|-------------|-------------|-------------------|-------|--------|
| **AZSRP_DS052_VT_S4** | CV_BASE_FIN_WEEKLY_BUDGET_S4 | Data Source | 98 | CV_BASE_FIN_WEEKLY_BUDGET_S4 explicitly references AZSRP_DS052_VT_S4 as a DataSource with schemaName="CVS_FRIP" in the Frozen_Cube projection view. Direct XML declaration confirms dependency. |
| **AZSRP_DS041_VT_S4** | CV_BASE_FIN_WEEKLY_BUDGET_S4 | Data Source | 98 | CV_BASE_FIN_WEEKLY_BUDGET_S4 explicitly references AZSRP_DS041_VT_S4 as a DataSource with schemaName="CVS_FRIP" in the Live_Cube projection view. Direct XML declaration confirms dependency. |
| **CV_BASE_FIN_WEEKLY_BUDGET_S4** | CV_BASE_MD_RCAIWEEK_S4 | Calculation View Dependency | 96 | CV_BASE_MD_RCAIWEEK_S4 explicitly references "/CVS_FRIP.Base.FI/calculationviews/CV_BASE_FIN_WEEKLY_BUDGET_S4" in its dataSources section. This is a direct calculation view-to-view dependency. |
| **CV_BASE_MD_HRRP_NODE_S4** | CV_BASE_MD_RCAIWEEK_S4 | Calculation View Dependency | 96 | CV_BASE_MD_RCAIWEEK_S4 explicitly references "/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_HRRP_NODE_S4" in its dataSources section. This is a direct calculation view-to-view dependency. |
| **CV_COMP_MD_SRPACT_STATIC** | CV_BASE_MD_RCAIWEEK_S4 | Calculation View Dependency | 96 | CV_BASE_MD_RCAIWEEK_S4 explicitly references "/CVS_FRIP.Composite.Master/calculationviews/CV_COMP_MD_SRPACT_STATIC" in its dataSources section. This is a direct calculation view-to-view dependency. |
| **CV_COMP_MD_COMPFL_STATIC** | CV_BASE_MD_RCAIWEEK_S4 | Calculation View Dependency | 96 | CV_BASE_MD_RCAIWEEK_S4 explicitly references "/CVS_FRIP.Composite.Master/calculationviews/CV_COMP_MD_COMPFL_STATIC" in its dataSources section. This is a direct calculation view-to-view dependency. |
| **CV_BASE_MD_CEPCT_S4** | CV_BASE_MD_RCAIWEEK_S4 | Calculation View Dependency | 96 | CV_BASE_MD_RCAIWEEK_S4 explicitly references "/CVS_FRIP.Base.Text/calculationviews/CV_BASE_MD_CEPCT_S4" in its dataSources section. This is a direct calculation view-to-view dependency. |
| **TBL_WSS_SRP_COMPFLAG** | CV_COMP_FIN_BUDGET_STATIC | Data Source | 98 | CV_COMP_FIN_BUDGET_STATIC explicitly references "CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG" as its data source in the XML definition. Direct table-to-view dependency. |
| **TBL_WSS_SRP_COMPFLAG** | CV_COMP_MD_COMPFL_STATIC | Data Source | 98 | CV_COMP_MD_COMPFL_STATIC explicitly references "CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG" as its data source in the XML definition. Direct table-to-view dependency. |
| **TBL_WSS_SRP_ATTR_ACT** | CV_COMP_MD_SRPACT_STATIC | Data Source | 98 | CV_COMP_MD_SRPACT_STATIC explicitly references "CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT" as its data source in the XML definition. Direct table-to-view dependency. |
| **CV_BASE_MD_SRPACT_S4** | STP_WSS_SRP_ATTRIBUTES | Source Calculation View | 97 | STP_WSS_SRP_ATTRIBUTES procedure explicitly reads from "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_SRPACT_S4" in the INSERT statement. Direct SQL reference in procedure code. |
| **CV_BASE_MD_COMPFL_S4** | STP_WSS_SRP_ATTRIBUTES | Source Calculation View | 97 | STP_WSS_SRP_ATTRIBUTES procedure explicitly reads from "_SYS_BIC"."CVS_FRIP.Base.Master/CV_BASE_MD_COMPFL_S4" in the INSERT statement with WHERE clause filtering on ZWEEK. Direct SQL reference in procedure code. |
| **STP_WSS_SRP_ATTRIBUTES** | TBL_WSS_SRP_ATTR_ACT | Target Table (Output) | 98 | STP_WSS_SRP_ATTRIBUTES procedure explicitly performs DELETE and INSERT operations on "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_SRP_ATTR_ACT". The procedure populates this table with data from CV_BASE_MD_SRPACT_S4. |
| **STP_WSS_SRP_ATTRIBUTES** | TBL_WSS_SRP_COMPFLAG | Target Table (Output) | 98 | STP_WSS_SRP_ATTRIBUTES procedure explicitly performs DELETE and INSERT operations on "CVS_FRIP"."CVS_FRIP.Table::TBL_WSS_SRP_COMPFLAG". The procedure populates this table with data from CV_BASE_MD_COMPFL_S4. |
| **TBL_WSS_SRP_ATTR_ACT** | CV_COMP_MD_SRPACT_STATIC | Data Flow | 95 | TBL_WSS_SRP_ATTR_ACT is populated by STP_WSS_SRP_ATTRIBUTES and then consumed by CV_COMP_MD_SRPACT_STATIC. This creates an indirect data flow relationship through the table. |
| **TBL_WSS_SRP_COMPFLAG** | CV_COMP_MD_COMPFL_STATIC | Data Flow | 95 | TBL_WSS_SRP_COMPFLAG is populated by STP_WSS_SRP_ATTRIBUTES and then consumed by CV_COMP_MD_COMPFL_STATIC. This creates an indirect data flow relationship through the table. |

---

## Summary Statistics

- **Total Relationships:** 16
- **Confirmed Relationships:** 16 (100%)
- **Inferred Relationships:** 0 (0%)
- **Unresolved Relationships:** 0 (0%)
- **Average Confidence Score:** 96.9/100
- **Minimum Score:** 95/100
- **Maximum Score:** 98/100

---

## Relationship Type Distribution

| Relationship Type | Count | Percentage |
|-------------------|-------|------------|
| Data Source | 5 | 31.25% |
| Calculation View Dependency | 5 | 31.25% |
| Target Table (Output) | 2 | 12.50% |
| Source Calculation View | 2 | 12.50% |
| Data Flow | 2 | 12.50% |

---

## Files Involved in Relationships

### Source Files (Upstream)
1. AZSRP_DS052_VT_S4
2. AZSRP_DS041_VT_S4
3. CV_BASE_FIN_WEEKLY_BUDGET_S4
4. CV_BASE_MD_HRRP_NODE_S4
5. CV_BASE_MD_CEPCT_S4
6. CV_COMP_MD_SRPACT_STATIC
7. CV_COMP_MD_COMPFL_STATIC
8. TBL_WSS_SRP_COMPFLAG
9. TBL_WSS_SRP_ATTR_ACT
10. CV_BASE_MD_SRPACT_S4 (External)
11. CV_BASE_MD_COMPFL_S4 (External)
12. STP_WSS_SRP_ATTRIBUTES

### Target Files (Downstream)
1. CV_BASE_FIN_WEEKLY_BUDGET_S4
2. CV_BASE_MD_RCAIWEEK_S4
3. CV_COMP_FIN_BUDGET_STATIC
4. CV_COMP_MD_COMPFL_STATIC
5. CV_COMP_MD_SRPACT_STATIC
6. STP_WSS_SRP_ATTRIBUTES
7. TBL_WSS_SRP_ATTR_ACT
8. TBL_WSS_SRP_COMPFLAG

---

## Confidence Score Analysis

### High Confidence (95-100)
All 16 relationships fall into the high confidence category, indicating:
- Explicit code references (XML declarations, SQL statements)
- Direct dependency declarations
- Clear and unambiguous relationships
- Full traceability from source to target

### Score Distribution
- **98/100:** 6 relationships (37.5%)
- **97/100:** 2 relationships (12.5%)
- **96/100:** 5 relationships (31.25%)
- **95/100:** 3 relationships (18.75%)

---

## Key Observations

1. **All relationships are CONFIRMED** - No inferred or unresolved relationships
2. **High average confidence score** (96.9/100) indicates strong evidence for all dependencies
3. **Balanced relationship types** - Mix of data sources, view dependencies, and data flows
4. **Clear data lineage** - Each relationship has explicit evidence from code analysis
5. **No circular dependencies** - All relationships flow in a single direction
6. **Central hub pattern** - CV_BASE_MD_RCAIWEEK_S4 serves as the primary integration point with 5 direct upstream dependencies

---

**Analysis Date:** 2024  
**Total Files Analyzed:** 8  
**Relationships Documented:** 16  
**Analysis Confidence:** 96.9/100