# -*- coding: utf-8 -*-
"""DMF0040 [E20260827-NLSDATE] CAST(F.CUTOFF_YYYYMMDD AS DATE) → TO_DATE(F.CUTOFF_YYYYMMDD,'YYYYMMDD') (hook #109 명시 마스크)
   클라우드 BE JDBC 세션 ORA-01861 (PKG_DMF0040 line 1471 DBMS_SQL) 정정. 사내 원문 ALL_SOURCE → 정정본 PREVIEW 생성."""
import io, sys, re, pathlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import oracledb; from ora import conn_info
u,p,d = conn_info(); con = oracledb.connect(user=u,password=p,dsn=d); cur = con.cursor()
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0040' AND TYPE='PACKAGE BODY' ORDER BY LINE")
src = "".join(r[0] for r in cur.fetchall())
out = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0040_NLSDATE_20260827")
(out/"BACKUP"/"PKG_DMF0040_BODY_ASIS.sql").write_bytes(("CREATE OR REPLACE "+src+"\n/\n").encode("utf-8"))
old = "CAST(F.CUTOFF_YYYYMMDD AS DATE)"; new = "TO_DATE(F.CUTOFF_YYYYMMDD, ''YYYYMMDD'') /*[E20260827-NLSDATE]*/"
n = src.count(old); assert n == 7, n
fixed = src.replace(old, new)
# 잔존 NLS 의존 스캔 (주석 제거본)
body = re.sub(r"--[^\n]*", "", re.sub(r"/\*.*?\*/", "", fixed, flags=re.S))
rest = [l.strip() for l in body.splitlines() if re.search(r"CAST\s*\([^)]*AS\s+DATE\)|TO_DATE\s*\([^,)]*\)", l, re.I)]
print("치환", n, "/ 잔존 NLS 의존 후보", rest)
(out/"PREVIEW_PKG_DMF0040_BODY.sql").write_bytes(("CREATE OR REPLACE "+fixed+"\n/\n").encode("utf-8"))
print("written", out)
