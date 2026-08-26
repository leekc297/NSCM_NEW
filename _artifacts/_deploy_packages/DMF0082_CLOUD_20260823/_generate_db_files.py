#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082_CLOUD_20260823 — A_DB 산출물 생성기 (사내 라이브 신선 덤프 / 기계 도출).

대상 축은 `_survey/axis_sweep_result.json` (기계 전수 스윕) 을 근거로 결정한다 — 손나열 금지(hook #140).
생성물:
  01_PKG_DMF0082_SPEC.sql        PKG SPEC 신선 덤프
  02_PKG_DMF0082_BODY.sql        PKG BODY 신선 덤프 (마커 30계보)
  03_DDL_GTT_DMF0082.sql         DMF0082 전용 GTT DDL (멱등 -955 가드) + 인덱스
  04_CMBO_SYNC.sql               콤보 MERGE (전용 + 기준선 이후 변경 공유) / 공유 미변경분은 PRECHECK 존재확인
  05_SHEET_META_SYNC.sql         SHEET_COLUMNS 2시트 전량 재적재 (hook #98 §9)
  06_SHEET_MEASURE_SYNC.sql      SHEET_MEASURE 전량 재적재
  07_EXCEL_META_SYNC.sql         EXCEL_COLUMNS 재적재
  08_MSG_SYNC.sql                SCM_ADM_MSG_M INSERT-only(NOT EXISTS) — MSG/LBL/MNU 3분류
  09_PROC_API_BTN_AUTH_SYNC.sql  PROC_M / API_M / MNU_M / BTN_MPG / 권한 2종 / PROGRAM MERGE
  10_LOOKUP_SYNC.sql             LOOKUP_MASTER_DETAIL MERGE (NULL-safe ON)
  _survey/collect_report.json    산출 카운트 실측 기록

03_DDL_DEFAULT_ON_NULL.sql / 00_CLOUD_PRECHECK.sql / 90_VERIFY.sql 은 수기 작성.
"""
import datetime
import io
import json
import pathlib
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parent
OUT = ROOT / "A_DB"
OUT.mkdir(exist_ok=True)
SURVEY = ROOT / "_survey"
SWEEP = json.loads((SURVEY / "axis_sweep_result.json").read_text(encoding="utf-8"))

FE_DIR = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\forecast-price")
# 동봉 공용 FE 파일 (MSG 코드 추출 축에 포함 — 이 파일들도 함께 이관되므로 코드가 클라우드에 있어야 한다)
SHARED_FE = [
    r"C:\Projects\NSCM\nscm-fe\packages\shared\src\stores\useDirtyRegistry.ts",
    r"C:\Projects\NSCM\nscm-fe\packages\shared\src\components\organisms\data-grid\DataGrid.tsx",
    r"C:\Projects\NSCM\nscm-fe\packages\shared\src\components\organisms\data-grid\dataGridUtils.ts",
    r"C:\Projects\NSCM\nscm-fe\packages\shared\src\components\templates\modals\column-layout-modal\ColumnLayoutModal.tsx",
    r"C:\Projects\NSCM\nscm-fe\packages\shared\src\components\templates\modals\column-layout-modal\columnLayoutModal.utils.ts",
    r"C:\Projects\NSCM\nscm-fe\packages\shared\src\components\molecules\customDropdown\CustomDropdown.tsx",
    r"C:\Projects\NSCM\nscm-fe\features\master\src\components\searchFields\SearchFields.tsx",
]
STAMP = "20260823"
BASELINE_CMBO = "2026-08-04"   # 이 날짜 이후 변경된 공유 콤보만 동봉 (그 이전 = 클라우드 기존재 가정 + PRECHECK 확인)
# 그리드 메타 소비 카운트로는 안 잡히지만 반드시 동봉해야 하는 콤보 (근거 명시 의무)
FORCE_CMBO = {
    "ColumnControlType": "admin UI Category Setup 셀컨트롤 목록 — DMF0082 ITEM_ID 가 신설값 'FPTextModal' 소비(SHEET_COLUMNS 실측)",
}
# FE 전수 grep 실측(2026-08-23, features/** *.ts|tsx, forecast-price·BACKUP_20260818 제외) — 공유 경고 근거
FE_CONSUMERS = {
    "AS_FROM_SITE": "mkt-fcst(3파일)",
    "AsIncotermsEdit": "sales-plan",
    "BucketType": "customer-fcst-master, customer-fcst-upload, mkt-fcst, production-plan-line(2), sales-plan, SearchFields",
    "EndCustomerByDivision": "mkt-fcst, project-list, project-master, sales-plan-waterfall, SearchFields",
    "EndCustomerByDivision40": "business-plan, OwnerByDivisionModal, sales-plan, mkt-fcst",
    "FcstTypeWs": "mkt-fcst(2파일)",
    "MktFcstWsPlannerYn": "mkt-fcst",
    "SalesSite": "customer-fcst-master, customer-fcst-upload, customer-model-mapping, ItemByDivisionModal, metal-link-price, OwnerByDivisionModal, PriceBatchInputModal, ProjectByDivisionModal, sales-monitoring, sales-site, sales-site-project-model, SearchFields (12)",
    "SenderCode": "demand-plan-waterfall, mkt-fcst",
    "TeambyDivision": "customer-model-mapping, ItemByDivisionModal, OwnerByDivisionModal, PriceBatchInputModal, ProjectByDivisionModal, sales-monitoring, SearchFields, sales-future-price, sales-plan (9)",
    "UserSiteByEndCustomer": "business-plan, demand-plan-waterfall, mkt-fcst, sales-plan-waterfall, SearchFields",
    "UserTeamByDivision": "mkt-fcst, sales-plan-waterfall, SearchFields",
}

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
report = {"generated": STAMP, "files": {}}


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


def fetch(sql, binds=None):
    cur.execute(sql, binds or {})
    cols = [c[0] for c in cur.description]
    rows = [[v.read() if isinstance(v, oracledb.LOB) else v for v in r] for r in cur.fetchall()]
    return cols, rows


def merge_stmts(table, key_cols, sql, binds=None, null_safe=False):
    cols, rows = fetch(sql, binds)
    out = []
    for r in rows:
        vals = dict(zip(cols, r))
        if null_safe:
            on = " AND ".join(
                f"NVL(T.{k}, '~NULL~') = NVL({lit(vals[k])}, '~NULL~')" for k in key_cols)
        else:
            on = " AND ".join(f"T.{k} = {lit(vals[k])}" for k in key_cols)
        upd = ", ".join(f"T.{c} = {lit(vals[c])}" for c in cols if c not in key_cols)
        out.append(
            f"MERGE INTO SCM_MGR.{table} T\nUSING DUAL ON ({on})\n"
            f"WHEN MATCHED THEN UPDATE SET {upd}\n"
            f"WHEN NOT MATCHED THEN INSERT ({', '.join(cols)})\n"
            f"VALUES ({', '.join(lit(vals[c]) for c in cols)});")
    return out, len(rows)


def reload_stmts(table, scope_where, sql, binds=None):
    """DELETE(삽입 범위와 동일) + INSERT 전량 — hook #98 §9"""
    cols, rows = fetch(sql, binds)
    out = [f"DELETE FROM SCM_MGR.{table} WHERE {scope_where};"]
    for r in rows:
        vals = dict(zip(cols, r))
        out.append(f"INSERT INTO SCM_MGR.{table} ({', '.join(cols)})\n"
                   f"VALUES ({', '.join(lit(vals[c]) for c in cols)});")
    return out, len(rows)


def insert_if_not_exists_stmts(table, key_cols, sql, binds=None):
    """INSERT ... SELECT ... FROM DUAL WHERE NOT EXISTS (...) — 사용자 지정 이관 형식.

    기존재 행은 덮어쓰지 않는다 (문구는 화면 간 공유 자산 — 한 화면 기준으로 덮으면 타 화면 오표기).
    """
    cols, rows = fetch(sql, binds)
    out = []
    for r in rows:
        vals = dict(zip(cols, r))
        keyw = " AND ".join(f"{k} = {lit(vals[k])}" for k in key_cols)
        sel = ", ".join(f"{lit(vals[c])} AS {c}" for c in cols)
        out.append(
            f"INSERT INTO SCM_MGR.{table} ({', '.join(cols)})\n"
            f"SELECT {sel} FROM DUAL\n"
            f" WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.{table} WHERE {keyw});")
    return out, len(rows)


def write(fname, header, stmts, commit=True):
    body = "\n\n".join(stmts)
    text = f"-- {header}\n\n{body}\n" + ("COMMIT;\n" if commit else "")
    (OUT / fname).write_text(text, encoding="utf-8")
    print(f"  {fname:<38} {len(stmts):>4} stmt / {len(text.splitlines()):>6} lines")
    report["files"][fname] = {"statements": len(stmts), "lines": len(text.splitlines())}


# ══════ 01 / 02 — SPEC·BODY 신선 덤프 ══════
print("\n[01/02] PKG 신선 덤프")
for typ, fname, tag in [
        ("PACKAGE", "01_PKG_DMF0082_SPEC.sql", "SPEC"),
        ("PACKAGE BODY", "02_PKG_DMF0082_BODY.sql", "BODY")]:
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' "
                "AND TYPE=:t ORDER BY LINE", {"t": typ})
    src = "".join(t for (t,) in cur if t is not None)
    text = (f"-- DMF0082_CLOUD_{STAMP} / PKG {tag} (사내 ALL_SOURCE 신선 덤프 {STAMP})\n"
            f"CREATE OR REPLACE {src}\n/\n")
    (OUT / fname).write_text(text, encoding="utf-8")
    n = len(text.splitlines())
    print(f"  {fname:<38} {n:>6} lines")
    report["files"][fname] = {"lines": n}

# ══════ 03 — GTT DDL (DMF0082 전용) ══════
print("\n[03] GTT DDL (DMF0082 전용, 멱등 -955 가드)")
gtts = [o["name"] for o in SWEEP["B_objects"]
        if o["type"] == "TABLE" and o.get("gtt") and "DMF0082" in o["name"]]
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,"
            "'SEGMENT_ATTRIBUTES',FALSE); DBMS_METADATA.SET_TRANSFORM_PARAM("
            "DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',FALSE); END;")
stmts = []
for g in sorted(gtts):
    cur.execute("SELECT DBMS_METADATA.GET_DDL('TABLE', :n, 'SCM_MGR') FROM DUAL", {"n": g})
    ddl = cur.fetchone()[0]
    ddl = (ddl.read() if isinstance(ddl, oracledb.LOB) else ddl).strip()
    stmts.append("BEGIN\n  EXECUTE IMMEDIATE q'[" + ddl +
                 "]';\nEXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;\nEND;\n/")
# 인덱스 (GTT 부속)
cur.execute("""SELECT INDEX_NAME, TABLE_NAME FROM ALL_INDEXES
                WHERE OWNER='SCM_MGR' AND TABLE_NAME LIKE 'GT_DMF0082%' ORDER BY 1""")
for idx, tbl in cur.fetchall():
    cur.execute("SELECT DBMS_METADATA.GET_DDL('INDEX', :n, 'SCM_MGR') FROM DUAL", {"n": idx})
    ddl = cur.fetchone()[0]
    ddl = (ddl.read() if isinstance(ddl, oracledb.LOB) else ddl).strip()
    stmts.append("BEGIN\n  EXECUTE IMMEDIATE q'[" + ddl +
                 "]';\nEXCEPTION WHEN OTHERS THEN IF SQLCODE NOT IN (-955,-1408) THEN RAISE; END IF;\nEND;\n/")
write("03_DDL_GTT_DMF0082.sql",
      f"DMF0082_CLOUD_{STAMP} / DMF0082 전용 GTT {len(gtts)}종 + 인덱스 DDL (멱등 — 기존재 시 -955 skip)\n"
      "-- ⚠ GTT 정의 변경분은 -955 skip 으로 반영되지 않는다. 컬럼 드리프트 시 00A_GTT_REBUILD 필요"
      " (deploy-package-completeness §1.1)",
      stmts, commit=False)
report["gtt_ddl_count"] = len(gtts)

# ══════ 04 — CMBO ══════
print("\n[04] CMBO — 소비 축 기계 도출")
# (a) 메타 축 : DMF0082 시트의 표시(CELL_COMBO_DATA_TYPE)·편집(ATTRIBUTE9) 콤보
cur.execute("""SELECT DISTINCT TRIM(CELL_COMBO_DATA_TYPE) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                WHERE PROGRAM_ID LIKE '%DMF0082%' AND TRIM(CELL_COMBO_DATA_TYPE) IS NOT NULL
               UNION
               SELECT DISTINCT TRIM(ATTRIBUTE9) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                WHERE PROGRAM_ID LIKE '%DMF0082%' AND TRIM(ATTRIBUTE9) IS NOT NULL""")
meta_names = {r[0] for r in cur.fetchall() if r[0]}
# (b) FE 축 : 화면 소스의 모든 문자열 리터럴 ∩ CMBO_SQL_M.SQL_ID (정확 일치만)
fe_src = "\n".join(f.read_text(encoding="utf-8", errors="ignore")
                   for f in FE_DIR.rglob("*") if f.suffix in (".ts", ".tsx"))
fe_lits = set(re.findall(r"['\"]([A-Za-z][\w]{2,})['\"]", fe_src))
cur.execute("SELECT SQL_ID FROM SCM_MGR.SCM_ADM_CMBO_SQL_M")
all_ids = {r[0] for r in cur.fetchall()}
fe_names = fe_lits & all_ids
cand = sorted(((meta_names | fe_names) & all_ids) | (set(FORCE_CMBO) & all_ids))

ship, verify_only = [], []
for c in cand:
    cur.execute("""SELECT TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD'),
                          (SELECT COUNT(DISTINCT PROGRAM_ID) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                            WHERE TRIM(CELL_COMBO_DATA_TYPE)=:s OR TRIM(ATTRIBUTE9)=:s)
                     FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID=:s""", {"s": c})
    lud, consumers = cur.fetchone()
    dedicated = ("DMF0082" in c) or consumers <= 1
    if c in FORCE_CMBO or dedicated or (lud or "") >= BASELINE_CMBO:
        ship.append((c, lud, consumers, dedicated))
    else:
        verify_only.append((c, lud, consumers))

stmts = []
for c, lud, consumers, dedicated in ship:
    if c in FORCE_CMBO:
        tag = "⚠공용 필수 — " + FORCE_CMBO[c]
    else:
        tag = "전용(그리드메타 기준)" if dedicated else f"⚠공유 {consumers}화면(그리드메타)"
    if c in FE_CONSUMERS:
        tag += f" / ⚠FE 타소비처: {FE_CONSUMERS[c]}"
    s, n = merge_stmts("SCM_ADM_CMBO_SQL_M", ["SQL_ID", "MDU_DIVS_CD"],
                       "SELECT * FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID=:s", {"s": c})
    stmts.append(f"-- [{tag}] {c}  (사내 LAST_UPDATE={lud})\n" + "\n\n".join(s))
write("04_CMBO_SYNC.sql",
      f"DMF0082_CLOUD_{STAMP} / CMBO MERGE {len(ship)}본 (기계 도출: 메타 표시·편집 콤보 ∪ FE 리터럴 ∩ CMBO_SQL_M)\n"
      f"-- 동봉 기준 = 전용(그리드메타 소비화면≤1 또는 이름에 DMF0082) 또는 사내 LAST_UPDATE >= {BASELINE_CMBO} 또는 FORCE_CMBO\n"
      "-- ⚠ [전용] 표기는 그리드 메타(SHEET_COLUMNS) 기준이다. 조회조건 콤보는 메타에 없으므로 FE 전수 grep 실측\n"
      "--    소비처를 각 항목에 병기했다 — 사내 정본으로 덮는 것이 의도인지 확인 후 적용할 것.\n"
      f"-- 미동봉(클라우드 기존재 확인만, 00_CLOUD_PRECHECK C6) = "
      + ", ".join(f"{c}({consumers})" for c, _, consumers in verify_only),
      stmts)
report["cmbo_ship"] = [c for c, *_ in ship]
report["cmbo_verify_only"] = [c for c, *_ in verify_only]
print(f"    동봉 {len(ship)}본 / 존재확인만 {len(verify_only)}본")

# ══════ 05 — SHEET_COLUMNS ══════
print("\n[05] SHEET_COLUMNS 시트 전량 재적재")
cur.execute("SELECT DISTINCT SHEET_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
            "WHERE PROGRAM_ID='DMF0082' ORDER BY 1")
sheets = [r[0] for r in cur.fetchall()]
stmts, total = [], 0
for sh in sheets:
    # 동일 SHEET_NAME 을 타 PROGRAM_ID 가 쓰는지 실측 (삭제 범위 경고 근거)
    cur.execute("SELECT COUNT(DISTINCT PROGRAM_ID) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
                "WHERE SHEET_NAME=:s", {"s": sh})
    owners = cur.fetchone()[0]
    s, n = reload_stmts("SCM_MST_SHEET_COLUMNS",
                        f"PROGRAM_ID='DMF0082' AND SHEET_NAME='{sh}'",
                        "SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
                        "WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME=:s ORDER BY SORT_ORDER_NO",
                        {"s": sh})
    stmts.append(f"-- 시트 [{sh}] {n}행 (SHEET_NAME 보유 PROGRAM_ID {owners}종 — 삭제는 DMF0082 로 한정)\n"
                 + "\n".join(s))
    total += n
    print(f"    {sh:<24} {n:>4}행 (SHEET_NAME 공유 프로그램 {owners})")
write("05_SHEET_META_SYNC.sql",
      f"DMF0082_CLOUD_{STAMP} / SHEET_COLUMNS 시트 단위 전량 재적재 (hook #98 §9 — 삭제 범위 = 삽입 범위)",
      stmts)
report["sheet_columns_rows"] = total

# ══════ 06 — SHEET_MEASURE ══════
print("\n[06] SHEET_MEASURE 전량 재적재")
s, n = reload_stmts("SCM_MST_SHEET_MEASURE", "PROGRAM_ID='DMF0082'",
                    "SELECT * FROM SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID='DMF0082' "
                    "ORDER BY SHEET_NAME, SORT_ORDER_NO, COLUMN_NAME")
write("06_SHEET_MEASURE_SYNC.sql",
      f"DMF0082_CLOUD_{STAMP} / SHEET_MEASURE 전량 재적재 ({n}행)", ["\n".join(s)])
report["sheet_measure_rows"] = n
print(f"    {n}행")

# ══════ 07 — EXCEL_COLUMNS ══════
print("\n[07] EXCEL_COLUMNS 재적재")
s, n = reload_stmts("SCM_ADM_EXCEL_COLUMNS", "PROGRAM_ID='DMF0082'",
                    "SELECT * FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID='DMF0082'")
write("07_EXCEL_META_SYNC.sql",
      f"DMF0082_CLOUD_{STAMP} / EXCEL_COLUMNS 재적재 ({n}행 — Excel Form/Upload 헤더 토큰)",
      ["\n".join(s)])
report["excel_columns_rows"] = n
print(f"    {n}행")

# ══════ 08 — MSG / LBL / MNU 라벨 (SCM_ADM_MSG_M 공용 원장) ══════
print("\n[08] MSG/LBL/MNU — FE ∪ BODY ∪ 동봉 공용 FE + 메뉴 라벨코드")
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' "
            "AND TYPE='PACKAGE BODY' ORDER BY LINE")
body_src = "".join(t for (t,) in cur if t is not None)
shared_src = ""
for sf in SHARED_FE:
    pf = pathlib.Path(sf)
    if pf.exists():
        shared_src += pf.read_text(encoding="utf-8", errors="ignore")
scan = fe_src + body_src + shared_src
msg_codes = sorted(set(re.findall(r"MSG\d{5}", scan)))
lbl_codes = sorted(set(re.findall(r"LBL\d{5}", scan)))
# MNU 축 — 메뉴 라벨 코드는 소스 스캔으로 안 잡힌다 (SCM_ADM_MNU_M.MNU_MSG_ID 에서 기계 도출)
cur.execute("SELECT DISTINCT MNU_MSG_ID FROM SCM_MGR.SCM_ADM_MNU_M "
            "WHERE MNU_ID='DMF0082' AND MNU_MSG_ID IS NOT NULL")
mnu_codes = sorted(r[0] for r in cur.fetchall())
codes = msg_codes + lbl_codes + mnu_codes

stmts, have, missing, langs = [], [], [], {}
for m in codes:
    st, n = insert_if_not_exists_stmts(
        "SCM_ADM_MSG_M", ["MSG_ID", "LANG_CD"],
        "SELECT * FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID=:m ORDER BY LANG_CD", {"m": m})
    if n == 0:
        missing.append(m)
        continue
    have.append(m)
    langs[m] = n
    stmts.append(f"-- {m} ({n}개 언어)" + "\n" + "\n\n".join(st))
short = sorted(k for k, v in langs.items() if v < 3)
write("08_MSG_SYNC.sql",
      f"DMF0082_CLOUD_{STAMP} / SCM_ADM_MSG_M (MSG/LBL/MNU 공용 원장) — **INSERT-only (NOT EXISTS)**\n"
      "-- ⚠ 사용자 지정 형식: MERGE 로 덮지 않는다. 코드는 화면 간 공유 자산이라 한 화면 기준으로\n"
      "--    문구를 덮으면 타 화면이 조용히 오표기된다. 클라우드에 같은 (MSG_ID,LANG_CD) 가 있으면 건너뛴다.\n"
      "--    적용 후 문구 차이가 있으면 대조해 **별도 판단**할 것 (본 파일은 차이를 해소하지 않는다).\n"
      f"-- 대상: MSG {len([c for c in msg_codes if c in have])}종 + LBL {len([c for c in lbl_codes if c in have])}종"
      f" + MNU {len([c for c in mnu_codes if c in have])}종 = {len(have)}종 / 총 {sum(langs.values())}행\n"
      f"-- ⛔ 사내 원장 미등록(이관 대상 아님 — FE fallback 문구로 표시) = {missing}\n"
      f"-- ⚠ 언어 3개 미만 보유 코드 = {short if short else '없음'}",
      stmts)
report["msg_codes_scanned"] = {"MSG": len(msg_codes), "LBL": len(lbl_codes), "MNU": len(mnu_codes)}
report["msg_shipped"] = have
report["msg_shipped_rows"] = sum(langs.values())
report["msg_lang_short"] = short
report["msg_missing_corporate"] = missing
print(f"    스캔 MSG {len(msg_codes)} / LBL {len(lbl_codes)} / MNU {len(mnu_codes)}")
print(f"    동봉 {len(have)}종 {sum(langs.values())}행 / 사내 미등록 {len(missing)}종 = {missing}")
print(f"    언어 3개 미만 = {short}")

# ══════ 09 — PROC / API / MNU / BTN / 권한 / PROGRAM ══════
print("\n[09] PROC_M / API_M / MNU / BTN / 권한 / PROGRAM")
blocks = []
specs = [
    ("SCM_ADM_PROGRAM", ["PROGRAM_ID"],
     "SELECT * FROM SCM_MGR.SCM_ADM_PROGRAM WHERE PROGRAM_ID LIKE '%DMF0082%'"),
    ("SCM_ADM_MNU_M", ["MNU_ID"],
     "SELECT * FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0082'"),
    ("SCM_ADM_API_M", ["API_ID"],
     "SELECT * FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE '%DMF0082%' OR API_URL LIKE '%DMF0082%'"),
    ("SCM_ADM_PROC_M", ["PROC_NM", "COL_NM", "COL_TP_CD"],
     "SELECT * FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE '%DMF0082%' ORDER BY PROC_NM, COL_NM"),
    ("SCM_ADM_MNU_BTN_MPG_M", ["MNU_ID", "SHT_NM", "MNU_BTN_CD"],
     "SELECT * FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0082' ORDER BY SHT_NM, MNU_BTN_CD"),
    ("SCM_ADM_USER_GR_MNU_MPG_M", ["USER_GR_ID", "MNU_ID"],
     "SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='DMF0082' ORDER BY USER_GR_ID"),
    ("SCM_ADM_USER_GR_MNU_BTN_MPG_M", ["USER_GR_ID", "MNU_ID", "SHT_NM", "MNU_BTN_CD"],
     "SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0082' "
     "ORDER BY USER_GR_ID, SHT_NM, MNU_BTN_CD"),
]
counts = {}
for table, keys, sql in specs:
    s, n = merge_stmts(table, keys, sql)
    counts[table] = n
    blocks.append(f"-- {table} {n}행 (PK={'+'.join(keys)})\n" + "\n\n".join(s))
    print(f"    {table:<32} {n:>4}행")
write("09_PROC_API_BTN_AUTH_SYNC.sql",
      f"DMF0082_CLOUD_{STAMP} / 배선·권한 축 MERGE (PROGRAM/MNU/API/PROC/BTN/권한 2종)\n"
      "-- ⚠ 권한 행(USER_GR_*)은 사내 그룹 구성 기준. 클라우드 그룹 체계가 다르면 00_PRECHECK C7 결과로 판단",
      blocks)
report["wiring_counts"] = counts

# ══════ 10 — LOOKUP ══════
print("\n[10] LOOKUP_MASTER_DETAIL")
s, n = merge_stmts(
    "SCM_ADM_LOOKUP_MASTER_DETAIL",
    ["LOOKUP_TYPE", "SEGMENT1", "SEGMENT2", "SEGMENT3", "SEGMENT4", "SEGMENT5"],
    "SELECT * FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL "
    "WHERE SEGMENT1 LIKE '%DMF0082%' OR SEGMENT2 LIKE '%DMF0082%' "
    "ORDER BY LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3", null_safe=True)
write("10_LOOKUP_SYNC.sql",
      f"DMF0082_CLOUD_{STAMP} / LOOKUP_MASTER_DETAIL {n}행 MERGE "
      "(PK=LOOKUP_TYPE+SEGMENT1~5, NULL-safe ON — NVL 양변 비교)\n"
      "-- 축: DM_UI_EDITABLE_DIVISION / DM_UI_EDITABLE_MEASURE / GET_ADMIN_GROUP_MEASURE / MENU_AUTH_BY_DIVISION",
      ["\n\n".join(s)])
report["lookup_rows"] = n
print(f"    {n}행")

(SURVEY / "collect_report.json").write_text(
    json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
con.close()
print("\ngenerate DONE ->", OUT)
