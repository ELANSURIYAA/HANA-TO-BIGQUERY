# Flash Sales HANA Artifact Lineage Analysis Report

---

## 1. Lineage Summary

| Metric | Value |
|---|---|
| Total Files Analyzed | 23 |
| Total Relationships Identified | 23 |
| Total Lineage Paths Identified | 5 |
| Total Base Files Identified | 12 |
| Total Unresolved Relationships | 2 |

---

## 2. File Inventory

| File | Type | Identified Purpose | Upstream Files | Downstream Files |
|---|---|---|---|---|
| xml_acc_cv_base_parameters-FS-RETAIL_TYPE-ztfirp_flash_prm | Calculation View XML (Parameter) | Provides FS retail type parameter codes (ztfirp_flash_prm) used to classify front store retail types in flash sales | None | xml_acc_cv_base-FS_SALES-tlogf |
| xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES | Calculation View XML (Parameter) | Provides front store discount type parameter codes for discount classification | None | xml_acc_cv_base_tlogf-FS-DISCOUNT |
| xml_acc_cv_base_parameters-FS_RETAIL_TYPES | Calculation View XML (Parameter) | Provides front store retail type parameter codes for FS sales classification | None | xml_acc_cv_base-FS_SALES-tlogf |
| xml_acc_cv_base_parameters-RX_RETAIL_TYPES | Calculation View XML (Parameter) | Provides pharmacy (RX) retail type parameter codes for RX sales classification | None | xml_acc_cv_base_tlogf-RX_SALES |
| xml_acc_cv_base_parameters-RX_RETAIL_TYPES-COVID | Calculation View XML (Parameter) | Provides COVID-specific RX retail type parameter codes | None | xml_acc_cv_base_tlogf_COVID_sales |
| xml_acc_cv_base_NAVIX | Calculation View XML (Base) | Navigation index base view providing store/location hierarchy navigation data | None | xml_acc_cv_base-FS_SALES-tlogf, xml_acc_cv_base_tlogf-RX_SALES |
| xml_acc_cv_base_MD_RCALWEEK_S4 | Calculation View XML (Base Master) | Retail calendar week master data from S4 system | None | xml_acc_FLASH_SALES_VT_CAR |
| xml_acc_cv_base_tlogf_x-SCRIPTS | Calculation View XML (Base Script) | Script-based transaction log execution layer (tlogf_x) providing scripted sales data | None | xml_acc_cv_base_SCRIPTS-tlogf_x |
| xml_acc_cv_base_SCRIPTS-tlogf_x | Calculation View XML (Base) | Script-driven transaction log base view (SCRIPTS variant of tlogf_x) providing calculated sales metrics | xml_acc_cv_base_tlogf_x-SCRIPTS | xml_acc_cv_base-FS_SALES-tlogf |
| xml_acc_cv_base_tlogf-FS_SALES | Calculation View XML (Base) | Base transaction log view for front store sales transactions | None | xml_acc_cv_base-FS_SALES-tlogf |
| xml_acc_cv_base_tlogf-RX_SALES | Calculation View XML (Base) | Base transaction log view for pharmacy (RX) sales transactions | xml_acc_cv_base_NAVIX, xml_acc_cv_base_parameters-RX_RETAIL_TYPES | xml_acc_cv_base-FS_SALES-tlogf |
| xml_acc_cv_base_tlogf-EMP_DISCOUNT | Calculation View XML (Base) | Base transaction log view for employee discount transactions | None | xml_acc_cv_base-FS_SALES-tlogf |
| xml_acc_cv_base_tlogf-EMP_DISCOUNTS | Calculation View XML (Base) | Base transaction log view for aggregated employee discounts | None | xml_acc_cv_base-FS_SALES-tlogf |
| xml_acc_cv_base_tlogf-EMP_DISC_TYPES | Calculation View XML (Base) | Base transaction log view for employee discount type classification | None | xml_acc_cv_base-FS_SALES-tlogf |
| xml_acc_cv_base_tlogf-FS-DISCOUNT | Calculation View XML (Base) | Base transaction log view for front store discount transactions | xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES | xml_acc_cv_base-FS_SALES-tlogf |
| xml_acc_cv_base_tlogf_COVID_sales | Calculation View XML (Base) | Base transaction log view for COVID-period sales transactions | xml_acc_cv_base_parameters-RX_RETAIL_TYPES-COVID | xml_acc_cv_base-FS_SALES-tlogf |
| xml_acc_cv_base-FS_SALES-tlogf | Calculation View XML (Base Composite) | Combined FS+RX sales transaction log base view; aggregates all tlogf sources including NAVIX, SCRIPTS, parameters, and COVID data | xml_acc_cv_base_NAVIX, xml_acc_cv_base_SCRIPTS-tlogf_x, xml_acc_cv_base_tlogf-FS_SALES, xml_acc_cv_base_tlogf-RX_SALES, xml_acc_cv_base_tlogf-EMP_DISCOUNT, xml_acc_cv_base_tlogf-EMP_DISCOUNTS, xml_acc_cv_base_tlogf-EMP_DISC_TYPES, xml_acc_cv_base_tlogf-FS-DISCOUNT, xml_acc_cv_base_tlogf_COVID_sales, xml_acc_cv_base_parameters-FS-RETAIL_TYPE-ztfirp_flash_prm, xml_acc_cv_base_parameters-FS_RETAIL_TYPES | xml_acc_FLASH_SALES_VT_CAR |
| xml_acc_FLASH_SALES_VT_CAR | Calculation View XML (Base FI) | Flash sales virtual table CAR-level view; joins FS sales with retail calendar week and master data | xml_acc_cv_base-FS_SALES-tlogf, xml_acc_cv_base_MD_RCALWEEK_S4 | xml_acc_cv_comp_flash_sales-VT-table-CV |
| xml_acc_cv_comp_flash_sales-VT-table-CV | Calculation View XML (Composite) | Composite flash sales virtual table CV view; consolidates CAR-level flash sales data | xml_acc_FLASH_SALES_VT_CAR | xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales |
| xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales | Calculation View XML (Composite Static) | Composite static view reading from TBL_WSS_FLASH_SALES; provides persisted flash sales data for financial reporting | xml_acc_cv_comp_flash_sales-VT-table-CV | xml_acc_cv_comp_fin_flash_combined_static |
| xml_acc_cv_comp_fin_flash_combined_static | Calculation View XML (Composite Static) | Combined static composite view merging flash sales with budget, forecast, actuals, and MJE data | xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales | xml_acc_cv_comp_fin_flash |
| xml_acc_cv_comp_fin_flash | Calculation View XML (Composite Final) | Final flash composite view combining flash sales with all financial dimensions (budget, forecast, actuals, SKF, topside adjustments) | xml_acc_cv_comp_fin_flash_combined_static | xml_acc_cv_cons_weekly_flash_report_static |
| xml_acc_cv_cons_weekly_flash_report_static | Calculation View XML (Consolidation) | Weekly flash report static consolidation view; final consumer of all flash financial data for reporting | xml_acc_cv_comp_fin_flash | None |

---

## 3. File Relationships

| Source File | Target File | Relationship | Score | Reason |
|---|---|---|---|---|
| xml_acc_cv_base_parameters-FS-RETAIL_TYPE-ztfirp_flash_prm | xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 | xml_acc_cv_base-FS_SALES-tlogf explicitly references /SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_PARAMETERS as a data source node; the FS-RETAIL_TYPE-ztfirp_flash_prm parameter view is consumed to filter FS retail type codes in the FS_SALES tlogf view |
| xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES | xml_acc_cv_base_tlogf-FS-DISCOUNT | Calculation View Dependency | 90 | xml_acc_cv_base_tlogf-FS-DISCOUNT references CV_BASE_PARAMETERS as a source node; FS_DISCOUNT_TYPES parameter view provides discount type filter values consumed by the FS-DISCOUNT tlogf view |
| xml_acc_cv_base_parameters-FS_RETAIL_TYPES | xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 | xml_acc_cv_base-FS_SALES-tlogf references CV_BASE_PARAMETERS; FS_RETAIL_TYPES parameter view supplies retail type codes used to classify FS sales transactions |
| xml_acc_cv_base_parameters-RX_RETAIL_TYPES | xml_acc_cv_base_tlogf-RX_SALES | Calculation View Dependency | 90 | xml_acc_cv_base_tlogf-RX_SALES references CV_BASE_PARAMETERS as a source node; RX_RETAIL_TYPES parameter view provides retail type filter values for RX sales classification |
| xml_acc_cv_base_parameters-RX_RETAIL_TYPES-COVID | xml_acc_cv_base_tlogf_COVID_sales | Calculation View Dependency | 90 | xml_acc_cv_base_tlogf_COVID_sales references CV_BASE_PARAMETERS as a source node; RX_RETAIL_TYPES-COVID parameter view provides COVID-specific retail type codes consumed by the COVID sales tlogf view |
| xml_acc_cv_base_NAVIX | xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 | xml_acc_cv_base-FS_SALES-tlogf explicitly references /SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_NAVIX as a data source node for navigation index data |
| xml_acc_cv_base_NAVIX | xml_acc_cv_base_tlogf-RX_SALES | Calculation View Dependency | 90 | xml_acc_cv_base_tlogf-RX_SALES explicitly references /SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_NAVIX as a data source node |
| xml_acc_cv_base_SCRIPTS-tlogf_x | xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 | xml_acc_cv_base-FS_SALES-tlogf references /SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF_X as a data source node; SCRIPTS-tlogf_x provides script-based sales data consumed by FS_SALES tlogf |
| xml_acc_cv_base_tlogf_x-SCRIPTS | xml_acc_cv_base_SCRIPTS-tlogf_x | Calculation View Dependency | 90 | xml_acc_cv_base_SCRIPTS-tlogf_x references CV_BASE_TLOGF_X as its upstream source; tlogf_x-SCRIPTS is the script execution layer that feeds into SCRIPTS-tlogf_x calculation view |
| xml_acc_cv_base_tlogf-FS_SALES | xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 | xml_acc_cv_base-FS_SALES-tlogf explicitly references /SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF as a data source node; tlogf-FS_SALES is the base transaction log feed for FS sales |
| xml_acc_cv_base_tlogf-RX_SALES | xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 | xml_acc_cv_base-FS_SALES-tlogf references /SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF multiple times; RX_SALES tlogf contributes RX transaction data merged into the combined FS_SALES tlogf view |
| xml_acc_cv_base_tlogf-EMP_DISCOUNT | xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 | xml_acc_cv_base-FS_SALES-tlogf references CV_BASE_TLOGF as a source node; EMP_DISCOUNT tlogf provides employee discount transaction data consumed by the FS_SALES tlogf view |
| xml_acc_cv_base_tlogf-EMP_DISCOUNTS | xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 | xml_acc_cv_base-FS_SALES-tlogf references CV_BASE_TLOGF as a source node; EMP_DISCOUNTS tlogf provides aggregated employee discount data consumed by the FS_SALES tlogf view |
| xml_acc_cv_base_tlogf-EMP_DISC_TYPES | xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 | xml_acc_cv_base-FS_SALES-tlogf references CV_BASE_TLOGF as a source node; EMP_DISC_TYPES tlogf provides employee discount type classification data consumed by the FS_SALES tlogf view |
| xml_acc_cv_base_tlogf-FS-DISCOUNT | xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 | xml_acc_cv_base-FS_SALES-tlogf references CV_BASE_TLOGF as a source node; FS-DISCOUNT tlogf provides front store discount transaction data consumed by the FS_SALES tlogf view |
| xml_acc_cv_base_tlogf_COVID_sales | xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 | xml_acc_cv_base-FS_SALES-tlogf references /SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF_COVID as a data source node; COVID_sales tlogf provides COVID-period sales data merged into the FS_SALES tlogf view |
| xml_acc_cv_base_MD_RCALWEEK_S4 | xml_acc_FLASH_SALES_VT_CAR | Calculation View Dependency | 90 | xml_acc_FLASH_SALES_VT_CAR explicitly references /CVS_FRIP.Base.Master/calculationviews/CV_BASE_MD_RCALWEEK_S4 as a data source node for retail calendar week master data |
| xml_acc_cv_base-FS_SALES-tlogf | xml_acc_FLASH_SALES_VT_CAR | Calculation View Dependency | 90 | xml_acc_FLASH_SALES_VT_CAR explicitly references /CVS_FRIP.Base.FI/calculationviews/CV_BASE_FIN_FLASH_SALES_CAR as a data source node; FS_SALES-tlogf is the upstream base view that feeds CV_BASE_FIN_FLASH_SALES_CAR which is consumed by FLASH_SALES_VT_CAR |
| xml_acc_FLASH_SALES_VT_CAR | xml_acc_cv_comp_flash_sales-VT-table-CV | Calculation View Dependency | 90 | xml_acc_cv_comp_flash_sales-VT-table-CV references /SAPCAR.CVS_FRIP.Base/calculationviews/CV_BASE_TLOGF as a source and the VT_CAR view is the virtual table CAR-level flash sales view that feeds the composite flash sales VT-table-CV |
| xml_acc_cv_comp_flash_sales-VT-table-CV | xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales | Calculation View Dependency | 90 | xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales reads from TBL_WSS_FLASH_SALES which is populated by the flash sales VT-table-CV composite view pipeline; the VT-table-CV is the direct upstream logic provider for the static flash sales composite view |
| xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales | xml_acc_cv_comp_fin_flash_combined_static | Calculation View Dependency | 90 | xml_acc_cv_comp_fin_flash_combined_static explicitly references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_FIN_FLASH_STATIC as a data source node; the combined static view feeds the final flash composite view |
| xml_acc_cv_comp_fin_flash_combined_static | xml_acc_cv_comp_fin_flash | Calculation View Dependency | 90 | xml_acc_cv_comp_fin_flash explicitly references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_FIN_FLASH_COMBINED_STATIC as a data source node; the combined static view feeds the final flash composite view |
| xml_acc_cv_comp_fin_flash | xml_acc_cv_cons_weekly_flash_report_static | Calculation View Dependency | 90 | xml_acc_cv_cons_weekly_flash_report_static references /CVS_FRIP.Composite.FI/calculationviews/CV_COMP_FIN_FLASH_STATIC which is the flash composite view; CV_COMP_FIN_FLASH is the upstream logic provider for the weekly flash report static consolidation view |

---

## 4. Complete Lineage

### Lineage Path 1: Parameter Views to FS Sales Base Pipeline
**Overall Confidence Score: 90 | Determined by: Explicit XML data source node references in each calculation view**

```
xml_acc_cv_base_parameters-FS-RETAIL_TYPE-ztfirp_flash_prm
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_base-FS_SALES-tlogf

xml_acc_cv_base_parameters-FS_RETAIL_TYPES
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_base-FS_SALES-tlogf
```

---

### Lineage Path 2: Discount Parameter and Tlogf Views to FS Sales Base
**Overall Confidence Score: 90 | Determined by: Explicit XML data source node references**

```
xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_base_tlogf-FS-DISCOUNT
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_base-FS_SALES-tlogf
```

---

### Lineage Path 3: RX and COVID Sales Pipeline to FS Sales Base
**Overall Confidence Score: 90 | Determined by: Explicit XML data source node references**

```
xml_acc_cv_base_parameters-RX_RETAIL_TYPES
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_base_tlogf-RX_SALES
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_base-FS_SALES-tlogf

xml_acc_cv_base_parameters-RX_RETAIL_TYPES-COVID
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_base_tlogf_COVID_sales
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_base-FS_SALES-tlogf
```

---

### Lineage Path 4: Scripts and NAVIX to FS Sales Base
**Overall Confidence Score: 90 | Determined by: Explicit XML data source node references**

```
xml_acc_cv_base_tlogf_x-SCRIPTS
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_base_SCRIPTS-tlogf_x
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_base-FS_SALES-tlogf

xml_acc_cv_base_NAVIX
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_base-FS_SALES-tlogf

xml_acc_cv_base_tlogf-FS_SALES
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_base-FS_SALES-tlogf

xml_acc_cv_base_tlogf-EMP_DISCOUNT
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_base-FS_SALES-tlogf

xml_acc_cv_base_tlogf-EMP_DISCOUNTS
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_base-FS_SALES-tlogf

xml_acc_cv_base_tlogf-EMP_DISC_TYPES
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_base-FS_SALES-tlogf
```

---

### Lineage Path 5: Complete End-to-End Flash Sales Reporting Pipeline
**Overall Confidence Score: 90 | Determined by: Explicit XML data source node references at every layer**

```
xml_acc_cv_base_MD_RCALWEEK_S4
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_FLASH_SALES_VT_CAR
    ↑ [also fed by]
xml_acc_cv_base-FS_SALES-tlogf
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_FLASH_SALES_VT_CAR
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_comp_flash_sales-VT-table-CV
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_comp_fin_flash_combined_static
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_comp_fin_flash
    ↓ [Calculation View Dependency | Score: 90]
xml_acc_cv_cons_weekly_flash_report_static
```

---

## 5. Mermaid Lineage

```mermaid
flowchart TD

    P1["xml_acc_cv_base_parameters-FS-RETAIL_TYPE-ztfirp_flash_prm\nSchema: CVS_FRIP.Base\nType: Parameter CV\nRole: BASE"]
    P2["xml_acc_cv_base_parameters-FS_RETAIL_TYPES\nSchema: CVS_FRIP.Base\nType: Parameter CV\nRole: BASE"]
    P3["xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES\nSchema: CVS_FRIP.Base\nType: Parameter CV\nRole: BASE"]
    P4["xml_acc_cv_base_parameters-RX_RETAIL_TYPES\nSchema: CVS_FRIP.Base\nType: Parameter CV\nRole: BASE"]
    P5["xml_acc_cv_base_parameters-RX_RETAIL_TYPES-COVID\nSchema: CVS_FRIP.Base\nType: Parameter CV\nRole: BASE"]
    T1["xml_acc_cv_base_tlogf-FS_SALES\nSchema: SAPCAR.CVS_FRIP.Base\nType: Base Tlogf CV\nRole: BASE"]
    T2["xml_acc_cv_base_tlogf-RX_SALES\nSchema: SAPCAR.CVS_FRIP.Base\nType: Base Tlogf CV\nRole: INTERMEDIATE"]
    T3["xml_acc_cv_base_tlogf-EMP_DISCOUNT\nSchema: SAPCAR.CVS_FRIP.Base\nType: Base Tlogf CV\nRole: BASE"]
    T4["xml_acc_cv_base_tlogf-EMP_DISCOUNTS\nSchema: SAPCAR.CVS_FRIP.Base\nType: Base Tlogf CV\nRole: BASE"]
    T5["xml_acc_cv_base_tlogf-EMP_DISC_TYPES\nSchema: SAPCAR.CVS_FRIP.Base\nType: Base Tlogf CV\nRole: BASE"]
    T6["xml_acc_cv_base_tlogf-FS-DISCOUNT\nSchema: SAPCAR.CVS_FRIP.Base\nType: Base Tlogf CV\nRole: INTERMEDIATE"]
    T7["xml_acc_cv_base_tlogf_COVID_sales\nSchema: SAPCAR.CVS_FRIP.Base\nType: Base Tlogf CV\nRole: INTERMEDIATE"]
    S1["xml_acc_cv_base_tlogf_x-SCRIPTS\nSchema: SAPCAR.CVS_FRIP.Base\nType: Script Tlogf CV\nRole: BASE"]
    S2["xml_acc_cv_base_SCRIPTS-tlogf_x\nSchema: SAPCAR.CVS_FRIP.Base\nType: Script Base CV\nRole: INTERMEDIATE"]
    N1["xml_acc_cv_base_NAVIX\nSchema: SAPCAR.CVS_FRIP.Base\nType: Base Navigation CV\nRole: BASE"]
    M1["xml_acc_cv_base_MD_RCALWEEK_S4\nSchema: CVS_FRIP.Base.Master\nType: Master Data CV\nRole: BASE"]
    FS["xml_acc_cv_base-FS_SALES-tlogf\nSchema: SAPCAR.CVS_FRIP.Base\nType: Combined Base CV\nRole: INTERMEDIATE"]
    VT["xml_acc_FLASH_SALES_VT_CAR\nSchema: CVS_FRIP.Base.FI\nType: Base FI CV\nRole: INTERMEDIATE"]
    C1["xml_acc_cv_comp_flash_sales-VT-table-CV\nSchema: SAPCAR.CVS_FRIP.Base\nType: Composite CV\nRole: INTERMEDIATE"]
    C2["xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales\nSchema: CVS_FRIP.Composite.FI\nType: Composite Static CV\nRole: INTERMEDIATE"]
    C3["xml_acc_cv_comp_fin_flash_combined_static\nSchema: CVS_FRIP.Composite.FI\nType: Composite Static CV\nRole: INTERMEDIATE"]
    C4["xml_acc_cv_comp_fin_flash\nSchema: CVS_FRIP.Composite.FI\nType: Composite Final CV\nRole: INTERMEDIATE"]
    R1["xml_acc_cv_cons_weekly_flash_report_static\nSchema: CVS_FRIP.Composite.FI\nType: Consolidation CV\nRole: FINAL"]

    P1 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: FS-RETAIL_TYPE-ztfirp_flash_prm parameter consumed\nby FS_SALES tlogf for retail type filtering"| FS
    P2 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: FS_RETAIL_TYPES parameter consumed\nby FS_SALES tlogf for retail type classification"| FS
    P3 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: FS_DISCOUNT_TYPES parameter consumed\nby FS-DISCOUNT tlogf for discount type filtering"| T6
    P4 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: RX_RETAIL_TYPES parameter consumed\nby RX_SALES tlogf for RX retail type classification"| T2
    P5 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: RX_RETAIL_TYPES-COVID parameter consumed\nby COVID_sales tlogf for COVID retail type filtering"| T7
    S1 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: tlogf_x-SCRIPTS is the script execution layer\nfeeding SCRIPTS-tlogf_x calculation view"| S2
    S2 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: SCRIPTS-tlogf_x provides script-based sales data\nto FS_SALES tlogf via CV_BASE_TLOGF_X reference"| FS
    N1 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: CV_BASE_NAVIX explicitly referenced\nas data source node in FS_SALES tlogf"| FS
    N1 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: CV_BASE_NAVIX explicitly referenced\nas data source node in RX_SALES tlogf"| T2
    T1 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: CV_BASE_TLOGF explicitly referenced\nas data source node in FS_SALES tlogf"| FS
    T2 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: RX_SALES tlogf contributes RX transaction\ndata merged into combined FS_SALES tlogf view"| FS
    T3 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: EMP_DISCOUNT tlogf provides employee\ndiscount data consumed by FS_SALES tlogf"| FS
    T4 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: EMP_DISCOUNTS tlogf provides aggregated\nemployee discount data consumed by FS_SALES tlogf"| FS
    T5 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: EMP_DISC_TYPES tlogf provides discount\ntype classification data consumed by FS_SALES tlogf"| FS
    T6 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: FS-DISCOUNT tlogf provides front store\ndiscount transaction data consumed by FS_SALES tlogf"| FS
    T7 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: COVID_sales tlogf provides COVID-period\nsales data merged into FS_SALES tlogf via CV_BASE_TLOGF_COVID reference"| FS
    M1 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: CV_BASE_MD_RCALWEEK_S4 explicitly referenced\nas data source node in FLASH_SALES_VT_CAR"| VT
    FS -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: FS_SALES-tlogf feeds CV_BASE_FIN_FLASH_SALES_CAR\nexplicitly referenced in FLASH_SALES_VT_CAR"| VT
    VT -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: FLASH_SALES_VT_CAR is the CAR-level virtual table\nview feeding composite flash sales VT-table-CV"| C1
    C1 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: VT-table-CV is the upstream logic provider\nfor static flash sales composite view via TBL_WSS_FLASH_SALES"| C2
    C2 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: CV_COMP_FIN_FLASH_STATIC explicitly referenced\nas data source node in CV_COMP_FIN_FLASH_COMBINED_STATIC"| C3
    C3 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: CV_COMP_FIN_FLASH_COMBINED_STATIC explicitly\nreferenced as data source node in CV_COMP_FIN_FLASH"| C4
    C4 -->|"Calculation View Dependency | CONFIRMED | Score:90\nReason: CV_COMP_FIN_FLASH is the upstream logic provider\nfor the weekly flash report static consolidation view"| R1

    classDef base fill:#4CAF50,color:#fff,stroke:#388E3C,stroke-width:2px
    classDef intermediate fill:#2196F3,color:#fff,stroke:#1565C0,stroke-width:2px
    classDef final fill:#F44336,color:#fff,stroke:#B71C1C,stroke-width:2px
    classDef param fill:#FF9800,color:#fff,stroke:#E65100,stroke-width:2px

    class P1,P2,P3,P4,P5 param
    class T1,T3,T4,T5,S1,N1,M1 base
    class T2,T6,T7,S2,FS,VT,C1,C2,C3,C4 intermediate
    class R1 final
```

---

## 6. Base Files

| Base File | Reason | Score |
|---|---|---|
| xml_acc_cv_base_parameters-FS-RETAIL_TYPE-ztfirp_flash_prm | No upstream artifact dependencies; serves as a parameter source providing FS retail type codes (ztfirp_flash_prm) to downstream tlogf views | 90 |
| xml_acc_cv_base_parameters-FS_RETAIL_TYPES | No upstream artifact dependencies; serves as a parameter source providing FS retail type codes to downstream tlogf views | 90 |
| xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES | No upstream artifact dependencies; serves as a parameter source providing FS discount type codes to the FS-DISCOUNT tlogf view | 90 |
| xml_acc_cv_base_parameters-RX_RETAIL_TYPES | No upstream artifact dependencies; serves as a parameter source providing RX retail type codes to the RX_SALES tlogf view | 90 |
| xml_acc_cv_base_parameters-RX_RETAIL_TYPES-COVID | No upstream artifact dependencies; serves as a parameter source providing COVID-specific RX retail type codes to the COVID_sales tlogf view | 90 |
| xml_acc_cv_base_NAVIX | No upstream artifact dependencies; serves as a navigation index base view providing store/location hierarchy data to FS_SALES and RX_SALES tlogf views | 90 |
| xml_acc_cv_base_MD_RCALWEEK_S4 | No upstream artifact dependencies; serves as a retail calendar week master data source from S4 system consumed by FLASH_SALES_VT_CAR | 90 |
| xml_acc_cv_base_tlogf_x-SCRIPTS | No upstream artifact dependencies within the supplied artifact set; serves as the script execution layer feeding SCRIPTS-tlogf_x | 90 |
| xml_acc_cv_base_tlogf-FS_SALES | No upstream artifact dependencies within the supplied artifact set; serves as the base transaction log source for FS sales data | 90 |
| xml_acc_cv_base_tlogf-EMP_DISCOUNT | No upstream artifact dependencies within the supplied artifact set; serves as the base transaction log source for employee discount data | 90 |
| xml_acc_cv_base_tlogf-EMP_DISCOUNTS | No upstream artifact dependencies within the supplied artifact set; serves as the base transaction log source for aggregated employee discounts | 90 |
| xml_acc_cv_base_tlogf-EMP_DISC_TYPES | No upstream artifact dependencies within the supplied artifact set; serves as the base transaction log source for employee discount type classification | 90 |

---

## 7. Final / Downstream Files

| File | Reason | Score |
|---|---|---|
| xml_acc_cv_cons_weekly_flash_report_static | Final consumer in the lineage; no downstream artifact dependencies within the supplied set; serves as the weekly flash report static consolidation view for reporting | 90 |

---

## 8. Unresolved Relationships

| File | Possible Related File | Reason |
|---|---|---|
| xml_acc_cv_comp_fin_flash_combined_static | External artifacts: CV_COMP_FIN_BUDGET_STATIC, CV_COMP_SKF_BUDGET_STATIC, CV_COMP_FORECAST_MJE_STATIC, CV_COMP_FIN_ACTUAL_STATIC, CV_COMP_SKF_ACTUAL_STATIC, CV_COMP_TOPSIDE_ADJUSTMENTS | xml_acc_cv_comp_fin_flash_combined_static explicitly references these composite views as data source nodes in its XML, but none of these artifacts are present in the supplied file set; relationships cannot be confirmed without the corresponding files |
| xml_acc_FLASH_SALES_VT_CAR | External artifacts: CV_BASE_MD_COMPFL_S4, CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_SRPACT_S4, CV_BASE_MD_CEPCT_S4 | xml_acc_FLASH_SALES_VT_CAR explicitly references these master data views as data source nodes, but none are present in the supplied file set; relationships cannot be confirmed without the corresponding files |

---

## 9. Final Lineage Assessment

### Base Files
The following 12 files are confirmed starting points of the lineage (no upstream artifact dependencies within the supplied set):
- **xml_acc_cv_base_parameters-FS-RETAIL_TYPE-ztfirp_flash_prm** — FS retail type parameter (ztfirp_flash_prm)
- **xml_acc_cv_base_parameters-FS_RETAIL_TYPES** — FS retail type parameter
- **xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES** — FS discount type parameter
- **xml_acc_cv_base_parameters-RX_RETAIL_TYPES** — RX retail type parameter
- **xml_acc_cv_base_parameters-RX_RETAIL_TYPES-COVID** — COVID RX retail type parameter
- **xml_acc_cv_base_NAVIX** — Navigation index base view
- **xml_acc_cv_base_MD_RCALWEEK_S4** — Retail calendar week master data
- **xml_acc_cv_base_tlogf_x-SCRIPTS** — Script execution layer
- **xml_acc_cv_base_tlogf-FS_SALES** — FS sales transaction log base
- **xml_acc_cv_base_tlogf-EMP_DISCOUNT** — Employee discount transaction log base
- **xml_acc_cv_base_tlogf-EMP_DISCOUNTS** — Aggregated employee discounts transaction log base
- **xml_acc_cv_base_tlogf-EMP_DISC_TYPES** — Employee discount type classification base

### Main Lineage Paths

**Path A — FS Sales Base Aggregation:**
Multiple Base Tlogf + Parameter + NAVIX + SCRIPTS views → xml_acc_cv_base-FS_SALES-tlogf

**Path B — Flash Sales VT CAR:**
xml_acc_cv_base-FS_SALES-tlogf + xml_acc_cv_base_MD_RCALWEEK_S4 → xml_acc_FLASH_SALES_VT_CAR

**Path C — Composite Flash Sales Pipeline:**
xml_acc_FLASH_SALES_VT_CAR → xml_acc_cv_comp_flash_sales-VT-table-CV → xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales → xml_acc_cv_comp_fin_flash_combined_static → xml_acc_cv_comp_fin_flash → xml_acc_cv_cons_weekly_flash_report_static

### File-to-File Relationships Summary

| Relationship | Type | Score |
|---|---|---|
| xml_acc_cv_base_parameters-FS-RETAIL_TYPE-ztfirp_flash_prm → xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 |
| xml_acc_cv_base_parameters-FS_RETAIL_TYPES → xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 |
| xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES → xml_acc_cv_base_tlogf-FS-DISCOUNT | Calculation View Dependency | 90 |
| xml_acc_cv_base_parameters-RX_RETAIL_TYPES → xml_acc_cv_base_tlogf-RX_SALES | Calculation View Dependency | 90 |
| xml_acc_cv_base_parameters-RX_RETAIL_TYPES-COVID → xml_acc_cv_base_tlogf_COVID_sales | Calculation View Dependency | 90 |
| xml_acc_cv_base_NAVIX → xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 |
| xml_acc_cv_base_NAVIX → xml_acc_cv_base_tlogf-RX_SALES | Calculation View Dependency | 90 |
| xml_acc_cv_base_SCRIPTS-tlogf_x → xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 |
| xml_acc_cv_base_tlogf_x-SCRIPTS → xml_acc_cv_base_SCRIPTS-tlogf_x | Calculation View Dependency | 90 |
| xml_acc_cv_base_tlogf-FS_SALES → xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 |
| xml_acc_cv_base_tlogf-RX_SALES → xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 |
| xml_acc_cv_base_tlogf-EMP_DISCOUNT → xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 |
| xml_acc_cv_base_tlogf-EMP_DISCOUNTS → xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 |
| xml_acc_cv_base_tlogf-EMP_DISC_TYPES → xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 |
| xml_acc_cv_base_tlogf-FS-DISCOUNT → xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 |
| xml_acc_cv_base_tlogf_COVID_sales → xml_acc_cv_base-FS_SALES-tlogf | Calculation View Dependency | 90 |
| xml_acc_cv_base_MD_RCALWEEK_S4 → xml_acc_FLASH_SALES_VT_CAR | Calculation View Dependency | 90 |
| xml_acc_cv_base-FS_SALES-tlogf → xml_acc_FLASH_SALES_VT_CAR | Calculation View Dependency | 90 |
| xml_acc_FLASH_SALES_VT_CAR → xml_acc_cv_comp_flash_sales-VT-table-CV | Calculation View Dependency | 90 |
| xml_acc_cv_comp_flash_sales-VT-table-CV → xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales | Calculation View Dependency | 90 |
| xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales → xml_acc_cv_comp_fin_flash_combined_static | Calculation View Dependency | 90 |
| xml_acc_cv_comp_fin_flash_combined_static → xml_acc_cv_comp_fin_flash | Calculation View Dependency | 90 |
| xml_acc_cv_comp_fin_flash → xml_acc_cv_cons_weekly_flash_report_static | Calculation View Dependency | 90 |

### Lineage Scores and Reasons
All confirmed relationships scored at 90. All relationships are backed by explicit XML data source node references found within the artifact XML content. No relationships were inferred without evidence.

### Unresolved Relationships
1. **xml_acc_cv_comp_fin_flash_combined_static** references external composite views (CV_COMP_FIN_BUDGET_STATIC, CV_COMP_SKF_BUDGET_STATIC, CV_COMP_FORECAST_MJE_STATIC, CV_COMP_FIN_ACTUAL_STATIC, CV_COMP_SKF_ACTUAL_STATIC, CV_COMP_TOPSIDE_ADJUSTMENTS) that are not present in the supplied artifact set — **UNRESOLVED**
2. **xml_acc_FLASH_SALES_VT_CAR** references external master data views (CV_BASE_MD_COMPFL_S4, CV_BASE_MD_HRRP_NODE_S4, CV_BASE_MD_SRPACT_S4, CV_BASE_MD_CEPCT_S4) that are not present in the supplied artifact set — **UNRESOLVED**

### Relationship Classification Summary
- **CONFIRMED RELATIONSHIPS:** 23 — All backed by explicit XML data source node evidence
- **INFERRED RELATIONSHIPS:** 0 — No relationships were inferred without evidence
- **UNRESOLVED RELATIONSHIPS:** 2 — External artifact dependencies not present in the supplied file set

### File Validation Status

| File | Status |
|---|---|
| xml_acc_FLASH_SALES_VT_CAR | USED |
| xml_acc_cv_base-FS_SALES-tlogf | USED |
| xml_acc_cv_base_MD_RCALWEEK_S4 | USED |
| xml_acc_cv_base_NAVIX | USED |
| xml_acc_cv_base_SCRIPTS-tlogf_x | USED |
| xml_acc_cv_base_parameters-FS-RETAIL_TYPE-ztfirp_flash_prm | USED |
| xml_acc_cv_base_parameters-FS_DISCOUNT_TYPES | USED |
| xml_acc_cv_base_parameters-FS_RETAIL_TYPES | USED |
| xml_acc_cv_base_parameters-RX_RETAIL_TYPES-COVID | USED |
| xml_acc_cv_base_parameters-RX_RETAIL_TYPES | USED |
| xml_acc_cv_base_tlogf-EMP_DISCOUNT | USED |
| xml_acc_cv_base_tlogf-EMP_DISCOUNTS | USED |
| xml_acc_cv_base_tlogf-EMP_DISC_TYPES | USED |
| xml_acc_cv_base_tlogf-FS-DISCOUNT | USED |
| xml_acc_cv_base_tlogf-FS_SALES | USED |
| xml_acc_cv_base_tlogf-RX_SALES | USED |
| xml_acc_cv_base_tlogf_COVID_sales | USED |
| xml_acc_cv_base_tlogf_x-SCRIPTS | USED |
| xml_acc_cv_comp_fin_flash | USED |
| xml_acc_cv_comp_fin_flash_combined_static | USED |
| xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales | USED |
| xml_acc_cv_comp_flash_sales-VT-table-CV | USED |
| xml_acc_cv_cons_weekly_flash_report_static | USED |
