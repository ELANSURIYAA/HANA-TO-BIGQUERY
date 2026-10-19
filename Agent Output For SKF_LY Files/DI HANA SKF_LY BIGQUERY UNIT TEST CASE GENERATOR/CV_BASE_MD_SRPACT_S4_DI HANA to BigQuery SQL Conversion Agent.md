**Unit Test Case Summary**

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Filter on MANDT includes only 120 and 200 | Input table contains rows with MANDT values 120, 200, and others (e.g., 100, 300) | Only rows with MANDT = 120 or 200 are processed and appear in the output | Verify output contains only rows where MANDT is 120 or 200 |
| TC_02 | Grouping by all non-measure columns | Input table contains multiple rows with identical values for all non-measure columns but different measure values | Output contains a single row per unique combination of non-measure columns, with measure columns summed | Verify only one output row for each unique non-measure column combination, with correct SUMs |
| TC_03 | SUM aggregation of measure columns | Input table contains multiple rows with same group-by columns and measure values (RX_HRS_OPER, FS_HRS_OPER, RETAIL_SQFT_AMT, TOTAL_SQFT_AMT) | Output contains the sum of each measure column per group | Verify output measure columns equal the sum of input values per group |
| TC_04 | Handling of NULL values in measure columns | Input contains NULLs in measure columns for some rows within a group | Output sums treat NULL as 0 (BigQuery SUM ignores NULLs) | Verify SUM ignores NULLs and sums only non-NULL values |
| TC_05 | Handling of NULL values in group-by (attribute) columns | Input contains NULLs in one or more group-by columns | Rows with NULLs in group-by columns are grouped together (NULL = NULL for GROUP BY in BigQuery) | Verify rows with identical NULLs in group-by columns are grouped and summed correctly |
| TC_06 | No rows match filter | Input table contains only rows with MANDT values not in (120, 200) | Output is empty | Verify output is empty when no rows match the filter |
| TC_07 | All measure columns are NULL for a group | All input rows for a group have NULL in all measure columns | Output contains NULL for each measure column in that group | Verify output measure columns are NULL when all input values are NULL |
| TC_08 | All non-measure columns present and mapped 1:1 | Input table contains values for all specified columns | Output contains all columns in the specified order, with values matching the input for non-aggregated columns | Verify output columns and order match specification, and values are 1:1 for non-measure columns |
| TC_09 | Data type compatibility for SUM aggregation | Input table contains non-numeric values in measure columns (should error in BigQuery) | Query fails with a runtime error | Verify that non-numeric values in measure columns cause an error |
| TC_10 | Column order in output matches specification | Input table contains values for all columns | Output columns appear in the exact order specified in the SELECT clause | Verify output column order matches the SQL SELECT clause |
| TC_11 | No calculated columns, joins, or unions | Input table contains only base columns, no derived/calculated fields | Output contains only base columns, no unexpected/calculated columns | Verify output schema contains only the specified columns, with no extra calculated fields |

---

**Pytest Script**

```python
import pytest
import pandas as pd
import numpy as np

# Sample column lists (shortened for demonstration; use full list in actual test)
GROUP_BY_COLUMNS = [
    "MANDT", "STRNUM", "PRCTR", "KOKRS", "KOSTL", "RX_OPEN_DAT", "RX_CLOSE_DAT", "FS_OPEN_DAT", "FS_CLOSE_DAT",
    "REP_MKT_CODE", "REP_MKT_DESC", "ADDRESS", "CITY", "STATE", "ZIPCODE", "DIVISION_CODE", "DIVISION_DESC",
    "DIVISION_MGR", "AREA_CODE", "AREA_DESC", "AREA_MGR", "REGION_CODE", "REGION_DESC", "REGION_MGR",
    "DISTRICT_CODE", "DISTRICT_DESC", "ZONE_CODE", "DISTRICT_MGR", "ZONE_DESC", "MAJOR_REGION_CODE",
    "MAJOR_REGION", "STORE_TYPE", "STORE_TYPE_DESC", "RX_STORE", "RX_STORE_DESC", "DISTRIBUTION_CNTR",
    "DISTRIBUTION_CNTR_DESC", "STORE_24_HR", "BUDGET_OPEN_DAT", "BUDGET_CLOSED_DAT", "BUDGET_RELOC_DAT",
    "CONST_OPEN_DAT", "CONST_CLOSE_DAT", "CONST_RELO_DAT", "RELOCATION_DAT", "EMERG_MKT_IND", "BUDGET_EMERG_MKT_IND",
    "COMPANY_CODE", "COMPANY_CODE_DESC", "ORIGINAL_FS_OPEN_DAT", "ORIGINAL_RX_OPEN_DAT", "GROUP_ONE", "GROUP_TWO",
    "ARD_SORT_KEY", "AREA_COST_CENTER", "REGIION_COST_CENTER", "COUNTY_CODE", "COUNTY_DESC", "SQFT_BRACKET_DESC",
    "SQFT_SORT_KEY", "ACQUISITION_CODE", "ACQUISITION_DESC", "PHOTO_LAB_ADD_DAT", "PHOTO_LAB_CLOSE_DAT",
    "MIN_HRS_IND", "CREATEDBY", "CREATED_ON", "RX_DIVISION_CODE", "RX_AREA_CODE", "RX_REGION_CODE", "RX_DISTRICT_CODE"
]
MEASURE_COLUMNS = ["RX_HRS_OPER", "FS_HRS_OPER", "RETAIL_SQFT_AMT", "TOTAL_SQFT_AMT"]
OUTPUT_COLUMNS = GROUP_BY_COLUMNS + MEASURE_COLUMNS

@pytest.fixture
def sample_input_df():
    # Minimal sample input for most tests; override as needed in test
    data = [
        dict(MANDT=120, STRNUM='A', PRCTR='P1', RX_HRS_OPER=10, FS_HRS_OPER=20, RETAIL_SQFT_AMT=100, TOTAL_SQFT_AMT=200, **{col: 'X' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
        dict(MANDT=200, STRNUM='B', PRCTR='P2', RX_HRS_OPER=5, FS_HRS_OPER=7, RETAIL_SQFT_AMT=50, TOTAL_SQFT_AMT=70, **{col: 'Y' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
        dict(MANDT=100, STRNUM='C', PRCTR='P3', RX_HRS_OPER=1, FS_HRS_OPER=2, RETAIL_SQFT_AMT=10, TOTAL_SQFT_AMT=20, **{col: 'Z' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
    ]
    df = pd.DataFrame(data)
    # Fill missing columns
    for col in OUTPUT_COLUMNS:
        if col not in df.columns:
            df[col] = None
    return df[OUTPUT_COLUMNS]

def run_sql_transformation(df):
    # Simulate the SQL: filter, group by, sum measures
    filtered = df[df['MANDT'].isin([120, 200])]
    grouped = filtered.groupby(GROUP_BY_COLUMNS, dropna=False, as_index=False)[MEASURE_COLUMNS].sum(min_count=1)
    result = pd.merge(filtered[GROUP_BY_COLUMNS].drop_duplicates(), grouped, on=GROUP_BY_COLUMNS, how='left')
    # Ensure order matches SQL
    return result[OUTPUT_COLUMNS]

def test_TC_01(sample_input_df):
    df = sample_input_df
    result = run_sql_transformation(df)
    assert all(result['MANDT'].isin([120, 200]))
    assert not any(result['MANDT'] == 100)

def test_TC_02():
    # Two rows with same group-by columns, different measures
    data = [
        dict(MANDT=120, STRNUM='A', PRCTR='P1', RX_HRS_OPER=10, FS_HRS_OPER=20, RETAIL_SQFT_AMT=100, TOTAL_SQFT_AMT=200, **{col: 'X' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
        dict(MANDT=120, STRNUM='A', PRCTR='P1', RX_HRS_OPER=5, FS_HRS_OPER=8, RETAIL_SQFT_AMT=50, TOTAL_SQFT_AMT=70, **{col: 'X' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
    ]
    df = pd.DataFrame(data)
    for col in OUTPUT_COLUMNS:
        if col not in df.columns:
            df[col] = None
    result = run_sql_transformation(df)
    # Should be one row, sums correct
    assert len(result) == 1
    assert result['RX_HRS_OPER'].iloc[0] == 15
    assert result['FS_HRS_OPER'].iloc[0] == 28
    assert result['RETAIL_SQFT_AMT'].iloc[0] == 150
    assert result['TOTAL_SQFT_AMT'].iloc[0] == 270

def test_TC_03():
    # Multiple groups, check sums
    data = [
        dict(MANDT=120, STRNUM='A', PRCTR='P1', RX_HRS_OPER=1, FS_HRS_OPER=2, RETAIL_SQFT_AMT=3, TOTAL_SQFT_AMT=4, **{col: 'X' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
        dict(MANDT=120, STRNUM='A', PRCTR='P1', RX_HRS_OPER=2, FS_HRS_OPER=3, RETAIL_SQFT_AMT=4, TOTAL_SQFT_AMT=5, **{col: 'X' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
        dict(MANDT=120, STRNUM='B', PRCTR='P2', RX_HRS_OPER=5, FS_HRS_OPER=6, RETAIL_SQFT_AMT=7, TOTAL_SQFT_AMT=8, **{col: 'Y' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
    ]
    df = pd.DataFrame(data)
    for col in OUTPUT_COLUMNS:
        if col not in df.columns:
            df[col] = None
    result = run_sql_transformation(df)
    # Should be two groups
    assert len(result) == 2
    group_a = result[result['STRNUM'] == 'A']
    assert group_a['RX_HRS_OPER'].iloc[0] == 3
    assert group_a['FS_HRS_OPER'].iloc[0] == 5
    assert group_a['RETAIL_SQFT_AMT'].iloc[0] == 7
    assert group_a['TOTAL_SQFT_AMT'].iloc[0] == 9

def test_TC_04():
    # NULLs in measure columns
    data = [
        dict(MANDT=120, STRNUM='A', PRCTR='P1', RX_HRS_OPER=None, FS_HRS_OPER=2, RETAIL_SQFT_AMT=None, TOTAL_SQFT_AMT=4, **{col: 'X' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
        dict(MANDT=120, STRNUM='A', PRCTR='P1', RX_HRS_OPER=3, FS_HRS_OPER=None, RETAIL_SQFT_AMT=4, TOTAL_SQFT_AMT=None, **{col: 'X' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
    ]
    df = pd.DataFrame(data)
    for col in OUTPUT_COLUMNS:
        if col not in df.columns:
            df[col] = None
    result = run_sql_transformation(df)
    assert result['RX_HRS_OPER'].iloc[0] == 3  # None is ignored
    assert result['FS_HRS_OPER'].iloc[0] == 2
    assert result['RETAIL_SQFT_AMT'].iloc[0] == 4
    assert result['TOTAL_SQFT_AMT'].iloc[0] == 4

def test_TC_05():
    # NULLs in group-by columns
    data = [
        dict(MANDT=120, STRNUM=None, PRCTR='P1', RX_HRS_OPER=1, FS_HRS_OPER=2, RETAIL_SQFT_AMT=3, TOTAL_SQFT_AMT=4, **{col: 'X' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
        dict(MANDT=120, STRNUM=None, PRCTR='P1', RX_HRS_OPER=2, FS_HRS_OPER=3, RETAIL_SQFT_AMT=4, TOTAL_SQFT_AMT=5, **{col: 'X' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
    ]
    df = pd.DataFrame(data)
    for col in OUTPUT_COLUMNS:
        if col not in df.columns:
            df[col] = None
    result = run_sql_transformation(df)
    assert len(result) == 1
    assert result['RX_HRS_OPER'].iloc[0] == 3

def test_TC_06():
    # No rows match filter
    data = [
        dict(MANDT=100, STRNUM='A', PRCTR='P1', RX_HRS_OPER=1, FS_HRS_OPER=2, RETAIL_SQFT_AMT=3, TOTAL_SQFT_AMT=4, **{col: 'X' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
    ]
    df = pd.DataFrame(data)
    for col in OUTPUT_COLUMNS:
        if col not in df.columns:
            df[col] = None
    result = run_sql_transformation(df)
    assert result.empty

def test_TC_07():
    # All measure columns NULL for a group
    data = [
        dict(MANDT=120, STRNUM='A', PRCTR='P1', RX_HRS_OPER=None, FS_HRS_OPER=None, RETAIL_SQFT_AMT=None, TOTAL_SQFT_AMT=None, **{col: 'X' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
        dict(MANDT=120, STRNUM='A', PRCTR='P1', RX_HRS_OPER=None, FS_HRS_OPER=None, RETAIL_SQFT_AMT=None, TOTAL_SQFT_AMT=None, **{col: 'X' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
    ]
    df = pd.DataFrame(data)
    for col in OUTPUT_COLUMNS:
        if col not in df.columns:
            df[col] = None
    result = run_sql_transformation(df)
    assert pd.isnull(result['RX_HRS_OPER'].iloc[0])
    assert pd.isnull(result['FS_HRS_OPER'].iloc[0])
    assert pd.isnull(result['RETAIL_SQFT_AMT'].iloc[0])
    assert pd.isnull(result['TOTAL_SQFT_AMT'].iloc[0])

def test_TC_08():
    # All non-measure columns present and mapped 1:1
    data = [
        dict(MANDT=120, STRNUM='A', PRCTR='P1', RX_HRS_OPER=1, FS_HRS_OPER=2, RETAIL_SQFT_AMT=3, TOTAL_SQFT_AMT=4, **{col: f'val_{col}' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
    ]
    df = pd.DataFrame(data)
    for col in OUTPUT_COLUMNS:
        if col not in df.columns:
            df[col] = None
    result = run_sql_transformation(df)
    for col in GROUP_BY_COLUMNS:
        assert result[col].iloc[0] == df[col].iloc[0]
    assert result.columns.tolist() == OUTPUT_COLUMNS

def test_TC_09():
    # Non-numeric value in measure column should error
    data = [
        dict(MANDT=120, STRNUM='A', PRCTR='P1', RX_HRS_OPER='abc', FS_HRS_OPER=2, RETAIL_SQFT_AMT=3, TOTAL_SQFT_AMT=4, **{col: 'X' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
    ]
    df = pd.DataFrame(data)
    for col in OUTPUT_COLUMNS:
        if col not in df.columns:
            df[col] = None
    with pytest.raises(TypeError):
        run_sql_transformation(df)

def test_TC_10():
    # Column order in output matches specification
    data = [
        dict(MANDT=120, STRNUM='A', PRCTR='P1', RX_HRS_OPER=1, FS_HRS_OPER=2, RETAIL_SQFT_AMT=3, TOTAL_SQFT_AMT=4, **{col: f'val_{col}' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
    ]
    df = pd.DataFrame(data)
    for col in OUTPUT_COLUMNS:
        if col not in df.columns:
            df[col] = None
    result = run_sql_transformation(df)
    assert result.columns.tolist() == OUTPUT_COLUMNS

def test_TC_11():
    # No calculated columns, joins, or unions
    data = [
        dict(MANDT=120, STRNUM='A', PRCTR='P1', RX_HRS_OPER=1, FS_HRS_OPER=2, RETAIL_SQFT_AMT=3, TOTAL_SQFT_AMT=4, **{col: 'X' for col in GROUP_BY_COLUMNS if col not in ['MANDT', 'STRNUM', 'PRCTR']}),
    ]
    df = pd.DataFrame(data)
    for col in OUTPUT_COLUMNS:
        if col not in df.columns:
            df[col] = None
    result = run_sql_transformation(df)
    # Check schema: only specified columns, no extra
    assert set(result.columns) == set(OUTPUT_COLUMNS)
    assert len(result.columns) == len(OUTPUT_COLUMNS)
```

---

**Cost Analysis**

`API Cost: 0.0000 USD`
