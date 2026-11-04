
"""
Generate all 5 Parameter Excel files for the consolidated BigQuery SQL files.
Run this script locally to produce the .xlsx files, then upload them.
"""

import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter


def make_excel(filename, rows):
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = "Parameters"

    header_font  = Font(bold=True, color="FFFFFF", size=12)
    header_fill  = PatternFill("solid", fgColor="1F4E79")
    header_align = Alignment(horizontal="center", vertical="center", wrap_text=True)
    thin         = Side(style="thin", color="000000")
    border       = Border(left=thin, right=thin, top=thin, bottom=thin)

    for col, h in enumerate(["Parameter", "Assigned Value"], 1):
        c = ws.cell(row=1, column=col, value=h)
        c.font      = header_font
        c.fill      = header_fill
        c.alignment = header_align
        c.border    = border

    light = PatternFill("solid", fgColor="DCE6F1")
    white = PatternFill("solid", fgColor="FFFFFF")

    for i, (param, value) in enumerate(rows, start=2):
        fill = light if i % 2 == 0 else white
        for col, val in enumerate([param, value], 1):
            c = ws.cell(row=i, column=col, value=val)
            c.alignment = Alignment(wrap_text=True, vertical="top")
            c.border    = border
            c.fill      = fill

    ws.column_dimensions["A"].width = 40
    ws.column_dimensions["B"].width = 90
    ws.row_dimensions[1].height     = 30
    for r in range(2, len(rows) + 2):
        ws.row_dimensions[r].height = 60

    wb.save(filename)
    print(f"Saved: {filename}")


# ─────────────────────────────────────────────────────────────────────────────
# 1. FIN_LY Consolidated File_v1 (1).sql
# ─────────────────────────────────────────────────────────────────────────────
make_excel(
    "FIN_LY Consolidated File_v1 (1)_Parameters.xlsx",
    [
        ("@ip_version",
         "'ACT01'"),
        ("@ip_week_ly",
         "(Select WEEKDATES.LY_WEEK_NBR from WEEKDATES)"),
        ("@ip_week_cy",
         "(Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)"),
        ("@ip_version_comp_flag",
         "'ACT01'"),
        ("@v_week",
         "(Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)"),
    ]
)

# ─────────────────────────────────────────────────────────────────────────────
# 2. MJE_FORECAST_Consolidated_Allinone.sql
# ─────────────────────────────────────────────────────────────────────────────
make_excel(
    "MJE_FORECAST_Consolidated_Allinone_Parameters.xlsx",
    [
        ("@IP_WEEK_ENDING_FROM",
         "NOT ASSIGNED"),
        ("@IP_WEEK_ENDING_TO",
         "NOT ASSIGNED"),
        ("@IP_FIN_VERSION",
         "NOT ASSIGNED"),
        ("@IP_SKF_VERSION",
         "NOT ASSIGNED"),
        ("@IP_VERSION_COMP_FLAG",
         "NOT ASSIGNED"),
    ]
)

# ─────────────────────────────────────────────────────────────────────────────
# 3. RX_BUDGET Consolidated Query_v2.txt
# ─────────────────────────────────────────────────────────────────────────────
make_excel(
    "RX_BUDGET Consolidated Query_v2_Parameters.xlsx",
    [
        ("@ip_version",
         "'LEDGER_BUD'"),
        ("@ip_week_ending_from",
         "(Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)"),
        ("@ip_week_ending_to",
         "(Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)"),
        ("@ip_fc_count",
         "(SELECT FC_CONTROL.IP_FC_COUNT FROM FC_CONTROL)"),
        ("@v_week",
         "(Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)"),
    ]
)

# ─────────────────────────────────────────────────────────────────────────────
# 4. SKF_BUDGET Consolidated File_v2.txt
# ─────────────────────────────────────────────────────────────────────────────
make_excel(
    "SKF_BUDGET Consolidated File_v2_Parameters.xlsx",
    [
        ("@ip_version",
         "'LEDGER_BUD'"),
        ("@ip_week_ending_from",
         "(Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)"),
        ("@ip_week_ending_to",
         "(Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)"),
        ("@ip_fc_count",
         "(SELECT IP_FC_COUNT FROM FC_CONTROL)"),
        ("@v_week",
         "(Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)"),
    ]
)

# ─────────────────────────────────────────────────────────────────────────────
# 5. SKF_LY Consolidated File_v4.txt
# ─────────────────────────────────────────────────────────────────────────────
make_excel(
    "SKF_LY Consolidated File_v4_Parameters.xlsx",
    [
        ("@IP_VERSION",
         "'ACT01'"),
        ("@IP_VERSION_COMP_FLAG",
         "'ACT01'"),
        ("@IP_WEEK_ENDING_FROM",
         "(Select WEEKDATES.LY_WEEK_NBR from WEEKDATES)"),
        ("@IP_WEEK_ENDING_TO",
         "(Select WEEKDATES.LY_WEEK_NBR from WEEKDATES)"),
        ("@IP_WEEK_LY",
         "(Select WEEKDATES.LY_WEEK_NBR from WEEKDATES)"),
        ("@IP_WEEK_CY",
         "(Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)"),
    ]
)
