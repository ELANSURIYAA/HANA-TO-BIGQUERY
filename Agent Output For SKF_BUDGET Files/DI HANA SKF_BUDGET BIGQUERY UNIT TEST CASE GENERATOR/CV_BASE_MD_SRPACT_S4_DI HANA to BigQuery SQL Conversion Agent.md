# Unit Test Case Summary

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Filter on MANDT includes only '120' and '200' | Input table contains rows with MANDT values '120', '200', and others (e.g., '100', '300') | Only rows with MANDT = '120' or '200' are included in the output | All output rows have MANDT in ['120', '200']; no other MANDT values present |
| TC_02 | All non-measure columns are grouped | Input contains multiple rows with same combination of all non-measure columns but different measure values | Output contains one row per unique combination of all non-measure columns | For each unique set of non-measure columns, only one aggregated row exists |
| TC_03 | Measure columns are aggregated with SUM | Input contains multiple rows with same grouping columns and measure values (RX_HRS_OPER, FS_HRS_OPER, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT) | Output measure columns are the sum of corresponding input values per group | Output measure values equal the sum of input values for each group |
| TC_04 | Output columns match logical model and order | Input contains all columns as listed in the logical model | Output columns exactly match the listed columns and in the same order | Output schema and column order matches specification |
| TC_05 | No calculated columns, joins, or unions present | Input contains only direct columns, no derived/calculated columns | Output contains only direct mappings, no extra columns | No unexpected/calculated columns in output |
| TC_06 | NULL handling in measure aggregation | Input contains NULLs in measure columns (RX_HRS_OPER, FS_HRS_OPER, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT) within a group | SUM ignores NULLs and sums non-NULL values; if all NULL, result is NULL or 0 per BigQuery semantics | Output measure columns correctly sum non-NULLs, or result is 0 if all NULL |
| TC_07 | Data type preservation for MANDT filter | Input has MANDT as string/character type, with some integer-like and some string values | Filter on MANDT matches only string values '120' and '200' | Only rows with MANDT exactly '120' or '200' as strings are included |
| TC_08 | No extra columns in output | Input table contains extra columns not listed in the logical model | Output contains only columns specified in the logical model | Output schema does not include any extra columns |
| TC_09 | Edge case: No matching MANDT rows | Input table contains only MANDT values not in ('120', '200') | Output is empty | Output has 0 rows |
| TC_10 | Edge case: All measure columns are NULL for a group | All input rows for a group have NULL in all measure columns | Output measure columns are 0 (per BigQuery SUM(NULL) = 0) | Output measure columns are 0 for that group |

# Pytest Script

```python
import pytest

# Sample input and output data for testing
from collections import namedtuple

# Define a sample row structure
Row = namedtuple('Row', [
    'MANDT', 'STRNUM', 'PRCTR', 'KOKRS', 'KOSTL', 'RX_OPEN_DAT', 'RX_CLOSE_DAT', 'FS_OPEN_DAT', 'FS_CLOSE_DAT',
    'REP_MKT_CODE', 'REP_MKT_DESC', 'ADDRESS', 'CITY', 'STATE', 'ZIPCODE', 'DIVISION_CODE', 'DIVISION_DESC',
    'DIVISION_MGR', 'AREA_CODE', 'AREA_DESC', 'AREA_MGR', 'REGION_CODE', 'REGION_DESC', 'REGION_MGR',
    'DISTRICT_CODE', 'DISTRICT_DESC', 'ZONE_CODE', 'DISTRICT_MGR', 'ZONE_DESC', 'MAJOR_REGION_CODE', 'MAJOR_REGION',
    'STORE_TYPE', 'STORE_TYPE_DESC', 'RX_STORE', 'RX_STORE_DESC', 'DISTRIBUTION_CNTR', 'DISTRIBUTION_CNTR_DESC',
    'STORE_24_HR', 'BUDGET_OPEN_DAT', 'BUDGET_CLOSED_DAT', 'BUDGET_RELOC_DAT', 'CONST_OPEN_DAT', 'CONST_CLOSE_DAT',
    'CONST_RELO_DAT', 'RELOCATION_DAT', 'EMERG_MKT_IND', 'BUDGET_EMERG_MKT_IND', 'COMPANY_CODE', 'COMPANY_CODE_DESC',
    'ORIGINAL_FS_OPEN_DAT', 'ORIGINAL_RX_OPEN_DAT', 'GROUP_ONE', 'GROUP_TWO', 'ARD_SORT_KEY', 'AREA_COST_CENTER',
    'REGIION_COST_CENTER', 'COUNTY_CODE', 'COUNTY_DESC', 'SQFT_BRACKET_DESC', 'SQFT_SORT_KEY', 'ACQUISITION_CODE',
    'ACQUISITION_DESC', 'PHOTO_LAB_ADD_DAT', 'PHOTO_LAB_CLOSE_DAT', 'MIN_HRS_IND', 'CREATEDBY', 'CREATED_ON',
    'RX_DIVISION_CODE', 'RX_AREA_CODE', 'RX_REGION_CODE', 'RX_DISTRICT_CODE',
    'RX_HRS_OPER', 'FS_HRS_OPER', 'RETAIL_SQFT_AMT', 'TOTAL_SQFT_AMT'
])

# Helper function to simulate the SQL logic
# Input: list of Row objects
# Output: list of dicts (aggregated, filtered, projected)
def process_rows(input_rows):
    # Filter on MANDT
    filtered = [row for row in input_rows if row.MANDT in ('120', '200')]
    # Group by all non-measure columns
    group_cols = Row._fields[:-4]
    measure_cols = Row._fields[-4:]
    groups = {}
    for row in filtered:
        key = tuple(getattr(row, c) for c in group_cols)
        if key not in groups:
            groups[key] = {c: getattr(row, c) for c in group_cols}
            for m in measure_cols:
                groups[key][m] = getattr(row, m) if getattr(row, m) is not None else 0
        else:
            for m in measure_cols:
                val = getattr(row, m)
                if val is not None:
                    groups[key][m] += val
    # For BigQuery SUM(NULL) = 0, so if all NULL, result is 0
    for g in groups.values():
        for m in measure_cols:
            if g[m] is None:
                g[m] = 0
    # Return list of dicts in the correct order
    return [g for g in groups.values()]

# TC_01: Filter on MANDT includes only '120' and '200'
def test_TC_01():
    input_data = [
        Row('120', *(['A']*69), 1, 2, 3, 4),
        Row('200', *(['B']*69), 5, 6, 7, 8),
        Row('100', *(['C']*69), 9, 10, 11, 12),
        Row('300', *(['D']*69), 13, 14, 15, 16),
    ]
    output = process_rows(input_data)
    assert all(row['MANDT'] in ('120', '200') for row in output)
    assert all(row['MANDT'] not in ('100', '300') for row in output)

# TC_02: All non-measure columns are grouped
def test_TC_02():
    # Two rows with identical non-measure columns but different measures
    base = ['120'] + ['X']*69
    row1 = Row(*base, 1, 2, 3, 4)
    row2 = Row(*base, 10, 20, 30, 40)
    input_data = [row1, row2]
    output = process_rows(input_data)
    # Should be only one output row
    assert len(output) == 1
    # Measures should be summed
    assert output[0]['RX_HRS_OPER'] == 11
    assert output[0]['FS_HRS_OPER'] == 22
    assert output[0]['RETAIL_SQFT_AMT'] == 33
    assert output[0]['TOTAL_SQFT_AMT'] == 44

# TC_03: Measure columns are aggregated with SUM
def test_TC_03():
    base1 = ['120'] + ['Y']*69
    base2 = ['120'] + ['Z']*69
    row1 = Row(*base1, 5, 6, 7, 8)
    row2 = Row(*base1, 2, 4, 6, 8)
    row3 = Row(*base2, 1, 1, 1, 1)
    input_data = [row1, row2, row3]
    output = process_rows(input_data)
    # Group 1: two rows should be summed
    group1 = [row for row in output if row['STRNUM'] == 'Y']
    assert group1[0]['RX_HRS_OPER'] == 7
    assert group1[0]['FS_HRS_OPER'] == 10
    assert group1[0]['RETAIL_SQFT_AMT'] == 13
    assert group1[0]['TOTAL_SQFT_AMT'] == 16
    # Group 2: single row, values as is
    group2 = [row for row in output if row['STRNUM'] == 'Z']
    assert group2[0]['RX_HRS_OPER'] == 1
    assert group2[0]['FS_HRS_OPER'] == 1
    assert group2[0]['RETAIL_SQFT_AMT'] == 1
    assert group2[0]['TOTAL_SQFT_AMT'] == 1

# TC_04: Output columns match logical model and order
def test_TC_04():
    row = Row('120', *range(1, 70), 10, 20, 30, 40)
    output = process_rows([row])
    # Output keys match logical model (column order)
    assert list(output[0].keys()) == list(Row._fields)

# TC_05: No calculated columns, joins, or unions present
def test_TC_05():
    row = Row('120', *(['A']*69), 1, 2, 3, 4)
    output = process_rows([row])
    # Only columns from logical model
    assert set(output[0].keys()) == set(Row._fields)

# TC_06: NULL handling in measure aggregation
def test_TC_06():
    # Two rows, one with NULLs
    base = ['120'] + ['Q']*69
    import math
    row1 = Row(*base, None, None, None, None)
    row2 = Row(*base, 5, 10, 15, 20)
    input_data = [row1, row2]
    output = process_rows(input_data)
    # SUM should ignore NULLs
    assert output[0]['RX_HRS_OPER'] == 5
    assert output[0]['FS_HRS_OPER'] == 10
    assert output[0]['RETAIL_SQFT_AMT'] == 15
    assert output[0]['TOTAL_SQFT_AMT'] == 20

# TC_07: Data type preservation for MANDT filter
def test_TC_07():
    # Only exact string matches '120' and '200' pass
    rows = [
        Row('120', *(['A']*69), 1, 2, 3, 4),
        Row('200', *(['B']*69), 5, 6, 7, 8),
        Row('0120', *(['C']*69), 9, 10, 11, 12),  # Should not match
        Row('120 ', *(['D']*69), 13, 14, 15, 16), # Should not match
    ]
    output = process_rows(rows)
    assert all(row['MANDT'] in ('120', '200') for row in output)
    assert len(output) == 2

# TC_08: No extra columns in output
def test_TC_08():
    # Simulate input with extra columns
    class ExtendedRow(Row):
        pass
    ExtendedRow.__new__.__defaults__ = (None,) * len(Row._fields)
    # Add extra fields
    extra_fields = ('EXTRA1', 'EXTRA2')
    ExtendedRow = namedtuple('ExtendedRow', Row._fields + extra_fields)
    row = ExtendedRow('120', *(['A']*69), 1, 2, 3, 4, 'foo', 'bar')
    # Only logical model columns should be in output
    output = process_rows([Row(*row[:73])])
    assert set(output[0].keys()) == set(Row._fields)
    assert 'EXTRA1' not in output[0]
    assert 'EXTRA2' not in output[0]

# TC_09: Edge case: No matching MANDT rows
def test_TC_09():
    input_data = [
        Row('999', *(['E']*69), 1, 2, 3, 4),
        Row('888', *(['F']*69), 5, 6, 7, 8),
    ]
    output = process_rows(input_data)
    assert output == []

# TC_10: Edge case: All measure columns are NULL for a group
def test_TC_10():
    base = ['120'] + ['Z']*69
    row1 = Row(*base, None, None, None, None)
    input_data = [row1]
    output = process_rows(input_data)
    # SUM(NULL) = 0 in BigQuery
    assert output[0]['RX_HRS_OPER'] == 0
    assert output[0]['FS_HRS_OPER'] == 0
    assert output[0]['RETAIL_SQFT_AMT'] == 0
    assert output[0]['TOTAL_SQFT_AMT'] == 0
```

# Cost Analysis

API Cost: 0.0000 USD
