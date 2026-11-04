
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter
import os

wb = openpyxl.Workbook()
ws = wb.active
ws.title = "Parameters"

# Header style
header_font = Font(bold=True, color="FFFFFF", size=12)
header_fill = PatternFill("solid", fgColor="1F4E79")
header_alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)

thin = Side(style="thin", color="000000")
border = Border(left=thin, right=thin, top=thin, bottom=thin)

headers = ["Parameter", "Assigned Value"]
for col, h in enumerate(headers, 1):
    cell = ws.cell(row=1, column=col, value=h)
    cell.font = header_font
    cell.fill = header_fill
    cell.alignment = header_alignment
    cell.border = border

# Data rows
data = [
    (
        "@ip_version",
        "'ACT01'"
    ),
    (
        "@ip_week_ly",
        "(Select WEEKDATES.LY_WEEK_NBR from WEEKDATES)"
    ),
    (
        "@ip_week_cy",
        "(Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)"
    ),
    (
        "@ip_version_comp_flag",
        "'ACT01'"
    ),
    (
        "@v_week",
        "(Select WEEKDATES.PREV_WEEK_NBR from WEEKDATES)"
    ),
]

row_fill_light = PatternFill("solid", fgColor="DCE6F1")
row_fill_white = PatternFill("solid", fgColor="FFFFFF")

for i, (param, value) in enumerate(data, start=2):
    fill = row_fill_light if i % 2 == 0 else row_fill_white
    cell_p = ws.cell(row=i, column=1, value=param)
    cell_v = ws.cell(row=i, column=2, value=value)
    for cell in [cell_p, cell_v]:
        cell.alignment = Alignment(wrap_text=True, vertical="top")
        cell.border = border
        cell.fill = fill

ws.column_dimensions["A"].width = 35
ws.column_dimensions["B"].width = 80
ws.row_dimensions[1].height = 30

output_path = "FIN_LY Consolidated File_v1 (1)_Parameters.xlsx"
wb.save(output_path)
print(f"Saved: {output_path}")
