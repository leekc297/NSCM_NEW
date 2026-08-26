# -*- coding: utf-8 -*-
"""④ 선행축소 축 실측: 원장 VERSION_NO 컬럼 유무 / VERPUSH 기적용 문장 / 상위 문장 구동원천·술어 (읽기 전용)."""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

print("=== ④-a 원장 VERSION_NO 컬럼 유무 (좌표축: 버전으로 선행축소 가능한가) ===")
for t in ("DM_PLN_MKT_FCST", "DM_PLN_MKT_FCST_C", "DM_PLN_CFM_MKT_DEMAND_PLAN",
          "DM_PLN_CFM_MKT_DEMAND_PLAN_C", "DM_PLN_MKT_FCST_RESULT", "DM_PLN_MKT_FCST_RESULT_C"):
    cur.execute("""SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                    AND TABLE_NAME=:t AND COLUMN_NAME='VERSION_NO'""", {"t": t})
    has = cur.fetchone()[0]
    cur.execute("SELECT NUM_ROWS FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t", {"t": t})
    n = cur.fetchone()
    print(f"  {t:<32} VERSION_NO={'있음' if has else '없음'}  rows={n[0] if n else '?'}")

cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = [(ln, t.rstrip("\n")) for ln, t in cur.fetchall()]
TXT = {ln: t for ln, t in src}

print("\n=== ④-b VERPUSH 기적용 위치 vs 미적용 UNION ALL 분기 ===")
for ln, t in src:
    if "GT_DM35_VERSION)" in t and "IN (SELECT" in t.upper():
        print(f"  [적용] L{ln}: {t.strip()[:110]}")
print("  --- 원장 _C 를 직접 구동하는 FROM 절 전수 (버전 술어 유무 판정) ---")
for ln, t in src:
    m = re.search(r"FROM\s+SCM_MGR\.(DM_PLN_MKT_FCST_C|DM_PLN_CFM_MKT_DEMAND_PLAN_C|DM_PLN_MKT_FCST_RESULT_C)\b", t, re.I)
    if m and not t.strip().startswith("--"):
        nxt = " ".join(TXT.get(ln + k, "") for k in range(1, 4))
        pushed = "VERSION_NO IN (SELECT" in nxt.upper() or "VERSION_NO IN (SELECT" in t.upper()
        print(f"  L{ln:>5} {m.group(1):<30} 버전푸시={'O' if pushed else '⛔X'}   {t.strip()[:70]}")

print("\n=== ④-c 매 호출 무조건 적재되는 대형 GTT 문장 (조회조건 축소 미반영 여부) ===")
for s, e, name in ((2041, 2062, "GT_DM35_ITEM_SINGLE_ORI"), (2072, 2098, "GT_DM35_ITEM_SINGLE_A"),
                   (2108, 2119, "GT_DM35_ITEM_SINGLE_B"), (2827, 2850, "GT_DM35_TEMP_SCM_SITE"),
                   (648, 712, "GT_DM35_T_LAST_SETUP")):
    print(f"\n  --- L{s}-{e} {name} ---")
    for ln in range(s, e + 1):
        t = TXT.get(ln, "")
        st = t.strip()
        if re.search(r"\b(FROM|JOIN|WHERE|AND|GROUP BY)\b", st, re.I) and not st.startswith("--"):
            print(f"    L{ln}: {st[:130]}")
con.close()
