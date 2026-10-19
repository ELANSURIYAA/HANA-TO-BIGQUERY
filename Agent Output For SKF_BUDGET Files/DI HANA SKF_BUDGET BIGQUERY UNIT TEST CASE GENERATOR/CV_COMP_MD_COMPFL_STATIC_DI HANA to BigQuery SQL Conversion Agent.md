# Unit Test Case Summary

| Test Case ID | Test Scenario                                                      | Input/Data Condition                                                                                                   | Expected Result                                                                                       | Validation                                                        |
| ------------ | ------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| TC_01        | All columns projected one-to-one                                  | Table contains a row with all columns populated with non-null, valid values                                            | Output row contains exactly the same values for each column as the input row, column order preserved   | Output row matches input row for all projected columns            |
| TC_02        | Projection with NULL values                                        | Table contains a row where some or all columns are NULL                                                               | Output row contains NULL in the same columns as input; no transformation or defaulting occurs         | Output row NULLs match input row NULLs                            |
| TC_03        | Projection with multiple rows                                      | Table contains multiple rows with varying values (including duplicates, unique, NULLs)                                 | Output contains all input rows, unchanged                                                             | Output row count and values match input                           |
| TC_04        | Projection with zero rows                                          | Table is empty (no rows)                                                                                              | Output is empty (no rows returned)                                                                    | Output has zero rows                                              |
| TC_05        | Column order and naming                                            | Table contains at least one row                                                                                       | Output columns are named and ordered exactly as in SQL: MANDT, PRCTR, STRNUM, COMP_VER, ZWEEK, ZMONTH, ZYEAR, FS_COMP_PRE, RX_COMP_PRE, FS_COMP_MON, RX_COMP_MON, FS_COMP_WK, RX_COMP_WK | Output column names and order match SQL definition                |
| TC_06        | No filters or transformations applied                              | Table contains rows with values that could be filtered or transformed (e.g., negative numbers, special characters)     | All rows are returned as-is, with no filtering or transformation                                       | Output includes all input rows, unchanged                         |
| TC_07        | Data type preservation                                             | Table contains various data types (e.g., integer, string, date) in columns                                            | Output preserves data types as per input for all columns                                              | Output data types match input data types for each column          |
| TC_08        | No aggregation or grouping                                         | Table contains rows with duplicate values or values that could be aggregated                                           | Output contains all rows, including duplicates; no aggregation or grouping is performed                | Output row count matches input, duplicates preserved              |


# Pytest Script

```python
import pytest

# Sample data for testing (as list of dicts representing table rows)
sample_rows = [
    {
        'MANDT': '100', 'PRCTR': 'A1', 'STRNUM': '001', 'COMP_VER': 'V1', 'ZWEEK': '12', 'ZMONTH': '03', 'ZYEAR': '2024',
        'FS_COMP_PRE': 10, 'RX_COMP_PRE': 20, 'FS_COMP_MON': 30, 'RX_COMP_MON': 40, 'FS_COMP_WK': 50, 'RX_COMP_WK': 60
    },
    {
        'MANDT': None, 'PRCTR': 'B2', 'STRNUM': None, 'COMP_VER': 'V2', 'ZWEEK': None, 'ZMONTH': '07', 'ZYEAR': '2023',
        'FS_COMP_PRE': None, 'RX_COMP_PRE': 0, 'FS_COMP_MON': None, 'RX_COMP_MON': 0, 'FS_COMP_WK': None, 'RX_COMP_WK': 0
    },
    {
        'MANDT': '300', 'PRCTR': 'C3', 'STRNUM': '003', 'COMP_VER': 'V3', 'ZWEEK': '25', 'ZMONTH': '12', 'ZYEAR': '2022',
        'FS_COMP_PRE': -5, 'RX_COMP_PRE': -10, 'FS_COMP_MON': -15, 'RX_COMP_MON': -20, 'FS_COMP_WK': -25, 'RX_COMP_WK': -30
    }
]

# Simulated SQL projection function
def project_rows(input_rows):
    columns = [
        'MANDT', 'PRCTR', 'STRNUM', 'COMP_VER', 'ZWEEK', 'ZMONTH', 'ZYEAR',
        'FS_COMP_PRE', 'RX_COMP_PRE', 'FS_COMP_MON', 'RX_COMP_MON', 'FS_COMP_WK', 'RX_COMP_WK'
    ]
    # Only project the listed columns in order
    return [ {col: row.get(col) for col in columns} for row in input_rows ]

# TC_01: All columns projected one-to-one
def test_TC_01_all_columns_projected():
    input_row = sample_rows[0]
    output = project_rows([input_row])
    assert output[0] == input_row
    assert list(output[0].keys()) == [
        'MANDT', 'PRCTR', 'STRNUM', 'COMP_VER', 'ZWEEK', 'ZMONTH', 'ZYEAR',
        'FS_COMP_PRE', 'RX_COMP_PRE', 'FS_COMP_MON', 'RX_COMP_MON', 'FS_COMP_WK', 'RX_COMP_WK'
    ]

# TC_02: Projection with NULL values
def test_TC_02_projection_with_nulls():
    input_row = sample_rows[1]
    output = project_rows([input_row])
    assert output[0] == input_row
    for col in output[0]:
        assert (output[0][col] is None) == (input_row[col] is None)

# TC_03: Projection with multiple rows
def test_TC_03_projection_multiple_rows():
    output = project_rows(sample_rows)
    assert output == sample_rows
    assert len(output) == len(sample_rows)

# TC_04: Projection with zero rows
def test_TC_04_projection_zero_rows():
    output = project_rows([])
    assert output == []
    assert len(output) == 0

# TC_05: Column order and naming
def test_TC_05_column_order_and_naming():
    input_row = sample_rows[2]
    output = project_rows([input_row])
    expected_order = [
        'MANDT', 'PRCTR', 'STRNUM', 'COMP_VER', 'ZWEEK', 'ZMONTH', 'ZYEAR',
        'FS_COMP_PRE', 'RX_COMP_PRE', 'FS_COMP_MON', 'RX_COMP_MON', 'FS_COMP_WK', 'RX_COMP_WK'
    ]
    assert list(output[0].keys()) == expected_order

# TC_06: No filters or transformations applied
def test_TC_06_no_filters_or_transformations():
    # Input includes negative numbers, special cases
    output = project_rows(sample_rows)
    assert output == sample_rows

# TC_07: Data type preservation
def test_TC_07_data_type_preservation():
    output = project_rows(sample_rows)
    for inp, out in zip(sample_rows, output):
        for col in inp:
            assert type(out[col]) == type(inp[col]) or (inp[col] is None and out[col] is None)

# TC_08: No aggregation or grouping
def test_TC_08_no_aggregation_or_grouping():
    # Add duplicate row
    input_rows = sample_rows + [sample_rows[0]]
    output = project_rows(input_rows)
    assert output == input_rows
    assert output.count(sample_rows[0]) == 2
```

# Cost Analysis

API Cost: 0.0000 USD
