# HANA to BigQuery Lineage and Dependency Analysis Report
## FIN_SBT Calculation Views

---

## 1. Lineage Summary

### Overview
- **Total Files Analyzed**: 6
- **Total Relationships Identified**: 5
- **Total Lineage Paths Identified**: 5
- **Total Base Files Identified**: 5
- **Total Unresolved Relationships**: 0

### Analysis Scope
This analysis covers HANA Calculation View XML artifacts from the FIN_SBT domain, focusing on file-to-file dependencies to support downstream SQL consolidation.

---

## 2. File Inventory

| File | Type | Identified Purpose | Upstream Files | Downstream Files |
|------|------|-------------------|----------------|------------------|
| CV_BASE_FIN_ACDOCA_S4 | Calculation View (Base) | Base view for ACDOCA (Universal Journal Entry Line Items) table - provides financial accounting document line items | None | CV_COMP_FIN_SBT |
| CV_BASE_FIN_BKPF_S4 | Calculation View (Base) | Base view for BKPF (Accounting Document Header) table - provides accounting document header information | None | CV_COMP_FIN_SBT |
| CV_BASE_MD_CEPCT_S4 | Calculation View (Base) | Base view for CEPCT (Profit Center Text) table - provides profit center text descriptions | None | CV_COMP_FIN_SBT |
| CV_BASE_MD_RCALWEEK_S4 | Calculation View (Base) | Base view for RCALWEEK (Calendar Week) table - provides calendar week master data | None | CV_COMP_FIN_SBT |
| CV_BASE_MD_SRPACT_S4 | Calculation View (Base) | Base view for SRPACT (SRP Activity) table - provides SRP activity master data | None | CV_COMP_FIN_SBT |
| CV_COMP_FIN_SBT | Calculation View (Composite) | Composite view that integrates financial transaction data (ACDOCA, BKPF) with master data (SRPACT, RCALWEEK, CEPCT) to produce consolidated financial reporting for SBT analysis | CV_BASE_FIN_BKPF_S4, CV_BASE_FIN_ACDOCA_S4, CV_BASE_MD_SRPACT_S4, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_CEPCT_S4 | None |

---

## 3. File Relationships

### Detailed Relationship Analysis

| Source File | Target File | Relationship | Score | Reason |
|------------|------------|--------------|--------|---------|
| CV_BASE_FIN_BKPF_S4 | CV_COMP_FIN_SBT | Calculation View Dependency | 90 | CV_COMP_FIN_SBT explicitly references /CVS_FRIP.Base.FI/calculationviews/CV_BASE_FIN_BKPF_S4 in its logicalModel dataSources section. This is a direct XML-based dependency where the composite view consumes the base view for accounting document header data. |
| CV_BASE_FIN_ACDOCA_S4 | CV_COMP_FIN_SBT | Calculation View Dependency | 90 | CV_COMP_FIN_SBT explicitly references /CVS_FRIP.Base.FI/calculationviews/CV_BASE_FIN_ACDOCA_S4 in its logicalModel dataSources section. This is a direct XML-based dependency where the composite view consumes the base view for universal journal entry line items. |
| CV_BASE_MD_SRPACT_S4 | CV_COMP_FIN_SBT | Calculation View Dependency | 90 | CV_COMP_FIN_SBT explicitly references /CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_SRPACT_S4 in its logicalModel dataSources section. This is a direct XML-based dependency where the composite view consumes the base view for SRP activity master data. |
| CV_BASE_MD_RCALWEEK_S4 | CV_COMP_FIN_SBT | Calculation View Dependency | 90 | CV_COMP_FIN_SBT explicitly references /CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_RCALWEEK_S4 in its logicalModel dataSources section. This is a direct XML-based dependency where the composite view consumes the base view for calendar week master data. |
| CV_BASE_MD_CEPCT_S4 | CV_COMP_FIN_SBT | Calculation View Dependency | 90 | CV_COMP_FIN_SBT explicitly references /CVS_FRIP.Base.Text/calculationviews/CV_BASE_MD_CEPCT_S4 in its logicalModel dataSources section. This is a direct XML-based dependency where the composite view consumes the base view for profit center text descriptions. |

### Relationship Type Distribution
- **Calculation View Dependency**: 5 relationships (100%)
- **Stored Procedure Dependency**: 0 relationships (0%)
- **Other Dependencies**: 0 relationships (0%)

---

## 4. Complete Lineage

### Lineage Path 1: Financial Document Header Flow
```
CV_BASE_FIN_BKPF_S4
    ↓ [Calculation View Dependency, Score: 90]
CV_COMP_FIN_SBT
```
**Path Confidence Score**: 90/100  
**Determination**: Direct XML reference in composite view's data sources. The BKPF base view provides accounting document header information that is consumed by the composite view for financial reporting.

---

### Lineage Path 2: Universal Journal Entry Flow
```
CV_BASE_FIN_ACDOCA_S4
    ↓ [Calculation View Dependency, Score: 90]
CV_COMP_FIN_SBT
```
**Path Confidence Score**: 90/100  
**Determination**: Direct XML reference in composite view's data sources. The ACDOCA base view provides universal journal entry line items that form the core transactional data for the composite view.

---

### Lineage Path 3: SRP Activity Master Data Flow
```
CV_BASE_MD_SRPACT_S4
    ↓ [Calculation View Dependency, Score: 90]
CV_COMP_FIN_SBT
```
**Path Confidence Score**: 90/100  
**Determination**: Direct XML reference in composite view's data sources. The SRPACT base view provides SRP activity master data that enriches the financial transaction data in the composite view.

---

### Lineage Path 4: Calendar Week Master Data Flow
```
CV_BASE_MD_RCALWEEK_S4
    ↓ [Calculation View Dependency, Score: 90]
CV_COMP_FIN_SBT
```
**Path Confidence Score**: 90/100  
**Determination**: Direct XML reference in composite view's data sources. The RCALWEEK base view provides calendar week master data for time-based analysis in the composite view. The composite view also references a stored function "CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK" for fiscal week calculations.

---

### Lineage Path 5: Profit Center Text Flow
```
CV_BASE_MD_CEPCT_S4
    ↓ [Calculation View Dependency, Score: 90]
CV_COMP_FIN_SBT
```
**Path Confidence Score**: 90/100  
**Determination**: Direct XML reference in composite view's data sources. The CEPCT base view provides profit center text descriptions for reporting purposes in the composite view.

---

### Complete Integrated Lineage
```
CV_BASE_FIN_BKPF_S4 ────┐
                         │
CV_BASE_FIN_ACDOCA_S4 ───┤
                         │
CV_BASE_MD_SRPACT_S4 ────┼──→ CV_COMP_FIN_SBT
                         │
CV_BASE_MD_RCALWEEK_S4 ──┤
                         │
CV_BASE_MD_CEPCT_S4 ─────┘
```

**Overall Lineage Confidence**: 90/100  
**Rationale**: All relationships are explicitly defined in XML with clear data source references. The composite view (CV_COMP_FIN_SBT) acts as an integration point for five base views, combining financial transaction data with master data for comprehensive reporting.

---

## 5. Base Files

| Base File | Reason | Score |
|-----------|--------|-------|
| CV_BASE_FIN_ACDOCA_S4 | This is a base calculation view with no upstream dependencies within the analyzed artifact set. It directly accesses the ACDOCA physical table (Universal Journal Entry Line Items) and serves as the starting point for financial transaction data lineage. The view contains 348 output columns and provides the foundational transactional data. | 100 |
| CV_BASE_FIN_BKPF_S4 | This is a base calculation view with no upstream dependencies within the analyzed artifact set. It directly accesses the BKPF physical table (Accounting Document Header) and serves as the starting point for accounting document header lineage. The view contains 9 output columns and provides document-level information. | 100 |
| CV_BASE_MD_CEPCT_S4 | This is a base calculation view with no upstream dependencies within the analyzed artifact set. It directly accesses the CEPCT physical table (Profit Center Text) and serves as the starting point for profit center text master data lineage. The view contains 8 output columns. | 100 |
| CV_BASE_MD_RCALWEEK_S4 | This is a base calculation view with no upstream dependencies within the analyzed artifact set. It directly accesses the RCALWEEK physical table (Calendar Week) and serves as the starting point for calendar week master data lineage. The view contains 9 output columns. | 100 |
| CV_BASE_MD_SRPACT_S4 | This is a base calculation view with no upstream dependencies within the analyzed artifact set. It directly accesses the SRPACT physical table (SRP Activity) and serves as the starting point for SRP activity master data lineage. The view contains 150 output columns. | 100 |

### Base File Classification Summary
- **Total Base Files**: 5
- **Financial Transaction Base Views**: 2 (CV_BASE_FIN_ACDOCA_S4, CV_BASE_FIN_BKPF_S4)
- **Master Data Base Views**: 3 (CV_BASE_MD_SRPACT_S4, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_CEPCT_S4)

---

## 6. Final/Downstream Files

| File | Reason | Score |
|------|--------|-------|
| CV_COMP_FIN_SBT | This is the final composite calculation view that consumes all five base views. It has no downstream dependencies within the analyzed artifact set. The view integrates financial transaction data (ACDOCA, BKPF) with master data (SRPACT, RCALWEEK, CEPCT) to produce a consolidated financial reporting dataset. It contains 35 output columns and includes complex join logic, calculated columns, and filters. This view represents the final output of the FIN_SBT lineage flow. | 100 |

### Downstream File Classification Summary
- **Total Final Files**: 1
- **Composite Views**: 1 (CV_COMP_FIN_SBT)
- **Intermediate Views**: 0

---

## 7. Unresolved Relationships

**Status**: No unresolved relationships identified.

All relationships within the analyzed artifact set have been successfully identified and documented with high confidence scores (90/100). Each relationship is supported by explicit XML evidence in the calculation view definitions.

### External Dependencies (Not Unresolved, but External to Artifact Set)

| File | External Reference | Type | Notes |
|------|-------------------|------|-------|
| CV_COMP_FIN_SBT | CVS_FRIP.Composite.Master::SFN_PRIOR_FISCAL_WEEK | Stored Function | Referenced in the composite view for fiscal week calculations. This is an external stored function not included in the analyzed artifact set. |
| CV_BASE_FIN_ACDOCA_S4 | ACDOCA (Physical Table) | Physical Table | The base view directly accesses this physical table, which is outside the artifact set. |
| CV_BASE_FIN_BKPF_S4 | BKPF (Physical Table) | Physical Table | The base view directly accesses this physical table, which is outside the artifact set. |
| CV_BASE_MD_CEPCT_S4 | CEPCT (Physical Table) | Physical Table | The base view directly accesses this physical table, which is outside the artifact set. |
| CV_BASE_MD_RCALWEEK_S4 | RCALWEEK (Physical Table) | Physical Table | The base view directly accesses this physical table, which is outside the artifact set. |
| CV_BASE_MD_SRPACT_S4 | SRPACT (Physical Table) | Physical Table | The base view directly accesses this physical table, which is outside the artifact set. |

**Note**: Physical tables and external stored functions are documented for completeness but are not included in the primary lineage graph per the mandatory lineage rules, as they are not supplied artifacts.

---

## 8. Final Lineage Assessment

### Executive Summary

The FIN_SBT artifact set represents a well-structured, hierarchical calculation view architecture following SAP HANA best practices. The lineage analysis reveals a clear star-schema pattern where five base views feed into a single composite view.

### Base Files (5 Total)

**Financial Transaction Base Views:**
1. **CV_BASE_FIN_ACDOCA_S4** - Universal Journal Entry Line Items (348 columns)
   - Score: 100/100
   - Rationale: Primary source for financial transaction data with no upstream dependencies

2. **CV_BASE_FIN_BKPF_S4** - Accounting Document Header (9 columns)
   - Score: 100/100
   - Rationale: Primary source for document header information with no upstream dependencies

**Master Data Base Views:**
3. **CV_BASE_MD_SRPACT_S4** - SRP Activity Master Data (150 columns)
   - Score: 100/100
   - Rationale: Primary source for SRP activity attributes with no upstream dependencies

4. **CV_BASE_MD_RCALWEEK_S4** - Calendar Week Master Data (9 columns)
   - Score: 100/100
   - Rationale: Primary source for time dimension data with no upstream dependencies

5. **CV_BASE_MD_CEPCT_S4** - Profit Center Text (8 columns)
   - Score: 100/100
   - Rationale: Primary source for profit center descriptions with no upstream dependencies

### Main Lineage Paths

All five lineage paths follow the same pattern: **Base View → Composite View**

**Path Architecture:**
- **Pattern**: Single-hop, direct dependency
- **Relationship Type**: Calculation View Dependency (XML-based)
- **Confidence**: 90/100 for all paths
- **Evidence**: Explicit XML references in CV_COMP_FIN_SBT's logicalModel/dataSources section

### File-to-File Relationships (5 Total)

| # | Source | Target | Type | Score | Status |
|---|--------|--------|------|-------|--------|
| 1 | CV_BASE_FIN_BKPF_S4 | CV_COMP_FIN_SBT | Calculation View Dependency | 90 | CONFIRMED |
| 2 | CV_BASE_FIN_ACDOCA_S4 | CV_COMP_FIN_SBT | Calculation View Dependency | 90 | CONFIRMED |
| 3 | CV_BASE_MD_SRPACT_S4 | CV_COMP_FIN_SBT | Calculation View Dependency | 90 | CONFIRMED |
| 4 | CV_BASE_MD_RCALWEEK_S4 | CV_COMP_FIN_SBT | Calculation View Dependency | 90 | CONFIRMED |
| 5 | CV_BASE_MD_CEPCT_S4 | CV_COMP_FIN_SBT | Calculation View Dependency | 90 | CONFIRMED |

### Lineage Scores and Rationale

**Overall Lineage Quality Score: 90/100**

**Score Breakdown:**
- **Relationship Clarity**: 100/100 - All relationships are explicitly defined in XML
- **Evidence Quality**: 90/100 - Direct XML references provide strong evidence
- **Completeness**: 100/100 - All files in the artifact set are accounted for
- **Traceability**: 100/100 - Clear path from base to composite views
- **Documentation**: 80/100 - XML provides structural information; business logic requires interpretation

**Rationale for 90/100 Score:**
1. **Explicit XML Dependencies**: All five relationships are explicitly declared in the CV_COMP_FIN_SBT XML file's dataSources section
2. **No Ambiguity**: Each base view has a single, clear downstream consumer
3. **Hierarchical Structure**: Clean two-tier architecture (base → composite) with no circular dependencies
4. **Complete Coverage**: All six files are classified and integrated into the lineage
5. **Deduction Reason**: Score is 90 instead of 100 because the relationships are XML-based rather than SQL-based (SQL references would score 100)

### Unresolved Relationships

**Count**: 0

**Status**: All relationships within the artifact set are fully resolved and confirmed.

**External Dependencies**: 
- 1 stored function reference (SFN_PRIOR_FISCAL_WEEK) - external to artifact set
- 5 physical table references - external to artifact set per lineage rules

### Architectural Insights

**Design Pattern**: Star Schema Integration
- **Fact Data**: CV_BASE_FIN_ACDOCA_S4 (line items), CV_BASE_FIN_BKPF_S4 (headers)
- **Dimension Data**: CV_BASE_MD_SRPACT_S4, CV_BASE_MD_RCALWEEK_S4, CV_BASE_MD_CEPCT_S4
- **Integration Point**: CV_COMP_FIN_SBT

**Data Flow Characteristics:**
- **Direction**: Unidirectional (base → composite)
- **Complexity**: Low (single-hop dependencies)
- **Coupling**: Loose (base views are independent)
- **Reusability**: High (base views can be consumed by other composite views)

**Business Logic Location:**
- **Base Views**: Minimal transformation, primarily column selection and basic filters
- **Composite View**: Complex join logic, calculated columns (e.g., WSL_NEGATIVE*-1), filters (e.g., PRCTR='0000562057'), and aggregations

### Validation Results

✅ **Validation 1 - File Classification**: PASSED
- All 6 files classified as USED
- No files ignored

✅ **Validation 2 - Evidence Traceability**: PASSED
- All 5 dependencies traced to XML evidence
- No inferred dependencies without evidence

✅ **Validation 3 - Stored Procedure Lineage**: PASSED
- No stored procedures in artifact set
- External stored function documented but not included in primary lineage

✅ **Validation 4 - ETL Table Exclusion**: PASSED
- No physical tables used as primary lineage nodes
- All lineage nodes are calculation view artifacts

### Recommendations for Downstream SQL Consolidation

1. **Expansion Order**: Process base views before composite view
2. **Dependency Resolution**: All dependencies are direct; no recursive expansion needed within this artifact set
3. **External References**: Account for SFN_PRIOR_FISCAL_WEEK stored function when generating BigQuery SQL
4. **Join Logic**: CV_COMP_FIN_SBT contains complex multi-way joins that will require careful SQL translation
5. **Calculated Fields**: Multiple calculated columns in composite view need BigQuery-compatible expressions

### Conclusion

The FIN_SBT lineage analysis reveals a clean, well-architected calculation view structure with clear dependencies and no ambiguities. All relationships are confirmed with high confidence, making this artifact set suitable for automated SQL consolidation and BigQuery migration.

---

**Analysis Completed**: 2024
**Artifact Set**: FIN_SBT
**Total Artifacts Analyzed**: 6
**Lineage Confidence**: 90/100
**Status**: COMPLETE - All relationships resolved
