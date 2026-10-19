"""Re-fix PKG_DMF0044 on the other worker's new version (DB 15:00:45+). FRESH-GATE: re-read DB source now, compare with
PKG_DMF0044.BODY.db_150045.sql; if changed, refresh the base before fixing. Output: pending_PKG_DMF0044_refix.sql (NOT applied)."""
import sys, pathlib, subprocess, json
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
from groupby_fix import fix
from parse_check import parse_all

u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name='PKG_DMF0044' AND object_type='PACKAGE BODY'")
    st, ddl = cur.fetchone(); print("FRESH-GATE PKG_DMF0044 now:", st, ddl)
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0044' AND type='PACKAGE BODY' ORDER BY line")
    now = "".join(r[0] for r in cur.fetchall())
    base = (HERE / "PKG_DMF0044.BODY.db_150045.sql")
    if base.read_text(encoding="utf-8") != now:
        print("  base changed since 15:00:45 snapshot → refreshing base"); base.write_text(now, encoding="utf-8")
    bak = (HERE / "../../00_BACKUP_corp/PKG_DMF0044.PACKAGE_BODY.sql").read_text(encoding="utf-8", errors="ignore")
    out, applied, unresolved = fix(bak, now)
    print("auto-fix applied:", len(applied), "unresolved:", len(unresolved))
    for a in sorted(applied, key=lambda a: a["obj_line"]): print(f"   FIX L{a['obj_line']}: {a['old'][:70]} => {a['new'][:70]}")
    for r, why in unresolved: print(f"   UNRESOLVED L{r['line']} (GROUP BY L{r['group_by_line']}): {r['item'][:70]} | {why[:80]}")
    # CASE statement: GROUP BY NVL(A.CURRENCY,'/') → full CASE expr (same as 14:42 hotfix)
    L = out.split("\n"); done = 0
    for i, l in enumerate(L):
        if l.strip().startswith(", A.FCST_TYPE, A.INCOTERMS, NVL(A.CURRENCY, '/'), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID") and any("CASE WHEN( NVL(A.CURRENCY, '/') = '/' ) THEN ''" in L[j] for j in range(max(0, i - 30), i)):
            L[i] = l.replace("NVL(A.CURRENCY, '/')", "CASE WHEN( NVL(A.CURRENCY, '/') = '/' ) THEN '' ELSE NVL(NULLIF(RTRIM(A.CURRENCY),''), '/') END /* [E20261009-GRPBYFIX] GROUP BY 식 = SELECT 식 */", 1); done += 1
            print("   FIX(CASE) L", i + 1)
    out = "\n".join(L)
    (HERE / "pending_PKG_DMF0044_refix.sql").write_text(out, encoding="utf-8")
    rb = parse_all(cur, now); ra = parse_all(cur, out)
    print("parse ORA-00979: base", [x[0] for x in rb if "00979" in x[1]], "→ refix", [x[0] for x in ra if "00979" in x[1]], "| markers:", out.count("[E20261009-GRPBYFIX]"))
    json.dump({"base_status": st, "base_ddl": ddl, "fixes": len(applied) + done, "unresolved": len(unresolved), "ora979_base": len([x for x in rb if "00979" in x[1]]), "ora979_refix": len([x for x in ra if "00979" in x[1]])}, open(HERE / "pending_PKG_DMF0044_refix.json", "w"), indent=1)
