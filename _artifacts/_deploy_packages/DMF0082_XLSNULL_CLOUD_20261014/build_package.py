"""DMF0082_XLSNULL 클라우드 패키지 생성기 — 패치형 (그 DB 의 USER_SOURCE 를 읽어 P_DMF0082_EXCEL_UPLOAD 구간만 치환)

[E20261014-DMF0082XLSNULL] P_DMF0082_EXCEL_UPLOAD 의 빈값 판정 `NVL(x,'') = ''` / `NVL(x,'') <> ''` / `CASE WHEN x = '' THEN`
은 Oracle 에서 '' = NULL 이라 항상 거짓이다. → AS-IS 이식본 PKG_DMF0020.P_DMF0020_EXCEL_UPLOAD 와 같이 IS NULL / IS NOT NULL 로 정정.
  · 바꾼 자리마다 /*XLSNULL*/ 표식을 남긴다 (원복 99 가 표식으로 원문을 되돌린다).
  · 치환 대상·개수는 사내 원문에서 정규식으로 뽑고, 같은 쌍을 PL/SQL 에 박아 클라우드에서도 개수가 같을 때만 적용한다.

왜 패치형인가: 클라우드 PKG_DMF0082 BODY 는 사내와 타 작업자 반영분이 달라 전체본 교체 금지.
FRESH-GATE: 생성 시 사내 DB(USER_SOURCE)를 새로 읽어 기준본으로 삼는다. 사내 적용(run_corp.py)은 적용 직전 재조회해 기준본과 같을 때만 실행.

  python build_package.py           # 사내 원문 조회 → 백업 + A_DB/*.sql 생성 (DB 무변경)
"""
import os
import re
import sys
from datetime import datetime

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
CORP_DIR = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_XLSNULL_20261014"
MARK = "E20261014-DMF0082XLSNULL"
TAG = "XLSNULL"
PROC_START = "\nPROCEDURE P_DMF0082_EXCEL_UPLOAD\n"
PROC_END = "\nPROCEDURE P_DMF0082_GET_EXCEL_UPLOAD_DATA"
ANCHOR = "    -- @p_mode = 0 이면 Validation\n"
NOTE = (
    "    --[E20261014-DMF0082XLSNULL] 빈값 판정 정정 (사용자 신고 2026-10-14 — Model 빈칸 업로드가 저장 0건).\n"
    "    --  구 판정 NVL(x,'') = '' / NVL(x,'') <> '' / CASE WHEN x = '' 는 Oracle 에서 '' = NULL 이라 항상 거짓이었다.\n"
    "    --  → Model 빈칸 행이 저장 대상에서 빠지고, 필수값·Invalid MODEL·음수·0·통화중복 검사가 1행도 잡지 못했으며,\n"
    "    --    빈 월이 '0' 으로 바뀌지 않았다. AS-IS 이식본 PKG_DMF0020.P_DMF0020_EXCEL_UPLOAD 와 같이 IS NULL / IS NOT NULL 로 정정.\n"
    "    --  바꾼 자리마다 /*XLSNULL*/ 표식 (원복 = 표식 자리를 원문으로 되돌림).\n"
)
PAT_NVL = re.compile(r"NVL\(([A-Z][A-Z0-9_]*(?:\.[A-Z][A-Z0-9_]*)?),(\s*)''\)(\s*)(=|<>)(\s*)''")
PAT_CASE = re.compile(r"CASE WHEN (ATTRIBUTE\d+)(\s*)=(\s*)'' THEN")


def fetch_body(cur):
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    body = "".join(r[0] or "" for r in cur)
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM USER_OBJECTS "
                "WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
    last_ddl, status = cur.fetchone()
    return body, last_ddl, status


def span_of(body):
    assert body.count(PROC_START) == 1, f"PROC_START 매칭 {body.count(PROC_START)}"
    assert body.count(PROC_END) == 1, f"PROC_END 매칭 {body.count(PROC_END)}"
    s, e = body.index(PROC_START), body.index(PROC_END)
    assert s < e
    return s, e


def build_pairs(span):
    """구간 원문에서 (구 토큰, 신 토큰, 개수) 를 뽑는다. 신 토큰은 서로 달라야 원복이 1:1 로 된다."""
    olds = {}
    for m in PAT_NVL.finditer(span):
        var, op = m.group(1), m.group(4)
        olds.setdefault(m.group(0), (var, "IS NULL" if op == "=" else "IS NOT NULL"))
    for m in PAT_CASE.finditer(span):
        olds.setdefault(m.group(0), (m.group(1), "IS NULL"))
    pairs, used = [], {}
    for old, (var, pred) in olds.items():
        # 별칭(EU./TMP.)이 붙은 토큰은 표식에 별칭을 넣는다 — 'ATTRIBUTE7 IS NOT NULL /*XLSNULL*/' 이
        # 'EU.ATTRIBUTE7 IS NOT NULL /*XLSNULL*/' 안에 포함돼 원복 개수·치환이 어긋나는 것을 막는다.
        tag = f"/*{TAG}.{var.split('.')[0]}*/" if "." in var else f"/*{TAG}*/"
        base = f"{var} {pred} {tag}"
        if old.startswith("CASE WHEN"):
            base = f"CASE WHEN {var} {pred} {tag} THEN"
        new, k = base, 1
        while new in used:  # 공백만 다른 구 토큰이 같은 신 토큰이 되면 표식 번호로 구분
            k += 1
            new = base.replace(tag, tag[:-2] + f".{k}*/")
        used[new] = old
        pairs.append((old, new, span.count(old)))
    for i, (_, n1, _) in enumerate(pairs):
        for j, (_, n2, _) in enumerate(pairs):
            assert i == j or n1 not in n2, f"적용 토큰 포함 관계: {n1!r} ⊂ {n2!r}"
    # 치환 순서: 긴 토큰 먼저 (부분 문자열 충돌 방지 — 아래 assert 로 재확인)
    pairs.sort(key=lambda p: -len(p[0]))
    for i, (o, _, _) in enumerate(pairs):
        for j, (o2, _, _) in enumerate(pairs):
            assert i == j or o not in o2, f"토큰 포함 관계: {o!r} ⊂ {o2!r}"
    return pairs


def patch(body, pairs):
    s, e = span_of(body)
    span = body[s:e]
    assert TAG not in span, "이미 적용됨"
    assert span.count(ANCHOR) == 1, f"ANCHOR 매칭 {span.count(ANCHOR)}"
    for old, new, n in pairs:
        assert span.count(old) == n, f"{old!r} 개수 {span.count(old)} != {n}"
        span = span.replace(old, new)
    span = span.replace(ANCHOR, NOTE + ANCHOR)
    # 독립 검산: 정규식 치환 결과와 같은 토큰이 하나도 남지 않아야 한다
    assert not PAT_NVL.search(span) and not PAT_CASE.search(span), "잔존 토큰 있음"
    return body[:s] + span + body[e:]


def unpatch(body, pairs):
    s, e = span_of(body)
    span = body[s:e].replace(NOTE, "")
    for old, new, n in pairs:
        assert span.count(new) == n, f"{new!r} 개수 {span.count(new)} != {n}"
        span = span.replace(new, old)
    assert TAG not in span
    return body[:s] + span + body[e:]


def lit(text):
    return "'" + text.replace("'", "''") + "'"


def plsql_lines(text, indent="        "):
    parts = text.split("\n")
    assert parts[-1] == ""
    return (" ||\n" + indent).join(lit(p) + " || CHR(10)" for p in parts[:-1])


def head(pairs):
    olds = ",\n        ".join(lit(o) for o, _, _ in pairs)
    news = ",\n        ".join(lit(n) for _, n, _ in pairs)
    cnts = ", ".join(str(c) for _, _, c in pairs)
    return f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    TYPE t_s IS TABLE OF VARCHAR2(200);
    TYPE t_n IS TABLE OF PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
    c_tag   CONSTANT VARCHAR2(20) := '/*{TAG}';   -- 치환 표식(/*XLSNULL*/) 전용 — 마커 문자열 {MARK} 와 겹치지 않게
    c_old   t_s := t_s(
        {olds});
    c_new   t_s := t_s(
        {news});
    c_cnt   t_n := t_n({cnts});
    c_anc   CONSTANT VARCHAR2(400) := {plsql_lines(ANCHOR)};
    c_note  CONSTANT VARCHAR2(4000) :=
        {plsql_lines(NOTE)};
    v_src   CLOB;
    v_span  CLOB;
    v_new   CLOB;
    v_s     PLS_INTEGER;
    v_e     PLS_INTEGER;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
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
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (토큰은 LF 기준)
    IF cnt(v_src, CHR(10) || 'PROCEDURE P_DMF0082_EXCEL_UPLOAD' || CHR(10)) <> 1
       OR cnt(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_EXCEL_UPLOAD_DATA') <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — P_DMF0082_EXCEL_UPLOAD 구간 경계를 찾지 못함. 원문 무변경');
    END IF;
    v_s := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_EXCEL_UPLOAD' || CHR(10));
    v_e := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_EXCEL_UPLOAD_DATA');
    v_span := SUBSTR(v_src, v_s, v_e - v_s);
"""


TAIL = """    v_new := SUBSTR(v_src, 1, v_s - 1) || v_span || SUBSTR(v_src, v_e);
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
"""
POST = ("SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL "
        "FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;\n")


def gen_apply(pairs, corp_ddl, total):
    return f"""-- 10_APPLY — [{MARK}] PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: Excel Upload SP P_DMF0082_EXCEL_UPLOAD 의 빈값 판정 정정 — NVL(x,'') = '' / NVL(x,'') <> '' / CASE WHEN x = ''
--       (Oracle 에서 항상 거짓) → IS NULL / IS NOT NULL. AS-IS 이식본 PKG_DMF0020.P_DMF0020_EXCEL_UPLOAD 와 같은 판정.
-- 효과: ① Model 빈칸 행 = 같은 Div/Team/End Customer/Project 의 Model 전체에 단가 반영(기존 LOC 단가 또는 RTF_SYS_RP 가 있는 Model)
--       ② 필수값 NULL · Invalid MODEL · 음수 · 0 · 통화 중복 검사가 실제로 동작 ③ 빈 월 = '0'(기존 단가 유지)
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 P_DMF0082_EXCEL_UPLOAD 구간 안의 토큰 {len(pairs)}종 {total}곳만 바꾼 뒤 CREATE OR REPLACE
--       (사내 전체본 복사 아님 — 다른 프로시저·다른 줄 무변경). 바꾼 자리마다 /*{TAG}*/ 표식.
-- 가드: 표식 존재 시 무동작 · 토큰 개수가 사내와 하나라도 다르면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 기준 원문 LAST_DDL {corp_ddl}. 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
{head(pairs)}    IF cnt(v_span, c_tag) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (표식 ' || cnt(v_span, c_tag) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_span, c_anc) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 설명 주석 앵커 매칭 ' || cnt(v_span, c_anc) || '건 (1 기대). 원문 무변경');
    END IF;
    FOR i IN 1 .. c_old.COUNT LOOP
        IF cnt(v_span, c_old(i)) <> c_cnt(i) THEN
            RAISE_APPLICATION_ERROR(-20003, '중단 — 토큰 [' || c_old(i) || '] ' || cnt(v_span, c_old(i)) || '곳 (사내 ' || c_cnt(i) || '곳). 00_PRECHECK 결과 회신. 원문 무변경');
        END IF;
    END LOOP;
    FOR i IN 1 .. c_old.COUNT LOOP
        v_span := REPLACE(v_span, c_old(i), c_new(i));
    END LOOP;
    v_span := REPLACE(v_span, c_anc, c_note || c_anc);
    IF cnt(v_span, c_tag) <> {total} + 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 표식 ' || cnt(v_span, c_tag) || '곳 ({total + 1} 기대). 원문 무변경');
    END IF;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 표식 {total}곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback(pairs, total):
    return f"""-- 99 ROLLBACK — [{MARK}] 역치환 (이 DB 의 USER_SOURCE 를 읽어 /*{TAG}*/ 자리를 원문으로 되돌린 뒤 CREATE OR REPLACE). 전체 F5, 멱등
-- 표식 없으면 무동작. ⚠ 되돌리면 Model 빈칸 업로드가 다시 저장 0건이 되고, 필수값·MODEL·음수·0·통화 검사가 다시 무효가 된다.
{head(pairs)}    IF cnt(v_span, c_tag) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 표식 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_span, c_note) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 설명 주석 매칭 ' || cnt(v_span, c_note) || '건 (1 기대). 원문 무변경');
    END IF;
    FOR i IN 1 .. c_new.COUNT LOOP
        IF cnt(v_span, c_new(i)) <> c_cnt(i) THEN
            RAISE_APPLICATION_ERROR(-20003, '중단 — 적용 토큰 [' || c_new(i) || '] ' || cnt(v_span, c_new(i)) || '곳 (' || c_cnt(i) || ' 기대). 원문 무변경');
        END IF;
    END LOOP;
    v_span := REPLACE(v_span, c_note, '');
    FOR i IN 1 .. c_new.COUNT LOOP
        v_span := REPLACE(v_span, c_new(i), c_old(i));
    END LOOP;
    IF cnt(v_span, c_tag) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 표식 ' || cnt(v_span, c_tag) || '곳 잔존. 원문 무변경');
    END IF;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 표식 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


TAG_COUNT_SQL = ("SUM((LENGTH(TEXT) - NVL(LENGTH(REPLACE(TEXT, '/*" + TAG + "')), 0)) / LENGTH('/*" + TAG + "'))")


def gen_precheck(pairs, total):
    rows = "\nUNION ALL ".join(
        f"SELECT {i:2d} NO, {lit(o)} TOKEN, {c} CORP_CNT FROM DUAL" for i, (o, _, c) in enumerate(pairs, 1))
    return f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL
-- * [L1] 표식(/*{TAG}*/) — 적용 전 0 (적용 뒤 {total + 1} = 치환 {total} + 설명 주석 1)
-- * [L2] 바꿀 토큰 {len(pairs)}종 — P_DMF0082_EXCEL_UPLOAD 구간 개수(THIS_DB)가 사내(CORP_CNT)와 전부 같아야 10 적용 가능
--        (L2 합계 JUDGE = PASS. 적용 뒤에는 THIS_DB 가 0 이 되므로 FAIL 로 보이는 것이 정상)
-- * [L3] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN TOKEN FORMAT A60
COLUMN JUDGE FORMAT A30
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 표식' CHK, NVL({TAG_COUNT_SQL}, 0) N,
       CASE WHEN NVL({TAG_COUNT_SQL}, 0) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%/*{TAG}%';
{{WITH_CNT}}
SELECT 'L2 토큰' CHK, C.NO, C.TOKEN, C.CORP_CNT, C.THIS_DB,
       CASE WHEN C.THIS_DB = C.CORP_CNT THEN 'OK' ELSE 'DIFF' END JUDGE
  FROM CNT C ORDER BY C.NO;
{{WITH_CNT}}
SELECT 'L2 합계' CHK, SUM(C.CORP_CNT) CORP_TOTAL, SUM(C.THIS_DB) THIS_TOTAL,
       SUM(CASE WHEN C.THIS_DB = C.CORP_CNT THEN 0 ELSE 1 END) DIFF_TOKENS,
       CASE WHEN SUM(CASE WHEN C.THIS_DB = C.CORP_CNT THEN 0 ELSE 1 END) = 0 THEN 'PASS → 10 적용 가능' ELSE 'FAIL — 회신' END JUDGE
  FROM CNT C;
SELECT 'L3 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
""".replace("{WITH_CNT}", with_cnt_block(rows))


def with_cnt_block(rows):
    return f"""WITH SRC AS (
    SELECT S.LINE, S.TEXT FROM USER_SOURCE S
     WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
       AND S.LINE >  (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)||' ') = 'PROCEDURE P_DMF0082_EXCEL_UPLOAD')
       AND S.LINE <  (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)||' ') LIKE 'PROCEDURE P!_DMF0082!_GET!_EXCEL!_UPLOAD!_DATA%' ESCAPE '!')
), TOK AS (
{rows}
)
, CNT AS (
SELECT T.NO, T.TOKEN, T.CORP_CNT,
       (SELECT NVL(SUM((LENGTH(S.TEXT) - NVL(LENGTH(REPLACE(S.TEXT, T.TOKEN)), 0)) / LENGTH(T.TOKEN)), 0) FROM SRC S) THIS_DB
  FROM TOK T
)"""


def gen_verify(total):
    return f"""-- 90 VERIFY — [{MARK}] 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 표식 {total + 1}곳(설명 주석 1 + 치환 {total}) · V2 VALID/오류 0/의존 INVALID 0 · V3 구 판정 잔존 0
-- * 화면 확인: Model 빈칸 행으로 Excel Upload → OK 저장 → Project 로 조회해 단가(LOC) 표시 확인
--   (대상 Model = 같은 Div/Team/End Customer/Project 에서 기존 LOC 단가 또는 Sales Plan RTF_SYS_RP 가 있는 Model — AS-IS 동일)
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN TXT FORMAT A150
COLUMN JUDGE FORMAT A30
SELECT 'V1 표식' CHK, NVL({TAG_COUNT_SQL}, 0) N,
       CASE WHEN NVL({TAG_COUNT_SQL}, 0) = {total + 1} THEN 'PASS' WHEN NVL({TAG_COUNT_SQL}, 0) = 0 THEN 'FAIL (미적용)' ELSE 'FAIL (개수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%/*{TAG}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 잔존' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END JUDGE
  FROM USER_SOURCE S
 WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
   AND S.LINE >  (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)||' ') = 'PROCEDURE P_DMF0082_EXCEL_UPLOAD')
   AND S.LINE <  (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)||' ') LIKE 'PROCEDURE P!_DMF0082!_GET!_EXCEL!_UPLOAD!_DATA%' ESCAPE '!')
   AND LTRIM(S.TEXT) NOT LIKE '--%'
   AND ( REGEXP_LIKE(S.TEXT, 'NVL\\([A-Z0-9_.]+,\\s*''''\\)\\s*(=|<>)\\s*''''')
      OR REGEXP_LIKE(S.TEXT, 'CASE WHEN ATTRIBUTE[0-9]+\\s*=\\s*'''' THEN') );
"""


def main():
    os.makedirs(CORP_DIR, exist_ok=True)
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','CON_NAME') FROM DUAL")
        host, pdb = cur.fetchone()
        body, last_ddl, status = fetch_body(cur)   # FRESH-GATE 기준본 = 방금 조회한 USER_SOURCE
    body = body.replace("\r\n", "\n")
    fetched = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    assert status == "VALID", status
    s, e = span_of(body)
    span = body[s:e]
    assert TAG not in span, "사내에 이미 적용됨 — 생성기 기준본은 미적용 원문이어야 한다"
    pairs = build_pairs(span)
    total = sum(c for _, _, c in pairs)
    tobe = patch(body, pairs)
    ts, te = span_of(tobe)
    assert tobe[ts:te].count("/*" + TAG) == total + 1, "표식 개수 != 치환 + 설명 주석 1 (PL/SQL -20004 가드와 동일 기준)"
    assert unpatch(tobe, pairs) == body, "왕복 불일치"
    stamp = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB={pdb}({host})\n"
    open(os.path.join(CORP_DIR, "PKG_DMF0082_BODY.ASIS.sql"), "w", encoding="utf-8", newline="\n").write(
        stamp + "CREATE OR REPLACE " + body + "\n/\n")
    open(os.path.join(CORP_DIR, "PKG_DMF0082_BODY.ASIS.raw"), "w", encoding="utf-8", newline="\n").write(body)
    open(os.path.join(CORP_DIR, "PKG_DMF0082_BODY.TOBE.raw"), "w", encoding="utf-8", newline="\n").write(tobe)
    files = {
        "00_PRECHECK_CLOUD.sql": gen_precheck(pairs, total),
        "10_APPLY_XLSNULL_PATCH.sql": stamp + gen_apply(pairs, last_ddl, total),
        "90_VERIFY.sql": gen_verify(total),
        "99_ROLLBACK_XLSNULL_PATCH.sql": stamp + gen_rollback(pairs, total),
    }
    for name, txt in files.items():
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")
    print(f"DB={pdb}({host}) LAST_DDL={last_ddl} FETCHED={fetched}")
    print(f"PAIRS={len(pairs)} TOTAL={total}")
    for o, n, c in sorted(pairs, key=lambda x: x[0]):
        print(f"  {c:2d}  {o}  ->  {n}")


if __name__ == "__main__":
    main()
