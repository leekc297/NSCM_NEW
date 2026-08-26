# -*- coding: utf-8 -*-
"""INSERT#1 SELECT 부 를 원문 그대로 떼어내 EXPLAIN PLAN 대조 (읽기 전용, DB 무변경).

  BEFORE = 라이브 원문
  AFTER  = 각 UNION ALL 분기에 버전 술어 push (VERPUSH)
access predicate 에 VERSION_NO 가 실제로 등장하는지를 구조 근거로 확인한다.
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_VERPUSH_20260820"
src = open(BASE + r"\00_BACKUP_PKG_DMF0035_BODY.sql", encoding="utf-8").read().splitlines()

# INSERT#1 의 SELECT 부 = L1527 ~ L1593 (1-based). 말미 ';' 제거.
sel = "\n".join(src[1526:1593])
assert sel.lstrip().startswith("SELECT X.VERSION_NO"), sel[:60]
sel = sel.rstrip().rstrip(";")
sel = sel.replace("P_DIVISION_ID", ":DIV")

VP = "AND F.VERSION_NO IN (SELECT VERSION_NO FROM SCM_MGR.GT_DM35_VERSION)"
after = sel
for tbl in ("SCM_MGR.DM_PLN_MKT_FCST_C F WHERE (CASE WHEN :DIV = '40' THEN 1 ELSE 2 END) = 2",
            "SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C F WHERE (CASE WHEN :DIV = '40' THEN 1 ELSE 2 END) = 1"):
    assert after.count(tbl) == 1, tbl
    after = after.replace(tbl, tbl + " " + VP)
old3 = "            FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A\n"
assert after.count(old3) == 1
after = after.replace("            WHERE A.DIVISION_ID = :DIV\n            AND   A.QTY <> 0\n            GROUP BY A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE\n        ) X",
                      "            WHERE A.DIVISION_ID = :DIV\n            AND   A.QTY <> 0\n            AND   A.VERSION_NO IN (SELECT VERSION_NO FROM SCM_MGR.GT_DM35_VERSION)\n            GROUP BY A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE\n        ) X")
assert after.count("GT_DM35_VERSION)") == 3, after.count("GT_DM35_VERSION)")

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
for tag, sql in (("BEFORE", sel), ("AFTER", after)):
    cur.execute(f"EXPLAIN PLAN SET STATEMENT_ID = '{tag}' FOR " + sql, {"DIV": "40"})
    cur.execute("""SELECT ID, LPAD(' ',DEPTH)||OPERATION||' '||NVL(OPTIONS,'') OP, OBJECT_NAME,
                          CARDINALITY, ACCESS_PREDICATES
                     FROM PLAN_TABLE WHERE STATEMENT_ID=:s ORDER BY ID""", {"s": tag})
    print(f"\n########## {tag} ##########")
    for i, op, obj, card, acc in cur.fetchall():
        acc = (acc.read() if hasattr(acc, "read") else acc) or ""
        if obj and ("DM_PLN_" in obj or "GT_DM35_VERSION" in obj) or "SEMI" in op or "UNION" in op:
            print(f"  {i:>3} {op:<44} {str(obj):<42} card={card}")
            if acc:
                print(f"        ACCESS: {acc[:200]}")
    cur.execute("DELETE FROM PLAN_TABLE WHERE STATEMENT_ID=:s", {"s": tag})
con.commit()
con.close()
