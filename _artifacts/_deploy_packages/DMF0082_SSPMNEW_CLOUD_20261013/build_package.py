"""DMF0082_SSPMNEW 클라우드 패키지 생성기 — 패치형 (클라우드 USER_SOURCE 를 읽어 검증 #5 뒤에 5-1 블록 삽입)

왜 패치형인가: 클라우드 PKG_DMF0082 BODY 와 사내 BODY 는 타 작업자 수정분이 달라 전체본 교체 금지.
삽입 블록·앵커 문구는 사내 적용 스크립트(_apply_corporate/DMF0082_SSPMNEW_20261013/build_apply.py)에서 그대로 가져온다.
FRESH-GATE: 생성 직전 사내 DB(USER_SOURCE)의 현재 BODY 에 `앵커 + 블록` 이 정확히 1회 있는지 확인 — 사내 적용본과 문구가 다르면 중단.

  python build_package.py
"""
import sys, os, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_SSPMNEW_20261013\build_apply.py"
spec = importlib.util.spec_from_file_location("corp_build", CORP)
corp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(corp)
MARK = corp.MARK.strip("[]")
ANCHOR, BLOCK = corp.ANCHOR, corp.BLOCK
END_LINE = "    -- 5. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (END)"
MSG_KEY = "Sales Site Project Model 에 등록되지 않은 조합입니다."


def plsql_lit(text, indent="        "):
    parts = text.split("\n")
    assert parts[-1] == "", "줄바꿈으로 끝나야 함"
    return (" ||\n" + indent).join("'" + p.replace("'", "''") + "' || CHR(10)" for p in parts[:-1])


def fresh_gate():
    # FRESH-GATE: 사내 DB 의 현재 BODY(USER_SOURCE)에 패키지가 넣을 `앵커 + 블록` 이 1회 존재 = 사내 적용본과 문구 동일
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0082' AND type='PACKAGE BODY' ORDER BY line")
        body = "".join(r[0] for r in cur)
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name='PKG_DMF0082' AND object_type='PACKAGE BODY'")
        last_ddl = cur.fetchone()[0]
    if body.count(ANCHOR + BLOCK) != 1:
        sys.exit(f"FRESH-GATE FAIL: 사내 BODY 에 적용 블록 {body.count(ANCHOR + BLOCK)}회 (1회여야 함)")
    print("FRESH-GATE PASS — 사내 BODY LAST_DDL", last_ddl)
    return last_ddl


HEAD = f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
    c_old   CONSTANT VARCHAR2(32767) :=   -- 검증 #5 종료 표시 3줄 (원문)
        {plsql_lit(ANCHOR)};
    c_new   CONSTANT VARCHAR2(32767) :=   -- 원문 3줄 + 5-1 블록
        {plsql_lit(ANCHOR + BLOCK)};
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
"""

TAIL = """    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
"""
POST = "SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;\n"


def gen_apply(corp_ddl):
    return f"""-- 10_APPLY — [{MARK}] PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: P_DMF0082_SAVE_MAIN_DATA 검증 #5(Site/Item Master) 바로 뒤에 5-1 신설 —
--       **신규 행(ACTION='I')** 은 Sales Site Project Model 마스터(SCM_MST_SITE_ITEM) 에 Division·Project·Sales Site·Model 4키가
--       유효(VALID_YN='Y')하게 등록돼 있어야 저장된다. 없으면 검증 실패 메시지로 저장 차단.
--       기존 행 수정·삭제는 종전대로(#5 = 3키). Project 빈값 표기('-'·'/'·공백)는 같은 값으로 본다.
-- 배경: 종전 #5·#17 은 AS-IS 와 같이 Project 를 보지 않아, 다른 Project 로만 등록된 Sales Site-Model 조합도 신규 입력됐다 (사용자 요청 2026-10-13).
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 #5 종료 표시 뒤에 블록만 삽입 후 CREATE OR REPLACE (사내 전체본 복사 아님 — 기존 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커 1건 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 {corp_ddl} (같은 블록 · 검증 9케이스 + 저장 SP 실호출 차단 확인). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
{HEAD}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_old) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 검증 #5 종료 앵커 매칭 ' || cnt(v_src, c_old) || '건 (1 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 문맥 확인');
    END IF;
    v_new := REPLACE(v_src, c_old, c_new);
    IF cnt(v_new, c_mark) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 치환 결과 마커 ' || cnt(v_new, c_mark) || '곳 (1 기대)');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback():
    return f"""-- 99 ROLLBACK — [{MARK}] 역치환 (이 DB 의 USER_SOURCE 를 읽어 5-1 블록 제거 후 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 제거 뒤 마커 0 이어야 실행.
{HEAD}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_new) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 블록 매칭 ' || cnt(v_src, c_new) || '건 (1 기대). 원문 무변경');
    END IF;
    v_new := REPLACE(v_src, c_new, c_old);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 BODY 상태·LAST_DDL
-- * [L1] 패치 앵커 — 검증 #5 종료 표시 줄이 1건이고 앞뒤가 구분선(====)이어야 10 적용 가능
-- * [L2] 마커 — 적용 전 0 (적용 뒤 1)
-- * [L3] 영향 미리보기 — 오늘 이후 원장 키 중 SSPM 4키 유효 등록이 없는 건수 (신규 행만 검증하므로 기존 데이터는 막히지 않는다. 참고용)
-- * [L4] 마스터의 Project 빈값 표기 분포 ('-' / '/' — 둘 다 같은 값으로 처리)
-- * [L5] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행)
SET LINESIZE 220 PAGESIZE 200
SET DEFINE OFF
COLUMN CHK FORMAT A8
COLUMN TXT FORMAT A150
COLUMN JUDGE FORMAT A70
COLUMN SRC FORMAT A28
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 앵커' CHK, COUNT(*) N,
       CASE WHEN COUNT(*) = 1 THEN 'PASS → 10 적용 가능' WHEN COUNT(*) = 0 THEN 'FAIL — 앵커 없음 → 중단·회신' ELSE 'FAIL — 앵커 2건↑ → 중단·회신' END JUDGE
  FROM USER_SOURCE S1
  JOIN USER_SOURCE S0 ON S0.NAME = S1.NAME AND S0.TYPE = S1.TYPE AND S0.LINE = S1.LINE - 1
  JOIN USER_SOURCE S2 ON S2.NAME = S1.NAME AND S2.TYPE = S1.TYPE AND S2.LINE = S1.LINE + 1
 WHERE S1.NAME = 'PKG_DMF0082' AND S1.TYPE = 'PACKAGE BODY'
   AND RTRIM(S1.TEXT, CHR(10)||CHR(13)) = '    ' || RPAD('-', 2, '-') || ' 5. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (END)'
   AND RTRIM(S0.TEXT, CHR(10)||CHR(13)) = '    ' || RPAD('-', 2, '-') || RPAD('=', 122, '=')
   AND RTRIM(S2.TEXT, CHR(10)||CHR(13)) = '    ' || RPAD('-', 2, '-') || RPAD('=', 122, '=');
SELECT 'L1 문맥' CHK, S.LINE, SUBSTR(RTRIM(S.TEXT, CHR(10)||CHR(13)),1,150) TXT
  FROM USER_SOURCE S WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
   AND S.LINE BETWEEN (SELECT MIN(LINE) - 3 FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%5. 40 Validation%Site/Item Master Valid%(END)%')
                  AND (SELECT MIN(LINE) + 2 FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%5. 40 Validation%Site/Item Master Valid%(END)%')
 ORDER BY S.LINE;
SELECT 'L2 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 영향' CHK, X.SRC, COUNT(*) KEYS,
       SUM(CASE WHEN NOT EXISTS (SELECT 1 FROM SCM_MST_SITE_ITEM Z WHERE Z.DIVISION_ID = X.DIVISION_ID AND Z.SCM_SITE_ID = X.SCM_SITE_ID AND Z.ITEM_ID = X.ITEM_ID AND Z.VALID_YN = 'Y'
                                    AND (Z.PROJECT_CODE = X.PROJECT_CODE OR (NVL(TRIM(Z.PROJECT_CODE),'/') IN ('-','/') AND NVL(TRIM(X.PROJECT_CODE),'/') IN ('-','/'))))
                THEN 1 ELSE 0 END) NO_SSPM_4KEY
  FROM (SELECT DISTINCT '40 수요 원장' SRC, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE DIVISION_ID = '40' AND YYYYMMDD >= TO_CHAR(SYSDATE,'YYYYMMDD')
        UNION ALL
        SELECT DISTINCT '40 판가 원장', DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID FROM DM_PLN_CFM_SELLING_PRICE WHERE DIVISION_ID = '40' AND YYYYMMDD >= TO_CHAR(SYSDATE,'YYYYMMDD')
        UNION ALL
        SELECT DISTINCT '81 계열 수요 원장', DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID FROM DM_PLN_MKT_FCST WHERE DIVISION_ID LIKE '81%' AND YYYYMMDD >= TO_CHAR(SYSDATE,'YYYYMMDD')) X
 GROUP BY X.SRC ORDER BY X.SRC;
SELECT 'L4 표기' CHK, S.DIVISION_ID,
       CASE WHEN TRIM(S.PROJECT_CODE) IS NULL THEN '(공백)' WHEN S.PROJECT_CODE IN ('-','/') THEN S.PROJECT_CODE ELSE '(실값)' END PROJECT_KIND, COUNT(*) CNT
  FROM SCM_MST_SITE_ITEM S WHERE S.DIVISION_ID = '40' OR S.DIVISION_ID LIKE '81%'
 GROUP BY S.DIVISION_ID, CASE WHEN TRIM(S.PROJECT_CODE) IS NULL THEN '(공백)' WHEN S.PROJECT_CODE IN ('-','/') THEN S.PROJECT_CODE ELSE '(실값)' END
 ORDER BY 2, 3;
SELECT 'L5 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] V1~V3 조회 전용 · V4 = 저장 SP 를 '마스터에 없는 Project' 신규 행 1건으로 호출해 차단 확인
-- * 기대: V1 마커 PASS · V2 VALID/오류 0 · V3 5-1 블록 줄 · V4 'PASS — 5-1 검증으로 차단 · 원장 0 → 0'
-- * V4 는 **마커가 있을 때만** 호출한다 (미적용 상태에서 호출하면 시험 행이 저장될 수 있어 건너뛴다).
--   시험 키 = 마스터에 실값 Project 로 유효 등록된 Sales Site-Model 1건 + 존재하지 않는 Project 'ZZ_SSPMNEW_TEST'.
--   호출 전후 원장(수요·판가)에 그 키가 0건인지 확인하고, 막히지 않았으면 FAIL 과 함께 키를 출력한다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A8
COLUMN TXT FORMAT A150
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) >= 1 THEN 'PASS' ELSE 'FAIL (미적용)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 블록' CHK, S.LINE, SUBSTR(RTRIM(S.TEXT, CHR(10)||CHR(13)),1,150) TXT
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY'
   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%') + 14
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%') + 28
 ORDER BY S.LINE;
DECLARE
    n_mark PLS_INTEGER;
    v_div  VARCHAR2(50); v_site VARCHAR2(200); v_item VARCHAR2(200);
    c_prj  CONSTANT VARCHAR2(30) := 'ZZ_SSPMNEW_TEST';
    v_ymd  VARCHAR2(8) := TO_CHAR(TRUNC(SYSDATE,'IW') + 7, 'YYYYMMDD');
    n_b    PLS_INTEGER; n_a PLS_INTEGER;
    rc     SYS_REFCURSOR;
    v_code VARCHAR2(100); v_msg VARCHAR2(4000); v_evt VARCHAR2(400);
    FUNCTION ledger_cnt RETURN PLS_INTEGER IS
        n1 PLS_INTEGER; n2 PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO n1 FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE DIVISION_ID = v_div AND PROJECT_CODE = c_prj AND SCM_SITE_ID = v_site AND ITEM_ID = v_item;
        SELECT COUNT(*) INTO n2 FROM DM_PLN_CFM_SELLING_PRICE   WHERE DIVISION_ID = v_div AND PROJECT_CODE = c_prj AND SCM_SITE_ID = v_site AND ITEM_ID = v_item;
        RETURN n1 + n2;
    END;
BEGIN
    SELECT COUNT(*) INTO n_mark FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
    IF n_mark = 0 THEN
        DBMS_OUTPUT.PUT_LINE('V4 SKIP — 미적용 상태 (10 적용 뒤 다시 실행)');
        RETURN;
    END IF;
    BEGIN
        SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID INTO v_div, v_site, v_item
          FROM (SELECT S.DIVISION_ID, S.SCM_SITE_ID, S.ITEM_ID
                  FROM SCM_MST_SITE_ITEM S
                 WHERE S.DIVISION_ID = '40' AND S.VALID_YN = 'Y' AND S.PROJECT_CODE NOT IN ('-','/') AND TRIM(S.PROJECT_CODE) IS NOT NULL
                   AND EXISTS (SELECT 1 FROM SCM_MST_ITEM_SN N WHERE N.DIVISION_ID = S.DIVISION_ID AND N.ITEM_ID = S.ITEM_ID AND N.ACTIVE_FLAG = 'Y')
                 ORDER BY S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID)
         WHERE ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('V4 SKIP — 시험에 쓸 40 유효 Sales Site-Model 이 없음');
        RETURN;
    END;
    n_b := ledger_cnt;
    IF n_b <> 0 THEN
        DBMS_OUTPUT.PUT_LINE('V4 SKIP — 시험 키가 원장에 이미 있음(' || n_b || '건) · 호출하지 않음');
        RETURN;
    END IF;
    SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA('I', v_div, c_prj, c_prj, v_site, v_item, 'E', 'MPS', 'CPT', 'MKT_FCST', '-', '-', v_ymd, '', '1', 'minyonglee1', '', rc);
    FETCH rc INTO v_code, v_msg, v_evt;
    CLOSE rc;
    ROLLBACK;
    n_a := ledger_cnt;
    DBMS_OUTPUT.PUT_LINE('V4 시험 키 = ' || v_div || ' / ' || c_prj || ' / ' || v_site || ' / ' || v_item);
    DBMS_OUTPUT.PUT_LINE('V4 결과 = ' || v_code || ' | ' || REPLACE(SUBSTR(v_msg,1,300), CHR(10), ' / '));
    DBMS_OUTPUT.PUT_LINE('V4 ' || CASE WHEN n_a <> 0 THEN 'FAIL — 막히지 않고 저장됨(' || n_a || '건). 위 시험 키의 행을 정리해야 함'
                                      WHEN v_code = '0' THEN 'FAIL — 성공 응답'
                                      WHEN INSTR(v_msg, '{MSG_KEY}') > 0 THEN 'PASS — 5-1 검증으로 차단 · 원장 0 → 0'
                                      ELSE 'CHECK — 저장은 막혔으나 5-1 보다 앞선 검증 메시지 (위 결과 문구 확인) · 원장 0 → 0' END);
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('V4 FAIL — ' || REPLACE(SUBSTR(SQLERRM,1,300), CHR(10), ' / '));
END;
/
"""


def main():
    corp_ddl = fresh_gate()
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_SSPMNEW_PATCH.sql": gen_apply(corp_ddl),
             "90_VERIFY.sql": VERIFY, "99_ROLLBACK_SSPMNEW_PATCH.sql": gen_rollback()}
    for name, txt in files.items():
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")


if __name__ == "__main__":
    main()
