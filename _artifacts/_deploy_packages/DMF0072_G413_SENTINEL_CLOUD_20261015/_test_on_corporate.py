#!/usr/bin/env python3
"""
클라우드 패키지 실행 검증 (사내 ZIOUI1) — 파일 전체 F5 모사.
순서: 99_ROLLBACK → DB==ORIG → 00_PRECHECK → 01_APPLY → DB==PATCH → 01_APPLY 재실행(SKIP) → DB==PATCH
FRESH-GATE: 시작 시 사내 원문 == G413 적용본(PATCH) 이어야 진행. ALL_SOURCE 재조회로 매 단계 판정.
문장 분할: PL/SQL 블록은 '/' 단독 줄 종결, SELECT 는 ';' 종결 (클라이언트 스크립트 실행과 동일 단위).
"""
import sys, re, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "_diagnostics"))
import ora  # noqa: E402
import oracledb  # noqa: E402
from build_cloud_pkg import OBJS, SRC, body_lines  # noqa: E402

HERE = pathlib.Path(__file__).resolve().parent


def stmts(path):
    t = path.read_text(encoding="utf-8")
    t = "\n".join(l for l in t.splitlines() if not l.startswith("--"))
    out = []
    plsql, rest = (t.split("\n/\n", 1) + [""])[:2] if "\nEND;\n/" in t else ("", t)
    if plsql:
        out.append(("PLSQL", plsql.strip()))
    # ';' 분할 — 작은따옴표 리터럴 안의 ';' 는 무시 (클라이언트 스크립트 분리기와 동일)
    buf, inq = "", False
    for ch in rest:
        if ch == "'":
            inq = not inq
        if ch == ";" and not inq:
            if buf.strip():
                out.append(("SQL", buf.strip()))
            buf = ""
        else:
            buf += ch
    assert not inq and not buf.strip(), "미종결 문장"
    return out


def run(cur, path):
    print(f"--- RUN {path.name}")
    for kind, s in stmts(path):
        if kind == "PLSQL":
            cur.callproc("DBMS_OUTPUT.ENABLE", [None])
            cur.execute(s)
            line, status = cur.var(str), cur.var(int)
            while True:
                cur.callproc("DBMS_OUTPUT.GET_LINE", (line, status))
                if status.getvalue() != 0:
                    break
                print("   ", line.getvalue())
        else:
            cur.execute(s)
            cols = [c[0] for c in cur.description]
            print("   ", " | ".join(cols))
            for r in cur.fetchall():
                print("   ", " | ".join(str(x) for x in r))


def db_equals(cur, which):
    ok = True
    for name, typ, tag, _ in OBJS:
        ref = "".join(body_lines(SRC / f"{which}_{tag}.sql")).rstrip()
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ)
        db = "".join(r[0] for r in cur.fetchall()).rstrip()
        cur.execute("SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
        st = cur.fetchone()[0]
        print(f"    {name}: DB=={which} {db == ref} / {st}")
        ok &= (db == ref and st == "VALID")
    return ok


def main():
    u, p, d = ora.conn_info()
    cur = oracledb.connect(user=u, password=p, dsn=d).cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL")
    print("DB SERVER_HOST =", cur.fetchone()[0])
    print("[FRESH-GATE] 시작 상태 == PATCH"); assert db_equals(cur, "PATCH")
    run(cur, HERE / "99_ROLLBACK.sql"); print("[CHECK] == ORIG"); assert db_equals(cur, "ORIG")
    run(cur, HERE / "00_PRECHECK.sql")
    run(cur, HERE / "01_APPLY.sql"); print("[CHECK] == PATCH"); assert db_equals(cur, "PATCH")
    run(cur, HERE / "01_APPLY.sql"); print("[CHECK 재실행] == PATCH"); assert db_equals(cur, "PATCH")
    run(cur, HERE / "00_PRECHECK.sql")
    print("ALL PASS")


if __name__ == "__main__":
    main()
