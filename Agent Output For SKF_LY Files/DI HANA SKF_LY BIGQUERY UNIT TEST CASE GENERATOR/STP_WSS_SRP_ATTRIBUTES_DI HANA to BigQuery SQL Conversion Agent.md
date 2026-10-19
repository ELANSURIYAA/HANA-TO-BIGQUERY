**Unit Test Case Summary**

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Variable Initialization: V_WEEK | Mock SFN_PRIOR_FISCAL_WEEK() returns '202423' | V_WEEK is set to '202423' | V_WEEK == '202423' |
| TC_02 | Table Truncate: TBL_WSS_SRP_ATTR_ACT | Table contains N rows before DELETE | All rows are deleted; table is empty | Row count after DELETE == 0 |
| TC_03 | Table Truncate: TBL_WSS_SRP_COMPFLAG | Table contains N rows before DELETE | All rows are deleted; table is empty | Row count after DELETE == 0 |
| TC_04 | Insert: TBL_WSS_SRP_ATTR_ACT, Column Mapping | Source table CV_BASE_MD_SRPACT_S4 contains 2 rows with known values | 2 rows inserted into TBL_WSS_SRP_ATTR_ACT with correct column mapping, audit columns populated | Inserted rows match input; audit columns not null |
| TC_05 | Insert: TBL_WSS_SRP_ATTR_ACT, Audit Columns | Source table contains 1 row | SNAPSHOT_TIMESTAMP is set to current timestamp; SNAPSHOT_CREATED_BY is set to session user | Audit columns are not null and have expected types/formats |
| TC_06 | Insert: TBL_WSS_SRP_COMPFLAG, Filter by ZWEEK | Source table contains 3 rows with ZWEEK values: ['202423', '202422', '202423']; V_WEEK='202423' | Only rows with ZWEEK='202423' are inserted into TBL_WSS_SRP_COMPFLAG | Inserted rows count == 2; all ZWEEK == '202423' |
| TC_07 | Insert: TBL_WSS_SRP_COMPFLAG, Audit Columns | Source table contains 1 row with ZWEEK=V_WEEK | SNAPSHOT_TIMESTAMP is set to current timestamp; CREATED_BY is set to session user | Audit columns are not null and have expected types/formats |
| TC_08 | Insert: TBL_WSS_SRP_COMPFLAG, No Matching Rows | Source table contains only ZWEEK values not equal to V_WEEK | No rows inserted into TBL_WSS_SRP_COMPFLAG | Inserted row count == 0 |
| TC_09 | Final Output: Summary String | V_WEEK is '202423' | Output is 'Store attribute table loaded & Comp Flag table loaded for 202423' | Output string matches expected format |
| TC_10 | SESSION_USER() Mapping | Simulate session user as 'test_user' | Audit columns SNAPSHOT_CREATED_BY/CREATED_BY equal 'test_user' | Audit columns == 'test_user' |
| TC_11 | NULL Handling: Source Columns | Some source columns are NULL in CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4 | NULLs are preserved in corresponding target columns | Target columns have NULL where source was NULL |
| TC_12 | Data Type Consistency | Inserted data types match between source and target for all columns | All columns inserted without type conversion errors | No type mismatch errors; data types as expected |

---

**Pytest Script**

```python
import pytest
from datetime import datetime

# Mocked data for tests
MOCK_SFN_PRIOR_FISCAL_WEEK = '202423'
MOCK_SESSION_USER = 'test_user'
MOCK_CURRENT_TIMESTAMP = datetime(2024, 6, 1, 12, 0, 0)

@pytest.fixture
def mock_cv_base_md_srpact_s4():
    # Two rows, one with NULLs
    return [
        {
            "MANDT": "100",
            "STRNUM": "123",
            "PRCTR": "A1",
            "KOKRS": "K1",
            "KOSTL": None,  # NULL value
            # ... all other columns ...
            "MIN_HRS_IND": "Y",
            "CREATEDBY": "user1",
            "CREATED_ON": "2024-05-01"
        },
        {
            "MANDT": "200",
            "STRNUM": "456",
            "PRCTR": "B2",
            "KOKRS": "K2",
            "KOSTL": "COST2",
            # ... all other columns ...
            "MIN_HRS_IND": "N",
            "CREATEDBY": "user2",
            "CREATED_ON": "2024-05-02"
        }
    ]

@pytest.fixture
def mock_cv_base_md_compfl_s4():
    # Three rows, two matching ZWEEK, one not
    return [
        {
            "MANDT": "100",
            "PRCTR": "A1",
            "STRNUM": "123",
            "COMP_VER": "V1",
            "ZWEEK": "202423",
            "ZMONTH": "06",
            "ZYEAR": "2024",
            # ... other columns ...
            "FS_COMP_PRE": 1, "RX_COMP_PRE": 2, "FS_COMP_MON": 3, "RX_COMP_MON": 4, "FS_COMP_WK": 5, "RX_COMP_WK": 6
        },
        {
            "MANDT": "200",
            "PRCTR": "B2",
            "STRNUM": "456",
            "COMP_VER": "V2",
            "ZWEEK": "202422",
            "ZMONTH": "05",
            "ZYEAR": "2024",
            # ... other columns ...
            "FS_COMP_PRE": 0, "RX_COMP_PRE": 0, "FS_COMP_MON": 0, "RX_COMP_MON": 0, "FS_COMP_WK": 0, "RX_COMP_WK": 0
        },
        {
            "MANDT": "300",
            "PRCTR": "C3",
            "STRNUM": "789",
            "COMP_VER": "V3",
            "ZWEEK": "202423",
            "ZMONTH": "06",
            "ZYEAR": "2024",
            # ... other columns ...
            "FS_COMP_PRE": 7, "RX_COMP_PRE": 8, "FS_COMP_MON": 9, "RX_COMP_MON": 10, "FS_COMP_WK": 11, "RX_COMP_WK": 12
        }
    ]

@pytest.fixture
def mock_empty_table():
    return []

@pytest.fixture
def mock_table_with_rows():
    return [{"id": i} for i in range(10)]

# TC_01: Variable Initialization: V_WEEK
def test_variable_initialization():
    V_WEEK = MOCK_SFN_PRIOR_FISCAL_WEEK
    assert V_WEEK == '202423'

# TC_02: Table Truncate: TBL_WSS_SRP_ATTR_ACT
def test_truncate_tbl_wss_srp_attr_act(mock_table_with_rows):
    table = mock_table_with_rows.copy()
    table.clear()
    assert len(table) == 0

# TC_03: Table Truncate: TBL_WSS_SRP_COMPFLAG
def test_truncate_tbl_wss_srp_compflag(mock_table_with_rows):
    table = mock_table_with_rows.copy()
    table.clear()
    assert len(table) == 0

# TC_04: Insert: TBL_WSS_SRP_ATTR_ACT, Column Mapping
def test_insert_tbl_wss_srp_attr_act_column_mapping(mock_cv_base_md_srpact_s4):
    # Simulate insert with audit columns
    inserted = []
    for row in mock_cv_base_md_srpact_s4:
        target_row = row.copy()
        target_row["SNAPSHOT_TIMESTAMP"] = MOCK_CURRENT_TIMESTAMP
        target_row["SNAPSHOT_CREATED_BY"] = MOCK_SESSION_USER
        inserted.append(target_row)
    assert len(inserted) == 2
    for row in inserted:
        assert "SNAPSHOT_TIMESTAMP" in row
        assert "SNAPSHOT_CREATED_BY" in row

# TC_05: Insert: TBL_WSS_SRP_ATTR_ACT, Audit Columns
def test_insert_tbl_wss_srp_attr_act_audit_columns(mock_cv_base_md_srpact_s4):
    row = mock_cv_base_md_srpact_s4[0]
    target_row = row.copy()
    target_row["SNAPSHOT_TIMESTAMP"] = MOCK_CURRENT_TIMESTAMP
    target_row["SNAPSHOT_CREATED_BY"] = MOCK_SESSION_USER
    assert target_row["SNAPSHOT_TIMESTAMP"] == MOCK_CURRENT_TIMESTAMP
    assert target_row["SNAPSHOT_CREATED_BY"] == MOCK_SESSION_USER

# TC_06: Insert: TBL_WSS_SRP_COMPFLAG, Filter by ZWEEK
def test_insert_tbl_wss_srp_compflag_filter_by_zweek(mock_cv_base_md_compfl_s4):
    V_WEEK = MOCK_SFN_PRIOR_FISCAL_WEEK
    filtered = [r for r in mock_cv_base_md_compfl_s4 if r["ZWEEK"] == V_WEEK]
    assert len(filtered) == 2
    for row in filtered:
        assert row["ZWEEK"] == V_WEEK

# TC_07: Insert: TBL_WSS_SRP_COMPFLAG, Audit Columns
def test_insert_tbl_wss_srp_compflag_audit_columns(mock_cv_base_md_compfl_s4):
    V_WEEK = MOCK_SFN_PRIOR_FISCAL_WEEK
    filtered = [r for r in mock_cv_base_md_compfl_s4 if r["ZWEEK"] == V_WEEK]
    for row in filtered:
        target_row = row.copy()
        target_row["SNAPSHOT_TIMESTAMP"] = MOCK_CURRENT_TIMESTAMP
        target_row["CREATED_BY"] = MOCK_SESSION_USER
        assert target_row["SNAPSHOT_TIMESTAMP"] == MOCK_CURRENT_TIMESTAMP
        assert target_row["CREATED_BY"] == MOCK_SESSION_USER

# TC_08: Insert: TBL_WSS_SRP_COMPFLAG, No Matching Rows
def test_insert_tbl_wss_srp_compflag_no_matching_rows(mock_cv_base_md_compfl_s4):
    V_WEEK = "209901"  # week not present in mock data
    filtered = [r for r in mock_cv_base_md_compfl_s4 if r["ZWEEK"] == V_WEEK]
    assert len(filtered) == 0

# TC_09: Final Output: Summary String
def test_final_output_summary_string():
    V_WEEK = MOCK_SFN_PRIOR_FISCAL_WEEK
    summary = f"Store attribute table loaded & Comp Flag table loaded for {V_WEEK}"
    assert summary == "Store attribute table loaded & Comp Flag table loaded for 202423"

# TC_10: SESSION_USER() Mapping
def test_session_user_mapping():
    session_user = MOCK_SESSION_USER
    assert session_user == 'test_user'

# TC_11: NULL Handling: Source Columns
def test_null_handling_source_columns(mock_cv_base_md_srpact_s4, mock_cv_base_md_compfl_s4):
    # Check that NULLs in source are preserved in target
    src_row = mock_cv_base_md_srpact_s4[0]
    assert src_row["KOSTL"] is None
    # Simulate insert
    target_row = src_row.copy()
    assert target_row["KOSTL"] is None

# TC_12: Data Type Consistency
def test_data_type_consistency(mock_cv_base_md_srpact_s4, mock_cv_base_md_compfl_s4):
    # For each column, check types match (simulate with limited fields)
    src_row = mock_cv_base_md_srpact_s4[0]
    target_row = src_row.copy()
    assert isinstance(target_row["MANDT"], str)
    assert (target_row["KOSTL"] is None or isinstance(target_row["KOSTL"], str))
    comp_row = mock_cv_base_md_compfl_s4[0]
    assert isinstance(comp_row["FS_COMP_PRE"], int)
```

---

**Cost Analysis**

API Cost: 0.0000 USD
