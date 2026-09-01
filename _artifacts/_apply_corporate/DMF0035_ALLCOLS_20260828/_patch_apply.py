# -*- coding: utf-8 -*-
"""[E20260828-ALLCOLS] DMF0035 3 GET SP — UI CATEGORY 전체 컬럼 반환 (사용자 지시 2026-08-28)

입력 : 00_BACKUP_PKG_DMF00{35,22,51}_BODY_LIVE.sql (ALL_SOURCE 라이브 전문 덤프 = 정본)
출력 : 01_PATCHED_PKG_*_BODY.sql → 사내 적용(CREATE OR REPLACE) → 02_POSTAPPLY_*_LIVE.sql 재추출
검증 : ALL_ERRORS 0 · 마커 3본 각 1 · MKT/SALES/BIZ GET 정적 컬럼 수 증가 실측 (22 → ?)

원리: V_COL_LIST(DEFAULT/titleset) 는 그대로(=Rows 축 정본·ORDER 유지), 사전(GT_*_T_COLUMN_SETUP) 적재 직후
      "사업부 매칭 VALID 컬럼 중 사전에 있고 아직 목록에 없는 것" 을 뒤에 덧붙인다. 사전 조인이 INNER 라
      사전 밖 컬럼은 애초에 SELECT 되지 않으므로 ORA-00904 위험 0. MEASURE/VERSION_NO 계열·NOTATION 은
      뒤따르는 REPLACE 규약(MEASURE→MEASURE_GROUP,MEASURE,SORT_ORDER_NO) 을 깨지 않도록 제외.
"""
import io, sys, pathlib, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import oracledb
from ora import conn_info

HERE = pathlib.Path(__file__).resolve().parent
MARK = "[E20260828-ALLCOLS]"

def block(dict_tbl, prog_var, sheet_var, col_var, indent):
    i = indent
    return f"""
{i}--{MARK} 사용자 지시(2026-08-28): UI CATEGORY 전체 컬럼 반환 — FE OLAP 은 DEFAULT/titleset 컬럼만 Rows 축에 두고
{i}--   나머지는 필드 후보(드래그)로 쓴다. 사업부 매칭 VALID 컬럼 중 사전({dict_tbl})에 있고 목록에 없는 것만 뒤에 덧붙임.
{i}--   ORDER 는 기존 유지. MEASURE/VERSION_NO 계열·NOTATION 은 REPLACE 규약 보호를 위해, 감사 4컬럼은 집계 grain 보호를 위해 제외.
{i}DECLARE
{i}    V_EXTRA_COLS VARCHAR2(32767 CHAR);
{i}BEGIN
{i}    SELECT LISTAGG(',' || C.COLUMN_NAME, '') WITHIN GROUP (ORDER BY C.SORT_ORDER_NO)
{i}      INTO V_EXTRA_COLS
{i}      FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
{i}     WHERE C.PROGRAM_ID = {prog_var}
{i}       AND C.SHEET_NAME = {sheet_var}
{i}       AND C.VALID_YN   = 'Y'
{i}       AND P_DIVISION_ID IN (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(C.DIVISION_ID, ',')))
{i}       AND C.COLUMN_NAME NOT LIKE '%MEASURE%'
{i}       AND C.COLUMN_NAME NOT LIKE '%VERSION_NO%'
{i}       AND C.COLUMN_NAME <> 'NOTATION'
{i}       AND C.COLUMN_NAME NOT IN ('CREATION_DATE','CREATED_BY','LAST_UPDATE_DATE','LAST_UPDATED_BY') -- 감사컬럼은 집계 grain 을 쪼갬(1차 적용 761→806행 실측)
{i}       AND EXISTS (SELECT 1 FROM SCM_MGR.{dict_tbl} D WHERE D.COLUMN_NAME = C.COLUMN_NAME)
{i}       AND INSTR(',' || REPLACE(REPLACE({col_var}, ' ', ''), CHR(10), '') || ',', ',' || C.COLUMN_NAME || ',') = 0;
{i}    IF V_EXTRA_COLS IS NOT NULL THEN
{i}        {col_var} := {col_var} || V_EXTRA_COLS;
{i}    END IF;
{i}END;
"""

TARGETS = [
    dict(pk="PKG_DMF0035", anchor="    INSERT INTO SCM_MGR.GT_DM35_T (COLUMN_STRING, SEQ)",
         blk=block("GT_DM35_T_COLUMN_SETUP", "V_P_PROGRAM_ID", "V_P_COLS_SHEET", "V_COL_LIST", "    ")),
    dict(pk="PKG_DMF0022", anchor="    INSERT INTO SCM_MGR.GT_DM22_T (COLUMN_STRING, SEQ)",
         blk=block("GT_DM22_T_COLUMN_SETUP", "v_program_id", "v_sheet_name", "v_ColList", "    ")),
    dict(pk="PKG_DMF0051", anchor="        INSERT INTO SCM_MGR.GT_DM22_T (COLUMN_STRING, SEQ)",
         blk=block("GT_DM22_T_COLUMN_SETUP", "v_program_id", "v_sheet_name", "v_ColList", "        ")),
]

u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()

def static_cols(pk):
    U = "minyonglee1"
    if pk == "PKG_DMF0035":
        r = [cur.var(oracledb.CURSOR) for _ in range(4)]
        cur.callproc("SCM_MGR.PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL",
                     ["40", "ALL", "ALL", "ALL", "", "", "ALL", "20260801", "20270228", U, "ALL", "ALL", "", "CURRENT", "MONTHLY", "", "", "N", "ALL", U, "DMF0035"] + r)
    elif pk == "PKG_DMF0022":
        r = [cur.var(oracledb.CURSOR) for _ in range(3)]
        cur.callproc("SCM_MGR.PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL",
                     ["40", "ALL", "ALL", "ALL", "", "", "ALL", "20260801", "20260824", "20270228", U, "ALL", "ALL", "", "N", "N", "CURRENT", "MONTHLY", "", "", U, "DMF0035"] + r)
    else:
        r = [cur.var(oracledb.CURSOR) for _ in range(3)]
        cur.callproc("SCM_MGR.PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL",
                     ["40", "ALL", "ALL", "ALL", "", "", "ALL", "20260801", "20260824", "20270228", U, "ALL", "ALL", "", "CURRENT", "N", "N", U, "DMF0035"] + r)
    c = r[0].getvalue(); cols = [x[0] for x in c.description]; rows = c.fetchall()
    static = [k for k in cols if not re.match(r"^(D_|W_|M_|Q_|Y_)\d", k)]
    return static, len(rows)

mode = sys.argv[1] if len(sys.argv) > 1 else "patch"
before = {}
if mode in ("patch", "apply"):
    for t in TARGETS:
        before[t["pk"]] = static_cols(t["pk"])
        print(f"[before] {t['pk']} static {len(before[t['pk']][0])} cols / rows {before[t['pk']][1]}")
    for t in TARGETS:
        src = (HERE / f"00_BACKUP_{t['pk']}_BODY_LIVE.sql").read_text(encoding="utf-8")
        assert src.count(t["anchor"]) == 1, (t["pk"], src.count(t["anchor"]))
        assert MARK not in src, f"{t['pk']} 이미 적용됨"
        out = src.replace(t["anchor"], t["blk"] + t["anchor"], 1)
        (HERE / f"01_PATCHED_{t['pk']}_BODY.sql").write_text(out, encoding="utf-8")
        print(f"[patched] {t['pk']} ({out.count(MARK)} marker)")
if mode == "apply":
    for t in TARGETS:
        sql = (HERE / f"01_PATCHED_{t['pk']}_BODY.sql").read_text(encoding="utf-8")
        body = sql.rstrip().rstrip("/").rstrip()  # DDL 은 '/' 없이 실행
        cur.execute(body)
        cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY'", [t["pk"]])
        nerr = cur.fetchone()[0]
        cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", [t["pk"]])
        st = cur.fetchone()
        if nerr:
            cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY SEQUENCE", [t["pk"]])
            for e in cur.fetchall(): print("  ERR", e)
            raise SystemExit(f"{t['pk']} 컴파일 오류 {nerr}")
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", [t["pk"]])
        live = "".join(r[0] for r in cur.fetchall())
        (HERE / f"02_POSTAPPLY_{t['pk']}_BODY_LIVE.sql").write_text("CREATE OR REPLACE " + live + "\n/\n", encoding="utf-8")
        print(f"[applied] {t['pk']} {st} ERRORS 0 marker={live.count(MARK)}")
    for t in TARGETS:
        after = static_cols(t["pk"])
        b = before[t["pk"]]
        added = [c for c in after[0] if c not in b[0]]
        print(f"[after] {t['pk']} static {len(b[0])} → {len(after[0])} (+{len(added)}) rows {b[1]} → {after[1]}  added={added}")
