"""DMF0082_GAP442_ZEROKEEP_CLOUD_20261015 패키지 생성기.

GAP 442 — DMF0082(40) 수량을 0 으로 고쳐 저장하면 원장 행 자체가 지워져 누가 언제 0 으로 바꿨는지 남지 않음.
  AS-IS(DMF0082_SAVE_MAIN_DATA L1917~1945) MERGE: MATCHED+QTY0+MKT_AMT_KRW/LOC → DELETE / MATCHED → UPDATE(0 포함)
  / NOT MATCHED+QTY<>0 → INSERT.  TO-BE P_DMF0082_SAVE_MAIN_DATA 의 Phase 1 DELETE + MERGE 4줄을 AS-IS 와 같게.

FRESH-GATE: 사내 ZIOUI1 ALL_SOURCE 를 지금 재조회해 적용본(신 블록 4곳 · 구 줄 0곳)인지 확인한 뒤에만 생성.
블록 문구는 재조회한 사내 적용본에서 그대로 추출한다 (손으로 다시 쓰지 않음).
"""
import os, sys, datetime, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
MARK = "GAP442 2026-10-15"
P_FROM = "PROCEDURE P_DMF0082_SAVE_MAIN_DATA\n"
P_TO = "PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA"
# (이름, 구 줄(ASCII), 신 블록 시작 토큰(ASCII), 신 블록 마지막 줄 시작 토큰(ASCII))
ITEMS = [
    ("D1 Phase1 DELETE 대상",
     "    WHERE A.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC', 'MKT_FCST', 'VMI_In_Req', 'SCM_FCST')",
     "    /* [" + MARK + "]",
     "    WHERE A.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')"),
    ("D2 Phase1 DELETE 내부",
     "            FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC', 'MKT_FCST', 'VMI_In_Req', 'SCM_FCST')",
     "            FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')  --[" + MARK + "]",
     "            FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')  --[" + MARK + "]"),
    ("M1 MERGE 소스",
     "                 AND M.QTY_PRICE <> 0)",
     "                 AND (M.QTY_PRICE <> 0 OR M.MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'SCM_FCST')))  --[" + MARK + "]",
     "                 AND (M.QTY_PRICE <> 0 OR M.MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'SCM_FCST')))  --[" + MARK + "]"),
    ("M2 MERGE INSERT 조건",
     "    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);",
     "    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE)\n    WHERE B.QTY_PRICE <> 0;  --[" + MARK + "]",
     "    WHERE B.QTY_PRICE <> 0;  --[" + MARK + "]"),
]

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
# FRESH-GATE: 생성 직전 DB 원문 재조회 (ALL_SOURCE + LAST_DDL_TIME)
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
last_ddl = cur.fetchone()[0]
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
src = "".join(r[0] for r in cur).replace("\r\n", "\n")
fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

s0 = src.index("\n" + P_FROM)
s1 = src.index("\n" + P_TO)
BLOCKS = []
for name, old, st, en in ITEMS:
    assert src.count("\n" + old + "\n") == 0, f"FRESH-GATE 실패: 사내에 구 줄 잔존 ({name})"
    assert src.count("\n" + st) == 1, f"FRESH-GATE 실패: 신 블록 시작 {src.count(chr(10) + st)}곳 ({name})"
    b0 = src.index("\n" + st) + 1
    e = src.index(en, b0)
    b1 = src.index("\n", e) + 1
    assert s0 < b0 < b1 < s1, f"블록이 SAVE_MAIN_DATA 구간 밖 ({name})"
    assert b1 - b0 < 1000, f"블록 길이 이상 ({name})"
    BLOCKS.append(src[b0:b1])
assert src.count(MARK) == 4, f"마커 {src.count(MARK)}곳 (4 기대)"


def lit(text):
    """여러 줄 텍스트(끝 LF 포함) → PL/SQL 문자열 식."""
    return " ||\n".join("        '" + ln.replace("'", "''") + "' || CHR(10)" for ln in text[:-1].split("\n"))


def q(text):
    """SQL 문자열 리터럴 본문 — 작은따옴표 이스케이프 + 줄바꿈은 ' || CHR(10) || ' 로 (리터럴 안 생 줄바꿈 금지)."""
    return text.replace("'", "''").replace(chr(10), "' || CHR(10) || '")


STAMP = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)"
RANGE = f"""   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)) = '{P_FROM.strip()}')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '{P_TO}%')"""

DECL = """    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_s0    PLS_INTEGER;
    v_s1    PLS_INTEGER;
    v_pos   PLS_INTEGER;
    v_e     PLS_INTEGER;
    v_end   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '""" + MARK + "';\n"
FUNC = """    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := p_from;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL OR pos > p_to;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;"""
LOAD = f"""    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_s0  := DBMS_LOB.INSTR(v_src, CHR(10) || '{P_FROM.strip()}' || CHR(10));
    v_s1  := DBMS_LOB.INSTR(v_src, CHR(10) || '{P_TO}');
    IF NOT (v_s0 > 0 AND v_s0 < v_s1) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 저장 프로시저 위치 확인 불가 (SAVE_MAIN_DATA / GET_EXCEL_FORM_DATA). 원문 무변경');
    END IF;"""
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

# ── 10_APPLY
a_consts, a_checks, a_steps = [], [], []
for i, ((name, old, st, en), blk) in enumerate(zip(ITEMS, BLOCKS), 1):
    a_consts.append(f"    c_old{i} CONSTANT VARCHAR2(400) :=   -- {name} 구 줄 (ASCII)\n        '{q(old)}' || CHR(10);\n"
                    f"    c_new{i} CONSTANT VARCHAR2(4000) :=   -- {name} 신 블록 (사내 적용본과 동일 문구)\n{lit(blk)};\n")
    a_checks.append(f"""    IF cnt(v_src, CHR(10) || c_old{i}, v_s0, v_s1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — {name} 구 줄이 SAVE_MAIN_DATA 구간에 ' || cnt(v_src, CHR(10) || c_old{i}, v_s0, v_s1) || '건 (1 기대). 00_PRECHECK L1 회신. 원문 무변경');
    END IF;""")
    a_steps.append(f"""    v_s0  := DBMS_LOB.INSTR(v_new, CHR(10) || '{P_FROM.strip()}' || CHR(10));
    v_pos := DBMS_LOB.INSTR(v_new, CHR(10) || c_old{i}, v_s0) + 1;
    v_new := SUBSTR(v_new, 1, v_pos - 1) || c_new{i} || SUBSTR(v_new, v_pos + LENGTH(c_old{i}));""")
len_expr = " + ".join(f"LENGTH(c_new{i}) - LENGTH(c_old{i})" for i in range(1, 5))
APPLY = f"""{STAMP}
-- 10_APPLY — [{MARK}] GAP 442 PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082(40) 저장 P_DMF0082_SAVE_MAIN_DATA 의 DM_PLN_CFM_MKT_DEMAND_PLAN 0 저장 처리를 AS-IS 와 같게 4줄 바꾼다.
--       구: 수량 0 저장 시 5종(MKT_AMT_KRW/LOC · MKT_FCST · VMI_In_Req · SCM_FCST) 원장 행을 삭제 → 누가 언제 0 으로 바꿨는지 남지 않음.
--       신: 삭제는 금액 2종(MKT_AMT_KRW/LOC)만. 수요 3종의 0 은 기존 행 QTY 0 수정(최종 변경자·일시 갱신). 없는 행에 0 은 추가하지 않음.
--       AS-IS 근거: DMF0082_SAVE_MAIN_DATA L1917~1945 MERGE (MATCHED+QTY0+MKT_AMT_* DELETE / MATCHED UPDATE / NOT MATCHED+QTY<>0 INSERT).
-- 범위: 저장 SP 4곳(D1·D2 Phase1 DELETE · M1 MERGE 소스 · M2 MERGE INSERT 조건). 81 경로 · 조회 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 SAVE_MAIN_DATA 구간의 ASCII 구 줄 4줄을 각각 신 블록으로 치환하고 CREATE OR REPLACE
--       (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 구 줄 4개 중 하나라도 구간 안 1건이 아니면 중단(원문 무변경) · 조립 길이 불일치 시 중단
--       · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL {last_ddl}) — 40 EATON_01 2027-12-27 100 저장 → 0 저장: MKT_FCST 행 QTY 0 유지 · MKT_AMT_KRW/LOC 삭제 (AS-IS 동일).
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}{''.join(a_consts)}{FUNC}
BEGIN
{LOAD}
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
{chr(10).join(a_checks)}
    v_new := v_src;
{chr(10).join(a_steps)}
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 4
       OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(v_src) + {len_expr} THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치. 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 4곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

# ── 99_ROLLBACK
r_consts, r_steps = [], []
for i, (name, old, st, en) in enumerate(ITEMS, 1):
    r_consts.append(f"    c_old{i} CONSTANT VARCHAR2(400) := '{q(old)}' || CHR(10);   -- {name} 구 줄\n"
                    f"    c_st{i}  CONSTANT VARCHAR2(400) := CHR(10) || '{q(st)}';   -- 신 블록 시작 (ASCII)\n"
                    f"    c_en{i}  CONSTANT VARCHAR2(400) := '{q(en)}';   -- 신 블록 마지막 줄 시작 (ASCII)\n")
    r_steps.append(f"""    v_s0  := DBMS_LOB.INSTR(v_new, CHR(10) || '{P_FROM.strip()}' || CHR(10));
    v_s1  := DBMS_LOB.INSTR(v_new, CHR(10) || '{P_TO}');
    IF cnt(v_new, c_st{i}, v_s0, v_s1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — {name} 신 블록이 SAVE_MAIN_DATA 구간에 1건이 아님. 원문 무변경');
    END IF;
    v_pos := DBMS_LOB.INSTR(v_new, c_st{i}, v_s0) + 1;               -- 신 블록 첫 글자
    v_e   := DBMS_LOB.INSTR(v_new, c_en{i}, v_pos);                  -- 마지막 줄 시작
    v_end := DBMS_LOB.INSTR(v_new, CHR(10), v_e);                     -- 마지막 줄 끝 LF
    IF v_e = 0 OR v_end = 0 OR v_end > v_s1 OR v_end - v_pos > 1000 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — {name} 신 블록 끝 위치 이상. 원문 무변경');
    END IF;
    v_new := SUBSTR(v_new, 1, v_pos - 1) || c_old{i} || SUBSTR(v_new, v_end + 1);""")
ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — [{MARK}] GAP 442 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 가 바꾼 4곳(D1 · D2 · M1 · M2)을 각각 구 줄 1줄로 되돌린다.
--       각 신 블록은 ASCII 시작 토큰과 ASCII 마지막 줄 시작 토큰으로 찾는다 — 한글 주석 비교에 의존하지 않는다.
-- 가드: 마커 없음 → 무동작 · 신 블록 위치 이상 → 중단(원문 무변경) · 컴파일 오류 → 원문 자동 복원
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}{''.join(r_consts)}{FUNC}
BEGIN
{LOAD}
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) <> 4 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 마커 ' || cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) || '곳 (4 기대). 원문 무변경');
    END IF;
    v_new := v_src;
{chr(10).join(r_steps)}
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치(마커 잔존). 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

# ── 00_PRECHECK
pre_rows = " UNION ALL\n         ".join(f"SELECT '{name}' KIND, '{q(old)}' TXT FROM DUAL" for name, old, _, _ in ITEMS)
PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] GAP 442 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL
-- * [L1] 구 줄 4개 — SAVE_MAIN_DATA 구간에 각 1줄이어야 10 적용 가능 (4줄 모두 PASS 기대)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 참고 — 원장 40 DM_PLN_CFM_MKT_DEMAND_PLAN 수요 3종 QTY 0 행 수 (적용 후 0 저장분이 행으로 남으며 늘어남)
-- * [L4] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A24
COLUMN JUDGE FORMAT A60
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 대상줄' CHK, K.KIND, COUNT(S.LINE) N, LISTAGG(S.LINE, ',') WITHIN GROUP (ORDER BY S.LINE) LINES,
       CASE WHEN COUNT(S.LINE) = 1 THEN 'PASS' ELSE 'FAIL — 건수 다름(1 기대) → 10 실행 금지·결과 회신' END JUDGE
  FROM ( {pre_rows} ) K
  LEFT JOIN USER_SOURCE S
    ON S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = K.TXT
{RANGE}
 GROUP BY K.KIND
 ORDER BY K.KIND;
SELECT 'L2 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 참고' CHK, MEASURE, COUNT(*) QTY0_ROWS
  FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE DIVISION_ID = '40' AND QTY = 0 AND MEASURE IN ('MKT_FCST','VMI_In_Req','SCM_FCST')
 GROUP BY MEASURE ORDER BY MEASURE;
SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""

# ── 90_VERIFY
v_rows = " UNION ALL\n         ".join(
    f"SELECT '{name}' KIND, '{q(old)}' OLD_TXT, '{q(en)}' NEW_TXT FROM DUAL" for name, old, _, en in ITEMS)
VERIFY = f"""-- 90 VERIFY — [{MARK}] GAP 442 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 4줄 PASS · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 4줄 모두 PASS(구 줄 0 · 신 줄 1)
-- * 화면 확인(README 5단계): 40 수량 칸을 0 으로 고쳐 저장 → V4 를 해당 키로 바꿔 실행하면 MKT_FCST 등 행이 QTY 0 으로 남는다.
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A24
COLUMN JUDGE FORMAT A60
SELECT 'V1 마커' CHK, COUNT(*) N, LISTAGG(LINE, ',') WITHIN GROUP (ORDER BY LINE) LINES,
       CASE WHEN COUNT(*) = 4 THEN 'PASS' ELSE 'FAIL (미적용 또는 마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 문장' CHK, K.KIND,
       SUM(CASE WHEN RTRIM(S.TEXT, CHR(10)||CHR(13)) = K.OLD_TXT THEN 1 ELSE 0 END) OLD_N,
       SUM(CASE WHEN S.TEXT LIKE K.NEW_TXT || '%' THEN 1 ELSE 0 END) NEW_N,
       CASE WHEN SUM(CASE WHEN RTRIM(S.TEXT, CHR(10)||CHR(13)) = K.OLD_TXT THEN 1 ELSE 0 END) = 0
             AND SUM(CASE WHEN S.TEXT LIKE K.NEW_TXT || '%' THEN 1 ELSE 0 END) = 1
            THEN 'PASS' ELSE 'FAIL — 구 줄 잔존 또는 신 줄 수 이상' END JUDGE
  FROM ( {v_rows} ) K
  LEFT JOIN USER_SOURCE S
    ON S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
   AND (RTRIM(S.TEXT, CHR(10)||CHR(13)) = K.OLD_TXT OR S.TEXT LIKE K.NEW_TXT || '%')
{RANGE}
 GROUP BY K.KIND
 ORDER BY K.KIND;
"""

os.makedirs(OUT, exist_ok=True)
files = {
    "00_PRECHECK_CLOUD.sql": PRECHECK,
    "10_APPLY_GAP442_PATCH.sql": APPLY,
    "90_VERIFY.sql": VERIFY,
    "99_ROLLBACK_GAP442_PATCH.sql": ROLLBACK,
}
for name, body in files.items():
    open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n").write(body)
    print("wrote", name, len(body.splitlines()), "lines")
open(os.path.join(HERE, "_md5_corporate_applied.txt"), "w", encoding="utf-8").write(
    f"PKG_DMF0082 BODY (LF) md5={hashlib.md5(src.encode('utf-8')).hexdigest()} LAST_DDL={last_ddl} FETCHED={fetched}\n")
print("LAST_DDL", last_ddl, "blocks", [b.count("\n") for b in BLOCKS])
