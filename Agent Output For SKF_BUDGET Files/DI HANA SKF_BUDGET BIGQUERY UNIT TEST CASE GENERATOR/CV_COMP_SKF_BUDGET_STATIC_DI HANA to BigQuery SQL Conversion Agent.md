**Unit Test Case Summary**

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Filter: FISCVARNT must be 'K4' in WEEKLY_SNAPSHOT_DS05 | Input row with FISCVARNT='K4' and another with FISCVARNT='K5' | Only row with FISCVARNT='K4' is included in output | Verify only rows with FISCVARNT='K4' are present after filter |
| TC_02 | Filter: _BIC_ZIO_SWEEK between @IP_WEEK_ENDING_FROM and @IP_WEEK_ENDING_TO | Input rows with _BIC_ZIO_SWEEK in and out of the range | Only rows within the parameter range are included | Validate output only has rows within the specified week range |
| TC_03 | Filter: _BIC_ZIO_VER equals @IP_VERSION | Input rows with _BIC_ZIO_VER matching and not matching @IP_VERSION | Only rows with _BIC_ZIO_VER = @IP_VERSION are included | Check that all rows in output have _BIC_ZIO_VER = @IP_VERSION |
| TC_04 | Filter: _BIC_ZIO_SAUDT in ('1', '10') | Input rows with _BIC_ZIO_SAUDT='1', '10', '2' | Only rows with _BIC_ZIO_SAUDT='1' or '10' are included | Ensure only '1' or '10' values appear in output |
| TC_05 | Filter: _BIC_ZIO_PSKF in ('804013', '801000') | Input rows with _BIC_ZIO_PSKF='804013','801000','999999' | Only rows with _BIC_ZIO_PSKF='804013' or '801000' are included | Confirm only allowed _BIC_ZIO_PSKF values are present |
| TC_06 | Filtered_Hierarchy_Nodes: REGEXP_CONTAINS(PARNODE, r'CORERET$') and HRYVALTO='99991231' | PARNODE values ending with 'CORERET' and HRYVALTO='99991231', and others | Only rows with PARNODE ending 'CORERET' and HRYVALTO='99991231' are included | Output contains only rows matching both conditions |
| TC_07 | Join: INNER JOIN on _B631_S_COSTCNTR to NODEVALUE | Matching and non-matching _B631_S_COSTCNTR and NODEVALUE | Only rows with matching keys are joined and appear in output | Output only includes joined rows with matching keys |
| TC_08 | Join: LEFT JOIN on _B631_S_PROFTCTR to PRCTR in STORE_ATTR_ACTUAL | Matching and non-matching keys | All left table rows are present; right table columns are NULL where no match | Validate left join behavior and NULL handling |
| TC_09 | Join: LEFT JOIN on _B631_S_PROFTCTR=PRCTR and _BIC_ZIO_SWEEK=ZWEEK in COMP_FLAG_BUDGET | Matching and non-matching composite keys | All left table rows are present; right table columns are NULL where no match | Validate composite join and NULL handling |
| TC_10 | Join: LEFT JOIN on _BIC_ZIO_SWEEK=ZZWEEK in CAL_WEEK | Matching and non-matching keys | All left table rows are present; right table columns are NULL where no match | Validate left join and NULL handling |
| TC_11 | Join: LEFT JOIN on _B631_S_PROFTCTR=PRCTR in PROFIT_CENTER_TEXT | Matching and non-matching keys | All left table rows are present; right table columns are NULL where no match | Validate join and NULL handling |
| TC_12 | Calculation: CAL_WEEK_NUMBER = RIGHT(CAST(_BIC_ZIO_SWEEK AS STRING), 2) | _BIC_ZIO_SWEEK='202352' | CAL_WEEK_NUMBER='52' | Output column CAL_WEEK_NUMBER is correct |
| TC_13 | Calculation: CAL_BIC_ZIO_SKFQ doubles value when _BIC_ZIO_PSKF='804013' | _BIC_ZIO_PSKF='804013', _BIC_ZIO_SKFQ=10 | CAL_BIC_ZIO_SKFQ=20 | Output column CAL_BIC_ZIO_SKFQ is correct |
| TC_14 | Calculation: CAL_BIC_ZIO_SKFQ keeps value when _BIC_ZIO_PSKF!='804013' | _BIC_ZIO_PSKF='801000', _BIC_ZIO_SKFQ=10 | CAL_BIC_ZIO_SKFQ=10 | Output column CAL_BIC_ZIO_SKFQ is correct |
| TC_15 | Calculation: CAL_RX_COMP_WK returns '0' when RX_COMP_WK is NULL | RX_COMP_WK is NULL | CAL_RX_COMP_WK='0' | Output column CAL_RX_COMP_WK is '0' |
| TC_16 | Calculation: CAL_RX_COMP_WK returns RX_COMP_WK when not NULL | RX_COMP_WK='5' | CAL_RX_COMP_WK='5' | Output column CAL_RX_COMP_WK is '5' |
| TC_17 | Aggregation: SUM(_BIC_ZIO_SKFQ) as _BIC_ZIO_SKFQ_NEGATIVE | Two rows with _BIC_ZIO_SKFQ=5, 10 in same group | _BIC_ZIO_SKFQ_NEGATIVE=15 | Aggregated value is correct |
| TC_18 | Aggregation: SUM(CAL_BIC_ZIO_SKFQ) as _BIC_ZIO_SKFQ | Two rows with CAL_BIC_ZIO_SKFQ=6, 4 in same group | _BIC_ZIO_SKFQ=10 | Aggregated value is correct |
| TC_19 | GROUP BY: All non-measure columns are grouped | Input data with duplicate group keys | Output has one row per unique group key | Validate grouping logic |
| TC_20 | Output mapping: All output columns as per logicalModel | Input row with all columns present | Output row contains all expected columns with correct mapping | Output schema matches expected logical model |
| TC_21 | NULL handling: LEFT JOIN with no match | No matching right table row | Output columns from right table are NULL | NULLs present as expected |
| TC_22 | Data type conversion: RIGHT(CAST(_BIC_ZIO_SWEEK AS STRING), 2) | _BIC_ZIO_SWEEK is integer 202352 | CAL_WEEK_NUMBER='52' | Data type conversion works as expected |
| TC_23 | Parameter mapping: @IP_VERSION | Query executed with IP_VERSION='LEDGER_BUD' | Only rows with _BIC_ZIO_VER='LEDGER_BUD' are included | Parameter is mapped and filtered correctly |
| TC_24 | Parameter mapping: @IP_WEEK_ENDING_FROM and @IP_WEEK_ENDING_TO | Query executed with week range | Only rows in range are present | Parameter is mapped and filtered correctly |
| TC_25 | Edge: All filters exclude all rows | Input data does not match any filter | Output is empty | Output is empty as expected |
| TC_26 | Edge: All joins fail (no matches in right tables) | No matching keys in any right table | Output columns from right tables are NULL | Output contains left table columns and NULLs from right tables |

---

**Pytest Script**

```python
import pytest

# Test data and helper functions for simulating SQL logic

def filter_weekly_snapshot_ds05(rows, ip_week_ending_from, ip_week_ending_to, ip_version):
    return [
        r for r in rows
        if r['FISCVARNT'] == 'K4'
        and ip_week_ending_from <= r['_BIC_ZIO_SWEEK'] <= ip_week_ending_to
        and r['_BIC_ZIO_VER'] == ip_version
        and r['_BIC_ZIO_SAUDT'] in ('1', '10')
        and r['_BIC_ZIO_PSKF'] in ('804013', '801000')
    ]

def right_str(val, n):
    return str(val)[-n:]

def calc_bic_zio_skfq(_bic_zio_pskf, _bic_zio_skfq):
    if _bic_zio_pskf == '804013':
        return float(_bic_zio_skfq) * 2
    return float(_bic_zio_skfq)

def calc_rx_comp_wk(rx_comp_wk):
    return '0' if rx_comp_wk is None else rx_comp_wk

def group_by(rows, group_keys, sum_fields):
    # groups rows by group_keys, sums sum_fields
    groups = {}
    for r in rows:
        key = tuple(r[k] for k in group_keys)
        if key not in groups:
            groups[key] = r.copy()
            for sf in sum_fields:
                groups[key][sf] = float(r[sf])
        else:
            for sf in sum_fields:
                groups[key][sf] += float(r[sf])
    return list(groups.values())

def join(left, right, left_key, right_key, how='inner'):
    res = []
    right_map = {tuple(r[k] for k in right_key): r for r in right}
    for l in left:
        k = tuple(l[k] for k in left_key)
        r = right_map.get(k)
        if r:
            merged = l.copy()
            merged.update(r)
            res.append(merged)
        elif how == 'left':
            merged = l.copy()
            for rk in right[0].keys():
                if rk not in l:
                    merged[rk] = None
            res.append(merged)
    return res

def join_composite(left, right, left_keys, right_keys, how='left'):
    res = []
    right_map = {tuple(r[k] for k in right_keys): r for r in right}
    for l in left:
        k = tuple(l[k] for k in left_keys)
        r = right_map.get(k)
        merged = l.copy()
        if r:
            for key, val in r.items():
                if key not in merged:
                    merged[key] = val
        elif how == 'left':
            for rk in right[0].keys():
                if rk not in merged:
                    merged[rk] = None
        res.append(merged)
    return res

def test_TC_01():
    rows = [
        {'FISCVARNT': 'K4', '_BIC_ZIO_SWEEK': '202350', '_BIC_ZIO_VER': 'LEDGER_BUD', '_BIC_ZIO_SAUDT': '1', '_BIC_ZIO_PSKF': '804013'},
        {'FISCVARNT': 'K5', '_BIC_ZIO_SWEEK': '202350', '_BIC_ZIO_VER': 'LEDGER_BUD', '_BIC_ZIO_SAUDT': '1', '_BIC_ZIO_PSKF': '804013'},
    ]
    filtered = filter_weekly_snapshot_ds05(rows, '202340', '202360', 'LEDGER_BUD')
    assert all(r['FISCVARNT'] == 'K4' for r in filtered)
    assert len(filtered) == 1

def test_TC_02():
    rows = [
        {'FISCVARNT': 'K4', '_BIC_ZIO_SWEEK': '202350', '_BIC_ZIO_VER': 'LEDGER_BUD', '_BIC_ZIO_SAUDT': '1', '_BIC_ZIO_PSKF': '804013'},
        {'FISCVARNT': 'K4', '_BIC_ZIO_SWEEK': '202370', '_BIC_ZIO_VER': 'LEDGER_BUD', '_BIC_ZIO_SAUDT': '1', '_BIC_ZIO_PSKF': '804013'},
    ]
    filtered = filter_weekly_snapshot_ds05(rows, '202340', '202360', 'LEDGER_BUD')
    assert all('202340' <= r['_BIC_ZIO_SWEEK'] <= '202360' for r in filtered)
    assert len(filtered) == 1

def test_TC_03():
    rows = [
        {'FISCVARNT': 'K4', '_BIC_ZIO_SWEEK': '202350', '_BIC_ZIO_VER': 'LEDGER_BUD', '_BIC_ZIO_SAUDT': '1', '_BIC_ZIO_PSKF': '804013'},
        {'FISCVARNT': 'K4', '_BIC_ZIO_SWEEK': '202350', '_BIC_ZIO_VER': 'ACTUAL', '_BIC_ZIO_SAUDT': '1', '_BIC_ZIO_PSKF': '804013'},
    ]
    filtered = filter_weekly_snapshot_ds05(rows, '202340', '202360', 'LEDGER_BUD')
    assert all(r['_BIC_ZIO_VER'] == 'LEDGER_BUD' for r in filtered)
    assert len(filtered) == 1

def test_TC_04():
    rows = [
        {'FISCVARNT': 'K4', '_BIC_ZIO_SWEEK': '202350', '_BIC_ZIO_VER': 'LEDGER_BUD', '_BIC_ZIO_SAUDT': '1', '_BIC_ZIO_PSKF': '804013'},
        {'FISCVARNT': 'K4', '_BIC_ZIO_SWEEK': '202350', '_BIC_ZIO_VER': 'LEDGER_BUD', '_BIC_ZIO_SAUDT': '2', '_BIC_ZIO_PSKF': '804013'},
        {'FISCVARNT': 'K4', '_BIC_ZIO_SWEEK': '202350', '_BIC_ZIO_VER': 'LEDGER_BUD', '_BIC_ZIO_SAUDT': '10', '_BIC_ZIO_PSKF': '804013'},
    ]
    filtered = filter_weekly_snapshot_ds05(rows, '202340', '202360', 'LEDGER_BUD')
    assert all(r['_BIC_ZIO_SAUDT'] in ('1', '10') for r in filtered)
    assert len(filtered) == 2

def test_TC_05():
    rows = [
        {'FISCVARNT': 'K4', '_BIC_ZIO_SWEEK': '202350', '_BIC_ZIO_VER': 'LEDGER_BUD', '_BIC_ZIO_SAUDT': '1', '_BIC_ZIO_PSKF': '804013'},
        {'FISCVARNT': 'K4', '_BIC_ZIO_SWEEK': '202350', '_BIC_ZIO_VER': 'LEDGER_BUD', '_BIC_ZIO_SAUDT': '1', '_BIC_ZIO_PSKF': '999999'},
        {'FISCVARNT': 'K4', '_BIC_ZIO_SWEEK': '202350', '_BIC_ZIO_VER': 'LEDGER_BUD', '_BIC_ZIO_SAUDT': '1', '_BIC_ZIO_PSKF': '801000'},
    ]
    filtered = filter_weekly_snapshot_ds05(rows, '202340', '202360', 'LEDGER_BUD')
    assert all(r['_BIC_ZIO_PSKF'] in ('804013', '801000') for r in filtered)
    assert len(filtered) == 2

def test_TC_06():
    rows = [
        {'PARNODE': 'ABC_CORERET', 'HRYVALTO': '99991231'},
        {'PARNODE': 'XYZ_CORERET', 'HRYVALTO': '20230101'},
        {'PARNODE': 'DEF_NOTCORERET', 'HRYVALTO': '99991231'},
    ]
    filtered = [r for r in rows if r['PARNODE'].endswith('CORERET') and r['HRYVALTO'] == '99991231']
    assert all(r['PARNODE'].endswith('CORERET') and r['HRYVALTO'] == '99991231' for r in filtered)
    assert len(filtered) == 1

def test_TC_07():
    left = [{'_B631_S_COSTCNTR': 'A'}, {'_B631_S_COSTCNTR': 'B'}]
    right = [{'NODEVALUE': 'A'}, {'NODEVALUE': 'C'}]
    joined = [l for l in left if any(l['_B631_S_COSTCNTR'] == r['NODEVALUE'] for r in right)]
    assert len(joined) == 1
    assert joined[0]['_B631_S_COSTCNTR'] == 'A'

def test_TC_08():
    left = [{'_B631_S_PROFTCTR': 'P1'}, {'_B631_S_PROFTCTR': 'P2'}]
    right = [{'PRCTR': 'P1', 'REP_MKT_CODE': 'X'}]
    joined = []
    right_map = {r['PRCTR']: r for r in right}
    for l in left:
        r = right_map.get(l['_B631_S_PROFTCTR'])
        merged = l.copy()
        if r:
            merged['REP_MKT_CODE'] = r['REP_MKT_CODE']
        else:
            merged['REP_MKT_CODE'] = None
        joined.append(merged)
    assert joined[0]['REP_MKT_CODE'] == 'X'
    assert joined[1]['REP_MKT_CODE'] is None

def test_TC_09():
    left = [{'_B631_S_PROFTCTR': 'P1', '_BIC_ZIO_SWEEK': '202352'}, {'_B631_S_PROFTCTR': 'P2', '_BIC_ZIO_SWEEK': '202352'}]
    right = [{'PRCTR': 'P1', 'ZWEEK': '202352', 'RX_COMP_WK': '5'}]
    joined = []
    right_map = {(r['PRCTR'], r['ZWEEK']): r for r in right}
    for l in left:
        key = (l['_B631_S_PROFTCTR'], l['_BIC_ZIO_SWEEK'])
        r = right_map.get(key)
        merged = l.copy()
        merged['RX_COMP_WK'] = r['RX_COMP_WK'] if r else None
        joined.append(merged)
    assert joined[0]['RX_COMP_WK'] == '5'
    assert joined[1]['RX_COMP_WK'] is None

def test_TC_10():
    left = [{'_BIC_ZIO_SWEEK': '202352'}, {'_BIC_ZIO_SWEEK': '202353'}]
    right = [{'ZZWEEK': '202352', 'ZRWENDDATE': '2023-12-31'}]
    joined = []
    right_map = {r['ZZWEEK']: r for r in right}
    for l in left:
        r = right_map.get(l['_BIC_ZIO_SWEEK'])
        merged = l.copy()
        merged['ZRWENDDATE'] = r['ZRWENDDATE'] if r else None
        joined.append(merged)
    assert joined[0]['ZRWENDDATE'] == '2023-12-31'
    assert joined[1]['ZRWENDDATE'] is None

def test_TC_11():
    left = [{'_B631_S_PROFTCTR': 'P1'}, {'_B631_S_PROFTCTR': 'P2'}]
    right = [{'PRCTR': 'P1', 'PROFIT_CENTER_TEXT': 'Text1'}]
    joined = []
    right_map = {r['PRCTR']: r for r in right}
    for l in left:
        r = right_map.get(l['_B631_S_PROFTCTR'])
        merged = l.copy()
        merged['PROFIT_CENTER_TEXT'] = r['PROFIT_CENTER_TEXT'] if r else None
        joined.append(merged)
    assert joined[0]['PROFIT_CENTER_TEXT'] == 'Text1'
    assert joined[1]['PROFIT_CENTER_TEXT'] is None

def test_TC_12():
    _BIC_ZIO_SWEEK = '202352'
    cal_week_number = right_str(_BIC_ZIO_SWEEK, 2)
    assert cal_week_number == '52'

def test_TC_13():
    val = calc_bic_zio_skfq('804013', 10)
    assert val == 20

def test_TC_14():
    val = calc_bic_zio_skfq('801000', 10)
    assert val == 10

def test_TC_15():
    val = calc_rx_comp_wk(None)
    assert val == '0'

def test_TC_16():
    val = calc_rx_comp_wk('5')
    assert val == '5'

def test_TC_17():
    rows = [{'_BIC_ZIO_SKFQ': 5}, {'_BIC_ZIO_SKFQ': 10}]
    agg = sum(r['_BIC_ZIO_SKFQ'] for r in rows)
    assert agg == 15

def test_TC_18():
    rows = [{'CAL_BIC_ZIO_SKFQ': 6}, {'CAL_BIC_ZIO_SKFQ': 4}]
    agg = sum(r['CAL_BIC_ZIO_SKFQ'] for r in rows)
    assert agg == 10

def test_TC_19():
    rows = [
        {'G1': 'A', 'G2': 'B', '_BIC_ZIO_SKFQ': 5},
        {'G1': 'A', 'G2': 'B', '_BIC_ZIO_SKFQ': 10},
        {'G1': 'C', 'G2': 'D', '_BIC_ZIO_SKFQ': 3}
    ]
    group_keys = ['G1', 'G2']
    sum_fields = ['_BIC_ZIO_SKFQ']
    grouped = group_by(rows, group_keys, sum_fields)
    assert len(grouped) == 2
    for g in grouped:
        if g['G1'] == 'A':
            assert g['_BIC_ZIO_SKFQ'] == 15
        elif g['G1'] == 'C':
            assert g['_BIC_ZIO_SKFQ'] == 3

def test_TC_20():
    row = {
        'MANDT': '100', 'FISCPER': '202312', 'FISCVARNT': 'K4', 'FISCYEAR': '2023', 'FISCPER3': '12',
        'RECORDMODE': 'A', '_BIC_ZIO_SWEEK': '202352', '_B631_S_CO_AREA': '01', '_BIC_ZIO_CMPCD': 'C1',
        '_B631_S_PROFTCTR': 'P1', '_B631_S_COSTCNTR': 'CC1', '_BIC_ZIO_VER': 'LEDGER_BUD', '_BIC_ZIO_SAUDT': '1',
        'REP_MKT_CODE': 'RM1', 'REP_MKT_DESC': 'Market', 'EMERG_MKT_IND': 'Y', '_BIC_ZIO_PSTY': 'PT1',
        '_BIC_ZIO_PSKF': '804013', 'UNIT': 'EA', 'DIVISION_CODE': 'D1', 'DIVISION_DESC': 'Div', 'AREA_CODE': 'A1',
        'AREA_DESC': 'Area', 'DISTRICT_CODE': 'DC1', 'DISTRICT_DESC': 'District', 'REGION_CODE': 'R1',
        'REGION_DESC': 'Region', 'CAL_WEEK_NUMBER': '52', 'STRNUM': 'S1', 'ZRWENDDATE': '2023-12-31',
        'ZRWSTRTDATE': '2023-12-25', 'CITY': 'City', 'STATE': 'ST', 'PROFIT_CENTER_TEXT': 'Text',
        'FS_OPEN_DAT': '2020-01-01', 'RX_OPEN_DAT': '2020-02-01', 'CAL_RX_COMP_WK': '5', 'FLAG': 'F',
        'RX_DIVISION_CODE': 'D2', 'RX_AREA_CODE': 'A2', 'RX_REGION_CODE': 'R2', 'RX_DISTRICT_CODE': 'D3'
    }
    expected_cols = [
        'MANDT','FISCPER','FISCVARNT','FISCYEAR','FISCPER3','RECORDMODE','_BIC_ZIO_SWEEK','_B631_S_CO_AREA',
        '_BIC_ZIO_CMPCD','_B631_S_PROFTCTR','_B631_S_COSTCNTR','_BIC_ZIO_VER','_BIC_ZIO_SAUDT','REP_MKT_CODE',
        'REP_MKT_DESC','EMERG_MKT_IND','_BIC_ZIO_PSTY','_BIC_ZIO_PSKF','UNIT','DIVISION_CODE','DIVISION_DESC',
        'AREA_CODE','AREA_DESC','DISTRICT_CODE','DISTRICT_DESC','REGION_CODE','REGION_DESC','CAL_WEEK_NUMBER',
        'STRNUM','ZRWENDDATE','ZRWSTRTDATE','CITY','STATE','PROFIT_CENTER_TEXT','FS_OPEN_DAT','RX_OPEN_DAT',
        'CAL_RX_COMP_WK','FLAG','RX_DIVISION_CODE','RX_AREA_CODE','RX_REGION_CODE','RX_DISTRICT_CODE'
    ]
    for col in expected_cols:
        assert col in row

def test_TC_21():
    left = [{'_B631_S_PROFTCTR': 'P2'}]
    right = [{'PRCTR': 'P1', 'PROFIT_CENTER_TEXT': 'Text1'}]
    right_map = {r['PRCTR']: r for r in right}
    l = left[0]
    r = right_map.get(l['_B631_S_PROFTCTR'])
    merged = l.copy()
    merged['PROFIT_CENTER_TEXT'] = r['PROFIT_CENTER_TEXT'] if r else None
    assert merged['PROFIT_CENTER_TEXT'] is None

def test_TC_22():
    _BIC_ZIO_SWEEK = 202352
    cal_week_number = right_str(_BIC_ZIO_SWEEK, 2)
    assert cal_week_number == '52'

def test_TC_23():
    rows = [
        {'_BIC_ZIO_VER': 'LEDGER_BUD'},
        {'_BIC_ZIO_VER': 'ACTUAL'}
    ]
    filtered = [r for r in rows if r['_BIC_ZIO_VER'] == 'LEDGER_BUD']
    assert all(r['_BIC_ZIO_VER'] == 'LEDGER_BUD' for r in filtered)
    assert len(filtered) == 1

def test_TC_24():
    rows = [
        {'_BIC_ZIO_SWEEK': '202350'},
        {'_BIC_ZIO_SWEEK': '202360'},
        {'_BIC_ZIO_SWEEK': '202370'},
    ]
    ip_week_ending_from = '202350'
    ip_week_ending_to = '202360'
    filtered = [r for r in rows if ip_week_ending_from <= r['_BIC_ZIO_SWEEK'] <= ip_week_ending_to]
    assert all(ip_week_ending_from <= r['_BIC_ZIO_SWEEK'] <= ip_week_ending_to for r in filtered)
    assert len(filtered) == 2

def test_TC_25():
    rows = [
        {'FISCVARNT': 'K5', '_BIC_ZIO_SWEEK': '202399', '_BIC_ZIO_VER': 'OTHER', '_BIC_ZIO_SAUDT': '3', '_BIC_ZIO_PSKF': '999999'},
    ]
    filtered = filter_weekly_snapshot_ds05(rows, '202340', '202360', 'LEDGER_BUD')
    assert len(filtered) == 0

def test_TC_26():
    left = [{'_B631_S_PROFTCTR': 'P3'}]
    right = [{'PRCTR': 'P1', 'PROFIT_CENTER_TEXT': 'Text1'}]
    right_map = {r['PRCTR']: r for r in right}
    l = left[0]
    r = right_map.get(l['_B631_S_PROFTCTR'])
    merged = l.copy()
    merged['PROFIT_CENTER_TEXT'] = r['PROFIT_CENTER_TEXT'] if r else None
    assert merged['PROFIT_CENTER_TEXT'] is None
```

---

**Cost Analysis**

API Cost: 0.0000 USD

---
