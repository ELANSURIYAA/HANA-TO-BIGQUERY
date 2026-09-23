# HANA Flash Sales Reporting - Friendly Lineage Summary

## Executive Summary

This document provides a business-friendly summary of the **Flash Sales Reporting System** data lineage analysis. The system processes retail transaction data from multiple sources—including Front Store sales, Pharmacy sales, and prescription scripts—through a sophisticated three-tier architecture to produce a consolidated weekly flash sales report for executive decision-making.

### What This System Does

The Flash Sales Reporting System is designed to:
- **Capture** daily transaction data from point-of-sale systems across Front Store and Pharmacy operations
- **Transform** raw transaction logs into meaningful business metrics
- **Enrich** sales data with store attributes, fiscal calendar information, and budget comparisons
- **Persist** weekly snapshots for historical trend analysis
- **Deliver** a consolidated weekly flash report combining actuals, budget, and forecast data

### Overall Data Flow

The data flows through the following logical stages:

**Source Data** (Transaction Logs & Master Data)  
↓  
**Data Preparation** (Base Calculation Views)  
↓  
**Data Integration** (Flash Sales Virtual Table)  
↓  
**Data Enrichment** (Composite Views with Master Data)  
↓  
**Data Persistence** (Weekly Snapshot via Stored Procedures)  
↓  
**Final Reporting** (Combined Static Views & Consolidated Report)

### Key Metrics

| Metric | Value |
|--------|-------|
| **Total Files Analyzed** | 32 |
| **Total Relationships Identified** | 47 |
| **Base/Source Files** | 13 (7 database tables + 6 base views) |
| **Major Lineage Paths** | 3 |
| **Final Output** | 1 (Consolidated Weekly Flash Report) |
| **Overall Confidence Score** | 95/100 |
| **Unresolved Relationships** | 2 (possible duplicates) |

---

## Key Data Flow

### 1. Source Components

The system begins with the following data sources:

#### Transaction Data Sources
- **TLOGF** - Transaction log table containing:
  - Front Store sales transactions
  - Front Store discounts
  - Employee discounts
  - COVID-related sales
- **TLOGF_X** - Transaction log table containing:
  - Prescription scripts data
  - Pharmacy transaction details

#### Master Data Sources
- **NAVIX** - Store navigation index for store identification
- **PARAMETERS** - Configuration parameters defining:
  - Retail types (Front Store and Pharmacy)
  - Discount types
  - Employee discount categories
  - COVID-related retail types

#### Budget & Calendar Sources
- **AZSRP_DS052_VT_S4** - Frozen budget cube (weekly snapshot)
- **AZSRP_DS041_VT_S4** - Live budget cube (current budget)
- **MD_RCALWEEK_S4** - Retail calendar week for fiscal period mapping

### 2. Major Processing Stages

#### Stage 1: Data Preparation (Base Layer)

**Purpose:** Extract and prepare raw data from source tables

**Key Components:**
- **xml_acc_cv_base_tlogf-FS_SALES** - Extracts Front Store sales from TLOGF
- **xml_acc_cv_base_tlogf-RX_SALES** - Extracts Pharmacy sales from TLOGF
- **xml_acc_cv_base_tlogf_x-SCRIPTS** - Extracts prescription scripts from TLOGF_X
- **xml_acc_cv_base_tlogf-FS-DISCOUNT** - Extracts Front Store discounts
- **xml_acc_cv_base_tlogf-EMP_DISCOUNT** - Extracts employee discounts
- **xml_acc_cv_base_tlogf_COVID_sales** - Extracts COVID-related sales
- **xml_acc_cv_base_NAVIX** - Prepares store navigation data
- **Multiple parameter views** - Prepare configuration parameters

**What Happens:** Raw transaction data is filtered, cleaned, and structured into specific business categories (sales, discounts, scripts, etc.). Each base view focuses on a specific data element and applies initial business rules.

**Why Important:** This layer ensures data quality and consistency before integration. It separates concerns and makes the system maintainable by isolating specific data extraction logic.

#### Stage 2: Data Integration (Virtual Table Layer)

**Purpose:** Combine all transaction data into a unified view

**Key Component:**
- **xml_acc_FLASH_SALES_VT_CAR** - Flash Sales Virtual Table from CAR system

**What Happens:** This is the central integration point where all sales, discounts, scripts, and configuration data from multiple base views are combined into a single unified virtual table. The view applies business logic to:
- Classify transactions by retail type
- Apply discount rules
- Combine Front Store and Pharmacy data
- Include COVID-related sales
- Link to store navigation

**Why Important:** This creates a single source of truth for flash sales data, eliminating the need for downstream processes to understand multiple source structures. It's the foundation for all subsequent reporting and analysis.

#### Stage 3: Data Enrichment (Composite Layer)

**Purpose:** Enrich transaction data with master data and contextual information

**Key Component:**
- **xml_acc_cv_comp_fin_flash** - Composite Financial Flash View

**Supporting Master Data Views:**
- **CV_BASE_MD_RCALWEEK_S4** - Retail calendar week information
- **CV_BASE_MD_HRRP_NODE_S4** - Store hierarchy (region, district, store)
- **CV_BASE_MD_CEPCT_S4** - Cost element and profit center text
- **CV_COMP_MD_SRPACT_STATIC** - Store attributes (location, type, size)
- **CV_COMP_MD_COMPFL_STATIC** - Comparable store flags

**What Happens:** The unified transaction data is enriched with:
- Fiscal calendar attributes (week, period, quarter, year)
- Store hierarchy information (which stores roll up to which districts/regions)
- Store attributes (store type, location, square footage)
- Comparable store indicators (whether a store is comparable year-over-year)
- Cost element and profit center details for financial reporting

**Why Important:** This enrichment transforms raw transaction data into meaningful business information. It enables analysis by time period, store hierarchy, and store characteristics. The comparable store flags are critical for accurate year-over-year performance comparisons.

#### Stage 4: Data Persistence (Snapshot Layer)

**Purpose:** Create weekly snapshots for historical reporting

**Key Components:**
- **STP_WSS_FLASH_SALES** - Flash Sales Snapshot Procedure
- **TBL_WSS_FLASH_SALES** - Flash Sales persistent table
- **STP_WSS_SRP_ATTRIBUTES** - Store Attributes Load Procedure
- **TBL_WSS_SRP_ATTR_ACT** - Store Attributes persistent table
- **TBL_WSS_SRP_COMPFLAG** - Comparable Flag persistent table

**What Happens:** 
- The **STP_WSS_FLASH_SALES** procedure runs weekly to capture a point-in-time snapshot of the enriched flash sales data and stores it in **TBL_WSS_FLASH_SALES**
- The **STP_WSS_SRP_ATTRIBUTES** procedure loads current store attributes and comparable flags into persistent tables
- These snapshots preserve historical data for trend analysis

**Why Important:** While the calculation views provide real-time data, the snapshot tables enable:
- Historical trend analysis (comparing this week to prior weeks)
- Performance tracking over time
- Consistent reporting even as source data changes
- Faster query performance for historical reports

#### Stage 5: Final Reporting (Combined & Consolidated Layer)

**Purpose:** Combine flash sales with budget, forecast, and actuals for comprehensive reporting

**Key Components:**
- **xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales** - Static view reading from snapshot table
- **xml_acc_cv_comp_fin_flash_combined_static** - Combined static view integrating:
  - Flash sales actuals
  - Budget data (CV_COMP_FIN_BUDGET_STATIC)
  - Forecast data (CV_COMP_FORECAST_MJE_STATIC)
  - Actual financial data (CV_COMP_FIN_ACTUAL_STATIC)
  - SKF budget and actuals
  - Topside adjustments
- **xml_acc_cv_cons_weekly_flash_report_static** - **Final Consolidated Weekly Flash Report**

**What Happens:** 
- The static view reads from the persisted snapshot table
- The combined view integrates flash sales with budget, forecast, and actual financial data
- The final consolidated report presents a complete picture of performance vs. plan
- Business users consume this final report for decision-making

**Why Important:** This is the ultimate deliverable of the entire system. It provides executives and managers with a comprehensive view of:
- Actual sales performance
- Variance to budget
- Variance to forecast
- Year-over-year comparisons (using comparable store flags)
- Performance by store hierarchy

### 3. Final/Downstream Components

**Primary Output:**
- **xml_acc_cv_cons_weekly_flash_report_static** - The final consolidated weekly flash report consumed by business users, reporting tools, and dashboards

**Persistent Storage:**
- **TBL_WSS_FLASH_SALES** - Historical flash sales snapshots
- **TBL_WSS_SRP_ATTR_ACT** - Store attributes history
- **TBL_WSS_SRP_COMPFLAG** - Comparable store flags history

---

## Major Lineage Paths

### Path 1: Front Store Sales Flow

**Source:** TLOGF (Transaction Log Database Table)

**Processing Flow:**
1. **TLOGF** → **xml_acc_cv_base_tlogf-FS_SALES** (Extract Front Store sales)
2. **xml_acc_cv_base_tlogf-FS_SALES** → **xml_acc_FLASH_SALES_VT_CAR** (Integrate into virtual table)
3. **xml_acc_FLASH_SALES_VT_CAR** → **xml_acc_cv_comp_fin_flash** (Enrich with master data)
4. **xml_acc_cv_comp_fin_flash** → **STP_WSS_FLASH_SALES** (Snapshot procedure)
5. **STP_WSS_FLASH_SALES** → **TBL_WSS_FLASH_SALES** (Persist to table)
6. **TBL_WSS_FLASH_SALES** → **xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales** (Static view)
7. **Static view** → **xml_acc_cv_comp_fin_flash_combined_static** (Combine with budget/forecast)
8. **Combined view** → **xml_acc_cv_cons_weekly_flash_report_static** (Final report)

**Destination:** Consolidated Weekly Flash Report

**Confidence Score:** 94/100

**Explanation:** This path captures all Front Store sales transactions from the point-of-sale system, transforms them through multiple layers of business logic, enriches them with store and calendar attributes, persists weekly snapshots, and ultimately delivers them in the final consolidated report. The high confidence score reflects explicit dependencies throughout the chain.

### Path 2: Pharmacy Sales & Prescription Scripts Flow

**Source:** TLOGF (for RX Sales) and TLOGF_X (for Scripts)

**Processing Flow:**

**RX Sales Branch:**
1. **TLOGF** → **xml_acc_cv_base_tlogf-RX_SALES** (Extract Pharmacy sales)
2. **xml_acc_cv_base_tlogf-RX_SALES** → **xml_acc_FLASH_SALES_VT_CAR** (Integrate)

**Scripts Branch:**
1. **TLOGF_X** → **xml_acc_cv_base_tlogf_x-SCRIPTS** (Extract prescription scripts)
2. **xml_acc_cv_base_tlogf_x-SCRIPTS** → **xml_acc_FLASH_SALES_VT_CAR** (Integrate)

**Combined Flow (continues from virtual table):**
3. **xml_acc_FLASH_SALES_VT_CAR** → **xml_acc_cv_comp_fin_flash** (Enrich)
4. **xml_acc_cv_comp_fin_flash** → **STP_WSS_FLASH_SALES** (Snapshot)
5. **STP_WSS_FLASH_SALES** → **TBL_WSS_FLASH_SALES** (Persist)
6. **TBL_WSS_FLASH_SALES** → **Static views** → **Combined view** → **Final report**

**Destination:** Consolidated Weekly Flash Report

**Confidence Score:** 94/100

**Explanation:** This path handles Pharmacy operations, capturing both sales transactions and prescription script counts. The dual-source approach (TLOGF for sales, TLOGF_X for scripts) ensures comprehensive Pharmacy reporting. Both streams merge at the virtual table layer and follow the same enrichment and reporting path as Front Store data.

### Path 3: Budget & Master Data Flow

**Source:** AZSRP_DS052_VT_S4 (Frozen Budget), AZSRP_DS041_VT_S4 (Live Budget), MD_RCALWEEK_S4 (Calendar)

**Processing Flow:**

**Budget Branch:**
1. **AZSRP_DS052_VT_S4** + **AZSRP_DS041_VT_S4** → **CV_BASE_FIN_WEEKLY_BUDGET_S4** (Combine budgets)
2. **CV_BASE_FIN_WEEKLY_BUDGET_S4** → **CV_BASE_MD_RCAIWEEK_S4** (Integrate with calendar)

**Calendar Branch:**
1. **MD_RCALWEEK_S4** → **xml_acc_cv_base_MD_RCALWEEK_S4** (Prepare calendar)
2. **xml_acc_cv_base_MD_RCALWEEK_S4** → **CV_BASE_MD_RCAIWEEK_S4** (Integrate)

**Master Data Integration:**
3. **CV_BASE_MD_RCAIWEEK_S4** (enriched with store hierarchy, cost elements, comparable flags)
4. **CV_BASE_MD_RCAIWEEK_S4** → **STP_WSS_SRP_ATTRIBUTES** (Load procedure)
5. **STP_WSS_SRP_ATTRIBUTES** → **TBL_WSS_SRP_ATTR_ACT** + **TBL_WSS_SRP_COMPFLAG** (Persist)

**Usage in Reporting:**
- Master data views feed into **xml_acc_cv_comp_fin_flash** to enrich transaction data
- Budget data feeds into **xml_acc_cv_comp_fin_flash_combined_static** for variance reporting

**Destination:** Master data tables and enrichment of flash sales reporting

**Confidence Score:** 97/100

**Explanation:** This path manages the budget and master data that provides context for sales performance. It combines frozen (historical) and live (current) budget data, integrates it with the fiscal calendar, and loads store attributes into persistent tables. This master data is then used throughout the system to enrich transaction data and enable budget variance analysis.

### Supporting Flows

#### Employee Discount Flow
- **TLOGF** → **xml_acc_cv_base_tlogf-EMP_DISCOUNT** / **xml_acc_cv_base_tlogf-EMP_DISCOUNTS** → **xml_acc_FLASH_SALES_VT_CAR**
- Captures employee discount transactions separately for analysis

#### COVID Sales Flow
- **TLOGF** → **xml_acc_cv_base_tlogf_COVID_sales** → **xml_acc_FLASH_SALES_VT_CAR**
- Tracks COVID-related sales separately for pandemic impact analysis

#### Discount Flow
- **TLOGF** → **xml_acc_cv_base_tlogf-FS-DISCOUNT** → **xml_acc_FLASH_SALES_VT_CAR**
- Captures promotional discounts and markdowns

#### Configuration Flow
- **PARAMETERS** → Multiple parameter views (retail types, discount types) → **xml_acc_FLASH_SALES_VT_CAR**
- Provides business rules and classification logic

---

## Key Findings

### 1. Central Integration Point

**Finding:** The **xml_acc_FLASH_SALES_VT_CAR** virtual table serves as the central integration point for all transaction data.

**Significance:** This component receives data from 14+ upstream base views and parameter views, combining:
- Front Store sales
- Pharmacy sales
- Prescription scripts
- Employee discounts
- COVID sales
- Front Store discounts
- Store navigation
- Multiple configuration parameters

**Business Impact:** Having a single integration point simplifies downstream processing and ensures consistency. Any changes to transaction data logic only need to be made in one place.

### 2. Three-Tier Architecture

**Finding:** The system follows a clear three-tier architecture:
- **Base Layer** - Raw data extraction and preparation
- **Composite Layer** - Data integration and enrichment
- **Reporting Layer** - Final aggregation and presentation

**Significance:** This layered approach provides:
- Clear separation of concerns
- Reusability of components
- Easier maintenance and troubleshooting
- Scalability for future enhancements

**Business Impact:** The architecture supports both real-time reporting (through calculation views) and historical analysis (through snapshot tables), meeting diverse business needs.

### 3. Dual Processing Paths

**Finding:** The system maintains two parallel processing approaches:
- **Real-time Path:** Direct calculation views for immediate reporting
- **Snapshot Path:** Stored procedures that persist data weekly for historical reporting

**Significance:** The **STP_WSS_FLASH_SALES** procedure creates weekly snapshots in **TBL_WSS_FLASH_SALES**, while calculation views provide real-time access to current data.

**Business Impact:** This dual approach enables:
- Current performance monitoring (real-time views)
- Historical trend analysis (snapshot tables)
- Consistent reporting even as source data changes
- Faster query performance for historical reports

### 4. Comprehensive Sales Coverage

**Finding:** The system captures multiple sales categories:
- Front Store sales and discounts
- Pharmacy (RX) sales
- Prescription scripts (script count, not just sales)
- Employee discounts (tracked separately)
- COVID-related sales (special category)

**Significance:** The separation of these categories allows for:
- Detailed analysis by sales type
- Employee discount impact analysis
- Pharmacy performance metrics (both sales and script volume)
- COVID impact tracking

**Business Impact:** Executives can understand performance across all revenue streams and identify specific areas of strength or concern.

### 5. Master Data Enrichment

**Finding:** Transaction data is consistently enriched with:
- **Store hierarchy** (region → district → store)
- **Store attributes** (type, location, size)
- **Fiscal calendar** (week, period, quarter, year)
- **Comparable store flags** (year-over-year comparability)
- **Cost elements and profit centers** (financial reporting structure)

**Significance:** This enrichment happens at the **xml_acc_cv_comp_fin_flash** composite view, which integrates 6+ master data views.

**Business Impact:** Enriched data enables:
- Analysis by store hierarchy (regional/district performance)
- Comparable store sales (accurate year-over-year comparisons)
- Fiscal period reporting (weekly, monthly, quarterly)
- Financial reporting by cost center and profit center

### 6. Budget Variance Reporting

**Finding:** The final combined view (**xml_acc_cv_comp_fin_flash_combined_static**) integrates:
- Flash sales actuals
- Budget data
- Forecast data
- Financial actuals
- SKF (Store Keeping Fee) budget and actuals
- Topside adjustments

**Significance:** This integration happens at the final reporting layer, combining 7+ data sources.

**Business Impact:** Executives receive a complete performance picture showing:
- Actual vs. Budget variance
- Actual vs. Forecast variance
- Financial performance vs. operational performance
- Adjustments and reconciliations

### 7. Weekly Snapshot Process

**Finding:** The **STP_WSS_FLASH_SALES** procedure runs weekly to capture point-in-time snapshots.

**Significance:** This creates a historical record in **TBL_WSS_FLASH_SALES** that preserves data even as source systems change.

**Business Impact:** 
- Enables trend analysis over weeks, months, and years
- Provides consistent historical reporting
- Supports forecasting and planning activities
- Maintains audit trail of performance

### 8. Multiple Source Systems

**Finding:** The system integrates data from multiple source systems:
- **TLOGF** - Primary transaction log (Front Store and Pharmacy sales)
- **TLOGF_X** - Extended transaction log (Prescription scripts)
- **NAVIX** - Store navigation system
- **PARAMETERS** - Configuration management system
- **AZSRP_DS052_VT_S4 / AZSRP_DS041_VT_S4** - Budget cubes (frozen and live)
- **MD_RCALWEEK_S4** - Retail calendar system

**Significance:** The system acts as an integration hub, bringing together operational, financial, and master data.

**Business Impact:** Provides a single source of truth for flash sales reporting, eliminating the need for manual data integration or reconciliation.

---

## Confidence Assessment

### Overall Lineage Confidence: 95/100

The lineage analysis achieved a very high confidence score based on:

#### Confirmed Relationships (Score: 96-99)
**Count:** 42 out of 47 relationships

**Characteristics:**
- Explicitly defined data source references in calculation view XML
- Direct SELECT and INSERT statements in stored procedures
- Clear column mappings and transformations
- Documented dependencies in view definitions

**Examples:**
- TLOGF → xml_acc_cv_base_tlogf-FS_SALES (Score: 98)
- xml_acc_cv_comp_fin_flash → STP_WSS_FLASH_SALES (Score: 98)
- STP_WSS_FLASH_SALES → TBL_WSS_FLASH_SALES (Score: 99)

**Why High Confidence:** These relationships are directly supported by technical evidence in the file contents. The data sources, transformations, and targets are explicitly defined.

#### Inferred Relationships (Score: 85)
**Count:** 5 out of 47 relationships

**Characteristics:**
- Based on naming conventions and data flow patterns
- Logical connections supported by context
- Not explicitly defined in file contents but highly probable

**Examples:**
- xml_acc_cv_base_tlogf-EMP_DISCOUNTS → xml_acc_FLASH_SALES_VT_CAR (Score: 85)
- xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales → xml_acc_cv_comp_fin_flash_combined_static (Score: 85)

**Why Medium-High Confidence:** While not explicitly documented, these relationships follow clear naming patterns and logical data flow. The lower score reflects the absence of direct technical evidence.

#### Unresolved Relationships
**Count:** 2 potential duplicates or variants

**Files:**
1. **xml_acc_cv_base-FS_SALES-tlogf.txt** vs. **xml_acc_cv_base_tlogf-FS_SALES.xml**
   - Both appear to extract Front Store sales from TLOGF
   - May represent different versions, contexts, or environments
   - Exact relationship cannot be determined from available information

2. **xml_acc_cv_comp_flash_sales-VT-table-CV.txt** vs. **xml_acc_FLASH_SALES_VT_CAR.txt**
   - Both appear to be virtual tables for Flash Sales from CAR system
   - Reference the same base views
   - May serve different reporting contexts or represent different versions

**Impact:** These unresolved relationships do not affect the overall lineage understanding, as the primary data flow is clearly established through the confirmed relationships.

### Confidence by Lineage Component

| Component | Score | Justification |
|-----------|-------|---------------|
| **Transaction Data Flow** | 96/100 | Explicitly defined data sources and calculation view dependencies with clear transformation logic |
| **Budget Data Flow** | 97/100 | Direct references in calculation views and stored procedures with explicit table mappings |
| **Master Data Integration** | 95/100 | Well-defined joins and dependencies between master data views and transaction data |
| **Stored Procedure Execution** | 98/100 | Explicit SELECT and INSERT statements with clear source and target identification |
| **Static View Layer** | 92/100 | Some inferred relationships based on naming conventions, but overall flow is clear |
| **Final Reporting Layer** | 96/100 | Explicit dependency chain from combined static view to final report |

### Why the Confidence is High

1. **Explicit Technical Evidence:** Most relationships are directly documented in calculation view XML files and stored procedure SQL code
2. **Consistent Naming Conventions:** File and component names follow clear patterns that support relationship inference
3. **Complete End-to-End Flow:** The lineage traces from source tables through all transformation layers to the final report
4. **Multiple Validation Points:** Relationships are validated through multiple sources (data source definitions, view dependencies, procedure logic)
5. **Minimal Ambiguity:** Only 2 relationships out of 47 could not be definitively established

### Areas Requiring Attention

While the overall confidence is high, the following areas warrant attention:

1. **Duplicate Views:** Clarify the purpose and usage of the two potential duplicate view pairs
2. **External Dependencies:** Seven referenced files were not provided in the analysis (CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4, etc.)
3. **Version Control:** Determine if multiple versions of views exist for different environments (dev, test, production)

---

## Simplified Lineage Diagram

```mermaid
flowchart TD
    %% Source Layer
    A["📊 Source Data<br/>━━━━━━━━━━<br/>TLOGF (Transaction Log)<br/>TLOGF_X (Scripts)<br/>NAVIX (Store Navigation)<br/>PARAMETERS (Config)<br/>Budget Cubes<br/>Retail Calendar"]
    
    %% Base Layer
    B["🔧 Data Preparation<br/>━━━━━━━━━━<br/>Base Calculation Views<br/>• FS Sales<br/>• RX Sales<br/>• Scripts<br/>• Discounts<br/>• Employee Discounts<br/>• COVID Sales<br/>• Parameters"]
    
    %% Integration Layer
    C["🔗 Data Integration<br/>━━━━━━━━━━<br/>Flash Sales Virtual Table<br/>(xml_acc_FLASH_SALES_VT_CAR)<br/>Central integration point for<br/>all transaction data"]
    
    %% Enrichment Layer
    D["✨ Data Enrichment<br/>━━━━━━━━━━<br/>Composite Financial Flash View<br/>(xml_acc_cv_comp_fin_flash)<br/>Enriched with:<br/>• Store Hierarchy<br/>• Fiscal Calendar<br/>• Comparable Flags<br/>• Cost Elements"]
    
    %% Persistence Layer
    E["💾 Data Persistence<br/>━━━━━━━━━━<br/>Weekly Snapshot Process<br/>(STP_WSS_FLASH_SALES)<br/>↓<br/>TBL_WSS_FLASH_SALES<br/>Historical snapshot table"]
    
    %% Budget Layer
    F["📈 Budget & Master Data<br/>━━━━━━━━━━<br/>Budget Views<br/>Store Attributes<br/>Comparable Flags<br/>Calendar Integration"]
    
    %% Combined Layer
    G["🔀 Data Combination<br/>━━━━━━━━━━<br/>Combined Static View<br/>(xml_acc_cv_comp_fin_flash_combined_static)<br/>Integrates:<br/>• Flash Sales Actuals<br/>• Budget<br/>• Forecast<br/>• Financial Actuals"]
    
    %% Final Report
    H["📋 Final Report<br/>━━━━━━━━━━<br/>Consolidated Weekly Flash Report<br/>(xml_acc_cv_cons_weekly_flash_report_static)<br/>Executive reporting layer"]
    
    %% Flow
    A -->|Extract & Transform| B
    B -->|Integrate| C
    C -->|Enrich| D
    D -->|Snapshot Weekly| E
    E -->|Read Historical| G
    A -->|Budget & Master Data| F
    F -->|Enrich| D
    F -->|Budget Variance| G
    D -->|Real-time Data| G
    G -->|Consolidate| H
    
    %% Styling
    classDef sourceStyle fill:#e3f2fd,stroke:#1976d2,stroke-width:3px,color:#000
    classDef baseStyle fill:#fff9c4,stroke:#f57f17,stroke-width:2px,color:#000
    classDef integrationStyle fill:#f3e5f5,stroke:#7b1fa2,stroke-width:3px,color:#000
    classDef enrichmentStyle fill:#e1f5fe,stroke:#0277bd,stroke-width:2px,color:#000
    classDef persistenceStyle fill:#c8e6c9,stroke:#388e3c,stroke-width:2px,color:#000
    classDef budgetStyle fill:#ffe0b2,stroke:#e65100,stroke-width:2px,color:#000
    classDef combinedStyle fill:#f8bbd0,stroke:#c2185b,stroke-width:2px,color:#000
    classDef reportStyle fill:#ffcdd2,stroke:#c62828,stroke-width:4px,color:#000
    
    class A sourceStyle
    class B baseStyle
    class C integrationStyle
    class D enrichmentStyle
    class E persistenceStyle
    class F budgetStyle
    class G combinedStyle
    class H reportStyle
```

### Diagram Explanation

This simplified diagram shows the major logical stages of the Flash Sales Reporting System:

1. **Source Data** - Raw data from transaction logs, master data tables, and budget cubes
2. **Data Preparation** - Base calculation views extract and prepare specific data elements
3. **Data Integration** - Flash Sales Virtual Table combines all transaction data
4. **Data Enrichment** - Composite view enriches data with store, calendar, and financial attributes
5. **Data Persistence** - Weekly snapshot process stores historical data
6. **Budget & Master Data** - Parallel flow providing context and comparison data
7. **Data Combination** - Combined view integrates actuals, budget, and forecast
8. **Final Report** - Consolidated weekly flash report for executive consumption

The diagram uses color coding to distinguish different processing stages and shows both the primary transaction data flow and the supporting budget/master data flow.

---

## Important Observations

### 1. Circular Dependency Pattern

**Observation:** The system contains a refresh cycle between stored procedures and calculation views.

**Technical Details:**
- **STP_WSS_FLASH_SALES** procedure reads from **xml_acc_cv_comp_fin_flash** calculation view
- The procedure inserts data into **TBL_WSS_FLASH_SALES** table
- **xml_acc_cv_comp_fin_flash_static_tbl_wss_flash_sales** calculation view reads from **TBL_WSS_FLASH_SALES**
- The static view feeds into **xml_acc_cv_comp_fin_flash_combined_static**, which is used for reporting

**Business-Friendly Explanation:** The system follows a weekly refresh cycle where:
1. The procedure captures current flash sales data from real-time views
2. It stores this data in a snapshot table for historical preservation
3. Reporting views then read from this snapshot table for consistent historical reporting
4. This creates a cycle where the procedure updates the target data, and views subsequently read that updated data

**Why This Matters:** This is not a problematic circular dependency but rather an intentional design pattern that enables:
- Weekly snapshots for historical analysis
- Consistent reporting even as source data changes
- Separation of real-time and historical reporting

**Risk Level:** Low - This is a controlled, scheduled process with clear separation between write (procedure) and read (views) operations.

### 2. Alternate Implementations

**Observation:** Two potential duplicate or variant implementations were identified:

**Duplicate 1: Front Store Sales Views**
- **xml_acc_cv_base-FS_SALES-tlogf.txt**
- **xml_acc_cv_base_tlogf-FS_SALES.xml**

**Duplicate 2: Flash Sales Virtual Tables**
- **xml_acc_cv_comp_flash_sales-VT-table-CV.txt**
- **xml_acc_FLASH_SALES_VT_CAR.txt**

**Business-Friendly Explanation:** The system appears to have two versions of certain views that serve similar purposes. This could indicate:
- Different versions for different environments (development, test, production)
- Legacy views maintained for backward compatibility
- Alternate implementations for different reporting contexts

**Why This Matters:** Having multiple implementations can lead to:
- Confusion about which view to use
- Maintenance overhead (changes must be made in multiple places)
- Potential data inconsistencies if the implementations diverge

**Recommendation:** Clarify the purpose of each implementation and document when each should be used. Consider consolidating if they serve the same purpose.

### 3. External Dependencies

**Observation:** Seven calculation views are referenced but were not provided in the analysis:
- CV_BASE_MD_SRPACT_S4
- CV_BASE_MD_COMPFL_S4
- CV_COMP_SKF_BUDGET_STATIC
- CV_COMP_FORECAST_MJE_STATIC
- CV_COMP_FIN_ACTUAL_STATIC
- CV_COMP_SKF_ACTUAL_STATIC
- CV_COMP_TOPSIDE_ADJUSTMENTS

**Business-Friendly Explanation:** These are additional components that the system depends on but were not included in the current analysis. They provide:
- Store attributes and comparable flags (master data)
- Budget data for Store Keeping Fees (SKF)
- Forecast data from Management Journal Entries (MJE)
- Actual financial data
- Topside adjustments (manual adjustments made at corporate level)

**Why This Matters:** These external dependencies are critical for the final reporting layer. Without them, the combined view cannot produce complete budget variance and forecast variance reporting.

**Recommendation:** Include these components in future analysis to ensure complete lineage understanding. Document their sources and refresh schedules.

### 4. Comprehensive Sales Categorization

**Observation:** The system separately tracks multiple sales categories:
- Front Store sales
- Pharmacy (RX) sales
- Prescription scripts (count, not just sales)
- Employee discounts
- COVID-related sales
- Front Store discounts

**Business-Friendly Explanation:** Rather than treating all sales as a single category, the system maintains separate data streams for each type. This granular approach enables detailed analysis of:
- Which sales categories are performing well or poorly
- The impact of employee discounts on profitability
- Pharmacy performance measured by both sales dollars and script volume
- COVID-related sales trends

**Why This Matters:** This level of detail supports sophisticated business analysis and decision-making. For example:
- Pharmacy managers can track script volume (a key operational metric) separately from sales dollars
- Finance can analyze the cost of employee discount programs
- Executives can understand COVID's ongoing impact on sales mix

### 5. Master Data Integration Complexity

**Observation:** The enrichment layer integrates 6+ master data views:
- Store hierarchy (CV_BASE_MD_HRRP_NODE_S4)
- Store attributes (CV_COMP_MD_SRPACT_STATIC)
- Comparable flags (CV_COMP_MD_COMPFL_STATIC)
- Retail calendar (xml_acc_cv_base_MD_RCALWEEK_S4)
- Cost elements (CV_BASE_MD_CEPCT_S4)
- Budget data (CV_BASE_FIN_WEEKLY_BUDGET_S4)

**Business-Friendly Explanation:** The system doesn't just report raw sales numbers. It enriches transaction data with extensive contextual information about stores, time periods, and financial structures. This transforms simple transaction records into meaningful business intelligence.

**Why This Matters:** This complexity enables sophisticated reporting but also creates dependencies:
- If master data is incorrect or outdated, reports will be inaccurate
- Changes to master data structures may require updates to multiple views
- Master data refresh schedules must be coordinated with transaction data processing

**Recommendation:** Establish clear data governance for master data, including:
- Ownership and accountability
- Refresh schedules
- Data quality monitoring
- Change management processes

### 6. Weekly Snapshot Timing

**Observation:** The **STP_WSS_FLASH_SALES** procedure runs weekly to create snapshots.

**Business-Friendly Explanation:** The system captures a "photograph" of flash sales data every week. This weekly snapshot becomes the historical record used for trend analysis and reporting.

**Why This Matters:** The timing of this snapshot is critical:
- If it runs too early in the week, it may miss late-arriving transactions
- If it runs too late, it may not be available for Monday morning reports
- The snapshot represents a point-in-time view, so any corrections or adjustments after the snapshot won't be reflected in historical reports

**Recommendation:** 
- Document the exact schedule for the snapshot procedure
- Establish a cutoff time for transaction data
- Define procedures for handling late-arriving data or corrections
- Consider implementing a reconciliation process to compare snapshots to final actuals

### 7. Budget Variance Reporting Capability

**Observation:** The final combined view integrates multiple data sources for comprehensive variance reporting:
- Flash sales actuals
- Budget data (both frozen and live)
- Forecast data
- Financial actuals
- SKF budget and actuals
- Topside adjustments

**Business-Friendly Explanation:** The system doesn't just report what happened (actuals). It compares actuals to what was planned (budget) and what was expected (forecast), showing variances at multiple levels. This enables executives to understand:
- Are we meeting our budget targets?
- Are we tracking to our latest forecast?
- How do operational metrics (flash sales) compare to financial metrics (actuals)?
- What adjustments have been made at the corporate level?

**Why This Matters:** This comprehensive variance reporting is the ultimate value of the system. It transforms raw data into actionable insights for decision-making.

**Business Value:** Executives can quickly identify:
- Stores or regions that are over/under performing vs. budget
- Trends that differ from forecast expectations
- Discrepancies between operational and financial reporting
- The impact of corporate adjustments on reported performance

---

## Risks and Attention Areas

### 1. Unresolved Duplicate Views

**Risk:** Potential duplicate or variant implementations of Front Store Sales views and Flash Sales Virtual Tables.

**Files Affected:**
- xml_acc_cv_base-FS_SALES-tlogf.txt vs. xml_acc_cv_base_tlogf-FS_SALES.xml
- xml_acc_cv_comp_flash_sales-VT-table-CV.txt vs. xml_acc_FLASH_SALES_VT_CAR.txt

**Impact:** 
- Confusion about which view to use for reporting or downstream processing
- Potential data inconsistencies if the implementations differ
- Maintenance overhead requiring updates in multiple places
- Risk of using the wrong view and getting incorrect results

**Recommendation:**
- Investigate the purpose and usage of each view
- Document which view should be used in which context
- Consider consolidating if they serve the same purpose
- If both are needed, clearly document the differences and use cases

**Priority:** Medium - Does not block current operations but creates maintenance and consistency risks

### 2. External Dependencies Not Analyzed

**Risk:** Seven referenced calculation views were not included in the analysis.

**Missing Components:**
- CV_BASE_MD_SRPACT_S4 (Store Attributes)
- CV_BASE_MD_COMPFL_S4 (Comparable Flags)
- CV_COMP_SKF_BUDGET_STATIC (SKF Budget)
- CV_COMP_FORECAST_MJE_STATIC (Forecast)
- CV_COMP_FIN_ACTUAL_STATIC (Financial Actuals)
- CV_COMP_SKF_ACTUAL_STATIC (SKF Actuals)
- CV_COMP_TOPSIDE_ADJUSTMENTS (Corporate Adjustments)

**Impact:**
- Incomplete understanding of the full lineage
- Cannot validate the complete end-to-end data flow
- Missing dependencies may cause issues during migration or changes
- Budget variance reporting depends on these components

**Recommendation:**
- Include these components in a follow-up analysis
- Document their sources, refresh schedules, and dependencies
- Ensure they are included in any migration or modernization efforts
- Validate that they are functioning correctly and producing accurate data

**Priority:** High - These components are critical for the final reporting layer

### 3. Master Data Refresh Coordination

**Risk:** The system depends on multiple master data sources that must be refreshed in coordination with transaction data.

**Dependencies:**
- Store hierarchy and attributes
- Comparable store flags
- Retail calendar
- Budget data
- Cost elements and profit centers

**Impact:**
- If master data is stale, reports will show incorrect store attributes or budget comparisons
- If master data refreshes after transaction data, enrichment may use outdated information
- Timing mismatches can cause data quality issues

**Recommendation:**
- Document the refresh schedule for all master data sources
- Establish dependencies and sequencing (e.g., master data must refresh before transaction processing)
- Implement monitoring to detect when master data is stale
- Consider implementing data quality checks to validate master data completeness

**Priority:** Medium - Important for data quality but likely already managed through existing processes

### 4. Snapshot Timing and Completeness

**Risk:** The weekly snapshot process may not capture all transactions if timing is not properly managed.

**Process:** STP_WSS_FLASH_SALES runs weekly to snapshot data into TBL_WSS_FLASH_SALES

**Impact:**
- Late-arriving transactions may be missed if the snapshot runs too early
- Corrections or adjustments made after the snapshot won't be reflected in historical reports
- Inconsistencies between real-time views and historical snapshots

**Recommendation:**
- Document the exact schedule and cutoff time for the snapshot procedure
- Establish procedures for handling late-arriving data
- Implement reconciliation processes to compare snapshots to final actuals
- Consider implementing a "final" snapshot that runs after all corrections are complete

**Priority:** Medium - Important for data accuracy but likely already managed

### 5. Circular Dependency Management

**Risk:** The refresh cycle between stored procedures and calculation views must be properly managed.

**Pattern:**
- Procedure reads from calculation view
- Procedure writes to table
- Calculation view reads from table
- Combined view uses both real-time and snapshot data

**Impact:**
- If the procedure fails, historical data won't be updated
- If the procedure runs at the wrong time, it may capture incomplete data
- If views are modified, the procedure may need to be updated

**Recommendation:**
- Document the intended refresh cycle and timing
- Implement monitoring to detect procedure failures
- Establish procedures for rerunning snapshots if needed
- Ensure proper error handling in the stored procedure

**Priority:** Low - This is an intentional design pattern, but it requires proper management

### 6. Configuration Parameter Management

**Risk:** The system depends on multiple configuration parameter views that define business rules.

**Parameter Views:**
- FS_RETAIL_TYPES (Front Store retail types)
- FS_DISCOUNT_TYPES (Front Store discount types)
- RX_RETAIL_TYPES (Pharmacy retail types)
- EMP_DISC_TYPES (Employee discount types)
- RX_RETAIL_TYPES-COVID (COVID retail types)
- FS-RETAIL_TYPE-ztfirp_flash_prm (Flash parameters)

**Impact:**
- If parameters are incorrect, transactions may be misclassified
- Changes to parameters may require reprocessing historical data
- Parameter changes may affect trend analysis and comparisons

**Recommendation:**
- Establish governance for parameter changes
- Document the business rules encoded in each parameter view
- Implement change control processes for parameter updates
- Consider versioning parameters to support historical analysis

**Priority:** Medium - Important for data accuracy and consistency

### 7. Performance Considerations

**Risk:** The complex multi-layer architecture may have performance implications.

**Complexity Factors:**
- Multiple layers of calculation views
- Large transaction volumes (TLOGF, TLOGF_X)
- Extensive master data joins
- Weekly snapshot processing

**Impact:**
- Slow query performance for real-time reporting
- Long-running snapshot procedures
- Resource contention during peak processing times

**Recommendation:**
- Monitor query performance for calculation views
- Optimize joins and filters in calculation views
- Consider indexing strategies for base tables
- Schedule snapshot procedures during off-peak hours
- Implement incremental processing where possible

**Priority:** Low - Performance is likely acceptable, but should be monitored

---

## Final Assessment

### System Overview

The Flash Sales Reporting System is a **well-architected, comprehensive data integration and reporting solution** that processes retail transaction data from multiple sources to produce a consolidated weekly flash sales report for executive decision-making.

### Strengths

1. **Clear Architecture:** The three-tier architecture (Base → Composite → Reporting) provides clear separation of concerns and supports maintainability

2. **Comprehensive Coverage:** The system captures all major sales categories (Front Store, Pharmacy, Scripts, Discounts, Employee Discounts, COVID sales)

3. **Rich Enrichment:** Transaction data is extensively enriched with store hierarchy, fiscal calendar, comparable flags, and financial attributes

4. **Dual Processing:** The system supports both real-time reporting (calculation views) and historical analysis (snapshot tables)

5. **Budget Variance:** The final report integrates actuals, budget, forecast, and adjustments for comprehensive variance reporting

6. **High Confidence:** 95/100 overall lineage confidence with 42 out of 47 relationships explicitly confirmed

### Main Data Sources

- **TLOGF** - Transaction log for Front Store and Pharmacy sales
- **TLOGF_X** - Transaction log for prescription scripts
- **NAVIX** - Store navigation and identification
- **PARAMETERS** - Configuration and business rules
- **Budget Cubes** - Frozen and live budget data
- **Retail Calendar** - Fiscal period mapping

### Main Processing Stages

1. **Data Preparation** - Base calculation views extract and prepare specific data elements
2. **Data Integration** - Flash Sales Virtual Table combines all transaction data
3. **Data Enrichment** - Composite view enriches with master data
4. **Data Persistence** - Weekly snapshot process stores historical data
5. **Data Combination** - Combined view integrates actuals, budget, and forecast
6. **Final Reporting** - Consolidated weekly flash report

### Final Destination

**xml_acc_cv_cons_weekly_flash_report_static** - Consolidated Weekly Flash Report consumed by business users, reporting tools, and executive dashboards

### Reporting/Consumption

The final report provides:
- Actual sales performance by store, region, and category
- Budget variance analysis (actual vs. budget)
- Forecast variance analysis (actual vs. forecast)
- Year-over-year comparisons using comparable store flags
- Performance by fiscal period (week, month, quarter)
- Financial reporting by cost element and profit center

### Overall Confidence: 95/100

The lineage analysis achieved very high confidence due to:
- Explicit technical evidence in calculation view definitions and stored procedures
- Clear naming conventions supporting relationship inference
- Complete end-to-end traceability from source to final report
- Minimal ambiguity (only 2 unresolved relationships out of 47)

### Important Observations

1. **Circular Dependency Pattern:** The system uses an intentional refresh cycle where procedures snapshot data from views, and views subsequently read from snapshot tables. This is a controlled pattern that enables historical reporting.

2. **Alternate Implementations:** Two potential duplicate views were identified that may represent different versions or contexts. These should be clarified and documented.

3. **External Dependencies:** Seven referenced calculation views were not included in the analysis. These are critical for budget variance reporting and should be analyzed in a follow-up.

4. **Master Data Complexity:** The system integrates 6+ master data sources to enrich transaction data. This provides rich reporting capabilities but creates dependencies that must be managed.

5. **Weekly Snapshot Process:** The snapshot timing is critical for data accuracy and must be properly coordinated with transaction data availability.

### Unresolved Areas

1. **Duplicate Views:** Two pairs of potentially duplicate views require clarification:
   - Front Store Sales views (xml_acc_cv_base-FS_SALES-tlogf vs. xml_acc_cv_base_tlogf-FS_SALES)
   - Flash Sales Virtual Tables (xml_acc_cv_comp_flash_sales-VT-table-CV vs. xml_acc_FLASH_SALES_VT_CAR)

2. **External Components:** Seven calculation views are referenced but not analyzed:
   - Store attributes and comparable flags (CV_BASE_MD_SRPACT_S4, CV_BASE_MD_COMPFL_S4)
   - Budget and forecast data (CV_COMP_SKF_BUDGET_STATIC, CV_COMP_FORECAST_MJE_STATIC)
   - Financial actuals (CV_COMP_FIN_ACTUAL_STATIC, CV_COMP_SKF_ACTUAL_STATIC)
   - Corporate adjustments (CV_COMP_TOPSIDE_ADJUSTMENTS)

### Recommendations

1. **Clarify Duplicate Views:** Investigate and document the purpose of each potential duplicate view
2. **Analyze External Dependencies:** Include the seven missing calculation views in a follow-up analysis
3. **Document Refresh Schedules:** Clearly document the timing and sequencing of all data refresh processes
4. **Establish Data Governance:** Implement governance for master data and configuration parameters
5. **Monitor Performance:** Establish monitoring for query performance and procedure execution
6. **Implement Reconciliation:** Create reconciliation processes to validate snapshot accuracy

### Business Value

This system enables the organization to:
- **Monitor Performance:** Track daily and weekly sales performance across all channels
- **Identify Trends:** Analyze historical trends and patterns
- **Compare to Plan:** Understand variance to budget and forecast
- **Make Decisions:** Provide executives with timely, accurate information for decision-making
- **Analyze by Hierarchy:** Understand performance at store, district, and regional levels
- **Track Initiatives:** Monitor the impact of promotions, discounts, and special programs

### Conclusion

The Flash Sales Reporting System is a sophisticated, well-designed data integration and reporting solution that successfully combines transaction data from multiple sources with master data and budget information to produce comprehensive executive reports. The lineage analysis achieved 95% confidence, with clear traceability from source systems through transformation layers to the final consolidated report. While some areas require clarification (duplicate views, external dependencies), the overall system architecture is sound and supports the organization's flash sales reporting needs effectively.

---

**Report Generated:** 2024  
**Analysis Type:** HANA Data Lineage Summary  
**Overall Confidence:** 95/100  
**Total Files Analyzed:** 32  
**Total Relationships Mapped:** 47  
**Complete Lineage Paths:** 3  
**Unresolved Relationships:** 2  
**External Dependencies:** 7  

---

*End of Friendly Lineage Summary*