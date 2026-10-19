# Unit Test Case Summary

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Validate that only rows with RCLNT = 120 or 200 are included in the output | Input data contains rows with RCLNT values: 120, 200, 300, NULL | Only rows with RCLNT = 120 or 200 are present in output; rows with RCLNT = 300 or NULL are excluded | Output only contains RCLNT values 120 and 200 |
| TC_02 | Validate that all required columns are present and mapped correctly | Input data contains all listed columns with distinct values | Output contains columns: RCLNT, ZZWEEK, ZCALYRP, ZRYEAR, ZRPERIOD, ZRYRP, ZRYRQTR, ZRWSTRTDATE, ZRWENDDATE, with values matching input for RCLNT = 120 or 200 | Output schema and values for each column match input for filtered rows |
| TC_03 | Validate behavior when input contains NULLs in non-filter columns | Input data has NULLs in columns ZZWEEK, ZCALYRP, etc. for RCLNT = 120 or 200 | Output retains NULLs in non-filter columns as per input | Output preserves NULL values in all non-filter columns |
| TC_04 | Validate behavior when input contains duplicate rows for RCLNT = 120 or 200 | Input data contains duplicate rows for RCLNT = 120 and/or 200 | Output includes duplicates, as there is no DISTINCT or aggregation | Output retains duplicate rows as in input |
| TC_05 | Validate that no aggregation or grouping is applied | Input data contains multiple rows per RCLNT, ZZWEEK, etc. | Output contains all matching rows with no aggregation | Output row count for RCLNT = 120 or 200 matches input row count for those values |
| TC_06 | Validate behavior when input contains no rows with RCLNT = 120 or 200 | Input data contains only RCLNT = 300, 400, NULL | Output is empty | Output contains 0 rows |
| TC_07 | Validate correct handling of edge numeric values for RCLNT | Input data contains RCLNT values at type boundaries (e.g., 0, max int, min int, negative values, NULL) | Only rows with RCLNT = 120 or 200 are included; all others excluded | Output only contains rows with RCLNT = 120 or 200 |
| TC_08 | Validate that the filter is inclusive (IN, not =) | Input data contains rows where RCLNT = 120, RCLNT = 200 | Both RCLNT = 120 and RCLNT = 200 rows are included | Output contains both RCLNT = 120 and RCLNT = 200 |

# Pytest Script

```python
import pytest

# Sample input data for all tests
def get_sample_input():
    return [
        # RCLNT = 120 (should be included)
        {'RCLNT': 120, 'ZZWEEK': '202301', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 1, 'ZRYRP': 202301, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-01', 'ZRWENDDATE': '2023-01-07'},
        # RCLNT = 200 (should be included)
        {'RCLNT': 200, 'ZZWEEK': '202302', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 2, 'ZRYRP': 202302, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-08', 'ZRWENDDATE': '2023-01-14'},
        # RCLNT = 300 (should be excluded)
        {'RCLNT': 300, 'ZZWEEK': '202303', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 3, 'ZRYRP': 202303, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-15', 'ZRWENDDATE': '2023-01-21'},
        # RCLNT = None (should be excluded)
        {'RCLNT': None, 'ZZWEEK': '202304', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 4, 'ZRYRP': 202304, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-22', 'ZRWENDDATE': '2023-01-28'},
    ]

def filter_sql_logic(rows):
    """
    Simulate the SQL logic: filter for RCLNT in (120, 200) and project all columns as-is.
    """
    return [
        {k: row[k] for k in ['RCLNT', 'ZZWEEK', 'ZCALYRP', 'ZRYEAR', 'ZRPERIOD', 'ZRYRP', 'ZRYRQTR', 'ZRWSTRTDATE', 'ZRWENDDATE']}
        for row in rows if row['RCLNT'] in (120, 200)
    ]

def test_TC_01_filter_on_RCLNT():
    input_data = get_sample_input()
    output = filter_sql_logic(input_data)
    assert all(row['RCLNT'] in (120, 200) for row in output)
    assert all(row['RCLNT'] not in (300, None) for row in output)

def test_TC_02_column_mapping():
    input_data = get_sample_input()
    output = filter_sql_logic(input_data)
    # Check columns
    expected_cols = ['RCLNT', 'ZZWEEK', 'ZCALYRP', 'ZRYEAR', 'ZRPERIOD', 'ZRYRP', 'ZRYRQTR', 'ZRWSTRTDATE', 'ZRWENDDATE']
    for row in output:
        assert sorted(row.keys()) == sorted(expected_cols)
    # Check mapping for a known row
    first_included = next(row for row in input_data if row['RCLNT'] == 120)
    first_output = next(row for row in output if row['RCLNT'] == 120)
    assert first_included == first_output

def test_TC_03_null_handling():
    # Add a row with NULLs in non-filter columns
    input_data = [
        {'RCLNT': 120, 'ZZWEEK': None, 'ZCALYRP': None, 'ZRYEAR': None, 'ZRPERIOD': None, 'ZRYRP': None, 'ZRYRQTR': None, 'ZRWSTRTDATE': None, 'ZRWENDDATE': None},
    ]
    output = filter_sql_logic(input_data)
    assert len(output) == 1
    assert all(value is None or key == 'RCLNT' for key, value in output[0].items())


def test_TC_04_duplicates_retained():
    input_data = [
        {'RCLNT': 120, 'ZZWEEK': '202301', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 1, 'ZRYRP': 202301, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-01', 'ZRWENDDATE': '2023-01-07'},
        {'RCLNT': 120, 'ZZWEEK': '202301', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 1, 'ZRYRP': 202301, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-01', 'ZRWENDDATE': '2023-01-07'},
    ]
    output = filter_sql_logic(input_data)
    assert len(output) == 2
    assert output[0] == output[1]


def test_TC_05_no_aggregation():
    input_data = [
        {'RCLNT': 120, 'ZZWEEK': '202301', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 1, 'ZRYRP': 202301, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-01', 'ZRWENDDATE': '2023-01-07'},
        {'RCLNT': 120, 'ZZWEEK': '202302', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 2, 'ZRYRP': 202302, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-08', 'ZRWENDDATE': '2023-01-14'},
    ]
    output = filter_sql_logic(input_data)
    assert len(output) == 2
    assert output[0]['ZZWEEK'] != output[1]['ZZWEEK']


def test_TC_06_no_matching_rows():
    input_data = [
        {'RCLNT': 300, 'ZZWEEK': '202301', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 1, 'ZRYRP': 202301, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-01', 'ZRWENDDATE': '2023-01-07'},
        {'RCLNT': None, 'ZZWEEK': '202302', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 2, 'ZRYRP': 202302, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-08', 'ZRWENDDATE': '2023-01-14'},
    ]
    output = filter_sql_logic(input_data)
    assert len(output) == 0


def test_TC_07_edge_numeric_values():
    input_data = [
        {'RCLNT': 0, 'ZZWEEK': '202301', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 1, 'ZRYRP': 202301, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-01', 'ZRWENDDATE': '2023-01-07'},
        {'RCLNT': -1, 'ZZWEEK': '202302', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 2, 'ZRYRP': 202302, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-08', 'ZRWENDDATE': '2023-01-14'},
        {'RCLNT': 2147483647, 'ZZWEEK': '202303', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 3, 'ZRYRP': 202303, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-15', 'ZRWENDDATE': '2023-01-21'},
        {'RCLNT': -2147483648, 'ZZWEEK': '202304', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 4, 'ZRYRP': 202304, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-22', 'ZRWENDDATE': '2023-01-28'},
        {'RCLNT': 120, 'ZZWEEK': '202305', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 5, 'ZRYRP': 202305, 'ZRYRQTR': 2, 'ZRWSTRTDATE': '2023-01-29', 'ZRWENDDATE': '2023-02-04'},
        {'RCLNT': 200, 'ZZWEEK': '202306', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 6, 'ZRYRP': 202306, 'ZRYRQTR': 2, 'ZRWSTRTDATE': '2023-02-05', 'ZRWENDDATE': '2023-02-11'},
    ]
    output = filter_sql_logic(input_data)
    assert all(row['RCLNT'] in (120, 200) for row in output)
    assert len(output) == 2


def test_TC_08_filter_inclusive():
    input_data = [
        {'RCLNT': 120, 'ZZWEEK': '202301', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 1, 'ZRYRP': 202301, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-01', 'ZRWENDDATE': '2023-01-07'},
        {'RCLNT': 200, 'ZZWEEK': '202302', 'ZCALYRP': 2023, 'ZRYEAR': 2023, 'ZRPERIOD': 2, 'ZRYRP': 202302, 'ZRYRQTR': 1, 'ZRWSTRTDATE': '2023-01-08', 'ZRWENDDATE': '2023-01-14'},
    ]
    output = filter_sql_logic(input_data)
    rclnts = {row['RCLNT'] for row in output}
    assert rclnts == {120, 200}
```

# Cost Analysis

API Cost: 0.0120 USD
