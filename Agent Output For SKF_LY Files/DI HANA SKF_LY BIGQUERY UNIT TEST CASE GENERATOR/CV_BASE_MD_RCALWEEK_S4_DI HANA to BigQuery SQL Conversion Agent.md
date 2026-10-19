# Unit Test Case Summary

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Filter on RCLNT includes only 120 and 200 | Input table contains rows with RCLNT values: 120, 200, 300, 400 | Only rows with RCLNT = 120 or 200 are present in output | Output contains no rows where RCLNT is not 120 or 200 |
| TC_02 | All specified columns are projected as-is | Input table with all columns populated for RCLNT = 120 and 200 | Output contains all 9 columns, values match input for included rows | Output rows for RCLNT = 120/200 have identical values in all columns as input |
| TC_03 | No rows returned when input has no RCLNT = 120 or 200 | Input table contains only RCLNT = 300, 400 | Output is empty | Output row count is zero |
| TC_04 | NULL handling in projected columns | Input table has NULLs in ZZWEEK, ZCALYRP, ZRYEAR, ZRPERIOD, ZRYRP, ZRYRQTR, ZRWSTRTDATE, ZRWENDDATE for RCLNT = 120 | Output contains NULLs in same columns for RCLNT = 120 | Output preserves NULLs in all columns for included rows |
| TC_05 | Edge case: Only one valid RCLNT value present | Input table contains only RCLNT = 120 | Output contains all rows with RCLNT = 120 and no other rows | Output rows all have RCLNT = 120 |
| TC_06 | Edge case: Empty input table | Input table is empty | Output is empty | Output row count is zero |
| TC_07 | Data type preservation for RCLNT | Input table has RCLNT as integer/numeric | Output RCLNT column is integer/numeric and matches input | Output RCLNT column type is unchanged and matches input values |

# Pytest Script

```python
import pytest

@pytest.fixture
def input_table():
    # Simulated input table as list of dicts (each dict is a row)
    return [
        {"RCLNT": 120, "ZZWEEK": "202301", "ZCALYRP": "2023", "ZRYEAR": "2023", "ZRPERIOD": "01", "ZRYRP": "202301", "ZRYRQTR": "Q1", "ZRWSTRTDATE": "2023-01-02", "ZRWENDDATE": "2023-01-08"},
        {"RCLNT": 200, "ZZWEEK": "202302", "ZCALYRP": "2023", "ZRYEAR": "2023", "ZRPERIOD": "02", "ZRYRP": "202302", "ZRYRQTR": "Q1", "ZRWSTRTDATE": "2023-01-09", "ZRWENDDATE": "2023-01-15"},
        {"RCLNT": 300, "ZZWEEK": "202303", "ZCALYRP": "2023", "ZRYEAR": "2023", "ZRPERIOD": "03", "ZRYRP": "202303", "ZRYRQTR": "Q1", "ZRWSTRTDATE": "2023-01-16", "ZRWENDDATE": "2023-01-22"},
        {"RCLNT": 400, "ZZWEEK": "202304", "ZCALYRP": "2023", "ZRYEAR": "2023", "ZRPERIOD": "04", "ZRYRP": "202304", "ZRYRQTR": "Q1", "ZRWSTRTDATE": "2023-01-23", "ZRWENDDATE": "2023-01-29"},
        {"RCLNT": 120, "ZZWEEK": None, "ZCALYRP": None, "ZRYEAR": None, "ZRPERIOD": None, "ZRYRP": None, "ZRYRQTR": None, "ZRWSTRTDATE": None, "ZRWENDDATE": None},
    ]

def sql_projection(input_rows):
    # Simulate the SQL transformation logic
    projected_cols = [
        "RCLNT", "ZZWEEK", "ZCALYRP", "ZRYEAR", "ZRPERIOD", "ZRYRP", "ZRYRQTR", "ZRWSTRTDATE", "ZRWENDDATE"
    ]
    return [
        {col: row[col] for col in projected_cols}
        for row in input_rows if row["RCLNT"] in (120, 200)
    ]

def test_TC_01_filter_on_RCLNT(input_table):
    result = sql_projection(input_table)
    assert all(row["RCLNT"] in (120, 200) for row in result), "Output contains rows with invalid RCLNT values"
    invalid_rows = [row for row in result if row["RCLNT"] not in (120, 200)]
    assert len(invalid_rows) == 0, f"Found rows with RCLNT not in (120, 200): {invalid_rows}"

def test_TC_02_all_columns_projected(input_table):
    result = sql_projection(input_table)
    # Only rows where RCLNT in (120, 200) should be present
    expected_rows = [row for row in input_table if row["RCLNT"] in (120, 200)]
    assert len(result) == len(expected_rows)
    for i, row in enumerate(result):
        for col in ["RCLNT", "ZZWEEK", "ZCALYRP", "ZRYEAR", "ZRPERIOD", "ZRYRP", "ZRYRQTR", "ZRWSTRTDATE", "ZRWENDDATE"]:
            assert row[col] == expected_rows[i][col], f"Mismatch in column {col} for row {i}"

def test_TC_03_no_rows_when_no_valid_RCLNT():
    input_rows = [
        {"RCLNT": 300, "ZZWEEK": "202303", "ZCALYRP": "2023", "ZRYEAR": "2023", "ZRPERIOD": "03", "ZRYRP": "202303", "ZRYRQTR": "Q1", "ZRWSTRTDATE": "2023-01-16", "ZRWENDDATE": "2023-01-22"},
        {"RCLNT": 400, "ZZWEEK": "202304", "ZCALYRP": "2023", "ZRYEAR": "2023", "ZRPERIOD": "04", "ZRYRP": "202304", "ZRYRQTR": "Q1", "ZRWSTRTDATE": "2023-01-23", "ZRWENDDATE": "2023-01-29"},
    ]
    result = sql_projection(input_rows)
    assert len(result) == 0, "Output should be empty when no valid RCLNT values are present"

def test_TC_04_null_handling_in_projected_columns():
    input_rows = [
        {"RCLNT": 120, "ZZWEEK": None, "ZCALYRP": None, "ZRYEAR": None, "ZRPERIOD": None, "ZRYRP": None, "ZRYRQTR": None, "ZRWSTRTDATE": None, "ZRWENDDATE": None},
    ]
    result = sql_projection(input_rows)
    assert len(result) == 1
    for col in ["ZZWEEK", "ZCALYRP", "ZRYEAR", "ZRPERIOD", "ZRYRP", "ZRYRQTR", "ZRWSTRTDATE", "ZRWENDDATE"]:
        assert result[0][col] is None, f"Column {col} should be NULL"

def test_TC_05_only_one_valid_RCLNT():
    input_rows = [
        {"RCLNT": 120, "ZZWEEK": "202301", "ZCALYRP": "2023", "ZRYEAR": "2023", "ZRPERIOD": "01", "ZRYRP": "202301", "ZRYRQTR": "Q1", "ZRWSTRTDATE": "2023-01-02", "ZRWENDDATE": "2023-01-08"},
        {"RCLNT": 120, "ZZWEEK": "202305", "ZCALYRP": "2023", "ZRYEAR": "2023", "ZRPERIOD": "05", "ZRYRP": "202305", "ZRYRQTR": "Q1", "ZRWSTRTDATE": "2023-01-30", "ZRWENDDATE": "2023-02-05"},
    ]
    result = sql_projection(input_rows)
    assert all(row["RCLNT"] == 120 for row in result), "All output rows should have RCLNT = 120"
    assert len(result) == 2

def test_TC_06_empty_input_table():
    input_rows = []
    result = sql_projection(input_rows)
    assert result == [], "Output should be empty when input is empty"

def test_TC_07_data_type_preservation_for_RCLNT():
    input_rows = [
        {"RCLNT": 120, "ZZWEEK": "202301", "ZCALYRP": "2023", "ZRYEAR": "2023", "ZRPERIOD": "01", "ZRYRP": "202301", "ZRYRQTR": "Q1", "ZRWSTRTDATE": "2023-01-02", "ZRWENDDATE": "2023-01-08"},
    ]
    result = sql_projection(input_rows)
    assert isinstance(result[0]["RCLNT"], int), "RCLNT should be integer/numeric"
    assert result[0]["RCLNT"] == 120
```

# Cost Analysis

API Cost: 0.0000 USD
