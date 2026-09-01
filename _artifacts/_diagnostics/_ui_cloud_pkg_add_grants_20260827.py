# -*- coding: utf-8 -*-
"""이관 패키지 보강 — 패키지 A_DB 의 PKG/PROCEDURE/FUNCTION 객체에 대한 사내 실측 GRANT EXECUTE + 앱계정 시노님을 40_GRANT_SYNONYM.sql 로 생성.
   (2026-08-27 DMF0040 클라우드 SQL ERROR 확정 원인: SCMP_APP 에 PKG_DMF0040 EXECUTE/시노님 부재)
   python _ui_cloud_pkg_add_grants_20260827.py DMF0014 DMF0035 DMF0040 DMF0053"""
import io, sys, re, pathlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import oracledb
from ora import conn_info
PKGDIR = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages")
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
def q(sql, **b): cur.execute(sql, b); return cur.fetchall()
APP = ('SCMP_APP', 'SCMD_APP')
for menu in sys.argv[1:]:
    out = PKGDIR / f"{menu}_CLOUD_20260827"; A = out / "A_DB"
    objs = []
    for f in sorted(A.glob("*.sql")):
        m = re.match(r"\d+_(PKG_\w+?)_(SPEC|BODY)\.sql$|\d+_(PROCEDURE|FUNCTION)_(\w+)\.sql$", f.name)
        if not m: continue
        name = m.group(1) or m.group(4)
        if name not in objs: objs.append(name)
    lines = [f"-- 40_GRANT_SYNONYM.sql — {menu} 앱 계정 EXECUTE 권한 + private synonym (사내 실측 재현, 멱등) — 2026-08-27",
             "-- 실행 계정: SCM_MGR (GRANT) + CREATE ANY SYNONYM 권한 보유 계정 (시노님). 클라우드에 SCMD_APP 계정이 없으면 해당 행 오류(ORA-01917)는 무시.",
             "-- 원인 사고: DMF0040 클라우드 — SCM_MGR 직접 호출 정상, SCMP_APP 에 PKG_DMF0040 EXECUTE/시노님 부재 → 화면 SQL ERROR"]
    for o in objs:
        rows = q("SELECT GRANTEE, PRIVILEGE FROM ALL_TAB_PRIVS WHERE TABLE_SCHEMA='SCM_MGR' AND TABLE_NAME=:n AND GRANTEE IN ('SCMP_APP','SCMD_APP') ORDER BY 1", n=o)
        syns = q("SELECT OWNER FROM ALL_SYNONYMS WHERE TABLE_OWNER='SCM_MGR' AND TABLE_NAME=:n AND SYNONYM_NAME=:n AND OWNER IN ('SCMP_APP','SCMD_APP') ORDER BY 1", n=o)
        lines.append(f"\n-- {o}: 사내 EXECUTE={[g for g,_ in rows]} / 시노님={[s for (s,) in syns]}")
        for g, pv in rows:
            if pv == 'EXECUTE': lines.append(f"GRANT EXECUTE ON SCM_MGR.{o} TO {g};")
        for (s,) in syns:
            lines.append(f"CREATE OR REPLACE SYNONYM {s}.{o} FOR SCM_MGR.{o};")
    lines += ["", "-- 검증 (기대: 객체별 SCMP_APP EXECUTE 1행 + SCMP_APP 시노님 1행)",
              f"SELECT GRANTEE, TABLE_NAME, PRIVILEGE FROM ALL_TAB_PRIVS WHERE TABLE_SCHEMA='SCM_MGR' AND TABLE_NAME IN ({','.join(repr(o) for o in objs)}) AND GRANTEE IN ('SCMP_APP','SCMD_APP') ORDER BY 2,1;",
              f"SELECT OWNER, SYNONYM_NAME FROM ALL_SYNONYMS WHERE TABLE_OWNER='SCM_MGR' AND SYNONYM_NAME IN ({','.join(repr(o) for o in objs)}) AND OWNER IN ('SCMP_APP','SCMD_APP') ORDER BY 2,1;"]
    (A / "40_GRANT_SYNONYM.sql").write_bytes(("\n".join(lines) + "\n").encode("utf-8"))
    (out / "README.md").open("a", encoding="utf-8").write(f"\n## 40_GRANT_SYNONYM.sql — 앱 계정 EXECUTE + 시노님 (2026-08-27 보강)\n- 대상 {len(objs)}: {objs}\n- 사고: DMF0040 클라우드 SCMP_APP 에 PKG_DMF0040 EXECUTE 부재 → 화면 SQL ERROR (SCM_MGR 재현은 정상). 10~32 적용 후 **반드시** 실행.\n")
    fl = out / "_FILELIST.md"; fl.write_text("\n".join(sorted(str(f.relative_to(out)).replace("\\", "/") for f in out.rglob("*") if f.is_file())) + "\n", encoding="utf-8")
    print(f"[{menu}] {objs}")
