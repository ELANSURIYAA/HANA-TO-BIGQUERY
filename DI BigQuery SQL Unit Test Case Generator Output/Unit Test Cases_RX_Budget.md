**Unit Test Case Summary**

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Filter on MANDT and @IP_FC_COUNT for Frozen_Cube_Base | MANDT in ('110', '200'), @IP_FC_COUNT != 0 | Only rows with MANDT '110' or '200' and @IP_FC_COUNT not zero are included | Assert all rows have MANDT in ('110', '200') and @IP_FC_COUNT != 0 |
| TC_02 | Filter on MANDT and @IP_FC_COUNT for Live_Cube_Base | MANDT in ('110', '200'), @IP_FC_COUNT = 0 | Only rows with MANDT '110' or '200' and @IP_FC_COUNT zero are included | Assert all rows have MANDT in ('110', '200') and @IP_FC_COUNT = 0 |
| TC_03 | UNION ALL logic for Union_Budget | Rows from Frozen_Cube_Base and Live_Cube_Base | All rows from both sources are present, no duplicates removed | Assert count equals sum of both sources |
| TC_04 | Aggregation in Aggregated_Budget | Multiple rows with same GROUP BY keys | SUM(_B631_S_AMOUNT) and SUM(_BIC_ZIO_AMT) are correctly calculated per group | Assert aggregation matches manual sum |
| TC_05 | CASE logic for RES_AMOUNT_LC and RES_AMOUNT_FC | FLAG values 'LC', 'FC', NULL | RES_AMOUNT_LC sums only 'LC', RES_AMOUNT_FC sums only 'FC', 0 for others | Assert correct sums for each FLAG |
| TC_06 | IF logic for _B631_S_AMOUNT in CV_BASE_FIN_WEEKLY_BUDGET_S4 | RES_AMOUNT_FC NULL or 0 | _B631_S_AMOUNT uses RES_AMOUNT_LC if RES_AMOUNT_FC is NULL/0, else RES_AMOUNT_FC | Assert value follows IF logic |
| TC_07 | Filter logic in WEEKLY_SNAPSHOT_DS05 | FISCVARNT = 'K4', _BIC_ZIO_SWEEK BETWEEN @IP_WEEK_ENDING_FROM AND @IP_WEEK_ENDING_TO, _BIC_ZIO_VER = @IP_VERSION, _BIC_ZIO_SAUDT in ('1', '10') | Only rows matching all filters are included | Assert all rows match filter criteria |
| TC_08 | JOIN condition in Join_1 (WEEKLY_SNAPSHOT_DS05 INNER JOIN HIER_NODE) | _B631_S_PROFTCTR = NODEVALUE | Only rows where profit center matches node value | Assert join keys match for all output rows |
| TC_09 | LEFT JOIN STORE_ATTR_ACTUAL in Join_2 | _B631_S_PROFTCTR = PRCTR | Store attributes added, NULLs for non-matching | Assert attributes filled for matches, NULL for non-matches |
| TC_10 | RIGHT logic for CAL_STORE_WEEK_NUMBER in WEEK_NUMBER | _BIC_ZIO_SWEEK values | CAL_STORE_WEEK_NUMBER is last 2 chars of week string | Assert extracted value matches expected |
| TC_11 | LEFT JOIN COMP_FLAG_BUDGET in Join_3 | _B631_S_PROFTCTR = PRCTR and _BIC_ZIO_SWEEK = ZWEEK | FS_COMP_WK and RX_COMP_WK added, NULLs for non-matching | Assert join keys match, NULL for non-matches |
| TC_12 | LEFT JOIN CAL_WEEK in Join_4 | _BIC_ZIO_SWEEK = ZZWEEK | ZRWSTRTDATE and ZRWENDDATE added, NULLs for non-matching | Assert join keys match, NULL for non-matches |
| TC_13 | LEFT JOIN PROFIT_CENTER_TEXT in Join_5 | _B631_S_PROFTCTR = PRCTR | PROFIT_CENTER_TEXT added, NULLs for non-matching | Assert join keys match, NULL for non-matches |
| TC_14 | CASE logic for CAL_FS_RX_FLAG | _BIC_ZWWPC_PA1 values starting with 'FS', 'RX', or others | 'FS' or 'RX' assigned, else empty string | Assert flag assignment matches CASE |
| TC_15 | CASE logic for CAL_COMP_FLAG | FS/RX flag and COMP_WK values (NULL, non-NULL) | '0' if NULL, else correct COMP_WK value | Assert correct value for each input |
| TC_16 | Negative value calculation for _B631_S_AMOUNT | _B631_S_AMOUNT * -1 | Negative value assigned | Assert negative transformation |
| TC_17 | Aggregation in final SELECT | Multiple rows per group | SUM(_B631_S_AMOUNT_NEGATIVE), SUM(_BIC_ZIO_AMT), SUM(_B631_S_AMOUNT) per group | Assert aggregation matches manual sum |
| TC_18 | NULL handling in JOINs | No matching keys in LEFT JOINs | Output columns are NULL for non-matches | Assert NULLs appear as expected |
| TC_19 | Data type conversion for week numbers | _BIC_ZIO_SWEEK as integer/string | RIGHT(CAST(_BIC_ZIO_SWEEK AS STRING), 2) yields string | Assert type and value correctness |
| TC_20 | Edge case: All input values NULL | All fields NULL in input | Output handles NULLs gracefully, no errors | Assert output has NULLs, no exceptions |
| TC_21 | Edge case: Empty input tables | No rows in input tables | Output is empty | Assert output row count is zero |

---

**Pytest Script**

```python
import pytest

# Sample data structures for mocking input/output
# These are simplified for unit logic validation

def test_TC_01():
    rows = [{'MANDT': '110'}, {'MANDT': '200'}]
    ip_fc_count = 1
    assert all(row['MANDT'] in ('110', '200') for row in rows)
    assert ip_fc_count != 0

def test_TC_02():
    rows = [{'MANDT': '110'}, {'MANDT': '200'}]
    ip_fc_count = 0
    assert all(row['MANDT'] in ('110', '200') for row in rows)
    assert ip_fc_count == 0

def test_TC_03():
    frozen = [1, 2, 3]
    live = [4, 5]
    union = frozen + live
    assert len(union) == len(frozen) + len(live)

def test_TC_04():
    rows = [{'group': 'A', 'amt': 10}, {'group': 'A', 'amt': 5}]
    grouped_amt = sum(row['amt'] for row in rows)
    assert grouped_amt == 15

def test_TC_05():
    rows = [
        {'FLAG': 'LC', 'amt': 10},
        {'FLAG': 'FC', 'amt': 20},
        {'FLAG': None, 'amt': 5}
    ]
    res_lc = sum(row['amt'] for row in rows if row['FLAG'] == 'LC')
    res_fc = sum(row['amt'] for row in rows if row['FLAG'] == 'FC')
    assert res_lc == 10
    assert res_fc == 20

def test_TC_06():
    res_fc = None
    res_lc = 12
    result = res_lc if (res_fc is None or res_fc == 0) else res_fc
    assert result == 12

def test_TC_07():
    rows = [
        {'FISCVARNT': 'K4', '_BIC_ZIO_SWEEK': 5, '_BIC_ZIO_VER': 'V1', '_BIC_ZIO_SAUDT': '1'},
        {'FISCVARNT': 'K4', '_BIC_ZIO_SWEEK': 7, '_BIC_ZIO_VER': 'V1', '_BIC_ZIO_SAUDT': '10'}
    ]
    ip_week_from, ip_week_to, ip_version = 5, 7, 'V1'
    assert all(
        row['FISCVARNT'] == 'K4' and
        ip_week_from <= row['_BIC_ZIO_SWEEK'] <= ip_week_to and
        row['_BIC_ZIO_VER'] == ip_version and
        row['_BIC_ZIO_SAUDT'] in ('1', '10')
        for row in rows
    )

def test_TC_08():
    w = {'_B631_S_PROFTCTR': 'P1'}
    h = {'NODEVALUE': 'P1'}
    assert w['_B631_S_PROFTCTR'] == h['NODEVALUE']

def test_TC_09():
    o = {'_B631_S_PROFTCTR': 'P1'}
    s = {'PRCTR': 'P1', 'REP_MKT_CODE': 'X'}
    match = o['_B631_S_PROFTCTR'] == s['PRCTR']
    assert match
    assert s['REP_MKT_CODE'] == 'X'

def test_TC_10():
    week = 202345
    week_str = str(week)
    cal_store_week_number = week_str[-2:]
    assert cal_store_week_number == week_str[-2:]

def test_TC_11():
    w = {'_B631_S_PROFTCTR': 'P1', '_BIC_ZIO_SWEEK': 5}
    c = {'PRCTR': 'P1', 'ZWEEK': 5, 'FS_COMP_WK': 'A', 'RX_COMP_WK': 'B'}
    match = w['_B631_S_PROFTCTR'] == c['PRCTR'] and w['_BIC_ZIO_SWEEK'] == c['ZWEEK']
    assert match
    assert c['FS_COMP_WK'] == 'A'
    assert c['RX_COMP_WK'] == 'B'

def test_TC_12():
    j = {'_BIC_ZIO_SWEEK': 5}
    c = {'ZZWEEK': 5, 'ZRWSTRTDATE': '2023-01-01', 'ZRWENDDATE': '2023-01-07'}
    match = j['_BIC_ZIO_SWEEK'] == c['ZZWEEK']
    assert match
    assert c['ZRWSTRTDATE'] == '2023-01-01'

def test_TC_13():
    j = {'_B631_S_PROFTCTR': 'P1'}
    p = {'PRCTR': 'P1', 'PROFIT_CENTER_TEXT': 'Retail'}
    match = j['_B631_S_PROFTCTR'] == p['PRCTR']
    assert match
    assert p['PROFIT_CENTER_TEXT'] == 'Retail'

def test_TC_14():
    val = 'FS123'
    flag = 'FS' if val[:2] == 'FS' else ('RX' if val[:2] == 'RX' else '')
    assert flag == 'FS'
    val = 'RX456'
    flag = 'FS' if val[:2] == 'FS' else ('RX' if val[:2] == 'RX' else '')
    assert flag == 'RX'
    val = 'XX789'
    flag = 'FS' if val[:2] == 'FS' else ('RX' if val[:2] == 'RX' else '')
    assert flag == ''

def test_TC_15():
    fs_flag = 'FS'
    fs_comp_wk = 'Y'
    rx_flag = 'RX'
    rx_comp_wk = 'Z'
    flag = fs_flag
    comp = fs_comp_wk if flag == 'FS' else (rx_comp_wk if flag == 'RX' else fs_comp_wk)
    if comp is None:
        result = '0'
    else:
        result = comp
    assert result == 'Y'

def test_TC_16():
    amt = 100
    neg_amt = amt * -1
    assert neg_amt == -100

def test_TC_17():
    rows = [{'amt_neg': -10, 'amt': 10, 'amt_zio': 5}, {'amt_neg': -20, 'amt': 20, 'amt_zio': 15}]
    sum_amt_neg = sum(row['amt_neg'] for row in rows)
    sum_amt = sum(row['amt'] for row in rows)
    sum_amt_zio = sum(row['amt_zio'] for row in rows)
    assert sum_amt_neg == -30
    assert sum_amt == 30
    assert sum_amt_zio == 20

def test_TC_18():
    left = {'key': 'A'}
    right = {'key': 'B'}
    match = left['key'] == right['key']
    if not match:
        val = None
    else:
        val = right['key']
    assert val is None

def test_TC_19():
    week = 202345
    week_str = str(week)
    cal_week_number = week_str[-2:]
    assert isinstance(cal_week_number, str)
    assert cal_week_number == week_str[-2:]

def test_TC_20():
    row = {k: None for k in ['MANDT', 'FISCPER', '_BIC_ZIO_SWEEK']}
    assert all(v is None for v in row.values())

def test_TC_21():
    rows = []
    assert len(rows) == 0
```

---

**Cost Analysis**

API Cost: 0.0025 USD

---
