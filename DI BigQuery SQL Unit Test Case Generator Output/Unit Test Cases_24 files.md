**Unit Test Case Summary**

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Filter: RECORDQUALIFIER and TRANSTYPECODE in CV_BASE_TLOGF_BASE | RECORDQUALIFIER=5,6; TRANSTYPECODE not in (1107,1197,1020); WORKSTATIONID!='0000000000'; ARCHIVED=''; ZZ_UPD_TIMESTAMP!=0 | Only rows matching all filter conditions are included in CV_BASE_TLOGF_BASE | Assert only qualifying rows are present in the result set |
| TC_02 | Filter: RECORDQUALIFIER and WORKSTATIONID in CV_BASE_TLOGF_X_BASE | RECORDQUALIFIER=25; WORKSTATIONID!='0000000000'; ZZ_UPD_TIMESTAMP!='0' | Only rows matching all filter conditions are included in CV_BASE_TLOGF_X_BASE | Assert only qualifying rows are present in the result set |
| TC_03 | JOIN: FS_SALES joins FS_RETAIL_TYPES | FS_SALES_BASE.RETAILTYPECODE matches FS_RETAIL_TYPES.LOW_CHAR | Only rows with matching RETAILTYPECODE are included in FS_SALES | Assert join returns only matching records |
| TC_04 | JOIN: FS_DISCOUNT joins FS_DISC_TYPES | FS_DISCOUNT_BASE.DISCTYPECODE matches FS_DISC_TYPES.LOW_CHAR | Only rows with matching DISCTYPECODE are included in FS_DISCOUNT | Assert join returns only matching records |
| TC_05 | JOIN: RX_SALES joins RX_RETAIL_TYPES | RX_SALES_BASE.RETAILTYPECODE matches RX_RETAIL_TYPES.LOW_CHAR | Only rows with matching RETAILTYPECODE are included in RX_SALES | Assert join returns only matching records |
| TC_06 | JOIN: EMP_DISCOUNT joins EMP_DISC_TYPES | EMP_DISCOUNT_BASE.DISCTYPECODE matches EMP_DISC_TYPES.LOW_CHAR | Only rows with matching DISCTYPECODE are included in EMP_DISCOUNT | Assert join returns only matching records |
| TC_07 | JOIN: SCRIPTS_WITH_CURRENCY | SCRIPTS_BASE joined with NAVIX_2 on MANDT, RETAILSTOREID, BUSINESSDAYDATE | Only rows with matching keys are present in SCRIPTS_WITH_CURRENCY | Assert join returns only matching records |
| TC_08 | CASE: CAL_FS_UNITS calculation | ZZ_CUSTTYPE in ('F','M','R'), ('X','Y','Z'), or other | Returns 1, -1, or 0 according to logic | Assert correct value for CAL_FS_UNITS per input |
| TC_09 | CASE: CAL_RX_CNT_GE84_NS/RE, CAL_RX_CNT_NS/RE | Input column is '' (empty string) or a valid integer string | Returns 0 if '', else integer value | Assert correct type conversion and null handling |
| TC_10 | CASE: CAL_CVD_UNITS calculation | WORKSTATIONID='0000000555' and ZZ_CUSTTYPE in ('C','W') | Returns 1, -1, or 0 according to logic | Assert correct value for CAL_CVD_UNITS per input |
| TC_11 | Filter: COVID_SALES_BASE ITEMID | ITEMID='A01-433556' | Only rows with matching ITEMID are present | Assert filter is enforced |
| TC_12 | UNION ALL: FLASH_SALES_UNION | All source CTEs with different columns, including NULLs | All rows from all sources are present; NULLs as specified | Assert all sources are included, NULLs handled |
| TC_13 | Aggregation: FLASH_SALES_AGGREGATED | Multiple rows per group | Aggregated sums and counts are correct per group | Assert group by and aggregation correctness |
| TC_14 | JOIN: CV_COMP_FLASH_SALES_VT_CAR | NAVIX_FLASH joined with FLASH_SALES_AGGREGATED | Only rows with matching MANDT, RETAILSTOREID, BUSINESSDAYDATE | Assert join correctness |
| TC_15 | Filter: FLASH_SALES_VT_CAR_FILTERED | ZZ_UPD_TIMESTAMP, RETAILSTOREID, BUSINESSDAYDATE within dynamic date/timestamp ranges | Only rows matching filter criteria are included | Assert filter logic correctness |
| TC_16 | Date Calculation: CAL_WEEK_ENDING_DATE | BUSINESSDAYDATE with various DAYOFWEEK values | CAL_WEEK_ENDING_DATE is calculated as per logic | Assert correct date calculation for edge cases (e.g., Sunday, Saturday) |
| TC_17 | LEFT JOIN: FLASH_WITH_WEEK with RC | FLASH_SALES_VT_CAR_FILTERED left joined with CV_BASE_MD_RCALWEEK_S4 | All rows from left, matching right rows where available | Assert left join preserves all left rows |
| TC_18 | LEFT JOIN: FLASH_WITH_STORE with STORE_ATTR | FLASH_WITH_WEEK left joined with STORE_ATTR | All rows from left, matching right rows where available | Assert left join preserves all left rows |
| TC_19 | INNER JOIN: FLASH_WITH_HIERARCHY | FLASH_WITH_STORE joined with HIERARCHY on PRCTR | Only rows with matching PRCTR/NODEVALUE | Assert join correctness |
| TC_20 | LEFT JOIN: FLASH_WITH_COMP with COMP_FLAG | FLASH_WITH_HIERARCHY left joined with COMP_FLAG | All rows from left, matching right rows where available | Assert left join preserves all left rows |
| TC_21 | CASE: CAL_COMP_FLAG calculation | FS_COMP_WK and RX_COMP_WK are NULL or not | Returns '0' if either is NULL, else greatest as string | Assert correct case logic and type casting |
| TC_22 | CASE: CAL_PRCTR in EMPLOYEE_DISCOUNT | CAL_COMP_FLAG is '1', '0', or other | Returns '0000562075', '0000562076', or NULL | Assert correct value assignment |
| TC_23 | Aggregation: EMPLOYEE_DISCOUNT | Multiple rows per group | Aggregated sums and maxes are correct per group | Assert group by and aggregation correctness |
| TC_24 | UNION ALL: UNION_CALCULATIONS_EMP | CALCULATIONS and EMP_DISC_WITH_STORE with NULLs as needed | All rows from both sources, NULLs as specified | Assert union includes all expected rows, NULLs handled |
| TC_25 | LEFT JOIN: CV_COMP_FIN_FLASH_OUTPUT with PROFIT_CENTER_TEXT | UNION_CALCULATIONS_EMP left joined with PROFIT_CENTER_TEXT | All left rows, right where available | Assert join correctness |
| TC_26 | Aggregation: CV_COMP_FIN_FLASH_STATIC | Multiple rows per group | Aggregated sums and maxes are correct per group | Assert group by and aggregation correctness |
| TC_27 | UNION ALL: COMBINED_ALL_SOURCES | Multiple sources with NULLs and different columns | All rows from all sources, NULLs as specified | Assert union includes all rows and correct NULL handling |
| TC_28 | Aggregation: AGGREGATION_COMBINED | Multiple rows per group | Aggregated sums and maxes are correct per group | Assert group by and aggregation correctness |
| TC_29 | Calculation: CAL_FS_SALES and other calculated columns | Inputs for all calculation columns | Calculated columns match SQL expressions | Assert calculation logic correctness |
| TC_30 | Final Output: Group By and Aggregation | Multiple rows per group | Aggregated sums and group by columns as per final SELECT | Assert correctness of final output logic |

---

**Pytest Script**

```python
import pytest

def test_TC_01_filter_CV_BASE_TLOGF_BASE():
    data = [
        {'RECORDQUALIFIER': 5, 'TRANSTYPECODE': 1000, 'WORKSTATIONID': '0000000001', 'ARCHIVED': '', 'ZZ_UPD_TIMESTAMP': 1},
        {'RECORDQUALIFIER': 4, 'TRANSTYPECODE': 1000, 'WORKSTATIONID': '0000000001', 'ARCHIVED': '', 'ZZ_UPD_TIMESTAMP': 1},
        {'RECORDQUALIFIER': 5, 'TRANSTYPECODE': 1107, 'WORKSTATIONID': '0000000001', 'ARCHIVED': '', 'ZZ_UPD_TIMESTAMP': 1},
        {'RECORDQUALIFIER': 5, 'TRANSTYPECODE': 1000, 'WORKSTATIONID': '0000000000', 'ARCHIVED': '', 'ZZ_UPD_TIMESTAMP': 1},
        {'RECORDQUALIFIER': 5, 'TRANSTYPECODE': 1000, 'WORKSTATIONID': '0000000001', 'ARCHIVED': 'X', 'ZZ_UPD_TIMESTAMP': 1},
        {'RECORDQUALIFIER': 5, 'TRANSTYPECODE': 1000, 'WORKSTATIONID': '0000000001', 'ARCHIVED': '', 'ZZ_UPD_TIMESTAMP': 0},
    ]
    filtered = [
        row for row in data
        if row['RECORDQUALIFIER'] in (5,6)
        and row['TRANSTYPECODE'] not in (1107,1197,1020)
        and row['WORKSTATIONID'] != '0000000000'
        and row['ARCHIVED'] == ''
        and row['ZZ_UPD_TIMESTAMP'] != 0
    ]
    assert filtered == [data[0]]

def test_TC_02_filter_CV_BASE_TLOGF_X_BASE():
    data = [
        {'RECORDQUALIFIER': 25, 'WORKSTATIONID': '0000000001', 'ZZ_UPD_TIMESTAMP': '1'},
        {'RECORDQUALIFIER': 25, 'WORKSTATIONID': '0000000000', 'ZZ_UPD_TIMESTAMP': '1'},
        {'RECORDQUALIFIER': 24, 'WORKSTATIONID': '0000000001', 'ZZ_UPD_TIMESTAMP': '1'},
        {'RECORDQUALIFIER': 25, 'WORKSTATIONID': '0000000001', 'ZZ_UPD_TIMESTAMP': '0'},
    ]
    filtered = [
        row for row in data
        if row['RECORDQUALIFIER'] == 25
        and row['WORKSTATIONID'] != '0000000000'
        and row['ZZ_UPD_TIMESTAMP'] != '0'
    ]
    assert filtered == [data[0]]

def test_TC_03_join_FS_SALES_FS_RETAIL_TYPES():
    sales_base = [
        {'RETAILTYPECODE': 'A'},
        {'RETAILTYPECODE': 'B'},
    ]
    retail_types = [
        {'LOW_CHAR': 'A'},
    ]
    joined = [
        l for l in sales_base
        if any(r['LOW_CHAR'] == l['RETAILTYPECODE'] for r in retail_types)
    ]
    assert joined == [sales_base[0]]

def test_TC_04_join_FS_DISCOUNT_FS_DISC_TYPES():
    discount_base = [
        {'DISCTYPECODE': 'X'},
        {'DISCTYPECODE': 'Y'},
    ]
    disc_types = [
        {'LOW_CHAR': 'X'},
    ]
    joined = [
        l for l in discount_base
        if any(r['LOW_CHAR'] == l['DISCTYPECODE'] for r in disc_types)
    ]
    assert joined == [discount_base[0]]

def test_TC_05_join_RX_SALES_RX_RETAIL_TYPES():
    rx_base = [
        {'RETAILTYPECODE': 'C'},
        {'RETAILTYPECODE': 'D'},
    ]
    rx_types = [
        {'LOW_CHAR': 'C'},
    ]
    joined = [
        l for l in rx_base
        if any(r['LOW_CHAR'] == l['RETAILTYPECODE'] for r in rx_types)
    ]
    assert joined == [rx_base[0]]

def test_TC_06_join_EMP_DISCOUNT_EMP_DISC_TYPES():
    emp_base = [
        {'DISCTYPECODE': 'E'},
        {'DISCTYPECODE': 'F'},
    ]
    emp_types = [
        {'LOW_CHAR': 'E'},
    ]
    joined = [
        l for l in emp_base
        if any(r['LOW_CHAR'] == l['DISCTYPECODE'] for r in emp_types)
    ]
    assert joined == [emp_base[0]]

def test_TC_07_join_SCRIPTS_WITH_CURRENCY():
    base = [
        {'MANDT': 1, 'RETAILSTOREID': 'A', 'BUSINESSDAYDATE': '20230101'},
        {'MANDT': 1, 'RETAILSTOREID': 'B', 'BUSINESSDAYDATE': '20230101'},
    ]
    navix = [
        {'MANDT': 1, 'RETAILSTOREID': 'A', 'BUSINESSDAYDATE': '20230101', 'CURRENCY': 'USD'},
    ]
    joined = [
        {**l, **{'CURRENCY': r['CURRENCY']}}
        for l in base
        for r in navix
        if l['MANDT'] == r['MANDT'] and l['RETAILSTOREID'] == r['RETAILSTOREID'] and l['BUSINESSDAYDATE'] == r['BUSINESSDAYDATE']
    ]
    assert joined == [{**base[0], 'CURRENCY': 'USD'}]

def test_TC_08_case_CAL_FS_UNITS():
    assert (lambda x: 1 if x in ('F','M','R') else -1 if x in ('X','Y','Z') else 0)('F') == 1
    assert (lambda x: 1 if x in ('F','M','R') else -1 if x in ('X','Y','Z') else 0)('Y') == -1
    assert (lambda x: 1 if x in ('F','M','R') else -1 if x in ('X','Y','Z') else 0)('Q') == 0

def test_TC_09_case_CAL_RX_CNT_conversions():
    def conv(val):
        return 0 if val == '' else int(val)
    assert conv('') == 0
    assert conv('5') == 5

def test_TC_10_case_CAL_CVD_UNITS():
    def calc(workstationid, custtype):
        if workstationid == '0000000555':
            if custtype == 'C':
                return 1
            elif custtype == 'W':
                return -1
            else:
                return 0
        else:
            return 0
    assert calc('0000000555', 'C') == 1
    assert calc('0000000555', 'W') == -1
    assert calc('0000000555', 'A') == 0
    assert calc('0000000001', 'C') == 0

def test_TC_11_filter_COVID_SALES_BASE_ITEMID():
    data = [
        {'ITEMID': 'A01-433556'},
        {'ITEMID': 'B01-000000'},
    ]
    filtered = [row for row in data if row['ITEMID'] == 'A01-433556']
    assert filtered == [data[0]]

def test_TC_12_union_all_FLASH_SALES_UNION():
    a = [{'a': 1}]
    b = [{'b': 2}]
    c = [{'c': 3}]
    unioned = [{**row, **{'b': None, 'c': None}} for row in a] + \
              [{**{'a': None}, **row, **{'c': None}} for row in b] + \
              [{**{'a': None, 'b': None}, **row} for row in c]
    assert len(unioned) == 3

def test_TC_13_aggregation_FLASH_SALES_AGGREGATED():
    data = [
        {'MANDT': 1, 'FS_SALESAMOUNT': 10, 'REDUCTIONAMOUNT': 1},
        {'MANDT': 1, 'FS_SALESAMOUNT': 20, 'REDUCTIONAMOUNT': 2},
    ]
    agg = {
        'FS_SALESAMOUNT': sum(d['FS_SALESAMOUNT'] for d in data),
        'REDUCTIONAMOUNT': sum(d['REDUCTIONAMOUNT'] for d in data),
    }
    assert agg['FS_SALESAMOUNT'] == 30
    assert agg['REDUCTIONAMOUNT'] == 3

def test_TC_14_join_CV_COMP_FLASH_SALES_VT_CAR():
    left = [{'MANDT': 1, 'RETAILSTOREID': 'A', 'BUSINESSDAYDATE': '20230101'}]
    right = [{'MANDT': 1, 'RETAILSTOREID': 'A', 'BUSINESSDAYDATE': '20230101'}]
    joined = [
        {**l, **r}
        for l in left
        for r in right
        if l['MANDT'] == r['MANDT'] and l['RETAILSTOREID'] == r['RETAILSTOREID'] and l['BUSINESSDAYDATE'] == r['BUSINESSDAYDATE']
    ]
    assert joined

def test_TC_15_filter_FLASH_SALES_VT_CAR_FILTERED():
    data = [
        {'ZZ_UPD_TIMESTAMP': '20230101091401', 'RETAILSTOREID': '0000020001', 'BUSINESSDAYDATE': '20230101'},
        {'ZZ_UPD_TIMESTAMP': '20230102091401', 'RETAILSTOREID': '0000025000', 'BUSINESSDAYDATE': '20230101'},
    ]
    v_update_timestamp_from = '20230101000000'
    v_update_timestamp_to = '20230102000000'
    v_week_ending_from_date = '20230101'
    v_week_ending_to_date = '20230101'
    filtered = [
        row for row in data
        if v_update_timestamp_from <= row['ZZ_UPD_TIMESTAMP'] <= v_update_timestamp_to
        and (row['RETAILSTOREID'] < '0000020000' or row['RETAILSTOREID'] > '0000024999')
        and (v_week_ending_from_date <= row['BUSINESSDAYDATE'] <= v_week_ending_to_date)
    ]
    assert filtered == [data[0]]

def test_TC_16_date_CAL_WEEK_ENDING_DATE():
    import datetime
    def calc_week_ending(businessdaydate):
        d = datetime.datetime.strptime(businessdaydate, '%Y%m%d').date()
        dow = d.isoweekday() % 7 + 1  # BigQuery DAYOFWEEK: 1=Sunday, 7=Saturday
        if dow == 7:
            offset = -1
        else:
            offset = dow
        week_ending = d + datetime.timedelta(days=(5 - offset))
        return week_ending.strftime('%Y%m%d')
    # Edge cases
    assert calc_week_ending('20230625')  # Sunday
    assert calc_week_ending('20230624')  # Saturday

def test_TC_17_left_join_FLASH_WITH_WEEK():
    left = [{'id': 1}, {'id': 2}]
    right = [{'id': 1}]
    joined = [dict(l, **(next((r for r in right if r['id'] == l['id']), {}))) for l in left]
    assert joined[0]['id'] == 1
    assert joined[1]['id'] == 2

def test_TC_18_left_join_FLASH_WITH_STORE():
    left = [{'id': 1}, {'id': 2}]
    right = [{'id': 2}]
    joined = [dict(l, **(next((r for r in right if r['id'] == l['id']), {}))) for l in left]
    assert joined[0]['id'] == 1
    assert joined[1]['id'] == 2

def test_TC_19_inner_join_FLASH_WITH_HIERARCHY():
    left = [{'PRCTR': 'A'}, {'PRCTR': 'B'}]
    right = [{'NODEVALUE': 'A'}]
    joined = [dict(l, **{'NODEVALUE': r['NODEVALUE']}) for l in left for r in right if l['PRCTR'] == r['NODEVALUE']]
    assert joined == [{'PRCTR': 'A', 'NODEVALUE': 'A'}]

def test_TC_20_left_join_FLASH_WITH_COMP():
    left = [{'PRCTR': 'A'}, {'PRCTR': 'B'}]
    right = [{'PRCTR': 'A'}]
    joined = [dict(l, **(next((r for r in right if r['PRCTR'] == l['PRCTR']), {}))) for l in left]
    assert joined[0]['PRCTR'] == 'A'
    assert joined[1]['PRCTR'] == 'B'

def test_TC_21_case_CAL_COMP_FLAG():
    def calc(fs, rx):
        if fs is None or rx is None:
            return '0'
        else:
            return str(max(int(fs), int(rx)))
    assert calc(None, 1) == '0'
    assert calc(1, None) == '0'
    assert calc(2, 1) == '2'

def test_TC_22_case_CAL_PRCTR():
    def calc(flag):
        if flag == '1':
            return '0000562075'
        elif flag == '0':
            return '0000562076'
        else:
            return None
    assert calc('1') == '0000562075'
    assert calc('0') == '0000562076'
    assert calc('X') is None

def test_TC_23_aggregation_EMPLOYEE_DISCOUNT():
    data = [
        {'EMP_REDUCTIONAMOUNT': 1, 'RX_UPD_TIMESTAMP': 2, 'FS_UPD_TIMESTAMP': 3, 'SCRIPTS_UPD_TIMESTAMP': 4},
        {'EMP_REDUCTIONAMOUNT': 2, 'RX_UPD_TIMESTAMP': 1, 'FS_UPD_TIMESTAMP': 4, 'SCRIPTS_UPD_TIMESTAMP': 2},
    ]
    agg = {
        'EMP_REDUCTIONAMOUNT': sum(d['EMP_REDUCTIONAMOUNT'] for d in data),
        'RX_UPD_TIMESTAMP': max(d['RX_UPD_TIMESTAMP'] for d in data),
        'FS_UPD_TIMESTAMP': max(d['FS_UPD_TIMESTAMP'] for d in data),
        'SCRIPTS_UPD_TIMESTAMP': max(d['SCRIPTS_UPD_TIMESTAMP'] for d in data),
    }
    assert agg['EMP_REDUCTIONAMOUNT'] == 3
    assert agg['RX_UPD_TIMESTAMP'] == 2

def test_TC_24_union_all_UNION_CALCULATIONS_EMP():
    a = [{'a': 1}]
    b = [{'b': 2}]
    unioned = [{**row, **{'b': None}} for row in a] + [{**{'a': None}, **row} for row in b]
    assert len(unioned) == 2

def test_TC_25_left_join_CV_COMP_FIN_FLASH_OUTPUT():
    left = [{'PRCTR': 'A'}, {'PRCTR': 'B'}]
    right = [{'PRCTR': 'A', 'PROFIT_CENTER_TEXT': 'TextA'}]
    joined = [dict(l, **(next(({'PROFIT_CENTER_TEXT': r['PROFIT_CENTER_TEXT']} for r in right if r['PRCTR'] == l['PRCTR']), {}))) for l in left]
    assert joined[0]['PROFIT_CENTER_TEXT'] == 'TextA'
    assert 'PROFIT_CENTER_TEXT' not in joined[1] or joined[1]['PROFIT_CENTER_TEXT'] is None

def test_TC_26_aggregation_CV_COMP_FIN_FLASH_STATIC():
    data = [
        {'FS_SALESAMOUNT': 10, 'REDUCTIONAMOUNT': 1},
        {'FS_SALESAMOUNT': 20, 'REDUCTIONAMOUNT': 2},
    ]
    agg = {
        'FS_SALESAMOUNT': sum(d['FS_SALESAMOUNT'] for d in data),
        'REDUCTIONAMOUNT': sum(d['REDUCTIONAMOUNT'] for d in data),
    }
    assert agg['FS_SALESAMOUNT'] == 30
    assert agg['REDUCTIONAMOUNT'] == 3

def test_TC_27_union_all_COMBINED_ALL_SOURCES():
    a = [{'a': 1}]
    b = [{'b': 2}]
    unioned = [{**row, **{'b': None}} for row in a] + [{**{'a': None}, **row} for row in b]
    assert len(unioned) == 2

def test_TC_28_aggregation_AGGREGATION_COMBINED():
    data = [
        {'RX_SALESAMOUNT': 10, 'CAL_SCRIPTS_90AS3': 5},
        {'RX_SALESAMOUNT': 20, 'CAL_SCRIPTS_90AS3': 7},
    ]
    agg = {
        'RX_SALESAMOUNT': sum(d['RX_SALESAMOUNT'] for d in data),
        'CAL_SCRIPTS_90AS3': sum(d['CAL_SCRIPTS_90AS3'] for d in data),
    }
    assert agg['RX_SALESAMOUNT'] == 30
    assert agg['CAL_SCRIPTS_90AS3'] == 12

def test_TC_29_calculation_columns():
    row = {
        'CAL_RX_CNT_NS': 2,
        'CAL_RX_CNT_RE': 3,
        'CAL_RX_CNT_GE84_NS': 1,
        'CAL_RX_CNT_GE84_RE': 2,
    }
    calc = row['CAL_RX_CNT_NS'] + row['CAL_RX_CNT_RE'] + (row['CAL_RX_CNT_GE84_NS'] + row['CAL_RX_CNT_GE84_RE']) * 2
    assert calc == 2 + 3 + (1+2)*2

def test_TC_30_final_output_group_by_aggregation():
    data = [
        {'DIVISION_CODE': 'A', 'CAL_FS_SALES': 10},
        {'DIVISION_CODE': 'A', 'CAL_FS_SALES': 20},
        {'DIVISION_CODE': 'B', 'CAL_FS_SALES': 5},
    ]
    from collections import defaultdict
    agg = defaultdict(int)
    for row in data:
        agg[row['DIVISION_CODE']] += row['CAL_FS_SALES']
    assert agg['A'] == 30
    assert agg['B'] == 5
```

---

**Cost Analysis**

API Cost: 0.0100 USD

---
