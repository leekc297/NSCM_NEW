import sys, re, pathlib
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from parse_check import declared_names, statements_with_group_by, bindify
import ora, oracledb
cases = [("fresh_all/DMF0020_GET_SCM_MST_FUTURE_PRICE.PROCEDURE.sql", 345), ("fresh_all/PKG_SCP0013.PACKAGE_BODY.sql", 2607),
         ("fresh_all/PR_DM_PLN_SALES_PLAN_RESULT_MOVE.PROCEDURE.sql", 60), ("fresh_all/PKG_DMF0045.PACKAGE_BODY.sql", 311)]
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    for f, want in cases:
        src = (HERE / f).read_text(encoding="utf-8", errors="ignore"); names = declared_names(src)
        s, st = statements_with_group_by(src)
        for a, b, text, seg in st:
            line = s.count("\n", 0, a) + 1
            if line == want:
                sql = bindify(seg, s, names)
                gb = sql.upper().find("GROUP BY")
                print(f"\n##### {f} L{line} len={len(sql)} binds={sql.count(':B_')}")
                print("...SELECT head:", re.sub(r"\s+", " ", sql[:400]))
                print("...GROUP BY tail:", re.sub(r"\s+", " ", sql[gb:gb + 900]) if gb >= 0 else "(no GROUP BY found in bindified text!)")
                try:
                    cur.execute("DECLARE c INTEGER; BEGIN c := DBMS_SQL.OPEN_CURSOR; DBMS_SQL.PARSE(c, :sql, DBMS_SQL.NATIVE); DBMS_SQL.CLOSE_CURSOR(c); END;", sql=sql)
                    print("PARSE -> OK")
                except Exception as e:
                    print("PARSE ->", str(e)[:300])

