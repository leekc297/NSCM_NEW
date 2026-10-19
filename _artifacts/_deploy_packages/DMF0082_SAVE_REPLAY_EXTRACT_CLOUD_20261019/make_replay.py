"""callProc 로그(LOG_SEQ) → 실행 가능한 PL/SQL 재현 스크립트(.sql) 생성 (사내 ZIOUI1)

  python make_replay.py 1676794 1840792
  - SQL_TEXT '{call PKG.PROC( 'v1', 'v2', …, NULL)}' 를 토큰 단위로 파싱('' 이스케이프 · NULL 처리)
  - ALL_ARGUMENTS 로 인자 이름·타입·IN/OUT 확인 → CLOB 은 4,000자 조각 APPEND, VARCHAR2 는 그대로, OUT REF CURSOR 는 변수
  - 검증: 생성 파일에서 다시 조립한 값 == 원본 인자(FIDELITY) · 호출을 IF 1=0 으로 막은 사본을 실제 실행(컴파일+조립)
"""
import sys, os, re, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "B_REPLAY"); os.makedirs(OUT, exist_ok=True)
CHUNK = 4000


def parse_call(t):
    m = re.match(r"\{call ([A-Z0-9_]+)\.([A-Z0-9_]+)\(", t)
    assert m, t[:100]
    pkg, proc = m.group(1), m.group(2)
    i, n, args = m.end(), len(t), []
    while True:
        while t[i] == " ":
            i += 1
        if t.startswith("NULL", i):
            args.append(None); i += 4
        elif t[i] == "'":
            j, buf = i + 1, []
            while True:
                k = t.index("'", j)
                if k + 1 < n and t[k + 1] == "'":
                    buf.append(t[j:k + 1]); j = k + 2
                else:
                    buf.append(t[j:k]); i = k + 1; break
            args.append("".join(buf))
        else:
            raise ValueError("unexpected token at %d: %r" % (i, t[i:i + 30]))
        while t[i] == " ":
            i += 1
        if t[i] == ",":
            i += 1; continue
        assert t[i:] == ")}", "tail %r" % t[i:i + 20]
        return pkg, proc, args


def q(s):
    return s.replace("'", "''")


def build(cur, seq):
    cur.execute("""SELECT SQL_TEXT, TO_CHAR(CREATE_DATE,'YYYY-MM-DD HH24:MI:SS'), CREATED_BY, ELAPSED_MS,
                          CASE WHEN EXCEPTION IS NULL THEN 'OK' ELSE 'EXCEPTION' END
                     FROM SCM_MGR.SCM_COM_SQL_LOG WHERE LOG_SEQ = :s""", s=seq)
    txt, created, by, ms, res = cur.fetchone()
    t = txt.read()
    pkg, proc, vals = parse_call(t)
    cur.execute("""SELECT POSITION, ARGUMENT_NAME, IN_OUT, DATA_TYPE FROM ALL_ARGUMENTS
                    WHERE OWNER='SCM_MGR' AND PACKAGE_NAME=:p AND OBJECT_NAME=:o AND DATA_LEVEL=0 ORDER BY POSITION""", p=pkg, o=proc)
    meta = cur.fetchall()
    assert len(meta) == len(vals), f"arg count {len(meta)} != log values {len(vals)}"
    rows = max((v.count("^") + 1 for v in vals if v), default=0)
    screen = re.search(r"DMF\d{4}", pkg).group(0)
    L = []
    o = L.append
    o(f"-- {screen} SAVE REPLAY — SCM_MGR.{pkg}.{proc}")
    o(f"-- 원본 LOG_SEQ={seq}  CREATED={created}  CREATED_BY={by}  ELAPSED_MS={ms}  RESULT={res}  SAVE_ROWS={rows}  SQL_LEN={len(t)}")
    o(f"-- 생성 {datetime.datetime.now():%Y-%m-%d %H:%M} · 사내 ZIOUI1 SCM_COM_SQL_LOG 원문 기준 (make_replay.py)")
    o("-- ⚠ 실행하면 실제로 저장된다(SP 내부 COMMIT). 접속 DB 를 확인하고 실행할 것")
    o("-- 실행: SQL*Plus / SQL Developer 스크립트 실행(F5). 맨 아래 REPLAY-END 줄까지 있어야 완전한 파일")
    o("SET SERVEROUTPUT ON SIZE UNLIMITED")
    o("SET DEFINE OFF")
    o("DECLARE")
    names = []
    for (pos, name, io, dt), v in zip(meta, vals):
        vn = "v_" + name.lower(); names.append((vn, name, io, dt, v))
        if io == "OUT":
            assert dt == "REF CURSOR" and v is None, (name, io, dt)
            o(f"    {vn} SYS_REFCURSOR;")
        elif dt == "CLOB":
            o(f"    {vn} CLOB;")
        else:
            assert v is None or len(v.encode("utf-8")) <= 32767, name
            o(f"    {vn} {dt}(32767);")
    o("    v_t0  TIMESTAMP;")
    o("    PROCEDURE print_rc(p_name VARCHAR2, p_rc IN OUT SYS_REFCURSOR) IS")
    o("        v_cur INTEGER; v_cnt INTEGER; v_desc DBMS_SQL.DESC_TAB2; v_val VARCHAR2(4000); v_line VARCHAR2(32767); v_n PLS_INTEGER := 0;")
    o("    BEGIN")
    o("        IF p_rc IS NULL OR NOT p_rc%ISOPEN THEN DBMS_OUTPUT.PUT_LINE(p_name || ' (not open)'); RETURN; END IF;")
    o("        v_cur := DBMS_SQL.TO_CURSOR_NUMBER(p_rc);")
    o("        DBMS_SQL.DESCRIBE_COLUMNS2(v_cur, v_cnt, v_desc);")
    o("        FOR c IN 1 .. v_cnt LOOP DBMS_SQL.DEFINE_COLUMN(v_cur, c, v_val, 4000); END LOOP;")
    o("        WHILE DBMS_SQL.FETCH_ROWS(v_cur) > 0 AND v_n < 50 LOOP")
    o("            v_n := v_n + 1; v_line := p_name;")
    o("            FOR c IN 1 .. v_cnt LOOP DBMS_SQL.COLUMN_VALUE(v_cur, c, v_val); v_line := v_line || ' | ' || v_desc(c).col_name || '=' || v_val; END LOOP;")
    o("            DBMS_OUTPUT.PUT_LINE(SUBSTR(v_line, 1, 4000));")
    o("        END LOOP;")
    o("        DBMS_SQL.CLOSE_CURSOR(v_cur);")
    o("    END;")
    o("BEGIN")
    for vn, name, io, dt, v in names:
        if io == "OUT":
            continue
        if dt == "CLOB":
            o(f"    DBMS_LOB.CREATETEMPORARY({vn}, TRUE);   -- {name} chars={0 if v is None else len(v)}")
            if v:
                for k in range(0, len(v), CHUNK):
                    o(f"    DBMS_LOB.APPEND({vn}, TO_CLOB('{q(v[k:k + CHUNK])}'));")
        else:
            o(f"    {vn} := {'NULL' if v is None else chr(39) + q(v) + chr(39)};   -- {name}")
    for vn, name, io, dt, v in names:
        if io != "OUT":
            ln = f"DBMS_LOB.GETLENGTH({vn})" if dt == "CLOB" else f"LENGTH({vn})"
            o(f"    DBMS_OUTPUT.PUT_LINE('{name:<20} len=' || NVL({ln}, 0) || ' tokens=' || CASE WHEN {vn} IS NULL THEN 0 ELSE REGEXP_COUNT({vn}, '\\^') + 1 END);")
    o("    v_t0 := SYSTIMESTAMP;")
    o(f"    SCM_MGR.{pkg}.{proc}(")
    o(",\n".join(f"        {vn}" for vn, *_ in names) + ");")
    o("    DBMS_OUTPUT.PUT_LINE('ELAPSED ' || TO_CHAR(SYSTIMESTAMP - v_t0));")
    for vn, name, io, dt, v in names:
        if io == "OUT":
            o(f"    print_rc('{name}', {vn});")
    o("END;")
    o("/")
    o(f"-- REPLAY-END rows={rows} params={len(vals)} LOG_SEQ={seq}")
    path = os.path.join(OUT, f"{screen}_SAVE_REPLAY_LOG{seq}.sql")
    open(path, "w", encoding="utf-8", newline="\n").write("\n".join(L) + "\n")

    # FIDELITY — 생성 파일에서 값 다시 조립
    gen = open(path, encoding="utf-8").read().split("\n")
    rebuilt = {}
    for l in gen:
        m = re.match(r"\s+DBMS_LOB\.APPEND\((v_\w+), TO_CLOB\('(.*)'\)\);$", l)
        if m:
            rebuilt.setdefault(m.group(1), []).append(m.group(2).replace("''", "'"))
        m = re.match(r"\s+(v_\w+) := '(.*)';   -- ", l)
        if m:
            rebuilt[m.group(1)] = [m.group(2).replace("''", "'")]
    bad = [n for vn, n, io, dt, v in names if io != "OUT" and "".join(rebuilt.get(vn, [])) != (v or "")]
    print(f"{screen} LOG_SEQ={seq} rows={rows} params={len(vals)} file={os.path.getsize(path):,}B lines={len(gen)} FIDELITY={'PASS' if not bad else 'FAIL ' + str(bad)}")

    # DRY — 호출을 IF 1=0 으로 막은 사본 실행 (조립 + 컴파일 검증, 저장 안 함)
    src = "\n".join(gen)
    blk = src[src.index("DECLARE"): src.index("\n/\n")]
    blk = blk.replace("    v_t0 := SYSTIMESTAMP;", "    IF 1 = 0 THEN\n    v_t0 := SYSTIMESTAMP;", 1)
    blk = blk[: blk.rindex("END;")] + "    END IF;\nEND;"
    cur.callproc("dbms_output.enable", [None])
    cur.execute(blk)
    chunk, n = cur.arrayvar(str, 100), cur.var(int)
    n.setvalue(0, 100); cur.callproc("dbms_output.get_lines", [chunk, n])
    for x in chunk.getvalue()[: n.getvalue()]:
        print("   DRY", x)
    return path


if __name__ == "__main__":
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','DB_NAME') FROM DUAL"); print("DB", cur.fetchone())
    for s in sys.argv[1:]:
        build(cur, int(s))
