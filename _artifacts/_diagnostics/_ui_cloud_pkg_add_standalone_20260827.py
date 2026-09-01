# -*- coding: utf-8 -*-
"""이관 패키지 보강 — API_M.API_URL 이 가리키는 **standalone 프로시저**(PKG 밖) 원문 덤프 추가.
   (초판 생성기는 PKG 의존객체만 덤프해 spreadTitle 등 standalone SP 가 빠졌음 — 2026-08-27 DMF0040 클라우드 SQL ERROR 진단 중 발견)
   python _ui_cloud_pkg_add_standalone_20260827.py DMF0014 DMF0035 DMF0040 DMF0053"""
import io, sys, pathlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import oracledb
from ora import conn_info
PKGDIR = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages")
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
def q(sql, **b): cur.execute(sql, b); return cur.fetchall()
for menu in sys.argv[1:]:
    out = PKGDIR / f"{menu}_CLOUD_20260827"; A = out / "A_DB"
    urls = sorted({r[0] for r in q("SELECT DISTINCT API_URL FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE :m AND API_TP_CD LIKE 'PROC%'", m=menu + "%")})
    added = []
    n = 30
    for url in urls:
        if "." in url: continue  # PKG.PROC 는 PKG 덤프에 포함
        rows = q("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE IN ('PROCEDURE','FUNCTION')", n=url)
        if not rows: added.append(f"⚠ {url}: SCM_MGR 에 standalone 객체 없음(시노님/타 스키마?)"); continue
        typ, st, ddl = rows[0]
        src = "".join(r[0] for r in q("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=url, t=typ))
        deps = [f"{r[0]}:{r[1]}" for r in q("SELECT REFERENCED_TYPE, REFERENCED_NAME FROM ALL_DEPENDENCIES WHERE OWNER='SCM_MGR' AND NAME=:n AND REFERENCED_OWNER='SCM_MGR' AND REFERENCED_TYPE IN ('TABLE','VIEW','SYNONYM','FUNCTION','PACKAGE','PROCEDURE','TYPE')", n=url)]
        fn = f"{n}_{typ}_{url}.sql"; n += 1
        (A / fn).write_text(f"-- {fn} — API_M 배선 standalone {typ} ({st}, LAST_DDL {ddl}) — 클라우드 부재/구판이면 적용\n-- 의존: {deps}\nCREATE OR REPLACE " + src + "\n/\n", encoding="utf-8")
        added.append(f"{fn} ({st} {ddl}) 의존 {deps}")
    fl = out / "_FILELIST.md"; fl.write_text("\n".join(sorted(str(f.relative_to(out)).replace("\\", "/") for f in out.rglob("*") if f.is_file())) + "\n", encoding="utf-8")
    (out / "README.md").open("a", encoding="utf-8").write("\n## 30~ standalone SP (API_M 배선, PKG 밖) — 2026-08-27 보강\n" + "\n".join(f"- {a}" for a in added) + "\n")
    print(f"[{menu}]"); [print("   ", a) for a in added]
