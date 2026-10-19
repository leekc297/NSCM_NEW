"""DMF0042_GAP257_BLANKFILL_CLOUD_20261015 패키지 생성기.

GAP 257 — DMF0042 저장 P_DMF0042_SAVE_DM_PLN_BP_FCST '2021.7.23 키 업데이트용 데이터 처리' 블록 미동작
  ① 빈값 검사 A.FCST_TYPE IS NULL OR A.INCOTERMS IS NULL → IN ('-','/')   (NOT NULL+DEFAULT ON NULL '/' 컬럼 · 과도기 '-'/'/' 공존)
  ② AS-IS 40 조건 복원  IF V_CNT_1 > 0 AND V_DIVISION_ID = '40'
  ③ 11키 조인 센티널 키 4종(DEPT_ID·END_CUSTOMER·BIZ_TYPE·ITEM_USE) '-'/'/' 동치 (count·MERGE 각 1)

방식: 클라우드는 자기 USER_SOURCE 를 패치한다(전체본 교체 금지). 구간 = ASCII 앵커 'INTO   V_CNT_1' ~ 'GOTO END_PKUPDATE;'
  적용·원복 모두 ASCII 토큰으로만 위치를 찾는다(한글 비교 없음). 삽입 문구(주석)는 사내 적용본 그대로.
FRESH-GATE: 사내 ZIOUI1 ALL_SOURCE 를 지금 재조회해 적용본(마커 5)인지 확인하고, 착수 기준본(00_BACKUP, 마커 0)과 함께
  '수정 전 → 적용 연산 == 적용본' · '적용본 → 원복 연산 == 수정 전' 이 문자 단위로 일치할 때만 SQL 을 쓴다.
"""
import os, sys, glob, datetime, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
OBJ = "PKG_DMF0042"
MARK = "[E20261015-GAP257]"
TAGPFX = "/* 2026.10.15 GAP257 " + MARK
A_START = "            INTO   V_CNT_1\n"
A_END = "GOTO END_PKUPDATE;"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
# FRESH-GATE: 생성 직전 DB 원문 재조회 (ALL_SOURCE + LAST_DDL_TIME)
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL"); host = cur.fetchone()[0]
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=OBJ)
last_ddl = cur.fetchone()[0]
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=OBJ)
APPLIED = "".join(r[0] for r in cur).replace("\r\n", "\n")
fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
bk = open(glob.glob(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0042_GAP257_20261015\00_BACKUP_*.sql")[0], encoding="utf-8").read()
PRE = bk.split("\n", 1)[1][len("CREATE OR REPLACE "):].rstrip("\n").removesuffix("\n/").replace("\r\n", "\n")
if not PRE.endswith("\n") and APPLIED.endswith("\n"):
    PRE += "\n"
assert APPLIED.count(MARK) == 5 and PRE.count(MARK) == 0, "FRESH-GATE 실패: 마커 수"

# ───────────── 연산 정의 (사내 적용본에서 문구를 그대로 추출)
def between(src, a, b):
    s = src.index(a); return src[s:src.index(b, s) + len(b)]

GT_OLD = "FROM   GT_SDPB2_BP_FCST_4"
GT_NEW = between(APPLIED, "FROM   (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CURRENCY, UNIT_ENERGY", "원본 : FROM GT_SDPB2_BP_FCST_4 */")
GT_NEW_HEAD = "FROM   (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CURRENCY, UNIT_ENERGY"
GT_NEW_TAIL_TOK = "FROM   GT_SDPB2_BP_FCST_4) "           # ASCII — 이 줄 끝(LF 앞)까지가 삽입 줄
W_OLD = "WHERE  A.FCST_TYPE IS NULL\n            OR     A.INCOTERMS IS NULL;"
W_ASC = "WHERE  A.FCST_TYPE IN ('-', '/')\n            OR     A.INCOTERMS IN ('-', '/');"
W_NEW = APPLIED[APPLIED.index(TAGPFX + " 빈값"):APPLIED.index(W_ASC) + len(W_ASC)]
I_OLD = "IF V_CNT_1 > 0 THEN"
I_ASC = "IF V_CNT_1 > 0 AND V_DIVISION_ID = '40' THEN"
I_NEW = APPLIED[APPLIED.index(TAGPFX + " AS-IS"):APPLIED.index(I_ASC) + len(I_ASC)]
M_OLD = "MERGE INTO DM_PLN_BP_FCST A"
M_NEW = APPLIED[APPLIED.index(TAGPFX + " ON"):APPLIED.index(M_OLD, APPLIED.index(TAGPFX + " ON")) + len(M_OLD)]
KEYS = ("DEPT_ID", "END_CUSTOMER", "BIZ_TYPE", "ITEM_USE")
DEC = [(f"A.{c} = B.{c}", f"DECODE(A.{c}, '-', '/', A.{c}) = B.{c}") for c in KEYS]
for t in (W_NEW, I_NEW, M_NEW):
    assert t.count(MARK) == 1 and len(t) < 400, t[:80]


def rng(src):
    s = src.index(A_START); assert src.count(A_START) == 1
    return s, src.index(A_END, s)


def op_tok(src, tok, new, n):
    lo, hi = rng(src)
    assert src.count(tok, lo, hi) == n, (tok[:50], src.count(tok, lo, hi), n)
    st = lo
    for _ in range(n):
        pos = src.index(tok, st)
        src = src[:pos] + new + src[pos + len(tok):]
        st = pos + len(new)          # 치환 결과 안의 토큰 재매칭 방지
    return src


def op_cut(src, start_tok, end_tok):
    """구간 안 start_tok 첫 위치 ~ end_tok 앞 삭제 (end_tok 보존)."""
    lo, hi = rng(src)
    s = src.index(start_tok, lo); e = src.index(end_tok, s)
    assert s < hi and e < hi and e - s < 400
    return src[:s] + src[e:]


def op_line_tail(src, head, tail_tok, new, n):
    """구간 안 head 시작 ~ tail_tok 가 든 줄 끝(LF 앞) 을 new 로 교체, n 건."""
    lo, hi = rng(src)
    assert src.count(head, lo, hi) == n
    for _ in range(n):
        lo, hi = rng(src)
        s = src.index(head, lo); t = src.index(tail_tok, s); e = src.index("\n", t)
        assert e - s < 600
        src = src[:s] + new + src[e:]
    return src


def apply_ops(src):
    src = op_tok(src, GT_OLD, GT_NEW, 2)
    for o, nw in DEC:
        src = op_tok(src, o, nw, 2)
    src = op_tok(src, W_OLD, W_NEW, 1)
    src = op_tok(src, I_OLD, I_NEW, 1)
    src = op_tok(src, M_OLD, M_NEW, 1)
    return src


def rollback_ops(src):
    src = op_line_tail(src, GT_NEW_HEAD, GT_NEW_TAIL_TOK, GT_OLD, 2)
    for o, nw in DEC:
        src = op_tok(src, nw, o, 2)
    src = op_cut(src, TAGPFX, W_ASC); src = op_tok(src, W_ASC, W_OLD, 1)
    src = op_cut(src, TAGPFX, I_ASC); src = op_tok(src, I_ASC, I_OLD, 1)
    src = op_cut(src, TAGPFX, M_OLD)
    lo, hi = rng(src); assert MARK not in src
    return src


assert apply_ops(PRE) == APPLIED, "시뮬레이터: 수정 전 → 적용 연산 ≠ 적용본"
assert rollback_ops(APPLIED) == PRE, "시뮬레이터: 적용본 → 원복 연산 ≠ 수정 전"
print("simulator OK (apply == applied · rollback == pre)")

# ───────────── PL/SQL 생성
def q(t):
    return t.replace("'", "''").replace("\n", "' || CHR(10) || '")


STAMP = f"-- SOURCE-FRESH: SCM_MGR.{OBJ} PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)"
DECL = f"""    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)   := '{MARK}';
    c_tagpfx CONSTANT VARCHAR2(100)  := '{q(TAGPFX)}';
    c_astart CONSTANT VARCHAR2(100)  := '{q(A_START)}';
    c_aend   CONSTANT VARCHAR2(100)  := '{q(A_END)}';
    c_gt_old CONSTANT VARCHAR2(100)  := '{q(GT_OLD)}';
    c_gt_new CONSTANT VARCHAR2(2000) := '{q(GT_NEW)}';
    c_gt_hd  CONSTANT VARCHAR2(200)  := '{q(GT_NEW_HEAD)}';
    c_gt_tl  CONSTANT VARCHAR2(100)  := '{q(GT_NEW_TAIL_TOK)}';
    c_w_old  CONSTANT VARCHAR2(300)  := '{q(W_OLD)}';
    c_w_asc  CONSTANT VARCHAR2(300)  := '{q(W_ASC)}';
    c_w_new  CONSTANT VARCHAR2(2000) := '{q(W_NEW)}';
    c_i_old  CONSTANT VARCHAR2(100)  := '{q(I_OLD)}';
    c_i_asc  CONSTANT VARCHAR2(100)  := '{q(I_ASC)}';
    c_i_new  CONSTANT VARCHAR2(2000) := '{q(I_NEW)}';
    c_m_old  CONSTANT VARCHAR2(100)  := '{q(M_OLD)}';
    c_m_new  CONSTANT VARCHAR2(2000) := '{q(M_NEW)}';
"""
HELPERS = """    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := p_from;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL OR pos >= p_to;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    -- 구간: 'INTO   V_CNT_1' (BODY 전체 1건) ~ 그 뒤 첫 'GOTO END_PKUPDATE;'
    PROCEDURE rng(o_lo OUT PLS_INTEGER, o_hi OUT PLS_INTEGER) IS
    BEGIN
        IF cnt(v_new, c_astart, 1, DBMS_LOB.GETLENGTH(v_new) + 1) <> 1 THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — 시작 앵커(INTO V_CNT_1) 1건 아님. 00_PRECHECK 회신. 원문 무변경');
        END IF;
        o_lo := DBMS_LOB.INSTR(v_new, c_astart);
        o_hi := DBMS_LOB.INSTR(v_new, c_aend, o_lo);
        IF NOT (o_hi > o_lo AND o_hi - o_lo < 8000) THEN RAISE_APPLICATION_ERROR(-20002, '중단 — 구간 끝(GOTO END_PKUPDATE) 확인 불가. 원문 무변경'); END IF;
    END;
    PROCEDURE op_tok(p_name VARCHAR2, p_tok VARCHAR2, p_new VARCHAR2, p_n PLS_INTEGER) IS
        lo PLS_INTEGER; hi PLS_INTEGER; pos PLS_INTEGER; st PLS_INTEGER;
    BEGIN
        rng(lo, hi);
        IF cnt(v_new, p_tok, lo, hi) <> p_n THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 대상 ' || cnt(v_new, p_tok, lo, hi) || '건 (' || p_n || ' 기대). 00_PRECHECK 회신. 원문 무변경');
        END IF;
        st := lo;
        FOR i IN 1 .. p_n LOOP
            pos := DBMS_LOB.INSTR(v_new, p_tok, st);
            v_new := SUBSTR(v_new, 1, pos - 1) || p_new || SUBSTR(v_new, pos + LENGTH(p_tok));
            st := pos + LENGTH(p_new);   -- 치환 결과 안의 토큰 재매칭 방지
        END LOOP;
    END;
    PROCEDURE op_cut(p_name VARCHAR2, p_start VARCHAR2, p_end VARCHAR2) IS
        lo PLS_INTEGER; hi PLS_INTEGER; s PLS_INTEGER; e PLS_INTEGER;
    BEGIN
        rng(lo, hi);
        s := DBMS_LOB.INSTR(v_new, p_start, lo);
        e := CASE WHEN s > 0 THEN DBMS_LOB.INSTR(v_new, p_end, s) ELSE 0 END;
        IF NOT (s > 0 AND s < hi AND e > s AND e < hi AND e - s < 400) THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 주석 위치 확인 불가. 원문 무변경');
        END IF;
        v_new := SUBSTR(v_new, 1, s - 1) || SUBSTR(v_new, e);
    END;
    PROCEDURE op_line_tail(p_name VARCHAR2, p_head VARCHAR2, p_tail VARCHAR2, p_new VARCHAR2, p_n PLS_INTEGER) IS
        lo PLS_INTEGER; hi PLS_INTEGER; s PLS_INTEGER; t PLS_INTEGER; e PLS_INTEGER;
    BEGIN
        rng(lo, hi);
        IF cnt(v_new, p_head, lo, hi) <> p_n THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 대상 ' || cnt(v_new, p_head, lo, hi) || '건 (' || p_n || ' 기대). 원문 무변경');
        END IF;
        FOR i IN 1 .. p_n LOOP
            rng(lo, hi);
            s := DBMS_LOB.INSTR(v_new, p_head, lo);
            t := DBMS_LOB.INSTR(v_new, p_tail, s);
            e := DBMS_LOB.INSTR(v_new, CHR(10), t);
            IF NOT (t > s AND e > t AND e - s < 600) THEN RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 줄 끝 확인 불가. 원문 무변경'); END IF;
            v_new := SUBSTR(v_new, 1, s - 1) || p_new || SUBSTR(v_new, e);
        END LOOP;
    END;"""
LOAD = f"""    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;"""
COMPILE = f"""    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = '{OBJ}' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;"""
POST = f"SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='{OBJ}' ORDER BY OBJECT_TYPE;"
MCOUNT = "(DBMS_LOB.GETLENGTH(v_new) - DBMS_LOB.GETLENGTH(REPLACE(v_new, c_mark, ''))) / LENGTH(c_mark)"

APPLY = f"""{STAMP}
-- 10_APPLY — {MARK} GAP 257 PKG_DMF0042 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 저장 P_DMF0042_SAVE_DM_PLN_BP_FCST 의 '2021.7.23 키 업데이트용 데이터 처리' 블록 — 같은 키로 새 행을 저장하면
--       FCST Type·Incoterms 가 빈 옛 행을 채우고 끝(AS-IS DMF0042_SAVE_DM_PLN_BP_FCST). 지금은 조건이 항상 거짓이라 미동작.
--   ① 빈값 검사 IS NULL → IN ('-','/')  (두 컬럼 NOT NULL + DEFAULT ON NULL '/' · 이관 빈값 '-' 와 신규 빈값 '/' 과도기 공존)
--   ② AS-IS 의 40 조건 복원 (IF ... AND V_DIVISION_ID = '40')
--   ③ 11키 조인 센티널 키 4종(DEPT_ID·END_CUSTOMER·BIZ_TYPE·ITEM_USE) '-'/'/' 동치 — 40 원장 '-' · GT 정규화 '/'
-- 범위: 저장 SP 블록 1곳만. 원장 데이터 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 토큰으로 위치를 찾고 연산 7개를 순서대로 적용 → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 연산마다 대상 건수가 기대와 다르면 중단(원문 무변경) · 마커 5곳 확인 · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL {last_ddl}). 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}{HELPERS}
BEGIN
{LOAD}
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    op_tok('③ GT 센티널 키 정규화', c_gt_old, c_gt_new, 2);
{chr(10).join(f"    op_tok('③ {c} 동치', '{q(o)}', '{q(nw)}', 2);" for (o, nw), c in zip(DEC, KEYS))}
    op_tok('① 빈값 검사', c_w_old, c_w_new, 1);
    op_tok('② 40 조건', c_i_old, c_i_new, 1);
    op_tok('③ MERGE 주석', c_m_old, c_m_new, 1);
    IF {MCOUNT} <> 5 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 마커 수 불일치(5 기대). 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('APPLIED — {OBJ} BODY ' || v_st || ' · 마커 5곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — {MARK} GAP 257 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 연산을 역순으로 되돌린다 — 위치는 ASCII 마커·토큰으로만 찾는다(한글 비교 없음).
-- 가드: 마커 없음 → 무동작 · 대상 건수 이상 → 중단(원문 무변경) · 컴파일 오류 → 원문 자동 복원
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}{HELPERS}
BEGIN
{LOAD}
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    op_line_tail('③ GT 센티널 키 정규화', c_gt_hd, c_gt_tl, c_gt_old, 2);
{chr(10).join(f"    op_tok('③ {c} 동치', '{q(nw)}', '{q(o)}', 2);" for (o, nw), c in zip(DEC, KEYS))}
    op_cut('① 빈값 검사 주석', c_tagpfx, c_w_asc);  op_tok('① 빈값 검사', c_w_asc, c_w_old, 1);
    op_cut('② 40 조건 주석', c_tagpfx, c_i_asc);    op_tok('② 40 조건', c_i_asc, c_i_old, 1);
    op_cut('③ MERGE 주석', c_tagpfx, c_m_old);
    IF DBMS_LOB.INSTR(v_new, c_mark) > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치(마커 잔존). 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — {OBJ} BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

lq = lambda t: t.replace("'", "''")
PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). {MARK} GAP 257 적용 전 상태
-- * [L0] 접속 DB · {OBJ} 상태·LAST_DDL
-- * [L1] 연산 앵커·대상 줄 — 전부 PASS 기대 (FAIL 이면 10 실행 금지, 결과 회신)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 원장 DM_PLN_BP_FCST 의 FCST_TYPE·INCOTERMS 빈값('-'/'/') 분포 (참고)
-- * [L4] 지금 {OBJ} 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A40
COLUMN JUDGE FORMAT A50
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{OBJ}' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 대상' CHK, K.KIND, COUNT(S.LINE) N, K.EXPECT, LISTAGG(S.LINE, ',') WITHIN GROUP (ORDER BY S.LINE) LINES,
       CASE WHEN COUNT(S.LINE) = K.EXPECT THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END JUDGE
  FROM ( SELECT '시작 앵커 INTO V_CNT_1' KIND, '{lq(A_START.rstrip(chr(10)))}' TXT, 1 EXPECT FROM DUAL UNION ALL
         SELECT '① WHERE FCST_TYPE IS NULL', '            WHERE  A.FCST_TYPE IS NULL', 1 FROM DUAL UNION ALL
         SELECT '① OR INCOTERMS IS NULL', '            OR     A.INCOTERMS IS NULL;', 1 FROM DUAL UNION ALL
         SELECT '② IF V_CNT_1 > 0 THEN', '            IF V_CNT_1 > 0 THEN', 1 FROM DUAL UNION ALL
         SELECT '구간 끝 GOTO END_PKUPDATE', '                GOTO END_PKUPDATE;', 1 FROM DUAL ) K
  LEFT JOIN USER_SOURCE S
    ON S.NAME = '{OBJ}' AND S.TYPE = 'PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = K.TXT
 GROUP BY K.KIND, K.EXPECT
 ORDER BY K.KIND;
SELECT 'L2 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN 'PASS (미적용)' ELSE '이미 적용됨 — 10 은 SKIP 됨' END JUDGE
  FROM USER_SOURCE WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY' AND INSTR(TEXT, '{MARK}') > 0;
SELECT 'L3 원장' CHK, DIVISION_ID, FCST_TYPE, INCOTERMS, COUNT(*) N, MIN(YYYYMM) MIN_YM, MAX(YYYYMM) MAX_YM
  FROM DM_PLN_BP_FCST WHERE FCST_TYPE IN ('-','/') OR INCOTERMS IN ('-','/')
 GROUP BY DIVISION_ID, FCST_TYPE, INCOTERMS ORDER BY 2, 3, 4;
SELECT 'L4 세션' CHK, COUNT(*) N FROM V$ACCESS WHERE OWNER = 'SCM_MGR' AND OBJECT = '{OBJ}';
"""

VERIFY = f"""-- 90_VERIFY — 조회 전용 (전체 F5, 값 입력 없음). {MARK} GAP 257 적용 뒤 확인
-- * [V1] 마커 줄 5 · [V2] BODY VALID · 오류 0 · [V3] 정정 줄 4종 존재
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN JUDGE FORMAT A40
SELECT 'V1 마커' CHK, COUNT(*) N, LISTAGG(LINE, ',') WITHIN GROUP (ORDER BY LINE) LINES,
       CASE WHEN COUNT(*) = 5 THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM USER_SOURCE WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY' AND INSTR(TEXT, '{MARK}') > 0;
SELECT 'V2 상태' CHK, O.STATUS, (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME = O.OBJECT_NAME AND E.TYPE = O.OBJECT_TYPE) ERRS,
       TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       CASE WHEN O.STATUS = 'VALID' AND (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME = O.OBJECT_NAME AND E.TYPE = O.OBJECT_TYPE) = 0 THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME = '{OBJ}' AND O.OBJECT_TYPE = 'PACKAGE BODY';
SELECT 'V3 줄' CHK, K.KIND, COUNT(S.LINE) N, K.EXPECT, CASE WHEN COUNT(S.LINE) = K.EXPECT THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM ( SELECT '① WHERE FCST_TYPE IN' KIND, '{lq("            WHERE  A.FCST_TYPE IN ('-', '/')")}' TXT, 1 EXPECT FROM DUAL UNION ALL
         SELECT '① OR INCOTERMS IN', '{lq("            OR     A.INCOTERMS IN ('-', '/');")}', 1 FROM DUAL UNION ALL
         SELECT '② IF ... 40', '{lq("            IF V_CNT_1 > 0 AND V_DIVISION_ID = '40' THEN")}', 1 FROM DUAL UNION ALL
         SELECT '③ DEPT_ID 동치(count)', '{lq("            AND    DECODE(A.DEPT_ID, '-', '/', A.DEPT_ID) = B.DEPT_ID")}', 1 FROM DUAL ) K
  LEFT JOIN USER_SOURCE S
    ON S.NAME = '{OBJ}' AND S.TYPE = 'PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = K.TXT
 GROUP BY K.KIND, K.EXPECT ORDER BY K.KIND;
"""

os.makedirs(OUT, exist_ok=True)
files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_GAP257_PATCH.sql": APPLY, "90_VERIFY.sql": VERIFY, "99_ROLLBACK_GAP257_PATCH.sql": ROLLBACK}
for n, t in files.items():
    open(os.path.join(OUT, n), "w", encoding="utf-8", newline="\n").write(t)
md5 = lambda s: hashlib.md5(s.encode("utf-8")).hexdigest()
open(os.path.join(HERE, "_md5_corporate_applied.txt"), "w", encoding="utf-8").write(
    f"HOST={host} LAST_DDL={last_ddl} FETCHED={fetched}\napplied md5={md5(APPLIED)}\npre     md5={md5(PRE)}\n")
print("written", list(files), "HOST", host, "LAST_DDL", last_ddl)
