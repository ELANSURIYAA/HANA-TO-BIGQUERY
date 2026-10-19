**Unit Test Case Summary**

| Test Case ID | Test Scenario                                         | Input/Data Condition                                                                                                     | Expected Result                                                                                                                  | Validation                                                                                   |
|--------------|-------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|
| TC_01        | Positive: MANDT filter includes valid values          | Row with MANDT=110 and all other columns populated with sample data                                                     | Row is included in the output; all columns are projected as-is                                                                   | Output contains the row with MANDT=110 and all columns matching input                        |
| TC_02        | Positive: MANDT filter includes second valid value    | Row with MANDT=200 and all other columns populated with sample data                                                     | Row is included in the output; all columns are projected as-is                                                                   | Output contains the row with MANDT=200 and all columns matching input                        |
| TC_03        | Negative: MANDT filter excludes invalid value         | Row with MANDT=100 (not in filter list) and all other columns populated                                                 | Row is excluded from the output                                                                                                  | Output does NOT contain the row with MANDT=100                                               |
| TC_04        | Edge: MANDT at lower boundary of filter               | Row with MANDT=110                                                                                                      | Row is included in the output                                                                                                    | Output contains the row with MANDT=110                                                       |
| TC_05        | Edge: MANDT at upper boundary of filter               | Row with MANDT=200                                                                                                      | Row is included in the output                                                                                                    | Output contains the row with MANDT=200                                                       |
| TC_06        | Edge: MANDT just below lower boundary                 | Row with MANDT=109                                                                                                      | Row is excluded from the output                                                                                                  | Output does NOT contain the row with MANDT=109                                               |
| TC_07        | Edge: MANDT just above upper boundary                 | Row with MANDT=201                                                                                                      | Row is excluded from the output                                                                                                  | Output does NOT contain the row with MANDT=201                                               |
| TC_08        | Null handling: Non-MANDT columns are NULL             | Row with MANDT=110, other columns set to NULL                                                                           | Row is included in the output; columns retain NULL values                                                                        | Output contains the row with MANDT=110 and NULLs in non-MANDT columns                        |
| TC_09        | Null handling: MANDT is NULL                         | Row with MANDT=NULL, other columns populated                                                                             | Row is excluded from the output (NULL does not match IN (110, 200))                                                             | Output does NOT contain the row with MANDT=NULL                                              |
| TC_10        | Data type: MANDT as integer                          | Row with MANDT=110 (int), all columns populated                                                                         | Row is included; filter works as expected                                                                                        | Output contains the row with MANDT=110                                                       |
| TC_11        | Data type: MANDT as string                           | Row with MANDT='110' (string), all columns populated (simulate string type if schema allows)                            | Row is excluded if filter is on integer values; included only if filter values are quoted and match string type                  | Output contains or does not contain row depending on filter implementation and column type    |
| TC_12        | Projection: All columns are passed through as-is     | Row with MANDT=110, other columns with distinct sample values                                                            | Output row has all columns matching the input values                                                                             | Output columns for the row match the input exactly                                            |
| TC_13        | Empty table                                          | No rows in PROJECT.DATASET.ZTSRP_COMPFL                                                                                 | Output is empty                                                                                                                  | Output is empty                                                                              |
| TC_14        | Multiple valid and invalid MANDT rows                | Rows with MANDT=110, 200, 100, 300, NULL, and various data in other columns                                             | Only rows with MANDT=110 and 200 are included                                                                                    | Output contains only rows with MANDT=110 and 200                                             |
| TC_15        | Column order                                         | Input row with known values for all columns                                                                             | Output columns appear in the same order as in the SELECT statement                                                               | Output column order matches SQL SELECT list                                                   |

---

**Pytest Script**

```python
import pytest

# Sample data row structure for testing: dict with all columns
COLUMNS = [
    "MANDT", "PRCTR", "STRNUM", "COMP_VER", "ZWEEK", "ZMONTH", "ZYEAR",
    "FS_COMP_PRE", "RX_COMP_PRE", "FS_COMP_MON", "RX_COMP_MON", "FS_COMP_WK", "RX_COMP_WK"
]

def filter_and_project(rows, mandt_type=int):
    # Simulate the BigQuery SQL transformation
    valid_mandts = [110, 200] if mandt_type == int else ['110', '200']
    return [
        {col: row.get(col) for col in COLUMNS}
        for row in rows
        if row.get("MANDT") in valid_mandts
    ]

def test_TC_01():
    row = {col: f"val_{col}" for col in COLUMNS}
    row["MANDT"] = 110
    result = filter_and_project([row])
    assert len(result) == 1
    assert result[0] == row

def test_TC_02():
    row = {col: f"val_{col}" for col in COLUMNS}
    row["MANDT"] = 200
    result = filter_and_project([row])
    assert len(result) == 1
    assert result[0] == row

def test_TC_03():
    row = {col: f"val_{col}" for col in COLUMNS}
    row["MANDT"] = 100
    result = filter_and_project([row])
    assert len(result) == 0

def test_TC_04():
    row = {col: f"val_{col}" for col in COLUMNS}
    row["MANDT"] = 110
    result = filter_and_project([row])
    assert len(result) == 1
    assert result[0]["MANDT"] == 110

def test_TC_05():
    row = {col: f"val_{col}" for col in COLUMNS}
    row["MANDT"] = 200
    result = filter_and_project([row])
    assert len(result) == 1
    assert result[0]["MANDT"] == 200

def test_TC_06():
    row = {col: f"val_{col}" for col in COLUMNS}
    row["MANDT"] = 109
    result = filter_and_project([row])
    assert len(result) == 0

def test_TC_07():
    row = {col: f"val_{col}" for col in COLUMNS}
    row["MANDT"] = 201
    result = filter_and_project([row])
    assert len(result) == 0

def test_TC_08():
    row = {col: None for col in COLUMNS}
    row["MANDT"] = 110
    result = filter_and_project([row])
    assert len(result) == 1
    assert all(result[0][col] is None for col in COLUMNS if col != "MANDT")

def test_TC_09():
    row = {col: f"val_{col}" for col in COLUMNS}
    row["MANDT"] = None
    result = filter_and_project([row])
    assert len(result) == 0

def test_TC_10():
    row = {col: f"val_{col}" for col in COLUMNS}
    row["MANDT"] = 110  # Integer type
    result = filter_and_project([row], mandt_type=int)
    assert len(result) == 1
    assert result[0]["MANDT"] == 110

def test_TC_11():
    # MANDT as string, filter as int (should not match)
    row = {col: f"val_{col}" for col in COLUMNS}
    row["MANDT"] = "110"
    result = filter_and_project([row], mandt_type=int)
    assert len(result) == 0
    # MANDT as string, filter as string (should match)
    result = filter_and_project([row], mandt_type=str)
    assert len(result) == 1
    assert result[0]["MANDT"] == "110"

def test_TC_12():
    row = {col: f"val_{col}" for col in COLUMNS}
    row["MANDT"] = 110
    result = filter_and_project([row])
    assert result[0] == row

def test_TC_13():
    result = filter_and_project([])
    assert result == []

def test_TC_14():
    rows = [
        {**{col: f"val_{col}_110" for col in COLUMNS}, "MANDT": 110},
        {**{col: f"val_{col}_200" for col in COLUMNS}, "MANDT": 200},
        {**{col: f"val_{col}_100" for col in COLUMNS}, "MANDT": 100},
        {**{col: f"val_{col}_300" for col in COLUMNS}, "MANDT": 300},
        {**{col: f"val_{col}_NULL" for col in COLUMNS}, "MANDT": None},
    ]
    result = filter_and_project(rows)
    mandts = [row["MANDT"] for row in result]
    assert set(mandts) == {110, 200}
    assert all(row["MANDT"] in [110, 200] for row in result)

def test_TC_15():
    row = {
        "MANDT": 110,
        "PRCTR": "A",
        "STRNUM": "B",
        "COMP_VER": "C",
        "ZWEEK": "D",
        "ZMONTH": "E",
        "ZYEAR": "F",
        "FS_COMP_PRE": "G",
        "RX_COMP_PRE": "H",
        "FS_COMP_MON": "I",
        "RX_COMP_MON": "J",
        "FS_COMP_WK": "K",
        "RX_COMP_WK": "L"
    }
    result = filter_and_project([row])
    assert list(result[0].keys()) == COLUMNS  # Check column order
```

---

**Cost Analysis**

API Cost: 0.0000 USD
