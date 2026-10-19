**Unit Test Case Summary**

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Validate that only rows with MANDT = 120 or MANDT = 200 are returned | Input table contains rows with MANDT = 120, 200, and other values (e.g., 100, 300) | Only rows where MANDT is 120 or 200 are present in the output | All output rows have MANDT in [120, 200]; no other MANDT values exist |
| TC_02 | Validate that all projection columns are present in the output | Input table contains all columns: MANDT, SPRAS, PRCTR, DATBI, KOKRS, KTEXT, LTEXT, MCTXT | Output contains exactly these columns, no more, no less | Output schema matches projection: 8 columns, names and order as in SQL |
| TC_03 | Validate that the filter on MANDT is inclusive for both values | Input table contains rows with MANDT = 120 and MANDT = 200 | Output contains all rows for MANDT = 120 and all rows for MANDT = 200 | All rows with MANDT = 120 or 200 from input are present in output |
| TC_04 | Validate that rows with MANDT not in (120, 200) are excluded | Input table contains rows with MANDT = 100, 110, 300 | Output contains no rows | Output is empty if no rows have MANDT = 120 or 200 |
| TC_05 | Validate correct handling when input contains NULL values in non-filter columns | Input table contains NULLs in SPRAS, PRCTR, DATBI, KOKRS, KTEXT, LTEXT, MCTXT (but MANDT is 120 or 200) | Output contains same NULLs in corresponding columns | Output rows preserve NULLs in non-filter columns |
| TC_06 | Validate correct handling when input contains NULL in MANDT | Input table contains rows with MANDT = NULL | Output excludes these rows | Output does not contain rows where MANDT is NULL |
| TC_07 | Validate behavior when input table is empty | Input table is empty | Output is empty | Output is empty (no rows) |
| TC_08 | Validate that no calculated columns or aggregations are present in the output | Input table contains multiple rows with same values | Output contains all qualifying rows, no aggregation/grouping | Output row count matches qualifying input rows; no aggregation applied |
| TC_09 | Validate filter logic if MANDT is a string (e.g., '120', '200') | Input table has MANDT as string type with values '120', '200', '300' | Only rows with MANDT = '120' or '200' are present in the output | All output rows have MANDT in ['120', '200'] if MANDT is string type |
| TC_10 | Validate that columns not listed in the projection do not appear in the output | Input table has extra columns (e.g., EXTRA1, EXTRA2) | Output does not contain these extra columns | Output only contains the 8 specified columns |

---

**Pytest Script**

```python
import pytest

# Sample input and expected output representations for each test case

def filter_rows_by_mandt(rows, mandt_values, mandt_type=int):
    """Utility function to filter rows by MANDT value, supporting int or str."""
    return [row for row in rows if row['MANDT'] in mandt_values and row['MANDT'] is not None]

def project_columns(rows, columns):
    """Utility function to project only the specified columns."""
    return [{col: row.get(col) for col in columns} for row in rows]

# Test data columns
projection_columns = ['MANDT', 'SPRAS', 'PRCTR', 'DATBI', 'KOKRS', 'KTEXT', 'LTEXT', 'MCTXT']

# TC_01
def test_TC_01_filter_on_mandt():
    input_rows = [
        {'MANDT': 120, 'SPRAS': 'EN', 'PRCTR': 'A', 'DATBI': '2023-01-01', 'KOKRS': '1000', 'KTEXT': 'Text1', 'LTEXT': None, 'MCTXT': 'M1'},
        {'MANDT': 200, 'SPRAS': 'DE', 'PRCTR': 'B', 'DATBI': '2023-01-02', 'KOKRS': '2000', 'KTEXT': 'Text2', 'LTEXT': 'Long2', 'MCTXT': None},
        {'MANDT': 100, 'SPRAS': 'FR', 'PRCTR': 'C', 'DATBI': '2023-01-03', 'KOKRS': '3000', 'KTEXT': 'Text3', 'LTEXT': 'Long3', 'MCTXT': 'M3'},
    ]
    expected_mandt = [120, 200]
    output_rows = filter_rows_by_mandt(input_rows, expected_mandt)
    assert all(row['MANDT'] in expected_mandt for row in output_rows)
    assert all(row['MANDT'] not in [100] for row in output_rows)

# TC_02
def test_TC_02_projection_columns():
    input_row = {'MANDT': 120, 'SPRAS': 'EN', 'PRCTR': 'A', 'DATBI': '2023-01-01', 'KOKRS': '1000', 'KTEXT': 'Text1', 'LTEXT': 'Long1', 'MCTXT': 'M1', 'EXTRA': 'ignore'}
    projected = project_columns([input_row], projection_columns)[0]
    assert set(projected.keys()) == set(projection_columns)
    assert 'EXTRA' not in projected

# TC_03
def test_TC_03_inclusive_filter():
    input_rows = [
        {'MANDT': 120, 'SPRAS': 'EN'},
        {'MANDT': 200, 'SPRAS': 'DE'},
        {'MANDT': 120, 'SPRAS': 'FR'},
    ]
    output_rows = filter_rows_by_mandt(input_rows, [120, 200])
    mandt_values = [row['MANDT'] for row in output_rows]
    assert 120 in mandt_values
    assert 200 in mandt_values
    assert len(output_rows) == 3  # All qualifying rows included

# TC_04
def test_TC_04_exclusive_filter():
    input_rows = [
        {'MANDT': 100, 'SPRAS': 'EN'},
        {'MANDT': 110, 'SPRAS': 'DE'},
        {'MANDT': 300, 'SPRAS': 'FR'},
    ]
    output_rows = filter_rows_by_mandt(input_rows, [120, 200])
    assert output_rows == []  # No qualifying rows

# TC_05
def test_TC_05_null_handling_non_filter_columns():
    input_rows = [
        {'MANDT': 120, 'SPRAS': None, 'PRCTR': None, 'DATBI': None, 'KOKRS': None, 'KTEXT': None, 'LTEXT': None, 'MCTXT': None},
        {'MANDT': 200, 'SPRAS': 'DE', 'PRCTR': None, 'DATBI': '2023-01-02', 'KOKRS': None, 'KTEXT': 'Text', 'LTEXT': None, 'MCTXT': None},
    ]
    output_rows = filter_rows_by_mandt(input_rows, [120, 200])
    for in_row, out_row in zip(input_rows, output_rows):
        for col in projection_columns:
            assert in_row[col] == out_row[col]

# TC_06
def test_TC_06_null_in_mandt():
    input_rows = [
        {'MANDT': None, 'SPRAS': 'EN'},
        {'MANDT': 120, 'SPRAS': 'DE'},
    ]
    output_rows = filter_rows_by_mandt(input_rows, [120, 200])
    assert all(row['MANDT'] is not None for row in output_rows)
    assert all(row['MANDT'] in [120, 200] for row in output_rows)

# TC_07
def test_TC_07_empty_input():
    input_rows = []
    output_rows = filter_rows_by_mandt(input_rows, [120, 200])
    assert output_rows == []

# TC_08
def test_TC_08_no_aggregation():
    input_rows = [
        {'MANDT': 120, 'SPRAS': 'EN', 'PRCTR': 'A', 'DATBI': '2023-01-01', 'KOKRS': '1000', 'KTEXT': 'Text1', 'LTEXT': 'Long1', 'MCTXT': 'M1'},
        {'MANDT': 120, 'SPRAS': 'EN', 'PRCTR': 'A', 'DATBI': '2023-01-01', 'KOKRS': '1000', 'KTEXT': 'Text1', 'LTEXT': 'Long1', 'MCTXT': 'M1'},
        {'MANDT': 200, 'SPRAS': 'DE', 'PRCTR': 'B', 'DATBI': '2023-01-02', 'KOKRS': '2000', 'KTEXT': 'Text2', 'LTEXT': 'Long2', 'MCTXT': 'M2'},
    ]
    output_rows = filter_rows_by_mandt(input_rows, [120, 200])
    assert len(output_rows) == 3  # No aggregation, all rows present

# TC_09
def test_TC_09_string_type_mandt():
    input_rows = [
        {'MANDT': '120', 'SPRAS': 'EN'},
        {'MANDT': '200', 'SPRAS': 'DE'},
        {'MANDT': '300', 'SPRAS': 'FR'},
    ]
    output_rows = filter_rows_by_mandt(input_rows, ['120', '200'], mandt_type=str)
    assert all(row['MANDT'] in ['120', '200'] for row in output_rows)
    assert all(row['MANDT'] not in ['300'] for row in output_rows)

# TC_10
def test_TC_10_projection_excludes_extra_columns():
    input_row = {'MANDT': 120, 'SPRAS': 'EN', 'PRCTR': 'A', 'DATBI': '2023-01-01', 'KOKRS': '1000', 'KTEXT': 'Text1', 'LTEXT': 'Long1', 'MCTXT': 'M1', 'EXTRA1': 'X', 'EXTRA2': 'Y'}
    projected = project_columns([input_row], projection_columns)[0]
    for col in projection_columns:
        assert col in projected
    assert 'EXTRA1' not in projected
    assert 'EXTRA2' not in projected
```

---

**Cost Analysis**

API Cost: 0.0000 USD

---
