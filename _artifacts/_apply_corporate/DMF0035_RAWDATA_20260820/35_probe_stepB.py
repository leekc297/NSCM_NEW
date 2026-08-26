# -*- coding: utf-8 -*-
"""STEP B 대상 5지점 개별 확인 — 별칭 / 기존 WHERE / GT_DM35_VERSION 내부조인 존재(등가성 근거)."""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_RAWDATA_20260820"
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = [(ln, t.rstrip("\n")) for ln, t in cur.fetchall()]
open(BASE + r"\02_LIVE_AFTER_STEPA.sql", "w", encoding="utf-8").write(
    "\n".join(t for _, t in src) + "\n")
con.close()
TXT = {ln: t for ln, t in src}
print(f"[live] {len(src)} lines (STEP A 적용본)")

LED = r"(DM_PLN_MKT_FCST_C|DM_PLN_CFM_MKT_DEMAND_PLAN_C|DM_PLN_MKT_FCST_RESULT_C)"
sites = []
for ln, t in src:
    if t.strip().startswith("--"):
        continue
    m = re.search(rf"FROM\s+SCM_MGR\.{LED}\s+(\w+)", t)
    if m:
        sites.append((ln, m.group(1), m.group(2)))

print(f"\n원장 _C 구동 지점 {len(sites)}곳")
for ln, tbl, al in sites:
    # 이 지점이 속한 서브블록에서 버전 술어 이미 있는지 (앞뒤 40줄)
    win = "\n".join(TXT.get(k, "") for k in range(ln, min(ln + 40, len(src) + 1)))
    pushed = bool(re.search(rf"{al}\.VERSION_NO IN \(SELECT VERSION_NO FROM SCM_MGR\.GT_DM35_VERSION\)", win))
    # 등가성 근거: 같은 블록 안에 GT_DM35_VERSION 내부조인이 VERSION_NO 로 걸려 있는가
    joinv = re.search(r"JOIN SCM_MGR\.GT_DM35_VERSION (\w+)", win)
    oncond = None
    if joinv:
        jl = next(k for k in range(ln, min(ln + 40, len(src) + 1))
                  if "JOIN SCM_MGR.GT_DM35_VERSION" in TXT.get(k, ""))
        oncond = " ".join(TXT.get(jl + i, "").strip() for i in range(1, 3))
    print(f"\n  L{ln:>5} {tbl:<30} 별칭={al}  버전푸시={'O 기적용' if pushed else '⛔ 미적용'}")
    print(f"        원문: {TXT[ln].strip()[:120]}")
    if not pushed:
        print(f"        다음줄: {TXT.get(ln+1,'').strip()[:120]}")
        print(f"        등가근거 JOIN GT_DM35_VERSION={joinv.group(1) if joinv else '없음'}  ON: {(oncond or '')[:150]}")
        # 이 서브블록의 WHERE 절 위치 (RESULT_C 처럼 FROM 라인에 WHERE 가 없는 경우용)
        for k in range(ln, min(ln + 40, len(src) + 1)):
            s = TXT.get(k, "").strip()
            if re.match(r"WHERE\s+\w+\.", s):
                print(f"        WHERE 절 L{k}: {s[:110]}")
                for j in range(k + 1, k + 6):
                    s2 = TXT.get(j, "").strip()
                    if re.match(r"(AND|GROUP BY|UNION|\))", s2, re.I):
                        print(f"           L{j}: {s2[:110]}")
                    if re.match(r"(GROUP BY|UNION|\))", s2, re.I):
                        break
                break
