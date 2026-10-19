"""DMF0082_GAP445_MKTFCSTPP_CLOUD_20261015 패키지 생성기.

GAP 445 — DMF0082 MKT FCST[P+P](MKT_FCST_PP) 를 골라도 계획 수량이 거의 표시되지 않음 (Current 29행 ↔ MKT_FCST 304행).
  AS-IS DMF0082_GET_MAIN_DATA 는 Current·MF·SF 모두 계획구간 MKT_FCST 를 MKT_FCST_PP 로 복사 적재한다(실행 문장 확인).
  TO-BE 는 SF 분기에만 있음 → P_DMF0082_GET_MAIN_DATA Current·MF '계획구간 수요' 블록 뒤에 복사 블록 2개 삽입.

FRESH-GATE: 사내 ZIOUI1 ALL_SOURCE 를 지금 재조회해 적용본(마커 2곳 · 블록 위치 정상)인지 확인한 뒤에만 생성.
블록 문구는 재조회한 사내 적용본에서 그대로 추출한다 (손으로 다시 쓰지 않음).
"""
import os, sys, datetime, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
MARK = "GAP445 2026-10-15"
P_FROM = "PROCEDURE P_DMF0082_GET_MAIN_DATA"
P_TO = "PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT"
END_DIV = "        END IF;  --[DIV81]\n"                                                       # ASCII
BR_CUR = "    IF p_version_type LIKE '%Current%' OR p_version_type LIKE '%current%' THEN\n"   # ASCII (GET_MAIN_DATA 첫 분기)
BR_MF = "    IF p_version_type LIKE '%MF%' THEN\n"                                           # ASCII
BR_SF = "    IF p_version_type LIKE '%SF%' THEN\n"                                           # ASCII
ST_CUR = "        /* [" + MARK + "] MKT_FCST [P+P] Current"                                  # ASCII
ST_MF = "        /* [" + MARK + "] MKT_FCST [P+P] MF"                                        # ASCII

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
# FRESH-GATE: 생성 직전 DB 원문 재조회 (ALL_SOURCE + LAST_DDL_TIME)
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
last_ddl = cur.fetchone()[0]
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
src = "".join(r[0] for r in cur).replace("\r\n", "\n")
fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

assert src.count(MARK) == 2, f"FRESH-GATE 실패: 사내 마커 {src.count(MARK)}곳 (2 기대)"
m0 = src.index("\n" + P_FROM + "\n"); m1 = src.index("\n" + P_TO)
cb = src.index(BR_CUR, m0); mb = src.index(BR_MF, m0); sb = src.index(BR_SF, m0)
assert m0 < cb < mb < sb < m1


def block(st):
    s = src.index(st)
    assert src[s - 2:s] == "\n\n", "블록 앞 빈 줄 없음"
    e = src.index(END_DIV, s) + len(END_DIV)
    return s - 1, e, src[s - 1:e]          # 삽입분 = 빈 줄(LF) + 블록


c0, c1, CUR_INS = block(ST_CUR)
f0, f1, MF_INS = block(ST_MF)
# 삽입 위치 = 각 분기 뒤 첫 END IF --[DIV81] 직후 (적용본 기준으로 되짚어 확인)
assert src.index(END_DIV, cb) + len(END_DIV) == c0 and cb < c0 < mb, "Current 블록 위치 이상"
assert src.index(END_DIV, mb) + len(END_DIV) == f0 and mb < f0 < sb, "MF 블록 위치 이상"
for ins in (CUR_INS, MF_INS):
    assert ins.count("'MKT_FCST_PP' AS MEASURE") == 2 and len(ins.encode("utf-8")) < 30000


def lit(text):
    """여러 줄 텍스트(끝 LF 포함) → PL/SQL 문자열 식. 빈 줄 보존."""
    return " ||\n".join("        '" + ln.replace("'", "''") + "' || CHR(10)" for ln in text[:-1].split("\n"))


def q(text):
    return text.replace("'", "''").replace(chr(10), "' || CHR(10) || '")


STAMP = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)"
RANGE = f"""   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)) = '{P_FROM}')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '{P_TO}%')"""
DECL = f"""    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_m0     PLS_INTEGER;
    v_m1     PLS_INTEGER;
    v_cb     PLS_INTEGER;
    v_mb     PLS_INTEGER;
    v_sb     PLS_INTEGER;
    v_pos    PLS_INTEGER;
    v_end    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)  := '{MARK}';
    c_enddiv CONSTANT VARCHAR2(100) := CHR(10) || '{q(END_DIV)}';
    c_br_cur CONSTANT VARCHAR2(200) := CHR(10) || '{q(BR_CUR)}';
    c_br_mf  CONSTANT VARCHAR2(200) := CHR(10) || '{q(BR_MF)}';
    c_br_sf  CONSTANT VARCHAR2(200) := CHR(10) || '{q(BR_SF)}';
"""
FUNC = """    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := p_from;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL OR pos > p_to;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    PROCEDURE locate(p_src CLOB) IS
    BEGIN
        v_m0 := DBMS_LOB.INSTR(p_src, CHR(10) || '""" + P_FROM + """' || CHR(10));
        v_m1 := DBMS_LOB.INSTR(p_src, CHR(10) || '""" + P_TO + """');
        v_cb := DBMS_LOB.INSTR(p_src, c_br_cur, v_m0);
        v_mb := DBMS_LOB.INSTR(p_src, c_br_mf, v_m0);
        v_sb := DBMS_LOB.INSTR(p_src, c_br_sf, v_m0);
        IF NOT (v_m0 > 0 AND v_m0 < v_cb AND v_cb < v_mb AND v_mb < v_sb AND v_sb < v_m1) THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — GET_MAIN_DATA 의 Current/MF/SF 분기 위치 확인 불가. 00_PRECHECK L1 회신. 원문 무변경');
        END IF;
    END;"""
LOAD = """    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)"""
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
-- 10_APPLY — [{MARK}] GAP 445 PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 조회 P_DMF0082_GET_MAIN_DATA 의 Current · MF 분기 '계획구간 수요' 블록 바로 뒤에
--       MKT_FCST → MKT_FCST_PP 복사 적재 블록을 각 1개 넣는다 (같은 SP 의 SF 분기 블록과 같은 형태 · 81/82 · 40 테이블 분기 포함).
--       구: SF 분기에만 있어 Current·MF 조회 시 MKT FCST[P+P] 계획 수량이 거의 표시되지 않음(40 Current 29행 ↔ MKT_FCST 304행).
--       AS-IS 근거: DMF0082_GET_MAIN_DATA Current L1798~1895 · MF L3008~3108 (실행 문장 — 중첩주석 판정).
-- 범위: 조회 SP 블록 2개 삽입. 저장 · 원장 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 표지(Current/MF 분기 시작 줄 → 그 뒤 첫 'END IF;  --[DIV81]') 직후에 블록을 넣고
--       CREATE OR REPLACE (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 분기 위치/삽입 위치 이상 시 중단 · 삽입 위치 앞 구간에 계획구간 원장이 없으면 중단(원문 무변경)
--       · 조립 길이 불일치 시 중단 · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL {last_ddl}) — 40 Current 20260901~20270228: MKT_FCST_PP 29 → 309행 · 계획구간 값 MKT_FCST 와 키 302건·전 칸 일치.
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}    c_cur    CONSTANT VARCHAR2(32767) :=   -- Current 삽입분 (빈 줄 + 블록, 사내 적용본과 동일 문구)
{lit(CUR_INS)};
    c_mf     CONSTANT VARCHAR2(32767) :=   -- MF 삽입분 (빈 줄 + 블록, 사내 적용본과 동일 문구)
{lit(MF_INS)};
{FUNC}
BEGIN
{LOAD}
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    locate(v_src);
    -- Current: 분기 시작 뒤 첫 END IF --[DIV81] 직후 (그 사이에 Current 계획구간 원장 적재가 있어야 함)
    v_end := DBMS_LOB.INSTR(v_src, c_enddiv, v_cb);
    IF v_end = 0 OR v_end > v_mb
       OR cnt(v_src, 'SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A', v_cb, v_end) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — Current 계획구간 수요 블록 끝 확인 불가. 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    v_pos := v_end + LENGTH(c_enddiv);   -- 삽입 위치 (END IF 줄 다음 줄 첫 글자)
    v_new := SUBSTR(v_src, 1, v_pos - 1) || c_cur || SUBSTR(v_src, v_pos);
    -- MF: 같은 방식 (조립본에서 다시 위치 계산)
    locate(v_new);
    v_end := DBMS_LOB.INSTR(v_new, c_enddiv, v_mb);
    IF v_end = 0 OR v_end > v_sb
       OR cnt(v_new, 'SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A', v_mb, v_end) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — MF 계획구간 수요 블록 끝 확인 불가. 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    v_pos := v_end + LENGTH(c_enddiv);
    v_new := SUBSTR(v_new, 1, v_pos - 1) || c_mf || SUBSTR(v_new, v_pos);
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 2
       OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(v_src) + LENGTH(c_cur) + LENGTH(c_mf) THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치. 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 2곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — [{MARK}] GAP 445 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 가 넣은 블록 2개(각 '빈 줄 + ASCII 마커 줄 ~ 첫 END IF --[DIV81]')를 지운다 — 한글 주석 비교에 의존하지 않는다.
-- 가드: 마커 없음 → 무동작 · 블록 위치 이상 → 중단(원문 무변경) · 컴파일 오류 → 원문 자동 복원
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}    c_st_cur CONSTANT VARCHAR2(200) := CHR(10) || CHR(10) || '{q(ST_CUR)}';   -- 빈 줄 + 마커 줄 시작 (ASCII)
    c_st_mf  CONSTANT VARCHAR2(200) := CHR(10) || CHR(10) || '{q(ST_MF)}';
{FUNC}
    PROCEDURE cut(p_tok VARCHAR2, p_lo PLS_INTEGER, p_hi PLS_INTEGER, p_name VARCHAR2) IS
    BEGIN
        IF cnt(v_new, p_tok, p_lo, p_hi) <> 1 THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 블록이 해당 분기에 1건이 아님. 원문 무변경');
        END IF;
        v_pos := DBMS_LOB.INSTR(v_new, p_tok, p_lo);                 -- 앞 END IF 줄 끝 LF
        v_end := DBMS_LOB.INSTR(v_new, c_enddiv, v_pos + 2);          -- 블록 마지막 END IF 줄 앞 LF
        IF v_end = 0 OR v_end > p_hi OR v_end - v_pos > 30000 THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — ' || p_name || ' 블록 끝 위치 이상. 원문 무변경');
        END IF;
        v_new := SUBSTR(v_new, 1, v_pos) || SUBSTR(v_new, v_end + LENGTH(c_enddiv));
    END;
BEGIN
{LOAD}
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 마커 ' || cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) || '곳 (2 기대). 원문 무변경');
    END IF;
    v_new := v_src;
    locate(v_new);
    cut(c_st_mf, v_mb, v_sb, 'MF');          -- 뒤쪽 먼저 (앞쪽 위치 불변)
    locate(v_new);
    cut(c_st_cur, v_cb, v_mb, 'Current');
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치(마커 잔존). 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] GAP 445 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL
-- * [L1] 표지 줄 — GET_MAIN_DATA 구간에 Current/MF/SF 분기 시작 줄 각 1 · 'END IF;  --[DIV81]' 존재 (전부 PASS 기대)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 블록이 쓰는 원장·GTT 실존 + 같은 SP SF 분기에 MKT_FCST_PP 복사가 이미 있음(원본 형태) (전부 PASS 기대)
-- * [L4] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A40
COLUMN JUDGE FORMAT A60
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 표지' CHK, K.KIND, COUNT(S.LINE) N, LISTAGG(S.LINE, ',') WITHIN GROUP (ORDER BY S.LINE) LINES,
       CASE WHEN (K.EXPECT = 1 AND COUNT(S.LINE) = 1) OR (K.EXPECT = 9 AND COUNT(S.LINE) >= 2) THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END JUDGE
  FROM ( SELECT 'Current 분기 시작' KIND, '{q(BR_CUR.rstrip(chr(10)))}' TXT, 1 EXPECT FROM DUAL UNION ALL
         SELECT 'MF 분기 시작', '{q(BR_MF.rstrip(chr(10)))}', 1 FROM DUAL UNION ALL
         SELECT 'SF 분기 시작', '{q(BR_SF.rstrip(chr(10)))}', 1 FROM DUAL UNION ALL
         SELECT 'END IF --[DIV81] (2+)', '{q(END_DIV.rstrip(chr(10)))}', 9 FROM DUAL ) K
  LEFT JOIN USER_SOURCE S
    ON S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = K.TXT
{RANGE}
 GROUP BY K.KIND, K.EXPECT
 ORDER BY K.KIND;
SELECT 'L2 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 실존' CHK, K.KIND, CASE WHEN O.OBJECT_NAME IS NULL THEN 'FAIL — 없음 → 10 실행 금지' ELSE 'PASS' END JUDGE
  FROM ( SELECT 'DM_PLN_MKT_FCST' KIND FROM DUAL UNION ALL SELECT 'DM_PLN_MKT_FCST_C' FROM DUAL UNION ALL
         SELECT 'DM_PLN_CFM_MKT_DEMAND_PLAN' FROM DUAL UNION ALL SELECT 'DM_PLN_CFM_MKT_DEMAND_PLAN_C' FROM DUAL UNION ALL
         SELECT 'GT_DMF0082_T_LAST_DATA_SETUP_FCST' FROM DUAL UNION ALL SELECT 'GT_DMF0082_T_LAST_DATA_SETUP_FCST_C' FROM DUAL UNION ALL
         SELECT 'GT_DMF0082_T_VERSION' FROM DUAL UNION ALL SELECT 'GT_DMF0082_TEMP_FCST_N_PRICE' FROM DUAL ) K
  LEFT JOIN (SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_TYPE = 'TABLE') O ON O.OBJECT_NAME = K.KIND
UNION ALL
SELECT 'L3 실존', 'SF 분기 MKT_FCST_PP 복사(원본 형태)',
       CASE WHEN COUNT(*) >= 2 THEN 'PASS' ELSE 'FAIL — SF 원본 블록 없음(구세대 BODY) → 10 실행 금지·결과 회신' END
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY' AND S.TEXT LIKE '%''MKT_FCST_PP'' AS MEASURE%'
{RANGE};
SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""

BR_POS = lambda br: f"(SELECT MIN(S.LINE) FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{q(br.rstrip(chr(10)))}'\n{RANGE})"
VERIFY = f"""-- 90 VERIFY — [{MARK}] GAP 445 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 2줄 PASS · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 Current 블록은 Current~MF 분기 사이, MF 블록은 MF~SF 분기 사이 PASS
--         · V4 MKT_FCST_PP 적재 문장 수 = 6 (Current 2 · MF 2 · SF 2) PASS
-- * 화면 확인(README 4단계): MKT FCST[P+P] 를 화면 설정에 둔 사용자로 Current 조회 → 계획구간 값이 MKT_FCST 와 같다.
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN JUDGE FORMAT A60
SELECT 'V1 마커' CHK, COUNT(*) N, LISTAGG(LINE, ',') WITHIN GROUP (ORDER BY LINE) LINES,
       CASE WHEN COUNT(*) = 2 THEN 'PASS' ELSE 'FAIL (미적용 또는 마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 위치' CHK, CB.L CUR_BR, MC.L CUR_MARK, MB.L MF_BR, MM.L MF_MARK, SB.L SF_BR,
       CASE WHEN CB.L < MC.L AND MC.L < MB.L AND MB.L < MM.L AND MM.L < SB.L THEN 'PASS' ELSE 'FAIL — 블록 위치 이상' END JUDGE
  FROM (SELECT {BR_POS(BR_CUR)} L FROM DUAL) CB,
       (SELECT {BR_POS(BR_MF)} L FROM DUAL) MB,
       (SELECT {BR_POS(BR_SF)} L FROM DUAL) SB,
       (SELECT MIN(LINE) L FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '{q(ST_CUR)}%') MC,
       (SELECT MIN(LINE) L FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '{q(ST_MF)}%') MM;
SELECT 'V4 문장' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 6 THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY' AND S.TEXT LIKE '%''MKT_FCST_PP'' AS MEASURE%'
{RANGE};
"""

os.makedirs(OUT, exist_ok=True)
files = {
    "00_PRECHECK_CLOUD.sql": PRECHECK,
    "10_APPLY_GAP445_PATCH.sql": APPLY,
    "90_VERIFY.sql": VERIFY,
    "99_ROLLBACK_GAP445_PATCH.sql": ROLLBACK,
}
for name, body in files.items():
    open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n").write(body)
    print("wrote", name, len(body.splitlines()), "lines")
open(os.path.join(HERE, "_md5_corporate_applied.txt"), "w", encoding="utf-8").write(
    f"PKG_DMF0082 BODY (LF) md5={hashlib.md5(src.encode('utf-8')).hexdigest()} LAST_DDL={last_ddl} FETCHED={fetched}\n")
print("LAST_DDL", last_ddl, "blocks", CUR_INS.count("\n"), MF_INS.count("\n"), "bytes", len(CUR_INS.encode()), len(MF_INS.encode()))
