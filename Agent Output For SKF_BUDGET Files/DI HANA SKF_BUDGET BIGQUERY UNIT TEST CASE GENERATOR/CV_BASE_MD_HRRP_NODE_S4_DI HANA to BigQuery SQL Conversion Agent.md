# Unit Test Case Summary

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Filter on MANDT includes only allowed values | Input table contains rows with MANDT values: 120, 200, 300, 400 | Only rows with MANDT=120 or MANDT=200 are present in the output | Output contains no rows with MANDT not in (120, 200) |
| TC_02 | All columns projected 1:1 from source | Input table contains a row with known values for all columns and MANDT=120 | Output row matches source row for all columns | Output row values equal input row values for each column |
| TC_03 | Exclusion of non-matching MANDT values | Input table contains only rows with MANDT values not in (120, 200) | Output is empty | Output contains 0 rows |
| TC_04 | Edge case: No rows in source table | Source table is empty | Output is empty | Output contains 0 rows |
| TC_05 | Edge case: NULL values in columns | Input row with MANDT=120 and some columns set to NULL | Output row preserves NULLs in corresponding columns | Output row has NULLs in the same columns as input |
| TC_06 | Edge case: Both allowed MANDT values present | Input table contains rows with MANDT=120 and MANDT=200 | Both rows are present in the output | Output contains both rows |
| TC_07 | Data type handling for MANDT (numeric assumption) | Input table has MANDT as integer, values 120 and 200 | Filter works as expected, rows included | Output contains rows with MANDT=120 and 200 |
| TC_08 | No aggregation or calculation performed | Input table with multiple rows, no aggregation columns | Output has same number of rows as filtered input, no aggregation | Output row count equals filtered input row count |

# Pytest Script

```python
import pytest
import pandas as pd

def apply_projection(input_df):
    # Simulates the SQL logic: filter on MANDT IN (120, 200), select columns 1:1
    allowed_mandt = [120, 200]
    cols = [
        'MANDT', 'HRYID', 'HRYVER', 'NODECLS', 'HRYNODE', 'PARNODE', 'HRYVALTO',
        'HRYVALFROM', 'BALIND', 'NODETYPE', 'NODEVALUE'
    ]
    filtered = input_df[input_df['MANDT'].isin(allowed_mandt)]
    # Ensure all columns are present in the output
    return filtered[cols]

# TC_01: Filter on MANDT includes only allowed values
def test_filter_on_mandt_includes_only_allowed_values():
    data = [
        {'MANDT': 120, 'HRYID': 'A', 'HRYVER': 1, 'NODECLS': 'X', 'HRYNODE': 10, 'PARNODE': 0, 'HRYVALTO': 5, 'HRYVALFROM': 1, 'BALIND': 'Y', 'NODETYPE': 'N', 'NODEVALUE': 'V1'},
        {'MANDT': 200, 'HRYID': 'B', 'HRYVER': 2, 'NODECLS': 'Y', 'HRYNODE': 20, 'PARNODE': 1, 'HRYVALTO': 10, 'HRYVALFROM': 6, 'BALIND': 'N', 'NODETYPE': 'L', 'NODEVALUE': 'V2'},
        {'MANDT': 300, 'HRYID': 'C', 'HRYVER': 3, 'NODECLS': 'Z', 'HRYNODE': 30, 'PARNODE': 2, 'HRYVALTO': 15, 'HRYVALFROM': 11, 'BALIND': 'Y', 'NODETYPE': 'M', 'NODEVALUE': 'V3'},
        {'MANDT': 400, 'HRYID': 'D', 'HRYVER': 4, 'NODECLS': 'W', 'HRYNODE': 40, 'PARNODE': 3, 'HRYVALTO': 20, 'HRYVALFROM': 16, 'BALIND': 'N', 'NODETYPE': 'O', 'NODEVALUE': 'V4'},
    ]
    df = pd.DataFrame(data)
    result = apply_projection(df)
    assert set(result['MANDT'].unique()) <= {120, 200}
    assert all(result['MANDT'].isin([120, 200]))

# TC_02: All columns projected 1:1 from source
def test_all_columns_projected_1_to_1():
    row = {'MANDT': 120, 'HRYID': 'A', 'HRYVER': 1, 'NODECLS': 'X', 'HRYNODE': 10, 'PARNODE': 0, 'HRYVALTO': 5, 'HRYVALFROM': 1, 'BALIND': 'Y', 'NODETYPE': 'N', 'NODEVALUE': 'V1'}
    df = pd.DataFrame([row])
    result = apply_projection(df)
    assert len(result) == 1
    for col in row:
        assert result.iloc[0][col] == row[col]

# TC_03: Exclusion of non-matching MANDT values
def test_exclusion_of_non_matching_mandt():
    data = [
        {'MANDT': 300, 'HRYID': 'A', 'HRYVER': 1, 'NODECLS': 'X', 'HRYNODE': 10, 'PARNODE': 0, 'HRYVALTO': 5, 'HRYVALFROM': 1, 'BALIND': 'Y', 'NODETYPE': 'N', 'NODEVALUE': 'V1'},
        {'MANDT': 400, 'HRYID': 'B', 'HRYVER': 2, 'NODECLS': 'Y', 'HRYNODE': 20, 'PARNODE': 1, 'HRYVALTO': 10, 'HRYVALFROM': 6, 'BALIND': 'N', 'NODETYPE': 'L', 'NODEVALUE': 'V2'},
    ]
    df = pd.DataFrame(data)
    result = apply_projection(df)
    assert len(result) == 0

# TC_04: Edge case: No rows in source table
def test_no_rows_in_source_table():
    df = pd.DataFrame(columns=[
        'MANDT', 'HRYID', 'HRYVER', 'NODECLS', 'HRYNODE', 'PARNODE',
        'HRYVALTO', 'HRYVALFROM', 'BALIND', 'NODETYPE', 'NODEVALUE'
    ])
    result = apply_projection(df)
    assert result.empty

# TC_05: Edge case: NULL values in columns
def test_null_values_in_columns():
    row = {'MANDT': 120, 'HRYID': None, 'HRYVER': 1, 'NODECLS': None, 'HRYNODE': 10, 'PARNODE': 0, 'HRYVALTO': None, 'HRYVALFROM': 1, 'BALIND': None, 'NODETYPE': 'N', 'NODEVALUE': None}
    df = pd.DataFrame([row])
    result = apply_projection(df)
    assert len(result) == 1
    for col in row:
        assert pd.isna(result.iloc[0][col]) if row[col] is None else result.iloc[0][col] == row[col]

# TC_06: Edge case: Both allowed MANDT values present
def test_both_allowed_mandt_values_present():
    data = [
        {'MANDT': 120, 'HRYID': 'A', 'HRYVER': 1, 'NODECLS': 'X', 'HRYNODE': 10, 'PARNODE': 0, 'HRYVALTO': 5, 'HRYVALFROM': 1, 'BALIND': 'Y', 'NODETYPE': 'N', 'NODEVALUE': 'V1'},
        {'MANDT': 200, 'HRYID': 'B', 'HRYVER': 2, 'NODECLS': 'Y', 'HRYNODE': 20, 'PARNODE': 1, 'HRYVALTO': 10, 'HRYVALFROM': 6, 'BALIND': 'N', 'NODETYPE': 'L', 'NODEVALUE': 'V2'},
    ]
    df = pd.DataFrame(data)
    result = apply_projection(df)
    assert set(result['MANDT']) == {120, 200}
    assert len(result) == 2

# TC_07: Data type handling for MANDT (numeric assumption)
def test_mandt_data_type_numeric():
    data = [
        {'MANDT': 120, 'HRYID': 'A', 'HRYVER': 1, 'NODECLS': 'X', 'HRYNODE': 10, 'PARNODE': 0, 'HRYVALTO': 5, 'HRYVALFROM': 1, 'BALIND': 'Y', 'NODETYPE': 'N', 'NODEVALUE': 'V1'},
        {'MANDT': 200, 'HRYID': 'B', 'HRYVER': 2, 'NODECLS': 'Y', 'HRYNODE': 20, 'PARNODE': 1, 'HRYVALTO': 10, 'HRYVALFROM': 6, 'BALIND': 'N', 'NODETYPE': 'L', 'NODEVALUE': 'V2'},
    ]
    df = pd.DataFrame(data)
    assert df['MANDT'].dtype in ['int64', 'int32']
    result = apply_projection(df)
    assert set(result['MANDT']) == {120, 200}

# TC_08: No aggregation or calculation performed
def test_no_aggregation_or_calculation():
    data = [
        {'MANDT': 120, 'HRYID': 'A', 'HRYVER': 1, 'NODECLS': 'X', 'HRYNODE': 10, 'PARNODE': 0, 'HRYVALTO': 5, 'HRYVALFROM': 1, 'BALIND': 'Y', 'NODETYPE': 'N', 'NODEVALUE': 'V1'},
        {'MANDT': 120, 'HRYID': 'B', 'HRYVER': 2, 'NODECLS': 'Y', 'HRYNODE': 20, 'PARNODE': 1, 'HRYVALTO': 10, 'HRYVALFROM': 6, 'BALIND': 'N', 'NODETYPE': 'L', 'NODEVALUE': 'V2'},
        {'MANDT': 200, 'HRYID': 'C', 'HRYVER': 3, 'NODECLS': 'Z', 'HRYNODE': 30, 'PARNODE': 2, 'HRYVALTO': 15, 'HRYVALFROM': 11, 'BALIND': 'Y', 'NODETYPE': 'M', 'NODEVALUE': 'V3'},
    ]
    df = pd.DataFrame(data)
    result = apply_projection(df)
    # Only MANDT 120, 200 rows included
    expected_count = sum([row['MANDT'] in [120, 200] for row in data])
    assert len(result) == expected_count
```

# Cost Analysis

API Cost: 0.0000 USD
