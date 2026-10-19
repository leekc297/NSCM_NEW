"""DMF0082_GAP446_PASTVER_CLOUD_20261015 패키지 생성기.

GAP 446 — DMF0082 과거 버전(SF/MF/SP) 조회 시 수요 행이 빠지거나 다른 행이 섞임. AS-IS DMF0082_GET_MAIN_DATA 실행 문장 기준 5종:
  C1 T_VERSION NOW_YYYYMMDD = FN_NEXT_DAY(버전일,'MON') - 7      C2 MF 계획(81·40) >= NOW      C3 MF 판가(81·40) >= NOW
  C4 SF 계획 = 확정 수요 컷오프(CFM_C / 81 MKT_FCST_C) + NOW (구: AS-IS 주석 구간 실적 테이블)   C5 SP Unit Price 뒤 실적 3종 삭제

방식: 클라우드는 자기 USER_SOURCE 를 패치한다. 모든 위치는 ASCII 토큰으로 찾고(한글 비교 없음) 연산 목록을 순서대로 적용한다.
FRESH-GATE: 사내 ZIOUI1 ALL_SOURCE 를 지금 재조회해 적용본인지 확인하고, 착수 기준본(수정 전)과 함께 연산 목록을
  Python 시뮬레이터로 돌려 '수정 전 → 적용 연산 → 적용본' · '적용본 → 원복 연산 → 수정 전' 이 문자 단위로 일치할 때만 SQL 을 쓴다.
"""
import os, sys, datetime, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
PRE_FILE = r"C:\Users\ejene\AppData\Local\Temp\claude\c--Projects-NSCM\b863378f-208f-46a1-9563-63278599cad9\scratchpad\gap446\body_fresh.sql"
MARK = "GAP446 2026-10-15"
P_FROM = "PROCEDURE P_DMF0082_GET_MAIN_DATA"
P_TO = "PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT"
END_DIV = "        END IF;  --[DIV81]\n"
BR_MF = "    IF p_version_type LIKE '%MF%' THEN\n"
BR_SF = "    IF p_version_type LIKE '%SF%' THEN\n"

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
assert APPLIED.count(MARK) == 9 and PRE.count(MARK) == 0, "FRESH-GATE 실패: 마커 수"

# ───────────── 블록 원문 추출 (사내 원문에서 그대로)
def seg_after(src, tok_start, tok_end):
    s = src.index(tok_start) + len(tok_start); e = src.index(tok_end, s); return src[s:e]

PP_PREFIX = "        -- MKT_FCST_PP SF "                                   # ASCII 접두
OLD_SF = seg_after(PRE, BR_SF, PP_PREFIX)
NEW_SF = seg_after(APPLIED, BR_SF, PP_PREFIX)
assert OLD_SF.count("INSERT INTO") == 1 and "SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A" in OLD_SF
assert ("[" + MARK + "] SF") in NEW_SF and NEW_SF.count("INSERT INTO") == 2

C1_OLD = "             , TO_CHAR(TO_DATE(B.YYYYMMDD, 'YYYYMMDD') - 7, 'YYYYMMDD') AS NOW_YYYYMMDD"
C1_NEW_PREFIX = "             , TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(B.YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD') AS NOW_YYYYMMDD  --[" + MARK + "]"
C1_NEW_LINE = APPLIED[APPLIED.index(C1_NEW_PREFIX):APPLIED.index("\n", APPLIED.index(C1_NEW_PREFIX)) + 1]
C2_TOK = "        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD\n        AND    A.QTY <> 0;\n"
C2_LINE_PREFIX = "        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD  --[" + MARK + "]"
C2_LINE = APPLIED[APPLIED.index(C2_LINE_PREFIX):APPLIED.index("\n", APPLIED.index(C2_LINE_PREFIX)) + 1]
C3_TOK = "        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;  -- [DATE ROOT FIX 2026-07-12]"
C3_TOK_NOSEMI = C3_TOK.replace("V_TO_YYYYMMDD;", "V_TO_YYYYMMDD", 1)
C3_LINE_PREFIX = "        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD;  --[" + MARK + "]"
C3_LINE = APPLIED[APPLIED.index(C3_LINE_PREFIX):APPLIED.index("\n", APPLIED.index(C3_LINE_PREFIX)) + 1]
C5_TOK = "            END) IS NOT NULL;\n\n    END IF;\n"
C5_START = "\n    /* [" + MARK + "] SP"
C5_END = "     WHERE A.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC', 'RTF_SYS_RP');\n"
C5_DEL = APPLIED[APPLIED.index(C5_START):APPLIED.index(C5_END) + len(C5_END)]

# ───────────── 연산 정의 (PL/SQL 과 같은 의미의 Python 시뮬레이터)
#   범위 = (lo_tok, hi_tok): lo = GET_MAIN_DATA 시작 뒤 lo_tok 첫 위치, hi = lo 뒤 hi_tok 첫 위치. None=GET_MAIN_DATA 전체.
RANGE_ALL = (None, None)
RANGE_MF_PLAN = (BR_MF, END_DIV)
RANGE_MF = (BR_MF, BR_SF)


def rng(src, r):
    m0 = src.index("\n" + P_FROM + "\n"); m1 = src.index("\n" + P_TO)
    if r[0] is None:
        return m0, m1
    lo = src.index(r[0], m0); hi = src.index(r[1], lo + len(r[0]))
    return lo, hi


def op_tok(src, tok, new, r, n):
    """범위 안 tok 정확히 n건 → 앞에서부터 new 로 치환."""
    lo, hi = rng(src, r)
    assert src.count(tok, lo, hi) == n, (tok[:50], src.count(tok, lo, hi), n)
    for _ in range(n):
        lo, hi = rng(src, r)
        pos = src.index(tok, lo)
        src = src[:pos] + new + src[pos + len(tok):]
    return src


def op_line(src, prefix, new, r, n):
    """범위 안 prefix 로 시작하는 줄(끝 LF 포함) n건 → new 로 치환(new='' 이면 줄 삭제)."""
    lo, hi = rng(src, r)
    assert src.count("\n" + prefix, lo - 1, hi) == n, (prefix[:50], n)
    for _ in range(n):
        lo, hi = rng(src, r)
        pos = src.index("\n" + prefix, lo - 1) + 1
        e = src.index("\n", pos) + 1
        src = src[:pos] + new + src[e:]
    return src


def op_after_line(src, tok, ins, r, n):
    """범위 안 tok 이 든 줄 n건 각각: 그 줄 끝 LF 뒤에 ins 삽입."""
    lo, hi = rng(src, r)
    assert src.count(tok, lo, hi) == n
    start = lo
    for _ in range(n):
        pos = src.index(tok, start)
        e = src.index("\n", pos) + 1
        src = src[:e] + ins + src[e:]
        start = e + len(ins)
    return src


def op_span(src, start_tok, end_tok, new, guard):
    """GET_MAIN_DATA 안 start_tok 끝 ~ end_tok 앞 구간(1건)을 new 로 교체. guard 가 구간에 있어야 함."""
    m0, m1 = rng(src, RANGE_ALL)
    assert src.count(start_tok, m0, m1) == 1
    s = src.index(start_tok, m0) + len(start_tok); e = src.index(end_tok, s)
    assert guard in src[s:e] and e < m1
    return src[:s] + new + src[e:]


def op_cut(src, start_tok, end_tok):
    """GET_MAIN_DATA 안 start_tok 시작 ~ end_tok 끝 구간(1건) 삭제."""
    m0, m1 = rng(src, RANGE_ALL)
    assert src.count(start_tok, m0, m1) == 1
    s = src.index(start_tok, m0); e = src.index(end_tok, s) + len(end_tok)
    assert e - s < 2000
    return src[:s] + src[e:]


def apply_ops(src):
    src = op_line(src, C1_OLD, C1_NEW_LINE, RANGE_ALL, 1)                                    # C1
    src = op_tok(src, C2_TOK, C2_TOK.replace("        AND    A.QTY <> 0;\n", C2_LINE + "        AND    A.QTY <> 0;\n"), RANGE_MF_PLAN, 2)  # C2
    src = op_tok(src, C3_TOK, C3_TOK_NOSEMI, RANGE_MF, 2)                                     # C3-a ';' 이동
    src = op_after_line(src, C3_TOK_NOSEMI, C3_LINE, RANGE_MF, 2)                             # C3-b NOW 줄
    src = op_span(src, BR_SF, PP_PREFIX, NEW_SF, "SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A")         # C4
    src = op_tok(src, C5_TOK, "            END) IS NOT NULL;\n" + C5_DEL + "\n    END IF;\n", RANGE_ALL, 1)  # C5
    return src


def rollback_ops(src):
    src = op_cut(src, C5_START, C5_END)                                                        # C5
    src = op_span(src, BR_SF, PP_PREFIX, OLD_SF, "[" + MARK + "] SF")                          # C4
    src = op_line(src, C3_LINE_PREFIX, "", RANGE_MF, 2)                                        # C3-b
    src = op_tok(src, C3_TOK_NOSEMI, C3_TOK, RANGE_MF, 2)                                      # C3-a
    src = op_line(src, C2_LINE_PREFIX, "", RANGE_MF_PLAN, 2)                                   # C2
    src = op_line(src, C1_NEW_PREFIX, C1_OLD + "\n", RANGE_ALL, 1)                             # C1
    return src


assert apply_ops(PRE) == APPLIED, "시뮬레이터: 수정 전 → 적용 연산 ≠ 적용본"
assert rollback_ops(APPLIED) == PRE, "시뮬레이터: 적용본 → 원복 연산 ≠ 수정 전"
print("simulator OK (apply == applied · rollback == pre)")

# ───────────── PL/SQL 생성
def chunks(text, n=40):
    lines = text.split("\n")
    out = []
    for i in range(0, len(lines), n):
        part = lines[i:i + n]
        last = i + n >= len(lines)
        out.append(" || ".join(("'" + ln.replace("'", "''") + "'" + ("" if (last and j == len(part) - 1) else " || CHR(10)"))
                               for j, ln in enumerate(part)).replace(" || CHR(10) || ", " || CHR(10)\n            || "))
    return out


def clob_build(var, text):
    s = f"    DBMS_LOB.CREATETEMPORARY({var}, TRUE);\n"
    for ch in chunks(text):
        if ch.strip() in ("''",):
            continue
        s += f"    DBMS_LOB.APPEND({var}, TO_CLOB(\n            {ch}));\n"
    return s


def q(t):
    return t.replace("'", "''").replace("\n", "' || CHR(10) || '")


STAMP = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)"
HELPERS = f"""    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := p_from;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL OR pos >= p_to;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    -- 범위: p_lo_tok NULL = GET_MAIN_DATA 전체 / 아니면 GET_MAIN_DATA 시작 뒤 p_lo_tok ~ 그 뒤 p_hi_tok
    PROCEDURE rng(p_lo_tok VARCHAR2, p_hi_tok VARCHAR2, o_lo OUT PLS_INTEGER, o_hi OUT PLS_INTEGER) IS
        m0 PLS_INTEGER; m1 PLS_INTEGER;
    BEGIN
        m0 := DBMS_LOB.INSTR(v_new, CHR(10) || '{P_FROM}' || CHR(10));
        m1 := DBMS_LOB.INSTR(v_new, CHR(10) || '{P_TO}');
        IF NOT (m0 > 0 AND m0 < m1) THEN RAISE_APPLICATION_ERROR(-20002, '중단 — GET_MAIN_DATA 위치 확인 불가. 원문 무변경'); END IF;
        IF p_lo_tok IS NULL THEN o_lo := m0; o_hi := m1; RETURN; END IF;
        o_lo := DBMS_LOB.INSTR(v_new, p_lo_tok, m0);
        o_hi := CASE WHEN o_lo > 0 THEN DBMS_LOB.INSTR(v_new, p_hi_tok, o_lo + LENGTH(p_lo_tok)) ELSE 0 END;
        IF NOT (o_lo > m0 AND o_hi > o_lo AND o_hi < m1) THEN RAISE_APPLICATION_ERROR(-20002, '중단 — 분기 범위 확인 불가. 00_PRECHECK 회신. 원문 무변경'); END IF;
    END;
    PROCEDURE op_tok(p_name VARCHAR2, p_tok VARCHAR2, p_new CLOB, p_lo_tok VARCHAR2, p_hi_tok VARCHAR2, p_n PLS_INTEGER) IS
        lo PLS_INTEGER; hi PLS_INTEGER; pos PLS_INTEGER;
    BEGIN
        rng(p_lo_tok, p_hi_tok, lo, hi);
        IF cnt(v_new, p_tok, lo, hi) <> p_n THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 대상 ' || cnt(v_new, p_tok, lo, hi) || '건 (' || p_n || ' 기대). 00_PRECHECK 회신. 원문 무변경');
        END IF;
        FOR i IN 1 .. p_n LOOP
            rng(p_lo_tok, p_hi_tok, lo, hi);
            pos := DBMS_LOB.INSTR(v_new, p_tok, lo);
            v_new := SUBSTR(v_new, 1, pos - 1) || p_new || SUBSTR(v_new, pos + LENGTH(p_tok));
        END LOOP;
    END;
    PROCEDURE op_line(p_name VARCHAR2, p_prefix VARCHAR2, p_new CLOB, p_lo_tok VARCHAR2, p_hi_tok VARCHAR2, p_n PLS_INTEGER) IS
        lo PLS_INTEGER; hi PLS_INTEGER; pos PLS_INTEGER; e PLS_INTEGER;
    BEGIN
        rng(p_lo_tok, p_hi_tok, lo, hi);
        IF cnt(v_new, CHR(10) || p_prefix, lo - 1, hi) <> p_n THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 대상 줄 ' || cnt(v_new, CHR(10) || p_prefix, lo - 1, hi) || '건 (' || p_n || ' 기대). 원문 무변경');
        END IF;
        FOR i IN 1 .. p_n LOOP
            rng(p_lo_tok, p_hi_tok, lo, hi);
            pos := DBMS_LOB.INSTR(v_new, CHR(10) || p_prefix, lo - 1) + 1;
            e   := DBMS_LOB.INSTR(v_new, CHR(10), pos) + 1;
            v_new := SUBSTR(v_new, 1, pos - 1) || p_new || SUBSTR(v_new, e);
        END LOOP;
    END;
    PROCEDURE op_after_line(p_name VARCHAR2, p_tok VARCHAR2, p_ins VARCHAR2, p_lo_tok VARCHAR2, p_hi_tok VARCHAR2, p_n PLS_INTEGER) IS
        lo PLS_INTEGER; hi PLS_INTEGER; pos PLS_INTEGER; e PLS_INTEGER; st PLS_INTEGER;
    BEGIN
        rng(p_lo_tok, p_hi_tok, lo, hi);
        IF cnt(v_new, p_tok, lo, hi) <> p_n THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 대상 ' || cnt(v_new, p_tok, lo, hi) || '건 (' || p_n || ' 기대). 원문 무변경');
        END IF;
        st := lo;
        FOR i IN 1 .. p_n LOOP
            pos := DBMS_LOB.INSTR(v_new, p_tok, st);
            e   := DBMS_LOB.INSTR(v_new, CHR(10), pos) + 1;
            v_new := SUBSTR(v_new, 1, e - 1) || p_ins || SUBSTR(v_new, e);
            st := e + LENGTH(p_ins);
        END LOOP;
    END;
    PROCEDURE op_span(p_name VARCHAR2, p_start VARCHAR2, p_end VARCHAR2, p_new CLOB, p_guard VARCHAR2) IS
        lo PLS_INTEGER; hi PLS_INTEGER; s PLS_INTEGER; e PLS_INTEGER;
    BEGIN
        rng(NULL, NULL, lo, hi);
        IF cnt(v_new, p_start, lo, hi) <> 1 THEN RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 시작 위치 1건 아님. 원문 무변경'); END IF;
        s := DBMS_LOB.INSTR(v_new, p_start, lo) + LENGTH(p_start);
        e := DBMS_LOB.INSTR(v_new, p_end, s);
        IF e = 0 OR e > hi OR cnt(v_new, p_guard, s, e) <> 1 THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 구간 확인 불가(표지 없음). 00_PRECHECK 회신. 원문 무변경');
        END IF;
        v_new := SUBSTR(v_new, 1, s - 1) || p_new || SUBSTR(v_new, e);
    END;
    PROCEDURE op_cut(p_name VARCHAR2, p_start VARCHAR2, p_end VARCHAR2) IS
        lo PLS_INTEGER; hi PLS_INTEGER; s PLS_INTEGER; e PLS_INTEGER;
    BEGIN
        rng(NULL, NULL, lo, hi);
        IF cnt(v_new, p_start, lo, hi) <> 1 THEN RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 블록 1건 아님. 원문 무변경'); END IF;
        s := DBMS_LOB.INSTR(v_new, p_start, lo);
        e := DBMS_LOB.INSTR(v_new, p_end, s);
        IF e = 0 OR e - s > 2000 THEN RAISE_APPLICATION_ERROR(-20002, '중단 — ' || p_name || ' 블록 끝 위치 이상. 원문 무변경'); END IF;
        v_new := SUBSTR(v_new, 1, s - 1) || SUBSTR(v_new, e + LENGTH(p_end));
    END;"""
DECL = f"""    v_src    CLOB;
    v_new    CLOB;
    v_blk    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)  := '{MARK}';
    c_enddiv CONSTANT VARCHAR2(100) := '{q(END_DIV)}';
    c_br_mf  CONSTANT VARCHAR2(100) := '{q(BR_MF)}';
    c_br_sf  CONSTANT VARCHAR2(100) := '{q(BR_SF)}';
    c_pp     CONSTANT VARCHAR2(100) := '{q(PP_PREFIX)}';
    c1_old   CONSTANT VARCHAR2(300) := '{q(C1_OLD)}';
    c1_pfx   CONSTANT VARCHAR2(300) := '{q(C1_NEW_PREFIX)}';
    c1_line  CONSTANT VARCHAR2(1000) := '{q(C1_NEW_LINE)}';
    c2_tok   CONSTANT VARCHAR2(300) := '{q(C2_TOK)}';
    c2_pfx   CONSTANT VARCHAR2(300) := '{q(C2_LINE_PREFIX)}';
    c2_line  CONSTANT VARCHAR2(1000) := '{q(C2_LINE)}';
    c3_tok   CONSTANT VARCHAR2(300) := '{q(C3_TOK)}';
    c3_tok2  CONSTANT VARCHAR2(300) := '{q(C3_TOK_NOSEMI)}';
    c3_pfx   CONSTANT VARCHAR2(300) := '{q(C3_LINE_PREFIX)}';
    c3_line  CONSTANT VARCHAR2(1000) := '{q(C3_LINE)}';
    c5_tok   CONSTANT VARCHAR2(300) := '{q(C5_TOK)}';
    c5_start CONSTANT VARCHAR2(100) := '{q(C5_START)}';
    c5_end   CONSTANT VARCHAR2(300) := '{q(C5_END)}';
    c5_del   CONSTANT VARCHAR2(2000) := '{q(C5_DEL)}';
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
-- 10_APPLY — [{MARK}] GAP 446 PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 조회 P_DMF0082_GET_MAIN_DATA 의 과거 버전(SF/MF/SP) 조회를 AS-IS DMF0082_GET_MAIN_DATA 실행 문장과 같게 5종 고친다.
--   C1 버전 기준일 NOW_YYYYMMDD = 버전일이 속한 주 월요일 (AS-IS L256 / 구: 버전일 - 7)
--   C2 MF 계획(81·40) 에 '버전 주 월요일 이후' 조건 (AS-IS L2775)        C3 MF 판가(81·40) 에 같은 조건 (AS-IS L3415)
--   C4 SF 계획 = 확정 수요 컷오프(40 DM_PLN_CFM_MKT_DEMAND_PLAN_C / 81·82 DM_PLN_MKT_FCST_C) + 같은 조건 (AS-IS L4262~4369)
--      — 구: AS-IS 에서 주석 처리된 실적 테이블(DM_PLN_MKT_FCST_RESULT_C)을 읽어 계획구간 MKT FCST·SCM FCST·RTF 가 빠짐
--   C5 SP 버전 Unit Price 계산 뒤 실적 3종(MKT_AMT_KRW/LOC · RTF_SYS_RP) 삭제 (AS-IS L4235~4238 / 구: RTF[R+P] 행이 화면에 남음)
-- 범위: 조회 SP 만. 저장 · 원장 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 토큰으로 위치를 찾고 연산 7개를 순서대로 적용 → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 연산마다 대상 건수가 기대와 다르면 중단(원문 무변경) · 마커 9곳 확인 · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL {last_ddl}) — 측정은 00_README.md 참조.
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
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
{clob_build('v_blk', NEW_SF)}    -- C1
    op_line('C1 NOW 산식', c1_old, c1_line, NULL, NULL, 1);
    -- C2 MF 계획 (MF 분기 시작 ~ 첫 END IF --[DIV81])
    op_tok('C2 MF 계획', c2_tok, REPLACE(c2_tok, '        AND    A.QTY <> 0;' || CHR(10), c2_line || '        AND    A.QTY <> 0;' || CHR(10)), c_br_mf, c_enddiv, 2);
    -- C3 MF 판가 (MF 분기 ~ SF 분기): 세미콜론을 다음 줄로 옮기고 NOW 줄 삽입
    op_tok('C3 MF 판가', c3_tok, c3_tok2, c_br_mf, c_br_sf, 2);
    op_after_line('C3 MF 판가 NOW', c3_tok2, c3_line, c_br_mf, c_br_sf, 2);
    -- C4 SF 계획 블록 교체 (SF 분기 시작 줄 ~ MKT_FCST_PP SF 블록 앞)
    op_span('C4 SF 계획', c_br_sf, c_pp, v_blk, 'SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A');
    -- C5 SP 실적 3종 삭제
    op_tok('C5 SP 삭제', c5_tok, '            END) IS NOT NULL;' || CHR(10) || c5_del || CHR(10) || '    END IF;' || CHR(10), NULL, NULL, 1);
    IF (DBMS_LOB.GETLENGTH(v_new) - DBMS_LOB.GETLENGTH(REPLACE(v_new, c_mark, ''))) / LENGTH(c_mark) <> 9 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 마커 수 불일치(9 기대). 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 9곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — [{MARK}] GAP 446 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 의 연산을 역순으로 되돌린다 — 위치는 ASCII 마커·토큰으로만 찾는다(한글 비교 없음).
--       C4 는 수정 전 SF 블록 원문(사내 기준본)을 그대로 되넣는다.
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
{clob_build('v_blk', OLD_SF)}    op_cut('C5 SP 삭제', c5_start, c5_end);
    op_span('C4 SF 계획', c_br_sf, c_pp, v_blk, '[' || c_mark || '] SF');
    op_line('C3 MF 판가 NOW', c3_pfx, '', c_br_mf, c_br_sf, 2);
    op_tok('C3 MF 판가', c3_tok2, c3_tok, c_br_mf, c_br_sf, 2);
    op_line('C2 MF 계획', c2_pfx, '', c_br_mf, c_enddiv, 2);
    op_line('C1 NOW 산식', c1_pfx, c1_old || CHR(10), NULL, NULL, 1);
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
lq = lambda t: t.replace("'", "''")
PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] GAP 446 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL
-- * [L1] 연산 대상 줄 (GET_MAIN_DATA 구간) — 기대 건수와 같아야 10 적용 가능 (전부 PASS 기대)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 블록이 쓰는 원장·GTT·함수 실존 (전부 PASS 기대)
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
SELECT 'L1 대상' CHK, K.KIND, COUNT(S.LINE) N, K.EXPECT, LISTAGG(S.LINE, ',') WITHIN GROUP (ORDER BY S.LINE) LINES,
       CASE WHEN (K.EXPECT > 0 AND COUNT(S.LINE) = K.EXPECT) OR (K.EXPECT = 0 AND COUNT(S.LINE) >= 1) THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END JUDGE
  FROM ( SELECT 'C1 NOW 산식 줄' KIND, '{lq(C1_OLD)}' TXT, 1 EXPECT FROM DUAL UNION ALL
         SELECT 'MF 분기 시작', '{lq(BR_MF.rstrip(chr(10)))}', 1 FROM DUAL UNION ALL
         SELECT 'SF 분기 시작', '{lq(BR_SF.rstrip(chr(10)))}', 1 FROM DUAL UNION ALL
         SELECT 'C4 SF 실적 원장(교체 대상)', '{lq("        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A")}', 0 FROM DUAL UNION ALL
         SELECT 'C5 SP Unit Price 끝', '{lq("            END) IS NOT NULL;")}', 1 FROM DUAL ) K
  LEFT JOIN USER_SOURCE S
    ON S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = K.TXT
{RANGE_SQL}
 GROUP BY K.KIND, K.EXPECT
 ORDER BY K.KIND;
SELECT 'L2 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 실존' CHK, K.KIND, CASE WHEN O.OBJECT_NAME IS NULL THEN 'FAIL — 없음 → 10 실행 금지' ELSE 'PASS' END JUDGE
  FROM ( SELECT 'DM_PLN_MKT_FCST_C' KIND, 'TABLE' T FROM DUAL UNION ALL SELECT 'DM_PLN_CFM_MKT_DEMAND_PLAN_C', 'TABLE' FROM DUAL UNION ALL
         SELECT 'GT_DMF0082_T_LAST_DATA_SETUP_FCST_C', 'TABLE' FROM DUAL UNION ALL SELECT 'GT_DMF0082_T_VERSION', 'TABLE' FROM DUAL UNION ALL
         SELECT 'GT_DMF0082_TEMP_FCST_N_PRICE', 'TABLE' FROM DUAL UNION ALL SELECT 'FN_NEXT_DAY', 'FUNCTION' FROM DUAL ) K
  LEFT JOIN (SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS WHERE STATUS = 'VALID') O ON O.OBJECT_NAME = K.KIND AND O.OBJECT_TYPE = K.T
 ORDER BY K.KIND;
SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] GAP 446 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 9줄 PASS · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 연산별 신 줄 PASS · V4 구 줄 잔존 0 PASS
-- * 화면 확인(README 4단계): 과거 SF·MF·SP 버전 조회 행 구성이 AS-IS 와 같다.
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A40
COLUMN JUDGE FORMAT A60
SELECT 'V1 마커' CHK, COUNT(*) N, LISTAGG(LINE, ',') WITHIN GROUP (ORDER BY LINE) LINES,
       CASE WHEN COUNT(*) = 9 THEN 'PASS' ELSE 'FAIL (미적용 또는 마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 신 줄' CHK, K.KIND, COUNT(S.LINE) N, K.EXPECT,
       CASE WHEN COUNT(S.LINE) = K.EXPECT THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM ( SELECT 'C1 NOW 산식' KIND, '{lq(C1_NEW_PREFIX)}' TXT, 1 EXPECT FROM DUAL UNION ALL
         SELECT 'C2 MF·SF 계획 NOW (MF 2 + SF 2)', '{lq(C2_LINE_PREFIX)}', 4 FROM DUAL UNION ALL
         SELECT 'C3 MF 판가 NOW', '{lq(C3_LINE_PREFIX)}', 2 FROM DUAL UNION ALL
         SELECT 'C5 SP 3종 삭제', '{lq(C5_END.rstrip(chr(10)))}', 1 FROM DUAL ) K
  LEFT JOIN USER_SOURCE S
    ON S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY' AND S.TEXT LIKE K.TXT || '%'
{RANGE_SQL}
 GROUP BY K.KIND, K.EXPECT
 ORDER BY K.KIND;
SELECT 'V4 구 줄' CHK, K.KIND, COUNT(S.LINE) N,
       CASE WHEN COUNT(S.LINE) = 0 THEN 'PASS' ELSE 'FAIL — 구 줄 잔존' END JUDGE
  FROM ( SELECT 'C1 구 NOW 산식' KIND, '{lq(C1_OLD)}' TXT FROM DUAL UNION ALL
         SELECT 'C4 SF 실적 원장(구)', '{lq("        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A")}' FROM DUAL ) K
  LEFT JOIN USER_SOURCE S
    ON S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = K.TXT
   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)) = '{lq(BR_SF.strip())}')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '{P_TO}%')
 GROUP BY K.KIND
 ORDER BY K.KIND;
"""

os.makedirs(OUT, exist_ok=True)
files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_GAP446_PATCH.sql": APPLY, "90_VERIFY.sql": VERIFY, "99_ROLLBACK_GAP446_PATCH.sql": ROLLBACK}
for name, body in files.items():
    open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n").write(body)
    print("wrote", name, len(body.splitlines()), "lines")
open(os.path.join(HERE, "_md5_corporate_applied.txt"), "w", encoding="utf-8").write(
    f"PKG_DMF0082 BODY (LF) applied md5={hashlib.md5(APPLIED.encode('utf-8')).hexdigest()} pre md5={hashlib.md5(PRE.encode('utf-8')).hexdigest()} LAST_DDL={last_ddl} FETCHED={fetched}\n")
print("LAST_DDL", last_ddl)
