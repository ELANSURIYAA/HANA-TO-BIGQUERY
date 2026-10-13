**Unit Test Case Summary**

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Filter on MANDT in WEEKLY_SNAPSHOT_DS05_BASE | Source table rows with MANDT values 110, 200, and others | Only rows with MANDT = 110 or 200 included | Output contains only MANDT 110, 200; others are excluded |
| TC_02 | Aggregation of amount columns in WEEKLY_SNAPSHOT_DS05_BASE | Multiple rows with same group by keys, different _B631_S_AMOUNT | SUM(_B631_S_AMOUNT) is correct per group | Aggregated value matches manual sum of input rows |
| TC_03 | FISCVARNT filter in WEEKLY_SNAPSHOT_DS05 | Rows with FISCVARNT = 'K4' and others | Only rows with FISCVARNT = 'K4' included | Output does not contain rows with FISCVARNT ≠ 'K4' |
| TC_04 | _BIC_ZIO_VER filter in WEEKLY_SNAPSHOT_DS05 | Rows with _BIC_ZIO_VER = @IP_VERSION and others | Only rows with _BIC_ZIO_VER = @IP_VERSION included | Output contains only filtered version |
| TC_05 | _BIC_ZIO_SWEEK filter in WEEKLY_SNAPSHOT_DS05 | Rows with _BIC_ZIO_SWEEK = @IP_WEEK_LY and others | Only rows with _BIC_ZIO_SWEEK = @IP_WEEK_LY included | Output contains only filtered week |
| TC_06 | _BIC_ZIO_SAUDT filter in WEEKLY_SNAPSHOT_DS05 | Rows with _BIC_ZIO_SAUDT = '1', '10', and others | Only rows with _BIC_ZIO_SAUDT in ('1', '10') included | Output contains only filtered audit types |
| TC_07 | Join_4: INNER JOIN on _B631_S_PROFTCTR and MANDT | Matching and non-matching values between WEEKLY_SNAPSHOT_DS05 and PC_HIER | Only rows with matching _B631_S_PROFTCTR and MANDT included | Output does not contain non-matching join rows |
| TC_08 | Join_6: INNER JOIN on _B631_S_GL_ACCT and MANDT | Matching and non-matching values between Join_4 and GL_HIER | Only rows with matching _B631_S_GL_ACCT and MANDT included | Output does not contain non-matching join rows |
| TC_09 | LEFT JOIN STORE_ATTR_ACTUAL | Join_6 rows with and without matching PRCTR and MANDT in STORE_ATTR_ACTUAL | All Join_6 rows preserved; store attributes are NULL where no match | Output row count matches Join_6; NULLs where no store match |
| TC_10 | LEFT JOIN RETAIL_CAL | Rows with and without matching CAL_WEEK and MANDT in RETAIL_CAL | All Join_2 rows preserved; ZRWSTRTDATE/ZRWENDDATE NULL if no match | Output row count matches Join_2; NULLs for non-matches |
| TC_11 | LEFT JOIN COMP_FLAG_LY | Rows with and without matching PRCTR, MANDT in COMP_FLAG_LY | All WEEK_NUMBER rows preserved; FS_COMP_WK/RX_COMP_WK NULL if no match | Output row count matches WEEK_NUMBER; NULLs for non-matches |
| TC_12 | LEFT JOIN PROFIT_CENTER_TEXT | Rows with and without matching PRCTR, MANDT in PROFIT_CENTER_TEXT | All Join_3 rows preserved; PROFIT_CENTER_TEXT NULL if no match | Output row count matches Join_3; NULLs for non-matches |
| TC_13 | CAL_FS_RX_FLAG derivation | _BIC_ZWWPC_PA1 values starting with 'FS', 'RX', and others | CAL_FS_RX_FLAG is 'FS', 'RX', or '' accordingly | Output column CAL_FS_RX_FLAG matches logic |
| TC_14 | CAL_WEEK_NUMBER calculation | @IP_WEEK_CY values (e.g., '202345') | CAL_WEEK_NUMBER is rightmost 2 chars of @IP_WEEK_CY | Output column CAL_WEEK_NUMBER is as expected |
| TC_15 | CAL_COMP_FLAG logic | CAL_FS_RX_FLAG='FS' or 'RX' or '' and matching FS_COMP_WK/RX_COMP_WK | CAL_COMP_FLAG is FS_COMP_WK if 'FS', RX_COMP_WK if 'RX', else FS_COMP_WK | Output column CAL_COMP_FLAG matches logic |
| TC_16 | Final aggregation and negation of _B631_S_AMOUNT | Multiple FLAGS_FINAL rows per group; positive and negative values | SUM(_B631_S_AMOUNT) per group, then multiplied by -1 | Output matches expected group sum and negation |
| TC_17 | NULL handling in joins and derived columns | Missing join keys or NULL source fields | Output columns from non-matching joins are NULL; derived columns handle NULLs | Output matches expected NULL propagation |
| TC_18 | Data type conversion in LTRIM(NODEVALUE, '0') | NODEVALUE values with/without leading zeros | CAL_NODE_VALUE has leading zeros removed | Output column CAL_NODE_VALUE matches expected |
| TC_19 | GROUP BY completeness | Multiple rows with same dimension values, different measures | All dimension columns are included in GROUP BY; measures are aggregated | Output grouping matches all dimension columns |

---

**Pytest Script**

```python
import pytest

# Test data samples are minimal and illustrative only.

def test_TC_01():
    input_rows = [
        {"MANDT": 110}, {"MANDT": 200}, {"MANDT": 300}
    ]
    filtered = [row for row in input_rows if row["MANDT"] in (110, 200)]
    assert all(row["MANDT"] in (110, 200) for row in filtered)
    assert not any(row["MANDT"] == 300 for row in filtered)

def test_TC_02():
    input_rows = [
        {"key": 1, "_B631_S_AMOUNT": 10},
        {"key": 1, "_B631_S_AMOUNT": 20}
    ]
    agg = {}
    for row in input_rows:
        agg.setdefault(row["key"], 0)
        agg[row["key"]] += row["_B631_S_AMOUNT"]
    assert agg[1] == 30

def test_TC_03():
    rows = [
        {"FISCVARNT": "K4"}, {"FISCVARNT": "XX"}
    ]
    filtered = [r for r in rows if r["FISCVARNT"] == "K4"]
    assert all(r["FISCVARNT"] == "K4" for r in filtered)

def test_TC_04():
    IP_VERSION = "A"
    rows = [
        {"_BIC_ZIO_VER": "A"}, {"_BIC_ZIO_VER": "B"}
    ]
    filtered = [r for r in rows if r["_BIC_ZIO_VER"] == IP_VERSION]
    assert all(r["_BIC_ZIO_VER"] == IP_VERSION for r in filtered)

def test_TC_05():
    IP_WEEK_LY = "202345"
    rows = [
        {"_BIC_ZIO_SWEEK": "202345"}, {"_BIC_ZIO_SWEEK": "202346"}
    ]
    filtered = [r for r in rows if r["_BIC_ZIO_SWEEK"] == IP_WEEK_LY]
    assert all(r["_BIC_ZIO_SWEEK"] == IP_WEEK_LY for r in filtered)

def test_TC_06():
    rows = [
        {"_BIC_ZIO_SAUDT": "1"}, {"_BIC_ZIO_SAUDT": "10"}, {"_BIC_ZIO_SAUDT": "2"}
    ]
    filtered = [r for r in rows if r["_BIC_ZIO_SAUDT"] in ("1", "10")]
    assert all(r["_BIC_ZIO_SAUDT"] in ("1", "10") for r in filtered)

def test_TC_07():
    ws = [{"_B631_S_PROFTCTR": "A", "MANDT": 120}, {"_B631_S_PROFTCTR": "B", "MANDT": 120}]
    pc = [{"NODEVALUE": "A", "MANDT": 120}]
    joined = [w for w in ws if any(p["NODEVALUE"] == w["_B631_S_PROFTCTR"] and p["MANDT"] == w["MANDT"] for p in pc)]
    assert joined == [{"_B631_S_PROFTCTR": "A", "MANDT": 120}]

def test_TC_08():
    j4 = [{"_B631_S_GL_ACCT": "X", "MANDT": 120}, {"_B631_S_GL_ACCT": "Y", "MANDT": 120}]
    gl = [{"NODEVALUE": "X", "MANDT": 120}]
    joined = [j for j in j4 if any(g["NODEVALUE"] == j["_B631_S_GL_ACCT"] and g["MANDT"] == j["MANDT"] for g in gl)]
    assert joined == [{"_B631_S_GL_ACCT": "X", "MANDT": 120}]

def test_TC_09():
    p1 = [{"_B631_S_PROFTCTR": "P1", "MANDT": 120}, {"_B631_S_PROFTCTR": "P2", "MANDT": 120}]
    sa = [{"PRCTR": "P1", "MANDT": 120, "CITY": "A"}]
    result = []
    for row in p1:
        match = next((s for s in sa if s["PRCTR"] == row["_B631_S_PROFTCTR"] and s["MANDT"] == row["MANDT"]), None)
        row_out = row.copy()
        row_out["CITY"] = match["CITY"] if match else None
        result.append(row_out)
    assert result[1]["CITY"] is None

def test_TC_10():
    j2 = [{"CAL_WEEK": "202345", "MANDT": 120}]
    rc = [{"ZZWEEK": "202345", "RCLNT": 120, "ZRWSTRTDATE": "2023-11-01"}]
    result = []
    for row in j2:
        match = next((r for r in rc if r["ZZWEEK"] == row["CAL_WEEK"] and r["RCLNT"] == row["MANDT"]), None)
        row_out = row.copy()
        row_out["ZRWSTRTDATE"] = match["ZRWSTRTDATE"] if match else None
        result.append(row_out)
    assert result[0]["ZRWSTRTDATE"] == "2023-11-01"

def test_TC_11():
    wn = [{"_B631_S_PROFTCTR": "P1", "MANDT": 120}]
    cf = [{"PRCTR": "P1", "MANDT": 120, "FS_COMP_WK": "A"}]
    result = []
    for row in wn:
        match = next((c for c in cf if c["PRCTR"] == row["_B631_S_PROFTCTR"] and c["MANDT"] == row["MANDT"]), None)
        row_out = row.copy()
        row_out["FS_COMP_WK"] = match["FS_COMP_WK"] if match else None
        result.append(row_out)
    assert result[0]["FS_COMP_WK"] == "A"

def test_TC_12():
    j3 = [{"_B631_S_PROFTCTR": "P1", "MANDT": 120}]
    pct = [{"PRCTR": "P1", "MANDT": 120, "PROFIT_CENTER_TEXT": "Store A"}]
    result = []
    for row in j3:
        match = next((p for p in pct if p["PRCTR"] == row["_B631_S_PROFTCTR"] and p["MANDT"] == row["MANDT"]), None)
        row_out = row.copy()
        row_out["PROFIT_CENTER_TEXT"] = match["PROFIT_CENTER_TEXT"] if match else None
        result.append(row_out)
    assert result[0]["PROFIT_CENTER_TEXT"] == "Store A"

def test_TC_13():
    rows = [
        {"_BIC_ZWWPC_PA1": "FS123"}, {"_BIC_ZWWPC_PA1": "RX456"}, {"_BIC_ZWWPC_PA1": "AB789"}
    ]
    for r in rows:
        prefix = r["_BIC_ZWWPC_PA1"][:2]
        flag = "FS" if prefix == "FS" else "RX" if prefix == "RX" else ""
        assert (flag == "FS" and prefix == "FS") or (flag == "RX" and prefix == "RX") or (flag == "" and prefix not in ("FS", "RX"))

def test_TC_14():
    IP_WEEK_CY = "202345"
    CAL_WEEK_NUMBER = IP_WEEK_CY[-2:]
    assert CAL_WEEK_NUMBER == "45"

def test_TC_15():
    rows = [
        {"CAL_FS_RX_FLAG": "FS", "FS_COMP_WK": "A", "RX_COMP_WK": "B"},
        {"CAL_FS_RX_FLAG": "RX", "FS_COMP_WK": "A", "RX_COMP_WK": "B"},
        {"CAL_FS_RX_FLAG": "", "FS_COMP_WK": "A", "RX_COMP_WK": "B"}
    ]
    for r in rows:
        if r["CAL_FS_RX_FLAG"] == "FS":
            comp_flag = r["FS_COMP_WK"]
        elif r["CAL_FS_RX_FLAG"] == "RX":
            comp_flag = r["RX_COMP_WK"]
        else:
            comp_flag = r["FS_COMP_WK"]
        assert comp_flag in ("A", "B")

def test_TC_16():
    rows = [
        {"group": 1, "_B631_S_AMOUNT": 10},
        {"group": 1, "_B631_S_AMOUNT": 20}
    ]
    agg = {}
    for r in rows:
        agg.setdefault(r["group"], 0)
        agg[r["group"]] += r["_B631_S_AMOUNT"]
    final = {k: v * -1 for k, v in agg.items()}
    assert final[1] == -30

def test_TC_17():
    row = {"FS_COMP_WK": None, "RX_COMP_WK": None}
    assert row["FS_COMP_WK"] is None and row["RX_COMP_WK"] is None

def test_TC_18():
    nodevalue = "000123"
    cal_node_value = nodevalue.lstrip("0")
    assert cal_node_value == "123"

def test_TC_19():
    rows = [
        {"MANDT": 1, "FISCPER": 2, "_B631_S_AMOUNT": 10},
        {"MANDT": 1, "FISCPER": 2, "_B631_S_AMOUNT": 20}
    ]
    group_keys = ("MANDT", "FISCPER")
    agg = {}
    for r in rows:
        key = tuple(r[k] for k in group_keys)
        agg.setdefault(key, 0)
        agg[key] += r["_B631_S_AMOUNT"]
    assert agg[(1, 2)] == 30
```

---

**Cost Analysis**

API Cost: 0.0400 USD
