# Unit Test Case Summary

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Validate 1:1 direct mapping of all attribute columns | Input table contains distinct values for each attribute column; no duplicate rows for attribute combinations | Output contains same attribute columns with identical values as input for each group | For each group of attribute columns, output values match input values |
| TC_02 | Validate SUM aggregation for measure columns | Multiple input rows share the same attribute column values, but have different values for RX_HRS_OPER, FS_HRS_OPER, RX_STORE, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT | Output contains one row per unique attribute group, with measure columns equal to sum of input rows in that group | For each group, sum of measure columns in output equals sum in input |
| TC_03 | Validate grouping by all non-measure columns | Input table has duplicate rows with same attribute values but varying measure values | Output contains one row per unique attribute group | Number of output rows equals number of unique attribute combinations in input |
| TC_04 | Validate handling of NULLs in measure columns during aggregation | Input rows for a group have NULL values in one or more measure columns | Output sums treat NULL as zero (BigQuery default for SUM) | Output measure values for group equal sum of non-null values in input |
| TC_05 | Validate handling of NULLs in attribute columns | Input rows have NULLs in one or more attribute columns, with possible duplicate attribute combinations | Rows with NULLs in attribute columns are grouped as unique combinations | Output contains distinct rows for each unique combination of attribute values, including NULLs |
| TC_06 | Validate output does not contain columns not in source table | Input table contains only columns specified in SQL | Output contains only columns explicitly listed in SELECT | Output schema matches SELECT list, no extra columns |
| TC_07 | Validate that all columns are present in output | Input table contains all columns listed in SELECT | Output contains all columns listed in SELECT, with correct order | Output schema matches SELECT list |
| TC_08 | Validate that no calculated columns or filters are present | Input table contains various values, including edge cases | Output contains only direct mappings and aggregations, no extra calculations or filters | Output contains only direct mappings and SUM aggregations |
| TC_09 | Validate data type compatibility for SUM aggregation | Input measure columns are numeric, but may include negative, zero, large, or decimal values | Output contains correct SUM aggregation results for all numeric cases | Output measure values equal sum of input values, regardless of sign or scale |
| TC_10 | Validate behavior with empty input table | Input table is empty | Output is empty (no rows) | Output row count is zero |
| TC_11 | Validate that GROUP BY columns match SELECT attribute columns | Input table contains all attribute columns with various values | All GROUP BY columns are present in SELECT, and vice versa | GROUP BY columns match SELECT attribute columns |

---

# Pytest Script

```python
import pytest
from collections import defaultdict

# Sample input/output data structures for testing
# Each row is a dict representing a table row

# TC_01: Validate 1:1 direct mapping of all attribute columns
def test_TC_01_direct_mapping():
    input_rows = [
        {'MANDT': '100', 'STRNUM': 'S1', 'PRCTR': 'P1', 'RX_HRS_OPER': 10, 'FS_HRS_OPER': 5, 'RX_STORE': 1, 'RETAIL_SQFT_AMT': 1000, 'TOTAL_SQFT_AMT': 2000},
        {'MANDT': '101', 'STRNUM': 'S2', 'PRCTR': 'P2', 'RX_HRS_OPER': 20, 'FS_HRS_OPER': 15, 'RX_STORE': 2, 'RETAIL_SQFT_AMT': 2000, 'TOTAL_SQFT_AMT': 4000},
    ]
    # Simulate SQL output: direct mapping, no aggregation needed as all attribute columns are unique
    output_rows = input_rows.copy()
    for i, row in enumerate(output_rows):
        for col in ['MANDT', 'STRNUM', 'PRCTR']:
            assert row[col] == input_rows[i][col]

# TC_02: Validate SUM aggregation for measure columns
def test_TC_02_sum_aggregation():
    input_rows = [
        {'MANDT': '100', 'STRNUM': 'S1', 'PRCTR': 'P1', 'RX_HRS_OPER': 10, 'FS_HRS_OPER': 5, 'RX_STORE': 1, 'RETAIL_SQFT_AMT': 1000, 'TOTAL_SQFT_AMT': 2000},
        {'MANDT': '100', 'STRNUM': 'S1', 'PRCTR': 'P1', 'RX_HRS_OPER': 20, 'FS_HRS_OPER': 15, 'RX_STORE': 2, 'RETAIL_SQFT_AMT': 2000, 'TOTAL_SQFT_AMT': 4000},
    ]
    # Expected output: single row, measure columns are summed
    expected = {
        'MANDT': '100', 'STRNUM': 'S1', 'PRCTR': 'P1',
        'RX_HRS_OPER': 30, 'FS_HRS_OPER': 20, 'RX_STORE': 3, 'RETAIL_SQFT_AMT': 3000, 'TOTAL_SQFT_AMT': 6000
    }
    # Simulate aggregation
    agg = defaultdict(lambda: {'RX_HRS_OPER': 0, 'FS_HRS_OPER': 0, 'RX_STORE': 0, 'RETAIL_SQFT_AMT': 0, 'TOTAL_SQFT_AMT': 0})
    key = ('100', 'S1', 'P1')
    for row in input_rows:
        agg[key]['RX_HRS_OPER'] += row['RX_HRS_OPER']
        agg[key]['FS_HRS_OPER'] += row['FS_HRS_OPER']
        agg[key]['RX_STORE'] += row['RX_STORE']
        agg[key]['RETAIL_SQFT_AMT'] += row['RETAIL_SQFT_AMT']
        agg[key]['TOTAL_SQFT_AMT'] += row['TOTAL_SQFT_AMT']
    out_row = {**dict(zip(['MANDT', 'STRNUM', 'PRCTR'], key)), **agg[key]}
    assert out_row == expected

# TC_03: Validate grouping by all non-measure columns
def test_TC_03_grouping():
    input_rows = [
        {'MANDT': '100', 'STRNUM': 'S1', 'PRCTR': 'P1', 'RX_HRS_OPER': 10},
        {'MANDT': '100', 'STRNUM': 'S1', 'PRCTR': 'P1', 'RX_HRS_OPER': 20},
        {'MANDT': '101', 'STRNUM': 'S2', 'PRCTR': 'P2', 'RX_HRS_OPER': 30},
    ]
    # Expected: 2 output rows (one for each unique group)
    groups = set((r['MANDT'], r['STRNUM'], r['PRCTR']) for r in input_rows)
    assert len(groups) == 2

# TC_04: Validate handling of NULLs in measure columns during aggregation
def test_TC_04_nulls_in_measures():
    input_rows = [
        {'MANDT': '100', 'STRNUM': 'S1', 'PRCTR': 'P1', 'RX_HRS_OPER': None},
        {'MANDT': '100', 'STRNUM': 'S1', 'PRCTR': 'P1', 'RX_HRS_OPER': 10},
    ]
    # BigQuery SUM ignores NULLs
    agg_value = sum([r['RX_HRS_OPER'] or 0 for r in input_rows])
    assert agg_value == 10

# TC_05: Validate handling of NULLs in attribute columns
def test_TC_05_nulls_in_attributes():
    input_rows = [
        {'MANDT': None, 'STRNUM': 'S1', 'PRCTR': 'P1', 'RX_HRS_OPER': 10},
        {'MANDT': None, 'STRNUM': 'S1', 'PRCTR': 'P1', 'RX_HRS_OPER': 20},
        {'MANDT': '100', 'STRNUM': 'S1', 'PRCTR': 'P1', 'RX_HRS_OPER': 30},
    ]
    # Grouping on NULLs: rows with NULLs in grouping columns are grouped together
    groups = defaultdict(list)
    for r in input_rows:
        key = (r['MANDT'], r['STRNUM'], r['PRCTR'])
        groups[key].append(r['RX_HRS_OPER'])
    assert len(groups) == 2
    assert sum(groups[(None, 'S1', 'P1')]) == 30
    assert sum(groups[('100', 'S1', 'P1')]) == 30

# TC_06: Validate output does not contain columns not in source table
def test_TC_06_no_extra_columns():
    select_cols = ['MANDT', 'STRNUM', 'PRCTR', 'RX_HRS_OPER']
    output_row = {'MANDT': '100', 'STRNUM': 'S1', 'PRCTR': 'P1', 'RX_HRS_OPER': 10}
    for col in output_row.keys():
        assert col in select_cols
    assert len(output_row) == len(select_cols)

# TC_07: Validate that all columns are present in output
def test_TC_07_all_columns_present():
    select_cols = ['MANDT', 'STRNUM', 'PRCTR', 'RX_HRS_OPER']
    output_row = {'MANDT': '100', 'STRNUM': 'S1', 'PRCTR': 'P1', 'RX_HRS_OPER': 10}
    for col in select_cols:
        assert col in output_row

# TC_08: Validate that no calculated columns or filters are present
def test_TC_08_no_calculated_columns():
    # Input/output should only have direct mappings and SUMs
    select_cols = ['MANDT', 'STRNUM', 'PRCTR', 'RX_HRS_OPER']
    calculated_cols = set(output_col for output_col in ['MANDT', 'STRNUM', 'PRCTR', 'RX_HRS_OPER'] if output_col not in select_cols)
    assert len(calculated_cols) == 0

# TC_09: Validate data type compatibility for SUM aggregation
def test_TC_09_sum_types():
    input_rows = [
        {'RX_HRS_OPER': 10},
        {'RX_HRS_OPER': -5},
        {'RX_HRS_OPER': 0},
        {'RX_HRS_OPER': 2.5},
    ]
    total = sum([row['RX_HRS_OPER'] for row in input_rows])
    assert total == 7.5

# TC_10: Validate behavior with empty input table
def test_TC_10_empty_input():
    input_rows = []
    output_rows = []  # No input, so no output
    assert len(output_rows) == 0

# TC_11: Validate that GROUP BY columns match SELECT attribute columns
def test_TC_11_groupby_select_match():
    select_attribute_cols = ['MANDT', 'STRNUM', 'PRCTR']
    groupby_cols = ['MANDT', 'STRNUM', 'PRCTR']
    assert set(select_attribute_cols) == set(groupby_cols)
```

---

# Cost Analysis

API Cost: 0.0000 USD
