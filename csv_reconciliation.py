# =============================================================================
# csv_reconciliation.py
# -----------------------------------------------------------------------------
# PURPOSE  : Full comparative analysis between a Source CSV and a Target CSV.
#            Produces "CSV Reconciliation Report.xlsx" with five sheets:
#              1. Summary
#              2. Column Differences
#              3. Duplicate Keys
#              4. Missing Rows
#              5. Value Mismatches
#
# REQUIRES : pip install pandas openpyxl
# RUN      : python csv_reconciliation.py
# =============================================================================


# =============================================================================
# CONFIG  –  Edit ONLY this block before running
# =============================================================================

# --- File paths --------------------------------------------------------------
SOURCE_FILE = r"C:\Users\kiran.krishnakumar\Downloads\source (1).csv"          # Path to the Source (reference) CSV file
TARGET_FILE = r"C:\Users\kiran.krishnakumar\Downloads\target (1).csv" 
# TARGET_FILE = r"C:\Users\kiran.krishnakumar\Downloads\source.csv"          # Path to the Target (file being checked) CSV file

# --- Key column(s) -----------------------------------------------------------
# List of column name(s) that uniquely identify a row in the SOURCE file.
# Example single key  : KEY_COLUMNS = ["order_id"]
# Example composite   : KEY_COLUMNS = ["order_id", "line_item_id"]
KEY_COLUMNS = ["id"]                # <-- REPLACE with your actual key column(s)

# --- Column mapping (optional) -----------------------------------------------
# Map Source column names to Target column names when they differ.
# Leave as {} if column names are identical in both files.
# Example: COLUMN_MAPPING = {"src_order_id": "tgt_order_id", "src_date": "tgt_date"}
COLUMN_MAPPING = {}

# --- Columns to exclude from value comparison (optional) ---------------------
# Audit / load-timestamp columns that should not be compared.
# Example: EXCLUDE_COLUMNS = ["load_ts", "etl_batch_id"]
EXCLUDE_COLUMNS = []

# --- Numeric tolerance -------------------------------------------------------
# Absolute tolerance for numeric columns (0 = exact match).
# Example: NUMERIC_TOLERANCE = 0.01
NUMERIC_TOLERANCE = 0

# --- File reading settings ---------------------------------------------------
SOURCE_DELIMITER = ","              # Delimiter used in the Source file
TARGET_DELIMITER = ","              # Delimiter used in the Target file
SOURCE_ENCODING  = "utf-8"         # Encoding of the Source file
TARGET_ENCODING  = "utf-8"         # Encoding of the Target file
SOURCE_HEADER    = 0               # Row number of the header (0-indexed); None if no header
TARGET_HEADER    = 0               # Row number of the header (0-indexed); None if no header

# --- Comparison behaviour switches ------------------------------------------
TRIM_WHITESPACE      = True        # Strip leading/trailing whitespace before comparing
CASE_SENSITIVE       = True        # False = case-insensitive string comparison
TREAT_BLANK_AS_NULL  = True        # Treat "", "NULL", "NaN", "None" as the same blank value

# --- Output file -------------------------------------------------------------
OUTPUT_FILE = "CSV Reconciliation Report.xlsx"

# =============================================================================
# END OF CONFIG  –  Do not edit below this line unless you know what you're doing
# =============================================================================


import sys
import pandas as pd
from openpyxl import load_workbook
from openpyxl.styles import PatternFill, Font, Alignment, Border, Side
from openpyxl.utils import get_column_letter


# ---------------------------------------------------------------------------
# Helper utilities
# ---------------------------------------------------------------------------

# Canonical "blank" tokens that are treated as equivalent when
# TREAT_BLANK_AS_NULL is True.
_BLANK_TOKENS = {"", "null", "nan", "none", "na", "n/a"}


def _normalise(series: pd.Series) -> pd.Series:
    """Apply all configured normalisation steps to a string Series."""
    s = series.copy()
    if TRIM_WHITESPACE:
        s = s.str.strip()
    if TREAT_BLANK_AS_NULL:
        s = s.str.lower().replace(list(_BLANK_TOKENS - {""}), "")
        # Restore case for non-blank values when case-sensitive
        if CASE_SENSITIVE:
            # We only lowered to detect blanks; restore original for non-blanks
            # by re-applying strip on the original and blanking only blank tokens
            orig = series.copy()
            if TRIM_WHITESPACE:
                orig = orig.str.strip()
            mask_blank = s == ""
            s = orig.where(~mask_blank, "")
    if not CASE_SENSITIVE:
        s = s.str.lower()
    return s


def _values_equal(s_val: str, t_val: str, col: str,
                  numeric_cols: set) -> bool:
    """Return True when two normalised string values are considered equal."""
    if col in numeric_cols:
        try:
            diff = abs(float(s_val) - float(t_val))
            return diff <= NUMERIC_TOLERANCE
        except (ValueError, TypeError):
            pass  # Fall through to string comparison
    return s_val == t_val


def _make_blank_row(columns, message="No differences found."):
    """Return a single-row DataFrame with a message in the first column."""
    row = {c: "" for c in columns}
    row[columns[0]] = message
    return pd.DataFrame([row])


# ---------------------------------------------------------------------------
# STEP 0 – Read files
# ---------------------------------------------------------------------------

def read_file(path, delimiter, encoding, header, label):
    """Read a CSV into a DataFrame with all columns as strings."""
    try:
        df = pd.read_csv(
            path,
            delimiter=delimiter,
            encoding=encoding,
            header=header,
            dtype=str,
            keep_default_na=False,
        )
        print(f"[OK] {label} loaded: {df.shape[0]} rows × {df.shape[1]} columns  ({path})")
        return df
    except FileNotFoundError:
        print(f"[WARNING] {label} file not found: {path}")
        sys.exit(1)
    except Exception as exc:
        print(f"[WARNING] Could not read {label} file '{path}': {exc}")
        sys.exit(1)


# ---------------------------------------------------------------------------
# STEP 1 – Individual checks
# ---------------------------------------------------------------------------

def check_columns(src_cols, tgt_cols):
    """
    Return (only_in_source, only_in_target, common_columns).
    Applies COLUMN_MAPPING so Source column names are translated before
    comparing with Target column names.
    """
    # Translate source column names via mapping
    mapped_src_cols = [COLUMN_MAPPING.get(c, c) for c in src_cols]

    only_in_source  = [c for c in mapped_src_cols if c not in tgt_cols]
    only_in_target  = [c for c in tgt_cols        if c not in mapped_src_cols]
    common          = [c for c in mapped_src_cols  if c in tgt_cols]
    return only_in_source, only_in_target, common


def check_duplicates(df, key_cols, label):
    """Return a DataFrame of duplicate key rows with an Occurrences count."""
    counts = df.groupby(key_cols).size().reset_index(name="_count")
    dupes  = counts[counts["_count"] > 1].copy()
    if dupes.empty:
        return pd.DataFrame(columns=["File", "Key", "Occurrences"])
    rows = []
    for _, row in dupes.iterrows():
        key_val = " | ".join(str(row[k]) for k in key_cols)
        rows.append({"File": label, "Key": key_val, "Occurrences": int(row["_count"])})
    return pd.DataFrame(rows)


def check_missing_rows(merged):
    """
    Use the merge indicator to find rows present in only one file.
    merged must have been produced with indicator=True, indicator column '_merge'.
    """
    missing_in_target = merged[merged["_merge"] == "left_only"].copy()
    missing_in_source = merged[merged["_merge"] == "right_only"].copy()
    return missing_in_target, missing_in_source


def check_value_mismatches(merged, common_cols, key_cols, numeric_cols):
    """
    For every row present in BOTH files, compare each common column and
    collect differences.  Uses vectorised operations – no row-by-row loops.
    """
    both = merged[merged["_merge"] == "both"].copy()
    if both.empty:
        return pd.DataFrame(columns=["Key", "Column", "Source Value", "Target Value"])

    mismatch_rows = []

    for col in common_cols:
        if col in key_cols:
            continue  # Keys are the join condition – skip value comparison

        src_col = col + "_src"
        tgt_col = col + "_tgt"

        if src_col not in both.columns or tgt_col not in both.columns:
            continue

        s_series = _normalise(both[src_col].astype(str))
        t_series = _normalise(both[tgt_col].astype(str))

        if col in numeric_cols:
            # Vectorised numeric comparison
            def _num_eq(pair):
                try:
                    return abs(float(pair[0]) - float(pair[1])) <= NUMERIC_TOLERANCE
                except (ValueError, TypeError):
                    return pair[0] == pair[1]

            equal_mask = pd.Series(
                [_num_eq(p) for p in zip(s_series, t_series)],
                index=both.index
            )
        else:
            equal_mask = s_series == t_series

        diff_rows = both[~equal_mask]

        if diff_rows.empty:
            continue

        for _, row in diff_rows.iterrows():
            key_val = " | ".join(str(row[k + "_src"]) if k + "_src" in row.index
                                 else str(row[k]) for k in key_cols)
            mismatch_rows.append({
                "Key"          : key_val,
                "Column"       : col,
                "Source Value" : row[src_col],
                "Target Value" : row[tgt_col],
            })

    return pd.DataFrame(mismatch_rows) if mismatch_rows else \
           pd.DataFrame(columns=["Key", "Column", "Source Value", "Target Value"])


# ---------------------------------------------------------------------------
# STEP 2 – Build the merged DataFrame
# ---------------------------------------------------------------------------

def build_merge(src_df, tgt_df, key_cols, common_cols):
    """
    Merge Source and Target on key columns with suffixes _src / _tgt.
    Only common columns (plus keys) are included to keep memory lean.
    """
    src_keep = list(dict.fromkeys(key_cols + common_cols))
    tgt_keep = list(dict.fromkeys(key_cols + common_cols))

    src_sub = src_df[src_keep].copy()
    tgt_sub = tgt_df[tgt_keep].copy()

    merged = pd.merge(
        src_sub,
        tgt_sub,
        on=key_cols,
        how="outer",
        suffixes=("_src", "_tgt"),
        indicator=True,
    )
    return merged


# ---------------------------------------------------------------------------
# STEP 3 – Write Excel report
# ---------------------------------------------------------------------------

def _style_workbook(wb):
    """Apply consistent header styling to every sheet in the workbook."""
    header_fill   = PatternFill("solid", fgColor="1F4E79")   # Dark blue
    header_font   = Font(bold=True, color="FFFFFF", size=11)
    center_align  = Alignment(horizontal="center", vertical="center", wrap_text=True)
    left_align    = Alignment(horizontal="left",   vertical="center", wrap_text=True)
    thin_border   = Border(
        left   = Side(style="thin"),
        right  = Side(style="thin"),
        top    = Side(style="thin"),
        bottom = Side(style="thin"),
    )
    diff_fill     = PatternFill("solid", fgColor="FFE699")    # Light yellow for differences
    match_fill    = PatternFill("solid", fgColor="C6EFCE")    # Light green for matches

    for ws in wb.worksheets:
        # Style header row
        for cell in ws[1]:
            cell.fill      = header_fill
            cell.font      = header_font
            cell.alignment = center_align
            cell.border    = thin_border

        # Style data rows
        for row in ws.iter_rows(min_row=2):
            for cell in row:
                cell.border    = thin_border
                cell.alignment = left_align
                # Colour Status column in Summary sheet
                if ws.title == "Summary" and cell.column == ws.max_column:
                    if cell.value == "Difference":
                        cell.fill = diff_fill
                    elif cell.value == "Match":
                        cell.fill = match_fill

        # Auto-fit column widths (capped at 60)
        for col_cells in ws.columns:
            max_len = max(
                (len(str(c.value)) if c.value is not None else 0)
                for c in col_cells
            )
            ws.column_dimensions[get_column_letter(col_cells[0].column)].width = min(max_len + 4, 60)

        # Freeze the header row
        ws.freeze_panes = "A2"


def write_report(summary_df, col_diff_df, dup_df, missing_df, mismatch_df):
    """Write all result DataFrames to the Excel report."""
    with pd.ExcelWriter(OUTPUT_FILE, engine="openpyxl") as writer:

        # Sheet 1 – Summary
        summary_df.to_excel(writer, sheet_name="Summary", index=False)

        # Sheet 2 – Column Differences
        if col_diff_df.empty:
            _make_blank_row(["Column", "Present In"]).to_excel(
                writer, sheet_name="Column Differences", index=False)
        else:
            col_diff_df.to_excel(writer, sheet_name="Column Differences", index=False)

        # Sheet 3 – Duplicate Keys
        if dup_df.empty:
            _make_blank_row(["File", "Key", "Occurrences"]).to_excel(
                writer, sheet_name="Duplicate Keys", index=False)
        else:
            dup_df.to_excel(writer, sheet_name="Duplicate Keys", index=False)

        # Sheet 4 – Missing Rows
        if missing_df.empty:
            _make_blank_row(["Key", "Missing In"]).to_excel(
                writer, sheet_name="Missing Rows", index=False)
        else:
            missing_df.to_excel(writer, sheet_name="Missing Rows", index=False)

        # Sheet 5 – Value Mismatches
        if mismatch_df.empty:
            _make_blank_row(["Key", "Column", "Source Value", "Target Value"]).to_excel(
                writer, sheet_name="Value Mismatches", index=False)
        else:
            mismatch_df.to_excel(writer, sheet_name="Value Mismatches", index=False)

    # Apply styling after the file is closed by ExcelWriter
    wb = load_workbook(OUTPUT_FILE)
    _style_workbook(wb)
    wb.save(OUTPUT_FILE)
    print(f"\n[OK] Report written → {OUTPUT_FILE}")


# ---------------------------------------------------------------------------
# MAIN
# ---------------------------------------------------------------------------

def main():
    print("=" * 70)
    print("  CSV RECONCILIATION SCRIPT")
    print("=" * 70)

    # ------------------------------------------------------------------
    # 0. Read files
    # ------------------------------------------------------------------
    src_df = read_file(SOURCE_FILE, SOURCE_DELIMITER, SOURCE_ENCODING, SOURCE_HEADER, "Source")
    tgt_df = read_file(TARGET_FILE, TARGET_DELIMITER, TARGET_ENCODING, TARGET_HEADER, "Target")

    # Apply column mapping to Source DataFrame
    if COLUMN_MAPPING:
        src_df.rename(columns=COLUMN_MAPPING, inplace=True)
        print(f"[INFO] Column mapping applied: {COLUMN_MAPPING}")

    # Validate key columns exist in both files after mapping
    for k in KEY_COLUMNS:
        mapped_k = COLUMN_MAPPING.get(k, k)
        if mapped_k not in src_df.columns:
            print(f"[ERROR] Key column '{mapped_k}' not found in Source file. "
                  f"Available columns: {list(src_df.columns)}")
            sys.exit(1)
        if k not in tgt_df.columns and mapped_k not in tgt_df.columns:
            print(f"[ERROR] Key column '{k}' not found in Target file. "
                  f"Available columns: {list(tgt_df.columns)}")
            sys.exit(1)

    # Resolve key column names after mapping
    resolved_keys = [COLUMN_MAPPING.get(k, k) for k in KEY_COLUMNS]

    # ------------------------------------------------------------------
    # 1. FILE SUMMARY
    # ------------------------------------------------------------------
    src_rows, src_cols = src_df.shape
    tgt_rows, tgt_cols = tgt_df.shape
    print(f"\n[CHECK 1] File Summary")
    print(f"  Source : {src_rows} rows, {src_cols} columns")
    print(f"  Target : {tgt_rows} rows, {tgt_cols} columns")

    # ------------------------------------------------------------------
    # 2. COLUMN COMPARISON
    # ------------------------------------------------------------------
    print(f"\n[CHECK 2] Column Comparison")
    only_in_src, only_in_tgt, common_cols_all = check_columns(
        list(src_df.columns), list(tgt_df.columns)
    )

    # Remove excluded columns from comparison set
    excluded_set  = set(EXCLUDE_COLUMNS)
    common_cols   = [c for c in common_cols_all if c not in excluded_set]

    col_diff_rows = []
    for c in only_in_src:
        col_diff_rows.append({"Column": c, "Present In": "Source Only"})
    for c in only_in_tgt:
        col_diff_rows.append({"Column": c, "Present In": "Target Only"})
    col_diff_df = pd.DataFrame(col_diff_rows) if col_diff_rows else \
                  pd.DataFrame(columns=["Column", "Present In"])

    print(f"  Only in Source : {only_in_src if only_in_src else 'None'}")
    print(f"  Only in Target : {only_in_tgt if only_in_tgt else 'None'}")
    print(f"  Common columns : {len(common_cols)}")

    # ------------------------------------------------------------------
    # 3. DUPLICATE KEYS
    # ------------------------------------------------------------------
    print(f"\n[CHECK 3] Duplicate Keys")
    src_dupes = check_duplicates(src_df, resolved_keys, "Source")
    tgt_dupes = check_duplicates(tgt_df, resolved_keys, "Target")
    dup_df    = pd.concat([src_dupes, tgt_dupes], ignore_index=True)
    print(f"  Source duplicates : {len(src_dupes)}")
    print(f"  Target duplicates : {len(tgt_dupes)}")

    # ------------------------------------------------------------------
    # 4. MISSING ROWS  (via outer merge)
    # ------------------------------------------------------------------
    print(f"\n[CHECK 4] Missing Rows")
    merged = build_merge(src_df, tgt_df, resolved_keys, common_cols)

    missing_in_tgt_df, missing_in_src_df = check_missing_rows(merged)

    missing_rows = []
    for _, row in missing_in_tgt_df.iterrows():
        key_val = " | ".join(str(row[k + "_src"]) if k + "_src" in row.index
                             else str(row[k]) for k in resolved_keys)
        missing_rows.append({"Key": key_val, "Missing In": "Target"})
    for _, row in missing_in_src_df.iterrows():
        key_val = " | ".join(str(row[k + "_tgt"]) if k + "_tgt" in row.index
                             else str(row[k]) for k in resolved_keys)
        missing_rows.append({"Key": key_val, "Missing In": "Source"})

    missing_df = pd.DataFrame(missing_rows) if missing_rows else \
                 pd.DataFrame(columns=["Key", "Missing In"])

    rows_only_in_src = len(missing_in_tgt_df)
    rows_only_in_tgt = len(missing_in_src_df)
    print(f"  Rows in Source but not Target : {rows_only_in_src}")
    print(f"  Rows in Target but not Source : {rows_only_in_tgt}")

    # ------------------------------------------------------------------
    # 5. VALUE MISMATCHES
    # ------------------------------------------------------------------
    print(f"\n[CHECK 5] Value Mismatches")

    # Identify numeric columns (attempt float conversion on both files)
    numeric_cols = set()
    if NUMERIC_TOLERANCE != 0:
        for col in common_cols:
            if col in resolved_keys:
                continue
            src_col_name = col + "_src"
            tgt_col_name = col + "_tgt"
            if src_col_name in merged.columns and tgt_col_name in merged.columns:
                try:
                    pd.to_numeric(merged[src_col_name].dropna(), errors="raise")
                    pd.to_numeric(merged[tgt_col_name].dropna(), errors="raise")
                    numeric_cols.add(col)
                except (ValueError, TypeError):
                    pass

    mismatch_df = check_value_mismatches(merged, common_cols, resolved_keys, numeric_cols)
    print(f"  Value mismatches found : {len(mismatch_df)}")

    # ------------------------------------------------------------------
    # 6. FULL-ROW CHECK
    # ------------------------------------------------------------------
    both_df        = merged[merged["_merge"] == "both"]
    total_both     = len(both_df)
    mismatch_keys  = set(mismatch_df["Key"].unique()) if not mismatch_df.empty else set()
    exact_matches  = total_both - len(mismatch_keys)
    print(f"\n[CHECK 6] Full-Row Check")
    print(f"  Rows present in both files : {total_both}")
    print(f"  Rows matching exactly      : {exact_matches}")
    print(f"  Rows with any mismatch     : {len(mismatch_keys)}")

    # ------------------------------------------------------------------
    # Build Summary sheet
    # ------------------------------------------------------------------
    def _status(diff_val):
        return "Difference" if diff_val else "Match"

    summary_data = [
        # Row count
        {
            "Check"      : "Row Count",
            "Source"     : src_rows,
            "Target"     : tgt_rows,
            "Difference" : abs(src_rows - tgt_rows),
            "Status"     : _status(src_rows != tgt_rows),
        },
        # Column count
        {
            "Check"      : "Column Count",
            "Source"     : src_cols,
            "Target"     : tgt_cols,
            "Difference" : abs(src_cols - tgt_cols),
            "Status"     : _status(src_cols != tgt_cols),
        },
        # Columns only in Source
        {
            "Check"      : "Columns Only in Source",
            "Source"     : len(only_in_src),
            "Target"     : "-",
            "Difference" : len(only_in_src),
            "Status"     : _status(len(only_in_src) > 0),
        },
        # Columns only in Target
        {
            "Check"      : "Columns Only in Target",
            "Source"     : "-",
            "Target"     : len(only_in_tgt),
            "Difference" : len(only_in_tgt),
            "Status"     : _status(len(only_in_tgt) > 0),
        },
        # Duplicate keys – Source
        {
            "Check"      : "Duplicate Keys (Source)",
            "Source"     : len(src_dupes),
            "Target"     : "-",
            "Difference" : len(src_dupes),
            "Status"     : _status(len(src_dupes) > 0),
        },
        # Duplicate keys – Target
        {
            "Check"      : "Duplicate Keys (Target)",
            "Source"     : "-",
            "Target"     : len(tgt_dupes),
            "Difference" : len(tgt_dupes),
            "Status"     : _status(len(tgt_dupes) > 0),
        },
        # Missing rows – in Target
        {
            "Check"      : "Rows in Source but Missing in Target",
            "Source"     : rows_only_in_src,
            "Target"     : "-",
            "Difference" : rows_only_in_src,
            "Status"     : _status(rows_only_in_src > 0),
        },
        # Missing rows – in Source
        {
            "Check"      : "Rows in Target but Missing in Source",
            "Source"     : "-",
            "Target"     : rows_only_in_tgt,
            "Difference" : rows_only_in_tgt,
            "Status"     : _status(rows_only_in_tgt > 0),
        },
        # Value mismatches
        {
            "Check"      : "Value Mismatches (cell-level)",
            "Source"     : "-",
            "Target"     : "-",
            "Difference" : len(mismatch_df),
            "Status"     : _status(len(mismatch_df) > 0),
        },
        # Exact full-row matches
        {
            "Check"      : "Rows Matching Exactly (all common columns)",
            "Source"     : exact_matches,
            "Target"     : exact_matches,
            "Difference" : 0,
            "Status"     : "Match",
        },
    ]

    # Overall status row
    any_diff = (
        src_rows != tgt_rows
        or src_cols != tgt_cols
        or len(only_in_src) > 0
        or len(only_in_tgt) > 0
        or len(src_dupes) > 0
        or len(tgt_dupes) > 0
        or rows_only_in_src > 0
        or rows_only_in_tgt > 0
        or len(mismatch_df) > 0
    )
    summary_data.append({
        "Check"      : "OVERALL STATUS",
        "Source"     : "-",
        "Target"     : "-",
        "Difference" : "-",
        "Status"     : "Differences Found" if any_diff else "Files Match",
    })

    summary_df = pd.DataFrame(summary_data)

    # ------------------------------------------------------------------
    # Write report
    # ------------------------------------------------------------------
    write_report(summary_df, col_diff_df, dup_df, missing_df, mismatch_df)

    print("\n" + "=" * 70)
    print("  RECONCILIATION COMPLETE")
    print(f"  Overall Status : {'Differences Found' if any_diff else 'Files Match'}")
    print("=" * 70)


if __name__ == "__main__":
    main()
