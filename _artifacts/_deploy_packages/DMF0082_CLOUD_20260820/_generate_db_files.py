#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082_CLOUD_20260820 — A_DB 산출물 생성기 (사내 라이브 신선 덤프).
생성: 01_SPEC / 02_BODY / 04_CMBO / 05_SHEET_META / 06_EXCEL_META / 07_MSG
(03_DDL / 00_PRECHECK / 90_VERIFY 는 수기 작성 파일)"""
import io
import pathlib
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb
import datetime

OUT = pathlib.Path(__file__).resolve().parent / "A_DB"
OUT.mkdir(exist_ok=True)

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def dump_source(obj_type, fname, header):
    cur.execute(
        "SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' "
        "AND TYPE=:t ORDER BY LINE", {"t": obj_type})
    body = "".join(t for (t,) in cur if t is not None)
    text = f"-- {header}\nCREATE OR REPLACE {body}\n/\n"
    (OUT / fname).write_text(text, encoding="utf-8")
    print(fname, len(text.splitlines()), "lines")


def lit(v):
    if v is None:
        return "NULL"
    if isinstance(v, (int, float)):
        return str(v)
    if isinstance(v, datetime.datetime):
        return f"TO_DATE('{v.strftime('%Y%m%d%H%M%S')}','YYYYMMDDHH24MISS')"
    s = str(v).replace("'", "''")
    if len(s) <= 1500 and "\n" not in s and "\r" not in s:
        return f"'{s}'"
    # 개행/장문 — CHR 결합으로 안전 직렬화 (라인 단위)
    parts = []
    for i, ln in enumerate(s.replace("\r\n", "\n").split("\n")):
        chunk = []
        while len(ln) > 1500:
            chunk.append(f"'{ln[:1500]}'")
            ln = ln[1500:]
        chunk.append(f"'{ln}'")
        seg = "||".join(chunk)
        parts.append(seg if i == 0 else f"CHR(10)||{seg}")
    return "||".join(parts)


def fetch_rows(sql, binds=None):
    cur.execute(sql, binds or {})
    cols = [c[0] for c in cur.description]
    rows = []
    for r in cur.fetchall():
        rows.append([v.read() if isinstance(v, oracledb.LOB) else v for v in r])
    return cols, rows


def merge_stmts(table, key_cols, sql, binds=None):
    cols, rows = fetch_rows(sql, binds)
    out = []
    for r in rows:
        vals = dict(zip(cols, r))
        on = " AND ".join(
            f"T.{k} = {lit(vals[k])}" for k in key_cols)
        upd_cols = [c for c in cols if c not in key_cols]
        upd = ", ".join(f"T.{c} = {lit(vals[c])}" for c in upd_cols)
        ins_cols = ", ".join(cols)
        ins_vals = ", ".join(lit(vals[c]) for c in cols)
        out.append(
            f"MERGE INTO SCM_MGR.{table} T\nUSING DUAL ON ({on})\n"
            f"WHEN MATCHED THEN UPDATE SET {upd}\n"
            f"WHEN NOT MATCHED THEN INSERT ({ins_cols})\nVALUES ({ins_vals});")
    return out, len(rows)


# 01 / 02 — SPEC·BODY 신선 덤프
dump_source("PACKAGE", "01_PKG_DMF0082_SPEC.sql",
            "DMF0082_CLOUD_20260820 / PKG SPEC (사내 ALL_SOURCE 신선 덤프 2026-08-20)")
dump_source("PACKAGE BODY", "02_PKG_DMF0082_BODY.sql",
            "DMF0082_CLOUD_20260820 / PKG BODY (사내 ALL_SOURCE 신선 덤프 2026-08-20 — "
            "5계보(0819)+XLSWEEKLY/XLSFORM2/SENTINELDDL/XLSSAVEPERF/AFSNULL/MEASRULE(0820) 포함)")

# 04 — CMBO 5본
CMBOS = ["EndCustomer", "SiteEndCustomerMapDMF0082", "EndCustomerByDivisionDMF0082",
         "FcstTypeByUserGroupDMF0082", "FcstTypeEditDMF0082"]
stmts = []
for c in CMBOS:
    s, n = merge_stmts("SCM_ADM_CMBO_SQL_M", ["SQL_ID"],
                       "SELECT * FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = :s", {"s": c})
    if n != 1:
        print(f"WARN: CMBO {c} rows={n}")
    stmts += s
(OUT / "04_CMBO_SYNC_20260820.sql").write_text(
    "-- DMF0082_CLOUD_20260820 / CMBO 5본 MERGE (사내 신선 덤프 — EndCustomer 는 공유 ⚠)\n"
    + "\n\n".join(stmts) + "\nCOMMIT;\n", encoding="utf-8")
print("04_CMBO_SYNC_20260820.sql", len(stmts), "MERGE")

# 05 — SHEET_COLUMNS 시트 단위 재적재 (hook #98 §9 — 삭제 범위 = 삽입 범위)
sheets = ["FcstNPrice", "Sales Price Save All"]
lines = ["-- DMF0082_CLOUD_20260820 / SHEET_COLUMNS 시트 단위 재적재 (hook #98 §9)",
         "-- 삭제 범위 = 삽입 범위 (PROGRAM_ID='DMF0082' 시트 2본 전량)"]
for sh in sheets:
    cols, rows = fetch_rows(
        "SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
        "WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME=:s ORDER BY SORT_ORDER_NO", {"s": sh})
    lines.append(f"\nDELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='{sh}';")
    for r in rows:
        vals = dict(zip(cols, r))
        lines.append(
            f"INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS ({', '.join(cols)})\n"
            f"VALUES ({', '.join(lit(vals[c]) for c in cols)});")
    print(f"05 sheet {sh}: {len(rows)} rows")
lines.append("COMMIT;")
(OUT / "05_SHEET_META_SYNC_20260820.sql").write_text("\n".join(lines), encoding="utf-8")

# 06 — EXCEL_COLUMNS 1행
s, n = merge_stmts("SCM_ADM_EXCEL_COLUMNS", ["PROGRAM_ID", "SHEET_NAME"],
                   "SELECT * FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID='DMF0082'")
(OUT / "06_EXCEL_META_SYNC_20260820.sql").write_text(
    "-- DMF0082_CLOUD_20260820 / EXCEL_COLUMNS MERGE (2026-08-20 01:09 갱신분)\n"
    + "\n\n".join(s) + "\nCOMMIT;\n", encoding="utf-8")
print("06_EXCEL_META_SYNC_20260820.sql", n, "rows")

# 07 — MSG (DMF0082 연관 10종 × 3언어)
MSGS = ["MSG01001", "MSG00328", "MSG00457", "MSG00458", "MSG00459",
        "MSG00460", "MSG00461", "MSG00462", "MSG00467", "MSG01014"]
stmts = []
for m in MSGS:
    s, n = merge_stmts("SCM_ADM_MSG_M", ["MSG_ID", "LANG_CD"],
                       "SELECT * FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID = :m", {"m": m})
    if n != 3:
        print(f"WARN: MSG {m} rows={n}")
    stmts += s
(OUT / "07_MSG_SYNC_20260820.sql").write_text(
    "-- DMF0082_CLOUD_20260820 / MSG 10종 x 3언어 MERGE (사내 신선 덤프)\n"
    + "\n\n".join(stmts) + "\nCOMMIT;\n", encoding="utf-8")
print("07_MSG_SYNC_20260820.sql", len(stmts), "MERGE")

con.close()
print("generate DONE")
