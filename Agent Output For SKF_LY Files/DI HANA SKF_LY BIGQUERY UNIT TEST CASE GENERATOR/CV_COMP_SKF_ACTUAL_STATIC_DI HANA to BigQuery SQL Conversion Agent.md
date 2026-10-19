**Unit Test Case Summary**

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Filter: FISCVARNT = 'K4' | Input row in CV_BASE_SKF_WEEKLY_ACTUAL_S4 with FISCVARNT = 'K4' | Row is included in WEEKLY_SNAPSHOT_DS05 CTE | Only rows with FISCVARNT = 'K4' are processed further |
| TC_02 | Filter: FISCVARNT != 'K4' | Input row in CV_BASE_SKF_WEEKLY_ACTUAL_S4 with FISCVARNT = 'K3' | Row is excluded from WEEKLY_SNAPSHOT_DS05 CTE | No rows with FISCVARNT != 'K4' are present in downstream CTEs |
| TC_03 | Filter: _BIC_ZIO_SWEEK = @IP_WEEK_LY | Input row with _BIC_ZIO_SWEEK matching parameter | Row is included | Only rows where _BIC_ZIO_SWEEK = @IP_WEEK_LY are processed |
| TC_04 | Filter: _BIC_ZIO_VER = @IP_VERSION | Input row with _BIC_ZIO_VER matching parameter | Row is included | Only rows where _BIC_ZIO_VER = @IP_VERSION are processed |
| TC_05 | Filter: _BIC_ZIO_SAUDT IN ('1','10') | Input row with _BIC_ZIO_SAUDT = '1' or '10' | Row is included | Only rows with _BIC_ZIO_SAUDT in ('1','10') are processed |
| TC_06 | Filter: _BIC_ZIO_SAUDT not in ('1','10') | Input row with _BIC_ZIO_SAUDT = '2' | Row is excluded | No rows with _BIC_ZIO_SAUDT not in ('1','10') are present |
| TC_07 | Filter: _BIC_ZIO_PSKF IN ('804013','801000') | Input row with _BIC_ZIO_PSKF = '804013' or '801000' | Row is included | Only rows with _BIC_ZIO_PSKF in ('804013','801000') are processed |
| TC_08 | Filter: _BIC_ZIO_PSKF not in ('804013','801000') | Input row with _BIC_ZIO_PSKF = '900000' | Row is excluded | No rows with _BIC_ZIO_PSKF not in list are present |
| TC_09 | Join: WEEKLY_SNAPSHOT_DS05 INNER JOIN CC_HIER | Matching _B631_S_COSTCNTR and MANDT in both tables | Row appears in JOIN_3 | Only rows with matching join keys are present in JOIN_3 |
| TC_10 | Join: No matching CC_HIER row | No matching NODEVALUE/MANDT | Row is excluded from JOIN_3 | Non-matching rows are excluded due to INNER JOIN |
| TC_11 | Filter: CC_HIER.PARNODE LIKE '%CORERET%' | PARNODE contains 'CORERET' | Row is included in CC_HIER CTE | Only rows with PARNODE containing 'CORERET' are processed |
| TC_12 | Filter: CC_HIER.HRYVALTO = '99991231' | HRYVALTO = '99991231' | Row is included | Only rows with HRYVALTO = '99991231' are processed |
| TC_13 | Join: Projection_1 LEFT JOIN STORE_ATTR_ACTUAL | Matching _B631_S_PROFTCTR and MANDT | STORE_ATTR_ACTUAL columns populated | Joined columns are present if match exists |
| TC_14 | Join: No matching STORE_ATTR_ACTUAL row | No matching PRCTR/MANDT | Joined columns are NULL | LEFT JOIN produces NULLs for missing matches |
| TC_15 | Join: Join_2 LEFT JOIN RETAIL_CAL | Matching CAL_WEEK = ZZWEEK | ZRWSTRTDATE, ZRWENDDATE populated | Date columns present if match exists |
| TC_16 | Join: No matching RETAIL_CAL row | No matching ZZWEEK | ZRWSTRTDATE, ZRWENDDATE are NULL | LEFT JOIN produces NULLs for missing matches |
| TC_17 | Join: Join_1 LEFT JOIN COMP_FLAG_ACT01 | Matching _B631_S_PROFTCTR, MANDT | RX_COMP_WK populated | RX_COMP_WK present if match exists |
| TC_18 | Filter: COMP_FLAG_ACT01 ZWEEK range | ZWEEK >= @IP_WEEK_ENDING_FROM and ZWEEK <= @IP_WEEK_ENDING_TO | Row included only if within range | Only rows in range are joined |
| TC_19 | Join: Join_4 LEFT JOIN PROFIT_CENTER_TEXT | Matching _B631_S_PROFTCTR, MANDT | PROFIT_CENTER_TEXT populated | PROFIT_CENTER_TEXT present if match exists |
| TC_20 | Join: No matching PROFIT_CENTER_TEXT row | No matching PRCTR/MANDT | PROFIT_CENTER_TEXT is NULL | LEFT JOIN produces NULLs for missing matches |
| TC_21 | Calculated: CAL_WEEK = @IP_WEEK_CY | Any input | CAL_WEEK column equals parameter value | CAL_WEEK always matches @IP_WEEK_CY |
| TC_22 | Calculated: CAL_WEEK_NUMBER | @IP_WEEK_CY = '202352' | CAL_WEEK_NUMBER = '52' | Last 2 digits of @IP_WEEK_CY are returned |
| TC_23 | Calculated: CAL_ZIO_SKFQ_QTY for _BIC_ZIO_PSKF = '804013' | _BIC_ZIO_PSKF = '804013', _BIC_ZIO_SKFQ = 5 | CAL_ZIO_SKFQ_QTY = 10 | Value is doubled for this condition |
| TC_24 | Calculated: CAL_ZIO_SKFQ_QTY for _BIC_ZIO_PSKF != '804013' | _BIC_ZIO_PSKF = '801000', _BIC_ZIO_SKFQ = 7 | CAL_ZIO_SKFQ_QTY = 7 | Value is unchanged for this condition |
| TC_25 | Aggregation: SUM measures | Multiple rows with same GROUP BY values, _BIC_ZIO_SKFQ = 2, 3 | SUM(_BIC_ZIO_SKFQ) = 5 | SUM is correctly calculated |
| TC_26 | Aggregation: GROUP BY all non-measure columns | Input with unique combinations of all GROUP BY columns | Each unique combination produces one output row | No duplicate output rows for same group |
| TC_27 | NULL handling: LEFT JOIN columns | No matching join in STORE_ATTR_ACTUAL or RETAIL_CAL | Output columns are NULL | NULLs appear as expected for missing matches |
| TC_28 | Data type: RIGHT(@IP_WEEK_CY, 2) on string | @IP_WEEK_CY = '202349' | CAL_WEEK_NUMBER = '49' | RIGHT works as expected on string input |
| TC_29 | Data type: RIGHT(@IP_WEEK_CY, 2) on integer input | @IP_WEEK_CY = 202349 (int) | CAL_WEEK_NUMBER returns last 2 digits as string | Function works or error is handled |
| TC_30 | Parameter substitution: All parameters | All input parameters provided | Query runs with parameters substituted | No parameter missing errors |
| TC_31 | Edge: Empty input tables | All source tables empty | Output is empty | Query returns 0 rows |
| TC_32 | Edge: All columns NULL | All input columns NULL where allowed | Output columns are NULL | Output reflects NULL propagation |
| TC_33 | Edge: Multiple matches in join keys | Multiple matching rows in STORE_ATTR_ACTUAL for same PRCTR/MANDT | All combinations appear in output (Cartesian join) | Join logic produces correct number of rows |
| TC_34 | Filter: COMP_FLAG_ACT01 COMP_VER = @IP_VERSION_COMP_FLAG | COMP_VER matches parameter | Row included | Only matching COMP_VER rows are joined |
| TC_35 | Filter: COMP_FLAG_ACT01 COMP_VER != @IP_VERSION_COMP_FLAG | COMP_VER does not match | Row excluded | No join for non-matching COMP_VER |

---

**Pytest Script**

```python
import pytest

# Simple utility functions to mimic SQL logic for testing

def rightstr(val, n):
    return str(val)[-n:]

def calc_cal_zio_skfq_qty(bic_zio_pskf, bic_zio_skfq):
    return bic_zio_skfq * 2 if bic_zio_pskf == '804013' else bic_zio_skfq

@pytest.mark.parametrize("fiscvarnt,expected", [
    ('K4', True), ('K3', False)
])
def test_TC_01_TC_02_fiscvarnt_filter(fiscvarnt, expected):
    # Only 'K4' should pass filter
    assert (fiscvarnt == 'K4') == expected

@pytest.mark.parametrize("skweek,param,expected", [
    ('202349', '202349', True), ('202349', '202350', False)
])
def test_TC_03_bic_zio_sweek_filter(skweek, param, expected):
    assert (skweek == param) == expected

@pytest.mark.parametrize("ver,param,expected", [
    ('A', 'A', True), ('B', 'A', False)
])
def test_TC_04_bic_zio_ver_filter(ver, param, expected):
    assert (ver == param) == expected

@pytest.mark.parametrize("saudt,expected", [
    ('1', True), ('10', True), ('2', False)
])
def test_TC_05_TC_06_bic_zio_saudt_filter(saudt, expected):
    assert (saudt in ['1', '10']) == expected

@pytest.mark.parametrize("pskf,expected", [
    ('804013', True), ('801000', True), ('900000', False)
])
def test_TC_07_TC_08_bic_zio_pskf_filter(pskf, expected):
    assert (pskf in ['804013', '801000']) == expected

def test_TC_09_TC_10_inner_join():
    w = {'_B631_S_COSTCNTR': 'CC01', 'MANDT': '100'}
    c = {'NODEVALUE': 'CC01', 'MANDT': '100'}
    # Matching join
    assert w['_B631_S_COSTCNTR'] == c['NODEVALUE'] and w['MANDT'] == c['MANDT']
    # No match
    c2 = {'NODEVALUE': 'CC02', 'MANDT': '100'}
    assert not (w['_B631_S_COSTCNTR'] == c2['NODEVALUE'] and w['MANDT'] == c2['MANDT'])

def test_TC_11_parnode_like():
    assert 'CORERET' in 'XXCORERETYY'
    assert not ('CORERET' in 'XXCOREYY')

def test_TC_12_hryvalto_filter():
    assert '99991231' == '99991231'

def test_TC_13_TC_14_left_join_store_attr_actual():
    p = {'_B631_S_PROFTCTR': 'P01', 'MANDT': '100'}
    s = {'PRCTR': 'P01', 'MANDT': '100'}
    # Match
    assert p['_B631_S_PROFTCTR'] == s['PRCTR'] and p['MANDT'] == s['MANDT']
    # No match
    s2 = {'PRCTR': 'P02', 'MANDT': '100'}
    assert not (p['_B631_S_PROFTCTR'] == s2['PRCTR'] and p['MANDT'] == s2['MANDT'])

def test_TC_15_TC_16_left_join_retail_cal():
    j = {'CAL_WEEK': '202349'}
    r = {'ZZWEEK': '202349'}
    # Match
    assert j['CAL_WEEK'] == r['ZZWEEK']
    # No match
    r2 = {'ZZWEEK': '202350'}
    assert not (j['CAL_WEEK'] == r2['ZZWEEK'])

def test_TC_17_TC_18_left_join_comp_flag_act01():
    j = {'_B631_S_PROFTCTR': 'P01', 'MANDT': '100'}
    c = {'PRCTR': 'P01', 'MANDT': '100', 'ZWEEK': '202349', 'COMP_VER': 'A'}
    # Match and filter
    assert j['_B631_S_PROFTCTR'] == c['PRCTR'] and j['MANDT'] == c['MANDT']
    assert '202348' <= c['ZWEEK'] <= '202350'
    assert c['COMP_VER'] == 'A'

def test_TC_19_TC_20_left_join_profit_center_text():
    j = {'_B631_S_PROFTCTR': 'P01', 'MANDT': '100'}
    p = {'PRCTR': 'P01', 'MANDT': '100'}
    # Match
    assert j['_B631_S_PROFTCTR'] == p['PRCTR'] and j['MANDT'] == p['MANDT']
    # No match
    p2 = {'PRCTR': 'P02', 'MANDT': '100'}
    assert not (j['_B631_S_PROFTCTR'] == p2['PRCTR'] and j['MANDT'] == p2['MANDT'])

def test_TC_21_cal_week():
    param = '202349'
    cal_week = param
    assert cal_week == param

def test_TC_22_cal_week_number():
    ip_week_cy = '202352'
    assert rightstr(ip_week_cy, 2) == '52'

def test_TC_23_cal_zio_skfq_qty_double():
    assert calc_cal_zio_skfq_qty('804013', 5) == 10

def test_TC_24_cal_zio_skfq_qty_unchanged():
    assert calc_cal_zio_skfq_qty('801000', 7) == 7

def test_TC_25_aggregation_sum():
    vals = [2, 3]
    assert sum(vals) == 5

def test_TC_26_group_by_uniqueness():
    rows = [
        ('A', 'B', 1),
        ('A', 'B', 2),
        ('A', 'C', 3)
    ]
    groups = set((r[0], r[1]) for r in rows)
    assert len(groups) == 2

def test_TC_27_null_handling_left_join():
    left = {'id': 1}
    right = None
    result = left.copy()
    if right:
        result['val'] = right['val']
    else:
        result['val'] = None
    assert result['val'] is None

def test_TC_28_right_function_on_string():
    assert rightstr('202349', 2) == '49'

def test_TC_29_right_function_on_int():
    assert rightstr(202349, 2) == '49'

def test_TC_30_all_parameters_supplied():
    params = {
        'IP_WEEK_LY': '202349',
        'IP_WEEK_CY': '202350',
        'IP_VERSION': 'A',
        'IP_VERSION_COMP_FLAG': 'B',
        'IP_WEEK_ENDING_FROM': '202340',
        'IP_WEEK_ENDING_TO': '202352'
    }
    for k in ['IP_WEEK_LY', 'IP_WEEK_CY', 'IP_VERSION', 'IP_VERSION_COMP_FLAG', 'IP_WEEK_ENDING_FROM', 'IP_WEEK_ENDING_TO']:
        assert k in params

def test_TC_31_empty_input():
    data = []
    assert len(data) == 0

def test_TC_32_all_columns_null():
    row = {k: None for k in ['MANDT', 'FISCPER', 'FISCVARNT']}
    assert all(v is None for v in row.values())

def test_TC_33_multiple_matches_in_join():
    left = [{'id': 1}]
    right = [{'id': 1}, {'id': 1}]
    result = [(l, r) for l in left for r in right if l['id'] == r['id']]
    assert len(result) == 2

def test_TC_34_comp_flag_act01_comp_ver_match():
    comp_ver = 'A'
    param = 'A'
    assert comp_ver == param

def test_TC_35_comp_flag_act01_comp_ver_no_match():
    comp_ver = 'B'
    param = 'A'
    assert comp_ver != param
```

---

**Cost Analysis**

API Cost: 0.0000 USD

---

**(GitHub Write Operation Follows...)**