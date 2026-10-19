# Unit Test Case Summary

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Filter: Only rows with MANDT IN (120, 200) are included | Input table contains rows with MANDT values 120, 200, and other values (e.g., 100, 300) | Only rows with MANDT = 120 or 200 are present in the output | Output contains only rows where MANDT is 120 or 200; all other rows are excluded |
| TC_02 | Column Mapping: All output columns are mapped directly from source | Input table contains a row with known values for all columns | Output row contains the same values for MANDT, SPRAS, PRCTR, DATBI, KOKRS, KTEXT, LTEXT, MCTXT as in the input | Each output column matches the corresponding input column value for included rows |
| TC_03 | Edge Case: No rows match filter | Input table contains only rows with MANDT not in (120, 200) | Output is empty (no rows) | Output result set has zero rows |
| TC_04 | Edge Case: All rows match filter | Input table contains only rows with MANDT = 120 or 200 | All input rows are present in the output | Output contains all input rows |
| TC_05 | NULL Handling: Source columns contain NULL values | Input table contains rows with NULLs in any of SPRAS, PRCTR, DATBI, KOKRS, KTEXT, LTEXT, MCTXT (with MANDT in (120, 200)) | Output rows retain NULL values in the same columns | Output columns are NULL where input columns are NULL for included rows |
| TC_06 | Data Type Consistency: MANDT is numeric | Input table contains MANDT as integer values (120, 200, etc.) | Filter correctly includes/excludes rows based on numeric comparison | Filter does not fail or misbehave due to data type |
| TC_07 | No Unintended Transformations: No calculated columns, joins, or aggregations | Input table contains distinct values for all columns | Output does not include extra columns, calculated fields, or aggregated rows | Output schema and row-level detail matches input (for filtered rows) |

# Pytest Script

```python
import pytest

# Sample utility functions to simulate SQL logic on in-memory data

def apply_filter_and_projection(input_rows):
    # Simulate the SQL: filter MANDT in (120, 200) and project columns
    output_cols = ['MANDT', 'SPRAS', 'PRCTR', 'DATBI', 'KOKRS', 'KTEXT', 'LTEXT', 'MCTXT']
    return [
        {col: row.get(col) for col in output_cols}
        for row in input_rows if row.get('MANDT') in (120, 200)
    ]

def test_TC_01_filter_mandt_in_120_200():
    input_rows = [
        {'MANDT': 120, 'SPRAS': 'EN', 'PRCTR': 'A', 'DATBI': '20231231', 'KOKRS': '1000', 'KTEXT': 'Text1', 'LTEXT': 'LongText1', 'MCTXT': 'MText1'},
        {'MANDT': 200, 'SPRAS': 'DE', 'PRCTR': 'B', 'DATBI': '20231231', 'KOKRS': '2000', 'KTEXT': 'Text2', 'LTEXT': 'LongText2', 'MCTXT': 'MText2'},
        {'MANDT': 100, 'SPRAS': 'FR', 'PRCTR': 'C', 'DATBI': '20231231', 'KOKRS': '3000', 'KTEXT': 'Text3', 'LTEXT': 'LongText3', 'MCTXT': 'MText3'},
        {'MANDT': 300, 'SPRAS': 'IT', 'PRCTR': 'D', 'DATBI': '20231231', 'KOKRS': '4000', 'KTEXT': 'Text4', 'LTEXT': 'LongText4', 'MCTXT': 'MText4'},
    ]
    output = apply_filter_and_projection(input_rows)
    assert all(row['MANDT'] in (120, 200) for row in output)
    assert len(output) == 2
    assert {row['MANDT'] for row in output} == {120, 200}

def test_TC_02_column_mapping_direct():
    input_rows = [
        {'MANDT': 120, 'SPRAS': 'EN', 'PRCTR': 'A', 'DATBI': '20231231', 'KOKRS': '1000', 'KTEXT': 'Text1', 'LTEXT': 'LongText1', 'MCTXT': 'MText1'},
    ]
    output = apply_filter_and_projection(input_rows)
    assert len(output) == 1
    for col in ['MANDT', 'SPRAS', 'PRCTR', 'DATBI', 'KOKRS', 'KTEXT', 'LTEXT', 'MCTXT']:
        assert output[0][col] == input_rows[0][col]

def test_TC_03_no_rows_match_filter():
    input_rows = [
        {'MANDT': 100, 'SPRAS': 'FR', 'PRCTR': 'C', 'DATBI': '20231231', 'KOKRS': '3000', 'KTEXT': 'Text3', 'LTEXT': 'LongText3', 'MCTXT': 'MText3'},
        {'MANDT': 300, 'SPRAS': 'IT', 'PRCTR': 'D', 'DATBI': '20231231', 'KOKRS': '4000', 'KTEXT': 'Text4', 'LTEXT': 'LongText4', 'MCTXT': 'MText4'},
    ]
    output = apply_filter_and_projection(input_rows)
    assert output == []

def test_TC_04_all_rows_match_filter():
    input_rows = [
        {'MANDT': 120, 'SPRAS': 'EN', 'PRCTR': 'A', 'DATBI': '20231231', 'KOKRS': '1000', 'KTEXT': 'Text1', 'LTEXT': 'LongText1', 'MCTXT': 'MText1'},
        {'MANDT': 200, 'SPRAS': 'DE', 'PRCTR': 'B', 'DATBI': '20231231', 'KOKRS': '2000', 'KTEXT': 'Text2', 'LTEXT': 'LongText2', 'MCTXT': 'MText2'},
    ]
    output = apply_filter_and_projection(input_rows)
    assert output == input_rows

def test_TC_05_null_handling():
    input_rows = [
        {'MANDT': 120, 'SPRAS': None, 'PRCTR': 'A', 'DATBI': None, 'KOKRS': '1000', 'KTEXT': None, 'LTEXT': 'LongText1', 'MCTXT': None},
        {'MANDT': 200, 'SPRAS': 'DE', 'PRCTR': None, 'DATBI': '20231231', 'KOKRS': None, 'KTEXT': 'Text2', 'LTEXT': None, 'MCTXT': 'MText2'},
        {'MANDT': 100, 'SPRAS': 'FR', 'PRCTR': 'C', 'DATBI': '20231231', 'KOKRS': '3000', 'KTEXT': 'Text3', 'LTEXT': 'LongText3', 'MCTXT': 'MText3'},
    ]
    output = apply_filter_and_projection(input_rows)
    assert len(output) == 2
    assert output[0]['SPRAS'] is None
    assert output[0]['DATBI'] is None
    assert output[0]['KTEXT'] is None
    assert output[1]['PRCTR'] is None
    assert output[1]['KOKRS'] is None
    assert output[1]['LTEXT'] is None

def test_TC_06_mandt_numeric_type():
    input_rows = [
        {'MANDT': 120, 'SPRAS': 'EN'},
        {'MANDT': '120', 'SPRAS': 'EN'},  # string type, should not match if strictly numeric
        {'MANDT': 200, 'SPRAS': 'DE'},
        {'MANDT': 201, 'SPRAS': 'DE'},
    ]
    output = apply_filter_and_projection(input_rows)
    # Only integer 120 and 200 should match
    assert all(isinstance(row['MANDT'], int) for row in output)
    assert {row['MANDT'] for row in output} == {120, 200}

def test_TC_07_no_unintended_transformations():
    input_rows = [
        {'MANDT': 120, 'SPRAS': 'EN', 'PRCTR': 'A', 'DATBI': '20231231', 'KOKRS': '1000', 'KTEXT': 'Text1', 'LTEXT': 'LongText1', 'MCTXT': 'MText1', 'EXTRA': 'X'},
        {'MANDT': 200, 'SPRAS': 'DE', 'PRCTR': 'B', 'DATBI': '20231231', 'KOKRS': '2000', 'KTEXT': 'Text2', 'LTEXT': 'LongText2', 'MCTXT': 'MText2', 'EXTRA': 'Y'},
    ]
    output = apply_filter_and_projection(input_rows)
    # Output should not contain 'EXTRA' or any other columns
    for row in output:
        assert set(row.keys()) == {'MANDT', 'SPRAS', 'PRCTR', 'DATBI', 'KOKRS', 'KTEXT', 'LTEXT', 'MCTXT'}
```

# Cost Analysis

API Cost: 0.0120 USD
