**Unit Test Case Summary**

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Filter on Frozen_Cube: MANDT in ('110','200') and IP_FC_COUNT != '0' | Frozen_Cube input rows with MANDT = '110', '200', '300'; test with IP_FC_COUNT = '1' | Only rows with MANDT = '110' or '200' are included in Frozen_Cube output when IP_FC_COUNT != '0' | Frozen_Cube output contains only rows with allowed MANDT values; rows with MANDT = '300' are excluded |
| TC_02 | Filter on Frozen_Cube: Exclusion when IP_FC_COUNT = '0' | Frozen_Cube input rows with any MANDT; test with IP_FC_COUNT = '0' | No rows are included in Frozen_Cube output when IP_FC_COUNT = '0' | Frozen_Cube output is empty |
| TC_03 | Filter on Live_Cube: MANDT in ('110','200') and IP_FC_COUNT = '0' | Live_Cube input rows with MANDT = '110', '200', '300'; test with IP_FC_COUNT = '0' | Only rows with MANDT = '110' or '200' are included in Live_Cube output when IP_FC_COUNT = '0' | Live_Cube output contains only rows with allowed MANDT values; rows with MANDT = '300' are excluded |
| TC_04 | Filter on Live_Cube: Exclusion when IP_FC_COUNT != '0' | Live_Cube input rows with any MANDT; test with IP_FC_COUNT = '1' | No rows are included in Live_Cube output when IP_FC_COUNT != '0' | Live_Cube output is empty |
| TC_05 | Mapping: _B631_S_CHRTACCT and _B631_S_FUNCAREA in Live_Cube | Live_Cube input rows with any values; test with IP_FC_COUNT = '0' | _B631_S_CHRTACCT and _B631_S_FUNCAREA are set to empty string ('') in Combined_Frozen_Live_Data from Live_Cube | Combined_Frozen_Live_Data rows from Live_Cube have _B631_S_CHRTACCT = '' and _B631_S_FUNCAREA = '' |
| TC_06 | Mapping: _B631_S_PROFTCTR and _B631_S_COSTCNTR in Live_Cube | Live_Cube input rows with _BIC_ZIO_PCTR = 'P1', _BIC_ZIO_CCTR = 'C1' | _B631_S_PROFTCTR = _BIC_ZIO_PCTR, _B631_S_COSTCNTR = _BIC_ZIO_CCTR in Combined_Frozen_Live_Data from Live_Cube | Combined_Frozen_Live_Data rows from Live_Cube have mapped values for these columns |
| TC_07 | UNION ALL: Combined_Frozen_Live_Data includes all rows from both cubes | 2 rows in Frozen_Cube, 3 in Live_Cube | Combined_Frozen_Live_Data has 5 rows, preserving all input rows | Row count and content of Combined_Frozen_Live_Data is sum of both cubes |
| TC_08 | FLAG assignment: 'FC' for Frozen_Cube, 'LC' for Live_Cube | Any valid Frozen_Cube and Live_Cube rows | Combined_Frozen_Live_Data rows from Frozen_Cube have FLAG='FC'; from Live_Cube have FLAG='LC' | FLAG column is correctly assigned in output |
| TC_09 | Calculated measure: Only FC present | Combined_Frozen_Live_Data has only rows with FLAG='FC', various _BIC_ZIO_SKFQ values | Output _BIC_ZIO_SKFQ is sum of _BIC_ZIO_SKFQ for FLAG='FC' | Output measure matches sum of FC rows |
| TC_10 | Calculated measure: Only LC present | Combined_Frozen_Live_Data has only rows with FLAG='LC', various _BIC_ZIO_SKFQ values | Output _BIC_ZIO_SKFQ is sum of _BIC_ZIO_SKFQ for FLAG='LC' | Output measure matches sum of LC rows |
| TC_11 | Calculated measure: Both FC and LC present | Combined_Frozen_Live_Data has rows with both FLAG='FC' and FLAG='LC', various _BIC_ZIO_SKFQ values | Output _BIC_ZIO_SKFQ is sum of _BIC_ZIO_SKFQ for FLAG='FC' (LC ignored if FC present) | Output measure matches sum of FC rows only |
| TC_12 | Calculated measure: FC sum is NULL, LC present | For a group, all _BIC_ZIO_SKFQ are NULL for FLAG='FC', but present for FLAG='LC' | Output _BIC_ZIO_SKFQ is sum of LC rows | Output measure matches sum of LC rows when FC sum is NULL |
| TC_13 | Calculated measure: Both FC and LC sums are NULL | For a group, all _BIC_ZIO_SKFQ are NULL for both FLAG='FC' and 'LC' | Output _BIC_ZIO_SKFQ is NULL | Output measure is NULL |
| TC_14 | Aggregation and GROUP BY: Distinct output rows | Input has multiple rows for same group keys, various _BIC_ZIO_SKFQ values | Output has one row per unique group (all non-measure columns), measure is aggregated | Output row count matches unique group count, measures are sums |
| TC_15 | NULL handling in input columns | Input rows have NULLs in non-measure columns | Output rows group by NULLs as valid group keys, measure aggregation is correct | Output groups by NULLs, measure is correct |
| TC_16 | Data type compatibility: Numeric aggregation | _BIC_ZIO_SKFQ contains numeric and NULL values | SUM aggregation works without error; NULLs do not affect sum | Output measure is correct sum of non-NULL values |
| TC_17 | Parameter substitution: IP_FC_COUNT as string | IP_FC_COUNT = '0', '1', '', NULL | Filters behave as expected with string values | Output matches expected filtering for each value |

---

**Pytest Script**

```python
import pytest

# Sample helper functions to simulate the SQL logic for unit testing

def filter_frozen_cube(rows, ip_fc_count):
    return [
        row for row in rows
        if row['MANDT'] in ('110', '200') and str(ip_fc_count) != '0'
    ]

def filter_live_cube(rows, ip_fc_count):
    return [
        row for row in rows
        if row['MANDT'] in ('110', '200') and str(ip_fc_count) == '0'
    ]

def map_live_cube(row):
    mapped = row.copy()
    mapped['_B631_S_CHRTACCT'] = ''
    mapped['_B631_S_FUNCAREA'] = ''
    mapped['_B631_S_PROFTCTR'] = row.get('_BIC_ZIO_PCTR', '')
    mapped['_B631_S_COSTCNTR'] = row.get('_BIC_ZIO_CCTR', '')
    mapped['FLAG'] = 'LC'
    return mapped

def map_frozen_cube(row):
    mapped = row.copy()
    mapped['FLAG'] = 'FC'
    return mapped

def combine_cubes(frozen_rows, live_rows):
    return [map_frozen_cube(r) for r in frozen_rows] + [map_live_cube(r) for r in live_rows]

def aggregate(rows, group_keys, measure_col='_BIC_ZIO_SKFQ'):
    from collections import defaultdict
    grouped = defaultdict(list)
    for row in rows:
        key = tuple(row.get(k) for k in group_keys)
        grouped[key].append(row)
    result = []
    for key, group in grouped.items():
        sum_fc = sum([r[measure_col] for r in group if r['FLAG'] == 'FC' and r[measure_col] is not None], 0)
        sum_lc = sum([r[measure_col] for r in group if r['FLAG'] == 'LC' and r[measure_col] is not None], 0)
        # If sum_fc is None or 0 rows, treat as None
        fc_rows = [r for r in group if r['FLAG'] == 'FC']
        fc_sum_is_null = all(r[measure_col] is None for r in fc_rows) if fc_rows else True
        if fc_sum_is_null:
            final = sum_lc if group else None
        else:
            final = sum_fc
        out_row = {k: v for k, v in zip(group_keys, key)}
        out_row['_BIC_ZIO_SKFQ'] = final if (fc_rows or sum_lc or sum_fc) else None
        result.append(out_row)
    return result

# Test cases

def test_TC_01():
    rows = [
        {'MANDT': '110'}, {'MANDT': '200'}, {'MANDT': '300'}
    ]
    result = filter_frozen_cube(rows, ip_fc_count='1')
    assert all(r['MANDT'] in ('110', '200') for r in result)
    assert all(r['MANDT'] != '300' for r in result)

def test_TC_02():
    rows = [{'MANDT': '110'}, {'MANDT': '200'}]
    result = filter_frozen_cube(rows, ip_fc_count='0')
    assert result == []

def test_TC_03():
    rows = [
        {'MANDT': '110'}, {'MANDT': '200'}, {'MANDT': '300'}
    ]
    result = filter_live_cube(rows, ip_fc_count='0')
    assert all(r['MANDT'] in ('110', '200') for r in result)
    assert all(r['MANDT'] != '300' for r in result)

def test_TC_04():
    rows = [{'MANDT': '110'}, {'MANDT': '200'}]
    result = filter_live_cube(rows, ip_fc_count='1')
    assert result == []

def test_TC_05():
    row = {
        '_BIC_ZIO_PCTR': 'P1', '_BIC_ZIO_CCTR': 'C1', '_B631_S_CHRTACCT': 'X', '_B631_S_FUNCAREA': 'Y'
    }
    mapped = map_live_cube(row)
    assert mapped['_B631_S_CHRTACCT'] == ''
    assert mapped['_B631_S_FUNCAREA'] == ''

def test_TC_06():
    row = {
        '_BIC_ZIO_PCTR': 'P1', '_BIC_ZIO_CCTR': 'C1'
    }
    mapped = map_live_cube(row)
    assert mapped['_B631_S_PROFTCTR'] == 'P1'
    assert mapped['_B631_S_COSTCNTR'] == 'C1'

def test_TC_07():
    frozen = [{}, {}]
    live = [{}, {}, {}]
    combined = combine_cubes(frozen, live)
    assert len(combined) == 5

def test_TC_08():
    frozen = [{}, {}]
    live = [{}, {}]
    combined = combine_cubes(frozen, live)
    assert all(r['FLAG'] == 'FC' for r in combined[:2])
    assert all(r['FLAG'] == 'LC' for r in combined[2:])

def test_TC_09():
    group_keys = ['K']
    rows = [
        {'K': 1, '_BIC_ZIO_SKFQ': 10, 'FLAG': 'FC'},
        {'K': 1, '_BIC_ZIO_SKFQ': 20, 'FLAG': 'FC'}
    ]
    agg = aggregate(rows, group_keys)
    assert agg[0]['_BIC_ZIO_SKFQ'] == 30

def test_TC_10():
    group_keys = ['K']
    rows = [
        {'K': 1, '_BIC_ZIO_SKFQ': 5, 'FLAG': 'LC'},
        {'K': 1, '_BIC_ZIO_SKFQ': 7, 'FLAG': 'LC'}
    ]
    agg = aggregate(rows, group_keys)
    assert agg[0]['_BIC_ZIO_SKFQ'] == 12

def test_TC_11():
    group_keys = ['K']
    rows = [
        {'K': 1, '_BIC_ZIO_SKFQ': 10, 'FLAG': 'FC'},
        {'K': 1, '_BIC_ZIO_SKFQ': 5, 'FLAG': 'LC'}
    ]
    agg = aggregate(rows, group_keys)
    assert agg[0]['_BIC_ZIO_SKFQ'] == 10

def test_TC_12():
    group_keys = ['K']
    rows = [
        {'K': 1, '_BIC_ZIO_SKFQ': None, 'FLAG': 'FC'},
        {'K': 1, '_BIC_ZIO_SKFQ': 7, 'FLAG': 'LC'}
    ]
    agg = aggregate(rows, group_keys)
    assert agg[0]['_BIC_ZIO_SKFQ'] == 7

def test_TC_13():
    group_keys = ['K']
    rows = [
        {'K': 1, '_BIC_ZIO_SKFQ': None, 'FLAG': 'FC'},
        {'K': 1, '_BIC_ZIO_SKFQ': None, 'FLAG': 'LC'}
    ]
    agg = aggregate(rows, group_keys)
    assert agg[0]['_BIC_ZIO_SKFQ'] is None

def test_TC_14():
    group_keys = ['K']
    rows = [
        {'K': 1, '_BIC_ZIO_SKFQ': 1, 'FLAG': 'FC'},
        {'K': 1, '_BIC_ZIO_SKFQ': 2, 'FLAG': 'FC'},
        {'K': 2, '_BIC_ZIO_SKFQ': 3, 'FLAG': 'FC'}
    ]
    agg = aggregate(rows, group_keys)
    assert len(agg) == 2
    assert any(r['_BIC_ZIO_SKFQ'] == 3 for r in agg)
    assert any(r['_BIC_ZIO_SKFQ'] == 3 for r in agg)

def test_TC_15():
    group_keys = ['K']
    rows = [
        {'K': None, '_BIC_ZIO_SKFQ': 2, 'FLAG': 'FC'},
        {'K': None, '_BIC_ZIO_SKFQ': 3, 'FLAG': 'FC'}
    ]
    agg = aggregate(rows, group_keys)
    assert agg[0]['K'] is None
    assert agg[0]['_BIC_ZIO_SKFQ'] == 5

def test_TC_16():
    group_keys = ['K']
    rows = [
        {'K': 1, '_BIC_ZIO_SKFQ': 10, 'FLAG': 'FC'},
        {'K': 1, '_BIC_ZIO_SKFQ': None, 'FLAG': 'FC'},
        {'K': 1, '_BIC_ZIO_SKFQ': 5, 'FLAG': 'FC'}
    ]
    agg = aggregate(rows, group_keys)
    assert agg[0]['_BIC_ZIO_SKFQ'] == 15

@pytest.mark.parametrize("ip_fc_count,expected_fc,expected_lc", [
    ('0', False, True),
    ('1', True, False),
    ('', True, False),
    (None, True, False)
])
def test_TC_17(ip_fc_count, expected_fc, expected_lc):
    frozen_rows = [{'MANDT': '110'}]
    live_rows = [{'MANDT': '110'}]
    frozen_result = filter_frozen_cube(frozen_rows, ip_fc_count)
    live_result = filter_live_cube(live_rows, ip_fc_count)
    assert (len(frozen_result) > 0) == expected_fc
    assert (len(live_result) > 0) == expected_lc
```

---

**Cost Analysis**

API Cost: 0.0000 USD
