#!/usr/bin/env python3
"""
ora.py — Claude Code 용 Oracle one-shot CLI (python-oracledb thin — Oracle Client 불필요)

설치(1회):  pip install oracledb --break-system-packages  (또는 pip install oracledb)
접속 정보:  환경변수 NSCM_ORA_USER / NSCM_ORA_PASS / NSCM_ORA_DSN
            예) NSCM_ORA_DSN=10.20.100.153:2521/ESSCMD   (사내)
                NSCM_ORA_DSN=localhost:1521/FREEPDB1      (로컬 Docker)
            없으면 프로젝트 루트 .env.asis 의 TOBE_DB_* 를 사용 (로컬 기본)

사용:
  python ora.py query "SELECT object_name FROM user_objects WHERE status='INVALID'"
  python ora.py exec  path/to/file.sql           # 스크립트 실행 (;/  / 구분 단순 분할)
  python ora.py invalid                          # INVALID object 목록
  python ora.py errors [OBJECT_NAME]             # USER_ERRORS
  python ora.py compile OBJECT_NAME              # ALTER ... COMPILE + 에러 리포트
  python ora.py args PKG_OR_PROC_NAME            # ALL_ARGUMENTS (PROC_M 대조용)
  python ora.py desc TABLE_NAME                  # 컬럼 인벤토리

참조: Doc/_dev_rules/32_CLAUDE_ORACLE_DIRECT.md / oracle-db-workflow.md §0-H
"""
import os, sys, pathlib

def conn_info():
    u, p, d = os.getenv("NSCM_ORA_USER"), os.getenv("NSCM_ORA_PASS"), os.getenv("NSCM_ORA_DSN")
    if not (u and p and d):
        root = pathlib.Path(__file__).resolve().parents[2]
        env = root / ".env.asis"
        if env.exists():
            kv = {}
            for line in env.read_text(encoding="utf-8", errors="ignore").splitlines():
                if "=" in line and not line.strip().startswith("#"):
                    k, v = line.split("=", 1); kv[k.strip()] = v.strip()
            u = u or kv.get("TOBE_DB_USER"); p = p or kv.get("TOBE_DB_PASS")
            if kv.get("TOBE_DB_HOST"):
                d = d or f"{kv.get('TOBE_DB_HOST','localhost')}:{kv.get('TOBE_DB_PORT','1521')}/{kv.get('TOBE_DB_PDB','FREEPDB1')}"
    # fallback: 기존 apply.sh 의 CONN 문자열에서 접속정보 파싱 (새 평문 사본 미생성)
    #   형식: CONN='SCM_MGR/"pwd"@host:port/SID'
    if not (u and p and d):
        import re
        apply = pathlib.Path(__file__).resolve().parents[1] / "_apply_corporate" / "apply.sh"
        if apply.exists():
            m = re.search(r"CONN=['\"]?([^/]+)/\"?([^\"@]+)\"?@([^'\"\s]+)", apply.read_text(encoding="utf-8", errors="ignore"))
            if m:
                u = u or m.group(1); p = p or m.group(2); d = d or m.group(3)
    if not (u and p and d):
        sys.exit("ERROR: NSCM_ORA_USER/PASS/DSN 환경변수 또는 .env.asis 또는 apply.sh CONN 필요")
    return u, p, d

def fetch(cur, sql, binds=None):
    cur.execute(sql, binds or {})
    if cur.description is None:
        return None, None
    cols = [c[0] for c in cur.description]
    return cols, cur.fetchall()

def show(cols, rows, limit=None):  # 전량 출력 기본 (2026-08-08 — 조용한 절단 제거)
    if cols is None:
        print("(no result set)"); return
    lim = len(rows) if limit is None else limit
    w = [max(len(str(c)), *(len(str(r[i])) for r in rows[:lim])) if rows else len(str(c)) for i, c in enumerate(cols)]
    print(" | ".join(str(c).ljust(w[i]) for i, c in enumerate(cols)))
    print("-+-".join("-" * x for x in w))
    for r in rows[:lim]:
        print(" | ".join(str("" if v is None else v).ljust(w[i]) for i, v in enumerate(r)))
    print(f"({len(rows)} rows" + (f' — {lim} 표시 · ⚠ {len(rows)-lim} 행 생략' if len(rows) > lim else '') + ')')

def main():
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(1)
    try:
        import oracledb
    except ImportError:
        sys.exit("ERROR: pip install oracledb 필요")
    cmd, arg = sys.argv[1], (sys.argv[2] if len(sys.argv) > 2 else None)
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        if cmd == "query":
            show(*fetch(cur, arg.rstrip().rstrip(";")))
        elif cmd == "exec":
            text = pathlib.Path(arg).read_text(encoding="utf-8", errors="ignore").replace("\r", "")
            # PL/SQL 블록은 '/' 단독 라인, 일반 SQL 은 ';' 종결 — 단순 분할
            stmts, buf, plsql = [], [], False
            for line in text.splitlines():
                ls = line.strip()
                if not plsql and ls.upper().startswith(("BEGIN", "DECLARE", "CREATE OR REPLACE")):
                    plsql = True
                if plsql and ls == "/":
                    stmts.append("\n".join(buf)); buf, plsql = [], False; continue
                if not plsql and ls.endswith(";"):
                    buf.append(line.rstrip().rstrip(";")); stmts.append("\n".join(buf)); buf = []; continue
                if ls or buf:
                    buf.append(line)
            if [s for s in buf if s.strip()]:
                stmts.append("\n".join(buf))
            for i, s in enumerate(s for s in stmts if s.strip()):
                try:
                    cur.execute(s)
                    print(f"[{i+1}] OK")
                except Exception as e:
                    print(f"[{i+1}] FAIL: {e}\n--- stmt head: {s.strip()[:120]}")
            con.commit()
        elif cmd == "invalid":
            show(*fetch(cur, "SELECT object_type, object_name FROM user_objects WHERE status='INVALID' ORDER BY 1,2"))
        elif cmd == "errors":
            sql = "SELECT name, type, line, position, text FROM user_errors" + (" WHERE name = UPPER(:n)" if arg else "") + " ORDER BY name, sequence"
            show(*fetch(cur, sql, {"n": arg} if arg else None))
        elif cmd == "compile":
            cur.execute("SELECT object_type FROM user_objects WHERE object_name = UPPER(:n) AND object_type IN ('PACKAGE','PROCEDURE','FUNCTION')", {"n": arg})
            row = cur.fetchone()
            if not row: sys.exit(f"object not found: {arg}")
            cur.execute(f"ALTER {row[0]} {arg} COMPILE")
            if row[0] == "PACKAGE":
                try: cur.execute(f"ALTER PACKAGE {arg} COMPILE BODY")
                except Exception as e: print(f"BODY: {e}")
            show(*fetch(cur, "SELECT object_type, status FROM user_objects WHERE object_name = UPPER(:n)", {"n": arg}))
            show(*fetch(cur, "SELECT line, position, text FROM user_errors WHERE name = UPPER(:n) ORDER BY sequence", {"n": arg}))
        elif cmd == "args":
            show(*fetch(cur, """SELECT NVL(package_name,'-') pkg, object_name, position, argument_name, data_type, in_out
                                FROM user_arguments WHERE object_name = UPPER(:n) OR package_name = UPPER(:n)
                                ORDER BY package_name, object_name, position""", {"n": arg}))
        elif cmd == "desc":
            show(*fetch(cur, """SELECT column_name, data_type, data_length, nullable
                                FROM user_tab_columns WHERE table_name = UPPER(:n) ORDER BY column_id""", {"n": arg}))
        else:
            print(__doc__); sys.exit(1)

if __name__ == "__main__":
    main()
