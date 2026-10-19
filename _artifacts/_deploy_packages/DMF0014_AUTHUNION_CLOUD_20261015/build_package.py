"""DMF0014_AUTHUNION 클라우드 패키지 생성기 — 패치형 (클라우드 USER_SOURCE 를 읽어 관리자 그룹 판정 2줄만 고친다)

왜 패치형인가: 클라우드 PKG_DMF0014 BODY 는 사내와 타 작업자 수정분이 다를 수 있어 전체본 교체 금지.
치환 문구(OLD/NEW/MARK)는 사내 적용 스크립트(_apply_corporate/DMF0014_AUTHUNION_20261015/apply_authunion.py)에서 그대로 가져온다.
FRESH-GATE: 생성 직전 사내 DB(ALL_SOURCE)의 현재 BODY 를 새로 읽어 치환 뒤 문구 2회 · 치환 전 문구 0회인지 확인.

  python build_package.py
"""
import sys, os, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0014_AUTHUNION_20261015\apply_authunion.py"
spec = importlib.util.spec_from_file_location("corp_apply", CORP)
corp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(corp)
MARK = corp.MARK
PKG = "PKG_DMF0014"


def q(s):
    """여러 줄 문자열 → PL/SQL 식 ('…' || CHR(10) || '…' || CHR(10))"""
    parts = []
    for line in s.split("\n")[:-1] if s.endswith("\n") else s.split("\n"):
        parts.append("'" + line.replace("'", "''") + "'")
    expr = " || CHR(10) || ".join(parts)
    return expr + " || CHR(10)" if s.endswith("\n") else expr


def fresh_gate():
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type='PACKAGE BODY' ORDER BY line", {"n": PKG})
        body = "".join(r[0] for r in cur)
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n AND object_type='PACKAGE BODY'", {"n": PKG})
        last_ddl = cur.fetchone()[0]
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') FROM dual")
        now = cur.fetchone()[0]
    if body.count(corp.NEW) != 2 or body.count(corp.OLD) != 0 or body.count(MARK) != 2:
        sys.exit(f"FRESH-GATE FAIL: 사내 BODY 치환 뒤 문구 {body.count(corp.NEW)}회 · 치환 전 {body.count(corp.OLD)}회 · 마커 {body.count(MARK)}회 (2·0·2 기대)")
    print("FRESH-GATE PASS — 사내 BODY LAST_DDL", last_ddl, "FETCHED", now)
    return last_ddl, now


HEAD = f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_pos   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40)   := '{MARK}';
    c_old   CONSTANT VARCHAR2(200)  := {q(corp.OLD)};   -- 치환 전: 그룹명 단일 판정
    c_new   CONSTANT VARCHAR2(2000) := {q(corp.NEW)};   -- 치환 뒤: 보유그룹 합집합 판정
    c_ctx   CONSTANT VARCHAR2(40)   := 'GET_ADMIN_GROUP';
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = '{PKG}' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF NVL(DBMS_LOB.GETLENGTH(v_src), 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — {PKG} BODY 없음. 원문 무변경');
    END IF;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
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
POST = f"SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='{PKG}' ORDER BY OBJECT_TYPE;\n"


def gen_apply(corp_ddl, fetched):
    return f"""-- SOURCE-FRESH: SCM_MGR.{PKG} PACKAGE BODY LAST_DDL={corp_ddl} FETCHED={fetched} DB=ZIOUI1 (패치형 — 적용 대상 원문은 실행 시점 클라우드 USER_SOURCE)
-- 10_APPLY — [{MARK}] {PKG} BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 요청: DMF0014 — 로그인 사용자의 권한그룹이 기준코드 GET_ADMIN_GROUP(VALID_YN='Y', SEGMENT2='ALL') 에 있으면 전행 수정 가능 (AS-IS 동작)
-- 원인: AS-IS 는 P_USERINFO 에 그룹명(NowGroupID)을 넘기지만 TO-BE FE 는 USER_ID 를 넘긴다(session.groupId 미존재)
--       → SP 판정 `SEGMENT1 = P_USERINFO` 가 항상 0건 → 관리자 그룹 사용자도 담당 팀 행만 편집 가능.
-- 보완: 판정 2곳(P_DMF0014_GET_CUST_FCST_UPLOAD_DATA · P_DMF0014_GET_EXCEL_FORM_DATA)을
--       "전달값이 그룹명이거나, 사용자(P_USERINFO/P_USER_ID/P_CREATED_BY)가 보유한 그룹" 으로 확장. FE·BE 변경 없음.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 2줄만 바꾼 뒤 CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 대상 줄이 정확히 2개가 아니거나 GET_ADMIN_GROUP 판정 문맥이 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 {corp_ddl}. 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
{HEAD}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_old) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 판정 줄 "AND SEGMENT1 = P_USERINFO;" ' || cnt(v_src, c_old)
            || '개 (2 기대). 이 DB 의 원문이 사내와 다름 → 00_PRECHECK L1 결과 회신. 원문 무변경');
    END IF;
    FOR i IN 1 .. 2 LOOP   -- 각 줄 바로 앞 400자 안에 GET_ADMIN_GROUP 판정이 있어야 한다
        v_pos := DBMS_LOB.INSTR(v_src, c_old, 1, i);
        IF INSTR(DBMS_LOB.SUBSTR(v_src, 400, GREATEST(v_pos - 400, 1)), c_ctx) = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, '중단 — ' || i || '번째 판정 줄 앞에 GET_ADMIN_GROUP 이 없음. 원문 무변경');
        END IF;
    END LOOP;
    v_new := REPLACE(v_src, c_old, c_new);
    IF cnt(v_new, c_mark) <> 2 OR cnt(v_new, c_old) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치 (마커 ' || cnt(v_new, c_mark) || '곳, 2 기대). 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — {PKG} BODY ' || v_st || ' · 관리자 그룹 판정 2곳 합집합 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback():
    return f"""-- 99 ROLLBACK — [{MARK}] 역치환 (판정 2곳을 그룹명 단일 판정으로 되돌린다). 전체 F5, 멱등
-- 마커 없으면 무동작. ⚠ 되돌리면 관리자 그룹 사용자도 다시 담당 팀 행만 편집 가능해진다.
{HEAD}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_new) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 문구 매칭 ' || cnt(v_src, c_new) || '건 (2 기대). 원문 무변경');
    END IF;
    v_new := REPLACE(v_src, c_new, c_old);
    IF cnt(v_new, c_mark) <> 0 OR cnt(v_new, c_old) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 결과 불일치. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — {PKG} BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


COLS = """SET LINESIZE 260 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A12
COLUMN TXT FORMAT A120
COLUMN JUDGE FORMAT A60
COLUMN GRPS FORMAT A60
"""

SRC_SQL = """SELECT '{tag}' CHK, S.LINE, SUBSTR(LTRIM(RTRIM(S.TEXT, CHR(10)||CHR(13))), 1, 120) TXT
  FROM USER_SOURCE S
 WHERE S.NAME = 'PKG_DMF0014' AND S.TYPE = 'PACKAGE BODY'
   AND (S.TEXT LIKE '%SEGMENT1 = P_USERINFO%' OR S.TEXT LIKE '%GET_ADMIN_GROUP%' OR S.TEXT LIKE '%{mark}%')
 ORDER BY S.LINE;
"""

# 관리자 대상 그룹 보유 사용자 표본 — 수정 전 판정(USER_ID = SEGMENT1) vs 수정 후 판정(보유그룹)
JUDGE_SQL = """SELECT '{tag}' CHK, U.USER_ID, U.GRPS
     , (SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WHERE L.LOOKUP_TYPE='GET_ADMIN_GROUP' AND L.VALID_YN='Y' AND L.SEGMENT2='ALL'
           AND L.SEGMENT1 = U.USER_ID) BEFORE_CNT
     , (SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WHERE L.LOOKUP_TYPE='GET_ADMIN_GROUP' AND L.VALID_YN='Y' AND L.SEGMENT2='ALL'
           AND (L.SEGMENT1 = U.USER_ID OR L.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M G WHERE G.USER_ID = U.USER_ID AND G.USE_YN='Y'))) AFTER_CNT
  FROM (SELECT M.USER_ID, LISTAGG(M.USER_GR_ID, ',') WITHIN GROUP (ORDER BY M.USER_GR_ID) GRPS
          FROM SCM_ADM_USER_GR_MPG_M M
         WHERE M.USE_YN = 'Y'
           AND M.USER_GR_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='GET_ADMIN_GROUP' AND VALID_YN='Y' AND SEGMENT2='ALL')
         GROUP BY M.USER_ID
         ORDER BY M.USER_ID
         FETCH FIRST 10 ROWS ONLY) U;
"""

PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태 확인
-- * [L0] 접속 DB · PKG_DMF0014 상태·LAST_DDL
-- * [L1] 판정 관련 줄 — 사내 적용 전과 같으면 'GET_ADMIN_GROUP' 줄 뒤에 'AND    SEGMENT1 = P_USERINFO;' 가 2번 나온다.
--        2번이 아니면 10 을 실행하지 말고 L1 결과를 회신 (10 을 실행해도 가드로 중단 · 원문 무변경)
-- * [L2] 마커 — 적용 전 0 (적용 뒤 2)
-- * [L3] 두 프로시저에 P_USER_ID · P_CREATED_BY 인자가 있는지 — 프로시저마다 P_CREATED_BY · P_USERINFO · P_USER_ID 3행(합 6) 기대 (치환식이 사용)
-- * [L4] 기준코드 GET_ADMIN_GROUP (VALID_YN='Y', SEGMENT2='ALL') — 사내: ADMIN · DM ADMIN · DM Planner · SCM PI Admin · SCP Planner
-- * [L5] 관리자 대상 그룹 보유 사용자 10명 — BEFORE_CNT 0 (지금 판정 탈락) · AFTER_CNT 1 이상 (적용 뒤 통과 예정)
-- * [L6] 지금 PKG_DMF0014 실행 중 세션 (있으면 끝난 뒤 10 실행)
{COLS}SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0014' ORDER BY O.OBJECT_TYPE;
{SRC_SQL.format(tag='L1 판정줄', mark=MARK)}SELECT 'L2 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 인자' CHK, A.OBJECT_NAME, A.ARGUMENT_NAME, A.POSITION
  FROM USER_ARGUMENTS A
 WHERE A.PACKAGE_NAME='PKG_DMF0014' AND A.OBJECT_NAME IN ('P_DMF0014_GET_CUST_FCST_UPLOAD_DATA','P_DMF0014_GET_EXCEL_FORM_DATA')
   AND A.ARGUMENT_NAME IN ('P_USERINFO','P_USER_ID','P_CREATED_BY')
 ORDER BY A.OBJECT_NAME, A.POSITION;
SELECT 'L4 기준코드' CHK, SEGMENT1, SEGMENT2, VALID_YN
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='GET_ADMIN_GROUP' ORDER BY SEGMENT1, SEGMENT2;
{JUDGE_SQL.format(tag='L5 판정')}SELECT 'L6 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0014' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 PASS(2) · V2 PACKAGE/PACKAGE BODY VALID · 오류 0 · 의존 INVALID 0
--         V3 'AND    SEGMENT1 = P_USERINFO;' 단독 줄 없음 · 마커 줄 2개
--         V4 관리자 대상 그룹 보유 사용자 AFTER_CNT 1 이상 (BEFORE_CNT 는 0 — 수정 전 판정이었다면 탈락)
{COLS}SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 2 THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL (미적용)' ELSE 'FAIL (마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0014')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0014' ORDER BY O.OBJECT_TYPE;
{SRC_SQL.format(tag='V3 판정줄', mark=MARK)}{JUDGE_SQL.format(tag='V4 판정')}"""


README = """# DMF0014 관리자 그룹 전행 수정 (GET_ADMIN_GROUP) 보완 — 클라우드 이관 · 패치형

> 마커 `[{mark}]` — PKG_DMF0014 BODY 의 관리자 그룹 판정 2줄만 변경. 데이터 · 메타 · 화면(FE) · BE 변경 없음.

| 항목 | 값 |
|---|---|
| 요청 | 로그인 사용자의 권한그룹이 기준코드 `GET_ADMIN_GROUP` 목록이면 DMF0014 전행 수정 가능 (AS-IS 동작) |
| AS-IS | `DMF0014_GET_CUST_FCST_UPLOAD_DATA` 가 `p_userinfo`(=로그인 그룹명) 로 판정 → ADMIN 이면 `EDIT_FLAG` 전행 'Y' |
| 원인 | TO-BE FE 는 `P_USERINFO` 에 USER_ID 를 넘김(세션에 그룹 정보 없음) → `SEGMENT1 = P_USERINFO` 항상 0건 → 담당 팀 행만 수정 가능 |
| 보완 | 판정 2곳(`P_DMF0014_GET_CUST_FCST_UPLOAD_DATA` · `P_DMF0014_GET_EXCEL_FORM_DATA`)을 **사용자가 보유한 그룹** 기준으로 확장 (DMF0082 · DMF0021 · DMF0042 와 같은 방식) |
| 사내 적용 | **완료** (ZIOUI1 2026-10-15 10:59:56) · [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0014_AUTHUNION_20261015/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| BE 재기동 · FE | 불요 |

변경 내용 (2곳 동일):
```sql
-- 전
        AND    SEGMENT1 = P_USERINFO;
-- 후
        AND    (SEGMENT1 = P_USERINFO  --[{mark}] …
                OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M G
                                WHERE  G.USER_ID IN (P_USERINFO, P_USER_ID, P_CREATED_BY)
                                AND    G.USE_YN = 'Y'));
```

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | **검증 쿼리.** L1 에 `AND    SEGMENT1 = P_USERINFO;` 2줄(각각 앞에 GET_ADMIN_GROUP) · L2 마커 0 · L3 6행 · L5 BEFORE_CNT 0 / AFTER_CNT ≥1 |
| 2 | [A_DB/10_APPLY_AUTHUNION_PATCH.sql](A_DB/10_APPLY_AUTHUNION_PATCH.sql) | `APPLIED — PKG_DMF0014 BODY VALID · 관리자 그룹 판정 2곳 합집합` (이미 적용이면 `SKIP`, 구조가 다르면 ORA-20001/20003 로 중단·원문 무변경) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 PASS(2) · V2 VALID/오류 0/의존 INVALID 0 · V3 단독 판정 줄 없음 · V4 AFTER_CNT ≥1 |

롤백: [A_DB/99_ROLLBACK_AUTHUNION_PATCH.sql](A_DB/99_ROLLBACK_AUTHUNION_PATCH.sql) — 되돌리면 관리자 그룹 사용자도 다시 담당 팀 행만 수정 가능.

적용 뒤 화면 확인: 관리자 대상 그룹(예: DM ADMIN · DM Planner) 계정으로 DMF0014 조회 → 다른 팀 행의 기간 셀도 편집 가능한지 확인.
ADMIN 그룹이 없는 계정(Viewer 등)은 기존과 같이 담당 팀 행만 편집 가능해야 한다.

## 주의
- **00 의 결과가 기대와 다르면 10 을 실행하지 않는다.** L1 의 판정 줄이 2개가 아니거나 L3 인자가 6행이 아니면 클라우드 원문이 사내와 다른 것이다 → L1 · L3 결과 회신.
  (10 을 실행해도 구조가 다르면 가드로 중단하고 원문을 건드리지 않는다. 컴파일 오류가 나면 원문을 자동 복원한다.)
- L4 기준코드 목록이 사내와 다르면 판정 대상 그룹이 달라진다(패치 자체는 무관) — 결과 회신.
- 10 은 패키지 BODY 재생성이라 DMF0014 조회 · 저장 · Excel Upload 실행 중이면 대기 — 00 L6 확인 뒤 실행.

## 리허설 (사내 ZIOUI1 {rehearsal}, `_rehearsal_out/`)
99(`ROLLED BACK … 마커 0`) → 00(L1 판정 줄 2 · L2 0 · L5 BEFORE 0) → 10(`APPLIED`) → 10(`SKIP` 멱등) → 90(V1 PASS · V2 VALID · V4 AFTER ≥1).

## 작업 ↔ 파일 대조
| 사내에서 한 일 | 파일 |
|---|---|
| PKG_DMF0014 BODY 관리자 그룹 판정 2곳 변경 | A_DB/10_APPLY_AUTHUNION_PATCH.sql |
| 권한 · 시노님 · 메타 · 데이터 · FE · BE 변경 | 없음 |
"""


def main():
    corp_ddl, fetched = fresh_gate()
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_AUTHUNION_PATCH.sql": gen_apply(corp_ddl, fetched),
             "90_VERIFY.sql": VERIFY, "99_ROLLBACK_AUTHUNION_PATCH.sql": gen_rollback()}
    for name, txt in files.items():
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")
    rehearsal = sys.argv[1] if len(sys.argv) > 1 else "(미실행)"
    open(os.path.join(HERE, "00_README.md"), "w", encoding="utf-8", newline="\n").write(
        README.format(mark=MARK, rehearsal=rehearsal))
    print("WROTE 00_README.md")


if __name__ == "__main__":
    main()
