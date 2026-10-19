**Unit Test Case Summary**

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Filter on MANDT includes only allowed values | Input table contains rows with MANDT values 110, 200, and other values (e.g., 100, 300) | Only rows with MANDT = 110 or 200 are present in the output; all other MANDT values are excluded | Check that all output rows have MANDT in (110, 200) and that no other MANDT values are present |
| TC_02 | All columns are projected 1:1 from source | Input table contains distinct, known values for each column | Output rows have the same values for all columns as the input, for rows where MANDT is 110 or 200 | For each output row, verify each column matches the input row with the same primary key (MANDT, PRCTR, STRNUM, COMP_VER, ZWEEK, ZMONTH, ZYEAR) |
| TC_03 | No calculated columns or transformations | Input table contains arbitrary values, including NULLs, in all columns | Output columns are not transformed or calculated; values (including NULLs) are preserved | For output, confirm that for every row, all columns are identical to the input for the filtered MANDT values |
| TC_04 | NULL handling in all columns | Input table contains NULL values in any/all columns (including MANDT, PRCTR, STRNUM, etc.) | NULL values are preserved in the output for filtered rows | For filtered rows, check that NULLs in input columns are also NULL in the output |
| TC_05 | Edge case: No matching MANDT values | Input table contains only rows with MANDT not in (110, 200) | Output is empty (no rows) | Confirm that the output has zero rows |
| TC_06 | Edge case: All rows match filter | Input table contains only rows where MANDT is 110 or 200 | All input rows are present in the output | Confirm that the output row count equals the input row count, and all values match |
| TC_07 | Edge case: Empty input table | Input table is empty | Output is also empty | Confirm that the output has zero rows |
| TC_08 | Data type compatibility for MANDT filter | Input table contains MANDT values as integers and as strings (if possible in BigQuery schema) | Only integer values 110 and 200 are included; string '110' or '200' are excluded if schema is integer | Output contains only rows where MANDT is integer 110 or 200; no rows with MANDT as string '110' or '200' |
| TC_09 | Column order and schema | Input table has columns in any order | Output columns appear in the exact order as specified in the SELECT statement | Confirm that output column order matches: MANDT, PRCTR, STRNUM, COMP_VER, ZWEEK, ZMONTH, ZYEAR, FS_COMP_PRE, RX_COMP_PRE, FS_COMP_MON, RX_COMP_MON, FS_COMP_WK, RX_COMP_WK |

---

**Pytest Script**

```python
import pytest

# Sample data structure: list of dicts, each dict is a row from the input table
# The test functions operate on in-memory data, not databases

# Helper function to simulate the SQL transformation
def apply_sql_logic(input_rows):
    # Filter MANDT in (110, 200)
    allowed_mandt = {110, 200}
    output_rows = [
        {
            "MANDT": row["MANDT"],
            "PRCTR": row["PRCTR"],
            "STRNUM": row["STRNUM"],
            "COMP_VER": row["COMP_VER"],
            "ZWEEK": row["ZWEEK"],
            "ZMONTH": row["ZMONTH"],
            "ZYEAR": row["ZYEAR"],
            "FS_COMP_PRE": row["FS_COMP_PRE"],
            "RX_COMP_PRE": row["RX_COMP_PRE"],
            "FS_COMP_MON": row["FS_COMP_MON"],
            "RX_COMP_MON": row["RX_COMP_MON"],
            "FS_COMP_WK": row["FS_COMP_WK"],
            "RX_COMP_WK": row["RX_COMP_WK"],
        }
        for row in input_rows
        if row["MANDT"] in allowed_mandt
    ]
    return output_rows

# TC_01: Filter on MANDT includes only allowed values
def test_tc_01_filter_on_mandt():
    input_rows = [
        {"MANDT": 110, "PRCTR": "A", "STRNUM": "001", "COMP_VER": 1, "ZWEEK": 10, "ZMONTH": 3, "ZYEAR": 2024,
         "FS_COMP_PRE": 1, "RX_COMP_PRE": 0, "FS_COMP_MON": 1, "RX_COMP_MON": 0, "FS_COMP_WK": 1, "RX_COMP_WK": 0},
        {"MANDT": 200, "PRCTR": "B", "STRNUM": "002", "COMP_VER": 2, "ZWEEK": 11, "ZMONTH": 4, "ZYEAR": 2024,
         "FS_COMP_PRE": 0, "RX_COMP_PRE": 1, "FS_COMP_MON": 0, "RX_COMP_MON": 1, "FS_COMP_WK": 0, "RX_COMP_WK": 1},
        {"MANDT": 100, "PRCTR": "C", "STRNUM": "003", "COMP_VER": 3, "ZWEEK": 12, "ZMONTH": 5, "ZYEAR": 2024,
         "FS_COMP_PRE": 1, "RX_COMP_PRE": 1, "FS_COMP_MON": 1, "RX_COMP_MON": 1, "FS_COMP_WK": 1, "RX_COMP_WK": 1},
        {"MANDT": 300, "PRCTR": "D", "STRNUM": "004", "COMP_VER": 4, "ZWEEK": 13, "ZMONTH": 6, "ZYEAR": 2024,
         "FS_COMP_PRE": 0, "RX_COMP_PRE": 0, "FS_COMP_MON": 0, "RX_COMP_MON": 0, "FS_COMP_WK": 0, "RX_COMP_WK": 0},
    ]
    output_rows = apply_sql_logic(input_rows)
    assert all(row["MANDT"] in (110, 200) for row in output_rows)
    assert all(row["MANDT"] not in (100, 300) for row in output_rows)
    assert len(output_rows) == 2

# TC_02: All columns are projected 1:1 from source
def test_tc_02_column_projection():
    input_row = {
        "MANDT": 110,
        "PRCTR": "A",
        "STRNUM": "001",
        "COMP_VER": 1,
        "ZWEEK": 10,
        "ZMONTH": 3,
        "ZYEAR": 2024,
        "FS_COMP_PRE": 1,
        "RX_COMP_PRE": 0,
        "FS_COMP_MON": 1,
        "RX_COMP_MON": 0,
        "FS_COMP_WK": 1,
        "RX_COMP_WK": 0,
    }
    input_rows = [input_row]
    output_rows = apply_sql_logic(input_rows)
    assert len(output_rows) == 1
    for col in input_row:
        assert output_rows[0][col] == input_row[col]

# TC_03: No calculated columns or transformations
def test_tc_03_no_calculated_columns():
    input_row = {
        "MANDT": 200,
        "PRCTR": "B",
        "STRNUM": "002",
        "COMP_VER": 2,
        "ZWEEK": 11,
        "ZMONTH": 4,
        "ZYEAR": 2024,
        "FS_COMP_PRE": 0,
        "RX_COMP_PRE": 1,
        "FS_COMP_MON": 0,
        "RX_COMP_MON": 1,
        "FS_COMP_WK": 0,
        "RX_COMP_WK": 1,
    }
    input_rows = [input_row]
    output_rows = apply_sql_logic(input_rows)
    assert output_rows[0] == input_row

# TC_04: NULL handling in all columns
def test_tc_04_null_handling():
    input_row = {
        "MANDT": 110,
        "PRCTR": None,
        "STRNUM": None,
        "COMP_VER": None,
        "ZWEEK": None,
        "ZMONTH": None,
        "ZYEAR": None,
        "FS_COMP_PRE": None,
        "RX_COMP_PRE": None,
        "FS_COMP_MON": None,
        "RX_COMP_MON": None,
        "FS_COMP_WK": None,
        "RX_COMP_WK": None,
    }
    input_rows = [input_row]
    output_rows = apply_sql_logic(input_rows)
    assert len(output_rows) == 1
    for col in input_row:
        assert output_rows[0][col] is None or output_rows[0][col] == input_row[col]

# TC_05: Edge case - No matching MANDT values
def test_tc_05_no_matching_mandt():
    input_rows = [
        {"MANDT": 100, "PRCTR": "A", "STRNUM": "001", "COMP_VER": 1, "ZWEEK": 10, "ZMONTH": 3, "ZYEAR": 2024,
         "FS_COMP_PRE": 1, "RX_COMP_PRE": 0, "FS_COMP_MON": 1, "RX_COMP_MON": 0, "FS_COMP_WK": 1, "RX_COMP_WK": 0}
    ]
    output_rows = apply_sql_logic(input_rows)
    assert len(output_rows) == 0

# TC_06: Edge case - All rows match filter
def test_tc_06_all_rows_match():
    input_rows = [
        {"MANDT": 110, "PRCTR": "A", "STRNUM": "001", "COMP_VER": 1, "ZWEEK": 10, "ZMONTH": 3, "ZYEAR": 2024,
         "FS_COMP_PRE": 1, "RX_COMP_PRE": 0, "FS_COMP_MON": 1, "RX_COMP_MON": 0, "FS_COMP_WK": 1, "RX_COMP_WK": 0},
        {"MANDT": 200, "PRCTR": "B", "STRNUM": "002", "COMP_VER": 2, "ZWEEK": 11, "ZMONTH": 4, "ZYEAR": 2024,
         "FS_COMP_PRE": 0, "RX_COMP_PRE": 1, "FS_COMP_MON": 0, "RX_COMP_MON": 1, "FS_COMP_WK": 0, "RX_COMP_WK": 1},
    ]
    output_rows = apply_sql_logic(input_rows)
    assert len(output_rows) == len(input_rows)
    for i, row in enumerate(input_rows):
        assert output_rows[i] == row

# TC_07: Edge case - Empty input table
def test_tc_07_empty_input():
    input_rows = []
    output_rows = apply_sql_logic(input_rows)
    assert output_rows == []

# TC_08: Data type compatibility for MANDT filter
def test_tc_08_mandt_type_compatibility():
    input_rows = [
        {"MANDT": 110, "PRCTR": "A", "STRNUM": "001", "COMP_VER": 1, "ZWEEK": 10, "ZMONTH": 3, "ZYEAR": 2024,
         "FS_COMP_PRE": 1, "RX_COMP_PRE": 0, "FS_COMP_MON": 1, "RX_COMP_MON": 0, "FS_COMP_WK": 1, "RX_COMP_WK": 0},
        {"MANDT": "110", "PRCTR": "B", "STRNUM": "002", "COMP_VER": 2, "ZWEEK": 11, "ZMONTH": 4, "ZYEAR": 2024,
         "FS_COMP_PRE": 0, "RX_COMP_PRE": 1, "FS_COMP_MON": 0, "RX_COMP_MON": 1, "FS_COMP_WK": 0, "RX_COMP_WK": 1},
        {"MANDT": 200, "PRCTR": "C", "STRNUM": "003", "COMP_VER": 3, "ZWEEK": 12, "ZMONTH": 5, "ZYEAR": 2024,
         "FS_COMP_PRE": 1, "RX_COMP_PRE": 1, "FS_COMP_MON": 1, "RX_COMP_MON": 1, "FS_COMP_WK": 1, "RX_COMP_WK": 1},
        {"MANDT": "200", "PRCTR": "D", "STRNUM": "004", "COMP_VER": 4, "ZWEEK": 13, "ZMONTH": 6, "ZYEAR": 2024,
         "FS_COMP_PRE": 0, "RX_COMP_PRE": 0, "FS_COMP_MON": 0, "RX_COMP_MON": 0, "FS_COMP_WK": 0, "RX_COMP_WK": 0},
    ]
    output_rows = apply_sql_logic(input_rows)
    # Only integer MANDT values should be included
    assert all(isinstance(row["MANDT"], int) and row["MANDT"] in (110, 200) for row in output_rows)
    assert len(output_rows) == 2

# TC_09: Column order and schema
def test_tc_09_column_order():
    input_row = {
        "MANDT": 110,
        "PRCTR": "A",
        "STRNUM": "001",
        "COMP_VER": 1,
        "ZWEEK": 10,
        "ZMONTH": 3,
        "ZYEAR": 2024,
        "FS_COMP_PRE": 1,
        "RX_COMP_PRE": 0,
        "FS_COMP_MON": 1,
        "RX_COMP_MON": 0,
        "FS_COMP_WK": 1,
        "RX_COMP_WK": 0,
    }
    # Shuffle input column order
    input_row_shuffled = dict(list(input_row.items())[::-1])
    input_rows = [input_row_shuffled]
    output_rows = apply_sql_logic(input_rows)
    expected_order = [
        "MANDT", "PRCTR", "STRNUM", "COMP_VER", "ZWEEK", "ZMONTH", "ZYEAR",
        "FS_COMP_PRE", "RX_COMP_PRE", "FS_COMP_MON", "RX_COMP_MON", "FS_COMP_WK", "RX_COMP_WK"
    ]
    assert list(output_rows[0].keys()) == expected_order
```

---

**Cost Analysis**

API Cost: 0.0000 USD

---
