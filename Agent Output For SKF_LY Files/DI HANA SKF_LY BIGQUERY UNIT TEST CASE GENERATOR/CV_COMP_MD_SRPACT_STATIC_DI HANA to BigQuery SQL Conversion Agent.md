# Unit Test Case Summary

| Test Case ID | Test Scenario | Input/Data Condition | Expected Result | Validation |
| ------------ | ------------- | -------------------- | --------------- | ---------- |
| TC_01 | Validate 1:1 column mapping for all attribute columns | Source table contains a row with known values for all attribute columns; measures set to 0 | Output row contains exactly the same values for all attribute columns; measures aggregated as 0 | Check that each attribute column in the output matches the source for a single-row group |
| TC_02 | Validate SUM aggregation for measure columns | Multiple rows with same group-by attributes, different measure values | Output row contains sum of measure columns for the group, attributes match group-by values | Assert that SUM(RX_HRS_OPER), SUM(FS_HRS_OPER), SUM(RX_STORE), SUM(RETAIL_SQFT_AMT), SUM(TOTAL_SQFT_AMT) are correct for each group |
| TC_03 | Validate GROUP BY logic for all attribute columns | Two or more distinct groups in attribute columns, distinct measure values | Each group is aggregated separately, producing one row per unique group | Assert that output contains one row per unique group of attribute columns |
| TC_04 | Validate handling of NULL values in attribute columns | Source rows where some attribute columns are NULL | Output groups rows with NULLs in attribute columns as separate groups | Assert that NULLs in group-by columns result in separate groups |
| TC_05 | Validate handling of NULL values in measure columns | Source rows where measure columns are NULL | Output sums NULLs as 0 if all are NULL, or ignores NULLs in SUM | Assert that SUM of all NULLs is 0, otherwise SUM ignores NULLs |
| TC_06 | Validate output column order | Source with all columns populated | Output columns appear in exact order as defined in SQL (attributes, then measures) | Assert output column order matches SQL definition |
| TC_07 | Validate no filters are applied | Source contains rows that would be filtered if there were filters | All rows are included in aggregation; no data is excluded | Assert that all source rows are present in the aggregated output |
| TC_08 | Validate no calculated columns or expressions | Source with known values | Output does not contain any columns not present in source; no expressions/calculations applied | Assert that only source columns (with SUM for measures) appear in output |
| TC_09 | Validate output when source table is empty | Source table has 0 rows | Output is empty (no rows) | Assert output is empty |
| TC_10 | Validate output when source table has only NULLs in group-by columns | All attribute columns NULL, measure columns populated | Output groups all-NULL attributes as one group, aggregates measures | Assert output has one row with all-NULL attributes and SUM of measures |
| TC_11 | Validate column name preservation (including typos) | Source table has column REGIION_COST_CENTER (with typo) | Output contains column with typo, values mapped as in source | Assert output column name matches typo in source |

# Pytest Script

```python
import pytest

# Mock functions to simulate SQL output
# These are simple Python dict/list mocks to represent the output of the SQL transformation

def run_sql_transformation(source_rows):
    # Simulate the GROUP BY and SUM aggregation logic
    # Group by all attribute columns, aggregate measure columns
    attribute_cols = [
        'MANDT', 'STRNUM', 'PRCTR', 'KOKRS', 'KOSTL', 'RX_OPEN_DAT', 'RX_CLOSE_DAT', 'FS_OPEN_DAT', 'FS_CLOSE_DAT',
        'REP_MKT_CODE', 'REP_MKT_DESC', 'ADDRESS', 'CITY', 'STATE', 'ZIPCODE', 'DIVISION_CODE', 'DIVISION_DESC',
        'DIVISION_MGR', 'AREA_CODE', 'AREA_DESC', 'AREA_MGR', 'REGION_CODE', 'REGION_DESC', 'REGION_MGR',
        'DISTRICT_CODE', 'DISTRICT_DESC', 'ZONE_CODE', 'DISTRICT_MGR', 'ZONE_DESC', 'MAJOR_REGION_CODE', 'MAJOR_REGION',
        'STORE_TYPE', 'STORE_TYPE_DESC', 'RX_STORE_DESC', 'DISTRIBUTION_CNTR', 'DISTRIBUTION_CNTR_DESC', 'STORE_24_HR',
        'BUDGET_OPEN_DAT', 'BUDGET_CLOSED_DAT', 'BUDGET_RELOC_DAT', 'CONST_OPEN_DAT', 'CONST_CLOSE_DAT', 'CONST_RELO_DAT',
        'RELOCATION_DAT', 'EMERG_MKT_IND', 'BUDGET_EMERG_MKT_IND', 'COMPANY_CODE', 'COMPANY_CODE_DESC',
        'ORIGINAL_FS_OPEN_DAT', 'ORIGINAL_RX_OPEN_DAT', 'GROUP_ONE', 'GROUP_TWO', 'ARD_SORT_KEY', 'AREA_COST_CENTER',
        'REGIION_COST_CENTER', 'COUNTY_CODE', 'COUNTY_DESC', 'SQFT_BRACKET_DESC', 'SQFT_SORT_KEY', 'ACQUISITION_CODE',
        'ACQUISITION_DESC', 'PHOTO_LAB_ADD_DAT', 'PHOTO_LAB_CLOSE_DAT', 'MIN_HRS_IND', 'CREATEDBY', 'CREATED_ON',
        'RX_DIVISION_CODE', 'RX_AREA_CODE', 'RX_REGION_CODE', 'RX_DISTRICT_CODE'
    ]
    measure_cols = [
        'RX_HRS_OPER', 'FS_HRS_OPER', 'RX_STORE', 'RETAIL_SQFT_AMT', 'TOTAL_SQFT_AMT'
    ]
    grouped = {}
    for row in source_rows:
        key = tuple(row.get(col) for col in attribute_cols)
        if key not in grouped:
            grouped[key] = {col: row.get(col) for col in attribute_cols}
            for m in measure_cols:
                grouped[key][m] = 0
        for m in measure_cols:
            val = row.get(m)
            if val is not None:
                grouped[key][m] += val
    # For SUM, BigQuery returns 0 if all values are NULL; simulate this
    for key, out_row in grouped.items():
        for m in measure_cols:
            if all(row.get(m) is None for row in source_rows if tuple(row.get(col) for col in attribute_cols) == key):
                out_row[m] = 0
    return list(grouped.values())

# Test cases

def test_TC_01_column_mapping():
    source = [{
        'MANDT': '100', 'STRNUM': '001', 'PRCTR': 'P1', 'KOKRS': 'K1', 'KOSTL': 'C1',
        'RX_OPEN_DAT': '2021-01-01', 'RX_CLOSE_DAT': None, 'FS_OPEN_DAT': '2021-02-01', 'FS_CLOSE_DAT': None,
        'REP_MKT_CODE': 'MKT1', 'REP_MKT_DESC': 'Market 1', 'ADDRESS': '123 Main St', 'CITY': 'CityA', 'STATE': 'CA',
        'ZIPCODE': '90001', 'DIVISION_CODE': 'D1', 'DIVISION_DESC': 'Div1', 'DIVISION_MGR': 'Mgr1', 'AREA_CODE': 'A1',
        'AREA_DESC': 'Area1', 'AREA_MGR': 'AM1', 'REGION_CODE': 'R1', 'REGION_DESC': 'Reg1', 'REGION_MGR': 'RM1',
        'DISTRICT_CODE': 'DC1', 'DISTRICT_DESC': 'Dist1', 'ZONE_CODE': 'Z1', 'DISTRICT_MGR': 'DM1', 'ZONE_DESC': 'Zone1',
        'MAJOR_REGION_CODE': 'MR1', 'MAJOR_REGION': 'Major1', 'STORE_TYPE': 'S1', 'STORE_TYPE_DESC': 'Type1',
        'RX_STORE_DESC': 'Desc1', 'DISTRIBUTION_CNTR': 'CN1', 'DISTRIBUTION_CNTR_DESC': 'DescCN1', 'STORE_24_HR': 'Y',
        'BUDGET_OPEN_DAT': None, 'BUDGET_CLOSED_DAT': None, 'BUDGET_RELOC_DAT': None, 'CONST_OPEN_DAT': None,
        'CONST_CLOSE_DAT': None, 'CONST_RELO_DAT': None, 'RELOCATION_DAT': None, 'EMERG_MKT_IND': None,
        'BUDGET_EMERG_MKT_IND': None, 'COMPANY_CODE': 'CC1', 'COMPANY_CODE_DESC': 'Company1',
        'ORIGINAL_FS_OPEN_DAT': None, 'ORIGINAL_RX_OPEN_DAT': None, 'GROUP_ONE': 'G1', 'GROUP_TWO': 'G2',
        'ARD_SORT_KEY': 'SK1', 'AREA_COST_CENTER': 'ACC1', 'REGIION_COST_CENTER': 'RCC1', 'COUNTY_CODE': 'CO1',
        'COUNTY_DESC': 'County1', 'SQFT_BRACKET_DESC': 'Small', 'SQFT_SORT_KEY': '1', 'ACQUISITION_CODE': 'AC1',
        'ACQUISITION_DESC': 'Acq1', 'PHOTO_LAB_ADD_DAT': None, 'PHOTO_LAB_CLOSE_DAT': None, 'MIN_HRS_IND': None,
        'CREATEDBY': 'user1', 'CREATED_ON': '2023-01-01', 'RX_DIVISION_CODE': 'RXD1', 'RX_AREA_CODE': 'RXA1',
        'RX_REGION_CODE': 'RXR1', 'RX_DISTRICT_CODE': 'RXDC1',
        'RX_HRS_OPER': 0, 'FS_HRS_OPER': 0, 'RX_STORE': 0, 'RETAIL_SQFT_AMT': 0, 'TOTAL_SQFT_AMT': 0
    }]
    result = run_sql_transformation(source)
    assert len(result) == 1
    for col in source[0]:
        assert result[0][col] == source[0][col]

def test_TC_02_measure_aggregation():
    group = {
        'MANDT': '100', 'STRNUM': '001', 'PRCTR': 'P1', 'KOKRS': 'K1', 'KOSTL': 'C1',
        'RX_OPEN_DAT': '2021-01-01', 'RX_CLOSE_DAT': None, 'FS_OPEN_DAT': '2021-02-01', 'FS_CLOSE_DAT': None,
        'REP_MKT_CODE': 'MKT1', 'REP_MKT_DESC': 'Market 1', 'ADDRESS': '123 Main St', 'CITY': 'CityA', 'STATE': 'CA',
        'ZIPCODE': '90001', 'DIVISION_CODE': 'D1', 'DIVISION_DESC': 'Div1', 'DIVISION_MGR': 'Mgr1', 'AREA_CODE': 'A1',
        'AREA_DESC': 'Area1', 'AREA_MGR': 'AM1', 'REGION_CODE': 'R1', 'REGION_DESC': 'Reg1', 'REGION_MGR': 'RM1',
        'DISTRICT_CODE': 'DC1', 'DISTRICT_DESC': 'Dist1', 'ZONE_CODE': 'Z1', 'DISTRICT_MGR': 'DM1', 'ZONE_DESC': 'Zone1',
        'MAJOR_REGION_CODE': 'MR1', 'MAJOR_REGION': 'Major1', 'STORE_TYPE': 'S1', 'STORE_TYPE_DESC': 'Type1',
        'RX_STORE_DESC': 'Desc1', 'DISTRIBUTION_CNTR': 'CN1', 'DISTRIBUTION_CNTR_DESC': 'DescCN1', 'STORE_24_HR': 'Y',
        'BUDGET_OPEN_DAT': None, 'BUDGET_CLOSED_DAT': None, 'BUDGET_RELOC_DAT': None, 'CONST_OPEN_DAT': None,
        'CONST_CLOSE_DAT': None, 'CONST_RELO_DAT': None, 'RELOCATION_DAT': None, 'EMERG_MKT_IND': None,
        'BUDGET_EMERG_MKT_IND': None, 'COMPANY_CODE': 'CC1', 'COMPANY_CODE_DESC': 'Company1',
        'ORIGINAL_FS_OPEN_DAT': None, 'ORIGINAL_RX_OPEN_DAT': None, 'GROUP_ONE': 'G1', 'GROUP_TWO': 'G2',
        'ARD_SORT_KEY': 'SK1', 'AREA_COST_CENTER': 'ACC1', 'REGIION_COST_CENTER': 'RCC1', 'COUNTY_CODE': 'CO1',
        'COUNTY_DESC': 'County1', 'SQFT_BRACKET_DESC': 'Small', 'SQFT_SORT_KEY': '1', 'ACQUISITION_CODE': 'AC1',
        'ACQUISITION_DESC': 'Acq1', 'PHOTO_LAB_ADD_DAT': None, 'PHOTO_LAB_CLOSE_DAT': None, 'MIN_HRS_IND': None,
        'CREATEDBY': 'user1', 'CREATED_ON': '2023-01-01', 'RX_DIVISION_CODE': 'RXD1', 'RX_AREA_CODE': 'RXA1',
        'RX_REGION_CODE': 'RXR1', 'RX_DISTRICT_CODE': 'RXDC1'
    }
    row1 = dict(group)
    row1.update({'RX_HRS_OPER': 4, 'FS_HRS_OPER': 3, 'RX_STORE': 1, 'RETAIL_SQFT_AMT': 100, 'TOTAL_SQFT_AMT': 200})
    row2 = dict(group)
    row2.update({'RX_HRS_OPER': 6, 'FS_HRS_OPER': 2, 'RX_STORE': 0, 'RETAIL_SQFT_AMT': 150, 'TOTAL_SQFT_AMT': 250})
    result = run_sql_transformation([row1, row2])
    assert len(result) == 1
    assert result[0]['RX_HRS_OPER'] == 10
    assert result[0]['FS_HRS_OPER'] == 5
    assert result[0]['RX_STORE'] == 1
    assert result[0]['RETAIL_SQFT_AMT'] == 250
    assert result[0]['TOTAL_SQFT_AMT'] == 450

def test_TC_03_group_by_logic():
    group1 = {'MANDT': '100', 'STRNUM': '001', 'PRCTR': 'P1', 'KOKRS': 'K1', 'KOSTL': 'C1',
              'RX_OPEN_DAT': '2021-01-01', 'FS_OPEN_DAT': '2021-02-01', 'RX_CLOSE_DAT': None, 'FS_CLOSE_DAT': None,
              'REP_MKT_CODE': 'MKT1', 'REP_MKT_DESC': 'Market 1', 'ADDRESS': '123 Main St', 'CITY': 'CityA', 'STATE': 'CA',
              'ZIPCODE': '90001', 'DIVISION_CODE': 'D1', 'DIVISION_DESC': 'Div1', 'DIVISION_MGR': 'Mgr1', 'AREA_CODE': 'A1',
              'AREA_DESC': 'Area1', 'AREA_MGR': 'AM1', 'REGION_CODE': 'R1', 'REGION_DESC': 'Reg1', 'REGION_MGR': 'RM1',
              'DISTRICT_CODE': 'DC1', 'DISTRICT_DESC': 'Dist1', 'ZONE_CODE': 'Z1', 'DISTRICT_MGR': 'DM1', 'ZONE_DESC': 'Zone1',
              'MAJOR_REGION_CODE': 'MR1', 'MAJOR_REGION': 'Major1', 'STORE_TYPE': 'S1', 'STORE_TYPE_DESC': 'Type1',
              'RX_STORE_DESC': 'Desc1', 'DISTRIBUTION_CNTR': 'CN1', 'DISTRIBUTION_CNTR_DESC': 'DescCN1', 'STORE_24_HR': 'Y',
              'BUDGET_OPEN_DAT': None, 'BUDGET_CLOSED_DAT': None, 'BUDGET_RELOC_DAT': None, 'CONST_OPEN_DAT': None,
              'CONST_CLOSE_DAT': None, 'CONST_RELO_DAT': None, 'RELOCATION_DAT': None, 'EMERG_MKT_IND': None,
              'BUDGET_EMERG_MKT_IND': None, 'COMPANY_CODE': 'CC1', 'COMPANY_CODE_DESC': 'Company1',
              'ORIGINAL_FS_OPEN_DAT': None, 'ORIGINAL_RX_OPEN_DAT': None, 'GROUP_ONE': 'G1', 'GROUP_TWO': 'G2',
              'ARD_SORT_KEY': 'SK1', 'AREA_COST_CENTER': 'ACC1', 'REGIION_COST_CENTER': 'RCC1', 'COUNTY_CODE': 'CO1',
              'COUNTY_DESC': 'County1', 'SQFT_BRACKET_DESC': 'Small', 'SQFT_SORT_KEY': '1', 'ACQUISITION_CODE': 'AC1',
              'ACQUISITION_DESC': 'Acq1', 'PHOTO_LAB_ADD_DAT': None, 'PHOTO_LAB_CLOSE_DAT': None, 'MIN_HRS_IND': None,
              'CREATEDBY': 'user1', 'CREATED_ON': '2023-01-01', 'RX_DIVISION_CODE': 'RXD1', 'RX_AREA_CODE': 'RXA1',
              'RX_REGION_CODE': 'RXR1', 'RX_DISTRICT_CODE': 'RXDC1',
              'RX_HRS_OPER': 5, 'FS_HRS_OPER': 2, 'RX_STORE': 1, 'RETAIL_SQFT_AMT': 50, 'TOTAL_SQFT_AMT': 100}
    group2 = dict(group1)
    group2['MANDT'] = '200'  # different group
    group2['RX_HRS_OPER'] = 7
    group2['FS_HRS_OPER'] = 1
    group2['RX_STORE'] = 2
    group2['RETAIL_SQFT_AMT'] = 60
    group2['TOTAL_SQFT_AMT'] = 110
    result = run_sql_transformation([group1, group2])
    assert len(result) == 2
    assert any(r['MANDT'] == '100' and r['RX_HRS_OPER'] == 5 for r in result)
    assert any(r['MANDT'] == '200' and r['RX_HRS_OPER'] == 7 for r in result)

def test_TC_04_nulls_in_attributes():
    row1 = {'MANDT': None, 'STRNUM': '001', 'PRCTR': 'P1', 'KOKRS': 'K1', 'KOSTL': 'C1',
            'RX_OPEN_DAT': '2021-01-01', 'FS_OPEN_DAT': '2021-02-01', 'RX_CLOSE_DAT': None, 'FS_CLOSE_DAT': None,
            'REP_MKT_CODE': 'MKT1', 'REP_MKT_DESC': 'Market 1', 'ADDRESS': '123 Main St', 'CITY': 'CityA', 'STATE': 'CA',
            'ZIPCODE': '90001', 'DIVISION_CODE': 'D1', 'DIVISION_DESC': 'Div1', 'DIVISION_MGR': 'Mgr1', 'AREA_CODE': 'A1',
            'AREA_DESC': 'Area1', 'AREA_MGR': 'AM1', 'REGION_CODE': 'R1', 'REGION_DESC': 'Reg1', 'REGION_MGR': 'RM1',
            'DISTRICT_CODE': 'DC1', 'DISTRICT_DESC': 'Dist1', 'ZONE_CODE': 'Z1', 'DISTRICT_MGR': 'DM1', 'ZONE_DESC': 'Zone1',
            'MAJOR_REGION_CODE': 'MR1', 'MAJOR_REGION': 'Major1', 'STORE_TYPE': 'S1', 'STORE_TYPE_DESC': 'Type1',
            'RX_STORE_DESC': 'Desc1', 'DISTRIBUTION_CNTR': 'CN1', 'DISTRIBUTION_CNTR_DESC': 'DescCN1', 'STORE_24_HR': 'Y',
            'BUDGET_OPEN_DAT': None, 'BUDGET_CLOSED_DAT': None, 'BUDGET_RELOC_DAT': None, 'CONST_OPEN_DAT': None,
            'CONST_CLOSE_DAT': None, 'CONST_RELO_DAT': None, 'RELOCATION_DAT': None, 'EMERG_MKT_IND': None,
            'BUDGET_EMERG_MKT_IND': None, 'COMPANY_CODE': 'CC1', 'COMPANY_CODE_DESC': 'Company1',
            'ORIGINAL_FS_OPEN_DAT': None, 'ORIGINAL_RX_OPEN_DAT': None, 'GROUP_ONE': 'G1', 'GROUP_TWO': 'G2',
            'ARD_SORT_KEY': 'SK1', 'AREA_COST_CENTER': 'ACC1', 'REGIION_COST_CENTER': 'RCC1', 'COUNTY_CODE': 'CO1',
            'COUNTY_DESC': 'County1', 'SQFT_BRACKET_DESC': 'Small', 'SQFT_SORT_KEY': '1', 'ACQUISITION_CODE': 'AC1',
            'ACQUISITION_DESC': 'Acq1', 'PHOTO_LAB_ADD_DAT': None, 'PHOTO_LAB_CLOSE_DAT': None, 'MIN_HRS_IND': None,
            'CREATEDBY': 'user1', 'CREATED_ON': '2023-01-01', 'RX_DIVISION_CODE': 'RXD1', 'RX_AREA_CODE': 'RXA1',
            'RX_REGION_CODE': 'RXR1', 'RX_DISTRICT_CODE': 'RXDC1',
            'RX_HRS_OPER': 2, 'FS_HRS_OPER': 1, 'RX_STORE': 1, 'RETAIL_SQFT_AMT': 10, 'TOTAL_SQFT_AMT': 20}
    row2 = dict(row1)
    row2['MANDT'] = '100'  # not NULL, so different group
    result = run_sql_transformation([row1, row2])
    assert len(result) == 2
    assert any(r['MANDT'] is None for r in result)
    assert any(r['MANDT'] == '100' for r in result)

def test_TC_05_nulls_in_measures():
    row1 = {'MANDT': '100', 'STRNUM': '001', 'PRCTR': 'P1', 'KOKRS': 'K1', 'KOSTL': 'C1',
            'RX_OPEN_DAT': '2021-01-01', 'FS_OPEN_DAT': '2021-02-01', 'RX_CLOSE_DAT': None, 'FS_CLOSE_DAT': None,
            'REP_MKT_CODE': 'MKT1', 'REP_MKT_DESC': 'Market 1', 'ADDRESS': '123 Main St', 'CITY': 'CityA', 'STATE': 'CA',
            'ZIPCODE': '90001', 'DIVISION_CODE': 'D1', 'DIVISION_DESC': 'Div1', 'DIVISION_MGR': 'Mgr1', 'AREA_CODE': 'A1',
            'AREA_DESC': 'Area1', 'AREA_MGR': 'AM1', 'REGION_CODE': 'R1', 'REGION_DESC': 'Reg1', 'REGION_MGR': 'RM1',
            'DISTRICT_CODE': 'DC1', 'DISTRICT_DESC': 'Dist1', 'ZONE_CODE': 'Z1', 'DISTRICT_MGR': 'DM1', 'ZONE_DESC': 'Zone1',
            'MAJOR_REGION_CODE': 'MR1', 'MAJOR_REGION': 'Major1', 'STORE_TYPE': 'S1', 'STORE_TYPE_DESC': 'Type1',
            'RX_STORE_DESC': 'Desc1', 'DISTRIBUTION_CNTR': 'CN1', 'DISTRIBUTION_CNTR_DESC': 'DescCN1', 'STORE_24_HR': 'Y',
            'BUDGET_OPEN_DAT': None, 'BUDGET_CLOSED_DAT': None, 'BUDGET_RELOC_DAT': None, 'CONST_OPEN_DAT': None,
            'CONST_CLOSE_DAT': None, 'CONST_RELO_DAT': None, 'RELOCATION_DAT': None, 'EMERG_MKT_IND': None,
            'BUDGET_EMERG_MKT_IND': None, 'COMPANY_CODE': 'CC1', 'COMPANY_CODE_DESC': 'Company1',
            'ORIGINAL_FS_OPEN_DAT': None, 'ORIGINAL_RX_OPEN_DAT': None, 'GROUP_ONE': 'G1', 'GROUP_TWO': 'G2',
            'ARD_SORT_KEY': 'SK1', 'AREA_COST_CENTER': 'ACC1', 'REGIION_COST_CENTER': 'RCC1', 'COUNTY_CODE': 'CO1',
            'COUNTY_DESC': 'County1', 'SQFT_BRACKET_DESC': 'Small', 'SQFT_SORT_KEY': '1', 'ACQUISITION_CODE': 'AC1',
            'ACQUISITION_DESC': 'Acq1', 'PHOTO_LAB_ADD_DAT': None, 'PHOTO_LAB_CLOSE_DAT': None, 'MIN_HRS_IND': None,
            'CREATEDBY': 'user1', 'CREATED_ON': '2023-01-01', 'RX_DIVISION_CODE': 'RXD1', 'RX_AREA_CODE': 'RXA1',
            'RX_REGION_CODE': 'RXR1', 'RX_DISTRICT_CODE': 'RXDC1',
            'RX_HRS_OPER': None, 'FS_HRS_OPER': None, 'RX_STORE': None, 'RETAIL_SQFT_AMT': None, 'TOTAL_SQFT_AMT': None}
    row2 = dict(row1)
    row2['RX_HRS_OPER'] = 5
    row2['FS_HRS_OPER'] = None
    row2['RX_STORE'] = 2
    row2['RETAIL_SQFT_AMT'] = 10
    row2['TOTAL_SQFT_AMT'] = 20
    # All measures NULL in row1, some not NULL in row2
    result = run_sql_transformation([row1, row2])
    assert len(result) == 1
    # SUM ignores NULLs, so result should be as in row2
    assert result[0]['RX_HRS_OPER'] == 5
    assert result[0]['FS_HRS_OPER'] == 0
    assert result[0]['RX_STORE'] == 2
    assert result[0]['RETAIL_SQFT_AMT'] == 10
    assert result[0]['TOTAL_SQFT_AMT'] == 20
    # Now test all NULLs
    result = run_sql_transformation([row1])
    assert result[0]['RX_HRS_OPER'] == 0
    assert result[0]['FS_HRS_OPER'] == 0
    assert result[0]['RX_STORE'] == 0
    assert result[0]['RETAIL_SQFT_AMT'] == 0
    assert result[0]['TOTAL_SQFT_AMT'] == 0

def test_TC_06_column_order():
    source = [{col: idx for idx, col in enumerate([
        'MANDT', 'STRNUM', 'PRCTR', 'KOKRS', 'KOSTL', 'RX_OPEN_DAT', 'RX_CLOSE_DAT', 'FS_OPEN_DAT', 'FS_CLOSE_DAT',
        'REP_MKT_CODE', 'REP_MKT_DESC', 'ADDRESS', 'CITY', 'STATE', 'ZIPCODE', 'DIVISION_CODE', 'DIVISION_DESC',
        'DIVISION_MGR', 'AREA_CODE', 'AREA_DESC', 'AREA_MGR', 'REGION_CODE', 'REGION_DESC', 'REGION_MGR',
        'DISTRICT_CODE', 'DISTRICT_DESC', 'ZONE_CODE', 'DISTRICT_MGR', 'ZONE_DESC', 'MAJOR_REGION_CODE', 'MAJOR_REGION',
        'STORE_TYPE', 'STORE_TYPE_DESC', 'RX_STORE_DESC', 'DISTRIBUTION_CNTR', 'DISTRIBUTION_CNTR_DESC', 'STORE_24_HR',
        'BUDGET_OPEN_DAT', 'BUDGET_CLOSED_DAT', 'BUDGET_RELOC_DAT', 'CONST_OPEN_DAT', 'CONST_CLOSE_DAT', 'CONST_RELO_DAT',
        'RELOCATION_DAT', 'EMERG_MKT_IND', 'BUDGET_EMERG_MKT_IND', 'COMPANY_CODE', 'COMPANY_CODE_DESC',
        'ORIGINAL_FS_OPEN_DAT', 'ORIGINAL_RX_OPEN_DAT', 'GROUP_ONE', 'GROUP_TWO', 'ARD_SORT_KEY', 'AREA_COST_CENTER',
        'REGIION_COST_CENTER', 'COUNTY_CODE', 'COUNTY_DESC', 'SQFT_BRACKET_DESC', 'SQFT_SORT_KEY', 'ACQUISITION_CODE',
        'ACQUISITION_DESC', 'PHOTO_LAB_ADD_DAT', 'PHOTO_LAB_CLOSE_DAT', 'MIN_HRS_IND', 'CREATEDBY', 'CREATED_ON',
        'RX_DIVISION_CODE', 'RX_AREA_CODE', 'RX_REGION_CODE', 'RX_DISTRICT_CODE',
        'RX_HRS_OPER', 'FS_HRS_OPER', 'RX_STORE', 'RETAIL_SQFT_AMT', 'TOTAL_SQFT_AMT'
    ])}]
    result = run_sql_transformation(source)
    output_cols = list(result[0].keys())
    expected_order = [
        'MANDT', 'STRNUM', 'PRCTR', 'KOKRS', 'KOSTL', 'RX_OPEN_DAT', 'RX_CLOSE_DAT', 'FS_OPEN_DAT', 'FS_CLOSE_DAT',
        'REP_MKT_CODE', 'REP_MKT_DESC', 'ADDRESS', 'CITY', 'STATE', 'ZIPCODE', 'DIVISION_CODE', 'DIVISION_DESC',
        'DIVISION_MGR', 'AREA_CODE', 'AREA_DESC', 'AREA_MGR', 'REGION_CODE', 'REGION_DESC', 'REGION_MGR',
        'DISTRICT_CODE', 'DISTRICT_DESC', 'ZONE_CODE', 'DISTRICT_MGR', 'ZONE_DESC', 'MAJOR_REGION_CODE', 'MAJOR_REGION',
        'STORE_TYPE', 'STORE_TYPE_DESC', 'RX_STORE_DESC', 'DISTRIBUTION_CNTR', 'DISTRIBUTION_CNTR_DESC', 'STORE_24_HR',
        'BUDGET_OPEN_DAT', 'BUDGET_CLOSED_DAT', 'BUDGET_RELOC_DAT', 'CONST_OPEN_DAT', 'CONST_CLOSE_DAT', 'CONST_RELO_DAT',
        'RELOCATION_DAT', 'EMERG_MKT_IND', 'BUDGET_EMERG_MKT_IND', 'COMPANY_CODE', 'COMPANY_CODE_DESC',
        'ORIGINAL_FS_OPEN_DAT', 'ORIGINAL_RX_OPEN_DAT', 'GROUP_ONE', 'GROUP_TWO', 'ARD_SORT_KEY', 'AREA_COST_CENTER',
        'REGIION_COST_CENTER', 'COUNTY_CODE', 'COUNTY_DESC', 'SQFT_BRACKET_DESC', 'SQFT_SORT_KEY', 'ACQUISITION_CODE',
        'ACQUISITION_DESC', 'PHOTO_LAB_ADD_DAT', 'PHOTO_LAB_CLOSE_DAT', 'MIN_HRS_IND', 'CREATEDBY', 'CREATED_ON',
        'RX_DIVISION_CODE', 'RX_AREA_CODE', 'RX_REGION_CODE', 'RX_DISTRICT_CODE',
        'RX_HRS_OPER', 'FS_HRS_OPER', 'RX_STORE', 'RETAIL_SQFT_AMT', 'TOTAL_SQFT_AMT'
    ]
    assert output_cols == expected_order

def test_TC_07_no_filters():
    # If there were a filter on STATE, some rows would be excluded, but all rows must be present
    row1 = {'MANDT': '100', 'STRNUM': '001', 'PRCTR': 'P1', 'KOKRS': 'K1', 'KOSTL': 'C1', 'STATE': 'CA',
            'RX_OPEN_DAT': '2021-01-01', 'FS_OPEN_DAT': '2021-02-01', 'RX_CLOSE_DAT': None, 'FS_CLOSE_DAT': None,
            'REP_MKT_CODE': 'MKT1', 'REP_MKT_DESC': 'Market 1', 'ADDRESS': '123 Main St', 'CITY': 'CityA',
            'ZIPCODE': '90001', 'DIVISION_CODE': 'D1', 'DIVISION_DESC': 'Div1', 'DIVISION_MGR': 'Mgr1', 'AREA_CODE': 'A1',
            'AREA_DESC': 'Area1', 'AREA_MGR': 'AM1', 'REGION_CODE': 'R1', 'REGION_DESC': 'Reg1', 'REGION_MGR': 'RM1',
            'DISTRICT_CODE': 'DC1', 'DISTRICT_DESC': 'Dist1', 'ZONE_CODE': 'Z1', 'DISTRICT_MGR': 'DM1', 'ZONE_DESC': 'Zone1',
            'MAJOR_REGION_CODE': 'MR1', 'MAJOR_REGION': 'Major1', 'STORE_TYPE': 'S1', 'STORE_TYPE_DESC': 'Type1',
            'RX_STORE_DESC': 'Desc1', 'DISTRIBUTION_CNTR': 'CN1', 'DISTRIBUTION_CNTR_DESC': 'DescCN1', 'STORE_24_HR': 'Y',
            'BUDGET_OPEN_DAT': None, 'BUDGET_CLOSED_DAT': None, 'BUDGET_RELOC_DAT': None, 'CONST_OPEN_DAT': None,
            'CONST_CLOSE_DAT': None, 'CONST_RELO_DAT': None, 'RELOCATION_DAT': None, 'EMERG_MKT_IND': None,
            'BUDGET_EMERG_MKT_IND': None, 'COMPANY_CODE': 'CC1', 'COMPANY_CODE_DESC': 'Company1',
            'ORIGINAL_FS_OPEN_DAT': None, 'ORIGINAL_RX_OPEN_DAT': None, 'GROUP_ONE': 'G1', 'GROUP_TWO': 'G2',
            'ARD_SORT_KEY': 'SK1', 'AREA_COST_CENTER': 'ACC1', 'REGIION_COST_CENTER': 'RCC1', 'COUNTY_CODE': 'CO1',
            'COUNTY_DESC': 'County1', 'SQFT_BRACKET_DESC': 'Small', 'SQFT_SORT_KEY': '1', 'ACQUISITION_CODE': 'AC1',
            'ACQUISITION_DESC': 'Acq1', 'PHOTO_LAB_ADD_DAT': None, 'PHOTO_LAB_CLOSE_DAT': None, 'MIN_HRS_IND': None,
            'CREATEDBY': 'user1', 'CREATED_ON': '2023-01-01', 'RX_DIVISION_CODE': 'RXD1', 'RX_AREA_CODE': 'RXA1',
            'RX_REGION_CODE': 'RXR1', 'RX_DISTRICT_CODE': 'RXDC1',
            'RX_HRS_OPER': 2, 'FS_HRS_OPER': 1, 'RX_STORE': 1, 'RETAIL_SQFT_AMT': 10, 'TOTAL_SQFT_AMT': 20}
    row2 = dict(row1)
    row2['STATE'] = 'TX'  # Different state, should not be filtered out
    result = run_sql_transformation([row1, row2])
    assert len(result) == 2
    assert any(r['STATE'] == 'CA' for r in result)
    assert any(r['STATE'] == 'TX' for r in result)

def test_TC_08_no_calculated_columns():
    row = {'MANDT': '100', 'STRNUM': '001', 'PRCTR': 'P1', 'KOKRS': 'K1', 'KOSTL': 'C1',
           'RX_OPEN_DAT': '2021-01-01', 'FS_OPEN_DAT': '2021-02-01', 'RX_CLOSE_DAT': None, 'FS_CLOSE_DAT': None,
           'REP_MKT_CODE': 'MKT1', 'REP_MKT_DESC': 'Market 1', 'ADDRESS': '123 Main St', 'CITY': 'CityA', 'STATE': 'CA',
           'ZIPCODE': '90001', 'DIVISION_CODE': 'D1', 'DIVISION_DESC': 'Div1', 'DIVISION_MGR': 'Mgr1', 'AREA_CODE': 'A1',
           'AREA_DESC': 'Area1', 'AREA_MGR': 'AM1', 'REGION_CODE': 'R1', 'REGION_DESC': 'Reg1', 'REGION_MGR': 'RM1',
           'DISTRICT_CODE': 'DC1', 'DISTRICT_DESC': 'Dist1', 'ZONE_CODE': 'Z1', 'DISTRICT_MGR': 'DM1', 'ZONE_DESC': 'Zone1',
           'MAJOR_REGION_CODE': 'MR1', 'MAJOR_REGION': 'Major1', 'STORE_TYPE': 'S1', 'STORE_TYPE_DESC': 'Type1',
           'RX_STORE_DESC': 'Desc1', 'DISTRIBUTION_CNTR': 'CN1', 'DISTRIBUTION_CNTR_DESC': 'DescCN1', 'STORE_24_HR': 'Y',
           'BUDGET_OPEN_DAT': None, 'BUDGET_CLOSED_DAT': None, 'BUDGET_RELOC_DAT': None, 'CONST_OPEN_DAT': None,
           'CONST_CLOSE_DAT': None, 'CONST_RELO_DAT': None, 'RELOCATION_DAT': None, 'EMERG_MKT_IND': None,
           'BUDGET_EMERG_MKT_IND': None, 'COMPANY_CODE': 'CC1', 'COMPANY_CODE_DESC': 'Company1',
           'ORIGINAL_FS_OPEN_DAT': None, 'ORIGINAL_RX_OPEN_DAT': None, 'GROUP_ONE': 'G1', 'GROUP_TWO': 'G2',
           'ARD_SORT_KEY': 'SK1', 'AREA_COST_CENTER': 'ACC1', 'REGIION_COST_CENTER': 'RCC1', 'COUNTY_CODE': 'CO1',
           'COUNTY_DESC': 'County1', 'SQFT_BRACKET_DESC': 'Small', 'SQFT_SORT_KEY': '1', 'ACQUISITION_CODE': 'AC1',
           'ACQUISITION_DESC': 'Acq1', 'PHOTO_LAB_ADD_DAT': None, 'PHOTO_LAB_CLOSE_DAT': None, 'MIN_HRS_IND': None,
           'CREATEDBY': 'user1', 'CREATED_ON': '2023-01-01', 'RX_DIVISION_CODE': 'RXD1', 'RX_AREA_CODE': 'RXA1',
           'RX_REGION_CODE': 'RXR1', 'RX_DISTRICT_CODE': 'RXDC1',
           'RX_HRS_OPER': 2, 'FS_HRS_OPER': 1, 'RX_STORE': 1, 'RETAIL_SQFT_AMT': 10, 'TOTAL_SQFT_AMT': 20}
    result = run_sql_transformation([row])
    # Only columns in source plus SUM for measures
    expected_cols = set(row.keys())
    assert set(result[0].keys()) == expected_cols

def test_TC_09_empty_source():
    result = run_sql_transformation([])
    assert result == []

def test_TC_10_all_null_groupby():
    row = {col: None for col in [
        'MANDT', 'STRNUM', 'PRCTR', 'KOKRS', 'KOSTL', 'RX_OPEN_DAT', 'RX_CLOSE_DAT', 'FS_OPEN_DAT', 'FS_CLOSE_DAT',
        'REP_MKT_CODE', 'REP_MKT_DESC', 'ADDRESS', 'CITY', 'STATE', 'ZIPCODE', 'DIVISION_CODE', 'DIVISION_DESC',
        'DIVISION_MGR', 'AREA_CODE', 'AREA_DESC', 'AREA_MGR', 'REGION_CODE', 'REGION_DESC', 'REGION_MGR',
        'DISTRICT_CODE', 'DISTRICT_DESC', 'ZONE_CODE', 'DISTRICT_MGR', 'ZONE_DESC', 'MAJOR_REGION_CODE', 'MAJOR_REGION',
        'STORE_TYPE', 'STORE_TYPE_DESC', 'RX_STORE_DESC', 'DISTRIBUTION_CNTR', 'DISTRIBUTION_CNTR_DESC', 'STORE_24_HR',
        'BUDGET_OPEN_DAT', 'BUDGET_CLOSED_DAT', 'BUDGET_RELOC_DAT', 'CONST_OPEN_DAT', 'CONST_CLOSE_DAT', 'CONST_RELO_DAT',
        'RELOCATION_DAT', 'EMERG_MKT_IND', 'BUDGET_EMERG_MKT_IND', 'COMPANY_CODE', 'COMPANY_CODE_DESC',
        'ORIGINAL_FS_OPEN_DAT', 'ORIGINAL_RX_OPEN_DAT', 'GROUP_ONE', 'GROUP_TWO', 'ARD_SORT_KEY', 'AREA_COST_CENTER',
        'REGIION_COST_CENTER', 'COUNTY_CODE', 'COUNTY_DESC', 'SQFT_BRACKET_DESC', 'SQFT_SORT_KEY', 'ACQUISITION_CODE',
        'ACQUISITION_DESC', 'PHOTO_LAB_ADD_DAT', 'PHOTO_LAB_CLOSE_DAT', 'MIN_HRS_IND', 'CREATEDBY', 'CREATED_ON',
        'RX_DIVISION_CODE', 'RX_AREA_CODE', 'RX_REGION_CODE', 'RX_DISTRICT_CODE'
    ]}
    row['RX_HRS_OPER'] = 5
    row['FS_HRS_OPER'] = 3
    row['RX_STORE'] = 2
    row['RETAIL_SQFT_AMT'] = 10
    row['TOTAL_SQFT_AMT'] = 20
    result = run_sql_transformation([row])
    assert len(result) == 1
    for col in [
        'MANDT', 'STRNUM', 'PRCTR', 'KOKRS', 'KOSTL', 'RX_OPEN_DAT', 'RX_CLOSE_DAT', 'FS_OPEN_DAT', 'FS_CLOSE_DAT',
        'REP_MKT_CODE', 'REP_MKT_DESC', 'ADDRESS', 'CITY', 'STATE', 'ZIPCODE', 'DIVISION_CODE', 'DIVISION_DESC',
        'DIVISION_MGR', 'AREA_CODE', 'AREA_DESC', 'AREA_MGR', 'REGION_CODE', 'REGION_DESC', 'REGION_MGR',
        'DISTRICT_CODE', 'DISTRICT_DESC', 'ZONE_CODE', 'DISTRICT_MGR', 'ZONE_DESC', 'MAJOR_REGION_CODE', 'MAJOR_REGION',
        'STORE_TYPE', 'STORE_TYPE_DESC', 'RX_STORE_DESC', 'DISTRIBUTION_CNTR', 'DISTRIBUTION_CNTR_DESC', 'STORE_24_HR',
        'BUDGET_OPEN_DAT', 'BUDGET_CLOSED_DAT', 'BUDGET_RELOC_DAT', 'CONST_OPEN_DAT', 'CONST_CLOSE_DAT', 'CONST_RELO_DAT',
        'RELOCATION_DAT', 'EMERG_MKT_IND', 'BUDGET_EMERG_MKT_IND', 'COMPANY_CODE', 'COMPANY_CODE_DESC',
        'ORIGINAL_FS_OPEN_DAT', 'ORIGINAL_RX_OPEN_DAT', 'GROUP_ONE', 'GROUP_TWO', 'ARD_SORT_KEY', 'AREA_COST_CENTER',
        'REGIION_COST_CENTER', 'COUNTY_CODE', 'COUNTY_DESC', 'SQFT_BRACKET_DESC', 'SQFT_SORT_KEY', 'ACQUISITION_CODE',
        'ACQUISITION_DESC', 'PHOTO_LAB_ADD_DAT', 'PHOTO_LAB_CLOSE_DAT', 'MIN_HRS_IND', 'CREATEDBY', 'CREATED_ON',
        'RX_DIVISION_CODE', 'RX_AREA_CODE', 'RX_REGION_CODE', 'RX_DISTRICT_CODE'
    ]:
        assert result[0][col] is None
    assert result[0]['RX_HRS_OPER'] == 5
    assert result[0]['FS_HRS_OPER'] == 3
    assert result[0]['RX_STORE'] == 2
    assert result[0]['RETAIL_SQFT_AMT'] == 10
    assert result[0]['TOTAL_SQFT_AMT'] == 20

def test_TC_11_column_name_typo():
    row = {'MANDT': '100', 'STRNUM': '001', 'PRCTR': 'P1', 'KOKRS': 'K1', 'KOSTL': 'C1',
           'RX_OPEN_DAT': '2021-01-01', 'FS_OPEN_DAT': '2021-02-01', 'RX_CLOSE_DAT': None, 'FS_CLOSE_DAT': None,
           'REP_MKT_CODE': 'MKT1', 'REP_MKT_DESC': 'Market 1', 'ADDRESS': '123 Main St', 'CITY': 'CityA', 'STATE': 'CA',
           'ZIPCODE': '90001', 'DIVISION_CODE': 'D1', 'DIVISION_DESC': 'Div1', 'DIVISION_MGR': 'Mgr1', 'AREA_CODE': 'A1',
           'AREA_DESC': 'Area1', 'AREA_MGR': 'AM1', 'REGION_CODE': 'R1', 'REGION_DESC': 'Reg1', 'REGION_MGR': 'RM1',
           'DISTRICT_CODE': 'DC1', 'DISTRICT_DESC': 'Dist1', 'ZONE_CODE': 'Z1', 'DISTRICT_MGR': 'DM1', 'ZONE_DESC': 'Zone1',
           'MAJOR_REGION_CODE': 'MR1', 'MAJOR_REGION': 'Major1', 'STORE_TYPE': 'S1', 'STORE_TYPE_DESC': 'Type1',
           'RX_STORE_DESC': 'Desc1', 'DISTRIBUTION_CNTR': 'CN1', 'DISTRIBUTION_CNTR_DESC': 'DescCN1', 'STORE_24_HR': 'Y',
           'BUDGET_OPEN_DAT': None, 'BUDGET_CLOSED_DAT': None, 'BUDGET_RELOC_DAT': None, 'CONST_OPEN_DAT': None,
           'CONST_CLOSE_DAT': None, 'CONST_RELO_DAT': None, 'RELOCATION_DAT': None, 'EMERG_MKT_IND': None,
           'BUDGET_EMERG_MKT_IND': None, 'COMPANY_CODE': 'CC1', 'COMPANY_CODE_DESC': 'Company1',
           'ORIGINAL_FS_OPEN_DAT': None, 'ORIGINAL_RX_OPEN_DAT': None, 'GROUP_ONE': 'G1', 'GROUP_TWO': 'G2',
           'ARD_SORT_KEY': 'SK1', 'AREA_COST_CENTER': 'ACC1', 'REGIION_COST_CENTER': 'RCC1', 'COUNTY_CODE': 'CO1',
           'COUNTY_DESC': 'County1', 'SQFT_BRACKET_DESC': 'Small', 'SQFT_SORT_KEY': '1', 'ACQUISITION_CODE': 'AC1',
           'ACQUISITION_DESC': 'Acq1', 'PHOTO_LAB_ADD_DAT': None, 'PHOTO_LAB_CLOSE_DAT': None, 'MIN_HRS_IND': None,
           'CREATEDBY': 'user1', 'CREATED_ON': '2023-01-01', 'RX_DIVISION_CODE': 'RXD1', 'RX_AREA_CODE': 'RXA1',
           'RX_REGION_CODE': 'RXR1', 'RX_DISTRICT_CODE': 'RXDC1',
           'RX_HRS_OPER': 2, 'FS_HRS_OPER': 1, 'RX_STORE': 1, 'RETAIL_SQFT_AMT': 10, 'TOTAL_SQFT_AMT': 20}
    result = run_sql_transformation([row])
    assert 'REGIION_COST_CENTER' in result[0]
    assert result[0]['REGIION_COST_CENTER'] == 'RCC1'
```

# Cost Analysis

API Cost: 0.0300 USD
