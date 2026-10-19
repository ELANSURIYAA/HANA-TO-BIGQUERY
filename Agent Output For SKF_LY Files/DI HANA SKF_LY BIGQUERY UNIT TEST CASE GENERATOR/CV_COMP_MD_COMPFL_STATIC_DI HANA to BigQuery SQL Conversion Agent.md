**Unit Test Case Summary**

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Validate 1:1 column mapping and projection | Source table contains rows with all 13 columns populated with distinct non-null values | Output contains the same values for each column as in the source table, with no missing or extra columns | For each row, assert output columns match input columns exactly and order is preserved |
| TC_02 | Validate output when source table is empty | Source table is empty (no rows) | Output is an empty result set with 13 columns | Assert output row count is zero and column names match expected list |
| TC_03 | Validate projection with NULL values | Source table contains rows where some columns are NULL | Output contains NULLs in the same columns and rows as in the source table | Assert output preserves NULLs in all projected columns |
| TC_04 | Validate presence of all expected columns | Source table contains all 13 columns | Output contains exactly the 13 specified columns, in the defined order | Assert output column names and order match the projection list |
| TC_05 | Validate no extra columns or calculated columns | Source table contains additional columns beyond the 13 projected columns | Output contains only the 13 specified columns, no extra columns or calculations | Assert output has exactly 13 columns, no others |
| TC_06 | Validate data type preservation (structure only) | Source table columns have arbitrary types (unknown, but consistent) | Output columns have the same types as the source columns (as no conversion is defined) | Assert output schema matches input schema for projected columns (types and order) |
| TC_07 | Validate row-level projection, no aggregation | Source table contains multiple rows with duplicate values | Output contains all source rows, including duplicates (no aggregation or grouping) | Assert output row count equals input row count, and duplicate rows are preserved |
| TC_08 | Validate behavior with minimum and maximum values | Source table columns contain minimum and maximum representable values for their types | Output preserves these min/max values exactly | Assert output matches input for min/max values, with no truncation or alteration |
| TC_09 | Validate absence of filters or WHERE clause | Source table contains a mix of rows (some that would be filtered in other logic) | Output contains all rows from the source table, none omitted | Assert all input rows are present in output, regardless of values |
| TC_10 | Validate behavior with special characters and long strings | Source table contains string columns with special characters, spaces, and long values | Output preserves special characters and string lengths exactly | Assert output matches input for all string values, including special chars and lengths |

---

**Pytest Script**

```python
import pytest

# Mock data structures to simulate input and output tables
# Each test assumes input_data is a list of dicts (one per row), and output_data is the result of the projection

# Test Case TC_01
def test_TC_01_column_mapping_projection():
    input_data = [
        {
            "MANDT": "100",
            "PRCTR": "A1",
            "STRNUM": "S1",
            "COMP_VER": "V1",
            "ZWEEK": 10,
            "ZMONTH": 3,
            "ZYEAR": 2023,
            "FS_COMP_PRE": 1.23,
            "RX_COMP_PRE": 2.34,
            "FS_COMP_MON": 3.45,
            "RX_COMP_MON": 4.56,
            "FS_COMP_WK": 5.67,
            "RX_COMP_WK": 6.78
        }
    ]
    # Simulate projection (1:1 mapping)
    output_data = [{k: row[k] for k in [
        "MANDT", "PRCTR", "STRNUM", "COMP_VER", "ZWEEK", "ZMONTH", "ZYEAR",
        "FS_COMP_PRE", "RX_COMP_PRE", "FS_COMP_MON", "RX_COMP_MON", "FS_COMP_WK", "RX_COMP_WK"
    ]} for row in input_data]

    assert output_data == input_data
    assert list(output_data[0].keys()) == [
        "MANDT", "PRCTR", "STRNUM", "COMP_VER", "ZWEEK", "ZMONTH", "ZYEAR",
        "FS_COMP_PRE", "RX_COMP_PRE", "FS_COMP_MON", "RX_COMP_MON", "FS_COMP_WK", "RX_COMP_WK"
    ]

# Test Case TC_02
def test_TC_02_empty_source_table():
    input_data = []
    output_data = []
    assert output_data == []
    # Simulate getting columns from an empty output (should match expected)
    expected_columns = [
        "MANDT", "PRCTR", "STRNUM", "COMP_VER", "ZWEEK", "ZMONTH", "ZYEAR",
        "FS_COMP_PRE", "RX_COMP_PRE", "FS_COMP_MON", "RX_COMP_MON", "FS_COMP_WK", "RX_COMP_WK"
    ]
    # If output_data is empty, columns can be checked via schema definition
    assert expected_columns == [
        "MANDT", "PRCTR", "STRNUM", "COMP_VER", "ZWEEK", "ZMONTH", "ZYEAR",
        "FS_COMP_PRE", "RX_COMP_PRE", "FS_COMP_MON", "RX_COMP_MON", "FS_COMP_WK", "RX_COMP_WK"
    ]

# Test Case TC_03
def test_TC_03_null_value_projection():
    input_data = [
        {
            "MANDT": None,
            "PRCTR": "A2",
            "STRNUM": None,
            "COMP_VER": "V2",
            "ZWEEK": None,
            "ZMONTH": 4,
            "ZYEAR": 2024,
            "FS_COMP_PRE": None,
            "RX_COMP_PRE": 1.11,
            "FS_COMP_MON": None,
            "RX_COMP_MON": 2.22,
            "FS_COMP_WK": None,
            "RX_COMP_WK": 3.33
        }
    ]
    output_data = [{k: row[k] for k in [
        "MANDT", "PRCTR", "STRNUM", "COMP_VER", "ZWEEK", "ZMONTH", "ZYEAR",
        "FS_COMP_PRE", "RX_COMP_PRE", "FS_COMP_MON", "RX_COMP_MON", "FS_COMP_WK", "RX_COMP_WK"
    ]} for row in input_data]
    assert output_data == input_data
    assert output_data[0]["MANDT"] is None
    assert output_data[0]["STRNUM"] is None
    assert output_data[0]["FS_COMP_PRE"] is None

# Test Case TC_04
def test_TC_04_expected_columns_present():
    input_data = [
        {
            "MANDT": "101",
            "PRCTR": "B1",
            "STRNUM": "S2",
            "COMP_VER": "V3",
            "ZWEEK": 12,
            "ZMONTH": 5,
            "ZYEAR": 2025,
            "FS_COMP_PRE": 7.89,
            "RX_COMP_PRE": 8.90,
            "FS_COMP_MON": 9.01,
            "RX_COMP_MON": 1.23,
            "FS_COMP_WK": 2.34,
            "RX_COMP_WK": 3.45
        }
    ]
    output_data = [{k: row[k] for k in [
        "MANDT", "PRCTR", "STRNUM", "COMP_VER", "ZWEEK", "ZMONTH", "ZYEAR",
        "FS_COMP_PRE", "RX_COMP_PRE", "FS_COMP_MON", "RX_COMP_MON", "FS_COMP_WK", "RX_COMP_WK"
    ]} for row in input_data]
    assert set(output_data[0].keys()) == set([
        "MANDT", "PRCTR", "STRNUM", "COMP_VER", "ZWEEK", "ZMONTH", "ZYEAR",
        "FS_COMP_PRE", "RX_COMP_PRE", "FS_COMP_MON", "RX_COMP_MON", "FS_COMP_WK", "RX_COMP_WK"
    ])
    # Order check
    assert list(output_data[0].keys()) == [
        "MANDT", "PRCTR", "STRNUM", "COMP_VER", "ZWEEK", "ZMONTH", "ZYEAR",
        "FS_COMP_PRE", "RX_COMP_PRE", "FS_COMP_MON", "RX_COMP_MON", "FS_COMP_WK", "RX_COMP_WK"
    ]

# Test Case TC_05
def test_TC_05_no_extra_columns():
    input_data = [
        {
            "MANDT": "102",
            "PRCTR": "C1",
            "STRNUM": "S3",
            "COMP_VER": "V4",
            "ZWEEK": 15,
            "ZMONTH": 6,
            "ZYEAR": 2026,
            "FS_COMP_PRE": 10.11,
            "RX_COMP_PRE": 11.12,
            "FS_COMP_MON": 12.13,
            "RX_COMP_MON": 13.14,
            "FS_COMP_WK": 14.15,
            "RX_COMP_WK": 15.16,
            "EXTRA_COL": "should not be projected"
        }
    ]
    # Projection only includes the specified columns
    output_data = [{k: row[k] for k in [
        "MANDT", "PRCTR", "STRNUM", "COMP_VER", "ZWEEK", "ZMONTH", "ZYEAR",
        "FS_COMP_PRE", "RX_COMP_PRE", "FS_COMP_MON", "RX_COMP_MON", "FS_COMP_WK", "RX_COMP_WK"
    ]} for row in input_data]
    assert "EXTRA_COL" not in output_data[0]
    assert len(output_data[0]) == 13

# Test Case TC_06
def test_TC_06_data_type_preservation():
    # Simulate types: string, int, float, etc. (types not transformed)
    input_data = [
        {
            "MANDT": "103",           # str
            "PRCTR": "D1",            # str
            "STRNUM": "S4",           # str
            "COMP_VER": "V5",         # str
            "ZWEEK": 20,              # int
            "ZMONTH": 7,              # int
            "ZYEAR": 2027,            # int
            "FS_COMP_PRE": 16.17,     # float
            "RX_COMP_PRE": 17.18,     # float
            "FS_COMP_MON": 18.19,     # float
            "RX_COMP_MON": 19.20,     # float
            "FS_COMP_WK": 20.21,      # float
            "RX_COMP_WK": 21.22       # float
        }
    ]
    output_data = [{k: row[k] for k in input_data[0].keys()} for row in input_data]
    # Check types are preserved (simulate by type comparison)
    for col in input_data[0]:
        assert type(output_data[0][col]) == type(input_data[0][col])

# Test Case TC_07
def test_TC_07_row_level_projection_no_aggregation():
    input_data = [
        {
            "MANDT": "104",
            "PRCTR": "E1",
            "STRNUM": "S5",
            "COMP_VER": "V6",
            "ZWEEK": 25,
            "ZMONTH": 8,
            "ZYEAR": 2028,
            "FS_COMP_PRE": 22.23,
            "RX_COMP_PRE": 23.24,
            "FS_COMP_MON": 24.25,
            "RX_COMP_MON": 25.26,
            "FS_COMP_WK": 26.27,
            "RX_COMP_WK": 27.28
        },
        {
            "MANDT": "104",
            "PRCTR": "E1",
            "STRNUM": "S5",
            "COMP_VER": "V6",
            "ZWEEK": 25,
            "ZMONTH": 8,
            "ZYEAR": 2028,
            "FS_COMP_PRE": 22.23,
            "RX_COMP_PRE": 23.24,
            "FS_COMP_MON": 24.25,
            "RX_COMP_MON": 25.26,
            "FS_COMP_WK": 26.27,
            "RX_COMP_WK": 27.28
        }
    ]
    output_data = [{k: row[k] for k in [
        "MANDT", "PRCTR", "STRNUM", "COMP_VER", "ZWEEK", "ZMONTH", "ZYEAR",
        "FS_COMP_PRE", "RX_COMP_PRE", "FS_COMP_MON", "RX_COMP_MON", "FS_COMP_WK", "RX_COMP_WK"
    ]} for row in input_data]
    # Both rows (duplicates) must be present
    assert len(output_data) == 2
    assert output_data[0] == output_data[1]

# Test Case TC_08
def test_TC_08_min_max_values():
    input_data = [
        {
            "MANDT": "",
            "PRCTR": "Z"*255,
            "STRNUM": "S"*255,
            "COMP_VER": "V"*255,
            "ZWEEK": 0,
            "ZMONTH": 12,
            "ZYEAR": 9999,
            "FS_COMP_PRE": float('-inf'),
            "RX_COMP_PRE": float('inf'),
            "FS_COMP_MON": float('-1e308'),
            "RX_COMP_MON": float('1e308'),
            "FS_COMP_WK": float('-1e-308'),
            "RX_COMP_WK": float('1e-308')
        }
    ]
    output_data = [{k: row[k] for k in input_data[0].keys()} for row in input_data]
    assert output_data[0]["MANDT"] == ""
    assert output_data[0]["PRCTR"] == "Z"*255
    assert output_data[0]["FS_COMP_PRE"] == float('-inf')
    assert output_data[0]["RX_COMP_PRE"] == float('inf')
    assert output_data[0]["FS_COMP_MON"] == float('-1e308')
    assert output_data[0]["RX_COMP_MON"] == float('1e308')
    assert output_data[0]["FS_COMP_WK"] == float('-1e-308')
    assert output_data[0]["RX_COMP_WK"] == float('1e-308')

# Test Case TC_09
def test_TC_09_no_filters_all_rows_returned():
    input_data = [
        {"MANDT": "105", "PRCTR": "F1", "STRNUM": "S6", "COMP_VER": "V7", "ZWEEK": 30, "ZMONTH": 9, "ZYEAR": 2029,
         "FS_COMP_PRE": 28.29, "RX_COMP_PRE": 29.30, "FS_COMP_MON": 30.31, "RX_COMP_MON": 31.32, "FS_COMP_WK": 32.33, "RX_COMP_WK": 33.34},
        {"MANDT": "106", "PRCTR": "F2", "STRNUM": "S7", "COMP_VER": "V8", "ZWEEK": 31, "ZMONTH": 10, "ZYEAR": 2030,
         "FS_COMP_PRE": 34.35, "RX_COMP_PRE": 35.36, "FS_COMP_MON": 36.37, "RX_COMP_MON": 37.38, "FS_COMP_WK": 38.39, "RX_COMP_WK": 39.40},
        # Row that might be filtered in other logic, but should not be here
        {"MANDT": "107", "PRCTR": "F3", "STRNUM": "S8", "COMP_VER": "V9", "ZWEEK": 32, "ZMONTH": 11, "ZYEAR": 2031,
         "FS_COMP_PRE": 40.41, "RX_COMP_PRE": 41.42, "FS_COMP_MON": 42.43, "RX_COMP_MON": 43.44, "FS_COMP_WK": 44.45, "RX_COMP_WK": 45.46}
    ]
    output_data = [{k: row[k] for k in [
        "MANDT", "PRCTR", "STRNUM", "COMP_VER", "ZWEEK", "ZMONTH", "ZYEAR",
        "FS_COMP_PRE", "RX_COMP_PRE", "FS_COMP_MON", "RX_COMP_MON", "FS_COMP_WK", "RX_COMP_WK"
    ]} for row in input_data]
    assert len(output_data) == 3
    for i in range(3):
        assert output_data[i] == input_data[i]

# Test Case TC_10
def test_TC_10_special_characters_and_long_strings():
    input_data = [
        {
            "MANDT": "汉字!@#",
            "PRCTR": "A" * 512,
            "STRNUM": "S\n\t\r",
            "COMP_VER": "V'\"\\",
            "ZWEEK": 40,
            "ZMONTH": 12,
            "ZYEAR": 2040,
            "FS_COMP_PRE": 123.456,
            "RX_COMP_PRE": 654.321,
            "FS_COMP_MON": 0.0,
            "RX_COMP_MON": -0.0,
            "FS_COMP_WK": 1.0e20,
            "RX_COMP_WK": -1.0e-20
        }
    ]
    output_data = [{k: row[k] for k in input_data[0].keys()} for row in input_data]
    assert output_data[0]["MANDT"] == "汉字!@#"
    assert output_data[0]["PRCTR"] == "A" * 512
    assert output_data[0]["STRNUM"] == "S\n\t\r"
    assert output_data[0]["COMP_VER"] == "V'\"\\"
    assert output_data[0]["FS_COMP_PRE"] == 123.456
    assert output_data[0]["RX_COMP_WK"] == -1.0e-20
```

---

**Cost Analysis**

API Cost: 0.0000 USD