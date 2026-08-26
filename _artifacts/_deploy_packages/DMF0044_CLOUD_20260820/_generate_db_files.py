#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0044_CLOUD_20260820 — A_DB 산출물 생성기 (사내 라이브 신선 덤프, READ-ONLY).

생성 대상
  01_DDL_GTT.sql             GTT 18본 멱등 생성 DDL (소스 grep(LIVE) + ALL_DEPENDENCIES 양축 스윕)
  02_DDL_GTT_INDEX.sql       GTT 인덱스 자급 DDL
  10_PKG_DMF0044_SPEC.sql    ALL_SOURCE 라이브 원문 (누적 패치 조합 아님)
  11_PKG_DMF0044_BODY.sql    ALL_SOURCE 라이브 원문 — 2026-08-20 CFMERGE/CFSETBASED/CFNOSTATS/EXAUTH 포함
  20_MENU_META_SYNC.sql      MNU_M / PROGRAM / API_M / MNU_BTN_MPG_M / USER_GR_MNU_MPG_M / USER_GR_MNU_BTN_MPG_M
  21_CMBO_SYNC.sql           SCM_ADM_CMBO_SQL_M (FE grep + 시트 메타 CELL_COMBO_DATA_TYPE 양축)
  22_SHEET_META_SYNC.sql     SHEET_COLUMNS / SHEET_MEASURE — SHEET_NAME 단위 삭제 후 전체 재적재
  23_MSG_LBL_MNU_SYNC.sql    SCM_ADM_MSG_M (MSG/LBL/MNU 동일 테이블)
  24_PROC_M_SYNC.sql         ⭐ SCM_ADM_PROC_M (누락 시 PLS-00306 — DMF0035 사고 계보)
  25_EXCEL_COLUMNS_SYNC.sql  SCM_ADM_EXCEL_COLUMNS — 0행 축 명기 (조용한 스킵 금지)

(00_CLOUD_PRECHECK / 18_GRANT_SYNONYM / 90_VERIFY 는 수기 작성 파일)

⛔ 본 스크립트는 SELECT 만 수행한다. DDL/DML 실행 없음.
"""
import io
import sys
import re
import json
import pathlib
import datetime

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

OUT = pathlib.Path(__file__).resolve().parent / "A_DB"
OUT.mkdir(exist_ok=True)
STAMP = "DMF0044_CLOUD_20260820"
UI = "DMF0044"
PKG = "PKG_DMF0044"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
counts = {}
axis_counts = {}


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


def pk_cols(table):
    """MERGE ON 키 = ALL_CONSTRAINTS/ALL_CONS_COLUMNS 실측 PK (추정 금지)."""
    _, rows = fetch_rows("""SELECT cc.COLUMN_NAME
          FROM ALL_CONSTRAINTS c JOIN ALL_CONS_COLUMNS cc
            ON cc.OWNER=c.OWNER AND cc.CONSTRAINT_NAME=c.CONSTRAINT_NAME
         WHERE c.OWNER='SCM_MGR' AND c.TABLE_NAME=:t AND c.CONSTRAINT_TYPE='P'
         ORDER BY cc.POSITION""", {"t": table})
    return [r[0] for r in rows]


def merge_stmts(table, key_cols, sql, binds=None):
    cols, rows = fetch_rows(sql, binds)
    # ON 키 유일성 실측 assert (중복 INSERT 사고 계보 회피)
    seen = set()
    for r in rows:
        v = dict(zip(cols, r))
        k = tuple(str(v[c]) for c in key_cols)
        assert k not in seen, f"{table} ON 키 중복: {k}"
        seen.add(k)
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
    print(f"  {fname:34s} {n:6d} lines   {note}")


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


# ────────────────────────────────────────────────────────────────────────────────
# 0) GTT 축 = 소스 grep(LIVE) + ALL_DEPENDENCIES 양축 전수 스윕
# ────────────────────────────────────────────────────────────────────────────────
print(f"[0] GTT 전수 스윕 ({PKG})")
src_live = []
for t in ("PACKAGE", "PACKAGE BODY"):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE",
                {"n": PKG, "t": t})
    src_live.append(strip_comments("".join(x for (x,) in cur if x is not None)))
grep_axis = set(re.findall(r"\bGT_[A-Z0-9_]+", "\n".join(src_live).upper()))

cur.execute("""SELECT DISTINCT REFERENCED_NAME FROM ALL_DEPENDENCIES
               WHERE OWNER='SCM_MGR' AND NAME=:n
                 AND REFERENCED_TYPE='TABLE' AND REFERENCED_NAME LIKE 'GT!_%' ESCAPE '!'""", {"n": PKG})
dep_axis = {r[0] for r in cur}

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
    return dt


lines = [
    f"-- {STAMP} / A_DB/01_DDL_GTT.sql",
    "-- GLOBAL TEMPORARY TABLE 자급 DDL — 기존재 가정 금지 (룰 22 이관패키지 GTT/TYPE 자급 의무).",
    f"-- 축 확정 = ① {PKG} 소스 grep(주석 제거 LIVE) ② ALL_DEPENDENCIES 양축 합집합 → 딕셔너리 교차.",
    f"--   grep {len(grep_axis)}종 / dep {len(dep_axis)}종 / 실존 GTT {len(gtt_names)}종 (양축 완전 일치).",
    "-- ⚠ -955(기존재) skip 방식의 맹점: 이름만 같고 컬럼 구조가 다른 구세대 GTT 가 남아 있으면",
    "--    조용히 통과한 뒤 런타임 ORA-00904/00932 로 터진다.",
    "--    적용 전 00_CLOUD_PRECHECK C2 의 컬럼 시그니처 대조를 반드시 수행할 것.",
    "-- DURATION 은 사내 실측 그대로 (SYS$SESSION → ON COMMIT PRESERVE ROWS / SYS$TRANSACTION → DELETE ROWS).",
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
    gtt_sig.append((tname, len(rows), duration))
    lines.append(f"-- {tname} ({len(rows)} cols, {duration})")
    lines.append("BEGIN EXECUTE IMMEDIATE q'[")
    lines.append(f"CREATE GLOBAL TEMPORARY TABLE SCM_MGR.{tname} (")
    lines.append(",\n".join(defs))
    lines.append(f") {oncommit}")
    lines.append("]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;")
    lines.append("/")
    lines.append("")
write("01_DDL_GTT.sql", "\n".join(lines), f"GTT {len(gtt_names)}본")
axis_counts["GTT(DDL)"] = len(gtt_names)

# ────────────────────────────────────────────────────────────────────────────────
# 2) 02_DDL_GTT_INDEX.sql
# ────────────────────────────────────────────────────────────────────────────────
cols, rows = fetch_rows("""SELECT i.TABLE_NAME, i.INDEX_NAME, i.UNIQUENESS,
       LISTAGG(c.COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY c.COLUMN_POSITION) COLS
  FROM ALL_INDEXES i JOIN ALL_IND_COLUMNS c
    ON c.INDEX_OWNER = i.OWNER AND c.INDEX_NAME = i.INDEX_NAME
 WHERE i.OWNER='SCM_MGR' AND i.TABLE_NAME IN (%s)
 GROUP BY i.TABLE_NAME, i.INDEX_NAME, i.UNIQUENESS ORDER BY 1,2""" % inl, b)
ilines = [
    f"-- {STAMP} / A_DB/02_DDL_GTT_INDEX.sql",
    "-- GTT 인덱스 자급 DDL. 멱등 — ORA-00955(이름중복) / ORA-01408(동일 컬럼목록) skip.",
    f"-- 사내 실측 {len(rows)}본.",
    "",
]
if not rows:
    ilines.append("-- ⚠ 0행 (사내 실측 0 — 본 화면 GTT 에 인덱스 없음. 조용한 스킵 방지 위해 명기)")
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
axis_counts["GTT INDEX"] = len(rows)

# ────────────────────────────────────────────────────────────────────────────────
# 3) PKG SPEC/BODY — 라이브 ALL_SOURCE 원문
#    ⚠ 헤더 주석에 검증 마커 리터럴 금지 (ALL_SOURCE 마커 카운트 교란 방지)
#    ⚠ 헤더 주석 안에 "PACKAGE BODY" 문자열도 금지 —
#      그 문자열로 자르는 실행기가 CREATE OR REPLACE 를 주석에 먹여 실행 불가로 만든다 (2026-08-20 실사고)
# ────────────────────────────────────────────────────────────────────────────────
pkg_meta = {}
for typ, fname, kind in (("PACKAGE", "10_PKG_DMF0044_SPEC.sql", "SPEC"),
                         ("PACKAGE BODY", "11_PKG_DMF0044_BODY.sql", "BODY")):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE",
                {"n": PKG, "t": typ})
    src = "".join(x for (x,) in cur if x is not None)
    head = "\n".join([
        f"-- {STAMP} / {fname}",
        f"-- {PKG} {kind} — 사내 Oracle 라이브 ALL_SOURCE 신선 덤프 (2026-08-20 19:17 적용분).",
        "-- 누적 패치 조합 아님 = 현재 사내 라이브 원문 그대로. SPEC(10) → BODY(11) 순서로 단독 실행.",
        "-- 2026-08-20 적용분(Cutoff 저장 MERGE ON 이동 / 행별 ROWID 루프 set-based 전환 /",
        "--   저장 시 통계수집 제거 / 환율 팝업 권한 뷰 OUTER 전환 4지점) 포함.",
        "-- 검증 마커 카운트는 90_VERIFY V2 참조 (헤더에 마커 리터럴을 넣지 않는다 — ALL_SOURCE 교란 방지).",
        "SET DEFINE OFF",
        "SET SQLBLANKLINES ON",
        "",
    ])
    text = head + "CREATE OR REPLACE " + src.rstrip("\n") + "\n/\nSHOW ERRORS\n"

    # ── 자기검증: 주석·SET 제외 첫 실행 라인이 CREATE OR REPLACE PACKAGE [BODY] 인가 ──
    first = None
    for ln in text.split("\n"):
        s = ln.strip()
        if not s or s.startswith("--") or s.upper().startswith("SET "):
            continue
        first = " ".join(s.split()).upper()
        break
    expect = "CREATE OR REPLACE PACKAGE BODY" if typ == "PACKAGE BODY" else "CREATE OR REPLACE PACKAGE"
    assert first and first.startswith(expect), f"[ASSERT FAIL] {fname} 첫 실행 라인={first!r}"
    # 헤더 주석에 'PACKAGE BODY' 리터럴이 섞이지 않았는지 (절단 사고 방지)
    for ln in text.split("\n"):
        if not ln.strip().startswith("--"):
            break
        assert "PACKAGE BODY" not in ln.upper(), f"[ASSERT FAIL] {fname} 헤더 주석에 PACKAGE BODY 리터럴"
    write(fname, text, f"assert OK ({first[:34]}…)")

cur.execute("""SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
               FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n ORDER BY 1""", {"n": PKG})
pkg_meta[PKG] = cur.fetchall()

# ────────────────────────────────────────────────────────────────────────────────
# 4) 20_MENU_META_SYNC.sql
# ────────────────────────────────────────────────────────────────────────────────
MENU_AXES = [
    ("SCM_ADM_MNU_M", "SELECT * FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0044'",
     "⭐ 메뉴 행 — 누락 시 권한 뷰 0행 → 전 조회가 조용히 0행 (DMF0035 2026-08-20 사고)"),
    ("SCM_ADM_PROGRAM", "SELECT * FROM SCM_MGR.SCM_ADM_PROGRAM WHERE PROGRAM_ID='DMF0044'",
     "프로그램 마스터"),
    ("SCM_ADM_API_M", """SELECT * FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID IN
        (SELECT DISTINCT API_ID FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0044' AND API_ID IS NOT NULL)
        ORDER BY API_ID""", "API 배선 (SP 라우팅)"),
    ("SCM_ADM_MNU_BTN_MPG_M",
     "SELECT * FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0044' ORDER BY SHT_NM, MNU_BTN_CD",
     "⭐ 버튼-API 배선 (2026-08-20 신설 EXRATE_SAVE 포함 — API_ID NULL = 권한 판정 전용)"),
    ("SCM_ADM_USER_GR_MNU_MPG_M",
     "SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='DMF0044' ORDER BY USER_GR_ID",
     "⭐ 권한그룹-메뉴 접근 — 누락 시 권한 뷰 0행"),
    ("SCM_ADM_USER_GR_MNU_BTN_MPG_M",
     "SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0044' ORDER BY USER_GR_ID, SHT_NM, MNU_BTN_CD",
     "⭐ 권한그룹-버튼 권한 (2026-08-20 EXRATE_SAVE ADMIN/DM ADMIN 2행 포함)"),
]
menu_lines = [
    f"-- {STAMP} / A_DB/20_MENU_META_SYNC.sql",
    "-- 메뉴/프로그램/API/버튼/권한 축 — 딕셔너리 기계 전수 스윕 결과 (손나열 금지 계보 2026-08-14).",
    "--   스윕 방식 = SCM_MGR 의 PROGRAM_ID/MENU_ID/MNU_ID/UI_ID/SCREEN_ID 컬럼 보유 테이블 54종 전수 →",
    "--                'DMF0044' 행 카운트 → HIT 14축 중 이관 대상만 채택.",
    "--   이관 제외(명기): SCM_MST_TITLESET_USER(234행 — 사용자 개인화) /",
    "--                    SCM_COM_SYS_LOG(985행 — 로그) / NSCM_UI_TEMP·_0211·_0304(각 3행 — 임시) /",
    "--                    SCM_MST_SHEET_COLUMNS_0408·_260408(각 58행 — 백업 테이블).",
    "-- MERGE ON 키 = ALL_CONSTRAINTS/ALL_CONS_COLUMNS 실측 PK (추정 금지 — 아래 각 축 헤더에 명기).",
    "-- 감사컬럼은 원본 실측값 그대로 (2026-08-20 신설분 = 'admin').",
    "",
]
for tbl, sql, label in MENU_AXES:
    keys = pk_cols(tbl)
    assert keys, f"{tbl} PK 미측정"
    stmts, n = merge_stmts(tbl, keys, sql)
    axis_counts[tbl] = n
    menu_lines.append(f"-- ── {tbl} : {n} rows  [PK={', '.join(keys)}]")
    menu_lines.append(f"--    {label}")
    if n:
        menu_lines += ["", *[s + "\n" for s in stmts]]
    else:
        menu_lines += ["-- ⚠ 0행 (사내 실측 0 — 이관 대상 없음)", ""]
menu_lines.append("COMMIT;")
write("20_MENU_META_SYNC.sql", "\n".join(menu_lines),
      " / ".join(f"{t.replace('SCM_ADM_', '')}={axis_counts[t]}" for t, _, _ in MENU_AXES))

# ────────────────────────────────────────────────────────────────────────────────
# 5) 21_CMBO_SYNC.sql — FE grep + 시트 메타 CELL_COMBO_DATA_TYPE 양축
# ────────────────────────────────────────────────────────────────────────────────
FE_COMBOS = {
    "MDF_TYPE": "조회조건 Report Type (SalesReportsForm useTabComboQueries)",
    "MDF_TYPE2": "조회조건 Report Type2 (동)",
    "CALENDAR_YYYY": "조회조건 Year (동)",
    "DMF0044_DEPARTMENT_TEAM2": "행별 콤보 ROW_COMBO_IDS.DEPT_DEFAULT",
    "DMF0044_DEPARTMENT_TEAM": "행별 콤보 ROW_COMBO_IDS.DEPT_BY_DEPARTMENT",
    "DMF0044_ETC_SALE_RESULT_TYPE_40": "행별 콤보 ROW_COMBO_IDS.DEPT_ETC",
    "DMF0005_REPORT_GROUP2": "행별 콤보 ROW_COMBO_IDS.CUST_REPORT (⚠ 공유 — DMF0005 계열)",
    "DMF0005_REPORT_GROUP3": "행별 콤보 ROW_COMBO_IDS.PRODUCT_GROUP (⚠ 공유 — DMF0005 계열)",
}
cur.execute("""SELECT DISTINCT CELL_COMBO_DATA_TYPE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
               WHERE PROGRAM_ID='DMF0044' AND CELL_COMBO_DATA_TYPE IS NOT NULL
                 AND TRIM(CELL_COMBO_DATA_TYPE) IS NOT NULL ORDER BY 1""")
meta_combos = [r[0] for r in cur]
combo_axis = []
for sid in sorted(set(list(FE_COMBOS) + meta_combos)):
    src_tag = []
    if sid in FE_COMBOS:
        src_tag.append("FE grep")
    if sid in meta_combos:
        src_tag.append("시트메타 CELL_COMBO_DATA_TYPE")
    combo_axis.append((sid, " + ".join(src_tag), FE_COMBOS.get(sid, "")))

clines = [
    f"-- {STAMP} / A_DB/21_CMBO_SYNC.sql",
    "-- SCM_ADM_CMBO_SQL_M — 축 확정 = ① FE 폴더 grep(useTabComboQueries / ROW_COMBO_IDS / comboId)",
    "--                                ② SCM_MST_SHEET_COLUMNS.CELL_COMBO_DATA_TYPE 딕셔너리 스윕",
    f"--   양축 합집합 {len(combo_axis)}종 (FE {len(FE_COMBOS)} / 메타 {len(meta_combos)}).",
    "--   메타 축의 공백(' ') 값은 '콤보 없음' 센티널이므로 제외했다.",
    "-- ⚠ 공유 콤보 다수 — 클라우드 본문이 사내와 다르면 덮어쓰기 충돌이 된다.",
    "--    적용 전 00_CLOUD_PRECHECK C4(콤보 본문 diff) 확인 후 판단할 것.",
    "--    조회조건 Division/Version 등은 @master 공용 필드 컴포넌트가 자체 콤보를 쓰므로",
    "--    본 화면 전용 신규 등록은 없다.",
    "",
]
cmbo_rows = 0
cmbo_key = pk_cols("SCM_ADM_CMBO_SQL_M") or ["SQL_ID"]
for sid, srct, note in combo_axis:
    stmts, n = merge_stmts("SCM_ADM_CMBO_SQL_M", cmbo_key,
                           "SELECT * FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = :s", {"s": sid})
    cmbo_rows += n
    clines.append(f"-- ── {sid} : {n} row  [{srct}] {note}")
    if n == 0:
        clines.append("-- ⚠ 0행 — 사내 미등록 (조용한 스킵 방지 위해 명기)")
    clines += ["", *[s + "\n" for s in stmts]]
clines.append("COMMIT;")
write("21_CMBO_SYNC.sql", "\n".join(clines), f"CMBO {cmbo_rows}본 / 축 {len(combo_axis)}")
axis_counts["SCM_ADM_CMBO_SQL_M"] = cmbo_rows

# ────────────────────────────────────────────────────────────────────────────────
# 6) 22_SHEET_META_SYNC.sql — SHEET_NAME 단위 삭제 후 전체 재적재 (hook #98 §9)
# ────────────────────────────────────────────────────────────────────────────────
sheet_counts = {}
slines = [
    f"-- {STAMP} / A_DB/22_SHEET_META_SYNC.sql",
    "-- 시트 메타 = SHEET_NAME 단위 삭제 후 전체 재적재 (hook #98 §9).",
    "--   ⭐ 삭제 범위 = 삽입 범위 — 공유 시트의 타 PROGRAM_ID 행을 전량 동봉한다.",
    "--   ⚠ 본 화면의 시트 2종이 공유 시트다:",
    "--       'MDF Reports'  ← DMF0044 + DMF0049 (SHEET_COLUMNS / SHEET_MEASURE 양쪽)",
    "--       'MDFVerpopup'  ← DMF0044 + DMF0041 (SHEET_COLUMNS)",
    "--     따라서 DELETE 는 SHEET_NAME 전체를 지우고, INSERT 도 타 PROGRAM_ID 행을 함께 넣는다.",
    "--     (부분 삭제·부분 삽입 시 타 화면 메타가 소실된다.)",
    "-- ⛔ SCM_MST_TITLESET_USER('MDF Reports' 70 / 'mdfReports' 164) = 사용자 개인화 → 이관 제외.",
    "-- SHEET_NAME 개명 금지 — 실측값 그대로.",
    "",
]
cur.execute("SELECT DISTINCT SHEET_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0044' ORDER BY 1")
SHEET_COL_NAMES = [r[0] for r in cur]
cur.execute("SELECT DISTINCT SHEET_NAME FROM SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID='DMF0044' ORDER BY 1")
SHEET_MSR_NAMES = [r[0] for r in cur]
for tbl, names in [("SCM_MST_SHEET_COLUMNS", SHEET_COL_NAMES),
                   ("SCM_MST_SHEET_MEASURE", SHEET_MSR_NAMES)]:
    slines.append(f"-- ══════════ {tbl} ══════════")
    tot = 0
    for sh in names:
        cols, rows = fetch_rows(
            f"SELECT * FROM SCM_MGR.{tbl} WHERE SHEET_NAME = :s ORDER BY SORT_ORDER_NO, PROGRAM_ID, COLUMN_NAME",
            {"s": sh})
        cur.execute(f"SELECT PROGRAM_ID, COUNT(*) FROM SCM_MGR.{tbl} WHERE SHEET_NAME=:s GROUP BY PROGRAM_ID ORDER BY 1",
                    {"s": sh})
        brk = ", ".join(f"{a}={c}" for a, c in cur)
        sheet_counts[f"{tbl}|{sh}"] = (len(rows), brk)
        tot += len(rows)
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
    axis_counts[tbl] = tot
slines.append("COMMIT;")
write("22_SHEET_META_SYNC.sql", "\n".join(slines),
      " / ".join(f"{k.split('|')[1]}={v[0]}" for k, v in sheet_counts.items()))

# ────────────────────────────────────────────────────────────────────────────────
# 7) 23_MSG_LBL_MNU_SYNC.sql — MSG/LBL/MNU 4분류 동봉 의무
# ────────────────────────────────────────────────────────────────────────────────
CODES_LIVE = ['LBL00086', 'LBL00112', 'LBL00121', 'LBL00626', 'LBL00627', 'LBL00661',
              'LBL00664', 'LBL00667', 'LBL00670', 'LBL00712', 'LBL00795', 'LBL00796',
              'LBL00797', 'LBL00798', 'MSG00002', 'MSG00004', 'MSG00096', 'MSG00283',
              'MSG00429', 'MSG00618', 'MSG00676', 'MSG00680', 'MSG00681', 'MSG00682',
              'MSG00683', 'MSG00684', 'MSG00685', 'MSG00686', 'MSG00687', 'MSG00688']
CODES_SHARED = ['MSG00703']                       # 공통 UI-7 (useDirtyRegistry — 화면 닫기 confirm)
CODES_MENU = ['MNU00038', 'MNU00011', 'MNU00002']  # MNU_M.MNU_MSG_ID (본 화면 + 조상 2단)
mlines = [
    f"-- {STAMP} / A_DB/23_MSG_LBL_MNU_SYNC.sql",
    "-- SCM_ADM_MSG_M — MSG / LBL / MNU 는 동일 테이블(MSG_TP_CD 로 구분). 라벨 전용 테이블 없음(딕셔너리 실측).",
    "-- 축 = ① FE 폴더 전수 grep (MSG|LBL|MNU)\\d{5} 중 **주석 제거 LIVE** 30종 (hook #138)",
    "--      ② 공통 UI 경로 1종 (MSG00703 — @shared useDirtyRegistry 화면 닫기 confirm)",
    "--      ③ MNU_M.MNU_MSG_ID 3종 (DMF0044=MNU00038 / Demand_Plan=MNU00011 / Demand=MNU00002)",
    "--   주석에만 등장하여 제외한 코드 6종: LBL00513 / LBL00605 / LBL00665 / MSG00142 / MSG00281 / MSG00321",
    "-- 사내 실측: 34코드 전부 3언어(KO/EN/CN) 완비 — 결손 0.",
    "",
]
msg_rows = 0
msg_key = pk_cols("SCM_ADM_MSG_M") or ["MSG_ID", "LANG_CD"]
for code in CODES_LIVE + CODES_SHARED + CODES_MENU:
    stmts, n = merge_stmts("SCM_ADM_MSG_M", msg_key,
                           "SELECT * FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID = :m ORDER BY LANG_CD",
                           {"m": code})
    msg_rows += n
    if n != 3:
        mlines.append(f"-- ⚠ {code}: {n} rows (3언어 아님 — 확인 필요)")
    mlines += [s + "\n" for s in stmts]
mlines.append("COMMIT;")
write("23_MSG_LBL_MNU_SYNC.sql", "\n".join(mlines),
      f"{len(CODES_LIVE + CODES_SHARED + CODES_MENU)}코드 / {msg_rows}행")
axis_counts["SCM_ADM_MSG_M"] = msg_rows

# ────────────────────────────────────────────────────────────────────────────────
# 8) 24_PROC_M_SYNC.sql — ⭐ 누락 시 PLS-00306 (DMF0035 2026-08-20 사고 계보)
# ────────────────────────────────────────────────────────────────────────────────
cur.execute("""SELECT DISTINCT a.API_URL FROM SCM_MGR.SCM_ADM_API_M a
               WHERE a.API_ID IN (SELECT API_ID FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
                                  WHERE MNU_ID='DMF0044' AND API_ID IS NOT NULL)
               ORDER BY 1""")
api_urls = [r[0] for r in cur]
own = [x for x in api_urls if x.upper().startswith("PKG_DMF0044.")]
shared = [x for x in api_urls if not x.upper().startswith("PKG_DMF0044.")]
proc_key = pk_cols("SCM_ADM_PROC_M")
assert proc_key == ["PROC_NM", "COL_NM", "COL_TP_CD"], f"PROC_M PK 실측 불일치: {proc_key}"

plines = [
    f"-- {STAMP} / A_DB/24_PROC_M_SYNC.sql",
    "-- ⭐ SCM_ADM_PROC_M — generic call-proc 의 인자 바인딩 목록 원천.",
    "--   누락 시 PLS-00306(잘못된 개수 또는 유형의 인수)로 조회가 즉사한다",
    "--   (2026-08-20 DMF0035 클라우드 사고 — 이 축이 통째로 빠져 있었다. hook deploy-package-completeness §4.7).",
    "--",
    f"-- ⭐ MERGE ON 키 = ALL_CONSTRAINTS/ALL_CONS_COLUMNS **실측 PK** = ({', '.join(proc_key)}) — 추정 아님.",
    "--   생성 시 전 행 ON 키 유일성 assert 통과.",
    "--",
    "-- 축 확정 = MNU_BTN_MPG_M ⋈ API_M 역추적 (손나열 아님).",
    f"--   API_URL distinct {len(api_urls)}본 = 본 화면 PKG {len(own)}본 + 공유 객체 {len(shared)}본.",
    "-- ⚠ 공유 객체 3본은 **타 화면 소관 공유 축**이다. 클라우드에 이미 정상 등재돼 있으면 건드리지 말 것:",
    "--     DMF0002_GET_TITLESET_POPUP (standalone PROCEDURE — Column Setup/Measure Select/titleSet 조회)",
    "--     SCM0002_SET_TITLESET_POPUP (standalone PROCEDURE — titleSet 저장)",
    "--     PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE (공용 PKG — unitedVersion 팝업 타이틀)",
    "--   → 아래 §2 로 분리했다. 00_CLOUD_PRECHECK C6 에서 클라우드 행수를 먼저 확인하고,",
    "--     0행이거나 인자수 불일치일 때만 §2 를 실행한다.",
    "--",
    "-- 감사컬럼 = 사내 실측값 그대로. SORT_ORD 도 사내 실측 순서 그대로.",
    "",
    "-- ══════════ §1 본 화면 PKG (PKG_DMF0044) — 항상 적용 ══════════",
    "",
]
proc_axis = {}
proc_rows_own = 0
for pn in own:
    stmts, n = merge_stmts("SCM_ADM_PROC_M", proc_key,
                           "SELECT * FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM = :p ORDER BY SORT_ORD", {"p": pn})
    # ALL_ARGUMENTS 대조 (PKG 멤버)
    pkgn, prcn = pn.split(".", 1)
    cur.execute("""SELECT COUNT(*) FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR'
                   AND PACKAGE_NAME=:pk AND OBJECT_NAME=:pr AND ARGUMENT_NAME IS NOT NULL""",
                {"pk": pkgn, "pr": prcn})
    args = cur.fetchone()[0]
    proc_axis[pn] = (n, args)
    proc_rows_own += n
    flag = "" if n == args else f"   ⚠ PROC_M {n} ≠ ALL_ARGUMENTS {args}"
    plines.append(f"-- ── {pn} : {n}행 (ALL_ARGUMENTS {args}){flag}")
    if n == 0:
        plines.append("-- ⚠ 0행 — 사내 미등재 (조용한 스킵 방지 위해 명기)")
    plines += ["", *[s + "\n" for s in stmts]]
plines.append("COMMIT;")
plines += ["", "-- ══════════ §2 공유 객체 3본 — 클라우드 결손일 때만 적용 (기본 주석 처리) ══════════", ""]
proc_rows_shared = 0
for pn in shared:
    stmts, n = merge_stmts("SCM_ADM_PROC_M", proc_key,
                           "SELECT * FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM = :p ORDER BY SORT_ORD", {"p": pn})
    if "." in pn:
        pkgn, prcn = pn.split(".", 1)
        cur.execute("""SELECT COUNT(*) FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR'
                       AND PACKAGE_NAME=:pk AND OBJECT_NAME=:pr AND ARGUMENT_NAME IS NOT NULL""",
                    {"pk": pkgn, "pr": prcn})
    else:
        cur.execute("""SELECT COUNT(*) FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR'
                       AND PACKAGE_NAME IS NULL AND OBJECT_NAME=:pr AND ARGUMENT_NAME IS NOT NULL""",
                    {"pr": pn})
    args = cur.fetchone()[0]
    proc_axis[pn] = (n, args)
    proc_rows_shared += n
    plines.append(f"-- ── {pn} : {n}행 (ALL_ARGUMENTS {args})")
    if n == 0:
        plines.append("-- ⚠ 0행 — 사내 미등재")
    for s in stmts:
        plines.append("\n".join("-- " + x for x in s.split("\n")))
        plines.append("")
plines.append("-- COMMIT;   ← §2 를 실행했을 때만 주석 해제")
write("24_PROC_M_SYNC.sql", "\n".join(plines),
      f"§1 {proc_rows_own}행({len(own)}본) / §2 {proc_rows_shared}행({len(shared)}본)")
axis_counts["SCM_ADM_PROC_M (§1 본화면)"] = proc_rows_own
axis_counts["SCM_ADM_PROC_M (§2 공유·조건부)"] = proc_rows_shared

# ────────────────────────────────────────────────────────────────────────────────
# 9) 25_EXCEL_COLUMNS_SYNC.sql — 0행 축 명기
# ────────────────────────────────────────────────────────────────────────────────
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID='DMF0044'")
xl = cur.fetchone()[0]
cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS
               WHERE SHEET_NAME IN (SELECT DISTINCT SHEET_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                                    WHERE PROGRAM_ID='DMF0044')""")
xl_sheet = cur.fetchone()[0]
xlines = [
    f"-- {STAMP} / A_DB/25_EXCEL_COLUMNS_SYNC.sql",
    "-- SCM_ADM_EXCEL_COLUMNS 축 — **사내 실측 0행** (조용한 스킵 금지 원칙에 따라 파일로 명기).",
    f"--   PROGRAM_ID='DMF0044'                     : {xl}행",
    f"--   본 화면 SHEET_NAME 3종으로 재조회        : {xl_sheet}행",
    "--",
    "--   즉 DMF0044 는 Excel Form/Upload 메타를 보유하지 않는다.",
    "--   화면의 [EXCEL] 버튼(MNU_BTN_MPG_M 'MDF Reports'/EXCEL)은 조회결과 그대로 내려받는",
    "--   클라이언트 다운로드이며, 업로드 적재 경로가 없다 (hook #135 2-Step Upload 대상 아님).",
    "--   → 적용할 DML 없음. 본 파일은 축 존재 증빙 전용이다.",
    "",
]
write("25_EXCEL_COLUMNS_SYNC.sql", "\n".join(xlines), "0행 축 명기")
axis_counts["SCM_ADM_EXCEL_COLUMNS"] = xl

# ────────────────────────────────────────────────────────────────────────────────
# 리포트 + 기계 판독용 JSON
# ────────────────────────────────────────────────────────────────────────────────
print("\n=== 축별 실측 카운트 ===")
for k, v in axis_counts.items():
    print(f"  {k:36s} {v}")
print("\n=== 시트 메타 상세 ===")
for k, (n, brk) in sheet_counts.items():
    print(f"  {k:52s} {n}  [{brk}]")
print("\n=== PROC_M 상세 (PROC_M행 vs ALL_ARGUMENTS) ===")
for k, (n, a) in proc_axis.items():
    print(f"  {k:60s} {n:3d} / {a:3d} {'OK' if n == a else '⚠ 불일치'}")
print("\n=== GTT 시그니처 ===")
for t, c, du in gtt_sig:
    print(f"  {t:32s} {c:3d} cols  {du}")
print("\n=== PKG 상태 ===")
for k, v in pkg_meta.items():
    print(f"  {k}: {v}")

(pathlib.Path(__file__).resolve().parent / "_axis_counts.json").write_text(
    json.dumps({"axis": axis_counts,
                "sheets": {k: v[0] for k, v in sheet_counts.items()},
                "sheet_breakdown": {k: v[1] for k, v in sheet_counts.items()},
                "proc_m": {k: {"rows": v[0], "args": v[1]} for k, v in proc_axis.items()},
                "gtt": [{"t": t, "cols": c, "duration": du} for t, c, du in gtt_sig],
                "files": counts}, ensure_ascii=False, indent=2), encoding="utf-8")

con.close()
print("\ngenerate DONE (DB 무변경 — SELECT only)")
