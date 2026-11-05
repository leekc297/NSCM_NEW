"""SCP0100 Global PSI Report — 클라우드 이관 패키지(DB 만) 생성기 (2026-10-30)

  python build_package.py          → A_DB/*.sql 재생성 + _build_facts.json (사내 ZIOUI1 실측값)

원칙 (hook #152 db-source-refresh-before-work · deploy-package-completeness · 22_PACKAGE_ARTIFACTS)
  - 모든 값은 이 스크립트 실행 시점에 사내 ZIOUI1 에서 새로 조회한다(ALL_SOURCE / ALL_OBJECTS / 메타 행 SELECT). 로컬 파일 복사 금지.
  - 이관 대상 = 이 화면 작업으로 새로 만들었거나 바뀐 행만 (SHEET_COLUMNS PLAN_TYPE 3행 · MSG_M LBL01163/LBL01167 6행).
    PKG_SCP0100·GTT·API_M·PROC_M·BTN_MPG·MNU_M·그룹권한은 수정 없음 → 00_PRECHECK 에서 존재·상태만 확인(기대값 = 사내 실측).
  - FRESH-GATE: 생성 직후 같은 행을 다시 읽어 생성에 쓴 값과 같을 때만 파일을 남긴다(다르면 중단).
  - 파일 머리 SOURCE-FRESH 스탬프(대상·LAST_UPDATE·FETCHED·DB). 24시간 지나면 재빌드.
  - 치환변수(&)·바인드(:v) 없음 · 감사 컬럼 'admin'/SYSDATE · MSG_M 은 INSERT … NOT EXISTS 전용(#140)
    · 시트 메타는 논리키 MERGE(ON = PROGRAM_ID, SHEET_NAME, COLUMN_NAME, NVL(DIVISION_ID,'~') — PK 없음, 사내 유일성 실측).
"""
import os, sys, json, hashlib, datetime, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
A_DB = os.path.join(HERE, "A_DB")
MENU = "SCP0100"
PKG = "PKG_SCP0100"
LBL_NEW = ["LBL01163", "LBL01167"]          # 이 화면 FE 가 쓰는 신규 라벨(사내 minyonglee1 2026-10-15 / 10-19 등록)
FE_CODES = ['MSG00097','LBL01167','LBL01163','LBL00112','MSG00704','MSG00703','MSG00618','LBL01129','LBL01073','LBL00767','LBL00710',
            'LBL00690','LBL00684','LBL00683','LBL00605','LBL00310','LBL00050','LBL00049','LBL00040','LBL00039','LBL00023','LBL00022',
            'LBL00021','LBL00012','LBL00001']   # nscm-fe/features/supply/src/pages/global-psi-report 전수 grep (2026-10-30)
CMBO_IDS = ['Division_SCP', 'PlanType1_SCP_ALL', 'PLAN_END_DATE_REPORT', 'SCPPlanPeriod_SCP']   # constants.ts COMBO / PLAN_END_DATE_COMBO_ID / GEN_NOTES 재사용
LOOKUP_TYPES = ['STOCK_TREND_DISPLAY', 'PRODUCT_LEVEL', 'BUCKET_TYPE_CODE', 'SCP_UNIT_QTY', 'PLAN_TYPE']  # constants.ts LOOKUP + UNIT_QTY + mapping §4 PLAN_TYPE
SC_COLS = ["PROGRAM_ID","SHEET_NAME","COLUMN_NAME","COLUMN_LABEL_NAME","SORT_ORDER_NO","DATA_SORT_METHOD_CODE","SMALL_CLASS_LABEL_NAME",
           "LARGE_CLASS_LABEL_NAME","FIXED_FLAG","COLUMN_WIDTH","CELL_CONTROL_OBJECT_TYPE_CODE","CELL_COMBO_DATA_TYPE","DATA_SCALE_NUMBER",
           "DATA_MAX_LENGTH","HORIZONTAL_ALIGN_CODE","UPPERCASE_APPLY_FLAG","VISIBLE_FLAG","DIVISION_ID","DEFAULT_FLAG","USER_SELECTABLE_FLAG",
           "VALID_YN","ATTRIBUTE1","ATTRIBUTE2","ATTRIBUTE3","ATTRIBUTE4","ATTRIBUTE5","ATTRIBUTE6","ATTRIBUTE7","ATTRIBUTE8","ATTRIBUTE9",
           "ATTRIBUTE10","INPUT_TP_CD"]          # 감사 4컬럼 제외 = 값 컬럼 32 (ALL_TAB_COLUMNS 실측 36 - 4)
SC_NUM = {"SORT_ORDER_NO", "COLUMN_WIDTH", "DATA_SCALE_NUMBER", "DATA_MAX_LENGTH"}
SC_KEY = ["PROGRAM_ID", "SHEET_NAME", "COLUMN_NAME"]      # + NVL(DIVISION_ID,'~')


def lit(v):
    """SQL 리터럴 — NULL / 숫자 / 문자열(작은따옴표 이스케이프). 탭·개행 금지(클라우드 F5 안전)."""
    if v is None:
        return "NULL"
    if isinstance(v, (int, float)):
        return str(int(v)) if float(v).is_integer() else repr(v)
    s = str(v)
    assert "\t" not in s and "\n" not in s, "리터럴에 탭/개행 — CHR() 로 바꿀 것: %r" % s
    return "'" + s.replace("'", "''") + "'"


def md5(s):
    return hashlib.md5(s.encode("utf-8")).hexdigest()


def q(cur, sql, **b):
    cur.execute(sql, b)
    cols = [c[0] for c in cur.description]
    return cols, cur.fetchall()


def rows_dict(cur, sql, **b):
    cols, rows = q(cur, sql, **b)
    return [dict(zip(cols, r)) for r in rows]


def fetch_facts(cur):
    f = {}
    cur.execute("SELECT SYS_CONTEXT('USERENV','DB_NAME'), SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
    f["db"], f["host"], f["fetched"] = cur.fetchone()
    # PKG (수정 없음 — PRECHECK 기대값만)
    f["pkg_objects"] = rows_dict(cur, "SELECT OBJECT_TYPE, STATUS, TO_CHAR(CREATED,'YYYY-MM-DD HH24:MI:SS') CREATED, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n ORDER BY OBJECT_TYPE", n=PKG)
    for t in ("PACKAGE", "PACKAGE BODY"):
        _, rows = q(cur, "SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=PKG, t=t)
        src = "".join(r[0] for r in rows)
        f["pkg_src_" + t.replace(" ", "_")] = {"lines": len(rows), "md5": md5(src),
            "markers": [l.strip()[:120] for l in src.split("\n") if re.search(r"^\s*\*\s+2026\.\d\d\.\d\d\s", l)]}
    _, procs = q(cur, "SELECT PROCEDURE_NAME FROM ALL_PROCEDURES WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND PROCEDURE_NAME IS NOT NULL ORDER BY SUBPROGRAM_ID", n=PKG)
    f["pkg_procs"] = [r[0] for r in procs]
    f["gtt"] = [r[0] for r in q(cur, "SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TEMPORARY='Y' AND TABLE_NAME LIKE 'GT_SCP0100%' ORDER BY 1")[1]]
    f["deps"] = rows_dict(cur, "SELECT DISTINCT REFERENCED_OWNER OWNER_, REFERENCED_NAME NAME_, REFERENCED_TYPE TYPE_ FROM ALL_DEPENDENCIES WHERE OWNER='SCM_MGR' AND NAME=:n AND REFERENCED_OWNER NOT IN ('SYS','PUBLIC') AND REFERENCED_NAME NOT LIKE 'GT_SCP0100%' AND REFERENCED_NAME<>:n ORDER BY 3,2", n=PKG)
    f["grants"] = rows_dict(cur, "SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:n ORDER BY 1,2", n=PKG)
    f["synonyms"] = rows_dict(cur, "SELECT OWNER, SYNONYM_NAME, TABLE_OWNER, TABLE_NAME FROM ALL_SYNONYMS WHERE TABLE_NAME=:n ORDER BY 1", n=PKG)
    # META 7영역 + MENU + MSG(MNU) 기대값 (수정 없음 — PRECHECK)
    f["meta_counts"] = {
        "SCM_ADM_MNU_M": q(cur, "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID=:m", m=MENU)[1][0][0],
        "SCM_ADM_API_M": q(cur, "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID IN (SELECT API_ID FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID=:m)", m=MENU)[1][0][0],
        "SCM_ADM_MNU_BTN_MPG_M": q(cur, "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID=:m", m=MENU)[1][0][0],
        "SCM_ADM_PROC_M": q(cur, "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE :p", p=PKG + ".%")[1][0][0],
        "SCM_ADM_USER_GR_MNU_MPG_M": q(cur, "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID=:m", m=MENU)[1][0][0],
        "SCM_ADM_USER_GR_MNU_BTN_MPG_M": q(cur, "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID=:m", m=MENU)[1][0][0],
        "SCM_MST_SHEET_COLUMNS": q(cur, "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:m", m=MENU)[1][0][0],
        "SCM_MST_SHEET_COLUMNS_base": q(cur, "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:m AND COLUMN_NAME<>'PLAN_TYPE'", m=MENU)[1][0][0],
        "SCM_MST_SHEET_MEASURE": q(cur, "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID=:m", m=MENU)[1][0][0],
        "SCM_ADM_MSG_M_MNU": q(cur, "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID='MNU_'||:m", m=MENU)[1][0][0],
        "SCM_ADM_LOOKUP_SHEET_PRSL_YN": q(cur, "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='SHEET_PRSL_YN' AND SEGMENT1=:m", m=MENU)[1][0][0],
    }
    f["mnu_m"] = rows_dict(cur, "SELECT MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC, SORT_ORD, MNU_LV_NO, MNU_TP_CD, UNIT_TP_CD, USE_YN, ROUTE_PATH, CREATED_BY, TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') CREATION_DATE, LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') LAST_UPDATE_DATE FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID=:m", m=MENU)
    f["api_m"] = rows_dict(cur, "SELECT API_ID, API_TP_CD, API_URL, USE_YN, CREATED_BY, TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') CREATION_DATE, LAST_UPDATED_BY FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID IN (SELECT API_ID FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID=:m) ORDER BY 1", m=MENU)
    f["btn_mpg"] = rows_dict(cur, "SELECT SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') CREATION_DATE FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID=:m ORDER BY 1,2", m=MENU)
    f["proc_m"] = rows_dict(cur, "SELECT PROC_NM, COUNT(*) CNT, MAX(CREATED_BY) CREATED_BY, MAX(LAST_UPDATED_BY) LAST_UPDATED_BY, TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI:SS') LAST_UPDATE_DATE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE :p GROUP BY PROC_NM ORDER BY 1", p=PKG + ".%")
    f["proc_args"] = rows_dict(cur, "SELECT OBJECT_NAME PROC, COUNT(*) ARG_CNT FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME=:n AND DATA_LEVEL=0 AND ARGUMENT_NAME IS NOT NULL GROUP BY OBJECT_NAME ORDER BY 1", n=PKG)
    f["gr_mnu"] = rows_dict(cur, "SELECT USER_GR_ID, USE_YN, CREATED_BY, TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') CREATION_DATE FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID=:m ORDER BY 1", m=MENU)
    f["gr_btn"] = rows_dict(cur, "SELECT USER_GR_ID, COUNT(*) CNT, MAX(CREATED_BY) CREATED_BY, TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI:SS') LAST_UPDATE_DATE FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID=:m GROUP BY USER_GR_ID ORDER BY 1", m=MENU)
    f["cmbo"] = rows_dict(cur, "SELECT SQL_ID, MDU_DIVS_CD, USE_YN, CREATED_BY, TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') CREATION_DATE, LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') LAST_UPDATE_DATE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN (%s) ORDER BY 1" % ",".join(lit(x) for x in CMBO_IDS))
    f["lookup_types"] = rows_dict(cur, "SELECT LOOKUP_TYPE, COUNT(*) CNT, SUM(CASE WHEN VALID_YN='Y' THEN 1 ELSE 0 END) VALID_CNT, TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI:SS') LAST_UPDATE_DATE FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE IN (%s) GROUP BY LOOKUP_TYPE ORDER BY 1" % ",".join(lit(x) for x in LOOKUP_TYPES))
    f["fe_codes"] = rows_dict(cur, "SELECT MSG_ID, COUNT(*) LANGS, MAX(CASE WHEN LANG_CD='EN' THEN MSG_NM END) EN, MIN(CREATED_BY) CREATED_BY, TO_CHAR(MIN(CREATION_DATE),'YYYY-MM-DD HH24:MI:SS') CREATION_DATE, MAX(LAST_UPDATED_BY) LAST_UPDATED_BY, TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI:SS') LAST_UPDATE_DATE FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN (%s) GROUP BY MSG_ID ORDER BY 1" % ",".join(lit(x) for x in FE_CODES))
    # ★ 이관 대상 행 (이 화면 작업분)
    f["plan_type_rows"] = rows_dict(cur, "SELECT %s, CREATED_BY, TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') CREATION_DATE, LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') LAST_UPDATE_DATE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:m AND COLUMN_NAME='PLAN_TYPE' ORDER BY SHEET_NAME" % ",".join(SC_COLS), m=MENU)
    f["lbl_rows"] = rows_dict(cur, "SELECT MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') CREATION_DATE, LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') LAST_UPDATE_DATE FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN (%s) ORDER BY MSG_ID, LANG_CD" % ",".join(lit(x) for x in LBL_NEW))
    # 논리키 유일성 실측 (MERGE ON 전제)
    f["sc_dup"] = q(cur, "SELECT COUNT(*) FROM (SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:m GROUP BY PROGRAM_ID,SHEET_NAME,COLUMN_NAME,NVL(DIVISION_ID,'~') HAVING COUNT(*)>1)", m=MENU)[1][0][0]
    f["msg_dup"] = q(cur, "SELECT COUNT(*) FROM (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN (%s) GROUP BY MSG_ID, LANG_CD HAVING COUNT(*)>1)" % ",".join(lit(x) for x in LBL_NEW))[1][0][0]
    return f


def value_sig(rows, cols):
    return md5(json.dumps([[("" if r[c] is None else str(r[c])) for c in cols] for r in rows], ensure_ascii=False))


def gen_precheck(f):
    L = []
    w = L.append
    w("-- =====================================================================================================")
    w("-- 00_PRECHECK_CLOUD.sql — SCP0100 Global PSI Report 클라우드 이관(DB 만) 선판정 · 조회 전용(변경 없음)")
    w("--   SOURCE-FRESH: 기대값 = 사내 %s(%s) %s 실측. 전체 F5 1회 — 결과 그리드를 아래 기대값과 대조한다." % (f["db"], f["host"], f["fetched"]))
    w("--   실행 계정 = SCM_MGR (권한 조회 ALL_TAB_PRIVS 는 소유자 세션에서만 전부 보인다). 치환변수·바인드 없음.")
    w("--   마지막 PL/SQL 블록만 '중단 조건'(라벨 코드 선점)에서 ORA-20001 을 낸다. 그 외 문장은 모두 SELECT.")
    w("-- =====================================================================================================")
    w("")
    w("-- [P1] PKG_SCP0100 존재·상태 (기대: PACKAGE VALID · PACKAGE BODY VALID — 이 패키지는 PKG 를 바꾸지 않는다. 없으면 PKG 선이관 필요 → README §4)")
    w("SELECT 'P1' STEP, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,")
    w("       (SELECT COUNT(*) FROM ALL_SOURCE S WHERE S.OWNER=O.OWNER AND S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES")
    w("  FROM ALL_OBJECTS O WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SCP0100' ORDER BY OBJECT_TYPE;")
    sp = f["pkg_src_PACKAGE"]; bd = f["pkg_src_PACKAGE_BODY"]
    o_sp = [o for o in f["pkg_objects"] if o["OBJECT_TYPE"] == "PACKAGE"][0]
    o_bd = [o for o in f["pkg_objects"] if o["OBJECT_TYPE"] == "PACKAGE BODY"][0]
    w("--   사내 실측: PACKAGE %d줄(LAST_DDL %s) · PACKAGE BODY %d줄(LAST_DDL %s)" % (sp["lines"], o_sp["LAST_DDL"], bd["lines"], o_bd["LAST_DDL"]))
    w("--   줄 수가 다르면 세대 차이 — 사내 BODY 이력 마커: " + " | ".join(bd["markers"]))
    w("--   (타 작업자 AJS 2026.10.07·10.16 변경분은 본 패키지 범위 밖 — 사용자 본인 작업만 이관 규칙. README §2 표)")
    w("SELECT 'P1b' STEP, SUBSTR(TEXT,1,120) MARKER_LINE FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_SCP0100' AND TYPE='PACKAGE BODY' AND LINE BETWEEN 1 AND 30 AND REGEXP_LIKE(TEXT,'^\\s*\\*\\s+2026\\.[0-9]{2}\\.[0-9]{2}\\s') ORDER BY LINE;")
    w("SELECT 'P1c' STEP, PROCEDURE_NAME FROM ALL_PROCEDURES WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SCP0100' AND PROCEDURE_NAME IS NOT NULL ORDER BY SUBPROGRAM_ID;")
    w("--   사내 실측 서브프로그램 %d: %s" % (len(f["pkg_procs"]), ", ".join(f["pkg_procs"])))
    w("")
    w("-- [P2] PKG 가 참조하는 GTT (사내 %d개 전부 존재해야 함 — 없으면 PKG BODY 가 INVALID 가 된다. 이 패키지는 GTT 를 만들지 않는다(화면 작업으로 생성·수정된 GTT 없음))" % len(f["gtt"]))
    w("SELECT 'P2' STEP, COUNT(*) GTT_FOUND, %d GTT_EXPECTED FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TEMPORARY='Y' AND TABLE_NAME IN (%s);" % (len(f["gtt"]), ", ".join(lit(x) for x in f["gtt"])))
    w("SELECT 'P2b' STEP, COLUMN_VALUE MISSING_GTT FROM TABLE(SYS.ODCIVARCHAR2LIST(%s)) WHERE COLUMN_VALUE NOT IN (SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TEMPORARY='Y');" % ", ".join(lit(x) for x in f["gtt"]))
    w("")
    w("-- [P3] PKG 외부 참조 객체 (함수·뷰·테이블·시노님 — 사내 %d개, 전부 기존 공용 자산 · 이 패키지 미포함 · 존재 확인만)" % len(f["deps"]))
    w("SELECT 'P3' STEP, D.TYPE_ EXPECTED_TYPE, D.OWNER_, D.NAME_, NVL((SELECT MAX(STATUS) FROM ALL_OBJECTS O WHERE O.OWNER=D.OWNER_ AND O.OBJECT_NAME=D.NAME_ AND O.OBJECT_TYPE=D.TYPE_),'** MISSING **') STATUS")
    w("  FROM (")
    w("       " + "\n       UNION ALL ".join("SELECT %s OWNER_, %s NAME_, %s TYPE_ FROM DUAL" % (lit(d["OWNER_"]), lit(d["NAME_"]), lit(d["TYPE_"])) for d in f["deps"]))
    w("       ) D ORDER BY 2,4;")
    w("")
    w("-- [P4] 앱 계정 SCMP_APP — PKG_SCP0100 EXECUTE 권한 + 시노님 (사내 실측: %s / 시노님 %s). 이 패키지는 GRANT 를 실행하지 않는다(사내 이번 작업 중 실행한 GRANT 없음)." % (
        ", ".join("%s:%s" % (g["GRANTEE"], g["PRIVILEGE"]) for g in f["grants"]) or "없음",
        ", ".join("%s.%s->%s.%s" % (s["OWNER"], s["SYNONYM_NAME"], s["TABLE_OWNER"], s["TABLE_NAME"]) for s in f["synonyms"]) or "없음"))
    w("SELECT 'P4' STEP, GRANTEE, PRIVILEGE FROM ALL_TAB_PRIVS WHERE TABLE_SCHEMA='SCM_MGR' AND TABLE_NAME='PKG_SCP0100' ORDER BY 1,2;")
    w("SELECT 'P4b' STEP, OWNER, SYNONYM_NAME, TABLE_OWNER, TABLE_NAME FROM ALL_SYNONYMS WHERE TABLE_NAME='PKG_SCP0100' ORDER BY 1;")
    w("--   0행이면 클라우드 DBA 에게 GRANT EXECUTE ON SCM_MGR.PKG_SCP0100 TO SCMP_APP + CREATE OR REPLACE SYNONYM SCMP_APP.PKG_SCP0100 FOR SCM_MGR.PKG_SCP0100 요청(본 패키지 범위 밖 · README §4)")
    w("")
    w("-- [P5] META 7영역 + MENU 행수 (사내 실측값과 같아야 한다. 이 패키지는 SHEET_COLUMNS PLAN_TYPE 3행만 추가한다)")
    mc = f["meta_counts"]
    w("SELECT 'P5' STEP, K, CNT, EXPECTED, CASE WHEN CNT=EXPECTED THEN 'OK' ELSE 'DIFF' END JUDGE FROM (")
    parts = [
        ("SCM_ADM_MNU_M", "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='SCP0100'", mc["SCM_ADM_MNU_M"]),
        ("SCM_ADM_API_M(BTN 배선 API)", "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID IN (SELECT API_ID FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='SCP0100')", mc["SCM_ADM_API_M"]),
        ("SCM_ADM_MNU_BTN_MPG_M", "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='SCP0100'", mc["SCM_ADM_MNU_BTN_MPG_M"]),
        ("SCM_ADM_PROC_M(PKG_SCP0100.%)", "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE 'PKG_SCP0100.%'", mc["SCM_ADM_PROC_M"]),
        ("SCM_ADM_USER_GR_MNU_MPG_M", "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='SCP0100'", mc["SCM_ADM_USER_GR_MNU_MPG_M"]),
        ("SCM_ADM_USER_GR_MNU_BTN_MPG_M", "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='SCP0100'", mc["SCM_ADM_USER_GR_MNU_BTN_MPG_M"]),
        ("SCM_MST_SHEET_COLUMNS(PLAN_TYPE 제외 기존)", "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0100' AND COLUMN_NAME<>'PLAN_TYPE'", mc["SCM_MST_SHEET_COLUMNS_base"]),
        ("SCM_MST_SHEET_COLUMNS(PLAN_TYPE — 적용 전 0 가능)", "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0100' AND COLUMN_NAME='PLAN_TYPE'", 3),
        ("SCM_MST_SHEET_MEASURE", "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID='SCP0100'", mc["SCM_MST_SHEET_MEASURE"]),
        ("SCM_ADM_MSG_M(MNU_SCP0100)", "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID='MNU_SCP0100'", mc["SCM_ADM_MSG_M_MNU"]),
        ("SCM_ADM_LOOKUP_MASTER_DETAIL(SHEET_PRSL_YN)", "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='SHEET_PRSL_YN' AND SEGMENT1='SCP0100'", mc["SCM_ADM_LOOKUP_SHEET_PRSL_YN"]),
        ("SCM_ADM_CMBO_SQL_M(화면 콤보 4)", "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN (%s)" % ",".join(lit(x) for x in CMBO_IDS), len(f["cmbo"])),
        ("SCM_ADM_LOOKUP_MASTER_DETAIL(화면 lookup 5 TYPE)", "SELECT COUNT(DISTINCT LOOKUP_TYPE) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE IN (%s)" % ",".join(lit(x) for x in LOOKUP_TYPES), len(f["lookup_types"])),
    ]
    w("       " + "\n       UNION ALL ".join("SELECT %s K, (%s) CNT, %d EXPECTED FROM DUAL" % (lit(k), s, e) for k, s, e in parts))
    w("       ) ORDER BY K;")
    w("--   SCM_MST_SHEET_COLUMNS(PLAN_TYPE) 가 0 이면 30 파일이 3행 INSERT · 3 이면 값 비교 후 다른 행만 UPDATE(같으면 0행) · 1~2 면 부족분만 INSERT")
    w("--   그 밖의 K 가 DIFF 이면 SCP0100 기본 등록(ZIONEX 2026-09-23 변환 산출물) 세대가 다른 것 — 본 패키지 범위 밖, README §4 로 보고")
    w("")
    m0 = f["mnu_m"][0] if f["mnu_m"] else {}
    w("-- [P6] 메뉴 행 상세 (사내: UPPR_MNU_ID=%s · MNU_URL=%s · ROUTE_PATH=%s · MNU_MSG_ID=%s · USE_YN=%s)" % tuple(m0.get(k) for k in ("UPPR_MNU_ID", "MNU_URL", "ROUTE_PATH", "MNU_MSG_ID", "USE_YN")))
    w("SELECT 'P6' STEP, MNU_ID, UPPR_MNU_ID, MNU_URL, ROUTE_PATH, MNU_MSG_ID, MNU_TP_CD, UNIT_TP_CD, SORT_ORD, MNU_LV_NO, USE_YN FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID IN ('SCP0100','Supply_Plan') ORDER BY MNU_LV_NO;")
    w("")
    w("-- [P7] 배선 역추적 (화면이 부르는 SP 가 전부 있고 PROC_M 행수 = ALL_ARGUMENTS 인자수인지 — 정상 = 전 행 PROC_M_ROWS = ARG_CNT, ARG_CNT 0 = SP 부재)")
    w("SELECT 'P7' STEP, B.SHT_NM, B.MNU_BTN_CD, A.API_URL,")
    w("       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM=A.API_URL) PROC_M_ROWS,")
    w("       (SELECT COUNT(*) FROM ALL_ARGUMENTS G WHERE G.OWNER='SCM_MGR' AND G.PACKAGE_NAME=SUBSTR(A.API_URL,1,INSTR(A.API_URL,'.')-1) AND G.OBJECT_NAME=SUBSTR(A.API_URL,INSTR(A.API_URL,'.')+1) AND G.DATA_LEVEL=0 AND G.ARGUMENT_NAME IS NOT NULL) ARG_CNT")
    w("  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M B JOIN SCM_MGR.SCM_ADM_API_M A ON A.API_ID=B.API_ID")
    w(" WHERE B.MNU_ID='SCP0100' ORDER BY 2,3;")
    w("--   사내 실측: " + " · ".join("%s PROC_M %d / ARG %s" % (p["PROC_NM"].split(".")[1], p["CNT"], next((a["ARG_CNT"] for a in f["proc_args"] if a["PROC"] == p["PROC_NM"].split(".")[1]), "?")) for p in f["proc_m"]))
    w("")
    w("-- [P8] 화면 FE 가 쓰는 라벨·메시지 코드 %d개 존재 (기존 재사용 23 = 존재 확인만 · 신규 2 = LBL01163·LBL01167 → 31 파일) — 적용 전엔 신규 2개만 MISSING 허용" % len(FE_CODES))
    w("SELECT 'P8' STEP, COLUMN_VALUE MISSING_CODE FROM TABLE(SYS.ODCIVARCHAR2LIST(%s)) WHERE COLUMN_VALUE NOT IN (SELECT MSG_ID FROM SCM_MGR.SCM_ADM_MSG_M);" % ", ".join(lit(x) for x in FE_CODES))
    w("SELECT 'P8b' STEP, MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN (%s) ORDER BY 1,2;" % ", ".join(lit(x) for x in LBL_NEW))
    w("--   사내 실측: " + " · ".join("%s=%s(%s,%s)" % (r["MSG_ID"], r["EN"], r["CREATED_BY"], r["CREATION_DATE"]) for r in f["fe_codes"] if r["MSG_ID"] in LBL_NEW))
    w("")
    w("-- [P9] 적용 전 PLAN_TYPE 행 현재값 (클라우드에 이미 있으면 여기 결과를 보관 — 99_ROLLBACK 은 이 패키지가 INSERT 한 행만 지운다)")
    w("SELECT 'P9' STEP, SHEET_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, FIXED_FLAG, COLUMN_WIDTH, CELL_CONTROL_OBJECT_TYPE_CODE, HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG, VISIBLE_FLAG, DIVISION_ID, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, INPUT_TP_CD, CREATED_BY, LAST_UPDATED_BY")
    w("  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0100' AND COLUMN_NAME='PLAN_TYPE' ORDER BY SHEET_NAME;")
    w("")
    w("-- [P10] 중단 조건 — 신규 라벨 코드가 클라우드에서 다른 문구로 선점돼 있으면 ORA-20001 (재채번 필요 · 31 파일 적용 금지)")
    lbl_en = {r["MSG_ID"]: r["MSG_NM"] for r in f["lbl_rows"] if r["LANG_CD"] == "EN"}
    w("DECLARE")
    w("  v_cnt NUMBER;")
    w("BEGIN")
    w("  SELECT COUNT(*) INTO v_cnt FROM SCM_MGR.SCM_ADM_MSG_M")
    w("   WHERE (" + " OR ".join("(MSG_ID = %s AND MSG_NM <> %s)" % (lit(k), lit(v)) for k, v in lbl_en.items()) + ");")
    w("  IF v_cnt > 0 THEN")
    w("    RAISE_APPLICATION_ERROR(-20001, 'PRECHECK P10: LBL01163/LBL01167 이 클라우드에서 다른 문구로 선점됨(' || v_cnt || '행) — 재채번 후 31 파일 재생성. 적용 중단');")
    w("  END IF;")
    w("END;")
    w("/")
    w("")
    w("-- 끝. 변경한 것 없음(SELECT + 판정 블록만).")
    return "\n".join(L) + "\n"


def gen_sheet_columns(f):
    rows = f["plan_type_rows"]
    assert len(rows) == 3, "PLAN_TYPE 행수 %d != 3 — 사내 메타가 바뀌었다. 조사 후 재빌드" % len(rows)
    assert f["sc_dup"] == 0, "SHEET_COLUMNS 논리키 중복 — MERGE 금지"
    last_upd = max(r["LAST_UPDATE_DATE"] for r in rows)
    L = []
    w = L.append
    w("-- =====================================================================================================")
    w("-- 30_META_SHEET_COLUMNS_PLAN_TYPE.sql — SCP0100 시트 메타 PLAN_TYPE 컬럼 3행 (REPORT / SEARCH_LEVEL / SEARCH_LEVEL_DETAIL)")
    w("-- SOURCE-FRESH: SCM_MGR.SCM_MST_SHEET_COLUMNS(PROGRAM_ID=SCP0100, COLUMN_NAME=PLAN_TYPE x3) LAST_UPDATE=%s FETCHED=%s DB=%s(%s)" % (last_upd, f["fetched"], f["db"], f["host"]))
    w("--   사내 등록 이력: " + " · ".join("%s %s/%s -> %s/%s" % (r["SHEET_NAME"], r["CREATED_BY"], r["CREATION_DATE"], r["LAST_UPDATED_BY"], r["LAST_UPDATE_DATE"]) for r in rows))
    w("--   방식: 멱등 MERGE. ON = 논리키 (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, NVL(DIVISION_ID,'~')) — 표에 PK/UK 없음(ALL_CONSTRAINTS 실측 0) · 사내 유일성 실측 중복 0.")
    w("--   MATCHED 는 값 컬럼이 하나라도 다를 때만 UPDATE(같으면 0행 — 사내 리허설에서 원본 감사컬럼 보존) · NOT MATCHED 는 INSERT. DELETE 없음(클라우드 고유 행 보호).")
    w("--   값 = 사내 실측 그대로(FIXED_FLAG '-' 등 기존 '-' 데이터 유지, #119 §0.5) · 감사 컬럼 'admin'/SYSDATE · 치환변수·바인드 없음 · 전체 F5 1회.")
    w("-- =====================================================================================================")
    w("")
    val_cols = [c for c in SC_COLS if c not in SC_KEY and c != "DIVISION_ID"]
    for r in rows:
        w("-- [%s] %s.%s" % (r["SHEET_NAME"], MENU, r["COLUMN_NAME"]))
        w("MERGE INTO SCM_MGR.SCM_MST_SHEET_COLUMNS T")
        w("USING (SELECT " + ", ".join("%s %s" % (lit(r[c]), c) for c in SC_COLS) + " FROM DUAL) S")
        w("   ON (T.PROGRAM_ID = S.PROGRAM_ID AND T.SHEET_NAME = S.SHEET_NAME AND T.COLUMN_NAME = S.COLUMN_NAME AND NVL(T.DIVISION_ID,'~') = NVL(S.DIVISION_ID,'~'))")
        w(" WHEN MATCHED THEN UPDATE SET")
        w("      " + ",\n      ".join("T.%s = S.%s" % (c, c) for c in val_cols) + ",")
        w("      T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE")
        w("  WHERE " + "\n     OR ".join(("NVL(T.%s,-99999) <> NVL(S.%s,-99999)" if c in SC_NUM else "NVL(T.%s,'~') <> NVL(S.%s,'~')") % (c, c) for c in val_cols))
        w(" WHEN NOT MATCHED THEN INSERT (" + ", ".join(SC_COLS) + ", CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)")
        w("      VALUES (" + ", ".join("S.%s" % c for c in SC_COLS) + ", 'admin', SYSDATE, 'admin', SYSDATE);")
        w("")
    w("COMMIT;")
    w("")
    w("-- 사후 확인 (기대 3행 · 값 = 머리말 사내 실측)")
    w("SELECT SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, FIXED_FLAG, COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, VISIBLE_FLAG, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, INPUT_TP_CD, CREATED_BY, LAST_UPDATED_BY")
    w("  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = 'SCP0100' AND COLUMN_NAME = 'PLAN_TYPE' ORDER BY SHEET_NAME;")
    return "\n".join(L) + "\n"


def gen_msg(f):
    rows = f["lbl_rows"]
    assert len(rows) == 6 and f["msg_dup"] == 0, "LBL 행수 %d != 6 또는 중복" % len(rows)
    last_upd = max(r["LAST_UPDATE_DATE"] for r in rows)
    L = []
    w = L.append
    w("-- =====================================================================================================")
    w("-- 31_MSG_LBL_SCP0100.sql — SCP0100 화면 FE 신규 라벨 2코드 x 3언어 (LBL01163 Scale · LBL01167 A/S)")
    w("-- SOURCE-FRESH: SCM_MGR.SCM_ADM_MSG_M(MSG_ID IN LBL01163,LBL01167) LAST_UPDATE=%s FETCHED=%s DB=%s(%s)" % (last_upd, f["fetched"], f["db"], f["host"]))
    w("--   사내 등록: " + " · ".join("%s %s(%s)" % (r["MSG_ID"], r["CREATED_BY"], r["CREATION_DATE"]) for r in rows if r["LANG_CD"] == "KO"))
    w("--   방식: INSERT … WHERE NOT EXISTS(MSG_ID+LANG_CD) 전용(#140 — 기존 행 UPDATE/DELETE 금지). 00_PRECHECK P10 통과(선점 없음) 후 실행.")
    w("--   NOT NULL 전수: MSG_ID·LANG_CD·MSG_TP_CD·USE_YN·감사 4컬럼(ALL_TAB_COLUMNS 실측) — MSG_DESC 는 사내 값(NULL) 그대로.")
    w("-- =====================================================================================================")
    w("")
    for r in rows:
        w("INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)")
        w("SELECT %s, %s, %s, %s, %s, %s, 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL" % (lit(r["MSG_ID"]), lit(r["LANG_CD"]), lit(r["MSG_NM"]), lit(r["MSG_DESC"]), lit(r["MSG_TP_CD"]), lit(r["USE_YN"])))
        w(" WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID = %s AND LANG_CD = %s);" % (lit(r["MSG_ID"]), lit(r["LANG_CD"])))
    w("")
    w("COMMIT;")
    w("")
    w("-- 사후 확인 (기대 6행)")
    w("SELECT MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN (%s) ORDER BY 1, 2;" % ", ".join(lit(x) for x in LBL_NEW))
    return "\n".join(L) + "\n"


def gen_verify(f):
    rows = f["plan_type_rows"]
    base = f["meta_counts"]["SCM_MST_SHEET_COLUMNS_base"]
    L = []
    w = L.append
    w("-- =====================================================================================================")
    w("-- 90_VERIFY.sql — SCP0100 클라우드 이관(DB 만) 적용 후 검증 · 조회 전용 · 전체 F5 1회")
    w("-- SOURCE-FRESH: 기대값 = 사내 %s(%s) %s 실측 (값 단언 형식 — 건수만 보지 않는다)" % (f["db"], f["host"], f["fetched"]))
    w("-- =====================================================================================================")
    w("")
    w("-- [V1] PLAN_TYPE 3행 값 단언 — 기대: 3행 모두 JUDGE='OK' (값 컬럼 전부 사내와 동일)")
    w("SELECT 'V1' STEP, S.SHEET_NAME, CASE WHEN T.PROGRAM_ID IS NULL THEN '** MISSING **' WHEN (")
    val_cols = [c for c in SC_COLS if c not in SC_KEY]
    w("       " + "\n       AND ".join(("NVL(T.%s,-99999) = NVL(S.%s,-99999)" if c in SC_NUM else "NVL(T.%s,'~') = NVL(S.%s,'~')") % (c, c) for c in val_cols))
    w("       ) THEN 'OK' ELSE 'VALUE DIFF' END JUDGE, T.CREATED_BY, T.LAST_UPDATED_BY")
    w("  FROM (")
    w("       " + "\n       UNION ALL ".join("SELECT " + ", ".join("%s %s" % (lit(r[c]), c) for c in SC_COLS) + " FROM DUAL" for r in rows))
    w("       ) S LEFT JOIN SCM_MGR.SCM_MST_SHEET_COLUMNS T")
    w("    ON T.PROGRAM_ID = S.PROGRAM_ID AND T.SHEET_NAME = S.SHEET_NAME AND T.COLUMN_NAME = S.COLUMN_NAME AND NVL(T.DIVISION_ID,'~') = NVL(S.DIVISION_ID,'~')")
    w(" ORDER BY S.SHEET_NAME;")
    w("")
    w("-- [V2] SCP0100 시트 메타 총 행수 (기대 %d = 기존 %d + PLAN_TYPE 3) · 논리키 중복 0" % (base + 3, base))
    w("SELECT 'V2' STEP, X.TOTAL_ROWS, %d EXPECTED, CASE WHEN X.TOTAL_ROWS = %d THEN 'OK' ELSE 'DIFF' END JUDGE, D.DUP_KEYS" % (base + 3, base + 3))
    w("  FROM (SELECT COUNT(*) TOTAL_ROWS FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0100') X,")
    w("       (SELECT COUNT(*) DUP_KEYS FROM (SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0100' GROUP BY SHEET_NAME, COLUMN_NAME, NVL(DIVISION_ID,'~') HAVING COUNT(*)>1)) D;")
    w("")
    w("-- [V3] CTRL 화이트리스트 단언 (hook #98 §6.1) — SCP0100 전 행: CELL_CONTROL_OBJECT_TYPE_CODE 는 NULL 또는 'FP%' 만. 기대 0행")
    w("SELECT 'V3' STEP, SHEET_NAME, COLUMN_NAME, CELL_CONTROL_OBJECT_TYPE_CODE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0100' AND CELL_CONTROL_OBJECT_TYPE_CODE IS NOT NULL AND CELL_CONTROL_OBJECT_TYPE_CODE NOT LIKE 'FP%';")
    w("-- [V3b] INPUT_TP_CD 분포 (조회 전용 리포트 — 사내 전 행 'S'. 기대: S=%d 1행만)" % (base + 3))
    w("SELECT 'V3b' STEP, INPUT_TP_CD, COUNT(*) CNT FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0100' GROUP BY INPUT_TP_CD ORDER BY 1;")
    w("")
    w("-- [V4] 신규 라벨 6행 값 단언 — 기대 6행 JUDGE='OK'")
    w("SELECT 'V4' STEP, S.MSG_ID, S.LANG_CD, CASE WHEN T.MSG_ID IS NULL THEN '** MISSING **' WHEN T.MSG_NM = S.MSG_NM AND T.MSG_TP_CD = S.MSG_TP_CD AND T.USE_YN = S.USE_YN THEN 'OK' ELSE 'VALUE DIFF: ' || T.MSG_NM END JUDGE")
    w("  FROM (")
    w("       " + "\n       UNION ALL ".join("SELECT %s MSG_ID, %s LANG_CD, %s MSG_NM, %s MSG_TP_CD, %s USE_YN FROM DUAL" % (lit(r["MSG_ID"]), lit(r["LANG_CD"]), lit(r["MSG_NM"]), lit(r["MSG_TP_CD"]), lit(r["USE_YN"])) for r in f["lbl_rows"]))
    w("       ) S LEFT JOIN SCM_MGR.SCM_ADM_MSG_M T ON T.MSG_ID = S.MSG_ID AND T.LANG_CD = S.LANG_CD")
    w(" ORDER BY 2, 3;")
    w("")
    w("-- [V5] 화면 FE 코드 %d개 전부 존재 — 기대 0행" % len(FE_CODES))
    w("SELECT 'V5' STEP, COLUMN_VALUE MISSING_CODE FROM TABLE(SYS.ODCIVARCHAR2LIST(%s)) WHERE COLUMN_VALUE NOT IN (SELECT MSG_ID FROM SCM_MGR.SCM_ADM_MSG_M);" % ", ".join(lit(x) for x in FE_CODES))
    w("")
    w("-- [V6] 배선 역추적 — 화면이 부르는 SP 중 없는 것(ARG_CNT 0) 또는 PROC_M 불일치(PROC_M_ROWS <> ARG_CNT) — 기대 0행 (deploy-package-completeness §4.7)")
    w("--   (사내 실측: O_RC1·O_RESULT_CURSOR 둘 다 실제 OUT 인자 → PROC_M 행수 = ALL_ARGUMENTS 인자수. " + " · ".join("%s %d" % (p["PROC_NM"].split(".")[1], p["CNT"]) for p in f["proc_m"]) + ")")
    w("SELECT 'V6' STEP, X.* FROM (")
    w("  SELECT B.SHT_NM, B.MNU_BTN_CD, A.API_URL,")
    w("         (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM=A.API_URL) PROC_M_ROWS,")
    w("         (SELECT COUNT(*) FROM ALL_ARGUMENTS G WHERE G.OWNER='SCM_MGR' AND G.PACKAGE_NAME=SUBSTR(A.API_URL,1,INSTR(A.API_URL,'.')-1) AND G.OBJECT_NAME=SUBSTR(A.API_URL,INSTR(A.API_URL,'.')+1) AND G.DATA_LEVEL=0 AND G.ARGUMENT_NAME IS NOT NULL) ARG_CNT")
    w("    FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M B JOIN SCM_MGR.SCM_ADM_API_M A ON A.API_ID=B.API_ID WHERE B.MNU_ID='SCP0100') X")
    w(" WHERE X.ARG_CNT = 0 OR X.PROC_M_ROWS <> X.ARG_CNT;")
    w("")
    w("-- [V7] PKG_SCP0100 VALID · 컴파일 오류 0 (이 패키지는 PKG 를 바꾸지 않지만 화면 동작 전제) — 기대: VALID 2행 · ERR 0")
    w("SELECT 'V7' STEP, OBJECT_TYPE, STATUS, (SELECT COUNT(*) FROM ALL_ERRORS E WHERE E.OWNER='SCM_MGR' AND E.NAME='PKG_SCP0100') ERR FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SCP0100' ORDER BY 2;")
    return "\n".join(L) + "\n"


def gen_rollback(f):
    L = []
    w = L.append
    w("-- =====================================================================================================")
    w("-- 99_ROLLBACK.sql — 이 패키지가 INSERT 한 행만 삭제 (CREATED_BY='admin' 표식). 다른 작성자의 기존 행·UPDATE 된 행은 건드리지 않는다.")
    w("--   SOURCE-FRESH: 대상 키 = 사내 %s %s 실측 (PLAN_TYPE 3 · LBL01163/LBL01167 6)" % (f["db"], f["fetched"]))
    w("--   MATCHED-UPDATE 가 일어난 행(클라우드에 다른 값의 PLAN_TYPE 이 있었던 경우)은 00_PRECHECK [P9] 결과로 수동 복원한다.")
    w("--   전체 F5 1회 · 재실행 안전(0행).")
    w("-- =====================================================================================================")
    w("")
    w("DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = 'SCP0100' AND COLUMN_NAME = 'PLAN_TYPE' AND CREATED_BY = 'admin';")
    w("DELETE FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN (%s) AND CREATED_BY = 'admin';" % ", ".join(lit(x) for x in LBL_NEW))
    w("COMMIT;")
    w("")
    w("-- 사후 확인 (이 패키지 표식 행 0 기대)")
    w("SELECT 'R1' STEP, (SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0100' AND COLUMN_NAME='PLAN_TYPE' AND CREATED_BY='admin') PLAN_TYPE_ADMIN_ROWS,")
    w("       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN (%s) AND CREATED_BY='admin') LBL_ADMIN_ROWS FROM DUAL;" % ", ".join(lit(x) for x in LBL_NEW))
    return "\n".join(L) + "\n"


def lint(name, txt):
    code = re.sub(r"--[^\n]*", "", txt)                 # 주석 제거
    code_nostr = re.sub(r"'[^']*'", "''", code)          # 문자열 리터럴 제거
    assert "&" not in code_nostr, "%s: 치환변수 & 잔존" % name
    assert not re.search(r"(?<![:\w]):[A-Za-z_]\w*", code_nostr), "%s: 바인드 :v 잔존" % name
    assert "'claude" not in txt.lower(), "%s: claude 감사컬럼 금지" % name
    assert "\t" not in txt, "%s: 탭 문자" % name
    assert "/*" not in txt, "%s: 블록 주석 금지(중첩 위험)" % name


def build():
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
    f = fetch_facts(cur)
    files = {
        "00_PRECHECK_CLOUD.sql": gen_precheck(f),
        "30_META_SHEET_COLUMNS_PLAN_TYPE.sql": gen_sheet_columns(f),
        "31_MSG_LBL_SCP0100.sql": gen_msg(f),
        "90_VERIFY.sql": gen_verify(f),
        "99_ROLLBACK.sql": gen_rollback(f),
    }
    # FRESH-GATE: 생성 직후 대상 행 재조회 — 생성에 쓴 값과 같을 때만 파일을 남긴다
    f2 = fetch_facts(cur)
    sig = lambda ff: (value_sig(ff["plan_type_rows"], SC_COLS), value_sig(ff["lbl_rows"], ["MSG_ID", "LANG_CD", "MSG_NM", "MSG_DESC", "MSG_TP_CD", "USE_YN"]), ff["pkg_src_PACKAGE_BODY"]["md5"])
    assert sig(f) == sig(f2), "FRESH-GATE 실패: 빌드 중 사내 원문/메타가 바뀜 — 재빌드"
    os.makedirs(A_DB, exist_ok=True)
    for name, txt in files.items():
        lint(name, txt)
        open(os.path.join(A_DB, name), "w", encoding="utf-8", newline="\n").write(txt)
    f["signatures"] = {"plan_type_rows": sig(f)[0], "lbl_rows": sig(f)[1], "pkg_body_md5": sig(f)[2], "pkg_spec_md5": f["pkg_src_PACKAGE"]["md5"]}
    f["built_at"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    json.dump(f, open(os.path.join(HERE, "_build_facts.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=str)
    print("built", list(files), "FETCHED", f["fetched"], "DB", f["db"], f["host"])
    print("PLAN_TYPE rows", len(f["plan_type_rows"]), "LBL rows", len(f["lbl_rows"]), "GTT", len(f["gtt"]), "deps", len(f["deps"]), "FE codes found", len(f["fe_codes"]))


if __name__ == "__main__":
    build()
