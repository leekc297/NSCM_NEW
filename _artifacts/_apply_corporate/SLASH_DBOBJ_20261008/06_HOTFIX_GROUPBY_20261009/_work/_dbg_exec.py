"""Execute (not only parse) the SELECT part of suspicious statements with dummy binds, rollback. Definitive ORA-00979 check."""
import sys, re, pathlib
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from parse_check import declared_names, statements_with_group_by, bindify
import ora, oracledb
cases = [("fresh_all/DMF0020_GET_SCM_MST_FUTURE_PRICE.PROCEDURE.sql", 248), ("fresh_all/DMF0020_GET_SCM_MST_FUTURE_PRICE.PROCEDURE.sql", 345),
         ("fresh_all/PKG_SCP0013.PACKAGE_BODY.sql", 2607), ("fresh_all/PR_DM_PLN_SALES_PLAN_RESULT_MOVE.PROCEDURE.sql", 60),
         ("fresh_all/PKG_DMF0045.PACKAGE_BODY.sql", 311), ("fresh_all/PKG_SSP0045.PACKAGE_BODY.sql", 314), ("fresh_all/PR_SSP_ANL_SHIPMENT_PLAN_FG.PROCEDURE.sql", 1384),
         ("PKG_DMF0020.BODY.broken_1726.sql", 5131)]
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    for f, want in cases:
        src = (HERE / f).read_text(encoding="utf-8", errors="ignore"); names = declared_names(src)
        s, st = statements_with_group_by(src)
        for a, b, text, seg in st:
            line = s.count("\n", 0, a) + 1
            if line != want:
                continue
            sql = bindify(seg, s, names)
            # SELECT part only: after INSERT INTO t (...) → first top-level SELECT
            m = re.search(r"\)\s*(SELECT\b)", sql, re.I)
            sel = sql[m.start(1):] if m and sql.upper().startswith("INSERT") else sql
            binds = sorted(set(re.findall(r":B_\w+", sel)))
            vals = {b[1:]: ("20261001" if "YYYYMMDD" in b or "DATE" in b else "40" if "DIVISION" in b else "X") for b in binds}
            print(f"\n##### {f} L{line} binds={binds}")
            # parse only
            try:
                cur.parse(sel); pr = "parse OK"
            except Exception as e:
                pr = "parse " + str(e)[:80]
            # execute with ROWNUM guard to keep it cheap
            try:
                cur.execute("SELECT * FROM (" + sel + ") WHERE ROWNUM <= 1", vals); r = cur.fetchall(); ex = f"exec OK rows={len(r)}"
            except Exception as e:
                ex = "exec " + str(e)[:120]
            print("   ", pr, "|", ex)
    c.rollback()
