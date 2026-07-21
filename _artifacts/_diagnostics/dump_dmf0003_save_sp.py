# -*- coding: utf-8 -*-
"""DMF0003_SAVE_MKT_FCST standalone SP 전문 덤프 (사내 SCM_MGR) — 백업 + p_authority 수정 원본"""
import io, sys, importlib.util

spec = importlib.util.spec_from_file_location("ora", r"C:\Projects\NSCM\_artifacts\_diagnostics\ora.py")
ora = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ora)

import oracledb
u, p, d = ora.conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cur = cn.cursor()
cur.execute("""
    SELECT text FROM all_source
    WHERE name = 'DMF0003_SAVE_MKT_FCST' AND owner = 'SCM_MGR' AND type = 'PROCEDURE'
    ORDER BY line
""")
lines = [r[0] for r in cur.fetchall()]
out = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0003_SAVE_MKT_FCST_BACKUP_pre_authority_20260720.sql"
with io.open(out, "w", encoding="utf-8", newline="\n") as f:
    f.write("CREATE OR REPLACE ")
    f.writelines(lines)
    f.write("\n/\n")
print("lines:", len(lines), "->", out)
