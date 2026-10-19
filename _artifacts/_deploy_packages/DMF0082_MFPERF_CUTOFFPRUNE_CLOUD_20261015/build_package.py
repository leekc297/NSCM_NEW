"""DMF0082_MFPERF_CUTOFFPRUNE_CLOUD_20261015 패키지 생성기.

DMF0082 과거 버전(MF/SF/SP) 조회 지연 — ASH 실측: 컷오프 최종수정자 적재(GT_DMF0082_T_LAST_DATA_SETUP_FCST_C / _PRICE_C)가
  전 시간의 99% (40 MF 575초 · 81 MF 532초). 플랜 = GTT 카티션 → 원장 인덱스 NL + PARTITION RANGE ALL (파티션 키 조건 없음).
조치(#129 3순위): 세 문장(40 수요·40 판가·81 수요)에 파티션 키 CUTOFF_YYYYMMDD_DATE 범위 조건(선택 버전 컷오프 범위) 추가.
  데이터 실측: 버전당 컷오프 1개 · CUTOFF_YYYYMMDD_DATE = CUTOFF_YYYYMMDD = 버전일 (40 수요 46 · 40 판가 74 · 81 수요 645 묶음, 불일치 0) → 행 무변화.

FRESH-GATE: 사내 ZIOUI1 ALL_SOURCE 를 지금 재조회해 적용본인지 확인하고, 착수 기준본과 함께 시뮬레이터로
  '수정 전 → 적용 연산 == 적용본' · '적용본 → 원복 연산 == 수정 전' 일 때만 SQL 을 쓴다.
"""
import os, sys, datetime, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
PRE_FILE = r"C:\Users\ejene\AppData\Local\Temp\claude\c--Projects-NSCM\b863378f-208f-46a1-9563-63278599cad9\scratchpad\mfperf\body.sql"
MARK = "MFPERF 2026-10-15"
P_FROM = "PROCEDURE P_DMF0082_GET_MAIN_DATA"
P_TO = "PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT"
INS_HEAD = "INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_"
DATE_LINE = "    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd\n"
CUT_PFX = "    AND    A.CUTOFF_YYYYMMDD_DATE BETWEEN TO_DATE(CASE WHEN V_CUTOFF_FROM = '00000000'"
TABLES = ["DM_PLN_MKT_FCST_C", "DM_PLN_CFM_MKT_DEMAND_PLAN_C", "DM_PLN_CFM_SELLING_PRICE_C"]

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
# FRESH-GATE: 생성 직전 DB 원문 재조회 (ALL_SOURCE + LAST_DDL_TIME)
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
last_ddl = cur.fetchone()[0]
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
APPLIED = "".join(r[0] for r in cur).replace("\r\n", "\n")
fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
PRE = open(PRE_FILE, encoding="utf-8", newline="").read().replace("\r\n", "\n")
assert APPLIED.count(MARK) == 3 and PRE.count(MARK) == 0, "FRESH-GATE 실패: 마커 수"
c0 = APPLIED.index(CUT_PFX)
CUT = APPLIED[c0:APPLIED.index("\n", APPLIED.index("\n", c0) + 1) + 1]          # 2줄 (사내 적용본 문구 그대로)
assert CUT.count("\n") == 2 and APPLIED.count(CUT) == 3


def sim_apply(src):
    for t in TABLES:
        m0 = src.index("\n" + P_FROM + "\n")
        f = src.index(f"    FROM   SCM_MGR.{t} A\n", m0)
        assert f - src.rindex(INS_HEAD, 0, f) < 800, t
        dl = src.index(DATE_LINE, f); g = src.index("    GROUP BY", f); assert dl < g
        src = src[:dl + len(DATE_LINE)] + CUT + src[dl + len(DATE_LINE):]
    return src


def sim_rollback(src):
    m0 = src.index("\n" + P_FROM + "\n"); m1 = src.index("\n" + P_TO)
    assert src.count("\n" + CUT_PFX, m0, m1) == 3
    for _ in range(3):
        s = src.index("\n" + CUT_PFX, m0) + 1
        e = src.index("\n", src.index("\n", s) + 1) + 1
        src = src[:s] + src[e:]
    return src


assert sim_apply(PRE) == APPLIED, "시뮬레이터: 수정 전 → 적용 연산 ≠ 적용본"
assert sim_rollback(APPLIED) == PRE, "시뮬레이터: 적용본 → 원복 연산 ≠ 수정 전"
print("simulator OK")


def q(t):
    return t.replace("'", "''").replace("\n", "' || CHR(10) || '")


STAMP = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)"
DECL = f"""    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_m0     PLS_INTEGER;
    v_m1     PLS_INTEGER;
    v_f      PLS_INTEGER;
    v_h      PLS_INTEGER;
    v_d      PLS_INTEGER;
    v_g      PLS_INTEGER;
    v_s      PLS_INTEGER;
    v_e      PLS_INTEGER;
    TYPE t_list IS TABLE OF VARCHAR2(100);
    c_tables CONSTANT t_list := t_list({', '.join("'" + t + "'" for t in TABLES)});
    c_mark   CONSTANT VARCHAR2(40)  := '{MARK}';
    c_ins    CONSTANT VARCHAR2(100) := '{INS_HEAD}';
    c_date   CONSTANT VARCHAR2(200) := '{q(DATE_LINE)}';
    c_pfx    CONSTANT VARCHAR2(300) := '{q(CUT_PFX)}';
    c_cut    CONSTANT VARCHAR2(2000) := '{q(CUT)}';
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := p_from;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL OR pos >= p_to;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    PROCEDURE locate IS
    BEGIN
        v_m0 := DBMS_LOB.INSTR(v_new, CHR(10) || '{P_FROM}' || CHR(10));
        v_m1 := DBMS_LOB.INSTR(v_new, CHR(10) || '{P_TO}');
        IF NOT (v_m0 > 0 AND v_m0 < v_m1) THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — GET_MAIN_DATA 위치 확인 불가. 원문 무변경');
        END IF;
    END;
"""
LOAD = """    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;"""
COMPILE = """    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원 (2026-10-15 GAP452 리허설 사고 정정)
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;"""
POST = "SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;"

APPLY = f"""{STAMP}
-- 10_APPLY — [{MARK}] DMF0082 과거 버전 조회 속도 PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: P_DMF0082_GET_MAIN_DATA 의 컷오프 최종수정자 적재 3문장(81 수요 DM_PLN_MKT_FCST_C · 40 수요 DM_PLN_CFM_MKT_DEMAND_PLAN_C ·
--       40 판가 DM_PLN_CFM_SELLING_PRICE_C)에 파티션 키 CUTOFF_YYYYMMDD_DATE 범위 조건(선택 버전 컷오프 범위)을 2줄씩 넣는다.
--       구: 파티션 키 조건이 없어 버전·사이트품목 조합마다 전 파티션을 탐색(PARTITION RANGE ALL) — 사내 40 MF 575초 · 81 MF 532초.
--       신: 해당 컷오프 파티션만 탐색 — 사내 40 MF 3.5초 · SF 3.5초 · SP 2.6초 · 81 MF 3.8초, 결과 행 동일.
--       버전당 컷오프 1개 · CUTOFF_YYYYMMDD_DATE = 버전일(사내 실측 불일치 0)이라 조건은 행을 거르지 않는다.
-- 범위: 조회 SP 3곳 조건 추가. 저장 · 원장 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 에서 각 원장의 GET_MAIN_DATA 첫 FROM 줄(컷오프 최종수정자 적재 문장)을 찾아
--       그 뒤 'A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd' 줄 다음에 2줄을 넣고 CREATE OR REPLACE.
-- 가드: 마커 존재 시 무동작 · 각 위치가 적재 문장 안이 아니면 중단(원문 무변경) · 마커 3곳 확인 · 컴파일 오류 시 원문 자동 복원
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}BEGIN
{LOAD}
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    FOR i IN 1 .. c_tables.COUNT LOOP
        locate;
        v_f := DBMS_LOB.INSTR(v_new, '    FROM   SCM_MGR.' || c_tables(i) || ' A' || CHR(10), v_m0);
        IF v_f = 0 OR v_f > v_m1 THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || c_tables(i) || ' FROM 줄 없음. 00_PRECHECK 회신. 원문 무변경');
        END IF;
        -- 이 FROM 이 컷오프 최종수정자 적재 문장(INSERT INTO GT_DMF0082_T_LAST_DATA_SETUP_*) 안인지: 직전 800자 안에 INSERT 머리
        v_h := DBMS_LOB.INSTR(v_new, c_ins, GREATEST(v_f - 800, 1));
        v_d := DBMS_LOB.INSTR(v_new, c_date, v_f);
        v_g := DBMS_LOB.INSTR(v_new, '    GROUP BY', v_f);
        IF v_h = 0 OR v_h > v_f OR v_d = 0 OR v_g = 0 OR v_d > v_g THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || c_tables(i) || ' 적재 문장 형태 확인 불가. 00_PRECHECK 회신. 원문 무변경');
        END IF;
        v_s := v_d + LENGTH(c_date);
        v_new := SUBSTR(v_new, 1, v_s - 1) || c_cut || SUBSTR(v_new, v_s);
    END LOOP;
    IF (DBMS_LOB.GETLENGTH(v_new) - DBMS_LOB.GETLENGTH(REPLACE(v_new, c_mark, ''))) / LENGTH(c_mark) <> 3
       OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(v_src) + 3 * LENGTH(c_cut) THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치. 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 3곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — [{MARK}] 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 가 넣은 2줄 조건 3곳을 지운다 — ASCII 접두 줄('{CUT_PFX.strip()[:60]}…')부터 다음 줄 끝까지(한글 비교 없음).
-- 가드: 마커 없음 → 무동작 · 대상 3곳이 아니면 중단(원문 무변경) · 컴파일 오류 → 원문 자동 복원
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}BEGIN
{LOAD}
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    locate;
    IF cnt(v_new, CHR(10) || c_pfx, v_m0, v_m1) <> 3 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 조건 줄 ' || cnt(v_new, CHR(10) || c_pfx, v_m0, v_m1) || '곳 (3 기대). 원문 무변경');
    END IF;
    FOR i IN 1 .. 3 LOOP
        locate;
        v_s := DBMS_LOB.INSTR(v_new, CHR(10) || c_pfx, v_m0) + 1;
        v_e := DBMS_LOB.INSTR(v_new, CHR(10), DBMS_LOB.INSTR(v_new, CHR(10), v_s) + 1) + 1;
        v_new := SUBSTR(v_new, 1, v_s - 1) || SUBSTR(v_new, v_e);
    END LOOP;
    IF DBMS_LOB.INSTR(v_new, c_mark) > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치(마커 잔존). 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

RANGE_SQL = f"""   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)) = '{P_FROM}')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '{P_TO}%')"""
PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL
-- * [L1] 대상 원장 3개의 FROM 줄이 GET_MAIN_DATA 에 있는지 (각 1건 이상 PASS) · V_CUTOFF_FROM/TO 변수 실존 (PASS)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 원장 파티션 키 = CUTOFF_YYYYMMDD_DATE (3줄 PASS) — 다르면 이 패치는 효과가 없다
-- * [L4] 버전당 컷오프 1개·CUTOFF_YYYYMMDD_DATE=버전일 (이 DB 데이터 — 조건이 행을 거르지 않음 확인, BAD 0 PASS. 대형 원장이라 1~2분)
-- * [L5] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A40
COLUMN JUDGE FORMAT A60
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 대상' CHK, K.KIND, COUNT(S.LINE) N,
       CASE WHEN COUNT(S.LINE) >= 1 THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END JUDGE
  FROM ( SELECT 'FROM DM_PLN_MKT_FCST_C' KIND, '    FROM   SCM_MGR.DM_PLN_MKT_FCST_C A' TXT FROM DUAL UNION ALL
         SELECT 'FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C', '    FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A' FROM DUAL UNION ALL
         SELECT 'FROM DM_PLN_CFM_SELLING_PRICE_C', '    FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A' FROM DUAL UNION ALL
         SELECT 'V_CUTOFF_FROM 선언', '    V_CUTOFF_FROM       VARCHAR2(8 CHAR);' FROM DUAL ) K
  LEFT JOIN USER_SOURCE S
    ON S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = K.TXT
{RANGE_SQL}
 GROUP BY K.KIND ORDER BY K.KIND;
SELECT 'L2 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 파티션키' CHK, K.T KIND, NVL(P.COLUMN_NAME, '(비파티션)') COL,
       CASE WHEN P.COLUMN_NAME = 'CUTOFF_YYYYMMDD_DATE' THEN 'PASS' ELSE 'FAIL — 파티션 키 다름 → 결과 회신' END JUDGE
  FROM ( SELECT 'DM_PLN_MKT_FCST_C' T FROM DUAL UNION ALL SELECT 'DM_PLN_CFM_MKT_DEMAND_PLAN_C' FROM DUAL UNION ALL SELECT 'DM_PLN_CFM_SELLING_PRICE_C' FROM DUAL ) K
  LEFT JOIN USER_PART_KEY_COLUMNS P ON P.NAME = K.T AND P.OBJECT_TYPE = 'TABLE'
 ORDER BY K.T;
SELECT 'L4 컷오프' CHK, X.T KIND, COUNT(*) VERSIONS, SUM(CASE WHEN X.N_CUT > 1 THEN 1 ELSE 0 END) MULTI_CUT, SUM(X.BAD) BAD_ROWS,
       CASE WHEN SUM(CASE WHEN X.N_CUT > 1 THEN 1 ELSE 0 END) = 0 AND SUM(X.BAD) = 0 THEN 'PASS' ELSE 'FAIL — 회신(조건이 행을 거를 수 있음)' END JUDGE
  FROM ( SELECT 'DM_PLN_MKT_FCST_C' T, A.DIVISION_ID, A.VERSION_NO, COUNT(DISTINCT A.CUTOFF_YYYYMMDD) N_CUT,
                SUM(CASE WHEN A.CUTOFF_YYYYMMDD_DATE <> TO_DATE(A.CUTOFF_YYYYMMDD,'YYYYMMDD') OR A.CUTOFF_YYYYMMDD <> V.YYYYMMDD THEN 1 ELSE 0 END) BAD
           FROM DM_PLN_MKT_FCST_C A JOIN DM_MST_VERSION V ON V.DIVISION_ID = A.DIVISION_ID AND V.VERSION_NO = A.VERSION_NO
          GROUP BY A.DIVISION_ID, A.VERSION_NO
         UNION ALL
         SELECT 'DM_PLN_CFM_MKT_DEMAND_PLAN_C', A.DIVISION_ID, A.VERSION_NO, COUNT(DISTINCT A.CUTOFF_YYYYMMDD),
                SUM(CASE WHEN A.CUTOFF_YYYYMMDD_DATE <> TO_DATE(A.CUTOFF_YYYYMMDD,'YYYYMMDD') OR A.CUTOFF_YYYYMMDD <> V.YYYYMMDD THEN 1 ELSE 0 END)
           FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A JOIN DM_MST_VERSION V ON V.DIVISION_ID = A.DIVISION_ID AND V.VERSION_NO = A.VERSION_NO
          GROUP BY A.DIVISION_ID, A.VERSION_NO
         UNION ALL
         SELECT 'DM_PLN_CFM_SELLING_PRICE_C', A.DIVISION_ID, A.VERSION_NO, COUNT(DISTINCT A.CUTOFF_YYYYMMDD),
                SUM(CASE WHEN A.CUTOFF_YYYYMMDD_DATE <> TO_DATE(A.CUTOFF_YYYYMMDD,'YYYYMMDD') OR A.CUTOFF_YYYYMMDD <> V.YYYYMMDD THEN 1 ELSE 0 END)
           FROM DM_PLN_CFM_SELLING_PRICE_C A JOIN DM_MST_VERSION V ON V.DIVISION_ID = A.DIVISION_ID AND V.VERSION_NO = A.VERSION_NO
          GROUP BY A.DIVISION_ID, A.VERSION_NO ) X
 GROUP BY X.T ORDER BY X.T;
SELECT 'L5 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 3줄 PASS · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 각 조건 줄이 적재 문장의 날짜 조건 바로 다음 줄 PASS
-- * 화면 확인(README 4단계): 40·81 과거 MF/SF/SP 버전 조회가 수 초 안에 끝나고 행 수가 적용 전과 같다.
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN JUDGE FORMAT A60
SELECT 'V1 마커' CHK, COUNT(*) N, LISTAGG(LINE, ',') WITHIN GROUP (ORDER BY LINE) LINES,
       CASE WHEN COUNT(*) = 3 THEN 'PASS' ELSE 'FAIL (미적용 또는 마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 위치' CHK, S.LINE CUT_LINE, P.LINE PREV_LINE,
       CASE WHEN RTRIM(P.TEXT, CHR(10)||CHR(13)) = '{q(DATE_LINE.rstrip(chr(10)))}' THEN 'PASS' ELSE 'FAIL — 위치 이상' END JUDGE
  FROM USER_SOURCE S JOIN USER_SOURCE P ON P.NAME = S.NAME AND P.TYPE = S.TYPE AND P.LINE = S.LINE - 1
 WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY' AND S.TEXT LIKE '{q(CUT_PFX)}%'
 ORDER BY S.LINE;
"""

os.makedirs(OUT, exist_ok=True)
files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_MFPERF_PATCH.sql": APPLY, "90_VERIFY.sql": VERIFY, "99_ROLLBACK_MFPERF_PATCH.sql": ROLLBACK}
for name, body in files.items():
    open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n").write(body)
    print("wrote", name, len(body.splitlines()), "lines")
open(os.path.join(HERE, "_md5_corporate_applied.txt"), "w", encoding="utf-8").write(
    f"PKG_DMF0082 BODY (LF) applied md5={hashlib.md5(APPLIED.encode('utf-8')).hexdigest()} pre md5={hashlib.md5(PRE.encode('utf-8')).hexdigest()} LAST_DDL={last_ddl} FETCHED={fetched}\n")
print("LAST_DDL", last_ddl)
