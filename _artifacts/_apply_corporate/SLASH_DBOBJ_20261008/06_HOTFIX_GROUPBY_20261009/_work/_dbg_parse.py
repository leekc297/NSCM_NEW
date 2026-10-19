import sys, re, pathlib
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from parse_check import declared_names, statements_with_group_by, bindify
import ora, oracledb
src = open(HERE / "../../01_NEW_corp/PKG_DMF0020.PACKAGE_BODY.sql", encoding="utf-8").read()
names = declared_names(src)
print("declared names:", len(names), sorted(n for n in names if n.startswith("P_FROM") or n in ("P_DIVISION_ID", "V_GROUP_ID"))[:5])
s, st = statements_with_group_by(src)
print("stmts:", len(st), "lines:", [s.count("\n", 0, a) + 1 for a, b, t, g in st][:40])
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    for a, b, text, seg in st:
        line = s.count("\n", 0, a) + 1
        if 5035 <= line <= 5045 or 5125 <= line <= 5135:
            sql = bindify(seg, s, names)
            print("LINE", line); print(sql[:1800])
            try:
                cur.execute("DECLARE c INTEGER; BEGIN c := DBMS_SQL.OPEN_CURSOR; DBMS_SQL.PARSE(c, :sql, DBMS_SQL.NATIVE); DBMS_SQL.CLOSE_CURSOR(c); END;", sql=sql)
                print("DBMS_SQL.PARSE -> OK")
            except Exception as e:
                print("DBMS_SQL.PARSE ->", str(e)[:300])
            try:
                cur.parse(sql); print("cursor.parse -> OK")
            except Exception as e:
                print("cursor.parse ->", str(e)[:300])
