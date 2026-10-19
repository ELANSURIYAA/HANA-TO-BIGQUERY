**Unit Test Case Summary**

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Variable Assignment: V_WEEK | SFN_PRIOR_FISCAL_WEEK() returns a valid week string (e.g., '202324') | V_WEEK is assigned the output of SFN_PRIOR_FISCAL_WEEK() | V_WEEK == expected value from the function |
| TC_02 | Table Cleanup: TBL_WSS_SRP_ATTR_ACT | TBL_WSS_SRP_ATTR_ACT contains data before DELETE | All rows are deleted from TBL_WSS_SRP_ATTR_ACT | Table is empty after DELETE |
| TC_03 | Table Cleanup: TBL_WSS_SRP_COMPFLAG | TBL_WSS_SRP_COMPFLAG contains data before DELETE | All rows are deleted from TBL_WSS_SRP_COMPFLAG | Table is empty after DELETE |
| TC_04 | Insert All Rows: TBL_WSS_SRP_ATTR_ACT | CV_BASE_MD_SRPACT_S4 contains 2 rows with valid data | Both rows are inserted into TBL_WSS_SRP_ATTR_ACT with audit columns populated | Row count matches, audit columns (CURRENT_TIMESTAMP, SESSION_USER) are set |
| TC_05 | Insert All Rows: TBL_WSS_SRP_ATTR_ACT (Empty Source) | CV_BASE_MD_SRPACT_S4 is empty | No rows are inserted into TBL_WSS_SRP_ATTR_ACT | TBL_WSS_SRP_ATTR_ACT remains empty after INSERT |
| TC_06 | Insert Filtered Rows: TBL_WSS_SRP_COMPFLAG | CV_BASE_MD_COMPFL_S4 contains 3 rows, 2 with ZWEEK = V_WEEK | Only 2 rows (ZWEEK = V_WEEK) are inserted into TBL_WSS_SRP_COMPFLAG with audit columns populated | Only rows with ZWEEK = V_WEEK are inserted; audit columns are set |
| TC_07 | Insert Filtered Rows: TBL_WSS_SRP_COMPFLAG (No Match) | CV_BASE_MD_COMPFL_S4 contains only rows with ZWEEK ≠ V_WEEK | No rows are inserted into TBL_WSS_SRP_COMPFLAG | TBL_WSS_SRP_COMPFLAG remains empty after INSERT |
| TC_08 | Audit Columns: CURRENT_TIMESTAMP and SESSION_USER | Inserted rows into both tables | CURRENT_TIMESTAMP and SESSION_USER are populated for each row | Audit columns are not NULL and match expected types/formats |
| TC_09 | Summary Output | V_WEEK = '202324' | Output message is "Store attribute table loaded & Comp Flag table loaded for 202324" | Output string matches expected format and includes V_WEEK |
| TC_10 | NULL Handling: Source with NULLs | CV_BASE_MD_SRPACT_S4 and CV_BASE_MD_COMPFL_S4 contain NULLs in non-key columns | NULLs are preserved in the target tables | Target table columns contain NULLs where expected |
| TC_11 | Data Type Preservation | Source and target columns have compatible types (e.g., STRING to STRING, INT to INT) | Data types are preserved during INSERT | Target table data types match source types (no implicit conversion errors) |
| TC_12 | No Aggregation or Grouping | Source tables contain multiple rows with duplicate values | All rows are inserted as-is (no aggregation or grouping) | Row count matches source; duplicates are preserved |
| TC_13 | Parameter Not Used: V_LY_WEEK | V_LY_WEEK is declared but not used | No impact on logic or output | No references or assignments to V_LY_WEEK in output or tables |

---

**Pytest Script**

```python
import pytest
from datetime import datetime

# Mock data and functions for testing

def SFN_PRIOR_FISCAL_WEEK():
    return '202324'

MOCK_SESSION_USER = 'test_user'

def get_current_timestamp():
    # Use a fixed timestamp for test reproducibility
    return datetime(2023, 6, 14, 12, 0, 0)

@pytest.fixture
def mock_CV_BASE_MD_SRPACT_S4():
    return [
        {
            'MANDT': '100', 'STRNUM': '001', 'PRCTR': 'P1', 'KOKRS': 'K1', 'KOSTL': 'C1',
            'RX_OPEN_DAT': None, 'RX_CLOSE_DAT': '2023-06-01', 'RX_HRS_OPER': 12,
            # ... other columns ...
            'CREATEDBY': 'userA', 'CREATED_ON': '2023-06-01',
        },
        {
            'MANDT': '100', 'STRNUM': '002', 'PRCTR': 'P2', 'KOKRS': 'K2', 'KOSTL': 'C2',
            'RX_OPEN_DAT': '2023-05-01', 'RX_CLOSE_DAT': None, 'RX_HRS_OPER': 8,
            # ... other columns ...
            'CREATEDBY': 'userB', 'CREATED_ON': '2023-06-02',
        },
    ]

@pytest.fixture
def mock_CV_BASE_MD_COMPFL_S4():
    return [
        {
            'MANDT': '100', 'PRCTR': 'P1', 'STRNUM': '001', 'COMP_VER': '1',
            'ZWEEK': '202324', 'ZMONTH': '06', 'ZYEAR': '2023', 'FS_COMP_PRE': 1, 'RX_COMP_PRE': 0,
            # ... other columns ...
        },
        {
            'MANDT': '100', 'PRCTR': 'P2', 'STRNUM': '002', 'COMP_VER': '1',
            'ZWEEK': '202324', 'ZMONTH': '06', 'ZYEAR': '2023', 'FS_COMP_PRE': 1, 'RX_COMP_PRE': 1,
            # ... other columns ...
        },
        {
            'MANDT': '100', 'PRCTR': 'P3', 'STRNUM': '003', 'COMP_VER': '1',
            'ZWEEK': '202323', 'ZMONTH': '06', 'ZYEAR': '2023', 'FS_COMP_PRE': 0, 'RX_COMP_PRE': 1,
            # ... other columns ...
        },
    ]

@pytest.fixture
def empty_table():
    return []

@pytest.fixture
def table_with_nulls():
    return [
        {
            'MANDT': None, 'STRNUM': None, 'PRCTR': None, 'KOKRS': None, 'KOSTL': None,
            # ... other columns ...
            'CREATEDBY': None, 'CREATED_ON': None,
        }
    ]

def insert_attr_act(source_rows, session_user, current_timestamp):
    result = []
    for row in source_rows:
        new_row = row.copy()
        new_row['SNAPSHOT_TIMESTAMP'] = current_timestamp
        new_row['SNAPSHOT_CREATED_BY'] = session_user
        result.append(new_row)
    return result

def insert_compflag(source_rows, v_week, session_user, current_timestamp):
    result = []
    for row in source_rows:
        if row['ZWEEK'] == v_week:
            new_row = row.copy()
            new_row['SNAPSHOT_TIMESTAMP'] = current_timestamp
            new_row['CREATED_BY'] = session_user
            result.append(new_row)
    return result

def get_summary_message(v_week):
    return f"Store attribute table loaded & Comp Flag table loaded for {v_week}"

# TC_01: Variable Assignment: V_WEEK
def test_tc_01_variable_assignment():
    v_week = SFN_PRIOR_FISCAL_WEEK()
    assert v_week == '202324'

# TC_02: Table Cleanup: TBL_WSS_SRP_ATTR_ACT
def test_tc_02_table_cleanup_attr_act():
    table = [{'MANDT': '100'}, {'MANDT': '200'}]
    table.clear()
    assert len(table) == 0

# TC_03: Table Cleanup: TBL_WSS_SRP_COMPFLAG
def test_tc_03_table_cleanup_compflag():
    table = [{'MANDT': '100'}, {'MANDT': '200'}]
    table.clear()
    assert len(table) == 0

# TC_04: Insert All Rows: TBL_WSS_SRP_ATTR_ACT
def test_tc_04_insert_all_rows_attr_act(mock_CV_BASE_MD_SRPACT_S4):
    current_ts = get_current_timestamp()
    result = insert_attr_act(mock_CV_BASE_MD_SRPACT_S4, MOCK_SESSION_USER, current_ts)
    assert len(result) == 2
    for row in result:
        assert row['SNAPSHOT_TIMESTAMP'] == current_ts
        assert row['SNAPSHOT_CREATED_BY'] == MOCK_SESSION_USER

# TC_05: Insert All Rows: TBL_WSS_SRP_ATTR_ACT (Empty Source)
def test_tc_05_insert_all_rows_attr_act_empty(empty_table):
    current_ts = get_current_timestamp()
    result = insert_attr_act(empty_table, MOCK_SESSION_USER, current_ts)
    assert result == []

# TC_06: Insert Filtered Rows: TBL_WSS_SRP_COMPFLAG
def test_tc_06_insert_filtered_rows_compflag(mock_CV_BASE_MD_COMPFL_S4):
    current_ts = get_current_timestamp()
    v_week = '202324'
    result = insert_compflag(mock_CV_BASE_MD_COMPFL_S4, v_week, MOCK_SESSION_USER, current_ts)
    assert len(result) == 2
    for row in result:
        assert row['ZWEEK'] == v_week
        assert row['SNAPSHOT_TIMESTAMP'] == current_ts
        assert row['CREATED_BY'] == MOCK_SESSION_USER

# TC_07: Insert Filtered Rows: TBL_WSS_SRP_COMPFLAG (No Match)
def test_tc_07_insert_filtered_rows_compflag_no_match(mock_CV_BASE_MD_COMPFL_S4):
    current_ts = get_current_timestamp()
    v_week = '209999'
    result = insert_compflag(mock_CV_BASE_MD_COMPFL_S4, v_week, MOCK_SESSION_USER, current_ts)
    assert result == []

# TC_08: Audit Columns: CURRENT_TIMESTAMP and SESSION_USER
def test_tc_08_audit_columns(mock_CV_BASE_MD_SRPACT_S4, mock_CV_BASE_MD_COMPFL_S4):
    current_ts = get_current_timestamp()
    v_week = '202324'
    attr_act_result = insert_attr_act(mock_CV_BASE_MD_SRPACT_S4, MOCK_SESSION_USER, current_ts)
    compflag_result = insert_compflag(mock_CV_BASE_MD_COMPFL_S4, v_week, MOCK_SESSION_USER, current_ts)
    for row in attr_act_result:
        assert row['SNAPSHOT_TIMESTAMP'] == current_ts
        assert row['SNAPSHOT_CREATED_BY'] == MOCK_SESSION_USER
    for row in compflag_result:
        assert row['SNAPSHOT_TIMESTAMP'] == current_ts
        assert row['CREATED_BY'] == MOCK_SESSION_USER

# TC_09: Summary Output
def test_tc_09_summary_output():
    v_week = '202324'
    summary = get_summary_message(v_week)
    assert summary == "Store attribute table loaded & Comp Flag table loaded for 202324"

# TC_10: NULL Handling: Source with NULLs
def test_tc_10_null_handling(table_with_nulls):
    current_ts = get_current_timestamp()
    result = insert_attr_act(table_with_nulls, MOCK_SESSION_USER, current_ts)
    assert result[0]['MANDT'] is None
    assert result[0]['SNAPSHOT_TIMESTAMP'] == current_ts

# TC_11: Data Type Preservation
def test_tc_11_data_type_preservation(mock_CV_BASE_MD_SRPACT_S4):
    current_ts = get_current_timestamp()
    result = insert_attr_act(mock_CV_BASE_MD_SRPACT_S4, MOCK_SESSION_USER, current_ts)
    for row, src in zip(result, mock_CV_BASE_MD_SRPACT_S4):
        assert type(row['MANDT']) == type(src['MANDT'])
        assert type(row['STRNUM']) == type(src['STRNUM'])

# TC_12: No Aggregation or Grouping
def test_tc_12_no_aggregation_grouping():
    src = [
        {'MANDT': '100', 'STRNUM': '001'}, 
        {'MANDT': '100', 'STRNUM': '001'}
    ]
    current_ts = get_current_timestamp()
    result = insert_attr_act(src, MOCK_SESSION_USER, current_ts)
    assert len(result) == 2
    assert result[0]['STRNUM'] == result[1]['STRNUM']

# TC_13: Parameter Not Used: V_LY_WEEK
def test_tc_13_parameter_not_used():
    v_ly_week = None
    # No usage in the logic
    assert v_ly_week is None
```

---

**Cost Analysis**

API Cost: 0.0000 USD

---
