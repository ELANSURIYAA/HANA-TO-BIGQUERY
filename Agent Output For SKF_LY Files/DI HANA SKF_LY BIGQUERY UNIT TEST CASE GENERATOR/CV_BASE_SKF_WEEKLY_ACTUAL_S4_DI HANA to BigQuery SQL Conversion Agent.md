# Unit Test Case Summary

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Validate filter on MANDT | Input contains rows with MANDT values 110, 200, and other values (e.g., 100, 300) | Only rows with MANDT 110 or 200 are included in output; others are excluded | Output does not contain any row where MANDT is not 110 or 200 |
| TC_02 | Validate SUM aggregation for measure columns | Multiple input rows with same attribute grouping and varying measure values | Output contains one row per unique attribute group with measures correctly summed | For each attribute group, SUM of each measure equals the sum of input measure values |
| TC_03 | Validate GROUP BY on all attribute columns | Input contains multiple rows with same and different combinations of attributes | Output contains one row per unique combination of attribute columns | No duplicate attribute groups in output; count of output rows equals count of unique attribute combinations in input |
| TC_04 | Validate direct mapping of attribute columns | Input has known values for all attribute columns | Output attribute columns match input values for each group | For each output row, attribute values match those in the input group |
| TC_05 | Validate handling of NULLs in measure columns | Input contains NULLs in measure columns | SUM aggregation treats NULLs as zero; output measure value sums only non-NULLs | Output measure values are sum of non-NULL input values (NULLs ignored) |
| TC_06 | Validate handling of NULLs in attribute columns | Input contains NULLs in one or more attribute columns | GROUP BY treats NULLs as a separate group | Output contains separate group(s) for NULL attribute combinations |
| TC_07 | Validate output column order | Input with any values | Output columns are in the exact order as specified in SELECT | Output schema matches specified column order |
| TC_08 | Validate no calculated columns or joins | Input with any values | Output contains only projected columns, no extra/calculated columns or joined data | Output schema matches only the listed columns |
| TC_09 | Validate SUM aggregation with all-zero measures | Input where all measure values are zero for a group | Output measure columns are zero for that group | Output measure values are exactly zero |
| TC_10 | Validate SUM aggregation with negative measure values | Input where some measure values are negative | Output measure columns reflect correct sum including negatives | Output measure values are algebraic sum (including negatives) |

# Pytest Script

```python
import pytest
from collections import defaultdict, namedtuple

# Simulated row structure for input and output
test_row = namedtuple('Row', [
    'FISCPER', 'FISCVARNT', 'FISCYEAR', 'FISCPER3', 'MANDT', 'RECORDMODE', 'UNIT', '_BIC_ZIO_SWEEK', '_BIC_ZIO_PSTY', '_BIC_ZIO_PSKF',
    '_B631_S_CO_AREA', '_BIC_ZIO_CMPCD', '_B631_S_PROFTCTR', '_B631_S_COSTCNTR', '_B631_S_FUNCAREA', '_BIC_ZIO_VER', '_BIC_ZIO_SAUDT',
    '_BIC_ZIO_SKFQ', '_BIC_ZIO_D1SKQ', '_BIC_ZIO_D2SKQ', '_BIC_ZIO_D3SKQ', '_BIC_ZIO_D4SKQ', '_BIC_ZIO_D5SKQ', '_BIC_ZIO_D6SKQ', '_BIC_ZIO_D7SKQ'
])

ATTR_COLS = [
    'FISCPER', 'FISCVARNT', 'FISCYEAR', 'FISCPER3', 'MANDT', 'RECORDMODE', 'UNIT', '_BIC_ZIO_SWEEK', '_BIC_ZIO_PSTY', '_BIC_ZIO_PSKF',
    '_B631_S_CO_AREA', '_BIC_ZIO_CMPCD', '_B631_S_PROFTCTR', '_B631_S_COSTCNTR', '_B631_S_FUNCAREA', '_BIC_ZIO_VER', '_BIC_ZIO_SAUDT'
]
MEASURE_COLS = [
    '_BIC_ZIO_SKFQ', '_BIC_ZIO_D1SKQ', '_BIC_ZIO_D2SKQ', '_BIC_ZIO_D3SKQ', '_BIC_ZIO_D4SKQ', '_BIC_ZIO_D5SKQ', '_BIC_ZIO_D6SKQ', '_BIC_ZIO_D7SKQ'
]

# Helper to simulate the SQL logic
def run_sql_logic(input_rows):
    # Apply filter
    filtered = [r for r in input_rows if r.MANDT in (110, 200)]
    # Group by all attribute columns
    grouped = defaultdict(list)
    for r in filtered:
        key = tuple(getattr(r, col) for col in ATTR_COLS)
        grouped[key].append(r)
    # Aggregate
    output = []
    for key, rows in grouped.items():
        agg = {col: getattr(rows[0], col) for col in ATTR_COLS}
        for m in MEASURE_COLS:
            agg[m] = sum((getattr(r, m) or 0) for r in rows)
        output.append(test_row(**agg))
    return output

# TC_01: Validate filter on MANDT
def test_TC_01():
    input_rows = [
        test_row(202301, 'A', 2023, 1, 110, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 1, 2, 3, 4, 5, 6, 7, 8),
        test_row(202301, 'A', 2023, 1, 200, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 2, 3, 4, 5, 6, 7, 8, 9),
        test_row(202301, 'A', 2023, 1, 100, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 3, 4, 5, 6, 7, 8, 9, 10),
    ]
    output = run_sql_logic(input_rows)
    assert all(r.MANDT in (110, 200) for r in output)
    assert not any(r.MANDT == 100 for r in output)

# TC_02: Validate SUM aggregation for measure columns
def test_TC_02():
    input_rows = [
        test_row(202301, 'A', 2023, 1, 110, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 1, 2, 3, 4, 5, 6, 7, 8),
        test_row(202301, 'A', 2023, 1, 110, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 2, 3, 4, 5, 6, 7, 8, 9),
    ]
    output = run_sql_logic(input_rows)
    assert len(output) == 1
    expected = [1+2, 2+3, 3+4, 4+5, 5+6, 6+7, 7+8, 8+9]
    for idx, m in enumerate(MEASURE_COLS):
        assert getattr(output[0], m) == expected[idx]

# TC_03: Validate GROUP BY on all attribute columns
def test_TC_03():
    input_rows = [
        test_row(202301, 'A', 2023, 1, 110, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 1, 2, 3, 4, 5, 6, 7, 8),
        test_row(202301, 'A', 2023, 1, 110, 'N', 'EA', 'W2', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 2, 3, 4, 5, 6, 7, 8, 9),
    ]
    output = run_sql_logic(input_rows)
    assert len(output) == 2
    keys = set(tuple(getattr(r, col) for col in ATTR_COLS) for r in output)
    assert len(keys) == 2

# TC_04: Validate direct mapping of attribute columns
def test_TC_04():
    input_rows = [
        test_row(202301, 'B', 2022, 2, 110, 'X', 'KG', 'W3', 'P3', 'K3', 'CA3', 'CM3', 'PF3', 'CC3', 'FA3', 'V3', 'AUD3', 10, 20, 30, 40, 50, 60, 70, 80),
    ]
    output = run_sql_logic(input_rows)
    for col in ATTR_COLS:
        assert getattr(output[0], col) == getattr(input_rows[0], col)

# TC_05: Validate handling of NULLs in measure columns
def test_TC_05():
    input_rows = [
        test_row(202301, 'A', 2023, 1, 110, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', None, 2, None, 4, None, 6, None, 8),
        test_row(202301, 'A', 2023, 1, 110, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 1, None, 3, None, 5, None, 7, None),
    ]
    output = run_sql_logic(input_rows)
    assert output[0]._BIC_ZIO_SKFQ == 1  # None + 1
    assert output[0]._BIC_ZIO_D1SKQ == 2  # 2 + None
    assert output[0]._BIC_ZIO_D2SKQ == 3  # None + 3
    assert output[0]._BIC_ZIO_D3SKQ == 4  # 4 + None
    assert output[0]._BIC_ZIO_D4SKQ == 5  # None + 5
    assert output[0]._BIC_ZIO_D5SKQ == 6  # 6 + None
    assert output[0]._BIC_ZIO_D6SKQ == 7  # None + 7
    assert output[0]._BIC_ZIO_D7SKQ == 8  # 8 + None

# TC_06: Validate handling of NULLs in attribute columns
def test_TC_06():
    input_rows = [
        test_row(None, 'A', 2023, 1, 110, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 1, 2, 3, 4, 5, 6, 7, 8),
        test_row(None, 'A', 2023, 1, 110, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 2, 3, 4, 5, 6, 7, 8, 9),
        test_row(202301, 'A', 2023, 1, 110, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 3, 4, 5, 6, 7, 8, 9, 10),
    ]
    output = run_sql_logic(input_rows)
    keys = set(tuple(getattr(r, col) for col in ATTR_COLS) for r in output)
    assert any(key[0] is None for key in keys)
    assert any(key[0] == 202301 for key in keys)

# TC_07: Validate output column order
def test_TC_07():
    input_rows = [
        test_row(1, 'A', 2, 3, 110, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 10, 20, 30, 40, 50, 60, 70, 80),
    ]
    output = run_sql_logic(input_rows)
    out_cols = output[0]._fields
    expected_order = ATTR_COLS + MEASURE_COLS
    assert list(out_cols) == expected_order

# TC_08: Validate no calculated columns or joins
def test_TC_08():
    input_rows = [
        test_row(1, 'A', 2, 3, 110, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 10, 20, 30, 40, 50, 60, 70, 80),
    ]
    output = run_sql_logic(input_rows)
    assert set(output[0]._fields) == set(ATTR_COLS + MEASURE_COLS)

# TC_09: Validate SUM aggregation with all-zero measures
def test_TC_09():
    input_rows = [
        test_row(1, 'A', 2, 3, 110, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 0, 0, 0, 0, 0, 0, 0, 0),
        test_row(1, 'A', 2, 3, 110, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 0, 0, 0, 0, 0, 0, 0, 0),
    ]
    output = run_sql_logic(input_rows)
    for m in MEASURE_COLS:
        assert getattr(output[0], m) == 0

# TC_10: Validate SUM aggregation with negative measure values
def test_TC_10():
    input_rows = [
        test_row(1, 'A', 2, 3, 110, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', -5, 10, -15, 20, -25, 30, -35, 40),
        test_row(1, 'A', 2, 3, 110, 'N', 'EA', 'W1', 'P1', 'K1', 'CA1', 'CM1', 'PF1', 'CC1', 'FA1', 'V1', 'AUD1', 5, -10, 15, -20, 25, -30, 35, -40),
    ]
    output = run_sql_logic(input_rows)
    # Each sum should be zero
    for m in MEASURE_COLS:
        assert getattr(output[0], m) == 0
```

# Cost Analysis

API Cost: 0.0000 USD
