"""DMF0082_ONEREAD40 클라우드 패키지 생성기 — 패치형 (클라우드 USER_SOURCE 를 읽어 GET_MAIN_DATA 의 40 경로 4구간만 교체)

왜 패치형인가: 클라우드 PKG_DMF0082 BODY 와 사내 BODY 는 적용 이력이 달라 전체본 교체 금지.
구간 찾기: 원문에 한글 주석이 섞여 있어 문구 전체 비교 대신 **ASCII 앵커로 시작·끝**을 찾고 **구간 길이(문자 수)**로 원문 동일성을 검증한다.
  (한글이 클라이언트에서 다르게 변환되면 길이가 달라져 중단된다 — 안전 방향)
교체 문구: 사내 적용본(USER_SOURCE 현재본)에서 같은 앵커로 잘라 낸 구간 그대로 — 사내 적용 스크립트와 1:1.
FRESH-GATE: 생성 직전 사내 DB 현재 BODY 에 마커 4곳 · 사내 백업본(적용 직전 원문)에서 앵커로 자른 구 구간 4개가
  사내 적용 스크립트(build_apply.transform)가 바꾼 구간과 같은지 확인. 다르면 중단.

  python build_package.py
"""
import sys, os, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP_DIR = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_ONEREAD40_20261014"
spec = importlib.util.spec_from_file_location("corp_build", os.path.join(CORP_DIR, "build_apply.py"))
corp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(corp)
MARK = corp.MARK.strip("[]")
NL = "\n"
ENDIF4 = "\n    END IF;  --[DIV81]"
ENDIF8 = "\n        END IF;  --[DIV81]\n"


# ---- 구간 찾기 규칙 (Python · PL/SQL 이 같은 규칙을 쓴다) ------------------------------------------------
# R1 old: '\n    ELSE\n    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST\n' 뒤 'INSERT' ~ 다음 '\n    END IF;  --[DIV81]' 의 '\n' 까지
# R2 old: 같은 규칙, _PRICE
# R3 old: R2 끝 이후 첫 '\n        ELSE\n        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE\n' 의 'ELSE' ~ 다음 '\n        END IF;  --[DIV81]\n' 끝
# R4 old: R3 끝 이후 첫 ') WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;' 뒤 첫
#         '\n        ELSE\n        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE\n' 의 'INSERT' ~ 다음 '\n        END IF;  --[DIV81]\n' 끝
# 새 본(롤백용)도 R1/R2 는 'NULL;  --[MARK] 40 T_LAST_DATA_SETUP_FCST/PRICE' 줄부터, R3 은 '\n        ELSE\n        /* [MARK] 40 ' 부터,
#   R4 는 R3 과 같은 규칙(ONEREAD 끝 뒤 첫 ELSE INSERT) — 끝 규칙은 old 와 동일.
A1 = "\n    ELSE\n    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST\n"
A2 = "\n    ELSE\n    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE\n"
A3 = "\n        ELSE\n        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE\n"
A4P = ") WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;"
N1 = f"    NULL;  --[{MARK}] 40 T_LAST_DATA_SETUP_FCST"
N2 = f"    NULL;  --[{MARK}] 40 T_LAST_DATA_SETUP_PRICE"
N3 = f"\n        ELSE\n        /* [{MARK}] 40 "


def regions_old(src, m, c):
    s1 = src.index(A1, m) + len("\n    ELSE\n"); e1 = src.index(ENDIF4, s1) + 1
    s2 = src.index(A2, e1) + len("\n    ELSE\n"); e2 = src.index(ENDIF4, s2) + 1
    s3 = src.index(A3, e2) + 1;                e3 = src.index(ENDIF8, s3) + len(ENDIF8)
    p4 = src.index(A4P, e3)
    s4 = src.index(A3, p4) + len("\n        ELSE\n"); e4 = src.index(ENDIF8, s4) + len(ENDIF8)
    r = [(s1, e1), (s2, e2), (s3, e3), (s4, e4)]
    assert all(m < s < e < c for s, e in r), "구간이 GET_MAIN_DATA 밖"
    return r


def regions_new(src, m, c):
    s1 = src.index(N1, m); e1 = src.index(ENDIF4, s1) + 1
    s2 = src.index(N2, e1); e2 = src.index(ENDIF4, s2) + 1
    s3 = src.index(N3, e2) + 1; e3 = src.index(ENDIF8, s3) + len(ENDIF8)
    p4 = src.index(A4P, e3)
    s4 = src.index(A3, p4) + len("\n        ELSE\n"); e4 = src.index(ENDIF8, s4) + len(ENDIF8)
    r = [(s1, e1), (s2, e2), (s3, e3), (s4, e4)]
    assert all(m < s < e < c for s, e in r), "구간이 GET_MAIN_DATA 밖"
    return r


def bounds(src):
    return src.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA\n"), src.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT")


def fresh_gate():
    # FRESH-GATE: 사내 DB 현재 BODY(USER_SOURCE) = 사내 적용본 · 백업본(적용 직전) → transform == 현재본
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0082' AND type='PACKAGE BODY' ORDER BY line")
        now = "".join(r[0] for r in cur)
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name='PKG_DMF0082' AND object_type='PACKAGE BODY'")
        last_ddl = cur.fetchone()[0]
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI'), SYS_CONTEXT('USERENV','SERVER_HOST') FROM dual")
        fetched, host = cur.fetchone()
    bak = open(os.path.join(CORP_DIR, "00_BACKUP_PKG_DMF0082_BODY.sql"), encoding="utf-8").read()
    old = bak.split("\n", 1)[1][len("CREATE OR REPLACE "):].rstrip().rstrip("/").rstrip()   # DB 원문은 줄바꿈 없이 끝남
    assert old == open(os.path.join(CORP_DIR, "PKG_DMF0082_BODY.ASIS.sql"), encoding="utf-8").read().rstrip(), "백업본 ≠ 착수 시 조회본"
    if now.count(corp.MARK) != 4:
        sys.exit(f"FRESH-GATE FAIL: 사내 BODY 마커 {now.count(corp.MARK)}곳 (기대 4)")
    if corp.transform(old).rstrip() != now.rstrip():
        sys.exit("FRESH-GATE FAIL: 사내 현재 BODY ≠ 백업본에 사내 변환을 적용한 결과 (적용 뒤 원문이 바뀜)")
    mo, co = bounds(old); mn, cn = bounds(now)
    ro, rn = regions_old(old, mo, co), regions_new(now, mn, cn)
    olds = [old[s:e] for s, e in ro]; news = [now[s:e] for s, e in rn]
    # 구간 밖은 완전히 같아야 한다 (교체가 4구간에 한정)
    def outside(src, r):
        out, k = [], 0
        for s, e in r:
            out.append(src[k:s]); k = e
        out.append(src[k:]); return out
    if outside(old, ro) != outside(now, rn):
        sys.exit("FRESH-GATE FAIL: 4구간 밖에 차이 있음")
    for i, (o, n) in enumerate(zip(olds, news), 1):
        assert "\t" not in o + n and "\r" not in o + n, f"구간 {i} 탭/CR 포함"
        assert MARK in n and MARK not in o, f"구간 {i} 마커 판정 이상"
    print("FRESH-GATE PASS — 사내 BODY LAST_DDL", last_ddl, "HOST", host, "구간 길이 old", [len(x) for x in olds], "new", [len(x) for x in news])
    return last_ddl, fetched, host, olds, news, len(old), len(now)


def plsql_lit(text, indent="        "):
    parts = text.split("\n")
    tail = parts[-1]
    lits = ["'" + p.replace("'", "''") + "' || CHR(10)" for p in parts[:-1]]
    if tail:
        lits.append("'" + tail.replace("'", "''") + "'")
    return (" ||\n" + indent).join(lits) if lits else "''"


def consts(olds, news):
    out = []
    for i, (o, n) in enumerate(zip(olds, news), 1):
        out.append(f"    c_old{i} CONSTANT VARCHAR2(32767) :=   -- 구 구간 {i} ({len(o)}자)\n        {plsql_lit(o)};")
        out.append(f"    c_new{i} CONSTANT VARCHAR2(32767) :=   -- 새 구간 {i} ({len(n)}자)\n        {plsql_lit(n)};")
    return "\n".join(out)


def plsql_str(s):
    return " || ".join(("CHR(10)" if part == "\n" else "'" + part.replace("'", "''") + "'")
                       for part in _split_nl(s))


def _split_nl(s):
    out, buf = [], ""
    for ch in s:
        if ch == "\n":
            if buf: out.append(buf); buf = ""
            out.append("\n")
        else:
            buf += ch
    if buf: out.append(buf)
    return out


def head(olds, news):
    return f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_main  PLS_INTEGER;
    v_cur   PLS_INTEGER;
    s1 PLS_INTEGER; e1 PLS_INTEGER; s2 PLS_INTEGER; e2 PLS_INTEGER;
    s3 PLS_INTEGER; e3 PLS_INTEGER; s4 PLS_INTEGER; e4 PLS_INTEGER; p4 PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
    c_a1  CONSTANT VARCHAR2(200) := {plsql_str(A1)};
    c_a2  CONSTANT VARCHAR2(200) := {plsql_str(A2)};
    c_a3  CONSTANT VARCHAR2(200) := {plsql_str(A3)};
    c_a4p CONSTANT VARCHAR2(200) := {plsql_str(A4P)};
    c_n1  CONSTANT VARCHAR2(200) := {plsql_str(N1)};
    c_n2  CONSTANT VARCHAR2(200) := {plsql_str(N2)};
    c_n3  CONSTANT VARCHAR2(200) := {plsql_str(N3)};
    c_e4  CONSTANT VARCHAR2(60)  := {plsql_str(ENDIF4)};
    c_e8  CONSTANT VARCHAR2(60)  := {plsql_str(ENDIF8)};
    c_else4 CONSTANT PLS_INTEGER := {len(chr(10) + '    ELSE' + chr(10))};
    c_else8 CONSTANT PLS_INTEGER := {len(chr(10) + '        ELSE' + chr(10))};
{consts(olds, news)}
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
    FUNCTION req(p_pos PLS_INTEGER, p_what VARCHAR2) RETURN PLS_INTEGER IS
    BEGIN
        IF p_pos IS NULL OR p_pos = 0 OR p_pos < v_main OR p_pos > v_cur THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_what || ' 위치 확인 불가(GET_MAIN_DATA 구간 밖 또는 없음). 원문 무변경');
        END IF;
        RETURN p_pos;
    END;
    PROCEDURE chk_len(p_i PLS_INTEGER, p_s PLS_INTEGER, p_e PLS_INTEGER, p_expect PLS_INTEGER, p_kind VARCHAR2) IS
    BEGIN
        IF p_e - p_s <> p_expect THEN
            RAISE_APPLICATION_ERROR(-20003, '중단 — ' || p_kind || ' 구간 ' || p_i || ' 길이 ' || (p_e - p_s) || '자 (' || p_expect || '자 기대) — 원문이 다름. 00_PRECHECK L1 회신. 원문 무변경');
        END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src  := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_main := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA' || CHR(10));
    v_cur  := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
    IF NOT (v_main > 0 AND v_main < v_cur) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 조회 프로시저 위치 확인 불가 (GET_MAIN_DATA / _CURRENT). 원문 무변경');
    END IF;
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

ASSEMBLE = """    v_new := SUBSTR(v_src, 1, s1 - 1) || {n1} || SUBSTR(v_src, e1, s2 - e1) || {n2} || SUBSTR(v_src, e2, s3 - e2)
          || {n3} || SUBSTR(v_src, e3, s4 - e3) || {n4} || SUBSTR(v_src, e4);
"""


def locate_old():
    return """    s1 := req(DBMS_LOB.INSTR(v_src, c_a1, v_main), 'R1 시작') + c_else4;  e1 := req(DBMS_LOB.INSTR(v_src, c_e4, s1), 'R1 끝') + 1;
    s2 := req(DBMS_LOB.INSTR(v_src, c_a2, e1), 'R2 시작') + c_else4;      e2 := req(DBMS_LOB.INSTR(v_src, c_e4, s2), 'R2 끝') + 1;
    s3 := req(DBMS_LOB.INSTR(v_src, c_a3, e2), 'R3 시작') + 1;            e3 := req(DBMS_LOB.INSTR(v_src, c_e8, s3), 'R3 끝') + LENGTH(c_e8);
    p4 := req(DBMS_LOB.INSTR(v_src, c_a4p, e3), 'R4 기준(81 ONEREAD 끝)');
    s4 := req(DBMS_LOB.INSTR(v_src, c_a3, p4), 'R4 시작') + c_else8;     e4 := req(DBMS_LOB.INSTR(v_src, c_e8, s4), 'R4 끝') + LENGTH(c_e8);
"""


def locate_new():
    return """    s1 := req(DBMS_LOB.INSTR(v_src, c_n1, v_main), 'R1 시작');            e1 := req(DBMS_LOB.INSTR(v_src, c_e4, s1), 'R1 끝') + 1;
    s2 := req(DBMS_LOB.INSTR(v_src, c_n2, e1), 'R2 시작');                e2 := req(DBMS_LOB.INSTR(v_src, c_e4, s2), 'R2 끝') + 1;
    s3 := req(DBMS_LOB.INSTR(v_src, c_n3, e2), 'R3 시작') + 1;            e3 := req(DBMS_LOB.INSTR(v_src, c_e8, s3), 'R3 끝') + LENGTH(c_e8);
    p4 := req(DBMS_LOB.INSTR(v_src, c_a4p, e3), 'R4 기준(81 ONEREAD 끝)');
    s4 := req(DBMS_LOB.INSTR(v_src, c_a3, p4), 'R4 시작') + c_else8;     e4 := req(DBMS_LOB.INSTR(v_src, c_e8, s4), 'R4 끝') + LENGTH(c_e8);
"""


def gen_apply(corp_ddl, olds, news, len_old, len_new):
    lens = "\n".join(f"    chk_len({i}, s{i}, e{i}, {len(o)}, '구');" for i, o in enumerate(olds, 1))
    return f"""-- 10_APPLY — [{MARK}] PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 조회 P_DMF0082_GET_MAIN_DATA 의 **40 경로**에서 같은 원장을 두 번 읽던 것을 한 번 읽기로 바꾼다.
--   R1 40 T_LAST_DATA_SETUP_FCST 별도 적재 제거(주석 보존) — R3 이 대신 적재
--   R2 40 T_LAST_DATA_SETUP_PRICE 별도 적재 제거(주석 보존) — R4 가 윈도 MAX 로 대체
--   R3 40 수요 arm → INSERT ALL (원장 1회 읽기로 수요 행 + 실적 arm 용 최근수정일 GTT 동시 적재)
--   R4 40 판가 arm → 81 [E20260930-DMF0082ONEREAD] 와 같은 형태 (원장 1회 읽기 + 키 8개 윈도 MAX)
-- 배경: 클라우드 QA 실측(G03/G04 2026-10-14, Division 만 지정 조회) 상위 4문장 = 위 2원장 × 2회 읽기 (ASH 38+36+20+13초).
-- 범위: 81/82 경로·결과 값·원장·메타·FE·권한 무변경. 사내 30→15케이스 전후 전행 해시 15/15 PASS.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 앵커로 4구간을 찾고 **구간 길이(문자 수)로 원문 동일성 확인** 뒤 교체 → CREATE OR REPLACE.
-- 가드: 마커 존재 시 무동작 · 구간 위치/길이 불일치 시 중단(원문 무변경) · 조립 길이 불일치 시 중단 · 컴파일 오류 시 원문 자동 복원
-- ⚠ 99_ROLLBACK 은 이 파일과 같은 도구로 실행할 것.
-- 사내 ZIOUI1 적용 완료 {corp_ddl}. 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
{head(olds, news)}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
{locate_old()}{lens}
{ASSEMBLE.format(n1='c_new1', n2='c_new2', n3='c_new3', n4='c_new4')}    IF cnt(v_new, c_mark) <> 4 OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(v_src) + {len_new - len_old} THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치 (마커 ' || cnt(v_new, c_mark) || '곳, 4 기대). 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 4곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback(olds, news, len_old, len_new):
    lens = "\n".join(f"    chk_len({i}, s{i}, e{i}, {len(n)}, '새');" for i, n in enumerate(news, 1))
    return f"""-- 99 ROLLBACK — [{MARK}] 4구간을 구 원문으로 되돌린다 (이 DB 의 USER_SOURCE 를 읽어 교체 → CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 새 구간 4개의 위치·길이가 적용본과 같을 때만 실행. 10_APPLY 와 같은 도구로 실행할 것.
-- ⚠ 되돌리면 40 조회가 다시 원장 2회 읽기로 돌아간다. 결과 값은 같다.
{head(olds, news)}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
{locate_new()}{lens}
{ASSEMBLE.format(n1='c_old1', n2='c_old2', n3='c_old3', n4='c_old4')}    IF cnt(v_new, c_mark) <> 0 OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(v_src) - {len_new - len_old} THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 되돌린 결과 불일치. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


SCOPE = """S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)) = 'PROCEDURE P_DMF0082_GET_MAIN_DATA')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT%')"""

LINE_SQL = """SELECT '{tag}' CHK, K.KIND, COUNT(S.LINE) N, K.EXPECT, LISTAGG(S.LINE, ',') WITHIN GROUP (ORDER BY S.LINE) LINES,
       CASE WHEN COUNT(S.LINE) = K.EXPECT THEN 'PASS' ELSE '{ng}' END JUDGE
  FROM ( SELECT '40 LD_FCST 적재 줄' KIND, '    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST' TXT, {e1} EXPECT FROM DUAL UNION ALL
         SELECT '40 LD_PRICE 적재 줄', '    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE', {e2} FROM DUAL UNION ALL
         SELECT '40 수요 원장 FROM', '        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A', {e3} FROM DUAL UNION ALL
         SELECT '40 판가 원장 FROM', '        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A', 1 FROM DUAL UNION ALL
         SELECT 'ONEREAD 끝(81·40판가)', '        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;%', {e5} FROM DUAL ) K
  LEFT JOIN USER_SOURCE S
    ON S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) LIKE K.TXT
   AND {scope}
 GROUP BY K.KIND, K.EXPECT
 ORDER BY K.KIND;
"""

MARK_SQL = """SELECT '{tag}' CHK, COUNT(*) N, LISTAGG(LINE, ',') WITHIN GROUP (ORDER BY LINE) LINES,
       CASE WHEN COUNT(*) = {exp} THEN '{ok}' ELSE '{ng}' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{mark}%';
"""


def gen_precheck():
    return f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL
-- * [L1] 대상 줄 — GET_MAIN_DATA 구간 기대 건수 (전부 PASS 여야 10 실행 가능. 81 판가 ONEREAD 끝 줄은 2줄 이상이면 이미 적용 상태)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행)
-- * 최종 판정은 10 이 구간 길이(문자 수)로 한다 — L1 PASS 인데 10 이 '길이 … 기대' 로 중단하면 그 메시지를 회신
SET LINESIZE 260 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A22
COLUMN LINES FORMAT A20
COLUMN JUDGE FORMAT A60
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
{LINE_SQL.format(tag='L1 대상줄', ng='FAIL — 건수 다름 → 10 실행 금지·결과 회신', scope=SCOPE, e1=2, e2=1, e3=1, e5=1)}{MARK_SQL.format(tag='L2 마커', exp=0, ok='미적용 (기대)', ng='적용됨 — 10 재실행은 가드로 무동작', mark=MARK)}SELECT 'L3 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""


def gen_verify():
    return f"""-- 90 VERIFY — [{MARK}] 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 4줄 PASS · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 대상 줄(적용 후 기대 건수) PASS
-- * V4 (선택) 화면에서 Division 40 을 조건 없이 조회한 뒤 이 파일을 다시 실행 — 새 문장 2개(INSERT ALL · 40 판가 ONEREAD)의
--      1회 소요·읽기와, 적용 전 클라우드 G03/G04 값(40 LD_FCST 2.95s · 40 수요 2.79s · 40 LD_PRICE 1.67s · 40 판가 2.12s)을 비교
SET LINESIZE 260 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A24
COLUMN LINES FORMAT A30
COLUMN JUDGE FORMAT A60
COLUMN TXT FORMAT A80
{MARK_SQL.format(tag='V1 마커', exp=4, ok='PASS', ng='FAIL (미적용 또는 마커 수 불일치)', mark=MARK)}SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
{LINE_SQL.format(tag='V3 대상줄', ng='FAIL — 적용 후 기대와 다름', scope=SCOPE, e1=1, e2=0, e3=0, e5=2)}SELECT 'V4 실행' CHK, S.SQL_ID, S.EXECUTIONS EX, ROUND(S.ELAPSED_TIME/1e6/GREATEST(S.EXECUTIONS,1),2) SEC_PER_EX,
       ROUND(S.USER_IO_WAIT_TIME/1e6/GREATEST(S.EXECUTIONS,1),2) IO_PER_EX, ROUND(S.BUFFER_GETS/GREATEST(S.EXECUTIONS,1)) BG_PER_EX,
       ROUND(S.ROWS_PROCESSED/GREATEST(S.EXECUTIONS,1)) ROWS_PER_EX, TO_CHAR(S.LAST_ACTIVE_TIME,'MM-DD HH24:MI') LAST_ACT,
       CASE WHEN UPPER(S.SQL_TEXT) LIKE 'INSERT ALL%' THEN '신규 40 수요 INSERT ALL' ELSE '신규 40 판가 ONEREAD' END KIND
  FROM GV$SQL S
 WHERE S.PROGRAM_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY')
   AND S.COMMAND_TYPE IN (2, 189)
   AND ((UPPER(S.SQL_TEXT) LIKE 'INSERT ALL%' AND DBMS_LOB.INSTR(S.SQL_FULLTEXT, 'DM_PLN_CFM_MKT_DEMAND_PLAN') > 0)   -- SQL_TEXT 는 앞 1000자뿐
        OR (DBMS_LOB.INSTR(S.SQL_FULLTEXT, 'X_ONEREAD_YMD') > 0 AND DBMS_LOB.INSTR(S.SQL_FULLTEXT, 'DM_PLN_CFM_SELLING_PRICE A') > 0))
 ORDER BY KIND;
"""


def main():
    corp_ddl, fetched, host, olds, news, len_old, len_new = fresh_gate()
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    stamp = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={corp_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 구간 대조 · 클라우드는 자기 USER_SOURCE 를 패치)\n"
    files = {"00_PRECHECK_CLOUD.sql": gen_precheck(),
             "10_APPLY_ONEREAD40_PATCH.sql": stamp + gen_apply(corp_ddl, olds, news, len_old, len_new),
             "90_VERIFY.sql": gen_verify(),
             "99_ROLLBACK_ONEREAD40_PATCH.sql": stamp + gen_rollback(olds, news, len_old, len_new)}
    for name, txt in files.items():
        assert "&" not in txt, f"{name}: 치환변수 문자 & 포함 금지 (클라우드 ORA-01008 계보)"
        assert "\t" not in txt, f"{name}: 탭 문자 포함 금지"
        for ln in txt.split("\n"):
            if ln.strip().startswith("'") and len(ln.encode("utf-8")) > 4000:
                sys.exit(f"{name}: 문자열 리터럴 한 줄이 4000바이트 초과")
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")


if __name__ == "__main__":
    main()
