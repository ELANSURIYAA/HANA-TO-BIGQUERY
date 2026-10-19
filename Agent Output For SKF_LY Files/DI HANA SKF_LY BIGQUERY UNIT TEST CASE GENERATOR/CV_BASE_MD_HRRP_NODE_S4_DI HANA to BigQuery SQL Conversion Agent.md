**Unit Test Case Summary**

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Filter on MANDT includes only 120 and 200 | Input table contains rows with MANDT values 120, 200, and other values (e.g., 100, 300) | Only rows with MANDT = 120 or MANDT = 200 are present in the output | Output contains only rows where MANDT is 120 or 200; all other MANDT values are excluded |
| TC_02 | All columns are projected without transformation | Input table contains distinct values for each column (MANDT, HRYID, HRYVER, NODECLS, HRYNODE, PARNODE, HRYVALTO, HRYVALFROM, BALIND, NODETYPE, NODEVALUE) | Output columns match input table values for all projected columns, with no changes | For each row in the output, values for all columns match the input source table for the same row |
| TC_03 | No calculated columns or aggregations | Input table contains values that would change if aggregations or calculations were applied (e.g., duplicate rows, NULLs, non-unique values) | Output contains the same number of rows as input after filter, and no aggregation or calculation is performed | Output row count equals the number of input rows where MANDT is 120 or 200; all values are direct projections |
| TC_04 | NULL value handling in projected columns | Input table contains NULLs in any of the projected columns | Output preserves NULL values exactly as in the input | Output rows retain NULL values in all columns where input had NULLs |
| TC_05 | Data type handling for MANDT filter | Input table contains MANDT values as integers and, if possible, as strings (if schema allows) | Only rows where MANDT matches 120 or 200 as per the filter are included; rows with string values are excluded if not matching numerically | Output contains only rows with numeric MANDT = 120 or 200; no string or mismatched types are present in output |
| TC_06 | Output structure matches expected schema | Input table contains all columns as per the SQL | Output contains exactly the columns: MANDT, HRYID, HRYVER, NODECLS, HRYNODE, PARNODE, HRYVALTO, HRYVALFROM, BALIND, NODETYPE, NODEVALUE | Output schema matches exactly the column list in the SELECT statement, with correct order and names |

---

**Pytest Script**

```python
import pytest

# Mock data representing the input and expected output after applying the SQL logic.
# Each test function below is self-contained and does not require external systems.

@pytest.fixture
def input_data():
    # List of dicts, each representing a row in the source table
    return [
        # Rows with allowed MANDT values
        {'MANDT': 120, 'HRYID': 'A', 'HRYVER': 1, 'NODECLS': 'X', 'HRYNODE': 'N1', 'PARNODE': 'P1', 'HRYVALTO': '2024-12-31', 'HRYVALFROM': '2024-01-01', 'BALIND': 'Y', 'NODETYPE': 'T1', 'NODEVALUE': 'V1'},
        {'MANDT': 200, 'HRYID': 'B', 'HRYVER': 2, 'NODECLS': 'Y', 'HRYNODE': 'N2', 'PARNODE': 'P2', 'HRYVALTO': '2024-11-30', 'HRYVALFROM': '2024-02-01', 'BALIND': 'N', 'NODETYPE': 'T2', 'NODEVALUE': 'V2'},
        # Rows with disallowed MANDT values
        {'MANDT': 100, 'HRYID': 'C', 'HRYVER': 3, 'NODECLS': 'Z', 'HRYNODE': 'N3', 'PARNODE': 'P3', 'HRYVALTO': '2024-10-31', 'HRYVALFROM': '2024-03-01', 'BALIND': 'Y', 'NODETYPE': 'T3', 'NODEVALUE': 'V3'},
        {'MANDT': 300, 'HRYID': 'D', 'HRYVER': 4, 'NODECLS': 'W', 'HRYNODE': 'N4', 'PARNODE': 'P4', 'HRYVALTO': '2024-09-30', 'HRYVALFROM': '2024-04-01', 'BALIND': 'N', 'NODETYPE': 'T4', 'NODEVALUE': 'V4'},
        # Row with NULLs
        {'MANDT': 120, 'HRYID': None, 'HRYVER': None, 'NODECLS': None, 'HRYNODE': None, 'PARNODE': None, 'HRYVALTO': None, 'HRYVALFROM': None, 'BALIND': None, 'NODETYPE': None, 'NODEVALUE': None},
        # Row with MANDT as string (should be excluded if filter expects integer)
        {'MANDT': '120', 'HRYID': 'E', 'HRYVER': 5, 'NODECLS': 'V', 'HRYNODE': 'N5', 'PARNODE': 'P5', 'HRYVALTO': '2024-08-31', 'HRYVALFROM': '2024-05-01', 'BALIND': 'Y', 'NODETYPE': 'T5', 'NODEVALUE': 'V5'},
    ]

def apply_sql_logic(rows):
    # Simulate the SQL: select only rows where MANDT == 120 or MANDT == 200 (as integer)
    # and project all columns as-is.
    return [
        row for row in rows
        if isinstance(row['MANDT'], int) and row['MANDT'] in (120, 200)
    ]

def test_TC_01_filter_on_MANDT(input_data):
    """TC_01: Filter on MANDT includes only 120 and 200"""
    result = apply_sql_logic(input_data)
    assert all(row['MANDT'] in (120, 200) for row in result), "Output contains MANDT values other than 120 or 200"
    assert all(isinstance(row['MANDT'], int) for row in result), "MANDT values should be integers in the output"
    # Ensure excluded values are not present
    excluded = [row for row in result if row['MANDT'] not in (120, 200)]
    assert len(excluded) == 0, f"Rows with MANDT not in (120, 200) found: {excluded}"

def test_TC_02_projection_of_all_columns(input_data):
    """TC_02: All columns are projected without transformation"""
    result = apply_sql_logic(input_data)
    # For each output row, check that all columns match the input
    for row in result:
        matching_input = next((r for r in input_data if r['MANDT'] == row['MANDT'] and r['HRYID'] == row['HRYID']), None)
        assert matching_input is not None, "Output row does not match any input row"
        for col in ['MANDT', 'HRYID', 'HRYVER', 'NODECLS', 'HRYNODE', 'PARNODE', 'HRYVALTO', 'HRYVALFROM', 'BALIND', 'NODETYPE', 'NODEVALUE']:
            assert row[col] == matching_input[col], f"Column {col} value changed during projection"

def test_TC_03_no_calculation_or_aggregation(input_data):
    """TC_03: No calculated columns or aggregations"""
    result = apply_sql_logic(input_data)
    # Output row count should be equal to the number of input rows with MANDT == 120 or 200 (as integer)
    expected_count = sum(1 for row in input_data if isinstance(row['MANDT'], int) and row['MANDT'] in (120, 200))
    assert len(result) == expected_count, f"Expected {expected_count} rows, got {len(result)}"
    # Ensure no aggregation: each output row matches a unique input row
    for row in result:
        matching = [r for r in input_data if all(row.get(col) == r.get(col) for col in row.keys())]
        assert len(matching) == 1, f"Row {row} appears to be aggregated or duplicated"

def test_TC_04_null_value_handling(input_data):
    """TC_04: NULL value handling in projected columns"""
    result = apply_sql_logic(input_data)
    # Find the row with all NULLs (except MANDT)
    null_row = next((row for row in result if row['HRYID'] is None and row['MANDT'] == 120), None)
    assert null_row is not None, "Row with NULLs in projected columns is missing"
    for col in ['HRYID', 'HRYVER', 'NODECLS', 'HRYNODE', 'PARNODE', 'HRYVALTO', 'HRYVALFROM', 'BALIND', 'NODETYPE', 'NODEVALUE']:
        assert null_row[col] is None, f"NULL in column {col} was not preserved"

def test_TC_05_data_type_handling_for_MANDT(input_data):
    """TC_05: Data type handling for MANDT filter"""
    result = apply_sql_logic(input_data)
    # Row with MANDT as string should not appear
    string_mandt_rows = [row for row in result if isinstance(row['MANDT'], str)]
    assert len(string_mandt_rows) == 0, "Rows with MANDT as string are incorrectly included"
    # Only integer 120/200 rows are present
    assert all(isinstance(row['MANDT'], int) and row['MANDT'] in (120, 200) for row in result), "Non-integer or invalid MANDT values found"

def test_TC_06_output_structure_matches_schema(input_data):
    """TC_06: Output structure matches expected schema"""
    result = apply_sql_logic(input_data)
    expected_columns = ['MANDT', 'HRYID', 'HRYVER', 'NODECLS', 'HRYNODE', 'PARNODE', 'HRYVALTO', 'HRYVALFROM', 'BALIND', 'NODETYPE', 'NODEVALUE']
    for row in result:
        assert list(row.keys()) == expected_columns, f"Output schema does not match expected columns: {row.keys()}"

```

---

**Cost Analysis**

API Cost: 0.0000 USD

---

**(GitHub Write Operation Follows...)**