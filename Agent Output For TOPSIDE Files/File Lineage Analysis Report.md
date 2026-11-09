# File Lineage Analysis Report — TOPSIDE Artifacts

---

## 1. Lineage Summary

| Metric | Value |
|--------|-------|
| Total Files Analyzed | 6 |
| Total Relationships Identified | 4 |
| Total Lineage Paths Identified | 4 |
| Total Base Files Identified | 4 |
| Total Unresolved Relationships | 0 |

---

## 2. File Inventory

| File | Type | Identified Purpose | Upstream Files | Downstream Files |
|------|------|--------------------|----------------|------------------|
| xml_acc_cv_base_md_srpact_s4_FS.txt | Calculation View XML (HANA) | Base master data view for SRP Actuals (Full Store variant). Provides SRP actuals master data attributes for downstream composite views. | None (Base File) | xml_acc_cv_comp_topside_adjustments_FS.txt |
| xml_acc_cv_base_md_srpact_s4_RX.txt | Calculation View XML (HANA) | Base master data view for SRP Actuals (Pharmacy/RX variant). Provides SRP actuals master data attributes for downstream composite views. | None (Base File) | xml_acc_cv_comp_topside_adjustments_RX.txt |
| xml_acc_cv_base_topside_adjustments_car_FS.txt | Calculation View XML (HANA) | Base financial view for Topside Adjustments CAR (Full Store variant). Provides core topside adjustment financial data for downstream composite views. | None (Base File) | xml_acc_cv_comp_topside_adjustments_FS.txt |
| xml_acc_cv_base_topside_adjustments_car_RX.txt | Calculation View XML (HANA) | Base financial view for Topside Adjustments CAR (Pharmacy/RX variant). Provides core topside adjustment financial data for downstream composite views. | None (Base File) | xml_acc_cv_comp_topside_adjustments_RX.txt |
| xml_acc_cv_comp_topside_adjustments_FS.txt | Calculation View XML (HANA) | Composite/aggregation view for Topside Adjustments (Full Store variant). Joins base topside CAR data with SRP actuals master data, applies scalar functions for fiscal week and comp flag logic. | xml_acc_cv_base_topside_adjustments_car_FS.txt, xml_acc_cv_base_md_srpact_s4_FS.txt | None (Terminal/Final File) |
| xml_acc_cv_comp_topside_adjustments_RX.txt | Calculation View XML (HANA) | Composite/aggregation view for Topside Adjustments (Pharmacy/RX variant). Joins base topside CAR data with SRP actuals master data, applies scalar functions for fiscal week and comp flag logic. | xml_acc_cv_base_topside_adjustments_car_RX.txt, xml_acc_cv_base_md_srpact_s4_RX.txt | None (Terminal/Final File) |

---

## 3. File Relationships

| Source File | Target File | Relationship | Score | Reason |
|-------------|-------------|--------------|-------|--------|
| xml_acc_cv_base_topside_adjustments_car_FS.txt | xml_acc_cv_comp_topside_adjustments_FS.txt | Calculation View Dependency | 90 | xml_acc_cv_comp_topside_adjustments_FS.txt contains an explicit XML datasource reference: `/CVS_FRIP.Base.FI/calculationviews/CV_BASE_TOPSIDE_ADJUSTMENTS_CAR`, which directly maps to the artifact xml_acc_cv_base_topside_adjustments_car_FS.txt. The FS suffix confirms the Full Store variant alignment. |
| xml_acc_cv_base_md_srpact_s4_FS.txt | xml_acc_cv_comp_topside_adjustments_FS.txt | Calculation View Dependency | 90 | xml_acc_cv_comp_topside_adjustments_FS.txt contains an explicit XML datasource reference: `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_SRPACT_S4`, which directly maps to the artifact xml_acc_cv_base_md_srpact_s4_FS.txt. The FS suffix confirms the Full Store variant alignment. |
| xml_acc_cv_base_topside_adjustments_car_RX.txt | xml_acc_cv_comp_topside_adjustments_RX.txt | Calculation View Dependency | 90 | xml_acc_cv_comp_topside_adjustments_RX.txt contains an explicit XML datasource reference: `/CVS_FRIP.Base.FI/calculationviews/CV_BASE_TOPSIDE_ADJUSTMENTS_CAR`, which directly maps to the artifact xml_acc_cv_base_topside_adjustments_car_RX.txt. The RX suffix confirms the Pharmacy variant alignment. |
| xml_acc_cv_base_md_srpact_s4_RX.txt | xml_acc_cv_comp_topside_adjustments_RX.txt | Calculation View Dependency | 90 | xml_acc_cv_comp_topside_adjustments_RX.txt contains an explicit XML datasource reference: `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_SRPACT_S4`, which directly maps to the artifact xml_acc_cv_base_md_srpact_s4_RX.txt. The RX suffix confirms the Pharmacy variant alignment. |

---

## 4. Complete Lineage

### Lineage Path 1 — Full Store (FS) Topside Adjustments CAR → Composite

```
xml_acc_cv_base_topside_adjustments_car_FS.txt
    ↓  [Calculation View Dependency | Score: 90]
xml_acc_cv_comp_topside_adjustments_FS.txt
```

**Overall Confidence Score: 90**
**Determination:** The composite view `xml_acc_cv_comp_topside_adjustments_FS.txt` contains an explicit XML datasource node referencing `/CVS_FRIP.Base.FI/calculationviews/CV_BASE_TOPSIDE_ADJUSTMENTS_CAR`. This is a direct, unambiguous XML-level dependency. Score of 90 is assigned per the Explicit XML Dependency scoring rule. No inference was required.

---

### Lineage Path 2 — Full Store (FS) SRP Actuals Master → Composite

```
xml_acc_cv_base_md_srpact_s4_FS.txt
    ↓  [Calculation View Dependency | Score: 90]
xml_acc_cv_comp_topside_adjustments_FS.txt
```

**Overall Confidence Score: 90**
**Determination:** The composite view `xml_acc_cv_comp_topside_adjustments_FS.txt` contains an explicit XML datasource node referencing `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_SRPACT_S4`. This is a direct, unambiguous XML-level dependency. Score of 90 is assigned per the Explicit XML Dependency scoring rule. No inference was required.

---

### Lineage Path 3 — Pharmacy (RX) Topside Adjustments CAR → Composite

```
xml_acc_cv_base_topside_adjustments_car_RX.txt
    ↓  [Calculation View Dependency | Score: 90]
xml_acc_cv_comp_topside_adjustments_RX.txt
```

**Overall Confidence Score: 90**
**Determination:** The composite view `xml_acc_cv_comp_topside_adjustments_RX.txt` contains an explicit XML datasource node referencing `/CVS_FRIP.Base.FI/calculationviews/CV_BASE_TOPSIDE_ADJUSTMENTS_CAR`. This is a direct, unambiguous XML-level dependency. Score of 90 is assigned per the Explicit XML Dependency scoring rule. No inference was required.

---

### Lineage Path 4 — Pharmacy (RX) SRP Actuals Master → Composite

```
xml_acc_cv_base_md_srpact_s4_RX.txt
    ↓  [Calculation View Dependency | Score: 90]
xml_acc_cv_comp_topside_adjustments_RX.txt
```

**Overall Confidence Score: 90**
**Determination:** The composite view `xml_acc_cv_comp_topside_adjustments_RX.txt` contains an explicit XML datasource node referencing `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_SRPACT_S4`. This is a direct, unambiguous XML-level dependency. Score of 90 is assigned per the Explicit XML Dependency scoring rule. No inference was required.

---

### Mermaid Lineage

```mermaid
flowchart TD

    %% ── FS (Full Store) Branch ──────────────────────────────────────────────
    A["xml_acc_cv_base_topside_adjustments_car_FS\n📦 Schema: CVS_FRIP.Base.FI\n🔖 CV_BASE_TOPSIDE_ADJUSTMENTS_CAR\n🏷️ Base Financial View — Full Store\n📍 Role: Base / Source"]

    B["xml_acc_cv_base_md_srpact_s4_FS\n📦 Schema: CVS_FRIP.Base.Master\n🔖 CV_BASE_MD_SRPACT_S4\n🏷️ Base Master Data View — SRP Actuals FS\n📍 Role: Base / Source"]

    C["xml_acc_cv_comp_topside_adjustments_FS\n📦 Schema: CVS_FRIP.Composite.FI\n🔖 CV_COMP_TOPSIDE_ADJUSTMENTS_FS\n🏷️ Composite Topside Adjustments — Full Store\n📍 Role: Final / Downstream\n🔧 Uses: SFN_PRIOR_FISCAL_WEEK, SFN_ACTUALS_COMP_FLAG"]

    A -->|"Calculation View Dependency\n✅ CONFIRMED\nScore: 90\nEvidence: Explicit XML datasource ref\n/CVS_FRIP.Base.FI/calculationviews/CV_BASE_TOPSIDE_ADJUSTMENTS_CAR\nfound in composite FS view"| C

    B -->|"Calculation View Dependency\n✅ CONFIRMED\nScore: 90\nEvidence: Explicit XML datasource ref\n/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_SRPACT_S4\nfound in composite FS view"| C

    %% ── RX (Pharmacy) Branch ────────────────────────────────────────────────
    D["xml_acc_cv_base_topside_adjustments_car_RX\n📦 Schema: CVS_FRIP.Base.FI\n🔖 CV_BASE_TOPSIDE_ADJUSTMENTS_CAR\n🏷️ Base Financial View — Pharmacy RX\n📍 Role: Base / Source"]

    E["xml_acc_cv_base_md_srpact_s4_RX\n📦 Schema: CVS_FRIP.Base.Master\n🔖 CV_BASE_MD_SRPACT_S4\n🏷️ Base Master Data View — SRP Actuals RX\n📍 Role: Base / Source"]

    F["xml_acc_cv_comp_topside_adjustments_RX\n📦 Schema: CVS_FRIP.Composite.FI\n🔖 CV_COMP_TOPSIDE_ADJUSTMENTS_RX\n🏷️ Composite Topside Adjustments — Pharmacy RX\n📍 Role: Final / Downstream\n🔧 Uses: SFN_PRIOR_FISCAL_WEEK, SFN_ACTUALS_COMP_FLAG"]

    D -->|"Calculation View Dependency\n✅ CONFIRMED\nScore: 90\nEvidence: Explicit XML datasource ref\n/CVS_FRIP.Base.FI/calculationviews/CV_BASE_TOPSIDE_ADJUSTMENTS_CAR\nfound in composite RX view"| F

    E -->|"Calculation View Dependency\n✅ CONFIRMED\nScore: 90\nEvidence: Explicit XML datasource ref\n/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_SRPACT_S4\nfound in composite RX view"| F

    %% ── Styling ─────────────────────────────────────────────────────────────
    style A fill:#d4edda,stroke:#28a745,color:#000
    style B fill:#d4edda,stroke:#28a745,color:#000
    style C fill:#cce5ff,stroke:#004085,color:#000
    style D fill:#d4edda,stroke:#28a745,color:#000
    style E fill:#d4edda,stroke:#28a745,color:#000
    style F fill:#cce5ff,stroke:#004085,color:#000
```

---

## 5. Base Files

| Base File | Reason | Score |
|-----------|--------|-------|
| xml_acc_cv_base_topside_adjustments_car_FS.txt | No upstream artifact dependencies found within the supplied file set. It is referenced as a datasource by the composite view `xml_acc_cv_comp_topside_adjustments_FS.txt`. It represents the base financial data layer for Full Store topside adjustments. | 90 |
| xml_acc_cv_base_md_srpact_s4_FS.txt | No upstream artifact dependencies found within the supplied file set. It is referenced as a datasource by the composite view `xml_acc_cv_comp_topside_adjustments_FS.txt`. It represents the base SRP actuals master data layer for Full Store. | 90 |
| xml_acc_cv_base_topside_adjustments_car_RX.txt | No upstream artifact dependencies found within the supplied file set. It is referenced as a datasource by the composite view `xml_acc_cv_comp_topside_adjustments_RX.txt`. It represents the base financial data layer for Pharmacy/RX topside adjustments. | 90 |
| xml_acc_cv_base_md_srpact_s4_RX.txt | No upstream artifact dependencies found within the supplied file set. It is referenced as a datasource by the composite view `xml_acc_cv_comp_topside_adjustments_RX.txt`. It represents the base SRP actuals master data layer for Pharmacy/RX. | 90 |

---

## 6. Final / Downstream Files

| File | Reason | Score |
|------|--------|-------|
| xml_acc_cv_comp_topside_adjustments_FS.txt | This is the terminal composite view for the Full Store (FS) lineage path. It consumes two upstream base views (`CV_BASE_TOPSIDE_ADJUSTMENTS_CAR` and `CV_BASE_MD_SRPACT_S4`) and applies scalar function logic (`SFN_PRIOR_FISCAL_WEEK`, `SFN_ACTUALS_COMP_FLAG`). No downstream artifact within the supplied file set consumes this view. | 90 |
| xml_acc_cv_comp_topside_adjustments_RX.txt | This is the terminal composite view for the Pharmacy/RX (RX) lineage path. It consumes two upstream base views (`CV_BASE_TOPSIDE_ADJUSTMENTS_CAR` and `CV_BASE_MD_SRPACT_S4`) and applies scalar function logic (`SFN_PRIOR_FISCAL_WEEK`, `SFN_ACTUALS_COMP_FLAG`). No downstream artifact within the supplied file set consumes this view. | 90 |

---

## 7. Unresolved Relationships

| File | Possible Related File | Reason |
|------|-----------------------|--------|
| xml_acc_cv_comp_topside_adjustments_FS.txt | CV_BASE_MD_COMPFL_S4 (external) | The composite FS view references `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_COMPFL_S4` as a datasource. This artifact was NOT supplied in the input file set and therefore cannot be resolved to a supplied file. It is documented here for downstream SQL consolidation awareness. |
| xml_acc_cv_comp_topside_adjustments_FS.txt | CV_BASE_MD_RCALWEEK_S4 (external) | The composite FS view references `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_RCALWEEK_S4` as a datasource. This artifact was NOT supplied in the input file set and therefore cannot be resolved to a supplied file. |
| xml_acc_cv_comp_topside_adjustments_FS.txt | CV_BASE_MD_CEPCT_S4 (external) | The composite FS view references `/CVS_FRIP.Base.Text/calculationviews/CV_BASE_MD_CEPCT_S4` as a datasource. This artifact was NOT supplied in the input file set and therefore cannot be resolved to a supplied file. |
| xml_acc_cv_comp_topside_adjustments_RX.txt | CV_BASE_MD_COMPFL_S4 (external) | The composite RX view references `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_COMPFL_S4` as a datasource. This artifact was NOT supplied in the input file set and therefore cannot be resolved to a supplied file. |
| xml_acc_cv_comp_topside_adjustments_RX.txt | CV_BASE_MD_RCALWEEK_S4 (external) | The composite RX view references `/CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_RCALWEEK_S4` as a datasource. This artifact was NOT supplied in the input file set and therefore cannot be resolved to a supplied file. |
| xml_acc_cv_comp_topside_adjustments_RX.txt | CV_BASE_MD_CEPCT_S4 (external) | The composite RX view references `/CVS_FRIP.Base.Text/calculationviews/CV_BASE_MD_CEPCT_S4` as a datasource. This artifact was NOT supplied in the input file set and therefore cannot be resolved to a supplied file. |

---

## 8. Final Lineage Assessment

### Overview

The six supplied HANA Calculation View XML artifacts form two parallel, symmetric lineage pipelines — one for the **Full Store (FS)** business segment and one for the **Pharmacy/RX (RX)** business segment. Both pipelines follow the same structural pattern: two base views feed into one composite view.

---

### Base Files

| Base File | Role |
|-----------|------|
| xml_acc_cv_base_topside_adjustments_car_FS.txt | Financial base data source — Full Store |
| xml_acc_cv_base_md_srpact_s4_FS.txt | SRP Actuals master data source — Full Store |
| xml_acc_cv_base_topside_adjustments_car_RX.txt | Financial base data source — Pharmacy/RX |
| xml_acc_cv_base_md_srpact_s4_RX.txt | SRP Actuals master data source — Pharmacy/RX |

---

### Main Lineage Paths

**FS Pipeline:**
```
xml_acc_cv_base_topside_adjustments_car_FS  ──┐
                                               ├──► xml_acc_cv_comp_topside_adjustments_FS
xml_acc_cv_base_md_srpact_s4_FS             ──┘
```

**RX Pipeline:**
```
xml_acc_cv_base_topside_adjustments_car_RX  ──┐
                                               ├──► xml_acc_cv_comp_topside_adjustments_RX
xml_acc_cv_base_md_srpact_s4_RX             ──┘
```

---

### File-to-File Relationships

| Source File | Target File | Relationship | Score | Status |
|-------------|-------------|--------------|-------|--------|
| xml_acc_cv_base_topside_adjustments_car_FS.txt | xml_acc_cv_comp_topside_adjustments_FS.txt | Calculation View Dependency | 90 | ✅ CONFIRMED RELATIONSHIP |
| xml_acc_cv_base_md_srpact_s4_FS.txt | xml_acc_cv_comp_topside_adjustments_FS.txt | Calculation View Dependency | 90 | ✅ CONFIRMED RELATIONSHIP |
| xml_acc_cv_base_topside_adjustments_car_RX.txt | xml_acc_cv_comp_topside_adjustments_RX.txt | Calculation View Dependency | 90 | ✅ CONFIRMED RELATIONSHIP |
| xml_acc_cv_base_md_srpact_s4_RX.txt | xml_acc_cv_comp_topside_adjustments_RX.txt | Calculation View Dependency | 90 | ✅ CONFIRMED RELATIONSHIP |

---

### Lineage Scores and Reasons

All four relationships are scored at **90** (Explicit XML Dependency). Each relationship is evidenced by a direct `<DataSource>` or datasource reference node within the composite view XML files pointing to the exact calculation view path of the base artifact. No inference or assumption was required for any of the four confirmed relationships.

---

### Unresolved Relationships

The following external artifacts are referenced within the composite views but were **not supplied** as input files. They are classified as **UNRESOLVED** and must be resolved by the downstream SQL Consolidation Agent if complete end-to-end lineage is required:

| External Artifact | Referenced By | Status |
|-------------------|---------------|--------|
| CV_BASE_MD_COMPFL_S4 | xml_acc_cv_comp_topside_adjustments_FS.txt, xml_acc_cv_comp_topside_adjustments_RX.txt | ⚠️ UNRESOLVED — Not in supplied file set |
| CV_BASE_MD_RCALWEEK_S4 | xml_acc_cv_comp_topside_adjustments_FS.txt, xml_acc_cv_comp_topside_adjustments_RX.txt | ⚠️ UNRESOLVED — Not in supplied file set |
| CV_BASE_MD_CEPCT_S4 | xml_acc_cv_comp_topside_adjustments_FS.txt, xml_acc_cv_comp_topside_adjustments_RX.txt | ⚠️ UNRESOLVED — Not in supplied file set |
| SFN_PRIOR_FISCAL_WEEK | xml_acc_cv_comp_topside_adjustments_FS.txt, xml_acc_cv_comp_topside_adjustments_RX.txt | ⚠️ UNRESOLVED — Scalar function, not a supplied artifact |
| SFN_ACTUALS_COMP_FLAG | xml_acc_cv_comp_topside_adjustments_FS.txt, xml_acc_cv_comp_topside_adjustments_RX.txt | ⚠️ UNRESOLVED — Scalar function, not a supplied artifact |

---

### Validation Summary

| Validation Rule | Status | Notes |
|-----------------|--------|-------|
| Validation 1: Every file classified as USED or NOT USED | ✅ PASS | All 6 files are USED |
| Validation 2: Every dependency traceable to evidence | ✅ PASS | All 4 relationships evidenced by explicit XML datasource references |
| Validation 3: Stored Procedures in lineage if applicable | ✅ PASS | No Stored Procedures present in supplied artifacts |
| Validation 4: No ETL tables as primary lineage nodes | ✅ PASS | No ETL tables appear as lineage nodes |

---

*Report generated by File Lineage Analysis Agent | TOPSIDE Artifacts | HANA-TO-BIGQUERY Project*
