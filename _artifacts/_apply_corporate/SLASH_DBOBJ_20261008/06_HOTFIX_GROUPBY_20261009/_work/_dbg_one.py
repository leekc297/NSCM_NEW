"""Debug one statement: python _dbg_one.py <file> <line>  → declared names sample, bindified select part, parse code"""
import sys, re, pathlib
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from parse_check import declared_names, statements_with_group_by, bindify, select_part, _code
import ora, oracledb
f, want = sys.argv[1], int(sys.argv[2])
src = (HERE / f).read_text(encoding="utf-8", errors="ignore"); names = declared_names(src)
print("declared:", len(names), sorted(names)[:40])
s, st = statements_with_group_by(src)
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    for a, b, text, seg in st:
        line = s.count("\n", 0, a) + 1
        if line != want:
            continue
        sql = bindify(seg, s, names)
        sql = re.sub(r"\bBULK\s+COLLECT\s+INTO\s+:B_\w+(\s*,\s*:B_\w+)*", "", sql, flags=re.I)
        sql = re.sub(r"\bINTO\s+:B_\w+(\s*,\s*:B_\w+)*\s+FROM\b", " FROM", sql, flags=re.I)
        sel = select_part(sql)
        print("SELECT PART head:", re.sub(r"\s+", " ", sel[:300]))
        print("SELECT PART tail:", re.sub(r"\s+", " ", sel[-400:]))
        try:
            cur.execute("DECLARE c INTEGER; BEGIN c := DBMS_SQL.OPEN_CURSOR; DBMS_SQL.PARSE(c, :sql, DBMS_SQL.NATIVE); DBMS_SQL.CLOSE_CURSOR(c); END;", sql=sel); print("CODE: OK")
        except Exception as e:
            print("CODE:", _code(e), "|", str(e)[:200])
