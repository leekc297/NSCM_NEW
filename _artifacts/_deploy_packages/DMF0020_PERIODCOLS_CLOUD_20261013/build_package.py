"""DMF0020_PERIODCOLS 패키지 생성기 — 패치형 (대상 DB 의 USER_SOURCE 를 읽어 정해진 줄만 치환)

대상: PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE (Sales Price 조회)
  PERIODCOLS — PIVOT 컬럼 목록 = 조회 Period 전체 구간(달력) + 조회된 데이터의 날짜      → 10_APPLY / 99_ROLLBACK

화면 반영에는 BE 설정이 함께 필요하다 (C_BE): BE(MyBatis)는 callSettersOnNulls 가 꺼져 있으면 값이 NULL 인 컬럼을
  응답 행에서 빼고, 화면은 응답 행의 키로 기간 컬럼을 만든다. 그래서 이 SP 패치만으로는 값이 전부 NULL 인 구간이 화면에서
  다시 사라진다 (클라우드 QA 10-13 실측: SP 는 주차 41개, 화면은 5개). 빈 칸을 0 으로 채워 내려주는 SP 안은 채택하지 않았다
  (빈 칸이 0.000 으로 보이는 화면 변화 — 사용자 결정 10-13: BE 일괄 수정).
왜 패치형인가: PKG_DMF0020 BODY 는 여러 작업자가 수시로 고친다. 사내 전체본을 클라우드에 올리면 서로 다른 수정분까지
  덮는다. APPLY 가 실행되는 DB 의 원문을 읽어 앵커만 바꾼다.

  python build_package.py                 A_DB/*.sql 생성
  python build_package.py --apply         생성 + 사내 ZIOUI1 에 00 → 10 → 90 실행 (생성본 그대로 = 리허설 겸용)
  python build_package.py --rollback      사내 ZIOUI1 에 99 실행

FRESH-GATE: 생성·실행 직전마다 사내 DB 원문(ALL_SOURCE)을 새로 읽어 패치별 상태(미적용/적용됨)를 판정한다.
  어느 쪽도 아니면 원문이 바뀐 것이므로 중단한다.
"""
import os
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0020"

# ── 패치 1: PERIODCOLS ─────────────────────────────────────────────────────────────────────────────
MARK1 = "E20261013-DMF0020PERIODCOLS"
P1_OLD = "    FOR REC IN (SELECT DISTINCT YYYYMMDD FROM SCM_MGR.GT_FTPR_TMPOUTPUT ORDER BY YYYYMMDD) LOOP\n"
P1_NEW = (
    f"    /* [{MARK1}] 기간 컬럼 = 조회 Period 전체 구간(달력) + 조회된 데이터의 날짜.\n"
    "       종전: 조회된 데이터의 날짜만 -> 일부 주만 판가가 있는 Sales Site 로 조회하면 그 주만 컬럼이 됐다.\n"
    "       달력 기준은 헤더 SP(P_DMF0020_GET_SPREAD_TITLE_DATE)와 같다: 주 = BASIS_START_DATE / 월 = BASIS_YYYYMM.\n"
    "       데이터 쪽은 그대로 합친다 (달력 주 시작일과 다른 날짜로 저장된 판가도 종전처럼 컬럼이 된다).\n"
    "       원문: FOR REC IN (SELECT DISTINCT YYYYMMDD FROM SCM_MGR.GT_FTPR_TMPOUTPUT ORDER BY YYYYMMDD) LOOP */\n"
    "    FOR REC IN (SELECT YYYYMMDD FROM SCM_MGR.GT_FTPR_TMPOUTPUT\n"
    "                UNION\n"
    "                SELECT 'W_' || C.BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M C\n"
    "                 WHERE C.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD\n"
    "                   AND C.BASIS_START_DATE IS NOT NULL\n"
    "                UNION\n"
    "                SELECT 'M_' || C.BASIS_YYYYMM || '01' FROM SCM_MGR.SCM_SYS_CALENDAR_M C\n"
    "                 WHERE C.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD\n"
    "                   AND C.BASIS_YYYYMM IS NOT NULL\n"
    "                ORDER BY 1) LOOP\n"
)

PATCHES = [
    {"key": "PERIODCOLS", "mark": MARK1, "mark_cnt": 1, "apply": "10_APPLY_PERIODCOLS_PATCH.sql", "rollback": "99_ROLLBACK_PERIODCOLS_PATCH.sql",
     "need": None,
     "reps": [("PIVOT 컬럼 목록 루프", P1_OLD, P1_NEW, 1)],
     "what": [
         "-- 내용: 기간 컬럼(W_yyyymmdd / M_yyyymm01)을 \"조회된 데이터의 날짜\"로만 만들던 것을",
         "--       \"조회 Period 전체 구간(SCM_SYS_CALENDAR_M) + 조회된 데이터의 날짜\" 로 바꾼다. 값·행·정적 컬럼은 그대로다.",
         "-- 증상: Sales Price 화면에서 특정 Sales Site 로 조회하면 판가가 있는 주/월만 컬럼으로 나와, 비어 있는 구간에 값을 넣을 칸이 없었다.",
     ]},
]


def plsql_lit(text, indent="        "):
    """여러 줄 문자열 → PL/SQL 리터럴 ('줄' || CHR(10) || …)."""
    parts = text.split("\n")
    assert parts[-1] == "", "줄바꿈으로 끝나야 함"
    return (" ||\n" + indent).join("'" + p.replace("'", "''") + "' || CHR(10)" for p in parts[:-1])


def fetch_body(cur):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=PKG)
    body = "".join(r[0] for r in cur).replace("\r\n", "\n")
    cur.execute(
        "SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI'), "
        "SYS_CONTEXT('USERENV','SERVICE_NAME'), SYS_CONTEXT('USERENV','SERVER_HOST') "
        "FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'",
        n=PKG,
    )
    return body, cur.fetchone()


def state_of(body, patch):
    n_mark = body.count(patch["mark"])
    olds = [body.count(old) for _, old, _, _ in patch["reps"]]
    news = [body.count(new) for _, _, new, _ in patch["reps"]]
    want = [c for _, _, _, c in patch["reps"]]
    if n_mark == 0 and olds == want:
        return "미적용"
    if n_mark == patch["mark_cnt"] and news == want:
        return "적용됨"
    return f"불명(마커 {n_mark} / 앵커 {olds} / 적용블록 {news} / 기대 {want})"


def fresh_gate(cur):
    # FRESH-GATE: 사내 DB 원문을 지금 다시 읽어 패치별 상태를 판정한다
    body, (last_ddl, status, now, svc, host) = fetch_body(cur)
    states = {p["key"]: state_of(body, p) for p in PATCHES}
    bad = {k: v for k, v in states.items() if v.startswith("불명")}
    if bad:
        sys.exit(f"FRESH-GATE FAIL: {bad} — 원문이 기준과 다름. 중단")
    print(f"FRESH-GATE PASS — DB={svc} HOST={host} {PKG} BODY {status} LAST_DDL={last_ddl} 상태={states}")
    return last_ddl, now, svc, states


COMMON_FN = f"""    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = '{PKG}' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
"""

TAIL = f"""    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = '{PKG}' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = '{PKG}' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = '{PKG}' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
"""

POST = (f"SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL "
        f"FROM USER_OBJECTS WHERE OBJECT_NAME='{PKG}' ORDER BY OBJECT_TYPE;\n")


def decl(patch):
    out = ["DECLARE\n    v_src   CLOB;\n    v_new   CLOB;\n    v_st    VARCHAR2(30);\n    v_err   PLS_INTEGER;\n",
           f"    c_mark  CONSTANT VARCHAR2(40) := '{patch['mark']}';\n"]
    if patch["need"]:
        out.append(f"    c_need  CONSTANT VARCHAR2(40) := '{patch['need']}';\n")
    for i, (label, old, new, _) in enumerate(patch["reps"], 1):
        out.append(f"    c_old{i}  CONSTANT VARCHAR2(32767) :=   -- {label} (원문)\n        {plsql_lit(old)};\n")
        out.append(f"    c_new{i}  CONSTANT VARCHAR2(32767) :=   -- {label} (변경)\n        {plsql_lit(new)};\n")
    return "".join(out)


def gen_apply(patch, last_ddl, now, svc):
    n = len(patch["reps"])
    checks = "".join(
        f"    IF cnt(v_src, c_old{i}) <> {c} THEN\n"
        f"        RAISE_APPLICATION_ERROR(-200{10 + i}, '중단 — [{label}] 앵커 매칭 ' || cnt(v_src, c_old{i}) || '건 ({c} 기대). 원문이 사내 기준과 다름 → 00_PRECHECK 결과 회신');\n"
        f"    END IF;\n"
        for i, (label, _, _, c) in enumerate(patch["reps"], 1))
    expr = "v_src"
    for i in range(1, n + 1):
        expr = f"REPLACE({expr}, c_old{i}, c_new{i})"
    need = ""
    if patch["need"]:
        need = ("    IF cnt(v_src, c_need) = 0 THEN\n"
                "        RAISE_APPLICATION_ERROR(-20002, '중단 — 선행 패치(' || c_need || ') 미적용. 10_APPLY 를 먼저 실행. 원문 무변경');\n"
                "    END IF;\n")
    what = "\n".join(patch["what"])
    return f"""-- {patch['apply'][:8]} — [{patch['mark']}] {PKG} BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- SOURCE-FRESH: SCM_MGR.{PKG} PACKAGE BODY LAST_DDL={last_ddl} FETCHED={now} DB={svc.upper()}
--   (위 스탬프는 앵커 문구를 대조한 사내 원문 시점. 이 파일은 사내 전체본을 싣지 않는다 — 실행되는 DB 의 원문을 읽어 고친다)
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 P_DMF0020_GET_SCM_MST_FUTURE_PRICE 의 정해진 줄만 바꾼 뒤 CREATE OR REPLACE.
{what}
-- 가드: 마커 존재 시 무동작 · 앵커 수가 기대와 다르면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 실행 뒤 90_VERIFY. 원복 = {patch['rollback']}. 화면(FE)·BE 변경 없음, 재기동 불요.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
{decl(patch)}{COMMON_FN}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
{need}{checks}    v_new := {expr};
    IF cnt(v_new, c_mark) <> {patch['mark_cnt']} THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 치환 결과 마커 ' || cnt(v_new, c_mark) || '곳 ({patch['mark_cnt']} 기대)');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — {PKG} BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback(patch):
    n = len(patch["reps"])
    checks = "".join(
        f"    IF cnt(v_src, c_new{i}) <> {c} THEN\n"
        f"        RAISE_APPLICATION_ERROR(-200{10 + i}, '중단 — [{label}] 적용 블록 매칭 ' || cnt(v_src, c_new{i}) || '건 ({c} 기대). 원문 무변경');\n"
        f"    END IF;\n"
        for i, (label, _, _, c) in enumerate(patch["reps"], 1))
    expr = "v_src"
    for i in range(n, 0, -1):   # 적용의 역순
        expr = f"REPLACE({expr}, c_new{i}, c_old{i})"
    return f"""-- {patch['rollback'][:11]} — [{patch['mark']}] 역치환 (이 DB 의 USER_SOURCE 를 읽어 해당 줄을 원문으로 되돌린 뒤 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 되돌린 뒤 마커 0 이어야 실행.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
{decl(patch)}{COMMON_FN}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
{checks}    v_new := {expr};
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — {PKG} BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def one_line(text):
    """앵커의 첫 줄(줄바꿈 제외) — PRECHECK 의 줄 단위 대조용."""
    return text.split("\n")[0].replace("'", "''")


PRECHECK = f"""-- 00_PRECHECK — 조회 전용. 적용 전 상태 판정 (전체 F5, 값 입력 없음)
-- * [L0] 접속 DB · {PKG} 상태·LAST_DDL
-- * [L1] 패치 상태 — 마커 수. 0 → 10 실행 대상 / 1 → 적용됨
-- * [L2] 앵커 — 패치가 바꿀 줄이 이 DB 원문에 1건 있는지 (미적용일 때만 의미 있음. 적용됨이면 0 이 정상)
-- * [L3] 달력 — 당월~+12개월 구간에 주 시작일/월 값이 비어 있는 날이 0 이어야 한다 (비어 있는 날은 컬럼에서 빠진다)
-- * [L4] 지금 {PKG} 실행 중 세션 (있으면 끝난 뒤 실행 — CREATE OR REPLACE 가 library cache pin 대기)
SET LINESIZE 300 PAGESIZE 200
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','INSTANCE_NAME') INST, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{PKG}' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 패치' CHK, P.PATCH, COUNT(S.LINE) MARKER_CNT,
       CASE WHEN COUNT(S.LINE) = 0 THEN '미적용 → ' || P.FILE_NM || ' 실행 대상'
            WHEN COUNT(S.LINE) = P.WANT THEN '적용됨 — 재실행은 가드로 무동작'
            ELSE '비정상 — 실행하지 말고 결과 회신' END JUDGE
  FROM (SELECT 'PERIODCOLS' PATCH, '{MARK1}' MARK, 1 WANT, '10_APPLY' FILE_NM FROM DUAL) P
  LEFT JOIN USER_SOURCE S ON S.NAME = '{PKG}' AND S.TYPE = 'PACKAGE BODY' AND S.TEXT LIKE '%' || P.MARK || '%'
 GROUP BY P.PATCH, P.WANT, P.FILE_NM
 ORDER BY P.PATCH;
SELECT 'L2 앵커' CHK, A.PATCH, A.LABEL, A.WANT, COUNT(S.LINE) N,
       CASE WHEN COUNT(S.LINE) = A.WANT THEN 'PASS' WHEN COUNT(S.LINE) = 0 THEN '0건 — 해당 패치가 적용됨이면 정상, 미적용이면 중단·결과 회신' ELSE '건수 다름 — 중단·결과 회신' END JUDGE
  FROM (SELECT 'PERIODCOLS' PATCH, 1 SEQ, '컬럼 목록 루프' LABEL, 1 WANT, '{one_line(P1_OLD)}' TXT FROM DUAL) A
  LEFT JOIN USER_SOURCE S ON S.NAME = '{PKG}' AND S.TYPE = 'PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = A.TXT
 GROUP BY A.PATCH, A.SEQ, A.LABEL, A.WANT
 ORDER BY A.SEQ;
SELECT 'L3 달력' CHK, COUNT(*) DAYS, COUNT(DISTINCT BASIS_START_DATE) WEEKS, COUNT(DISTINCT BASIS_YYYYMM) MONTHS,
       SUM(CASE WHEN BASIS_START_DATE IS NULL OR BASIS_YYYYMM IS NULL THEN 1 ELSE 0 END) EMPTY_DAYS,
       CASE WHEN COUNT(*) = 0 THEN 'FAIL — 달력 자료 없음 → 결과 회신'
            WHEN SUM(CASE WHEN BASIS_START_DATE IS NULL OR BASIS_YYYYMM IS NULL THEN 1 ELSE 0 END) = 0 THEN 'PASS' ELSE '확인 필요 — 빈 날 있음 → 결과 회신' END JUDGE
  FROM SCM_SYS_CALENDAR_M
 WHERE BASIS_YYYYMMDD BETWEEN TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),12)-1,'YYYYMMDD');
SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.MACHINE, S.LAST_CALL_ET CALL_SEC, S.SQL_ID
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='{PKG}' AND OBJECT_TYPE='PACKAGE')
 ORDER BY S.LAST_CALL_ET DESC;
"""

# 조회 SP 를 1회 호출해 결과 커서를 끝까지 읽고, 기간 컬럼별로 "값이 하나라도 있는가"를 센다.
#   v_gone = 값이 전부 NULL 인 기간 컬럼 수 = BE 가 NULL 컬럼을 응답에서 빼는 동안(C_BE 미배포) 화면에서 빠지는 컬럼 수
PROBE_DECL = """  rc1 SYS_REFCURSOR; rr SYS_REFCURSOR;
  cc INTEGER; n INTEGER; d DBMS_SQL.DESC_TAB; x NUMBER;
  TYPE t_set IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(128); s t_set; has_val t_set;
  v_w PLS_INTEGER; v_m PLS_INTEGER; v_cal PLS_INTEGER; v_miss PLS_INTEGER; v_gone PLS_INTEGER; v_rows PLS_INTEGER; v_list VARCHAR2(32767); t0 NUMBER;
  TYPE t_lines IS TABLE OF VARCHAR2(32767) INDEX BY PLS_INTEGER; v_out t_lines;   -- 결과 줄은 모아 두었다가 맨 끝에 찍는다
  PROCEDURE probe(p_div VARCHAR2, p_site VARCHAR2, p_from VARCHAR2, p_to VARCHAR2) IS
  BEGIN
    v_w := 0; v_m := 0; v_cal := 0; v_miss := 0; v_gone := 0; v_rows := 0; v_list := NULL; s.DELETE; has_val.DELETE;
    t0 := DBMS_UTILITY.GET_TIME;
    DBMS_OUTPUT.DISABLE;   -- SP 가 내부에서 찍는 긴 조회문 출력은 버린다 (DISABLE 은 버퍼를 비우므로 결과 줄은 v_out 에 모은다)
    SCM_MGR.PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE(p_div, 'ALL', 'ALL', p_site, 'ALL', 'ALL', 'ALL', 'ALL', 'ALL', p_from, p_to, 'ALL',
        'admin', 'ADMIN', 'ALL', 'N', 'N', 'Current', rc1, rr);
    cc := DBMS_SQL.TO_CURSOR_NUMBER(rc1);
    DBMS_SQL.DESCRIBE_COLUMNS(cc, n, d);
    FOR i IN 1 .. n LOOP
      IF d(i).col_name LIKE 'W\\_%' ESCAPE '\\' OR d(i).col_name LIKE 'M\\_%' ESCAPE '\\' THEN
        s(d(i).col_name) := i;
        DBMS_SQL.DEFINE_COLUMN(cc, i, x);
        IF d(i).col_name LIKE 'W%' THEN
          v_w := v_w + 1;
          IF v_list IS NULL OR LENGTH(v_list) < 3000 THEN v_list := v_list || CASE WHEN v_list IS NOT NULL THEN ',' END || SUBSTR(d(i).col_name, 3); END IF;
        ELSE
          v_m := v_m + 1;
        END IF;
      END IF;
    END LOOP;
    WHILE DBMS_SQL.FETCH_ROWS(cc) > 0 LOOP
      v_rows := v_rows + 1;
      FOR i IN 1 .. n LOOP
        IF s.EXISTS(d(i).col_name) AND NOT has_val.EXISTS(d(i).col_name) THEN
          DBMS_SQL.COLUMN_VALUE(cc, i, x);
          IF x IS NOT NULL THEN has_val(d(i).col_name) := 1; END IF;
        END IF;
      END LOOP;
    END LOOP;
    DBMS_SQL.CLOSE_CURSOR(cc); CLOSE rr;
    v_gone := v_w + v_m - has_val.COUNT;
    FOR c IN (SELECT 'W_' || BASIS_START_DATE K FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD BETWEEN p_from AND p_to AND BASIS_START_DATE IS NOT NULL
              UNION
              SELECT 'M_' || BASIS_YYYYMM || '01' FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD BETWEEN p_from AND p_to AND BASIS_YYYYMM IS NOT NULL) LOOP
      v_cal := v_cal + 1;
      IF NOT s.EXISTS(c.K) THEN v_miss := v_miss + 1; END IF;
    END LOOP;
    ROLLBACK;
  END;
  FUNCTION verdict RETURN VARCHAR2 IS
  BEGIN
    RETURN CASE WHEN v_miss > 0 THEN 'SP 가 데이터 구간만 내려줌 — PERIODCOLS(10_APPLY) 미적용 상태'
                WHEN v_rows = 0 THEN 'SP PASS (0행) — 이 사업부·기간에 조회되는 행이 없다. 화면은 행이 없으면 기간 컬럼도 없다'
                WHEN v_gone > 0 THEN 'SP PASS — Period 전체를 내려준다. 값이 전부 빈 컬럼 ' || v_gone || '개는 BE 가 NULL 컬럼을 응답에 담아야 화면에 보인다 (C_BE 배포 여부 확인)'
                ELSE 'SP PASS — Period 전체 구간에 값이 있다 → BE 설정과 무관하게 화면에 전부 표시' END;
  END;
"""

DIAG = f"""-- 01_DIAG — 조회 전용. Sales Price(DMF0020) 에서 Sales Site 'AJ상사_AB_TES' 조회 시 기간 컬럼이 일부 주차만 나오는 현상 점검
-- 전체 F5 실행 (값 입력 없음 · 바인드 없음 · 데이터/객체 변경 없음). D6 은 조회 SP 를 1회 호출하지만 세션 작업 테이블만 쓰고 끝에 ROLLBACK 한다.
-- 조회 기간 = 당월 1일 ~ +6개월 말일 (화면에서 다른 기간으로 조회했다면 D3 의 "전체 기간" 값을 함께 본다)
--
-- 화면에 기간 컬럼이 나오려면 두 가지가 다 맞아야 한다:
--   (가) 조회 SP 가 그 기간을 컬럼으로 내려준다                    ← DB: PERIODCOLS(10_APPLY). 이 파일의 D1·D6 으로 확인
--   (나) BE 가 값이 NULL 인 컬럼도 응답에 담아 준다                ← BE: C_BE 2개 파일 배포 (DB 에서는 확인할 수 없다)
--        (나) 가 안 돼 있으면 D6 의 '값이 전부 빈 컬럼' 수만큼 화면에서 컬럼이 빠진다
--
-- * [D0] 접속 DB · {PKG} 상태·LAST_DDL
-- * [D1] SP 패치(PERIODCOLS) 적용 여부
-- * [D2] Sales Site 마스터 — 이 사이트가 어느 사업부에 있는지
-- * [D3] 판가 원장 요약 — 이 사이트에 판가가 있는 날짜 수 (조회 기간 안 / 전체 기간)
-- * [D4] 판가 원장 날짜 목록 — 조회 기간 안에서 판가가 있는 날짜. 이 중 월요일이거나 1일인 날짜가 화면에 보이던 주차다
-- * [D5] 달력 — 조회 기간에 있어야 할 주차·월 수 (보완 뒤 화면에 나와야 하는 기간 컬럼 수)
-- * [D6] 조회 SP 실제 호출 — SP 가 내려준 기간 컬럼 수 / 달력 대비 빠진 구간 / 값이 전부 빈 컬럼 수
--          기대(DB 쪽 보완 완료): 빠진 구간 0 → 'SP PASS'. 값이 전부 빈 컬럼 수 = BE 배포 전까지 화면에서 빠지는 컬럼 수
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 300 PAGESIZE 500

SELECT 'D0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','INSTANCE_NAME') INST, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'D0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{PKG}' ORDER BY O.OBJECT_TYPE;

SELECT 'D1 패치' CHK, P.PATCH, COUNT(S.LINE) MARKER_CNT,
       CASE WHEN COUNT(S.LINE) = 0 THEN '미적용 → ' || P.FILE_NM || ' 실행 대상'
            WHEN COUNT(S.LINE) = P.WANT THEN '적용됨'
            ELSE '비정상 — 실행하지 말고 결과 회신' END JUDGE
  FROM (SELECT 'PERIODCOLS' PATCH, '{MARK1}' MARK, 1 WANT, '10_APPLY' FILE_NM FROM DUAL) P
  LEFT JOIN USER_SOURCE S ON S.NAME = '{PKG}' AND S.TYPE = 'PACKAGE BODY' AND S.TEXT LIKE '%' || P.MARK || '%'
 GROUP BY P.PATCH, P.WANT, P.FILE_NM
 ORDER BY P.PATCH;

SELECT 'D2 사이트' CHK, S.DIVISION_ID, S.SCM_SITE_ID, S.SITE_TYPE, S.VALID_YN, S.END_CUSTOMER
  FROM SCM_MST_SITE S
 WHERE S.SCM_SITE_ID = 'AJ상사_AB_TES'
 ORDER BY S.DIVISION_ID;

SELECT 'D3 판가 요약' CHK, P.DIVISION_ID,
       COUNT(DISTINCT CASE WHEN P.YYYYMMDD BETWEEN TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),7)-1,'YYYYMMDD') THEN P.YYYYMMDD END) DATES_IN_PERIOD,
       COUNT(DISTINCT P.YYYYMMDD) DATES_ALL, MIN(P.YYYYMMDD) FIRST_DATE, MAX(P.YYYYMMDD) LAST_DATE, COUNT(*) ROW_CNT,
       TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD') || '~' || TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),7)-1,'YYYYMMDD') PERIOD
  FROM SCM_MST_FUTURE_PRICE P
 WHERE P.SCM_SITE_ID = 'AJ상사_AB_TES'
 GROUP BY P.DIVISION_ID
 ORDER BY P.DIVISION_ID;

SELECT 'D4 판가 날짜' CHK, P.DIVISION_ID, P.YYYYMMDD, TO_CHAR(TO_DATE(P.YYYYMMDD,'YYYYMMDD'),'DY','NLS_DATE_LANGUAGE=ENGLISH') DOW,
       CASE WHEN TO_CHAR(TO_DATE(P.YYYYMMDD,'YYYYMMDD'),'DY','NLS_DATE_LANGUAGE=ENGLISH') = 'MON' OR SUBSTR(P.YYYYMMDD,7,2) = '01' THEN 'Y' ELSE 'N' END SHOWN_ON_SCREEN,
       COUNT(*) ROW_CNT, COUNT(DISTINCT P.ITEM_ID) ITEMS
  FROM SCM_MST_FUTURE_PRICE P
 WHERE P.SCM_SITE_ID = 'AJ상사_AB_TES'
   AND P.YYYYMMDD BETWEEN TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),7)-1,'YYYYMMDD')
 GROUP BY P.DIVISION_ID, P.YYYYMMDD
 ORDER BY P.DIVISION_ID, P.YYYYMMDD;

SELECT 'D5 달력' CHK, COUNT(DISTINCT C.BASIS_START_DATE) WEEKS, COUNT(DISTINCT C.BASIS_YYYYMM) MONTHS,
       COUNT(DISTINCT C.BASIS_START_DATE) + COUNT(DISTINCT C.BASIS_YYYYMM) EXPECTED_PERIOD_COLS,
       SUM(CASE WHEN C.BASIS_START_DATE IS NULL OR C.BASIS_YYYYMM IS NULL THEN 1 ELSE 0 END) EMPTY_DAYS,
       MIN(C.BASIS_START_DATE) FIRST_WEEK, MAX(C.BASIS_START_DATE) LAST_WEEK
  FROM SCM_SYS_CALENDAR_M C
 WHERE C.BASIS_YYYYMMDD BETWEEN TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD') AND TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),7)-1,'YYYYMMDD');

-- D6 — 조회 SP 호출 (사이트가 속한 사업부마다 1회). 결과 커서를 끝까지 읽어 기간 컬럼별 값 유무를 센다. 끝에 ROLLBACK.
DECLARE
  c_site CONSTANT VARCHAR2(200) := 'AJ상사_AB_TES';
  v_from VARCHAR2(8) := TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD'); v_to VARCHAR2(8) := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),7)-1,'YYYYMMDD');
  v_div_cnt PLS_INTEGER := 0;
{PROBE_DECL}BEGIN
  FOR dv IN (SELECT DIVISION_ID FROM SCM_MST_SITE WHERE SCM_SITE_ID = c_site
             UNION
             SELECT DIVISION_ID FROM SCM_MST_FUTURE_PRICE WHERE SCM_SITE_ID = c_site
             ORDER BY 1) LOOP
    v_div_cnt := v_div_cnt + 1;
    probe(dv.DIVISION_ID, c_site, v_from, v_to);
    v_out(v_out.COUNT + 1) := 'D6 div ' || dv.DIVISION_ID || ' site ' || c_site || ' (' || v_from || '~' || v_to || ') — 행 ' || v_rows || ' · SP 주차 컬럼 ' || v_w || ' · 월 컬럼 ' || v_m ||
      ' · 달력 구간 ' || v_cal || ' · 빠진 구간 ' || v_miss || ' · 값이 전부 빈 컬럼 ' || v_gone || ' · SP ' || TO_CHAR((DBMS_UTILITY.GET_TIME - t0)/100, 'FM99990.00') || 's → ' || verdict;
    v_out(v_out.COUNT + 1) := 'D6 div ' || dv.DIVISION_ID || ' SP 주차 = ' || NVL(v_list, '(없음)');
  END LOOP;
  DBMS_OUTPUT.ENABLE(NULL);
  FOR i IN 1 .. v_out.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(v_out(i));
  END LOOP;
  IF v_div_cnt = 0 THEN
    DBMS_OUTPUT.PUT_LINE('D6 SKIP — Sales Site ''' || c_site || ''' 가 사이트 마스터·판가 원장 어디에도 없음 (사이트 이름 철자·공백 확인 후 회신)');
  END IF;
END;
/
"""

VERIFY = f"""-- 90_VERIFY — V1~V2 조회 전용 · V3 = 조회 SP 1회 호출(세션 작업 테이블만 사용, 끝에 ROLLBACK)
-- * 기대: V1 PASS · V2 VALID/오류 0 · V3 'SP PASS …'
-- * 10 실행 전에 돌리면 V1 FAIL(0) · V3 = 'SP 가 데이터 구간만 내려줌' — 그 자체가 적용 전 증거
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 300 PAGESIZE 500
SELECT 'V1 마커' CHK, P.PATCH, COUNT(S.LINE) N, CASE WHEN COUNT(S.LINE) = P.WANT THEN 'PASS' ELSE 'FAIL (' || COUNT(S.LINE) || ' / 기대 ' || P.WANT || ')' END JUDGE
  FROM (SELECT 'PERIODCOLS' PATCH, '{MARK1}' MARK, 1 WANT FROM DUAL) P
  LEFT JOIN USER_SOURCE S ON S.NAME = '{PKG}' AND S.TYPE = 'PACKAGE BODY' AND S.TEXT LIKE '%' || P.MARK || '%'
 GROUP BY P.PATCH, P.WANT
 ORDER BY P.PATCH;
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='{PKG}')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{PKG}' ORDER BY O.OBJECT_TYPE;
-- V3 — 기능 확인: 당월~+6개월 구간에서 "일부 날짜만 판가가 있는" Sales Site 1곳을 이 DB 원장에서 골라 조회 (값 입력 없음)
--   판정 = 달력 전체 구간이 SP 결과 컬럼으로 있다(빠진 구간 0). '값이 전부 빈 컬럼' 은 참고값 — 화면 표시는 BE(C_BE) 몫
DECLARE
  v_from VARCHAR2(8) := TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD'); v_to VARCHAR2(8) := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),7)-1,'YYYYMMDD');
  v_div VARCHAR2(20); v_site VARCHAR2(200); v_have PLS_INTEGER;
{PROBE_DECL}BEGIN
  BEGIN
    SELECT DIVISION_ID, SCM_SITE_ID, W INTO v_div, v_site, v_have FROM (
      SELECT DIVISION_ID, SCM_SITE_ID, COUNT(DISTINCT YYYYMMDD) W, COUNT(*) C
        FROM SCM_MST_FUTURE_PRICE
       WHERE YYYYMMDD BETWEEN v_from AND v_to
       GROUP BY DIVISION_ID, SCM_SITE_ID
      HAVING COUNT(DISTINCT YYYYMMDD) < (SELECT COUNT(DISTINCT BASIS_START_DATE) FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD BETWEEN v_from AND v_to)
       ORDER BY W, C DESC, DIVISION_ID, SCM_SITE_ID) WHERE ROWNUM = 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('V3 SKIP — "일부 날짜만 판가가 있는" Sales Site 가 없음 (이 기간 증상 대상 없음)');
    RETURN;
  END;
  probe(v_div, v_site, v_from, v_to);
  DBMS_OUTPUT.ENABLE(NULL);
  DBMS_OUTPUT.PUT_LINE('V3 div ' || v_div || ' site ' || v_site || ' (' || v_from || '~' || v_to || ', 판가 보유 ' || v_have || '일) — 행 ' || v_rows || ' · SP 기간 컬럼 ' || (v_w + v_m) ||
    ' · 달력 구간 ' || v_cal || ' · 빠진 구간 ' || v_miss || ' · 값이 전부 빈 컬럼 ' || v_gone || ' · SP ' || TO_CHAR((DBMS_UTILITY.GET_TIME - t0)/100, 'FM99990.00') || 's → ' || verdict);
END;
/
"""


def run_sql_file(cur, path):
    """생성한 .sql 을 그대로 실행 (SET 줄 제외, '/' 단독 줄로 PL/SQL 블록 구분, 나머지는 ';' 단위 SELECT)."""
    text = open(path, encoding="utf-8").read()
    cur.callproc("DBMS_OUTPUT.ENABLE", [None])
    chunks = re.split(r"(?m)^/\s*$", text)
    for chunk in chunks:
        lines = [ln for ln in chunk.splitlines() if not ln.strip().upper().startswith("SET ")]
        body = "\n".join(lines)
        m = re.search(r"(?ms)^(DECLARE|BEGIN)\b.*", body)
        pre = body[: m.start()] if m else body
        code = "\n".join(ln for ln in pre.splitlines() if not ln.lstrip().startswith("--"))
        for stmt in [s.strip() for s in code.split(";") if s.strip()]:
            cur.execute(stmt)
            cols = [c[0] for c in cur.description]
            for row in cur.fetchall():
                print("   ", dict(zip(cols, row)))
        if m:
            cur.execute(m.group(0).rstrip())
            line, st = cur.var(str), cur.var(int)
            while True:
                cur.callproc("DBMS_OUTPUT.GET_LINE", [line, st])
                if st.getvalue() != 0:
                    break
                print("   ", line.getvalue())


def main():
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        last_ddl, now, svc, _ = fresh_gate(cur)
        out = os.path.join(HERE, "A_DB")
        os.makedirs(out, exist_ok=True)
        files = {"00_PRECHECK.sql": PRECHECK, "01_DIAG_SITE_PERIOD_COLS.sql": DIAG, "90_VERIFY.sql": VERIFY}
        for patch in PATCHES:
            files[patch["apply"]] = gen_apply(patch, last_ddl, now, svc)
            files[patch["rollback"]] = gen_rollback(patch)
        for name, txt in sorted(files.items()):
            open(os.path.join(out, name), "w", encoding="utf-8", newline="\n").write(txt)
            print("WROTE", name, txt.count("\n"), "lines")
        print("BUILD OK", now)
        a = PATCHES[0]
        if "--apply" in sys.argv:
            seq = ["00_PRECHECK.sql", a["apply"], "90_VERIFY.sql", "00_PRECHECK.sql"]
        elif "--rollback" in sys.argv:
            seq = [a["rollback"], "90_VERIFY.sql"]
        else:
            seq = []
        for name in seq:
            fresh_gate(cur)  # FRESH-GATE: 실행 직전 재조회
            print(f"--- RUN {name} @ {svc}")
            run_sql_file(cur, os.path.join(out, name))
            con.rollback()


if __name__ == "__main__":
    main()
