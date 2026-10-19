"""패키지 SQL 리허설 실행기 (사내 ZIOUI1) — SQL*Plus 형식 파일을 문장 단위로 실행하고 결과를 _rehearsal_out/ 에 남긴다.

  SET / COLUMN 줄은 건너뛴다 · PL/SQL 블록은 '/' 단독 줄까지 · 일반 SQL 은 줄 끝 ';' 까지 · DBMS_OUTPUT 출력 포함
  python run_rehearsal.py 99_ROLLBACK_AUTHUNION_PATCH.sql 00_PRECHECK_CLOUD.sql ...
"""
import sys, os
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "_rehearsal_out")


def split(txt):
    stmts, buf, plsql = [], [], False
    for line in txt.split("\n"):
        s = line.strip()
        if not buf:
            if not s or s.startswith("--") or s.upper().startswith(("SET ", "COLUMN ")):
                continue
            plsql = s.upper().startswith(("DECLARE", "BEGIN"))
        if plsql:
            if s == "/":
                stmts.append("\n".join(buf)); buf = []
            else:
                buf.append(line)
        else:
            buf.append(line)
            if s.endswith(";"):
                stmts.append("\n".join(buf).rstrip().rstrip(";")); buf = []
    assert not buf, "끝나지 않은 문장: " + "\n".join(buf)[:200]
    return stmts


def run(cur, fname, seq):
    txt = open(os.path.join(HERE, "A_DB", fname), encoding="utf-8").read()
    lines = []
    cur.callproc("dbms_output.enable", [None])
    for st in split(txt):
        try:
            cur.execute(st)
            if cur.description:
                cols = [c[0] for c in cur.description]
                rows = cur.fetchall()
                lines.append(" | ".join(cols))
                for r in rows:
                    lines.append(" | ".join("" if v is None else str(v) for v in r))
                lines.append(f"({len(rows)} rows)")
        except oracledb.DatabaseError as e:
            lines.append("ERROR " + str(e).replace("\n", " / "))
        chunk, n = cur.arrayvar(str, 100), cur.var(int)
        while True:
            n.setvalue(0, 100)
            cur.callproc("dbms_output.get_lines", [chunk, n])
            got = chunk.getvalue()[: n.getvalue()]
            lines.extend(x or "" for x in got)
            if n.getvalue() < 100:
                break
        lines.append("")
    os.makedirs(OUT, exist_ok=True)
    path = os.path.join(OUT, f"{seq:02d}_{fname[:-4]}.out.txt")
    open(path, "w", encoding="utf-8", newline="\n").write("\n".join(lines))
    print(f"== {seq:02d} {fname}")
    for l in lines:
        if l and not l.startswith(("L3 키", "V3 줄")) or l.startswith("ERROR"):
            print("  ", l[:230])


def main():
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-RR' NLS_DATE_LANGUAGE='AMERICAN'")
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
    print("DB", d, cur.fetchone())
    for i, f in enumerate(sys.argv[1:], 1):
        run(cur, f, i)


if __name__ == "__main__":
    main()
