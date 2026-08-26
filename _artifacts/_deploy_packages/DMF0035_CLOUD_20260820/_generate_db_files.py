#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0035_CLOUD_20260820 — A_DB 산출물 생성기 (사내 라이브 신선 덤프, READ-ONLY).

생성 대상
  01_DDL_GTT.sql            GTT 49본 멱등 생성 DDL (소스 grep + ALL_DEPENDENCIES 양축 스윕 결과)
  02_DDL_GTT_INDEX.sql      GTT 인덱스 2본 (2026-08-06 PERF)
  10~17_PKG_*.sql           PKG 4본 SPEC/BODY — ALL_SOURCE 라이브 원문 (누적 패치 조합 아님)
  20_MENU_META_SYNC.sql     MNU_M / USER_GR_MNU_MPG_M / MNU_BTN_MPG_M / USER_GR_MNU_BTN_MPG_M
                            / API_M / SCM_ADM_PROGRAM
  21_CMBO_SYNC.sql          SCM_ADM_CMBO_SQL_M 7본 (FE 실소비 — grep 실측)
  22_SHEET_META_SYNC.sql    SHEET_COLUMNS 3시트 / SHEET_MEASURE 3시트 — SHEET_NAME 단위 재적재
  23_MSG_LBL_MNU_SYNC.sql   SCM_ADM_MSG_M (MSG/LBL/MNU 동일 테이블) 21코드 x 3언어

(00_CLOUD_PRECHECK / 18_GRANT_SYNONYM / 90_VERIFY 는 수기 작성 파일)

⛔ 본 스크립트는 SELECT 만 수행한다. DDL/DML 실행 없음.
"""
import io
import sys
import re
import pathlib
import datetime

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

OUT = pathlib.Path(__file__).resolve().parent / "A_DB"
OUT.mkdir(exist_ok=True)
STAMP = "DMF0035_CLOUD_20260820"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
counts = {}


# ────────────────────────────────────────────────────────────────────────────────
# 공통 유틸
# ────────────────────────────────────────────────────────────────────────────────
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
        on = " AND ".join(f"T.{k} = {lit(vals[k])}" for k in key_cols)
        upd = ", ".join(f"T.{c} = {lit(vals[c])}" for c in cols if c not in key_cols)
        ins_cols = ", ".join(cols)
        ins_vals = ", ".join(lit(vals[c]) for c in cols)
        out.append(
            f"MERGE INTO SCM_MGR.{table} T\nUSING DUAL ON ({on})\n"
            f"WHEN MATCHED THEN UPDATE SET {upd}\n"
            f"WHEN NOT MATCHED THEN INSERT ({ins_cols})\nVALUES ({ins_vals});")
    return out, len(rows)


def write(fname, text, note=""):
    (OUT / fname).write_text(text, encoding="utf-8")
    n = len(text.splitlines())
    counts[fname] = n
    print(f"  {fname:38s} {n:6d} lines   {note}")


def strip_comments(text):
    """라인 보존 주석 제거 (hook #138 — 주석은 근거가 아니다)."""
    out, inblk = [], False
    for ln in text.split("\n"):
        if inblk:
            if "*/" in ln:
                ln = ln.split("*/", 1)[1]
                inblk = False
            else:
                out.append("")
                continue
        if "/*" in ln:
            h, r = ln.split("/*", 1)
            if "*/" in r:
                ln = h + r.split("*/", 1)[1]
            else:
                ln = h
                inblk = True
        out.append(re.sub(r"--.*$", "", ln))
    return "\n".join(out)


PKGS = ["PKG_DMF0035", "PKG_DMF0022", "PKG_DMF0051", "PKG_SCM0002"]

# ────────────────────────────────────────────────────────────────────────────────
# 0) GTT 축 = 소스 grep(LIVE) + ALL_DEPENDENCIES 양축 전수 스윕
# ────────────────────────────────────────────────────────────────────────────────
print("[0] GTT 전수 스윕 (소스 grep LIVE + ALL_DEPENDENCIES)")
src_live = []
for name in PKGS:
    for t in ("PACKAGE", "PACKAGE BODY"):
        cur.execute(
            "SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE",
            {"n": name, "t": t})
        src_live.append(strip_comments("".join(x for (x,) in cur if x is not None)))
grep_axis = set(re.findall(r"\bGT_[A-Z0-9_]+", "\n".join(src_live).upper()))

cur.execute("""SELECT DISTINCT REFERENCED_NAME FROM ALL_DEPENDENCIES
               WHERE OWNER='SCM_MGR' AND NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051','PKG_SCM0002')
                 AND REFERENCED_TYPE='TABLE' AND REFERENCED_NAME LIKE 'GT!_%' ESCAPE '!'""")
dep_axis = {r[0] for r in cur}

# 실존 GTT 만 DDL 대상 (grep 축에는 접두 오탐이 섞일 수 있으므로 딕셔너리로 교차 확정)
axis = sorted(grep_axis | dep_axis)
b = {f"g{i}": g for i, g in enumerate(axis)}
inl = ",".join(f":g{i}" for i in range(len(axis)))
cur.execute(f"""SELECT TABLE_NAME, DURATION FROM ALL_TABLES
                WHERE OWNER='SCM_MGR' AND TEMPORARY='Y' AND TABLE_NAME IN ({inl}) ORDER BY 1""", b)
gtts = cur.fetchall()
gtt_names = [g for g, _ in gtts]
print(f"    grep 축 {len(grep_axis)} / dep 축 {len(dep_axis)} / 합집합 {len(axis)} → 실존 GTT {len(gtt_names)}")
missing = sorted(set(axis) - set(gtt_names))
if missing:
    print(f"    ⚠ 딕셔너리 미존재(오탐 또는 결손): {missing}")

# ────────────────────────────────────────────────────────────────────────────────
# 1) 01_DDL_GTT.sql — 멱등 생성
# ────────────────────────────────────────────────────────────────────────────────
def col_type(c):
    dt = c["DATA_TYPE"]
    if dt in ("VARCHAR2", "CHAR", "NVARCHAR2", "NCHAR", "RAW"):
        unit = " CHAR" if c["CHAR_USED"] == "C" and dt in ("VARCHAR2", "CHAR") else ""
        ln = c["CHAR_LENGTH"] if (c["CHAR_USED"] == "C" and c["CHAR_LENGTH"]) else c["DATA_LENGTH"]
        return f"{dt}({ln}{unit})"
    if dt == "NUMBER":
        if c["DATA_PRECISION"] is None and (c["DATA_SCALE"] in (None, 0)):
            return "NUMBER"
        if c["DATA_SCALE"] is None:
            return f"NUMBER({c['DATA_PRECISION']})"
        return f"NUMBER({c['DATA_PRECISION']},{c['DATA_SCALE']})"
    if dt == "FLOAT":
        return f"FLOAT({c['DATA_PRECISION']})" if c["DATA_PRECISION"] else "FLOAT"
    if dt.startswith("TIMESTAMP") or dt.startswith("INTERVAL"):
        return dt
    return dt


lines = [
    f"-- {STAMP} / A_DB/01_DDL_GTT.sql",
    "-- GLOBAL TEMPORARY TABLE 자급 DDL — 기존재 가정 금지 (룰 #22 이관패키지 GTT/TYPE 자급 의무).",
    "-- 축 확정 = ① PKG 4본 소스 grep(주석 제거 LIVE) ② ALL_DEPENDENCIES 양축 합집합 → 딕셔너리 교차.",
    f"--   grep {len(grep_axis)}종 / dep {len(dep_axis)}종 / 실존 GTT {len(gtt_names)}종.",
    "-- ⚠ -955(기존재) 무시 방식의 맹점: 이름만 같고 컬럼 구조가 다른 구세대 GTT 가 남아 있으면",
    "--    조용히 통과한 뒤 런타임 ORA-00904/00932 로 터진다. 적용 전 00_CLOUD_PRECHECK C2 의",
    "--    컬럼 시그니처 대조를 반드시 수행할 것 (README §GTT 구조 diff 가이드).",
    "-- 전 GTT DURATION = SYS$SESSION → ON COMMIT PRESERVE ROWS.",
    "",
]
gtt_sig = []
for tname, duration in gtts:
    cols, rows = fetch_rows("""SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE,
                                      CHAR_USED, CHAR_LENGTH, NULLABLE, DATA_DEFAULT
                               FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t
                               ORDER BY COLUMN_ID""", {"t": tname})
    defs = []
    for r in rows:
        c = dict(zip(cols, r))
        seg = f"    {c['COLUMN_NAME']:38s} {col_type(c)}"
        dflt = (c["DATA_DEFAULT"] or "")
        dflt = dflt.strip() if isinstance(dflt, str) else ""
        if dflt and dflt.upper() != "NULL":
            seg += f" DEFAULT {dflt}"
        if c["NULLABLE"] == "N":
            seg += " NOT NULL"
        defs.append(seg)
    oncommit = "ON COMMIT PRESERVE ROWS" if duration == "SYS$SESSION" else "ON COMMIT DELETE ROWS"
    gtt_sig.append((tname, len(rows)))
    lines.append(f"-- {tname} ({len(rows)} cols, {duration})")
    lines.append("BEGIN EXECUTE IMMEDIATE q'[")
    lines.append(f"CREATE GLOBAL TEMPORARY TABLE SCM_MGR.{tname} (")
    lines.append(",\n".join(defs))
    lines.append(f") {oncommit}")
    lines.append("]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;")
    lines.append("/")
    lines.append("")
write("01_DDL_GTT.sql", "\n".join(lines), f"GTT {len(gtt_names)}본")

# ────────────────────────────────────────────────────────────────────────────────
# 2) 02_DDL_GTT_INDEX.sql
# ────────────────────────────────────────────────────────────────────────────────
cols, rows = fetch_rows("""SELECT i.TABLE_NAME, i.INDEX_NAME, i.UNIQUENESS,
       LISTAGG(c.COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY c.COLUMN_POSITION) COLS
  FROM ALL_INDEXES i JOIN ALL_IND_COLUMNS c
    ON c.INDEX_OWNER = i.OWNER AND c.INDEX_NAME = i.INDEX_NAME
 WHERE i.OWNER='SCM_MGR' AND i.TABLE_NAME IN (SELECT TABLE_NAME FROM ALL_TABLES
        WHERE OWNER='SCM_MGR' AND TEMPORARY='Y')
   AND i.TABLE_NAME IN (%s)
 GROUP BY i.TABLE_NAME, i.INDEX_NAME, i.UNIQUENESS ORDER BY 1,2""" % inl, b)
ilines = [
    f"-- {STAMP} / A_DB/02_DDL_GTT_INDEX.sql",
    "-- GTT 인덱스 자급 DDL (2026-08-06 PERF 분 포함). 멱등 — ORA-00955(이름중복)/ORA-01408(동일 컬럼목록) skip.",
    "",
]
for r in rows:
    v = dict(zip(cols, r))
    uniq = "UNIQUE " if v["UNIQUENESS"] == "UNIQUE" else ""
    ilines.append(f"-- {v['INDEX_NAME']} ON {v['TABLE_NAME']} ({v['COLS']})")
    ilines.append("BEGIN EXECUTE IMMEDIATE q'[")
    ilines.append(f"CREATE {uniq}INDEX SCM_MGR.{v['INDEX_NAME']} ON SCM_MGR.{v['TABLE_NAME']} ({v['COLS']})")
    ilines.append("]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -1408) THEN RAISE; END IF; END;")
    ilines.append("/")
    ilines.append("")
write("02_DDL_GTT_INDEX.sql", "\n".join(ilines), f"IDX {len(rows)}본")
counts["_GTT_IDX_ROWS"] = len(rows)

# ────────────────────────────────────────────────────────────────────────────────
# 3) PKG 4본 SPEC/BODY — 라이브 ALL_SOURCE 원문
# ────────────────────────────────────────────────────────────────────────────────
# ⚠ 헤더 주석에 검증 마커 리터럴을 절대 넣지 않는다 —
#    실행기가 선행 주석을 statement 에 함께 넘기면 ALL_SOURCE 에 섞여 마커 카운트가 어긋난다.
PKG_FILES = [
    ("PKG_SCM0002", "10_PKG_SCM0002_SPEC.sql", "11_PKG_SCM0002_BODY.sql",
     "공유 PKG — 전체 원문(부분 발췌 금지). versionWf 팝업 P_SCM0002_GET_VERSIONBYWATERFALLPOPUP 포함"),
    ("PKG_DMF0035", "12_PKG_DMF0035_SPEC.sql", "13_PKG_DMF0035_BODY.sql",
     "⭐ 2026-08-20 조회 튜닝 포함 (상관 스칼라 2분기 → 선계산 LEFT JOIN. MKT GET 141s→4.2s)\n"
     "-- 검증 마커는 90_VERIFY V3-1 참조 (헤더에 마커 리터럴 금지)"),
    ("PKG_DMF0022", "14_PKG_DMF0022_SPEC.sql", "15_PKG_DMF0022_BODY.sql",
     "⭐ 2026-08-20 08-06 정본 재적용분 (08-10 구세대 회귀 정정 — 미적용 시 SALES PLAN 0행)\n"
     "-- 검증 마커는 90_VERIFY V3-2 참조 (헤더에 마커 리터럴 금지)"),
    ("PKG_DMF0051", "16_PKG_DMF0051_SPEC.sql", "17_PKG_DMF0051_BODY.sql",
     "BIZ PLAN 계열 (2026-08-07 최종)"),
]
pkg_meta = {}
for name, fspec, fbody, note in PKG_FILES:
    for typ, fname in (("PACKAGE", fspec), ("PACKAGE BODY", fbody)):
        cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                       AND TYPE=:t ORDER BY LINE""", {"n": name, "t": typ})
        body = "".join(x for (x,) in cur if x is not None)
        head = (f"-- {STAMP} / {fname}\n"
                f"-- {name} {typ} — 사내 Oracle 라이브 ALL_SOURCE 신선 덤프 (2026-08-20).\n"
                f"-- {note}\n"
                f"-- ⚠ 단독 실행 (SPEC → BODY 순서). 누적 패치 조합 아님 = 현재 라이브 원문 그대로.\n")
        write(fname, head + "CREATE OR REPLACE " + body + "\n/\n", note if typ == "PACKAGE BODY" else "")
    cur.execute("""SELECT STATUS, LAST_DDL_TIME FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                   AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'""", {"n": name})
    pkg_meta[name] = cur.fetchone()

# ────────────────────────────────────────────────────────────────────────────────
# 4) 20_MENU_META_SYNC.sql
# ────────────────────────────────────────────────────────────────────────────────
menu_lines = [
    f"-- {STAMP} / A_DB/20_MENU_META_SYNC.sql",
    "-- 메뉴/버튼/권한/API/프로그램 축 — 딕셔너리 기계 전수 스윕 결과 (손나열 금지 계보 2026-08-14).",
    "--   스윕 방식: SCM_MGR 의 PROGRAM_ID/MENU_ID/MNU_ID 컬럼 보유 테이블 39종 전수 → 'DMF0035' 행 카운트.",
    "--   TITLESET_USER(607행) = 사용자 개인화 → 이관 제외 (사용자 지시).",
    "--   SCM_COM_SYS_LOG(151행) / NSCM_UI_TEMP* / *_BAK / *_0408 등 로그·백업 테이블 = 이관 제외.",
    "-- 감사컬럼은 원본 실측값 그대로 (사내 등록분 = 'admin').",
    "",
]
axis_counts = {}
for tbl, keys, sql, label in [
    ("SCM_ADM_MNU_M", ["MNU_ID"],
     "SELECT * FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0035'", "메뉴 1행 (ROUTE_PATH='report/demand-plan-waterfall')"),
    ("SCM_ADM_PROGRAM", ["PROGRAM_ID"],
     "SELECT * FROM SCM_MGR.SCM_ADM_PROGRAM WHERE PROGRAM_ID='DMF0035'", "프로그램 마스터"),
    ("SCM_ADM_API_M", ["API_ID"],
     """SELECT * FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID IN
        (SELECT DISTINCT API_ID FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0035')
        ORDER BY API_ID""", "API 배선 (SP 8본)"),
    ("SCM_ADM_MNU_BTN_MPG_M", ["MNU_ID", "SHT_NM", "MNU_BTN_CD"],
     "SELECT * FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0035' ORDER BY SHT_NM", "버튼-API 배선"),
    ("SCM_ADM_USER_GR_MNU_MPG_M", ["USER_GR_ID", "MNU_ID"],
     "SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='DMF0035' ORDER BY USER_GR_ID", "권한그룹-메뉴 접근"),
    ("SCM_ADM_USER_GR_MNU_BTN_MPG_M", ["USER_GR_ID", "MNU_ID", "SHT_NM", "MNU_BTN_CD"],
     "SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0035' ORDER BY USER_GR_ID, SHT_NM", "권한그룹-버튼 권한"),
]:
    stmts, n = merge_stmts(tbl, keys, sql)
    axis_counts[tbl] = n
    menu_lines.append(f"-- ── {tbl} : {n} rows ({label}) " + "─" * 10)
    menu_lines += ["", *[s + "\n" for s in stmts]] if n else ["-- ⚠ 0행 (사내 실측 0 — 이관 대상 없음)", ""]
menu_lines.append("COMMIT;")
write("20_MENU_META_SYNC.sql", "\n".join(menu_lines),
      " / ".join(f"{k.replace('SCM_ADM_','')}={v}" for k, v in axis_counts.items()))

# ────────────────────────────────────────────────────────────────────────────────
# 5) 21_CMBO_SYNC.sql — FE 실소비 콤보 (grep 실측)
# ────────────────────────────────────────────────────────────────────────────────
CMBOS = [
    ("QtyType", "QTY 환산 배수 — 2026-08-06 DMF0035 작업분"),
    ("ReportBucketType", "Report Bucket(ONLY_WEEKLY 포함) — 2026-08-06 DMF0035 작업분"),
    ("BucketType2", "BIZ 버킷 M/Q/Y (⚠ 공유 — DMF0042 도 소비)"),
    ("SenderCode", "EDI Sender Code (⚠ 공유)"),
    ("ItemType", "Item Type (⚠ 공유)"),
    ("UserSiteByEndCustomer", "Sales Site (⚠ 공유 — SalesSiteField comboId)"),
    ("MyDivision", "Version 모달 Division (⚠ 공유)"),
]
clines = [
    f"-- {STAMP} / A_DB/21_CMBO_SYNC.sql",
    "-- SCM_ADM_CMBO_SQL_M — DMF0035 FE 가 실제 소비하는 콤보 7본 (FE grep 실측).",
    "--   Form: useTabComboQueries(['SenderCode','ItemType','ReportBucketType','BucketType2','QtyType'])",
    "--         + SalesSiteField comboId='UserSiteByEndCustomer'",
    "--   Version 모달: useTabComboQueries(['MyDivision'])",
    "--   그 외 조회조건(Division/Team/EndCustomer/BizType/PlantSite/Owner/Project/Item)은",
    "--   @master 공용 필드 컴포넌트가 자체 콤보를 쓰므로 본 화면 전용 신규 등록 없음.",
    "-- ⚠ 공유 콤보 표시된 5본은 타 화면도 소비 — 클라우드 본문이 사내와 다르면 덮어쓰기 충돌.",
    "--    적용 전 00_CLOUD_PRECHECK C4(콤보 본문 diff) 확인 후 판단할 것.",
    "",
]
cmbo_rows = 0
for sid, note in CMBOS:
    stmts, n = merge_stmts("SCM_ADM_CMBO_SQL_M", ["SQL_ID"],
                           "SELECT * FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = :s", {"s": sid})
    cmbo_rows += n
    clines.append(f"-- ── {sid} : {n} row  ({note})")
    if n == 0:
        clines.append("-- ⚠ 0행 — 사내 미등록 (조용한 스킵 방지 위해 명기)")
    clines += ["", *[s + "\n" for s in stmts]]
clines.append("COMMIT;")
write("21_CMBO_SYNC.sql", "\n".join(clines), f"CMBO {cmbo_rows}본")
counts["_CMBO_ROWS"] = cmbo_rows

# ────────────────────────────────────────────────────────────────────────────────
# 6) 22_SHEET_META_SYNC.sql — SHEET_NAME 단위 삭제 후 전체 재적재 (hook #98 §9)
# ────────────────────────────────────────────────────────────────────────────────
#   PKG 실측 변수 대입 (주석 아닌 LIVE 코드):
#     PKG_DMF0035  V_P_PROGRAM_ID='DMF0035'  V_P_COLS_SHEET='Mkt Fcst Waterfall'  (TITLESET='mktFcstWaterfall')
#     PKG_DMF0022  v_program_id ='DMF0022'   v_sheet_name  ='salesPlanWaterfall'  v_measure_sheet='Sales Plan Waterfall'
#     PKG_DMF0051  V_PROGRAM_ID ='DMF0051'   V_SHEET_NAME  ='Biz Plan Waterfall'
SHEET_COL_NAMES = ["Mkt Fcst Waterfall", "salesPlanWaterfall", "Biz Plan Waterfall"]
SHEET_MSR_NAMES = ["Mkt Fcst Waterfall", "Sales Plan Waterfall", "Biz Plan Waterfall"]

slines = [
    f"-- {STAMP} / A_DB/22_SHEET_META_SYNC.sql",
    "-- 시트 메타 = SHEET_NAME 단위 삭제 후 전체 재적재 (hook #98 §9).",
    "--   ⭐ 삭제 범위 = 삽입 범위 — 공유 시트의 타 PROGRAM_ID 행을 전량 동봉한다.",
    "-- ⚠ sheet_name 3체계 (데이터 개명 금지 — 실측값 그대로):",
    "--     SHEET_COLUMNS : DMF0035='Mkt Fcst Waterfall' / DMF0022='salesPlanWaterfall' / DMF0051='Biz Plan Waterfall'",
    "--     SHEET_MEASURE : DMF0035='Mkt Fcst Waterfall' / DMF0022='Sales Plan Waterfall' / DMF0051='Biz Plan Waterfall'",
    "--     TITLESET_USER : 'mktFcstWaterfall'/'salesPlanWaterfall'/'Biz Plan Waterfall'  → ⛔ 이관 제외",
    "",
]
sheet_counts = {}
for tbl, names, order in [
    ("SCM_MST_SHEET_COLUMNS", SHEET_COL_NAMES, "SORT_ORDER_NO, PROGRAM_ID, COLUMN_NAME"),
    ("SCM_MST_SHEET_MEASURE", SHEET_MSR_NAMES, "SORT_ORDER_NO, PROGRAM_ID, COLUMN_NAME"),
]:
    slines.append(f"-- ══════════ {tbl} ══════════")
    for sh in names:
        cols, rows = fetch_rows(
            f"SELECT * FROM SCM_MGR.{tbl} WHERE SHEET_NAME = :s ORDER BY {order}", {"s": sh})
        cur.execute(f"SELECT PROGRAM_ID, COUNT(*) FROM SCM_MGR.{tbl} WHERE SHEET_NAME=:s GROUP BY PROGRAM_ID ORDER BY 1",
                    {"s": sh})
        brk = ", ".join(f"{a}={c}" for a, c in cur)
        sheet_counts[f"{tbl}|{sh}"] = (len(rows), brk)
        slines.append(f"-- ── SHEET_NAME='{sh}' : {len(rows)} rows  [{brk}]")
        if not rows:
            slines.append("-- ⚠ 0행 (사내 실측 0)")
            continue
        slines.append(f"DELETE FROM SCM_MGR.{tbl} WHERE SHEET_NAME = {lit(sh)};")
        for r in rows:
            v = dict(zip(cols, r))
            slines.append(f"INSERT INTO SCM_MGR.{tbl} ({', '.join(cols)})\n"
                          f"VALUES ({', '.join(lit(v[c]) for c in cols)});")
        slines.append("")
slines.append("COMMIT;")
write("22_SHEET_META_SYNC.sql", "\n".join(slines),
      " / ".join(f"{k.split('|')[1]}={v[0]}" for k, v in sheet_counts.items()))

# ────────────────────────────────────────────────────────────────────────────────
# 7) 23_MSG_LBL_MNU_SYNC.sql — MSG/LBL/MNU 4분류 동봉 의무
# ────────────────────────────────────────────────────────────────────────────────
#   축 = FE 폴더 전수 grep (MSG\d{5}|LBL\d{5}|MNU\d{5}) + MNU_M.MNU_MSG_ID + 조상 메뉴 라벨
CODES_LIVE = ['LBL00001', 'LBL00031', 'LBL00090', 'LBL00112', 'LBL00608', 'LBL00627',
              'LBL00664', 'LBL00665', 'LBL00687', 'LBL00710', 'LBL00852', 'LBL00853',
              'LBL00854', 'MNU00179', 'MSG00013', 'MSG00097', 'MSG00108', 'MSG00137',
              'MSG00164', 'MSG00283']
CODES_META = ['MNU00691', 'MNU00020']   # MNU_M.MNU_MSG_ID (본 화면 + 상위 Demand_Waterfall)
mlines = [
    f"-- {STAMP} / A_DB/23_MSG_LBL_MNU_SYNC.sql",
    "-- SCM_ADM_MSG_M — MSG/LBL/MNU 는 동일 테이블(MSG_TP_CD 로 구분). 라벨 전용 테이블은 없음(딕셔너리 실측).",
    "-- 축 = ① FE 폴더 전수 grep (MSG|LBL|MNU)\\d{5} LIVE 20종  ② MNU_M.MNU_MSG_ID 2종(MNU00691/MNU00020)",
    "--   주석에만 등장하는 LBL00774(Mail Setup·SYS0017 점유) / MSG00109 는 제외 (hook #138).",
    "-- 신규 채번분 = LBL00852~854 (Day/Week/Manual, 2026-08-06). 나머지는 기존 코드 재사용.",
    "",
]
msg_rows = 0
for code in CODES_LIVE + CODES_META:
    stmts, n = merge_stmts("SCM_ADM_MSG_M", ["MSG_ID", "LANG_CD"],
                           "SELECT * FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID = :m ORDER BY LANG_CD",
                           {"m": code})
    msg_rows += n
    if n != 3:
        mlines.append(f"-- ⚠ {code}: {n} rows (3언어 아님 — 확인 필요)")
    mlines += [s + "\n" for s in stmts]
mlines.append("COMMIT;")
write("23_MSG_LBL_MNU_SYNC.sql", "\n".join(mlines), f"{len(CODES_LIVE + CODES_META)}코드 / {msg_rows}행")
counts["_MSG_ROWS"] = msg_rows

# ────────────────────────────────────────────────────────────────────────────────
# 리포트
# ────────────────────────────────────────────────────────────────────────────────
print("\n=== 축별 실측 카운트 ===")
for k, v in axis_counts.items():
    print(f"  {k:34s} {v}")
for k, (n, brk) in sheet_counts.items():
    print(f"  {k:34s} {n}  [{brk}]")
print(f"  SCM_ADM_CMBO_SQL_M                 {cmbo_rows}")
print(f"  SCM_ADM_MSG_M                      {msg_rows}")
print(f"  GTT                                {len(gtt_names)}")
print(f"  GTT INDEX                          {counts['_GTT_IDX_ROWS']}")
print("\n=== PKG BODY STATUS ===")
for k, v in pkg_meta.items():
    print(f"  {k:14s} {v}")

con.close()
print("\ngenerate DONE (DB 무변경 — SELECT only)")
