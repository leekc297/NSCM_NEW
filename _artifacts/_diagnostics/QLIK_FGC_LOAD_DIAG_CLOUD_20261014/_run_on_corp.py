# -*- coding: utf-8 -*-
"""클라우드 점검 SQL 을 사내 ZIOUI1 에서 그대로 실행해 문법·권한 검증 + 사내 기준값 채취 (READ-ONLY 스크립트 전용).

SQL*Plus 스크립트를 단순 해석: SET/COLUMN/SPOOL/DEFINE/UNDEFINE/SHOW 행 무시, PROMPT 출력,
PL/SQL 블록(DECLARE/BEGIN ~ '/' 행) · 일반 SQL(';' 종결) 실행, &&VAR/&VAR 는 -D VAR=값 으로 치환.
사용: python _run_on_corp.py C01_ENV_STATE.sql [-D SQL_ID=xxxx] > out.txt
"""
import io, re, sys, pathlib
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

path = sys.argv[1]
_raw = pathlib.Path(path).read_text(encoding="utf-8")
_bad = [(i + 1, l) for i, l in enumerate(_raw.splitlines()) if "&" in l or chr(9) in l]
for _n, _l in _bad:
    print(f"!!! ERROR: 줄 {_n} 에 & 또는 탭 문자 (클라우드 F5 금지): {_l[:120]}")
defs = {}
for i, a in enumerate(sys.argv):
    if a == "-D":
        k, v = sys.argv[i + 1].split("=", 1); defs[k.upper()] = v

u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 3600000
cur = cn.cursor()
cur.callproc("DBMS_OUTPUT.ENABLE", [None])


def subst(s):
    return re.sub(r"&&?(\w+)\.?", lambda m: defs.get(m.group(1).upper(), m.group(0)), s)


def flush_output():
    lv, st = cur.var(str), cur.var(int)
    while True:
        cur.callproc("DBMS_OUTPUT.GET_LINE", (lv, st))
        if st.getvalue() != 0:
            break
        print(lv.getvalue() or "")


def run(stmt):
    stmt = subst(stmt).strip()
    if not stmt:
        return
    try:
        cur.execute(stmt)
        if cur.description:
            cols = [c[0] for c in cur.description]
            rows = cur.fetchall()
            w = [max(len(str(c)), *(len(str(r[i])) for r in rows)) if rows else len(str(c)) for i, c in enumerate(cols)]
            w = [min(x, 110) for x in w]
            print(" | ".join(str(c).ljust(w[i]) for i, c in enumerate(cols)))
            print("-+-".join("-" * x for x in w))
            for r in rows:
                print(" | ".join(str(v if v is not None else "")[:110].ljust(w[i]) for i, v in enumerate(r)))
            print(f"({len(rows)} rows)")
        flush_output()
    except oracledb.Error as e:
        flush_output()
        print(f"!!! ERROR: {e}\n--- stmt head: {stmt[:200]}")


lines = pathlib.Path(path).read_text(encoding="utf-8").splitlines()
buf, in_plsql = [], False
for ln in lines:
    s = ln.strip()
    up = s.upper()
    if not in_plsql and not buf:
        if up.startswith(("SET ", "COLUMN ", "SPOOL", "DEFINE", "UNDEFINE", "SHOW ", "WHENEVER", "CLEAR", "TTITLE", "BREAK")) or up in ("SET", ""):
            continue
        if up.startswith("PROMPT"):
            print(subst(s[6:].strip())); continue
        if s.startswith("--"):
            continue
        if up.startswith(("DECLARE", "BEGIN")):
            in_plsql = True
    if in_plsql:
        if s == "/":
            run("\n".join(buf)); buf, in_plsql = [], False
        else:
            buf.append(ln)
        continue
    buf.append(ln)
    code = re.sub(r"--.*$", "", ln).rstrip()
    if code.endswith(";"):
        stmt = "\n".join(buf).rstrip()
        stmt = stmt[: stmt.rfind(";")]
        run(stmt); buf = []
if buf:
    run("\n".join(buf))
cn.rollback()
cn.close()
