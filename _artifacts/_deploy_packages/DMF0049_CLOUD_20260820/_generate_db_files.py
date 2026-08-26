#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0049_CLOUD_20260820 — A_DB 산출물 생성기 (사내 라이브 신선 덤프, READ-ONLY).

생성 대상
  01_DDL_DEFAULT_ON_NULL.sql  NOT NULL 컬럼 DEFAULT ON NULL 멱등 DDL
                              (2026-08-20 사용자 확정. 사내 ALL_TAB_COLUMNS 실측값 그대로 — 추정 금지)
  02_DDL_GTT.sql              GTT 자급 DDL (소스 grep LIVE + ALL_DEPENDENCIES 양축 스윕 → 딕셔너리 교차)
  03_DDL_SEQUENCE.sql         SEQ1_DM_PLN_SALES_ETC_REPORT_H 멱등 (PKG 의존 — 기존재 가정 금지)
  10/11_PKG_DMF0049_*.sql     SPEC/BODY — ALL_SOURCE 라이브 원문 (누적 패치 조합 아님)
  20_MENU_META_SYNC.sql       MNU_M / PROGRAM / API_M / MNU_BTN_MPG_M
                              / USER_GR_MNU_MPG_M / USER_GR_MNU_BTN_MPG_M
  21_CMBO_SYNC.sql            SCM_ADM_CMBO_SQL_M (FE grep LIVE + SHEET_COLUMNS 메타 양축 합집합)
  22_SHEET_META_SYNC.sql      SHEET_COLUMNS / SHEET_MEASURE — SHEET_NAME 단위 삭제 후 전체 재적재
  23_MSG_LBL_MNU_SYNC.sql     SCM_ADM_MSG_M (MSG/LBL/MNU 동일 테이블)
  24_PROC_M_SYNC.sql          ⭐ SCM_ADM_PROC_M — 버튼 배선 역추적 전 SP (누락 시 PLS-00306)
  25_EXCEL_COLUMNS_SYNC.sql   SCM_ADM_EXCEL_COLUMNS (0행 축 — 명기 목적)

(30_GRANT_SYNONYM / 90_VERIFY 는 수기 작성 파일)

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
STAMP = "DMF0049_CLOUD_20260820"
PROG = "DMF0049"
SHEET = "MDF Reports"          # SHEET_COLUMNS / SHEET_MEASURE 공통 (PKG LIVE 대입 실측)
PKG = "PKG_DMF0049"

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
    """MERGE ON 키 = PK 실측값만 사용한다 (추정 금지 — 메모리 feedback_merge_on_key_must_match_pk)."""
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
    print(f"  {fname:34s} {n:6d} lines   {note}")


def strip_comments(text):
    """라인 보존 주석 제거 (hook #138 — 주석은 분석 근거가 아니다)."""
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
# 0) PKG 라이브 소스 확보 (이후 GTT grep 축에도 사용)
# ────────────────────────────────────────────────────────────────────────────────
src = {}
for typ in ("PACKAGE", "PACKAGE BODY"):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                   AND TYPE=:t ORDER BY LINE""", {"n": PKG, "t": typ})
    src[typ] = "".join(x for (x,) in cur if x is not None)
live_src = strip_comments(src["PACKAGE BODY"]) + "\n" + strip_comments(src["PACKAGE"])

# ────────────────────────────────────────────────────────────────────────────────
# 1) 01_DDL_DEFAULT_ON_NULL.sql — 사내 실측 상태를 멱등 DDL 로 동봉
# ────────────────────────────────────────────────────────────────────────────────
#   대상 축도 실측으로 산출한다(손나열 금지):
#     저장 대상 표 2본 × NULLABLE='N' × DEFAULT_ON_NULL='YES' 인 컬럼 전부.
#   의도적 제외(README §3 사유): 키(DATA_SEQ/HISTORY_SEQ) + 감사컬럼 4종
#     → 기본값을 주면 PK 충돌·유령행을 **조용히** 만든다. 비면 지금처럼 즉시 실패해야 한다.
TABLES_DDL = ["DM_PLN_SALES_ETC_REPORT_C", "DM_PLN_SALES_ETC_REPORT_H"]
EXCLUDE_DDL = {"DATA_SEQ", "HISTORY_SEQ",
               "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_DATE"}

dlines = [
    f"-- {STAMP} / A_DB/01_DDL_DEFAULT_ON_NULL.sql",
    "-- NOT NULL 컬럼 DEFAULT ON NULL — 2026-08-20 사용자 확정 \"NOT NULL 컬럼은 DEFAULT ON NULL 설정\".",
    "--   사내에는 이미 적용 완료(VARCHAR2 10 x 2표 = '-', QTY x 2표 = 0). 클라우드는 미확인 →",
    "--   **현재 사내 상태를 ALL_TAB_COLUMNS 로 실측해 멱등 DDL 로 동봉**한다(추정 금지).",
    "-- 멱등 방식: DEFAULT_ON_NULL='YES' 면 skip. 이미 적용된 클라우드에서도 무해하다.",
    "-- ⚠ 의도적 제외 (README §3-1):",
    "--   · DATA_SEQ / HISTORY_SEQ = 키·시퀀스. 0 기본값은 PK 충돌·유령행을 **조용히** 만든다.",
    "--   · 감사컬럼 4종(CREATED_BY/CREATION_DATE/LAST_UPDATED_BY/LAST_UPDATE_DATE) = 확정 제외 계보.",
    "--   두 축 모두 '비면 즉시 실패' 가 정상 동작이다 — 조용한 오류 은폐 방지.",
    "",
]
ddl_axis = []
for tb in TABLES_DDL:
    cols, rows = fetch_rows("""SELECT COLUMN_NAME, DATA_TYPE, NULLABLE, DEFAULT_ON_NULL, DATA_DEFAULT
                                 FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t
                                ORDER BY COLUMN_ID""", {"t": tb})
    tgt = []
    for r in rows:
        v = dict(zip(cols, r))
        if v["NULLABLE"] != "N" or v["COLUMN_NAME"] in EXCLUDE_DDL:
            continue
        if v["DEFAULT_ON_NULL"] != "YES":
            print(f"    ⚠ {tb}.{v['COLUMN_NAME']} 사내 DEFAULT_ON_NULL={v['DEFAULT_ON_NULL']} — 대상 제외(실측 우선)")
            continue
        dflt = (v["DATA_DEFAULT"] or "")
        dflt = dflt.strip() if isinstance(dflt, str) else str(dflt).strip()
        tgt.append((v["COLUMN_NAME"], v["DATA_TYPE"], dflt))
    ddl_axis.append((tb, tgt))
    dlines.append(f"-- ── {tb} : 대상 {len(tgt)} 컬럼 (NOT NULL ∧ 사내 DEFAULT_ON_NULL='YES' ∧ 제외축 밖)")
    if not tgt:
        dlines.append("-- ⚠ 0행 (사내 실측 0 — 이관 대상 없음)")
        continue
    for cname, dtype, dflt in tgt:
        dlines.append(f"-- {tb}.{cname} ({dtype}) DEFAULT ON NULL {dflt}")
        dlines.append("DECLARE v_n NUMBER;")
        dlines.append("BEGIN")
        dlines.append("  SELECT COUNT(*) INTO v_n FROM ALL_TAB_COLUMNS")
        dlines.append(f"   WHERE OWNER='SCM_MGR' AND TABLE_NAME='{tb}' AND COLUMN_NAME='{cname}'")
        dlines.append("     AND DEFAULT_ON_NULL='YES';")
        dlines.append("  IF v_n = 0 THEN")
        dlines.append(f"    EXECUTE IMMEDIATE q'[ALTER TABLE SCM_MGR.{tb} MODIFY ({cname} DEFAULT ON NULL {dflt})]';")
        dlines.append("  END IF;")
        dlines.append("END;")
        dlines.append("/")
        dlines.append("")
write("01_DDL_DEFAULT_ON_NULL.sql", "\n".join(dlines),
      " / ".join(f"{t}={len(x)}" for t, x in ddl_axis))
counts["_DDL_AXIS"] = ddl_axis

# ────────────────────────────────────────────────────────────────────────────────
# 2) 02_DDL_GTT.sql — 소스 grep(LIVE) + ALL_DEPENDENCIES 양축 → 딕셔너리 교차
# ────────────────────────────────────────────────────────────────────────────────
grep_axis = set(re.findall(r"\bGT_[A-Z0-9_]+", live_src.upper()))
cur.execute("""SELECT DISTINCT REFERENCED_NAME FROM ALL_DEPENDENCIES
               WHERE OWNER='SCM_MGR' AND NAME=:n AND REFERENCED_TYPE='TABLE'
                 AND REFERENCED_NAME LIKE 'GT!_%' ESCAPE '!'""", {"n": PKG})
dep_axis = {r[0] for r in cur}
axis = sorted(grep_axis | dep_axis)
b = {f"g{i}": g for i, g in enumerate(axis)}
inl = ",".join(f":g{i}" for i in range(len(axis)))
cur.execute(f"""SELECT TABLE_NAME, DURATION FROM ALL_TABLES
                WHERE OWNER='SCM_MGR' AND TEMPORARY='Y' AND TABLE_NAME IN ({inl}) ORDER BY 1""", b)
gtts = cur.fetchall()
gtt_names = [g for g, _ in gtts]
print(f"[GTT] grep {len(grep_axis)} / dep {len(dep_axis)} / 합집합 {len(axis)} → 실존 {len(gtt_names)}")
missing = sorted(set(axis) - set(gtt_names))
if missing:
    print(f"    ⚠ 딕셔너리 미존재(오탐 또는 결손): {missing}")


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


glines = [
    f"-- {STAMP} / A_DB/02_DDL_GTT.sql",
    "-- GLOBAL TEMPORARY TABLE 자급 DDL — 기존재 가정 금지 (룰 #22 GTT/TYPE 자급 의무).",
    f"-- 축 확정 = ① {PKG} 소스 grep(주석 제거 LIVE) ② ALL_DEPENDENCIES 합집합 → 딕셔너리 교차.",
    f"--   grep {len(grep_axis)}종 / dep {len(dep_axis)}종 / 실존 GTT {len(gtt_names)}종.",
    "-- ⚠ -955(기존재) skip 의 맹점: 이름만 같고 컬럼 구조가 다른 구세대 GTT 가 남아 있으면",
    "--    조용히 통과한 뒤 런타임 ORA-00904/00932 로 터진다. 적용 전 90_VERIFY V4b 컬럼 시그니처 대조 필수.",
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
        seg = f"    {c['COLUMN_NAME']:36s} {col_type(c)}"
        dflt = (c["DATA_DEFAULT"] or "")
        dflt = dflt.strip() if isinstance(dflt, str) else ""
        if dflt and dflt.upper() != "NULL":
            seg += f" DEFAULT {dflt}"
        if c["NULLABLE"] == "N":
            seg += " NOT NULL"
        defs.append(seg)
    oncommit = "ON COMMIT PRESERVE ROWS" if duration == "SYS$SESSION" else "ON COMMIT DELETE ROWS"
    gtt_sig.append((tname, len(rows)))
    glines.append(f"-- {tname} ({len(rows)} cols, {duration})")
    glines.append("BEGIN EXECUTE IMMEDIATE q'[")
    glines.append(f"CREATE GLOBAL TEMPORARY TABLE SCM_MGR.{tname} (")
    glines.append(",\n".join(defs))
    glines.append(f") {oncommit}")
    glines.append("]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;")
    glines.append("/")
    glines.append("")

# GTT 인덱스 (사내 실측 0본 — 0행 축 명기)
cols, irows = fetch_rows(f"""SELECT i.TABLE_NAME, i.INDEX_NAME, i.UNIQUENESS,
       LISTAGG(c.COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY c.COLUMN_POSITION) COLS
  FROM ALL_INDEXES i JOIN ALL_IND_COLUMNS c
    ON c.INDEX_OWNER = i.OWNER AND c.INDEX_NAME = i.INDEX_NAME
 WHERE i.OWNER='SCM_MGR' AND i.TABLE_NAME IN ({inl})
 GROUP BY i.TABLE_NAME, i.INDEX_NAME, i.UNIQUENESS ORDER BY 1,2""", b)
glines.append(f"-- ── GTT INDEX : {len(irows)} 본 (사내 실측)")
if not irows:
    glines.append("-- ⚠ **0행 축** — 본 화면 GTT 에는 인덱스가 하나도 없다 (사내 실측 0). 이관 대상 없음.")
else:
    for r in irows:
        v = dict(zip(cols, r))
        uniq = "UNIQUE " if v["UNIQUENESS"] == "UNIQUE" else ""
        glines.append("BEGIN EXECUTE IMMEDIATE q'[")
        glines.append(f"CREATE {uniq}INDEX SCM_MGR.{v['INDEX_NAME']} ON SCM_MGR.{v['TABLE_NAME']} ({v['COLS']})")
        glines.append("]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE NOT IN (-955, -1408) THEN RAISE; END IF; END;")
        glines.append("/")
glines.append("")

# TYPE 축 (사내 실측 0본 — 0행 축 명기)
cur.execute("""SELECT DISTINCT REFERENCED_OWNER, REFERENCED_NAME FROM ALL_DEPENDENCIES
               WHERE OWNER='SCM_MGR' AND NAME=:n AND REFERENCED_TYPE='TYPE'""", {"n": PKG})
types = cur.fetchall()
glines.append(f"-- ── TYPE 축 : {len(types)} 본 (ALL_DEPENDENCIES 실측)")
glines.append("-- ⚠ **0행 축** — PKG_DMF0049 는 사용자 정의 TYPE 을 참조하지 않는다. 이관 대상 없음."
              if not types else "-- " + str(types))
write("02_DDL_GTT.sql", "\n".join(glines), f"GTT {len(gtt_names)}본 / IDX {len(irows)} / TYPE {len(types)}")
counts["_GTT"] = gtt_sig
counts["_GTT_IDX"] = len(irows)
counts["_TYPE"] = len(types)

# ────────────────────────────────────────────────────────────────────────────────
# 3) 03_DDL_SEQUENCE.sql
# ────────────────────────────────────────────────────────────────────────────────
cur.execute("""SELECT DISTINCT REFERENCED_NAME FROM ALL_DEPENDENCIES
               WHERE OWNER='SCM_MGR' AND NAME=:n AND REFERENCED_TYPE='SEQUENCE'""", {"n": PKG})
seqs = [r[0] for r in cur]
slines = [
    f"-- {STAMP} / A_DB/03_DDL_SEQUENCE.sql",
    f"-- {PKG} 이 참조하는 SEQUENCE 자급 DDL (ALL_DEPENDENCIES 실측 — 기존재 가정 금지).",
    "-- 멱등: ORA-00955(이름중복) skip. ⚠ 기존재 시 START WITH 는 건드리지 않는다(연속성 보존).",
    "",
]
for s in seqs:
    cols, rows = fetch_rows("""SELECT MIN_VALUE, MAX_VALUE, INCREMENT_BY, CYCLE_FLAG, ORDER_FLAG, CACHE_SIZE
                                 FROM ALL_SEQUENCES WHERE SEQUENCE_OWNER='SCM_MGR' AND SEQUENCE_NAME=:s""",
                            {"s": s})
    v = dict(zip(cols, rows[0]))
    cache = f"CACHE {int(v['CACHE_SIZE'])}" if v["CACHE_SIZE"] and int(v["CACHE_SIZE"]) > 0 else "NOCACHE"
    slines.append(f"-- {s} (사내 실측: INCREMENT {v['INCREMENT_BY']} / {cache} / CYCLE {v['CYCLE_FLAG']})")
    slines.append("BEGIN EXECUTE IMMEDIATE q'[")
    slines.append(f"CREATE SEQUENCE SCM_MGR.{s} START WITH 1 INCREMENT BY {int(v['INCREMENT_BY'])} "
                  f"MINVALUE {int(v['MIN_VALUE'])} {cache} "
                  f"{'CYCLE' if v['CYCLE_FLAG'] == 'Y' else 'NOCYCLE'}")
    slines.append("]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF; END;")
    slines.append("/")
    slines.append("")
write("03_DDL_SEQUENCE.sql", "\n".join(slines), f"SEQ {len(seqs)}본")
counts["_SEQ"] = seqs

# ────────────────────────────────────────────────────────────────────────────────
# 4) 10/11_PKG_DMF0049_{SPEC,BODY}.sql — 라이브 ALL_SOURCE 원문
# ────────────────────────────────────────────────────────────────────────────────
# ⚠ 2026-08-20 실사고: 헤더 주석 안의 "PACKAGE BODY" 문자열로 자르는 실행기가 있어
#    CREATE OR REPLACE 가 주석에 먹혀 실행 불가였다. → 헤더 주석에 'PACKAGE' 리터럴 금지 + 자기검증 assert.
# ⚠ 헤더에 검증 마커 리터럴도 금지 (실행기가 선행 주석을 함께 넘기면 ALL_SOURCE 마커 카운트가 어긋난다).
PKG_FILES = [
    ("PACKAGE", "10_PKG_DMF0049_SPEC.sql"),
    ("PACKAGE BODY", "11_PKG_DMF0049_BODY.sql"),
]
for typ, fname in PKG_FILES:
    body = src[typ]
    kind = "SPEC" if typ == "PACKAGE" else "BODY"
    head = "\n".join([
        f"-- {STAMP} / {fname}",
        f"-- {PKG} {kind} — 사내 Oracle 라이브 ALL_SOURCE 신선 덤프 (2026-08-20).",
        "-- 단독 실행. 누적 패치 조합이 아니라 현재 라이브 원문 그대로다.",
        "-- 적용 순서: 10(SPEC) -> 11(BODY). 검증 마커는 90_VERIFY V3 참조.",
        "SET DEFINE OFF",
        "SET SQLBLANKLINES ON",
        "",
    ])
    text = head + "CREATE OR REPLACE " + body.rstrip("\n") + "\n/\nSHOW ERRORS\n"

    # ── 자기검증 assert (2026-08-20 실사고 재발 방지) ──────────────────────────
    lines = text.split("\n")
    ci = next(i for i, l in enumerate(lines) if l.startswith("CREATE OR REPLACE "))
    pre = "\n".join(lines[:ci]).upper()
    assert "PACKAGE" not in pre, f"{fname}: 헤더 주석에 'PACKAGE' 리터럴 존재 — 실행기 분할 시 CREATE 문이 주석에 먹힌다"
    assert "E20260820" not in pre, f"{fname}: 헤더에 검증 마커 리터럴 존재 — 마커 카운트 오염"
    # 실행기가 'PACKAGE'/'PACKAGE BODY' 토큰 최초 출현 지점부터 잘라도 CREATE 문이 살아남아야 한다.
    #   = 해당 토큰의 최초 출현이 CREATE OR REPLACE 보다 **뒤**에 있어야 한다.
    U = text.upper()
    cpos = U.index("CREATE OR REPLACE")
    for token in ("PACKAGE", "PACKAGE BODY", "CREATE OR REPLACE PACKAGE"):
        tpos = U.find(token)
        assert tpos == -1 or tpos >= cpos, \
            f"{fname}: '{token}' 이 CREATE 문보다 앞(pos {tpos} < {cpos})에 출현 — 분할 시 CREATE 문 소실"
    assert text.count("\n/\n") >= 1, f"{fname}: 종결자 '/' 누락"
    assert text.rstrip().endswith("SHOW ERRORS"), f"{fname}: SHOW ERRORS 누락"
    assert lines[ci].startswith(f"CREATE OR REPLACE {typ} "), f"{fname}: CREATE 문 형식 불일치: {lines[ci][:80]}"
    write(fname, text, f"{len(body.splitlines())} src lines (assert OK)")

cur.execute("""SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS
               WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'""", {"n": PKG})
counts["_PKG_STATUS"] = cur.fetchone()
cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
               AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260820-DIVIDSCALAR%'""", {"n": PKG})
counts["_MARKER"] = cur.fetchone()[0]

# ────────────────────────────────────────────────────────────────────────────────
# 5) 20_MENU_META_SYNC.sql
# ────────────────────────────────────────────────────────────────────────────────
menu_lines = [
    f"-- {STAMP} / A_DB/20_MENU_META_SYNC.sql",
    "-- 메뉴/프로그램/API/버튼/권한 축 — 딕셔너리 기계 전수 스윕 결과 (손나열 금지 계보 2026-08-14).",
    "--   스윕 = SCM_MGR 의 PROGRAM_ID/MNU_ID/MENU_ID/API_ID/SQL_ID/PROC_NM 컬럼 보유 표 52 조합 전수 →",
    "--          'DMF0049' 매칭 18 HIT. 로그·백업·개인화 표는 아래 사유로 제외.",
    "--   ⛔ 이관 제외: SCM_MST_TITLESET_USER(DMF0049 30 + mdfReports 34 = 64행) = 사용자 개인화,",
    "--                SCM_COM_SYS_LOG(282행) = 로그, NSCM_UI_TEMP* / SCM_MST_SHEET_COLUMNS_0408",
    "--                / SCM_MST_SHEET_COLUMNS_260408 = 백업·임시 표.",
    "-- ⭐ MNU_M + USER_GR_MNU_MPG_M 은 절대 누락 금지 (§4.7-B) —",
    "--    이 둘이 비면 SCM_ADM_USER_MNU_EDIT_AUTH_V 가 0행이 되어 **조회가 조용히 전멸**한다.",
    "-- MERGE ON 키 = PK 실측값 (ALL_CONSTRAINTS 확인).  감사컬럼은 원본 실측값 그대로('admin').",
    "",
]
axis_counts = {}
for tbl, keys, sql, label in [
    ("SCM_ADM_MNU_M", ["MNU_ID"],
     f"SELECT * FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='{PROG}'",
     "⭐ 메뉴 1행 (UPPR=Demand_Plan / ROUTE_PATH=demand/demand-plan/etc-sales-reports)"),
    ("SCM_ADM_PROGRAM", ["PROGRAM_ID"],
     f"SELECT * FROM SCM_MGR.SCM_ADM_PROGRAM WHERE PROGRAM_ID='{PROG}'", "프로그램 마스터"),
    ("SCM_ADM_API_M", ["API_ID"],
     f"""SELECT * FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID IN
        (SELECT DISTINCT API_ID FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='{PROG}')
        ORDER BY API_ID""", "API 배선 (버튼 역추적)"),
    ("SCM_ADM_MNU_BTN_MPG_M", ["MNU_ID", "SHT_NM", "MNU_BTN_CD"],
     f"SELECT * FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='{PROG}' ORDER BY SHT_NM, MNU_BTN_CD",
     "버튼-API 배선 (5시트)"),
    ("SCM_ADM_USER_GR_MNU_MPG_M", ["USER_GR_ID", "MNU_ID"],
     f"SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='{PROG}' ORDER BY USER_GR_ID",
     "⭐ 권한그룹-메뉴 접근 (누락 시 권한 뷰 0행)"),
    ("SCM_ADM_USER_GR_MNU_BTN_MPG_M", ["USER_GR_ID", "MNU_ID", "SHT_NM", "MNU_BTN_CD"],
     f"SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='{PROG}' ORDER BY USER_GR_ID, SHT_NM, MNU_BTN_CD",
     "권한그룹-버튼 권한"),
]:
    stmts, n = merge_stmts(tbl, keys, sql)
    axis_counts[tbl] = n
    menu_lines.append(f"-- ── {tbl} : {n} rows ({label}) " + "─" * 8)
    menu_lines += ["", *[s + "\n" for s in stmts]] if n else ["-- ⚠ 0행 (사내 실측 0 — 이관 대상 없음)", ""]
menu_lines.append("COMMIT;")
write("20_MENU_META_SYNC.sql", "\n".join(menu_lines),
      " / ".join(f"{k.replace('SCM_ADM_', '')}={v}" for k, v in axis_counts.items()))
counts["_MENU"] = axis_counts

# ────────────────────────────────────────────────────────────────────────────────
# 6) 21_CMBO_SYNC.sql — FE grep LIVE + SHEET_COLUMNS 메타 양축 합집합
# ────────────────────────────────────────────────────────────────────────────────
FE_GREP = ["DM_LOOKUP_DIV", "DMF0044_DEPARTMENT_TEAM", "DMF0005_REPORT_GROUP2",
           "ReportGroup3", "MDF_TYPE", "CALENDAR_YYYY"]
cur.execute("""SELECT DISTINCT CELL_COMBO_DATA_TYPE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
               WHERE PROGRAM_ID=:pg AND SHEET_NAME=:sh AND CELL_COMBO_DATA_TYPE IS NOT NULL
                 AND TRIM(CELL_COMBO_DATA_TYPE) IS NOT NULL ORDER BY 1""", {"pg": PROG, "sh": SHEET})
META_AXIS = [r[0] for r in cur]
cur.execute("SELECT SQL_ID FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID LIKE :p ORDER BY 1", {"p": f"%{PROG}%"})
NAMED = [r[0] for r in cur]
cmbo_axis = sorted(set(FE_GREP) | set(META_AXIS) | set(NAMED))
clines = [
    f"-- {STAMP} / A_DB/21_CMBO_SYNC.sql",
    "-- SCM_ADM_CMBO_SQL_M — 축 = ① FE 폴더 grep(LIVE, 주석 제외) ② SHEET_COLUMNS 메타",
    "--   CELL_COMBO_DATA_TYPE (PROGRAM_ID='DMF0049') ③ SQL_ID LIKE '%DMF0049%' 의 합집합.",
    f"--   ① {len(FE_GREP)}종 / ② {len(META_AXIS)}종 / ③ {len(NAMED)}종 → 합집합 {len(cmbo_axis)}종.",
    "-- MERGE ON 키 = PK 실측 (SQL_ID, MDU_DIVS_CD) — SQL_ID 단독 아님(중복 MDU 행 소실 방지).",
    "-- ⚠ 다수가 **공유 콤보**(타 화면도 소비). 클라우드 본문이 사내와 다르면 덮어쓰기 충돌 —",
    "--    적용 전 90_VERIFY V6b 로 SQL_DTL_CTN 길이/해시 diff 를 확인하고 판단할 것.",
    "-- ⚠ DMF0044 는 형제 화면이라 CMBO 축이 일부 겹친다 (DMF0044 패키지와 중복 적용은 멱등 — 무해).",
    "",
]
cmbo_rows = 0
for sid in cmbo_axis:
    stmts, n = merge_stmts("SCM_ADM_CMBO_SQL_M", ["SQL_ID", "MDU_DIVS_CD"],
                           "SELECT * FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = :s ORDER BY MDU_DIVS_CD",
                           {"s": sid})
    cmbo_rows += n
    tags = []
    if sid in FE_GREP:
        tags.append("FE-grep")
    if sid in META_AXIS:
        tags.append("메타")
    if sid in NAMED:
        tags.append("전용명")
    clines.append(f"-- ── {sid} : {n} row  [{'+'.join(tags)}]")
    if n == 0:
        clines.append("-- ⚠ 0행 — 사내 미등록 (조용한 스킵 방지 위해 명기)")
    clines += ["", *[s + "\n" for s in stmts]]
clines.append("COMMIT;")
write("21_CMBO_SYNC.sql", "\n".join(clines), f"CMBO {len(cmbo_axis)}종 / {cmbo_rows}행")
counts["_CMBO"] = (len(cmbo_axis), cmbo_rows, cmbo_axis)

# ────────────────────────────────────────────────────────────────────────────────
# 7) 22_SHEET_META_SYNC.sql — SHEET_NAME 단위 삭제 후 전체 재적재 (hook #98 §9)
# ────────────────────────────────────────────────────────────────────────────────
shlines = [
    f"-- {STAMP} / A_DB/22_SHEET_META_SYNC.sql",
    "-- 시트 메타 = SHEET_NAME 단위 삭제 후 전체 재적재 (hook #98 §9).",
    "--   ⭐ 삭제 범위 = 삽입 범위 — **공유 시트의 타 PROGRAM_ID 행을 전량 동봉**한다.",
    "-- ⚠⚠ 'MDF Reports' 는 DMF0044(Sales Reports) 와 **공유**하는 시트다.",
    "--    따라서 본 파일은 DMF0044 행까지 전부 담는다. DMF0049 행만 넣으면 DMF0044 가 전멸한다.",
    "--    (DMF0044 패키지도 같은 시트를 담으므로 두 패키지 중 **나중에 적용된 쪽이 최종**이다 —",
    "--     둘 다 사내 동일 시점 덤프라면 결과는 같다. 시점이 다르면 최신 덤프를 후행 적용할 것.)",
    "-- ⛔ SHEET_NAME 개명 금지 (룰 #91). PKG LIVE 대입 실측: P_PROGRAM_ID='DMF0049' / P_SHEET_NAME='MDF Reports'.",
    "-- ⭐ 본 덤프에는 2026-08-20 사내 적용분 **INPUT_TP_CD 40 행 분리**가 반영돼 있다:",
    "--      DEPARTMENT_ID  40 → 'M'   / 비-40(82,81,81_UC,81_HM,81_ST,81_HD,81_HG) → 'IM' 유지",
    "--      DEPT_ID        40 → 'O'   / 비-40 → 'IO' 유지",
    "--      CUST_REPORT    40 전용행 → 'O'",
    "--    근거: AS-IS DMF0049_Sales_ETC_Reports.cs EditButton L396~406 — 40 분기만 정적 3컬럼을",
    "--    잠그지 않는다(기존행 편집 허용). 비-40 은 L409 에서 전면 잠금.",
    "",
]
sheet_counts = {}
for tbl, order in [
    ("SCM_MST_SHEET_COLUMNS", "SORT_ORDER_NO, PROGRAM_ID, COLUMN_NAME, DIVISION_ID"),
    ("SCM_MST_SHEET_MEASURE", "SORT_ORDER_NO, PROGRAM_ID, COLUMN_NAME, DIVISION_ID"),
]:
    cols, rows = fetch_rows(f"SELECT * FROM SCM_MGR.{tbl} WHERE SHEET_NAME = :s ORDER BY {order}",
                            {"s": SHEET})
    cur.execute(f"SELECT PROGRAM_ID, COUNT(*) FROM SCM_MGR.{tbl} WHERE SHEET_NAME=:s GROUP BY PROGRAM_ID ORDER BY 1",
                {"s": SHEET})
    brk = ", ".join(f"{a}={c}" for a, c in cur)
    sheet_counts[tbl] = (len(rows), brk)
    shlines.append(f"-- ══════════ {tbl} / SHEET_NAME='{SHEET}' : {len(rows)} rows  [{brk}] ══════════")
    if not rows:
        shlines.append("-- ⚠ 0행 (사내 실측 0)")
        continue
    shlines.append(f"DELETE FROM SCM_MGR.{tbl} WHERE SHEET_NAME = {lit(SHEET)};")
    for r in rows:
        v = dict(zip(cols, r))
        shlines.append(f"INSERT INTO SCM_MGR.{tbl} ({', '.join(cols)})\n"
                       f"VALUES ({', '.join(lit(v[c]) for c in cols)});")
    shlines.append("")
shlines.append("COMMIT;")
write("22_SHEET_META_SYNC.sql", "\n".join(shlines),
      " / ".join(f"{k.replace('SCM_MST_', '')}={v[0]}" for k, v in sheet_counts.items()))
counts["_SHEET"] = sheet_counts

# ────────────────────────────────────────────────────────────────────────────────
# 8) 23_MSG_LBL_MNU_SYNC.sql
# ────────────────────────────────────────────────────────────────────────────────
#   축 = ① FE 폴더 LIVE grep (MSG|LBL|MNU)\d{5}  ② MNU_M.MNU_MSG_ID 조상 walk-up
FE_LIVE_CODES = ['LBL00086', 'LBL00112', 'LBL00712', 'LBL00795', 'LBL00797', 'LBL00798',
                 'LBL00800', 'MSG00002', 'MSG00004', 'MSG00096', 'MSG00283', 'MSG00429',
                 'MSG00618', 'MSG00676', 'MSG00682', 'MSG00683', 'MSG00684', 'MSG00685',
                 'MSG00686', 'MSG00687', 'MSG00688']
MENU_CODES = ['MNU00039', 'MNU00011', 'MNU00002']   # DMF0049 / Demand_Plan / Demand
COMMENT_ONLY = ['LBL00513', 'LBL00605', 'LBL00665', 'MSG00680']   # 주석 전용 → 제외 (hook #138)
mlines = [
    f"-- {STAMP} / A_DB/23_MSG_LBL_MNU_SYNC.sql",
    "-- SCM_ADM_MSG_M — MSG/LBL/MNU 는 동일 테이블(MSG_TP_CD 로 구분). 라벨 전용 표는 없음(딕셔너리 실측).",
    f"-- 축 = ① FE 폴더 LIVE grep {len(FE_LIVE_CODES)}종 (주석 제거 후 — hook #138)",
    f"--      ② MNU_M.MNU_MSG_ID 조상 walk-up {len(MENU_CODES)}종 (DMF0049→Demand_Plan→Demand)",
    f"-- ⛔ 주석에만 등장해 제외한 코드: {', '.join(COMMENT_ONLY)} (grep 증거는 LIVE 분류 후에만 근거)",
    "-- 신규 채번 0 — 전부 사내 기등록 코드 재사용 (hook #114 3분기 판정 완료).",
    "-- MERGE ON 키 = PK 실측 (MSG_ID, LANG_CD).",
    "",
]
msg_rows = 0
for code in FE_LIVE_CODES + MENU_CODES:
    stmts, n = merge_stmts("SCM_ADM_MSG_M", ["MSG_ID", "LANG_CD"],
                           "SELECT * FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID = :m ORDER BY LANG_CD",
                           {"m": code})
    msg_rows += n
    if n != 3:
        mlines.append(f"-- ⚠ {code}: {n} rows (3언어 아님 — 확인 필요)")
    mlines += [s + "\n" for s in stmts]
mlines.append("COMMIT;")
write("23_MSG_LBL_MNU_SYNC.sql", "\n".join(mlines),
      f"{len(FE_LIVE_CODES + MENU_CODES)}코드 / {msg_rows}행")
counts["_MSG"] = (len(FE_LIVE_CODES + MENU_CODES), msg_rows)

# ────────────────────────────────────────────────────────────────────────────────
# 9) 24_PROC_M_SYNC.sql — ⭐ 필수 축 (누락 시 PLS-00306)
# ────────────────────────────────────────────────────────────────────────────────
cur.execute(f"""SELECT DISTINCT A.API_URL FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M B
                JOIN SCM_MGR.SCM_ADM_API_M A ON A.API_ID = B.API_ID
                WHERE B.MNU_ID = '{PROG}' ORDER BY 1""")
proc_axis = [r[0] for r in cur]
plines = [
    f"-- {STAMP} / A_DB/24_PROC_M_SYNC.sql",
    "-- ⭐⭐ SCM_ADM_PROC_M — **절대 누락 금지 축** (2026-08-20 DMF0035 에서 통째 누락 → PLS-00306 실사고).",
    "--   generic call-proc 은 PROC_M 으로 인자 바인딩 목록을 만든다. PKG 가 VALID 여도 PROC_M 이 비면",
    "--   \"잘못된 개수 또는 유형의 인수\" 로 즉사한다.",
    "-- 축 = MNU_BTN_MPG_M(MNU_ID='DMF0049') ⋈ API_M 역추적 → DISTINCT API_URL "
    f"{len(proc_axis)}본 (손나열 아님).",
    "--   ⚠ 본 화면은 형제 DMF0044 SP 4본 + 공통 PKG_DMF0000 1본 + standalone 2본을 함께 호출한다.",
    "--     이들이 PROC_M 에 없으면 DMF0049 화면의 해당 시트가 죽는다 → 여기에 반드시 포함한다.",
    "-- MERGE ON 키 = PK 실측 (PROC_NM, COL_NM, COL_TP_CD).",
    "",
]
proc_total = 0
proc_brk = []
for pn in proc_axis:
    stmts, n = merge_stmts("SCM_ADM_PROC_M", ["PROC_NM", "COL_NM", "COL_TP_CD"],
                           "SELECT * FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM = :p ORDER BY SORT_ORD, COL_NM",
                           {"p": pn})
    proc_total += n
    proc_brk.append((pn, n))
    plines.append(f"-- ── {pn} : {n} rows")
    if n == 0:
        plines.append("-- ⚠⚠ 0행 — 사내에도 미등록! 이 SP 를 쓰는 시트는 PLS-00306 으로 죽는다. 즉시 확인 필요.")
    plines += ["", *[s + "\n" for s in stmts]]
plines.append("COMMIT;")
write("24_PROC_M_SYNC.sql", "\n".join(plines), f"{len(proc_axis)}본 / {proc_total}행")
counts["_PROC_M"] = (len(proc_axis), proc_total, proc_brk)

# ────────────────────────────────────────────────────────────────────────────────
# 10) 25_EXCEL_COLUMNS_SYNC.sql — 0행 축 명기
# ────────────────────────────────────────────────────────────────────────────────
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID=:p", {"p": PROG})
exc_prog = cur.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE SHEET_NAME=:s", {"s": SHEET})
exc_sheet = cur.fetchone()[0]
elines = [
    f"-- {STAMP} / A_DB/25_EXCEL_COLUMNS_SYNC.sql",
    "-- SCM_ADM_EXCEL_COLUMNS — Excel Form/Upload 메타 축.",
    f"-- 사내 실측: PROGRAM_ID='{PROG}' → **{exc_prog}행** / SHEET_NAME='{SHEET}' → **{exc_sheet}행**.",
    "-- ⇒ **0행 축** — 본 화면은 Excel Upload 를 보유하지 않는다(EXCEL 버튼은 그리드 내보내기 전용).",
    "--   MNU_BTN_MPG_M 의 DMF0049_main_EXCEL 은 조회 SP(P_DMF0049_GET_SALES_ETC_REPORTS_DATA)에",
    "--   배선돼 있고 Upload 계약(P_MODE 0/1) SP 가 없다 → hook #135 2단 Upload 대상 아님.",
    "-- 이관 대상 없음. 본 파일은 '축을 봤고 0행이었다' 는 사실을 남기기 위한 것이다(조용한 스킵 방지).",
    "",
    "-- (실행할 DML 없음)",
]
write("25_EXCEL_COLUMNS_SYNC.sql", "\n".join(elines), f"0행 축 (PROGRAM {exc_prog} / SHEET {exc_sheet})")
counts["_EXCEL"] = (exc_prog, exc_sheet)

# ────────────────────────────────────────────────────────────────────────────────
# 리포트
# ────────────────────────────────────────────────────────────────────────────────
print("\n=== 축별 실측 카운트 ===")
for k, v in counts["_MENU"].items():
    print(f"  {k:34s} {v}")
for k, (n, brk) in counts["_SHEET"].items():
    print(f"  {k:34s} {n}  [{brk}]")
print(f"  SCM_ADM_CMBO_SQL_M                 {counts['_CMBO'][0]}종 / {counts['_CMBO'][1]}행")
print(f"  SCM_ADM_MSG_M                      {counts['_MSG'][0]}코드 / {counts['_MSG'][1]}행")
print(f"  SCM_ADM_PROC_M                     {counts['_PROC_M'][0]}본 / {counts['_PROC_M'][1]}행")
print(f"  SCM_ADM_EXCEL_COLUMNS              {counts['_EXCEL'][0]} (0행 축)")
print(f"  GTT                                {len(counts['_GTT'])} / IDX {counts['_GTT_IDX']} / TYPE {counts['_TYPE']}")
print(f"  SEQUENCE                           {counts['_SEQ']}")
print(f"  DDL DEFAULT ON NULL                " + " / ".join(f"{t}={len(x)}" for t, x in counts["_DDL_AXIS"]))
print(f"\n  PKG BODY STATUS                    {counts['_PKG_STATUS']}")
print(f"  마커 E20260820-DIVIDSCALAR         {counts['_MARKER']} (기대 3)")
print("\n  PROC_M 내역:")
for pn, n in counts["_PROC_M"][2]:
    print(f"    {pn:56s} {n}")

con.close()
print("\ngenerate DONE (DB 무변경 — SELECT only)")
