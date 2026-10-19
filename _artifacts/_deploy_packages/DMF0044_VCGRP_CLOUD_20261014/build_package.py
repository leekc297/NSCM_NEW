"""DMF0044_VCGRP 클라우드 패키지 생성기 v2 — 패치형 (클라우드 USER_SOURCE 를 읽어 Version Copy 프로시저의 GROUP BY 줄만 고친다)

v1 은 대상 줄을 "들여쓰기 · 줄 끝 주석까지 글자 단위로" 맞췄다 → QA(2026-10-14)에서 16줄 전부 불일치로 중단.
  QA 진단 출력: 공백을 무시하면 12줄은 일치, 줄 끝에 '--  2026.10.11 AJS' 주석이 붙은 4줄은 공백을 무시해도 불일치
  = 클라우드 원문은 들여쓰기가 다르고 그 주석이 없다 (SQL 내용은 같은 것으로 보인다).

v2 는 줄을 "코드 내용"으로만 맞춘다.
  - 줄 열쇠 = 줄 끝 주석('--' 뒤)을 떼고 공백 · 탭을 모두 뺀 문자열.
  - 프로시저 안의 줄을 위에서부터 읽으며, 사내 적용 전 대상 줄 16개의 열쇠가 "같은 순서로, 같은 횟수만" 나오는지 본다.
    순서가 다르거나 더 나오거나 덜 나오면 중단한다 (원문 무변경).
  - 맞은 줄은 그 줄 안의 NVL(X, '/') 토큰만 바꾼다 — 클라우드의 들여쓰기 · 주석은 그대로 둔다.
치환 내용은 사내 적용 폴더(_apply_corporate/DMF0044_VCGRP_20261014)의 적용 전(00) · 적용 후(01) 원문에서 뽑는다.
FRESH-GATE: 생성 직전 사내 DB(USER_SOURCE)의 현재 BODY == 적용 후(01) 원문.
생성기 안에서 같은 절차를 Python 으로 흉내 내, 사내 적용 전 원문 → 사내 적용 후 원문이 그대로 나오는지 확인한다.

  python build_package.py
"""
import sys, os, re, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP_DIR = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0044_VCGRP_20261014"
spec = importlib.util.spec_from_file_location("corp_build", os.path.join(CORP_DIR, "build_apply.py"))
corp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(corp)
MARK = corp.MARK.strip("[]")
P_START = corp.P_START
RAW_RE = re.compile(r"NVL\((\w+\.\w+), '/'\)")


def body_of(fname):
    return corp.strip(open(os.path.join(CORP_DIR, fname), encoding="utf-8").read())[len("CREATE OR REPLACE "):]


def region(body):
    a = body.index(P_START)
    nxt = re.search(r"\nPROCEDURE |\nFUNCTION |\nEND PKG_DMF0044", body[a + 10:])
    return body[a:a + 10 + nxt.start()]


def key(line):
    """줄 열쇠 — 줄 끝 주석을 떼고 공백 · 탭 · CR 을 뺀다 (PL/SQL 의 lkey 와 같은 규칙)."""
    i = line.find("--")
    code = line if i < 0 else line[:i]
    code = code.replace("\t", "").replace(" ", "").replace("\r", "")
    return re.sub(r"NVL\(([AB]\.[A-Z_]+),'-'\)", r"NVL(\1,'/')", code)   # 빈값 표기 '-' · '/' 는 같은 줄로 본다 (QA 는 4줄이 아직 '-')


def ws(tok):
    """토큰을 공백 무관 정규식으로 (괄호 · 쉼표 · 따옴표 사이의 공백은 있어도 없어도 된다)."""
    parts = re.findall(r"[A-Za-z_][\w.]*|''|'/'|[(),]", tok.replace(" ", ""))
    assert "".join(parts) == tok.replace(" ", ""), tok
    return r"\s*".join(p.replace(".", r"\.") if p[0].isalpha() or p[0] == "_" else re.escape(p) for p in parts)


def new_text(x, how):
    return corp.sel(x) if how == "R" else corp.raw(x) + ", " + corp.sel(x)


def raw_re(x):
    """GROUP BY 쪽 토큰을 찾는 식 — 빈값 표기가 '-' 이든 '/' 이든 찾는다."""
    r = ws(corp.raw(x))
    assert r.count("'/'") == 1
    return r.replace("'/'", "'[-/]'")


def fwd(x, how):
    """적용: (찾는 식, 바꿀 말). 덧붙임(A)은 원래 토큰(\\1)을 그대로 두고 뒤에 붙인다."""
    return "(" + raw_re(x) + ")", (corp.sel(x) if how == "R" else "\\1, " + corp.sel(x))


def bwd(x, how):
    """원복: (찾는 식, 바꿀 말). 바꿈(R)은 NVL(X, '/') 로 돌린다 — 원래 '-' 였던 줄도 '/' 로 돌아간다."""
    if how == "R":
        return ws(corp.sel(x)), corp.raw(x)
    return "(" + raw_re(x) + r")\s*,\s*" + ws(corp.sel(x)), "\\1"


def derive():
    """원문 순서대로 줄마다 {적용 전 열쇠, 적용 후 열쇠, [(X, 방식 R=바꿈/A=덧붙임)]} 를 만든다."""
    old_l, new_l = region(body_of(corp.F_BAK)).split("\n"), region(body_of(corp.F_NEW)).split("\n")
    note_i = next(i for i, l in enumerate(new_l) if corp.MARK in l)
    note = new_l[note_i].strip()
    new_wo = new_l[:note_i] + new_l[note_i + 1:]
    assert len(old_l) == len(new_wo)
    seq = []
    for o, n in zip(old_l, new_wo):
        if o == n:
            continue
        toks, cur = [], o
        for x in RAW_RE.findall(o):
            how = "A" if corp.raw(x) + ", " + corp.sel(x) in n else "R"
            assert cur.count(corp.raw(x)) == 1
            cur = cur.replace(corp.raw(x), new_text(x, how))
            toks.append((x, how))
        assert cur == n, ("토큰 치환으로 적용 후 줄을 재현하지 못함", o, n)
        seq.append({"ko": key(o), "kn": key(n), "toks": toks})
    assert key(old_l[note_i]) == seq[0]["ko"]
    return seq, note, old_l, new_l


def simulate(lines, seq, note, forward=True):
    """PL/SQL walk() 와 같은 절차. 실패하면 문자열(사유)을 돌려준다."""
    keys = [s["ko" if forward else "kn"] for s in seq]
    allk = set(keys)
    out, k = [], 0
    for ln in lines:
        if not forward and MARK in ln:
            continue                                   # 설명 주석 줄 제거
        ck = key(ln)
        if k < len(seq) and ck == keys[k]:
            for x, how in seq[k]["toks"]:
                frm, to = fwd(x, how) if forward else bwd(x, how)
                ln2 = re.sub(frm, lambda m, t=to: t.replace("\\1", m.group(1) if m.groups() else ""), ln, count=1)
                if ln2 == ln:
                    return f"{k + 1}번째 줄에서 토큰을 찾지 못함"
                ln = ln2
            if forward and k == 0:
                out.append(re.match(r"[ \t]*", ln).group(0) + note)
            out.append(ln)
            k += 1
        elif ck and ck in allk:
            return f"대상 줄이 예상 순서 밖에 있음 (다음 기대 {k + 1}번째)"
        else:
            out.append(ln)
    return out if k == len(seq) else f"대상 줄 {len(seq)}개 중 {k}개만 찾음"


def q(s):
    """PL/SQL 문자열 리터럴 (탭 · 제어 문자 금지 — 붙여 넣기 과정에서 바뀐다)."""
    assert not any(ord(ch) < 32 for ch in s), "제어 문자"
    return "'" + s.replace("'", "''") + "'"


def fresh_gate():
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0044' AND type='PACKAGE BODY' ORDER BY line")
        body = "".join(r[0] for r in cur)
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name='PKG_DMF0044' AND object_type='PACKAGE BODY'")
        last_ddl = cur.fetchone()[0]
    if body.rstrip() != body_of(corp.F_NEW).rstrip():
        sys.exit("FRESH-GATE FAIL: 사내 BODY 가 적용 후(01) 원문과 다름 — 사내 재빌드 후 다시 생성")
    print("FRESH-GATE PASS — 사내 BODY LAST_DDL", last_ddl)
    return last_ddl


def head(seq, note, sel_counts):
    n = len(seq)
    ko = ",\n        ".join(q(s["ko"]) for s in seq)
    kn = ",\n        ".join(q(s["kn"]) for s in seq)
    rows = [(i, x, how) for i, s in enumerate(seq, 1) for x, how in s["toks"]]
    r_i = ", ".join(str(i) for i, _, _ in rows)
    r_fre = ",\n        ".join(q(fwd(x, how)[0]) for _, x, how in rows)
    r_frp = ",\n        ".join(q(fwd(x, how)[1]) for _, x, how in rows)
    r_bre = ",\n        ".join(q(bwd(x, how)[0]) for _, x, how in rows)
    r_brp = ",\n        ".join(q(bwd(x, how)[1]) for _, x, how in rows)
    sx = ",\n        ".join(q(k) for k, _ in sel_counts)
    sc = ", ".join(str(v) for _, v in sel_counts)
    return f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    TYPE t_s IS TABLE OF VARCHAR2(2000);
    TYPE t_n IS TABLE OF PLS_INTEGER;
    v_src   CLOB;
    v_reg   CLOB;
    v_out   CLOB;
    v_regc  CLOB;
    v_bad   VARCHAR2(4000);
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_a     PLS_INTEGER;
    v_b     PLS_INTEGER;
    c_nl    CONSTANT VARCHAR2(1)    := CHR(10);
    c_mark  CONSTANT VARCHAR2(40)   := '{MARK}';
    c_ps    CONSTANT VARCHAR2(200)  := CHR(10) || {q(P_START.lstrip(chr(10)))};
    c_note  CONSTANT VARCHAR2(1000) := {q(note)};
    -- 대상 줄 {n}개 (원문 순서). 줄 열쇠 = 줄 끝 주석을 떼고 공백 · 탭을 모두 뺀 코드 — 들여쓰기 · 주석이 달라도 같은 줄로 본다
    t_ko t_s := t_s(   -- 적용 전 줄의 열쇠
        {ko});
    t_kn t_s := t_s(   -- 적용 후 줄의 열쇠
        {kn});
    -- 줄 안에서 바꾸는 토큰 (t_li = 위 목록의 몇 번째 줄인가)
    t_li  t_n := t_n({r_i});
    t_fre t_s := t_s(   -- 적용: 찾는 식 (공백 무관 · 빈값 표기 '-' '/' 모두)
        {r_fre});
    t_frp t_s := t_s(   -- 적용: 바꿀 말 (\\1 = 원래 토큰 그대로)
        {r_frp});
    t_bre t_s := t_s(   -- 원복: 찾는 식
        {r_bre});
    t_brp t_s := t_s(   -- 원복: 바꿀 말
        {r_brp});
    -- SELECT 쪽 확인용: 이 프로시저 안에 SELECT 의 식(공백 뺀 꼴)이 사내 적용 전과 같은 횟수만큼 있어야 한다
    --   (GROUP BY 를 이 식으로 맞추는 것이므로, SELECT 쪽이 사내와 다르면 적용하지 않는다)
    t_sx t_s := t_s(
        {sx});
    t_sc t_n := t_n({sc});
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
    FUNCTION lkey(p VARCHAR2) RETURN VARCHAR2 IS
        i PLS_INTEGER := INSTR(p, '--');
    BEGIN
        -- 빈값 표기 '-' · '/' 는 같은 줄로 본다 (GROUP BY 의 NVL(X,'-') 도 대상)
        RETURN REGEXP_REPLACE(REPLACE(REPLACE(REPLACE(CASE WHEN i > 0 THEN SUBSTR(p, 1, i - 1) ELSE p END, CHR(9)), ' '), CHR(13))
                            , 'NVL\(([AB]\.[A-Z_]+),''-''\)', 'NVL(\\1,''/'')');
    END;
    -- v_reg 의 줄을 위에서부터 읽어 v_out 을 만든다. p_fwd = TRUE 적용 / FALSE 원복
    PROCEDURE walk(p_fwd BOOLEAN) IS
        v_keys t_s;
        v_pos  PLS_INTEGER := 1;
        v_end  PLS_INTEGER;
        v_len  PLS_INTEGER := DBMS_LOB.GETLENGTH(v_reg);
        v_ln   VARCHAR2(32767);
        v_ln2  VARCHAR2(32767);
        v_ck   VARCHAR2(32767);
        v_k    PLS_INTEGER := 1;
        v_no   PLS_INTEGER := 0;
        v_last BOOLEAN;
        PROCEDURE put(p VARCHAR2, p_nl BOOLEAN) IS
        BEGIN
            IF p IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(v_out, LENGTH(p), p); END IF;
            IF p_nl THEN DBMS_LOB.WRITEAPPEND(v_out, 1, c_nl); END IF;
        END;
    BEGIN
        IF p_fwd THEN v_keys := t_ko; ELSE v_keys := t_kn; END IF;
        DBMS_LOB.CREATETEMPORARY(v_out, TRUE);
        WHILE v_pos <= v_len + 1 LOOP
            v_end  := DBMS_LOB.INSTR(v_reg, c_nl, v_pos);
            v_last := NVL(v_end, 0) = 0;
            IF v_last THEN v_end := v_len + 1; END IF;
            v_ln  := CASE WHEN v_end > v_pos THEN DBMS_LOB.SUBSTR(v_reg, v_end - v_pos, v_pos) END;
            v_no  := v_no + 1;
            v_pos := v_end + 1;
            IF NOT p_fwd AND INSTR(v_ln, c_mark) > 0 THEN
                NULL;                                               -- 원복: 설명 주석 줄은 버린다
            ELSE
                v_ck := lkey(v_ln);
                IF v_k <= v_keys.COUNT AND v_ck = v_keys(v_k) THEN
                    FOR j IN 1 .. t_li.COUNT LOOP
                        IF t_li(j) = v_k THEN
                            IF p_fwd THEN v_ln2 := REGEXP_REPLACE(v_ln, t_fre(j), t_frp(j), 1, 1);
                            ELSE          v_ln2 := REGEXP_REPLACE(v_ln, t_bre(j), t_brp(j), 1, 1);
                            END IF;
                            IF v_ln2 = v_ln THEN
                                RAISE_APPLICATION_ERROR(-20003, '중단 — 대상 ' || v_k || '번째 줄(프로시저 ' || v_no || '행)에서 토큰을 찾지 못함. 원문 무변경');
                            END IF;
                            v_ln := v_ln2;
                        END IF;
                    END LOOP;
                    IF p_fwd AND v_k = 1 THEN
                        put(REGEXP_SUBSTR(v_ln, '^[ ' || CHR(9) || ']*') || c_note, TRUE);   -- 첫 대상 줄 바로 위에 설명 주석 1줄 (같은 들여쓰기)
                    END IF;
                    v_k := v_k + 1;
                ELSIF v_ck IS NOT NULL THEN
                    FOR j IN 1 .. v_keys.COUNT LOOP
                        IF v_ck = v_keys(j) THEN
                            RAISE_APPLICATION_ERROR(-20001, '중단 — 대상 줄이 예상 순서 밖에 있음: 프로시저 ' || v_no || '행 (다음 기대 ' || v_k || '번째). 원문이 사내와 다름 → 00_PRECHECK L2 회신. 원문 무변경');
                        END IF;
                    END LOOP;
                END IF;
                put(v_ln, NOT v_last);
            END IF;
        END LOOP;
        IF v_k <> v_keys.COUNT + 1 THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — 대상 줄 ' || v_keys.COUNT || '개 중 ' || (v_k - 1) || '개만 찾음 (다음 기대 ' || v_k || '번째). 원문이 사내와 다름 → 00_PRECHECK L2 회신. 원문 무변경');
        END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화
    v_a := DBMS_LOB.INSTR(v_src, c_ps);
    IF NVL(v_a, 0) = 0 OR cnt(v_src, c_ps) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — Version Copy 프로시저 시작 줄을 찾지 못함. 원문 무변경');
    END IF;
    v_b := LEAST(NVL(NULLIF(DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE ', v_a + 10), 0), 2147483647)
               , NVL(NULLIF(DBMS_LOB.INSTR(v_src, CHR(10) || 'FUNCTION ',  v_a + 10), 0), 2147483647)
               , NVL(NULLIF(DBMS_LOB.INSTR(v_src, CHR(10) || 'END PKG_DMF0044', v_a + 10), 0), 2147483647));
    IF v_b = 2147483647 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — Version Copy 프로시저의 끝을 찾지 못함. 원문 무변경');
    END IF;
    v_reg := SUBSTR(v_src, v_a, v_b - v_a);   -- Version Copy 프로시저 본문만
"""


TAIL = """    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0044' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
"""
POST = "SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0044' ORDER BY OBJECT_TYPE;\n"


def gen_apply(seq, note, corp_ddl, sel_counts):
    n_tok = sum(len(s["toks"]) for s in seq)
    return f"""-- 10_APPLY — [{MARK}] PKG_DMF0044 BODY 패치 v2 (전체 F5, 값 입력 없음, 멱등)
-- 대상: P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY (Version Copy 저장) 의 GROUP BY 절 {len(seq)}줄 · 토큰 {n_tok}곳
-- 원인: SELECT 는 NVL(NULLIF(RTRIM(X),''), '/') 인데 GROUP BY 는 NVL(X, '/') — 식이 달라 실행 시점에 ORA-00979.
--       X = A.CURRENCY · B.SALES_COMPANY · A.ITEM_USE · A.END_CUSTOMER · A.COMPANY_ID  (INSERT 4문장)
-- 보완: GROUP BY 의 식을 SELECT 와 같은 식으로 맞춘다. SELECT · WHERE · 그 밖의 문장 무변경 — 결과 값은 달라지지 않는다.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 대상 줄 안의 토큰만 바꾼 뒤 CREATE OR REPLACE (사내 전체본 복사 아님).
--       v2 = 줄을 코드 내용으로만 맞춘다(들여쓰기 · 줄 끝 주석 무관). 이 DB 의 들여쓰기 · 주석은 그대로 남는다.
-- 가드: 마커 존재 시 무동작 · 대상 줄 {len(seq)}개가 사내와 같은 순서 · 같은 횟수로 나오지 않으면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 {corp_ddl}. 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
{head(seq, note, sel_counts)}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    v_regc := REPLACE(REPLACE(v_reg, CHR(9)), ' ');
    FOR i IN 1 .. t_sx.COUNT LOOP
        IF cnt(v_regc, t_sx(i)) <> t_sc(i) THEN
            v_bad := v_bad || ' [' || t_sx(i) || '] ' || cnt(v_regc, t_sx(i)) || '회(기대 ' || t_sc(i) || ')';
        END IF;
    END LOOP;
    IF v_bad IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20006, '중단 — SELECT 쪽 식의 개수가 사내 적용 전과 다름:' || v_bad || '. 원문 무변경');
    END IF;
    walk(TRUE);
    v_new := SUBSTR(v_src, 1, v_a - 1) || v_out || SUBSTR(v_src, v_b);
    IF cnt(v_new, c_mark) <> 1 OR LENGTH(v_new) <= LENGTH(v_src) THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치 (마커 ' || cnt(v_new, c_mark) || '곳, 1 기대). 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0044 BODY ' || v_st || ' · Version Copy GROUP BY {len(seq)}줄 보완 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback(seq, note, sel_counts):
    return f"""-- 99 ROLLBACK — [{MARK}] 역치환 v2 (Version Copy 프로시저의 GROUP BY 줄을 적용 전으로 되돌린다). 전체 F5, 멱등
-- 마커 없으면 무동작. ⚠ 되돌리면 Version Copy 저장이 다시 ORA-00979 로 실패한다.
{head(seq, note, sel_counts)}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    walk(FALSE);
    v_new := SUBSTR(v_src, 1, v_a - 1) || v_out || SUBSTR(v_src, v_b);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0044 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


SRC_SQL = """SELECT '{tag}' CHK, S.LINE
     , CASE WHEN S.TEXT LIKE '%NVL(NULLIF(RTRIM(%' THEN '적용 후 꼴' ELSE '적용 전 꼴' END KIND
     , SUBSTR(LTRIM(RTRIM(S.TEXT, CHR(10)||CHR(13)), ' ' || CHR(9)), 1, 150) TXT
  FROM USER_SOURCE S
 WHERE S.NAME = 'PKG_DMF0044' AND S.TYPE = 'PACKAGE BODY'
   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY' AND TEXT LIKE 'PROCEDURE P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY%')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY' AND TEXT LIKE 'PROCEDURE P_DMF0044_SALES_REPORT_DEPT_CREATE%')
   AND LTRIM(S.TEXT, ' ' || CHR(9)) NOT LIKE '--%'
   AND (   S.TEXT LIKE '%, A.INCOTERMS, NVL(%A.CURRENCY%'
        OR S.TEXT LIKE '%, NVL(%B.SALES_COMPANY%' AND S.TEXT NOT LIKE '% AS COMPANY_ID%'
        OR S.TEXT LIKE '%, NVL(%A.ITEM_USE%NVL(%A.END_CUSTOMER%A.CELL_PROD_SITE;%'
        OR S.TEXT LIKE '%A.YYYYMM, A.CURRENCY, NVL(%A.COMPANY_ID%' )
   AND S.TEXT NOT LIKE '% AS CURRENCY%'
 ORDER BY S.LINE;
"""


def gen_precheck():
    return f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0044 상태·LAST_DDL
-- * [L1] 최근 30일 PKG_DMF0044 오류 기록 (Version Copy 저장이 ORA-00979 로 실패한 적이 있는지 — 없으면 0행)
-- * [L2] Version Copy 프로시저의 GROUP BY 대상 줄 — 적용 전이면 16줄 모두 '적용 전 꼴' (줄 번호 · 들여쓰기 · 줄 끝 주석은 사내와 달라도 된다)
-- * [L3] 마커 — 적용 전 0 (적용 뒤 1)
-- * [L4] 지금 PKG_DMF0044 실행 중 세션 (있으면 끝난 뒤 10 실행)
SET LINESIZE 260 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN ERR_MSG FORMAT A100
COLUMN BACKTRACE FORMAT A60
COLUMN TXT FORMAT A150
COLUMN JUDGE FORMAT A60
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0044' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 오류' CHK, TO_CHAR(MAX(L.EVENT_DATE),'MM-DD HH24:MI:SS') LAST_EVT, COUNT(*) N, SUBSTR(L.SQL_ERR_MSG, 1, 100) ERR_MSG
     , SUBSTR(REPLACE(L.SQL_BACKTRACE, CHR(10), ' '), 1, 60) BACKTRACE
  FROM SCM_SYS_LOG_BATCH L
 WHERE L.PROGRAM_NAME = 'PKG_DMF0044' AND L.LOG_TYPE = 'ERROR' AND L.EVENT_DATE >= SYSDATE - 30
 GROUP BY SUBSTR(L.SQL_ERR_MSG, 1, 100), SUBSTR(REPLACE(L.SQL_BACKTRACE, CHR(10), ' '), 1, 60)
 ORDER BY 2 DESC;
{SRC_SQL.format(tag='L2 줄')}SELECT 'L3 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0044' AND OBJECT_TYPE='PACKAGE');
"""


def gen_verify():
    return f"""-- 90 VERIFY — [{MARK}] 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 PASS(1) · V2 VALID/오류 0 · V3 16줄 모두 '적용 후 꼴'
SET LINESIZE 260 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN TXT FORMAT A150
COLUMN JUDGE FORMAT A60
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 1 THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL (미적용)' ELSE 'FAIL (마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0044')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0044' ORDER BY O.OBJECT_TYPE;
{SRC_SQL.format(tag='V3 줄')}"""


def main():
    seq, note, old_l, new_l = derive()
    old_c = "\n".join(old_l).replace("\t", "").replace(" ", "")
    xs = sorted({x for s in seq for x, _ in s["toks"]})
    sel_counts = [(corp.sel(x).replace(" ", ""), old_c.count(corp.sel(x).replace(" ", ""))) for x in xs]
    # 생성기 자체 점검: 같은 절차를 흉내 내 사내 적용 전 → 적용 후 · 적용 후 → 적용 전이 그대로 나와야 한다
    sim = simulate(old_l, seq, note, True)
    norm = lambda ls: [l.strip() if MARK in l else l for l in ls]   # 설명 주석 줄은 들여쓰기만 다를 수 있다 (v2 = 대상 줄과 같은 들여쓰기)
    assert not isinstance(sim, str), sim
    assert norm(sim) == norm(new_l), "흉내 적용 결과가 사내 적용본과 다름"
    assert simulate(new_l, seq, note, False) == old_l, "흉내 원복 결과가 사내 적용 전과 다름"
    corp_ddl = fresh_gate()
    print("SELECT 쪽 식 개수(사내 적용 전):", sel_counts)
    print("대상 줄", len(seq), "· 토큰", sum(len(s["toks"]) for s in seq), "| 흉내 적용/원복 == 사내 원문 PASS")
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    files = {"00_PRECHECK_CLOUD.sql": gen_precheck(), "10_APPLY_VCGRP_PATCH.sql": gen_apply(seq, note, corp_ddl, sel_counts),
             "90_VERIFY.sql": gen_verify(), "99_ROLLBACK_VCGRP_PATCH.sql": gen_rollback(seq, note, sel_counts)}
    for name, txt in files.items():
        assert not any(ord(ch) < 32 and ch != "\n" for ch in txt), name + " 에 탭 · 제어 문자"
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")


if __name__ == "__main__":
    main()
